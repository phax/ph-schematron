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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.io.File;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class Issue126Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue126Test.class);

  private static void _validateAndProduceSVRL (@NonNull final File aSchematron,
                                               @NonNull final File aXML) throws Exception
  {
    final SchematronResourceSCH aSCH = SchematronResourceSCH.fromFile (aSchematron);
    aSCH.setAllowForeignElements (true);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);

    final String sSVRL = new SVRLMarshaller ().getAsString (aSVRL);
    assertNotNull (sSVRL);
    if (true)
      LOGGER.info ("SVRL:\n" + sSVRL);

    assertEquals (1, SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).size ());
  }

  @Test
  public void testIssue () throws Exception
  {
    _validateAndProduceSVRL (new File ("src/test/resources/external/issues/github126/schematron.sch"),
                             new File ("src/test/resources/external/issues/github126/test.xml"));
  }
}
