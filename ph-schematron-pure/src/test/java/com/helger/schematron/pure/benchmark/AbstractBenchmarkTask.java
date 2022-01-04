/*
 * Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.benchmark;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.CGlobal;
import com.helger.commons.system.SystemHelper;
import com.helger.commons.system.SystemProperties;

/**
 * Abstract benchmarking class.
 *
 * @author Philip Helger
 */
public abstract class AbstractBenchmarkTask
{
  /** logger to use. */
  protected static final Logger LOGGER = LoggerFactory.getLogger (AbstractBenchmarkTask.class);

  /**
   * This constant specifies the minimum number of times that a task to be
   * benchmarked must run before an actual timing measurement should be done.
   * This is done both to load all relevant classes as well as to warm up
   * hotspot before doing a measurement.
   */
  private static final int MIN_WARMUP_CALLS = 1000;
  /**
   * This constant specifies the minimum time that a task to be benchmarked must
   * run to assure accurate timing measurements. It must be set reasonably large
   * to deal with the low resolution clocks present on many platforms (e.g.
   * typical Windows machines have error around 10s of ms?). The units of this
   * constant are nanoseconds.
   */
  private static final long MIN_BENCHMARK_NANOSECS = 3 * CGlobal.NANOSECONDS_PER_SECOND;

  protected AbstractBenchmarkTask ()
  {}

  protected static void logSystemInfo ()
  {
    LOGGER.info ("Runtime: Date=" +
                 new Date ().toString () +
                 "; Java=" +
                 SystemProperties.getJavaVersion () +
                 "; OS=" +
                 SystemHelper.getOperatingSystemName () +
                 "; User=" +
                 SystemProperties.getUserName () +
                 "; Procs=" +
                 SystemHelper.getNumberOfProcessors ());
  }

  /**
   * Measures how long it takes to execute the run method of the task arg.
   * <p>
   * This method uses the MIN_WARMUP_CALLS and MIN_BENCHMARK_TIME constants to
   * obtain accurate results.
   * <p>
   * This method explicitly requests garbage collection before doing each
   * benchmark. Therefore, unless you actually want to include the effect of
   * garbage collection in the benchmark, the JVM should use a "stop-the-world"
   * garbage collector, if it is available. (Usually it is. With Sun's tools,
   * this is, in fact, the default garbage collector type.) The type of garbage
   * collectors to avoid are incremental, concurrent, or parallel ones.
   * <p>
   *
   * @param aTask
   *        The task to be executed
   * @return average execution time of a single invocation of task.run, in
   *         microseconds
   */
  protected static final double benchmarkTask (final Runnable aTask)
  {
    int numberOfRuns = MIN_WARMUP_CALLS;
    while (true)
    {
      System.gc ();
      final long t1 = System.nanoTime ();
      for (int i = 0; i < numberOfRuns; i++)
      {
        aTask.run ();
      }
      final long t2 = System.nanoTime ();

      final long nTestNanos = t2 - t1;
      if ((numberOfRuns > MIN_WARMUP_CALLS) && (nTestNanos > MIN_BENCHMARK_NANOSECS))
      {
        // System.out.println("numberOfRuns required = " + numberOfRuns);
        return nTestNanos / (double) numberOfRuns;
      }
      numberOfRuns *= 2;
    }
  }
}
