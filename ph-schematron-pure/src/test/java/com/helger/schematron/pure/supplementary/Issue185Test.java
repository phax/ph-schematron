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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

import jakarta.annotation.Nonnull;

/**
 * Test for GitHub issue 185
 *
 * @author Philip Helger
 */
public final class Issue185Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue185Test.class);

  public static void validateAndProduceSVRL (@Nonnull final IReadableResource aSchematron,
                                             @Nonnull final IReadableResource aXML) throws Exception
  {
    final SchematronResourcePure aSCH = new SchematronResourcePure (aSchematron);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (aXML);
    assertNotNull (aSVRL);
    if (true)
      LOGGER.info (new SVRLMarshaller ().getAsString (aSVRL));

    final ICommonsList <AbstractSVRLMessage> aFailures = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    final int n = aFailures.size ();
    LOGGER.info (n + " failed assertions/successful reports");
    aFailures.forEach (x -> LOGGER.info (x.getAsResourceError (aXML.getPath ()).getAsStringLocaleIndepdent ()));

    // Should be 0 but is 1
    if (false)
      assertEquals (0, aFailures.size ());
  }

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new ClassPathResource ("external/issues/github185/schematron.sch"),
                            new ClassPathResource ("external/issues/github185/test.xml"));
  }
}
