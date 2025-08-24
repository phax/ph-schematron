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
package com.helger.schematron.supplementary.documentation;

import java.io.File;

import javax.xml.transform.stream.StreamSource;

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

import jakarta.annotation.Nonnull;

/**
 * This class contains code examples that are used in the documentation.
 *
 * @author Philip Helger
 */
public final class DocumentationExamples
{
  public static boolean validateXMLViaXSLTSchematron (@Nonnull final File aSchematronFile, @Nonnull final File aXMLFile) throws Exception
  {
    final ISchematronResource aResSCH = SchematronResourceSCH.fromFile (aSchematronFile);
    if (!aResSCH.isValidSchematron ())
      throw new IllegalArgumentException ("Invalid Schematron!");
    return aResSCH.getSchematronValidity (new StreamSource (aXMLFile)).isValid ();
  }

  public static SchematronOutputType validateXMLViaXSLTSchematronFull (@Nonnull final File aSchematronFile,
                                                                       @Nonnull final File aXMLFile) throws Exception
  {
    final ISchematronResource aResSCH = SchematronResourceSCH.fromFile (aSchematronFile);
    if (!aResSCH.isValidSchematron ())
      throw new IllegalArgumentException ("Invalid Schematron!");
    return aResSCH.applySchematronValidationToSVRL (new StreamSource (aXMLFile));
  }
}
