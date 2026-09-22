/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
 * philip[at]helger[dot]com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.helger.schematron.it;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.atomic.AtomicInteger;

import org.jspecify.annotations.NonNull;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.serialize.read.DOMReader;
import com.sun.net.httpserver.HttpServer;

/**
 * Verifies that <em>no</em> Schematron engine dereferences a remote URL, no matter which of the URI
 * consuming XPath functions is used. A local HTTP server counts the incoming requests, so the test
 * proves the absence of the outbound request itself and not merely that the validation failed.
 * <p>
 * How a blocked access surfaces differs per engine - a failed assertion, a fatal XPath error or a
 * schema that cannot be bound at all - so only the request count is asserted here.
 * </p>
 *
 * @author Philip Helger
 */
public final class SchematronRemoteAccessTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronRemoteAccessTest.class);

  // Non-empty, so that a successful fetch makes the assertions below pass
  private static final byte [] RESPONSE = "<remote><item /></remote>".getBytes (StandardCharsets.UTF_8);
  private static final String XML = "<?xml version='1.0' encoding='UTF-8'?><root><item /></root>";

  private final AtomicInteger m_aRequestCount = new AtomicInteger ();
  private HttpServer m_aServer;
  private String m_sRemoteURL;

  @Before
  public void startServer () throws IOException
  {
    // Port 0 == any free port; bound to the loopback interface only
    m_aServer = HttpServer.create (new InetSocketAddress (InetAddress.getLoopbackAddress (), 0), 0);
    m_aServer.createContext ("/", aExchange -> {
      m_aRequestCount.incrementAndGet ();
      aExchange.sendResponseHeaders (200, RESPONSE.length);
      try (final OutputStream aOS = aExchange.getResponseBody ())
      {
        aOS.write (RESPONSE);
      }
    });
    m_aServer.start ();
    m_sRemoteURL = "http://" +
                   InetAddress.getLoopbackAddress ().getHostAddress () +
                   ":" +
                   m_aServer.getAddress ().getPort () +
                   "/blocked";
    LOGGER.info ("Started local HTTP server on " + m_sRemoteURL);
  }

  @After
  public void stopServer ()
  {
    if (m_aServer != null)
      m_aServer.stop (0);
  }

  @FunctionalInterface
  private interface IEngineBuilder
  {
    @NonNull
    ISchematronResource build (@NonNull IReadableResource aResource);
  }

  @NonNull
  private static ICommonsList <IEngineBuilder> _engines ()
  {
    final ICommonsList <IEngineBuilder> ret = new CommonsArrayList <> ();
    ret.add (r -> SchematronResourcePureXPath.builder (r).useCache (false).build ());
    ret.add (r -> SchematronResourcePureXslt.builder (r).useCache (false).build ());
    ret.add (r -> SchematronResourceSCH.builder (r).useCache (false).build ());
    ret.add (r -> SchematronResourceSchXslt_XSLT2.builder (r).useCache (false).build ());
    ret.add (r -> SchematronResourceSchXslt2.builder (r).useCache (false).build ());
    return ret;
  }

  /**
   * @param sTest
   *        The XPath expression of the single assertion. May not be <code>null</code>.
   * @return A Schematron with exactly one rule containing exactly one assertion.
   */
  @NonNull
  private static String _buildSCH (@NonNull final String sTest)
  {
    // The XPath contains single quotes, so the attribute must be delimited with double quotes
    return "<?xml version='1.0' encoding='UTF-8'?>\n" +
           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
           "  <iso:pattern>\n" +
           "    <iso:rule context='/root'>\n" +
           "      <iso:assert test=\"" +
           sTest +
           "\">the resource was not resolved</iso:assert>\n" +
           "    </iso:rule>\n" +
           "  </iso:pattern>\n" +
           "</iso:schema>";
  }

  /**
   * Validate the provided XML instance with every engine, using a Schematron that contains the
   * provided XPath test, and check that not a single HTTP request reached the local server.
   *
   * @param sTest
   *        The XPath expression of the single assertion. May not be <code>null</code>.
   */
  private void _assertNoRemoteAccess (@NonNull final String sTest) throws Exception
  {
    final String sSCH = _buildSCH (sTest);
    final Node aXML = DOMReader.readXMLDOM (XML);
    assertNotNull (aXML);

    for (final IEngineBuilder aEngineBuilder : _engines ())
    {
      final ISchematronResource aRes = aEngineBuilder.build (ReadableResourceString.utf8 (sSCH));
      try
      {
        // No base URI
        aRes.applySchematronValidationToSVRL (aXML, null);
      }
      catch (final Exception ex)
      {
        // A blocked resource may also surface as a fatal error - that is fine here
        LOGGER.info (aRes.getClass ().getSimpleName () + " failed as expected: " + ex.getMessage ());
      }
      assertEquals ("Engine " + aRes.getClass ().getName () + " performed a remote request", 0, m_aRequestCount.get ());
    }
  }

  @Test
  public void testDocumentFunctionMakesNoRemoteRequest () throws Exception
  {
    _assertNoRemoteAccess ("count(document('" + m_sRemoteURL + ".xml')//*) &gt; 0");
  }

  @Test
  public void testDocFunctionMakesNoRemoteRequest () throws Exception
  {
    _assertNoRemoteAccess ("count(doc('" + m_sRemoteURL + ".xml')//*) &gt; 0");
  }

  @Test
  public void testUnparsedTextMakesNoRemoteRequest () throws Exception
  {
    _assertNoRemoteAccess ("string-length(unparsed-text('" + m_sRemoteURL + ".txt')) &gt; 0");
  }

  @Test
  public void testLocalAccessIsNotBlocked () throws Exception
  {
    // Only the remote URL schemes are blocked - a local resource must still be resolved by every
    // engine, otherwise the security defaults would break the legitimate use cases
    final Path aLocalFile = Files.createTempFile ("ph-schematron-local", ".xml");
    try
    {
      Files.write (aLocalFile, RESPONSE);
      final String sSCH = _buildSCH ("count(doc('" + aLocalFile.toUri ().toASCIIString () + "')//*) &gt; 0");
      final Node aXML = DOMReader.readXMLDOM (XML);
      assertNotNull (aXML);

      for (final IEngineBuilder aEngineBuilder : _engines ())
      {
        final ISchematronResource aRes = aEngineBuilder.build (ReadableResourceString.utf8 (sSCH));
        final SchematronOutputType aSVRL = aRes.applySchematronValidationToSVRL (aXML, null);
        assertNotNull ("Engine " + aRes.getClass ().getName () + " produced no SVRL", aSVRL);
        assertEquals ("Engine " + aRes.getClass ().getName () + " could not resolve the local document",
                      0,
                      SVRLHelper.getAllFailedAssertions (aSVRL).size ());
      }
    }
    finally
    {
      Files.deleteIfExists (aLocalFile);
    }
  }
}
