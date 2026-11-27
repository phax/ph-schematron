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

import javax.xml.transform.Source;

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
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.enginefactory.SchematronXsltCreator;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.phoxtrot.PhoxtrotXsltProcessor;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;
import com.helger.schematron.purexslt.xslt.PureXsltStylesheetGenerator;
import com.helger.schematron.saxon.SaxonXsltProcessor;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * The pure XSLT engine on Saxon and on phoxtrot, against the same generated XSLT run as a pre-built
 * XSLT (<code>SchematronResourceXSLT</code>), see "<code>pure-xslt</code> on phoxtrot (D12
 * reopened)" in <code>docs/PLAN-phoxtrot-engine.md</code>. On Saxon the XSLT uses the native
 * location functions; on phoxtrot it uses <code>fn:path</code>, because phoxtrot does not have all
 * of them. The <code>jaxp*</code> variants without and with SVRL schema validation and with the DOM
 * converted into the tree of the processor show where the time of the JAXP path goes.
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
public class BenchmarkPureXsltJaxp
{
  private static final String FLAT_SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
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

  /**
   * <code>flat-N</code>: a generated flat document with N items, half of them failing an assert;
   * <code>en16931</code>: the EN 16931 UBL rules on the TC 434 example 1 invoice.
   */
  @Param ({ "flat-1000", "flat-5000", "en16931" })
  public String scenario;

  private Document m_aXmlDom;
  private SchematronResourcePureXslt m_aPureXsltSaxon;
  private SchematronResourcePureXslt m_aPureXsltPhoxtrot;
  private SchematronResourceXSLT m_aJaxpSaxon;
  private SchematronResourceXSLT m_aJaxpPhoxtrot;
  private SchematronResourceXSLT m_aJaxpSaxonNoSchema;
  private SchematronResourceXSLT m_aJaxpPhoxtrotNoSchema;

  private static byte [] _createFlatXml (final int nItemCount)
  {
    final StringBuilder aSB = new StringBuilder (64 + nItemCount * 64);
    aSB.append ("<?xml version='1.0' encoding='UTF-8'?>\n<root>\n");
    for (int i = 0; i < nItemCount; i++)
    {
      // Every second item has a negative value
      final int nValue = (i % 2) == 0 ? i : -i;
      aSB.append ("  <item id='item-").append (i).append ("'><value>").append (nValue).append ("</value></item>\n");
    }
    aSB.append ("</root>\n");
    return aSB.toString ().getBytes (StandardCharsets.UTF_8);
  }

  private static SchematronResourceXSLT _createJaxp (final PSSchema aSchema,
                                                     final boolean bNativeLocation,
                                                     final String sXsltProcessorID,
                                                     final boolean bValidateSVRL) throws Exception
  {
    final Document aXslt = PureXsltStylesheetGenerator.generate (aSchema, null, EPureXsltVersion.DEFAULT, bNativeLocation);
    final SchematronResourceXSLT ret = SchematronResourceXSLT.builderFromString (SchematronXsltCreator.getXsltDocumentAsString (aXslt, null))
                                                             .errorListener (new DoNothingTransformErrorListener ())
                                                             .xsltProcessor (SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (sXsltProcessorID))
                                                             .validateSVRL (bValidateSVRL)
                                                             .build ();
    if (!ret.isValidSchematron ())
      throw new IllegalStateException ("Invalid XSLT for " + sXsltProcessorID);
    return ret;
  }

