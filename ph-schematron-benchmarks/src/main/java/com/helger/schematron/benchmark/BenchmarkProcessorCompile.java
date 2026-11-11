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

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.sch.SchematronProviderXSLTFromSCH;
import com.helger.schematron.sch.SchematronSCHConfig;
import com.helger.schematron.schxslt.xslt2.SchematronProviderXSLTFromSchXslt_XSLT2;
import com.helger.schematron.schxslt.xslt2.SchematronSchXslt_XSLT2Config;
import com.helger.schematron.schxslt2.xslt.SchematronProviderXSLTFromSchXslt2;
import com.helger.schematron.schxslt2.xslt.SchematronSchXslt2Config;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * The Schematron to XSLT conversion alone (without compiling the created XSLT and without
 * validation), per pipeline and XSLT processor, for a Schematron with includes and abstract
 * patterns. The conversion stylesheets are cached per processor before the measurement.
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
public class BenchmarkProcessorCompile
{
  private static final ClassPathResource SCHEMATRON = new ClassPathResource ("external/test-sch/eugen/EUGEN-UBL-T10.sch",
                                                                             SchematronTestHelper.getCL ());

  /** The XSLT processor */
  @Param ({ "saxon", "phoxtrot" })
  public String xsltProcessor;

  private ISchematronXsltProcessor m_aXsltProcessor;

  @Setup
  public void setup ()
  {
    m_aXsltProcessor = SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (xsltProcessor);
    SchematronProviderXSLTFromSCH.cacheXSLTTemplates (m_aXsltProcessor);
    SchematronProviderXSLTFromSchXslt_XSLT2.cacheXSLTTemplates (m_aXsltProcessor);
    SchematronProviderXSLTFromSchXslt2.cacheXSLTTemplate (m_aXsltProcessor);
  }

  @Benchmark
  public void iso (final Blackhole bh) throws Exception
  {
    bh.consume (SchematronProviderXSLTFromSCH.createSchematronXSLT (SchematronSCHConfig.builder (SCHEMATRON)
                                                                                      .errorListener (new DoNothingTransformErrorListener ())
                                                                                      .xsltProcessor (m_aXsltProcessor)
                                                                                      .build ()));
  }

  @Benchmark
  public void schXslt (final Blackhole bh) throws Exception
  {
    bh.consume (SchematronProviderXSLTFromSchXslt_XSLT2.createSchematronXSLT (SchematronSchXslt_XSLT2Config.builder (SCHEMATRON)
                                                                                                          .errorListener (new DoNothingTransformErrorListener ())
                                                                                                          .xsltProcessor (m_aXsltProcessor)
                                                                                                          .build ()));
  }

  @Benchmark
  public void schXslt2 (final Blackhole bh) throws Exception
  {
    bh.consume (SchematronProviderXSLTFromSchXslt2.createSchematronXSLT (SchematronSchXslt2Config.builder (SCHEMATRON)
                                                                                                .errorListener (new DoNothingTransformErrorListener ())
                                                                                                .xsltProcessor (m_aXsltProcessor)
                                                                                                .build ()));
  }
}
