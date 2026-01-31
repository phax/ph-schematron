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

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.serialize.write.XMLWriter;

public final class IssueCellarBookTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (IssueCellarBookTest.class);

  public static void validateAndProduceSVRL (@NonNull final File aSchematron, final File aXML) throws Exception
  {
    final SchematronResourceSchXslt_XSLT2 aSCH = SchematronResourceSchXslt_XSLT2.fromFile (aSchematron);
    assertTrue (aSCH.isValidSchematron ());
    aSCH.parameters ().put ("schxslt.compile.metadata", "false");

    if (false)
      LOGGER.info (XMLWriter.getNodeAsString (aSCH.getXSLTProvider ().getXSLTDocument ()));

    // Disable!
    if (false)
      aSCH.setValidateSVRL (false);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    if (true)
      LOGGER.info (new SVRLMarshaller (false).getAsString (aSVRL));
  }

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/external/issues/cellarbook/CellarBook.sch"),
                            new File ("src/test/resources/external/issues/cellarbook/cellar.xml"));
  }
}
