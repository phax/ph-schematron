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
package com.helger.schematron.pure.supplementary;

import java.io.File;

import javax.xml.transform.stream.StreamSource;

import org.junit.Test;

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;

public final class IssueGC4Test
{
  private static final String PATH_SCH = "src/test/resources/external/issues/gc4/UBL-TR_Main_Schematron.xml";
  private static final String PATH_XML = "src/test/resources/external/issues/gc4/1_TEMEL_FATURA_ZARF.xml";

  @Test
  public void testIssue () throws Exception
  {
    System.out.println (validateXMLViaPureSchematron (new File (PATH_SCH), new File (PATH_XML)));
  }

  public static boolean validateXMLViaPureSchematron (final File aSchematronFile, final File aXMLFile) throws Exception
  {
    final ISchematronResource aResPure = SchematronResourcePure.fromFile (aSchematronFile);

    System.out.println ("Valid Şematron mu? " + aResPure.isValidSchematron ());
    // if (!aResPure.isValidSchematron())
    // throw new IllegalArgumentException("Invalid Schematron!");

    return aResPure.getSchematronValidity (new StreamSource (aXMLFile)).isValid ();
  }
}
