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
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Test for GitHub issue 199: a <code>&lt;let&gt;</code> variable referencing another
 * <code>&lt;let&gt;</code> variable via a sequence returning function like
 * <code>distinct-values</code> must keep the sequence. From v8.0.0 to v9.1.1 the JAXP based XPath
 * evaluation collapsed such a sequence into a single value, so <code>count()</code> always returned
 * 1. Since v9.2.0 the pure engine evaluates via the Saxon s9api and the sequence is retained.
 *
 * @author Philip Helger
 */
public final class Issue199Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue199Test.class);

  private static final String SCH = "src/test/resources/external/issues/github199/schematron.sch";
  private static final String XML_VALID = "src/test/resources/external/issues/github199/test.xml";
  private static final String XML_INVALID = "src/test/resources/external/issues/github199/test-invalid.xml";

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
  public void testDistinctValuesInLet () throws Exception
  {
    // 3 attributes with 2 distinct values - this is what failed before.
    // Also covers "tokenize" and a "for .. return" sequence
    assertEquals (0, _validateAndProduceSVRL (XML_VALID).size ());
  }

  @Test
  public void testDistinctValuesInLetFailing () throws Exception
  {
    // 3 attributes with 3 distinct values - proves the sequence is really evaluated
    final ICommonsList <AbstractSVRLMessage> aFailures = _validateAndProduceSVRL (XML_INVALID);
    assertEquals (1, aFailures.size ());

    final String sText = aFailures.getFirstOrNull ().getText ();
    assertTrue (sText, sText.contains ("1,2,3"));
  }
}
