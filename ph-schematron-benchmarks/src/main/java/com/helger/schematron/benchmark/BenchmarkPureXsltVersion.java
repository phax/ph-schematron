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

import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.Level;
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Warmup;
import org.openjdk.jmh.infra.Blackhole;

import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;

/**
 * Compares the three XSLT language versions that {@link SchematronResourcePureXslt} can emit on the
 * generated {@code xsl:stylesheet/@version} attribute: {@link EPureXsltVersion#XSLT_1_0},
 * {@link EPureXsltVersion#XSLT_2_0} and {@link EPureXsltVersion#XSLT_3_0}. Lower versions require
 * conformant fallbacks for the SVRL {@code location} computation (a recursive {@code phsch-path}
 * mode for 1.0, an {@code xsl:function} for 2.0) instead of the 3.0 {@code fn:path()}, so the cost
 * of that scaffolding is what this benchmark isolates. The same XPath-1.0-compatible schema is used
 * for all three versions so the difference reflects the generated scaffolding, not the schema's own
 * expressions.
 * <p>
 * Two cost profiles per version:
 * <ul>
 * <li><b>{@code cold*}</b> - fresh resource per invocation. Includes the stylesheet generation plus
 * Saxon compile cost.</li>
 * <li><b>{@code warm*}</b> - one resource shared across invocations, only the per-document
 * validation cost is measured.</li>
 * </ul>
 *
 * @author Philip Helger
 */
@State (Scope.Benchmark)
@BenchmarkMode (Mode.AverageTime)
@OutputTimeUnit (TimeUnit.MICROSECONDS)
@Warmup (iterations = 3, time = 2)
@Measurement (iterations = 5, time = 3)
@Fork (1)
public class BenchmarkPureXsltVersion
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

  private static final String XMLINSTANCE = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                            "<root>\n" +
                                            "  <item id='a'><value>1</value></item>\n" +
                                            "  <item id='b'><value>2</value></item>\n" +
                                            "  <item id='c'><value>3</value></item>\n" +
                                            "</root>";

  // XML instance as a readable resource, shared by all variants
  private ReadableResourceByteArray m_aXml;

  // Long-lived, pre-compiled resources used by the warm variants
  private SchematronResourcePureXslt m_aWarm10;
  private SchematronResourcePureXslt m_aWarm20;
  private SchematronResourcePureXslt m_aWarm30;

  private static SchematronResourcePureXslt _build (final EPureXsltVersion eVersion)
  {
    return SchematronResourcePureXslt.builderFromString (SCHEMATRON)
                                     .xsltVersion (eVersion)
                                     .errorHandler (new DoNothingPSErrorHandler ())
                                     .build ();
  }

  @Setup (Level.Trial)
  public void setup () throws Exception
  {
    m_aXml = new ReadableResourceByteArray (XMLINSTANCE.getBytes (StandardCharsets.UTF_8));

    m_aWarm10 = _build (EPureXsltVersion.XSLT_1_0);
    m_aWarm20 = _build (EPureXsltVersion.XSLT_2_0);
    m_aWarm30 = _build (EPureXsltVersion.XSLT_3_0);
    // Force one validation to materialize the cached XSLT before the timed loop starts
    m_aWarm10.getSchematronValidity (m_aXml);
    m_aWarm20.getSchematronValidity (m_aXml);
    m_aWarm30.getSchematronValidity (m_aXml);
  }

  // ---- cold (includes per-invocation generation + compile cost) ----

  @Benchmark
  public void cold10 (final Blackhole bh) throws Exception
  {
    bh.consume (_build (EPureXsltVersion.XSLT_1_0).getSchematronValidity (m_aXml));
  }

  @Benchmark
  public void cold20 (final Blackhole bh) throws Exception
  {
    bh.consume (_build (EPureXsltVersion.XSLT_2_0).getSchematronValidity (m_aXml));
  }

  @Benchmark
  public void cold30 (final Blackhole bh) throws Exception
  {
    bh.consume (_build (EPureXsltVersion.XSLT_3_0).getSchematronValidity (m_aXml));
  }

  // ---- warm (compile happens once, only per-document validation is measured) ----

  @Benchmark
  public void warm10 (final Blackhole bh) throws Exception
  {
    bh.consume (m_aWarm10.getSchematronValidity (m_aXml));
  }

  @Benchmark
  public void warm20 (final Blackhole bh) throws Exception
  {
    bh.consume (m_aWarm20.getSchematronValidity (m_aXml));
  }

  @Benchmark
  public void warm30 (final Blackhole bh) throws Exception
  {
    bh.consume (m_aWarm30.getSchematronValidity (m_aXml));
  }
}
