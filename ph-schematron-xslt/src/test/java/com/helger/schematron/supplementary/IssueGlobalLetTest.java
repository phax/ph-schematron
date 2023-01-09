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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertNotNull;

import java.io.File;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class IssueGlobalLetTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (IssueGlobalLetTest.class);

  @Test
  public void testIssueXsltKey () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/issues/global-let/schematron.sch"),
                            new File ("src/test/resources/issues/global-let/test.xml"));
  }

  public static void validateAndProduceSVRL (final File schematron, final File xml) throws Exception
  {
    final IReadableResource aSchematron = new FileSystemResource (schematron.getAbsoluteFile ());
    final IReadableResource anXMLSource = new FileSystemResource (xml.getAbsoluteFile ());
    final AbstractSchematronResource pure = new SchematronResourceSCH (aSchematron);
    final SchematronOutputType aSVRL = pure.applySchematronValidationToSVRL (anXMLSource);
    assertNotNull (aSVRL);
    if (false)
      LOGGER.info (new SVRLMarshaller ().setFormattedOutput (true).getAsString (aSVRL));
  }
}
