/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;

import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.SchematronHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.transform.TransformSourceFactory;

/**
 * Test class for class {@link SchematronHelper}.
 *
 * @author Philip Helger
 */
public final class SchematronHelperTest
{
  private static final String VALID_SCHEMATRON = "external/test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "external/test-xml/valid01.xml";

  @Test
  public void testReadValidSchematronValidXMLFromFile () throws Exception
  {
    final ISchematronResource aSchematron = SchematronResourcePure.fromClassPath (VALID_SCHEMATRON);
    final IReadableResource aXML = new ClassPathResource (VALID_XMLINSTANCE);
    final SchematronOutputType aSO = aSchematron.applySchematronValidationToSVRL (TransformSourceFactory.create (aXML));
    assertNotNull ("Failed to parse Schematron output", aSO);
  }
}
