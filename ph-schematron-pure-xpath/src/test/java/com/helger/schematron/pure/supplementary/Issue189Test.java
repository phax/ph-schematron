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
package com.helger.schematron.pure.supplementary;

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
import com.helger.schematron.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Test for GitHub issue 189: a <code>&lt;let&gt;</code> without a <code>value</code> attribute
 * takes its expression from the element content. Previously this was rejected with
 * "<code>&lt;let&gt; has no 'value'</code>" during binding.
 *
 * @author Philip Helger
 */
public final class Issue189Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue189Test.class);

  private static final String SCH = "src/test/resources/external/issues/github189/schematron.sch";
  private static final String XML_VALID = "src/test/resources/external/issues/github189/test-valid.xml";
  private static final String XML_INVALID = "src/test/resources/external/issues/github189/test-invalid.xml";

  @NonNull
  private static ICommonsList <AbstractSVRLMessage> _validateAndProduceSVRL (@NonNull final String sXML) throws Exception
  {
    final SchematronResourcePureXPath aSCH = SchematronResourcePureXPath.builderFromFile (SCH).build ();

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (new File (sXML)));
    assertNotNull (aSVRL);
    LOGGER.info (new SVRLMarshaller ().getAsString (aSVRL));

    return SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL);
  }

  @Test
  public void testSchematronIsValid ()
  {
    // This is what failed before: "<let> has no 'value'"
    final SchematronResourcePureXPath aSCH = SchematronResourcePureXPath.builderFromFile (SCH).build ();
    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();
    aSCH.validateCompletely (aErrorHandler);
    assertTrue (aErrorHandler.getErrorList ().toString (), aErrorHandler.isEmpty ());
    assertTrue (aSCH.isValidSchematron ());
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

    // Proves that the <let> body expressions were not just parsed but also evaluated:
    // $docCode (schema level) and $obsCount (pattern level) are resolved in the message
    final String sText = aFailures.getFirstOrNull ().getText ();
    assertTrue (sText, sText.contains ("'RAP'"));
    assertTrue (sText, sText.contains ("(2 observations in total)"));
  }
}
