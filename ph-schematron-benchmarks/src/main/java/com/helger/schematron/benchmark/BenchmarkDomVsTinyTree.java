/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
import org.w3c.dom.Node;

import com.helger.base.io.nonblocking.NonBlockingByteArrayInputStream;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.xml.serialize.read.DOMReader;

import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.XdmNode;

/**
 * Compares the two XML-to-Saxon bridges used by {@link SchematronResourcePureXPath} for an
 * XPath-only Schematron: the standard {@code org.w3c.dom} tree built by {@link DOMReader} versus
 * the Saxon TinyTree exposed as a DOM facade via {@link NodeOverNodeInfo}. The TinyTree path is
 * what {@code getAsNode(IHasInputStream)} uses internally when no custom entity resolver is
 * configured.
 *
 * @author Philip Helger
 */
@State (Scope.Benchmark)
@BenchmarkMode (Mode.AverageTime)
@OutputTimeUnit (TimeUnit.MILLISECONDS)
@Warmup (iterations = 3, time = 2)
@Measurement (iterations = 5, time = 3)
@Fork (1)
public class BenchmarkDomVsTinyTree
{
  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                           "  <iso:let name='total' value='count(/root/item)'/>\n" +
                                           "  <iso:pattern>\n" +
                                           "    <iso:rule context='/root'>\n" +
                                           "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                           "      <iso:assert test='$total &gt; 0'>total must be positive</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "    <iso:rule context='/root/item'>\n" +
                                           "      <iso:assert test='@id'>item must have an id</iso:assert>\n" +
                                           "      <iso:assert test='string-length(@id) &gt; 0'>id must be non-empty</iso:assert>\n" +
                                           "      <iso:assert test='value'>item must have a value child</iso:assert>\n" +
                                           "      <iso:assert test='number(value) &gt;= 0'>value must be a non-negative number</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "</iso:schema>";

  @Param ({ "5000", "20000" })
  public int itemCount;

  private byte [] m_aXmlBytes;
  private SchematronResourcePureXPath m_aSchemaPure;
  private DocumentBuilder m_aSaxonDomBuilder;
  private Document m_aPreparsedDom;
  private Node m_aPreparsedFacade;

  @Setup
  public void setup () throws Exception
  {
    final StringBuilder aSB = new StringBuilder (64 + itemCount * 64);
    aSB.append ("<?xml version='1.0' encoding='UTF-8'?>\n<root>\n");
    for (int i = 0; i < itemCount; i++)
      aSB.append ("  <item id='item-").append (i).append ("'><value>").append (i).append ("</value></item>\n");
    aSB.append ("</root>\n");
    m_aXmlBytes = aSB.toString ().getBytes (StandardCharsets.UTF_8);

    m_aSchemaPure = SchematronResourcePureXPath.builderFromString (SCHEMATRON).build ();
    m_aSchemaPure.getOrCreateBoundSchema ();
    m_aSaxonDomBuilder = XPathConfigBuilder.DEFAULT_PROCESSOR.newDocumentBuilder ();

    m_aPreparsedDom = DOMReader.readXMLDOM (m_aXmlBytes);
    final XdmNode aXdm = m_aSaxonDomBuilder.build (new StreamSource (new NonBlockingByteArrayInputStream (m_aXmlBytes)));
    m_aPreparsedFacade = NodeOverNodeInfo.wrap (aXdm.getUnderlyingNode ());
  }

  // ---- parse only ----

  @Benchmark
  public void parseDom (final Blackhole bh) throws Exception
  {
    bh.consume (DOMReader.readXMLDOM (m_aXmlBytes));
  }

  @Benchmark
  public void parseTinyTree (final Blackhole bh) throws Exception
  {
    bh.consume (m_aSaxonDomBuilder.build (new StreamSource (new NonBlockingByteArrayInputStream (m_aXmlBytes))));
  }

  // ---- validate only (pre-parsed) ----

  @Benchmark
  public void validateDom (final Blackhole bh) throws Exception
  {
    bh.consume (m_aSchemaPure.applySchematronValidationToSVRL (m_aPreparsedDom, null));
  }

  @Benchmark
  public void validateTinyTree (final Blackhole bh) throws Exception
  {
    bh.consume (m_aSchemaPure.applySchematronValidationToSVRL (m_aPreparsedFacade, null));
  }

  // ---- end-to-end ----

  @Benchmark
  public void totalDom (final Blackhole bh) throws Exception
  {
    final Document aDoc = DOMReader.readXMLDOM (m_aXmlBytes);
    bh.consume (m_aSchemaPure.applySchematronValidationToSVRL (aDoc, null));
  }

  @Benchmark
  public void totalTinyTree (final Blackhole bh) throws Exception
  {
    final XdmNode aXdm = m_aSaxonDomBuilder.build (new StreamSource (new NonBlockingByteArrayInputStream (m_aXmlBytes)));
    final Node aFacade = NodeOverNodeInfo.wrap (aXdm.getUnderlyingNode ());
    bh.consume (m_aSchemaPure.applySchematronValidationToSVRL (aFacade, null));
  }
}
