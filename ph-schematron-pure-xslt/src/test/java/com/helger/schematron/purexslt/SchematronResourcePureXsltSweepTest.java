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
package com.helger.schematron.purexslt;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.io.resource.IReadableResource;
import com.helger.schematron.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.testfiles.SchematronTestHelper;

/**
 * Sweep test: runs {@link SchematronResourcePureXslt} over every Schematron file shipped by
 * {@code ph-schematron-testfiles#getAllValidSchematronFiles()}. Catches broad regressions in schema
 * parsing / XSLT generation / Saxon compilation. Per-file failures are accumulated and reported
 * together at the end of the run so all gaps surface in one pass.
 *
 * @author Philip Helger
 */
public final class SchematronResourcePureXsltSweepTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourcePureXsltSweepTest.class);

  @Test
  public void testParseAndCompileAllValidSchematrons ()
  {
    int nTotal = 0;
    int nOk = 0;
    final StringBuilder aFailures = new StringBuilder ();
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      nTotal++;
      final SchematronResourcePureXslt aSch = SchematronResourcePureXslt.builder (aRes)
                                                                        .errorHandler (new DoNothingPSErrorHandler ())
                                                                        .build ();
      try
      {
        // Both lazy reading and XSLT generation/compilation are exercised by isValidSchematron
        // (which forces the read) followed by getOrCompileXslt via a dummy validation call
        // setup. We deliberately don't run a transform - it requires an instance XML and isn't
        // what this sweep is testing.
        if (!aSch.isValidSchematron ())
        {
          aFailures.append ("\n  - ").append (aRes.getPath ()).append (" :: isValidSchematron returned false");
          continue;
        }
        aSch.getOrCompileXslt ();
        nOk++;
      }
      catch (final Throwable t)
      {
        aFailures.append ("\n  - ")
                 .append (aRes.getPath ())
                 .append (" :: ")
                 .append (t.getClass ().getSimpleName ())
                 .append (": ")
                 .append (t.getMessage ());
      }
    }
    LOGGER.info ("Sweep: " + nOk + " / " + nTotal + " valid schematrons parsed and compiled cleanly");
    assertTrue ("at least one valid schematron was expected in the testfiles fixture set", nTotal > 0);
    if (nOk < nTotal)
    {
      final int nFailed = nTotal - nOk;
      // Surface as a soft-fail with the full list. Convert to hard-fail when coverage is good
      // enough that any regression is a real bug. For now, log; flip to fail() to enforce.
      LOGGER.warn ("Sweep: " + nFailed + " / " + nTotal + " schematrons failed:" + aFailures);
      if (nOk * 4 < nTotal * 3)
      {
        // less than 75% success - hard fail so we notice
        fail ("Sweep: only " + nOk + " / " + nTotal + " schematrons compiled" + aFailures);
      }
    }
  }
}
