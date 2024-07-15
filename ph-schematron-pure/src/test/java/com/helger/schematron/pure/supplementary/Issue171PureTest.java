/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertNotNull;

import javax.annotation.Nonnull;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.testfiles.SchematronTestFile;

public final class Issue171PureTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue171PureTest.class);

  public static void validateAndProduceSVRL (@Nonnull final IReadableResource aSchematron,
                                             @Nonnull final IReadableResource aXML) throws Exception
  {
    final SchematronResourcePure aSCH = new SchematronResourcePure (aSchematron);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (aXML);
    assertNotNull (aSVRL);
    if (false)
      LOGGER.info (new SVRLMarshaller ().getAsString (aSVRL));

    final ICommonsList <AbstractSVRLMessage> aFailures = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    final int n = aFailures.size ();
    LOGGER.info (n + " failed assertions/successful reports");
    aFailures.forEach (x -> LOGGER.info (x.getAsResourceError (aXML.getPath ()).getAsStringLocaleIndepdent ()));
  }

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new ClassPathResource ("external/issue171/eforms-de-validation.sch",
                                                   SchematronTestFile.class.getClassLoader ()),
                            new ClassPathResource ("external/issue171/PureVsXslt.xml",
                                                   SchematronTestFile.class.getClassLoader ()));
  }
}
