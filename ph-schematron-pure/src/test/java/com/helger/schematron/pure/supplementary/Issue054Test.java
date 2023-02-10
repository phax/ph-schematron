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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertNotNull;

import java.io.File;

import javax.annotation.Nonnull;

import org.junit.Test;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

public final class Issue054Test
{
  public static void validateAndProduceSVRL (@Nonnull final File aSchematron, final File aXML) throws Exception
  {
    final ISchematronResource aSCH = SchematronResourcePure.fromFile (aSchematron);

    // Perform validation
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    if (false)
      System.out.println (new SVRLMarshaller ().getAsString (aSVRL));
  }

  @Test
  public void testIssue () throws Exception
  {
    SchematronDebug.setSaveIntermediateXSLTFiles (true);
    try
    {
      validateAndProduceSVRL (new File ("src/test/resources/external/issues/github54/schematron.sch"),
                              new File ("src/test/resources/external/issues/github54/test.xml"));
    }
    finally
    {
      SchematronDebug.setSaveIntermediateXSLTFiles (false);
    }
  }
}
