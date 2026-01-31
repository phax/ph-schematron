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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.io.File;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class Issue158Test
{
  public static void validateAndProduceSVRL (@NonNull final File aSchematron, final File aXML) throws Exception
  {
    final SchematronResourceSCH aSCH = SchematronResourceSCH.fromFile (aSchematron);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);

    final ICommonsList <AbstractSVRLMessage> aAssertions = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    assertEquals (2, aAssertions.size ());

    final AbstractSVRLMessage aAssert0 = aAssertions.get (0);
    assertEquals (2, aAssert0.getDiagnosticReferences ().size ());
    assertEquals ("d_role_en", aAssert0.getDiagnosticReferences ().get (0).getDiagnostic ());
  }

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/external/issues/github156/schematron.sch"),
                            new File ("src/test/resources/external/issues/github156/test.xml"));
  }
}
