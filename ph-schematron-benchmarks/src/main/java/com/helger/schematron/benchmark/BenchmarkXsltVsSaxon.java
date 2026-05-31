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

import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.puresaxon.SchematronResourceSaxon;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * Head-to-head comparison of the two SCH&nbsp;&rarr;&nbsp;SVRL pipelines:
 * <ul>
 * <li>{@link SchematronResourceSCH} - "regular XSLT": preprocesses the schema through the ISO
 * Schematron XSL stylesheet chain via JAXP {@code TransformerFactory}, then applies the resulting
 * XSLT via JAXP as well.</li>
 * <li>{@link SchematronResourceSaxon} - "new pure XSLT": walks the parsed {@code PSSchema} in Java
 * and emits an XSLT&nbsp;3.0 stylesheet directly, then compiles and runs it via Saxon
 * {@code s9api}.</li>
 * </ul>
 * <p>
 * Two cost profiles per engine:
 * <ul>
 * <li><b>{@code cold*}</b> - fresh resource per invocation. Includes the full compile cost (the
 * dominant cost in batch jobs that validate a few documents and exit).</li>
 * <li><b>{@code warm*}</b> - one resource shared across invocations, only the per-document
 * validation cost is measured. Representative of long-running services.</li>
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
public class BenchmarkXsltVsSaxon
{
  private static final ClassPathResource SCHEMATRON = new ClassPathResource ("external/test-sch/valid03.sch");
  private static final ClassPathResource XMLINSTANCE = new ClassPathResource ("external/test-xml/valid03.xml");

  // Long-lived, pre-compiled resources used by the warm variants
  private SchematronResourceSCH m_aWarmSch;
  private SchematronResourceSaxon m_aWarmSaxon;

  @Setup (Level.Trial)
  public void setup () throws Exception
  {
    m_aWarmSch = new SchematronResourceSCH (SCHEMATRON);
    m_aWarmSch.setErrorListener (new DoNothingTransformErrorListener ());
    // Force one validation to materialize the cached XSLT before the timed loop starts
    m_aWarmSch.getSchematronValidity (XMLINSTANCE);

    m_aWarmSaxon = new SchematronResourceSaxon (SCHEMATRON);
    m_aWarmSaxon.setErrorHandler (new DoNothingPSErrorHandler ());
    m_aWarmSaxon.getSchematronValidity (XMLINSTANCE);
  }

  // ---- cold (includes per-invocation compile cost) ----

  @Benchmark
  public void coldXslt (final Blackhole bh) throws Exception
  {
    final SchematronResourceSCH r = new SchematronResourceSCH (SCHEMATRON);
    r.setErrorListener (new DoNothingTransformErrorListener ());
    bh.consume (r.getSchematronValidity (XMLINSTANCE));
  }

  @Benchmark
  public void coldSaxon (final Blackhole bh) throws Exception
  {
    final SchematronResourceSaxon r = new SchematronResourceSaxon (SCHEMATRON);
    r.setErrorHandler (new DoNothingPSErrorHandler ());
    bh.consume (r.getSchematronValidity (XMLINSTANCE));
  }

  // ---- warm (compile happens once, only per-document validation is measured) ----

  @Benchmark
  public void warmXslt (final Blackhole bh) throws Exception
  {
    bh.consume (m_aWarmSch.getSchematronValidity (XMLINSTANCE));
  }

  @Benchmark
  public void warmSaxon (final Blackhole bh) throws Exception
  {
    bh.consume (m_aWarmSaxon.getSchematronValidity (XMLINSTANCE));
  }
}
