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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import javax.annotation.Nonnull;

import org.junit.Test;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class Issue077Test
{
  private static void _validateAndProduceSVRL (@Nonnull final File aSchematron,
                                               @Nonnull final File aXML,
                                               final boolean bValid) throws Exception
  {
    final SchematronResourceSCH aSCH = SchematronResourceSCH.fromFile (aSchematron);
    aSCH.setAllowForeignElements (true);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);

    if (bValid)
      assertTrue (SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).isEmpty ());
    else
      assertTrue (SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).isNotEmpty ());
  }

  @Test
  public void testIssue () throws Exception
  {
    _validateAndProduceSVRL (new File ("src/test/resources/external/issues/github77/schematron.sch"),
                             new File ("src/test/resources/external/issues/github77/valid.xml"),
                             true);
    _validateAndProduceSVRL (new File ("src/test/resources/external/issues/github77/schematron.sch"),
                             new File ("src/test/resources/external/issues/github77/invalid.xml"),
                             false);
  }
}
