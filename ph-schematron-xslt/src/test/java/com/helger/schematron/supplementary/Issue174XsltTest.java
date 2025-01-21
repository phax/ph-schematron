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
import static org.junit.Assert.assertTrue;

import java.io.File;

import javax.annotation.Nonnull;

import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedResource;
import com.helger.schematron.sch.SchematronProviderXSLTFromSCH;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.sch.TransformerCustomizerSCH;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.xml.serialize.write.XMLWriter;

public final class Issue174XsltTest
{
  private static final File SCH = new File ("src/test/resources/external/issues/github174/schematron.sch");
  private static final File XML = new File ("src/test/resources/external/issues/github174/test.xml");

  public static void validateAndProduceSVRL (@Nonnull final File aSchematron, final File aXML) throws Exception
  {
    final SchematronResourceSCH aSCH = SchematronResourceSCH.fromFile (aSchematron);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);

    final ICommonsList <AbstractSVRLMessage> aAssertions = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    assertEquals (0, aAssertions.size ());
  }

  @Test
  public void testIssueSCH () throws Exception
  {
    final SchematronResourceSCH aSCH = SchematronResourceSCH.fromFile (SCH);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (XML));
    assertNotNull (aSVRL);

    final ICommonsList <AbstractSVRLMessage> aAssertions = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    assertEquals (0, aAssertions.size ());
  }

  @Test
  public void testIssueXSLT () throws Exception
  {
    // Convert SCH to XSLT
    final TransformerCustomizerSCH aCustomizer = new TransformerCustomizerSCH ();
    final Document aXsltDoc = SchematronProviderXSLTFromSCH.createSchematronXSLT (new FileSystemResource (SCH),
                                                                                  aCustomizer);

    // Load XSLT
    final ISchematronXSLTBasedResource xslt = SchematronResourceXSLT.fromByteArray (XMLWriter.getNodeAsBytes (aXsltDoc));
    assertTrue (xslt.isValidSchematron ());

    // Perform validation
    final SchematronOutputType aSVRL = xslt.applySchematronValidationToSVRL (new FileSystemResource (XML));
    assertNotNull (aSVRL);

    final ICommonsList <AbstractSVRLMessage> aAssertions = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
    assertEquals (0, aAssertions.size ());
  }
}
