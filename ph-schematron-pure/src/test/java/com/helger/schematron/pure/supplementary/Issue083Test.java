/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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

import java.io.File;

import javax.annotation.Nonnull;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class Issue083Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue083Test.class);

  private static void _validateAndProduceSVRL (@Nonnull final File aSchematron,
                                               @Nonnull final File aXML) throws Exception
  {
    final SchematronResourcePure aSCH = SchematronResourcePure.fromFile (aSchematron);
    SchematronDebug.setSaveIntermediateXSLTFiles (true);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);

    final String sSVRL = new SVRLMarshaller ().getAsString (aSVRL);
    assertNotNull (sSVRL);
    if (true)
      LOGGER.info ("SVRL:\n" + sSVRL);

    // XXX should be 1 according to #83
    assertEquals (0, SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).size ());
  }

  @Test
  public void testIssue () throws Exception
  {
    _validateAndProduceSVRL (new File ("src/test/resources/external/issues/github83/schematron.sch"),
                             new File ("src/test/resources/external/issues/github83/test.xml"));
  }
}
