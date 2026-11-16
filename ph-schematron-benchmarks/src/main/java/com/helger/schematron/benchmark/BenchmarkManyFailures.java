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
package com.helger.schematron.benchmark;

import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;

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
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * Warm validation (compiled once) of a document with many failures on many same named siblings,
 * with the XSLT engines on Saxon and on phoxtrot. Every second of <code>itemCount</code> sibling
 * elements fails, so the SVRL <code>location</code> of <code>itemCount / 2</code> elements is
 * created; an implementation that counts the preceding siblings for every location is quadratic.
 * The pure engines are measured the same way by {@link BenchmarkPureEngines}.
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
public class BenchmarkManyFailures
{
  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                                           "  <iso:pattern>\n" +
                                           "    <iso:rule context='item'>\n" +
                                           "      <iso:assert test='number(value) &gt;= 0'>value must be non-negative</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "</iso:schema>";

  /** The XSLT processor */
  @Param ({ "saxon", "phoxtrot" })
  public String xsltProcessor;

  @Param ({ "1000", "5000" })
  public int itemCount;

  private Document m_aXmlDom;
  private SchematronResourceSCH m_aSCH;
  private SchematronResourceSchXslt_XSLT2 m_aSchXslt;
  private SchematronResourceSchXslt2 m_aSchXslt2;

  @Setup
  public void setup () throws Exception
  {
    final StringBuilder aSB = new StringBuilder (64 + itemCount * 64);
    aSB.append ("<?xml version='1.0' encoding='UTF-8'?>\n<root>\n");
    for (int i = 0; i < itemCount; i++)
    {
      // Every second item has a negative value
      final int nValue = (i % 2) == 0 ? i : -i;
      aSB.append ("  <item id='item-").append (i).append ("'><value>").append (nValue).append ("</value></item>\n");
    }
    aSB.append ("</root>\n");
    m_aXmlDom = DOMReader.readXMLDOM (aSB.toString ().getBytes (StandardCharsets.UTF_8));

    final ISchematronXsltProcessor aProcessor = SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (xsltProcessor);
    m_aSCH = SchematronResourceSCH.builderFromString (SCHEMATRON)
                                  .errorListener (new DoNothingTransformErrorListener ())
                                  .xsltProcessor (aProcessor)
                                  .build ();
    m_aSchXslt = SchematronResourceSchXslt_XSLT2.builderFromString (SCHEMATRON)
                                                .errorListener (new DoNothingTransformErrorListener ())
                                                .xsltProcessor (aProcessor)
                                                .build ();
    m_aSchXslt2 = SchematronResourceSchXslt2.builderFromString (SCHEMATRON)
                                            .errorListener (new DoNothingTransformErrorListener ())
                                            .xsltProcessor (aProcessor)
                                            .build ();
    // Compile before the measurement
    if (!m_aSCH.isValidSchematron () || !m_aSchXslt.isValidSchematron () || !m_aSchXslt2.isValidSchematron ())
      throw new IllegalStateException ("Invalid Schematron");
  }

  @Benchmark
  public void sch (final Blackhole bh) throws Exception
  {
    bh.consume (m_aSCH.applySchematronValidationToSVRL (m_aXmlDom, null));
  }

  @Benchmark
  public void schXslt (final Blackhole bh) throws Exception
  {
    bh.consume (m_aSchXslt.applySchematronValidationToSVRL (m_aXmlDom, null));
  }

  @Benchmark
  public void schXslt2 (final Blackhole bh) throws Exception
  {
    bh.consume (m_aSchXslt2.applySchematronValidationToSVRL (m_aXmlDom, null));
  }
}
