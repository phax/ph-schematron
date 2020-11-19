/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
import static org.junit.Assert.assertTrue;

import java.io.File;

import javax.annotation.Nonnull;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.validation.LoggingPSValidationHandler;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class Issue088Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue088Test.class);

  private static void _validateAndProduceSVRL (@Nonnull final File aSchematron, @Nonnull final File aXML) throws Exception
  {
    SchematronDebug.setSaveIntermediateXSLTFiles (true);
    final ISchematronResource aSCH = SchematronResourcePure.fromFile (aSchematron);
    if (aSCH instanceof SchematronResourcePure)
      ((SchematronResourcePure) aSCH).setCustomValidationHandler (new LoggingPSValidationHandler ());

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);

    LOGGER.info ("SVRL:\n" + new SVRLMarshaller ().getAsString (aSVRL));

    assertTrue (SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).isEmpty ());
  }

  @Test
  public void testIssue () throws Exception
  {
    _validateAndProduceSVRL (new File ("src/test/resources/issues/github88/schematron.sch"),
                             new File ("src/test/resources/issues/github88/test.xml"));
  }
}
