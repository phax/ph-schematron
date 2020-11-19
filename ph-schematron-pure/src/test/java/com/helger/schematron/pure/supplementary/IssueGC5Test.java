/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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

import java.io.File;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.SchematronHelper;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class IssueGC5Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (IssueGC5Test.class);

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/issues/gc5/schematron.sch"),
                            new File ("src/test/resources/issues/gc5/AERODROME.xml"));
  }

  public static void validateAndProduceSVRL (final File schematron, final File xml) throws Exception
  {
    final IReadableResource aSchematron = new FileSystemResource (schematron.getAbsoluteFile ());
    final IReadableResource anXMLSource = new FileSystemResource (xml.getAbsoluteFile ());
    final SchematronResourcePure pure = new SchematronResourcePure (aSchematron);
    // final FileOutputStream fos = new FileOutputStream (result);
    // final Result res = new StreamResult (fos);

    // res.setSystemId(result.getAbsolutePath());
    // final SchematronOutputType svrl = pure.applySchematronValidationToSVRL
    // (anXMLSource);
    final SchematronOutputType aSO = SchematronHelper.applySchematron (pure, anXMLSource);
    final ICommonsList <SVRLFailedAssert> aFailedAsserts = SVRLHelper.getAllFailedAssertions (aSO);
    LOGGER.info (aFailedAsserts.toString ());
  }

}
