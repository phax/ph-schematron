/*
 * Copyright (C) 2020-2026 Philip Helger (www.helger.com)
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

import org.junit.Test;

import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class Issue174SchXsltTest
{
  private static final File SCH = new File ("src/test/resources/external/issues/github174/schematron.sch");
  private static final File XML = new File ("src/test/resources/external/issues/github174/test.xml");

  @Test
  public void testIssueSCH () throws Exception
  {
    final SchematronResourceSchXslt2 aSCH = SchematronResourceSchXslt2.fromFile (SCH);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (XML));
    assertNotNull (aSVRL);

    final ICommonsList <AbstractSVRLMessage> aAssertions = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    assertEquals (0, aAssertions.size ());
  }
}
