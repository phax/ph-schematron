/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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
import org.oclc.purl.dsdl.svrl.SchematronOutputType;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.SVRLMarshaller;

public final class IssueDita1
{
  @Test
  public void testIssueXsltKey () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/issues/dita1/topic.sch"),
                            new File ("src/test/resources/issues/dita1/image-in-title.dita"));
    validateAndProduceSVRL (new File ("src/test/resources/issues/dita1/topic.sch"),
                            new File ("src/test/resources/issues/dita1/highlight-in-title.dita"));
  }

  public static void validateAndProduceSVRL (final File aSchematronFile, final File aXmlFile) throws Exception
  {
    final AbstractSchematronResource aSCH = SchematronResourcePure.fromFile (aSchematronFile);
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXmlFile));
    assertNotNull (aSVRL);
    if (true)
      System.out.println (new SVRLMarshaller ().getAsString (aSVRL));
  }
}