  @Setup
  public void setup () throws Exception
  {
    final IReadableResource aSchRes;
    if (scenario.startsWith ("flat-"))
    {
      aSchRes = new ReadableResourceByteArray ("flat.sch", FLAT_SCHEMATRON.getBytes (StandardCharsets.UTF_8), false);
      m_aXmlDom = DOMReader.readXMLDOM (_createFlatXml (Integer.parseInt (scenario.substring (5))));
    }
    else
    {
      aSchRes = new ClassPathResource ("external/en16931/EN16931-UBL-validation-preprocessed.sch");
      m_aXmlDom = DOMReader.readXMLDOM (new ClassPathResource ("external/en16931/ubl-tc434-example1.xml"));
    }

    m_aPureXsltSaxon = SchematronResourcePureXslt.builder (aSchRes)
                                                 .xsltProcessor (SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (SaxonXsltProcessor.ID))
                                                 .build ();
    m_aPureXsltPhoxtrot = SchematronResourcePureXslt.builder (aSchRes)
                                                    .xsltProcessor (SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (PhoxtrotXsltProcessor.ID))
                                                    .build ();
    final PSSchema aSchema = m_aPureXsltSaxon.getOrReadSchema ();
    m_aJaxpSaxon = _createJaxp (aSchema, true, SaxonXsltProcessor.ID, true);
    m_aJaxpPhoxtrot = _createJaxp (aSchema, false, PhoxtrotXsltProcessor.ID, true);
    m_aJaxpSaxonNoSchema = _createJaxp (aSchema, true, SaxonXsltProcessor.ID, false);
    m_aJaxpPhoxtrotNoSchema = _createJaxp (aSchema, false, PhoxtrotXsltProcessor.ID, false);

    // Compile before the measurement
    if (!m_aPureXsltSaxon.isValidSchematron () || !m_aPureXsltPhoxtrot.isValidSchematron ())
      throw new IllegalStateException ("Invalid Schematron");
  }

  @Benchmark
  public void pureXsltSaxonSvrl (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXsltSaxon.applySchematronValidationToSVRL (m_aXmlDom, BASE_URI));
  }

  @Benchmark
  public void pureXsltPhoxtrotSvrl (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXsltPhoxtrot.applySchematronValidationToSVRL (m_aXmlDom, BASE_URI));
  }

  @Benchmark
  public void jaxpSaxonSvrl (final Blackhole bh) throws Exception
  {
    bh.consume (m_aJaxpSaxon.applySchematronValidationToSVRL (m_aXmlDom, BASE_URI));
  }

  @Benchmark
  public void jaxpPhoxtrotSvrl (final Blackhole bh) throws Exception
  {
    bh.consume (m_aJaxpPhoxtrot.applySchematronValidationToSVRL (m_aXmlDom, BASE_URI));
  }

  /**
   * Without validating the SVRL against its XML Schema, as the pure XSLT engine does.
   */
  @Benchmark
  public void jaxpSaxonSvrlNoSchema (final Blackhole bh) throws Exception
  {
    bh.consume (m_aJaxpSaxonNoSchema.applySchematronValidationToSVRL (m_aXmlDom, BASE_URI));
  }

  /**
   * Without SVRL schema validation, and with the DOM converted into the tree of the processor once,
   * as the pure XSLT engine does.
   */
  @Benchmark
  public void jaxpSaxonSvrlTuned (final Blackhole bh) throws Exception
  {
    final Source aSource = m_aJaxpSaxonNoSchema.getXSLTProvider ()
                                               .getXsltProcessor ()
                                               .createSourceForInternalDocument (m_aXmlDom, BASE_URI);
    bh.consume (m_aJaxpSaxonNoSchema.applySchematronValidationToSVRL (aSource));
  }

  /**
   * Like {@link #jaxpSaxonSvrlTuned(Blackhole)} on phoxtrot.
   */
  @Benchmark
  public void jaxpPhoxtrotSvrlTuned (final Blackhole bh) throws Exception
  {
    final Source aSource = m_aJaxpPhoxtrotNoSchema.getXSLTProvider ()
                                                  .getXsltProcessor ()
                                                  .createSourceForInternalDocument (m_aXmlDom, BASE_URI);
    bh.consume (m_aJaxpPhoxtrotNoSchema.applySchematronValidationToSVRL (aSource));
  }

  @Benchmark
  public void pureXsltSaxonValidity (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXsltSaxon.getSchematronValidity (m_aXmlDom, BASE_URI));
  }

  @Benchmark
  public void pureXsltPhoxtrotValidity (final Blackhole bh) throws Exception
  {
    bh.consume (m_aPureXsltPhoxtrot.getSchematronValidity (m_aXmlDom, BASE_URI));
  }

  @Benchmark
  public void jaxpSaxonValidity (final Blackhole bh) throws Exception
  {
    bh.consume (m_aJaxpSaxon.getSchematronValidity (m_aXmlDom, BASE_URI));
  }
}
