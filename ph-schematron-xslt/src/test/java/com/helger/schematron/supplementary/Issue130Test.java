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

import static org.junit.Assert.assertNotNull;

import java.io.File;

import javax.annotation.Nonnull;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.serialize.write.XMLWriter;

public final class Issue130Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue130Test.class);

  public static void validateAndProduceSVRL (@Nonnull final File aSchematron, final File aXML) throws Exception
  {
    final SchematronResourceSCH aSCH = SchematronResourceSCH.fromFile (aSchematron);

    // Assign custom parameters
    aSCH.parameters ().put ("xyz", "cellphone");
    aSCH.parameters ().put ("expected", "");

    if (false)
      LOGGER.info (XMLWriter.getNodeAsString (aSCH.getXSLTProvider ().getXSLTDocument ()));

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    if (true)
      LOGGER.info (new SVRLMarshaller ().getAsString (aSVRL));
  }

  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/external/issues/github130/schematron.sch"),
                            new File ("src/test/resources/external/issues/github130/test.xml"));
  }
}
