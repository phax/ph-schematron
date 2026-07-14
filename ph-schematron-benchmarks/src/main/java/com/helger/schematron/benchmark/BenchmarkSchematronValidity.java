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
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Warmup;
import org.openjdk.jmh.infra.Blackhole;

import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * End-to-end SVRL-producing validation, one fixed Schematron and one fixed XML, repeated across
 * engines. Each iteration creates a fresh resource instance to include the bind/compile cost.
 *
 * @author Philip Helger
 */
@State (Scope.Benchmark)
@BenchmarkMode (Mode.AverageTime)
@OutputTimeUnit (TimeUnit.MICROSECONDS)
@Warmup (iterations = 3, time = 2)
@Measurement (iterations = 5, time = 3)
@Fork (1)
public class BenchmarkSchematronValidity
{
  private static final ClassPathResource VALID_SCHEMATRON = new ClassPathResource ("external/test-sch/valid03.sch",
                                                                                   SchematronTestHelper.getCL ());
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("external/test-xml/valid03.xml",
                                                                                    SchematronTestHelper.getCL ());

  @Setup
  public void setup ()
  {
    // Touch the resources once so any classpath discovery cost is paid before timing starts.
    VALID_SCHEMATRON.exists ();
    VALID_XMLINSTANCE.exists ();
  }

  @Benchmark
  public void sch (final Blackhole bh) throws Exception
  {
    final SchematronResourceSCH r = SchematronResourceSCH.builder (VALID_SCHEMATRON)
                                                         .errorListener (new DoNothingTransformErrorListener ())
                                                         .build ();
    bh.consume (r.getSchematronValidity (VALID_XMLINSTANCE));
  }

  @Benchmark
  public void pureXPath (final Blackhole bh) throws Exception
  {
    final SchematronResourcePureXPath r = SchematronResourcePureXPath.builder (VALID_SCHEMATRON).build ();
    bh.consume (r.getSchematronValidity (VALID_XMLINSTANCE));
  }

  @Benchmark
  public void pureSaxon (final Blackhole bh) throws Exception
  {
    final SchematronResourcePureXslt r = SchematronResourcePureXslt.builder (VALID_SCHEMATRON).build ();
    bh.consume (r.getSchematronValidity (VALID_XMLINSTANCE));
  }
}
