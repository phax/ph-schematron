/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Test for GitHub issue 189 with the XSLT sequence constructor form of {@code <let>} - the body of
 * the {@code <let>} is emitted as the body of the generated {@code <xsl:variable>}. The pure XPath
 * engine cannot evaluate this, so it is only tested with an XSLT based engine.
 *
 * @author Philip Helger
 */
public final class Issue189PureXsltTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue189PureXsltTest.class);

  private static final String SCH = "src/test/resources/external/issues/github189/schematron.sch";
  private static final String XML_VALID = "src/test/resources/external/issues/github189/test-valid.xml";
  private static final String XML_INVALID = "src/test/resources/external/issues/github189/test-invalid.xml";

  @NonNull
  private static ICommonsList <AbstractSVRLMessage> _validateAndProduceSVRL (@NonNull final String sXML) throws Exception
  {
    final SchematronResourcePureXslt aSCH = SchematronResourcePureXslt.builder (new FileSystemResource (new File (SCH)))
                                                                      .build ();

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (new File (sXML)));
    assertNotNull (aSVRL);
    LOGGER.info (new SVRLMarshaller ().setUseSchema (false).getAsString (aSVRL));

    return SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
  }

  @Test
  public void testValidXML () throws Exception
  {
    assertEquals (0, _validateAndProduceSVRL (XML_VALID).size ());
  }

  @Test
  public void testInvalidXML () throws Exception
  {
    final ICommonsList <AbstractSVRLMessage> aFailures = _validateAndProduceSVRL (XML_INVALID);
    assertEquals (1, aFailures.size ());

    // Proves that the <xsl:for-each> body of the <let> was evaluated
    final String sText = aFailures.getFirstOrNull ().getText ();
    assertTrue (sText, sText.contains ("/component/structuredBody/component/section/entry"));
  }
}
