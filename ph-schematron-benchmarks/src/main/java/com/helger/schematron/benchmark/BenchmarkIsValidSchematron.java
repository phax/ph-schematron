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

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.CSchematron;
import com.helger.schematron.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * Compares {@code isValidSchematron()} across all engines. Each iteration walks the curated set of
 * valid schematron files and asks each engine to parse + accept them. Measures the parse + bind
 * cost rather than the validate cost.
 *
 * @author Philip Helger
 */
@State (Scope.Benchmark)
@BenchmarkMode (Mode.AverageTime)
@OutputTimeUnit (TimeUnit.NANOSECONDS)
@Warmup (iterations = 2, time = 3)
@Measurement (iterations = 5, time = 5)
@Fork (1)
public class BenchmarkIsValidSchematron
{
  private ICommonsList <IReadableResource> m_aSchemas;

  @Setup
  public void setup ()
  {
    m_aSchemas = new CommonsArrayList <> ();
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
      if (!aRes.getPath ().endsWith ("/BIICORE-UBL-T01.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T10.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T14.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T15.sch") &&
          !aRes.getPath ().endsWith ("/CellarBook.sch") &&
          !aRes.getPath ().endsWith ("/pattern-example-with-includes.sch") &&
          !aRes.getPath ().endsWith ("/pattern-example.sch") &&
          !aRes.getPath ().endsWith ("/schematron-svrl.sch"))
        m_aSchemas.add (aRes);
  }

  @Benchmark
  public void sch (final Blackhole bh)
  {
    for (final IReadableResource aRes : m_aSchemas)
    {
      final SchematronResourceSCH r = SchematronResourceSCH.builder (aRes)
                                                           .errorListener (new DoNothingTransformErrorListener ())
                                                           .build ();
      bh.consume (r.isValidSchematron ());
    }
  }

  @Benchmark
  public void pureXPath (final Blackhole bh)
  {
    for (final IReadableResource aRes : m_aSchemas)
    {
      final SchematronResourcePureXPath r = new SchematronResourcePureXPath (aRes,
                                                                             CSchematron.PHASE_ALL,
                                                                             new DoNothingPSErrorHandler ());
      bh.consume (r.isValidSchematron ());
    }
  }

  @Benchmark
  public void pureSaxon (final Blackhole bh)
  {
    for (final IReadableResource aRes : m_aSchemas)
    {
      final SchematronResourcePureXslt r = SchematronResourcePureXslt.builder (aRes)
                                                                     .errorHandler (new DoNothingPSErrorHandler ())
                                                                     .build ();
      bh.consume (r.isValidSchematron ());
    }
  }
}
