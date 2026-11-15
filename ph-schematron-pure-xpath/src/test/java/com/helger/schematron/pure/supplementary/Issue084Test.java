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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;

import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Test for GitHub issue 84
 *
 * @author Philip Helger
 */
public final class Issue084Test
{
  @Test
  public void testIssue () throws Exception
  {
    final SchematronResourcePureXPath aSCH = SchematronResourcePureXPath.builder (new ClassPathResource ("external/issues/github84/schematron.sch"))
                                                                        .build ();
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new ClassPathResource ("external/issues/github84/test.xml"));
    assertNotNull (aSVRL);

    // Both elements are matched by the first rule, so the second rule must not fire
    int nFiredRules = 0;
    for (final Object aObj : aSVRL.getActivePatternOrActiveGroupAndFiredRule ())
      if (aObj instanceof final FiredRule aFR)
      {
        assertEquals ("//element", aFR.getContext ());
        nFiredRules++;
      }
    assertEquals (2, nFiredRules);
    assertEquals (0, SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).size ());
  }
}
