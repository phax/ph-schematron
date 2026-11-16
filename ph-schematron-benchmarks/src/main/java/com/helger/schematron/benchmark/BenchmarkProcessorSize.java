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
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * Warm validation (compiled once) with the ISO Schematron pipeline on Saxon and on phoxtrot, by
 * document size. The input is provided as stream (parsed internally and converted into the tree
 * of the XSLT processor) and as a W3C DOM document of the caller, to show the cost of the input
 * conversion separately.
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
public class BenchmarkProcessorSize
{
  /** Like BenchmarkDomVsTinyTree */
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

  /** The XSLT processor */
  @Param ({ "saxon", "phoxtrot" })
  public String xsltProcessor;

  @Param ({ "1000", "5000", "20000" })
  public int itemCount;

  private byte [] m_aXmlBytes;
  private Document m_aXmlDom;
  private SchematronResourceSCH m_aSchema;

  @Setup
  public void setup () throws Exception
  {
    final StringBuilder aSB = new StringBuilder (64 + itemCount * 64);
    aSB.append ("<?xml version='1.0' encoding='UTF-8'?>\n<root>\n");
    for (int i = 0; i < itemCount; i++)
      aSB.append ("  <item id='item-").append (i).append ("'><value>").append (i).append ("</value></item>\n");
    aSB.append ("</root>\n");
    m_aXmlBytes = aSB.toString ().getBytes (StandardCharsets.UTF_8);
    m_aXmlDom = DOMReader.readXMLDOM (m_aXmlBytes);

    m_aSchema = SchematronResourceSCH.builderFromString (SCHEMATRON)
                                     .errorListener (new DoNothingTransformErrorListener ())
                                     .xsltProcessor (SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (xsltProcessor))
                                     .build ();
    // Compile before the measurement
    if (!m_aSchema.isValidSchematron ())
      throw new IllegalStateException ("Invalid Schematron");
  }

  @Benchmark
  public void validateStream (final Blackhole bh) throws Exception
  {
    bh.consume (m_aSchema.applySchematronValidationToSVRL (new ReadableResourceByteArray ("in-memory.xml",
                                                                                          m_aXmlBytes,
                                                                                          false)));
  }

  @Benchmark
  public void validateDom (final Blackhole bh) throws Exception
  {
    bh.consume (m_aSchema.applySchematronValidationToSVRL (m_aXmlDom, null));
  }
}
