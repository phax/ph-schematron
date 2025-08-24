/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.testfiles.SchematronTestFile;
import com.helger.schematron.xslt.SchematronResourceXSLT;

import jakarta.annotation.Nonnull;

public final class Issue169XsltTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue169XsltTest.class);

  public static void validateAndProduceSVRL (@Nonnull final IReadableResource aSchematron,
                                             @Nonnull final IReadableResource aXML) throws Exception
  {
    final SchematronResourceXSLT aSCH = new SchematronResourceXSLT (aSchematron);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (aXML);
    assertNotNull (aSVRL);
    if (false)
      LOGGER.info (new SVRLMarshaller ().getAsString (aSVRL));

    int nFiredRules = 0;
    for (final Object o : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
      if (o instanceof FiredRule)
      {
        LOGGER.info (((FiredRule) o).getContext ());
        nFiredRules++;
      }
    LOGGER.info (nFiredRules + " fired rules");

    final ICommonsList <AbstractSVRLMessage> aFailures = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    final int n = aFailures.size ();
    LOGGER.info (n + " failed assertions/successful reports");
    aFailures.forEach (x -> LOGGER.info (x.getAsResourceError (aXML.getPath ()).getAsStringLocaleIndepdent ()));
  }

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new ClassPathResource ("external/issue169/schematron_eu_1.0.0.xslt",
                                                   SchematronTestFile.class.getClassLoader ()),
                            new ClassPathResource ("external/issue169/cn_24_maximal_error.xml",
                                                   SchematronTestFile.class.getClassLoader ()));
  }
}
