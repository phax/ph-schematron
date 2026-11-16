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
package com.helger.schematron.benchmark;

import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;

import javax.xml.transform.stream.StreamSource;

import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Param;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Warmup;
import org.openjdk.jmh.infra.Blackhole;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.io.nonblocking.NonBlockingByteArrayInputStream;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.saxon.SaxonTinyTreeHelper;
import com.helger.schematron.saxon.SchematronProcessorFactory;
import com.helger.xml.serialize.read.DOMReader;

import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmAtomicValue;

/**
 * Validation of one generated flat document with many items by the two pure engines
 * ({@link SchematronResourcePureXPath} and {@link SchematronResourcePureXslt}). The Schematron uses
 * schema and rule level variables and, for the invalid document, half of the items fail an assert,
 * so that the SVRL location and text of many failed asserts is created. The XPath engine has an
 * external variable configured. Binding and compilation happen once in the setup.
 *
 * @author Philip Helger
 */
@NotThreadSafe
@State (Scope.Benchmark)
@BenchmarkMode (Mode.AverageTime)
@OutputTimeUnit (TimeUnit.MILLISECONDS)
@Warmup (iterations = 3, time = 2)
@Measurement (iterations = 5, time = 3)
@Fork (1)
public class BenchmarkPureEngines
{
  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                                           "  <iso:let name='total' value='count(/root/item)'/>\n" +
                                           "  <iso:pattern id='root'>\n" +
                                           "    <iso:rule context='/root'>\n" +
                                           "      <iso:assert test='$total &gt; 0'>total must be positive</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "  <iso:pattern id='items'>\n" +
                                           "    <iso:rule context='item'>\n" +
                                           "      <iso:let name='v' value='number(value)'/>\n" +
                                           "      <iso:assert test='@id'>item must have an id</iso:assert>\n" +
                                           "      <iso:assert test='$v &gt;= 0'>value of <iso:value-of select='@id'/> must be non-negative</iso:assert>\n" +
                                           "      <iso:assert test='$v &lt;= $total * 10'>value must not exceed <iso:value-of select='$total * 10'/></iso:assert>\n" +
                                           "      <iso:report test='$v = -1'>value minus one in <iso:name/></iso:report>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "</iso:schema>";
  private static final String BASE_URI = "urn:benchmark";

  @Param ({ "5000" })
  public int itemCount;

  private SchematronResourcePureXPath m_aPureXPath;
  private SchematronResourcePureXslt m_aPureXslt;
  private Document m_aValidDom;
  private Document m_aInvalidDom;
  private Document m_aInvalidFacade;

  private byte [] _createXml (final boolean bValid)
  {
    final StringBuilder aSB = new StringBuilder (64 + itemCount * 64);
    aSB.append ("<?xml version='1.0' encoding='UTF-8'?>\n<root>\n");
    for (int i = 0; i < itemCount; i++)
    {
      // In the invalid document every second item has a negative value
      final int nValue = bValid || (i % 2) == 0 ? i : -i;
      aSB.append ("  <item id='item-").append (i).append ("'><value>").append (nValue).append ("</value></item>\n");
    }
    aSB.append ("</root>\n");
    return aSB.toString ().getBytes (StandardCharsets.UTF_8);
  }

  @Setup
  public void setup () throws Exception
  {
    m_aPureXPath = SchematronResourcePureXPath.builderFromString (SCHEMATRON)
                                              .xpathConfig (new XPathConfigBuilder ().addExternalVariable (new QName ("unused"),
                                                                                                           new XdmAtomicValue ("x"))
                                                                                     .build ())
                                              .build ();
    m_aPureXPath.getOrCreateBoundSchema ();
    m_aPureXslt = SchematronResourcePureXslt.builderFromString (SCHEMATRON).build ();

    m_aValidDom = DOMReader.readXMLDOM (_createXml (true));
    final byte [] aInvalid = _createXml (false);
    m_aInvalidDom = DOMReader.readXMLDOM (aInvalid);
    m_aInvalidFacade = SaxonTinyTreeHelper.buildDocumentFacade (SchematronProcessorFactory.getDefault (),
                                                                new StreamSource (new NonBlockingByteArrayInputStream (aInvalid),
                                                                                  BASE_URI));

    // Compile the XSLT once before timing starts
    m_aPureXslt.applySchematronValidationToSVRL (m_aValidDom, BASE_URI);
  }

  @Benchmark
  public void pureXPathSvrlDom (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXPath.applySchematronValidationToSVRL (m_aInvalidDom, BASE_URI));
  }

  @Benchmark
  public void pureXPathSvrlTinyTree (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXPath.applySchematronValidationToSVRL (m_aInvalidFacade, BASE_URI));
  }

  @Benchmark
  public void pureXPathValidityDom (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXPath.getSchematronValidity (m_aValidDom, BASE_URI));
  }

  @Benchmark
  public void pureXsltSvrlDom (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXslt.applySchematronValidationToSVRL (m_aInvalidDom, BASE_URI));
  }

  @Benchmark
  public void pureXsltSvrlTinyTree (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXslt.applySchematronValidationToSVRL (m_aInvalidFacade, BASE_URI));
  }

  @Benchmark
  public void pureXsltValidityDom (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXslt.getSchematronValidity (m_aValidDom, BASE_URI));
  }
}
