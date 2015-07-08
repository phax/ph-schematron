/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertTrue;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.xml.transform.DoNothingTransformErrorListener;
import com.helger.schematron.CSchematron;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.schematron.xslt.SchematronResourceSCH;

/**
 * Mini benchmark
 *
 * @author Philip Helger
 */
public final class MainBenchmarkIsValidSchematron extends AbstractBenchmarkTask
{
  public static void main (final String [] args)
  {
    logSystemInfo ();

    final List <IReadableResource> aValidSchematrons = new ArrayList <IReadableResource> ();
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
      if (!aRes.getPath ().endsWith ("/BIICORE-UBL-T01.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T10.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T14.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T15.sch") &&
          !aRes.getPath ().endsWith ("/CellarBook.sch") &&
          !aRes.getPath ().endsWith ("/pattern-example-with-includes.sch") &&
          !aRes.getPath ().endsWith ("/pattern-example.sch") &&
          !aRes.getPath ().endsWith ("/schematron-svrl.sch"))
        aValidSchematrons.add (aRes);

    s_aLogger.info ("Starting");

    final double dTime1 = benchmarkTask (new ValidSchematronPure (aValidSchematrons));
    s_aLogger.info ("Time pure: " + BigDecimal.valueOf (dTime1).toString () + " us");

    final double dTime2 = benchmarkTask (new ValidSchematronSCH (aValidSchematrons));
    s_aLogger.info ("Time XSLT: " + BigDecimal.valueOf (dTime2).toString () + " us");

    s_aLogger.info ("Time1 is " + BigDecimal.valueOf (dTime1 / dTime2 * 100).toString () + "% of time2");
  }

  private static final class ValidSchematronPure implements Runnable
  {
    private final List <IReadableResource> m_aValidSchematrons;

    public ValidSchematronPure (final List <IReadableResource> aValidSchematrons)
    {
      m_aValidSchematrons = aValidSchematrons;
    }

    public void run ()
    {
      for (final IReadableResource aRes : m_aValidSchematrons)
      {
        final SchematronResourcePure aResPure = new SchematronResourcePure (aRes,
                                                                            CSchematron.PHASE_ALL,
                                                                            new DoNothingPSErrorHandler ());
        assertTrue (aRes.getPath (), aResPure.isValidSchematron ());
      }
    }
  }

  private static final class ValidSchematronSCH implements Runnable
  {
    private final List <IReadableResource> m_aValidSchematrons;

    public ValidSchematronSCH (final List <IReadableResource> aValidSchematrons)
    {
      m_aValidSchematrons = aValidSchematrons;
    }

    public void run ()
    {
      for (final IReadableResource aRes : m_aValidSchematrons)
      {
        final SchematronResourceSCH aResSCH = new SchematronResourceSCH (aRes);
        aResSCH.setErrorListener (new DoNothingTransformErrorListener ());
        assertTrue (aRes.getPath (), aResSCH.isValidSchematron ());
      }
    }
  }
}
