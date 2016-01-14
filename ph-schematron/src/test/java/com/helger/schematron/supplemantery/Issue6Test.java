/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
package com.helger.schematron.supplemantery;

import static org.junit.Assert.assertNotNull;

import java.io.File;

import org.junit.Test;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.xml.serialize.write.XMLWriter;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.svrl.SVRLWriter;
import com.helger.schematron.xslt.SchematronResourceSCH;

public final class Issue6Test
{
  @Test
  public void testIssue () throws Exception
  {
    validateAndProduceSVRL (new File ("src/test/resources/issues/github6/schematron.sch"),
                            new File ("src/test/resources/issues/github6/test.xml"));
  }

  public static void validateAndProduceSVRL (final File schematron, final File xml) throws Exception
  {
    final IReadableResource aSchematron = new FileSystemResource (schematron.getAbsoluteFile ());
    final IReadableResource anXMLSource = new FileSystemResource (xml.getAbsoluteFile ());
    final AbstractSchematronResource aSCH = new SchematronResourceSCH (aSchematron);
    if (aSCH instanceof SchematronResourcePure)
      ((SchematronResourcePure) aSCH).setErrorHandler (new LoggingPSErrorHandler ());
    else
      System.out.println (XMLWriter.getXMLString (((SchematronResourceSCH) aSCH).getXSLTProvider ().getXSLTDocument ()));
    final SchematronOutputType aSVRL = aSCH.applySchematronValidationToSVRL (anXMLSource);
    assertNotNull (aSVRL);
    System.out.println (SVRLWriter.createXMLString (aSVRL));
  }
}
