/*
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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

import java.math.BigDecimal;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * Mini benchmark
 *
 * @author Philip Helger
 */
public final class MainBenchmarkSchematronGetSVRL extends AbstractBenchmarkTask
{
  private static final ClassPathResource VALID_SCHEMATRON = new ClassPathResource ("/test-sch/valid03.sch");
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("/test-xml/valid03.xml");

  public static void main (final String [] args)
  {
    logSystemInfo ();

    LOGGER.info ("Starting");

    final double dTime1 = benchmarkTask (new ValidSchematronPure ());
    LOGGER.info ("Time pure: " + BigDecimal.valueOf (dTime1).toString () + " us");

    final double dTime2 = benchmarkTask (new ValidSchematronSCH ());
    LOGGER.info ("Time XSLT: " + BigDecimal.valueOf (dTime2).toString () + " us");

    LOGGER.info ("Time1 is " + BigDecimal.valueOf (dTime1 / dTime2 * 100).toString () + "% of time2");
  }

  private static final class ValidSchematronPure implements Runnable
  {
    public void run ()
    {
      final SchematronResourcePure aResPure = new SchematronResourcePure (VALID_SCHEMATRON);
      try
      {
        if (aResPure.getSchematronValidity (VALID_XMLINSTANCE).isValid ())
          LOGGER.error ("SCH is invalid");
      }
      catch (final Exception ex)
      {
        throw new IllegalStateException (ex);
      }
    }
  }

  private static final class ValidSchematronSCH implements Runnable
  {
    public void run ()
    {
      final SchematronResourceSCH aResSCH = new SchematronResourceSCH (VALID_SCHEMATRON);
      aResSCH.setErrorListener (new DoNothingTransformErrorListener ());
      try
      {
        if (!aResSCH.getSchematronValidity (VALID_XMLINSTANCE).isValid ())
          LOGGER.error ("SCH is invalid");
      }
      catch (final Exception ex)
      {
        throw new IllegalStateException (ex);
      }
    }
  }
}
