/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.OutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.sun.net.httpserver.HttpServer;

/**
 * Test the effects of the secure processing defaults that ph-commons applies to the Saxon
 * {@link javax.xml.transform.TransformerFactory} of all XSLT based engines - see
 * {@link com.helger.schematron.saxon.SchematronTransformerFactory}.
 *
 * @author Philip Helger
 */
public final class SchematronSecureProcessingTest
{
  private static final String BASE = "src/test/resources/external/secureprocessing/";

  @NonNull
  private static IReadableResource _res (final String sFilename)
  {
    return new FileSystemResource (BASE + sFilename);
  }

  @Test
  public void testRemoteDocumentIsBlocked () throws Exception
  {
    // "document()" on a remote URL must not open a connection - it resolves to an empty
    // document instead, so the assertion fails
    final SchematronResourceSCH aSCH = SchematronResourceSCH.builder (_res ("remote-document.sch"))
                                                            .useCache (false)
                                                            .build ();
    assertTrue (aSCH.isValidSchematron ());

    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (_res ("test.xml"));
    assertNotNull (aSVRL);
    assertEquals (1, SVRLHelper.getAllFailedAssertions (aSVRL).size ());
  }

  @Test
  public void testNoNamespaceSystemPropertyIsEmpty () throws Exception
  {
    // Saxon only exposes JVM system properties to "system-property()" if external functions
    // are allowed - with secure processing enabled the result is the empty string
    final SchematronResourceSCH aSCH = SchematronResourceSCH.builder (_res ("system-property.sch"))
                                                            .useCache (false)
                                                            .build ();
    assertTrue (aSCH.isValidSchematron ());

    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (_res ("test.xml"));
    assertNotNull (aSVRL);
    assertEquals (1, SVRLHelper.getAllFailedAssertions (aSVRL).size ());
  }

  @Test
  public void testRemoteXSLTIncludeIsBlocked ()
  {
    // "xsl:include" of a remote URL is resolved to an empty document, so the stylesheet
    // cannot be compiled
    final SchematronResourceXSLT aXSLT = SchematronResourceXSLT.builder (_res ("remote-include.xslt"))
                                                               .useCache (false)
                                                               .build ();
    assertFalse (aXSLT.isValidSchematron ());
  }

  @Test
  public void testResultDocumentIsRejected ()
  {
    // Saxon disables the secondary output destinations of "xsl:result-document" if external
    // functions are disallowed
    final SchematronResourceXSLT aXSLT = SchematronResourceXSLT.builder (_res ("result-document.xslt"))
                                                               .useCache (false)
                                                               .build ();
    assertFalse (aXSLT.isValidSchematron ());
  }

  @Test
  public void testLocalXSLTIncludeStillWorks () throws Exception
  {
    // Only remote URL schemes are blocked - a local "xsl:include" is resolved as before
    final SchematronResourceXSLT aXSLT = SchematronResourceXSLT.builder (_res ("local-include.xslt"))
                                                               .useCache (false)
                                                               .validateSVRL (false)
                                                               .build ();
    assertTrue (aXSLT.isValidSchematron ());

    final SchematronOutputType aSVRL = aXSLT.applySchematronValidationToSVRL (_res ("test.xml"));
    assertNotNull (aSVRL);
  }

  @Test
  public void testRemoteXSLTIncludeCanBeAllowedExplicitly () throws Exception
  {
    // A caller supplied URI resolver that permits "http" must win - it is used as-is and is not
    // wrapped in another (stricter) DefaultTransformURIResolver
    final byte [] aIncluded = ("<?xml version='1.0' encoding='UTF-8'?>" +
                               "<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'" +
                               " xmlns:xs='http://www.w3.org/2001/XMLSchema' xmlns:u='urn:test:utils' version='2.0'>" +
                               "<xsl:function name='u:constant' as='xs:string'><xsl:value-of select=\"'included'\" />" +
                               "</xsl:function></xsl:stylesheet>").getBytes (StandardCharsets.UTF_8);

    // Port 0 == any free port; bound to the loopback interface only
    final HttpServer aServer = HttpServer.create (new InetSocketAddress (InetAddress.getLoopbackAddress (), 0), 0);
    aServer.createContext ("/", aExchange -> {
      aExchange.getResponseHeaders ().add ("Content-Type", "application/xml");
      aExchange.sendResponseHeaders (200, aIncluded.length);
      try (final OutputStream aOS = aExchange.getResponseBody ())
      {
        aOS.write (aIncluded);
      }
    });
    aServer.start ();
    try
    {
      final String sURL = "http://" +
                          InetAddress.getLoopbackAddress ().getHostAddress () +
                          ":" +
                          aServer.getAddress ().getPort () +
                          "/included.xslt";
      final String sXSLT = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'" +
                           " xmlns:svrl='http://purl.oclc.org/dsdl/svrl' xmlns:u='urn:test:utils' version='2.0'>\n" +
                           "  <xsl:include href='" + sURL + "' />\n" +
                           "  <xsl:template match='/'><svrl:schematron-output>" +
                           "<xsl:attribute name='title'><xsl:value-of select='u:constant()' /></xsl:attribute>" +
                           "</svrl:schematron-output></xsl:template>\n" +
                           "</xsl:stylesheet>";

      final SchematronResourceXSLT aXSLT = SchematronResourceXSLT.builder (ReadableResourceString.utf8 (sXSLT))
                                                                 .useCache (false)
                                                                 .validateSVRL (false)
                                                                 .uriResolver (new DefaultTransformURIResolver ().setAllowedRemoteSchemes ("http"))
                                                                 .build ();
      assertTrue (aXSLT.isValidSchematron ());
    }
    finally
    {
      aServer.stop (0);
    }
  }
}
