/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertNotNull;

import java.io.File;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Ported from {@code IssueGlobalLetTest} in {@code ph-schematron-xslt}. Exercises a pattern-level
 * {@code <sch:let>} referenced from multiple rules with two rule scopes - the let must remain in
 * scope across the rule context match.
 *
 * @author Philip Helger
 */
public final class IssueGlobalLetPureXsltTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (IssueGlobalLetPureXsltTest.class);

  @Test
  public void testIssueGlobalLet () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/external/issues/global-let/schematron.sch"),
                            new File ("src/test/resources/external/issues/global-let/test.xml"));
  }

  public static void validateAndProduceSVRL (final File aSchematron, final File aXML) throws Exception
  {
    final IReadableResource aSchRes = new FileSystemResource (aSchematron.getAbsoluteFile ());
    final IReadableResource aXMLRes = new FileSystemResource (aXML.getAbsoluteFile ());
    final SchematronResourcePureXslt aSch = new SchematronResourcePureXslt (aSchRes);
    final SchematronOutputType aSVRL = aSch.applySchematronValidationToSVRL (aXMLRes);
    assertNotNull (aSVRL);
    if (false)
      LOGGER.info (new SVRLMarshaller (false).setFormattedOutput (true).getAsString (aSVRL));
  }
}
