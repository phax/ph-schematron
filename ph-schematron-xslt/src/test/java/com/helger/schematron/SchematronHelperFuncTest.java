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
package com.helger.schematron;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.fail;

import javax.xml.transform.Source;

import org.junit.Test;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Test class for class {@link SchematronHelper}.
 *
 * @author Philip Helger
 */
public final class SchematronHelperFuncTest
{
  private static final String VALID_SCHEMATRON = "external/test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "external/test-xml/valid01.xml";

  @Test
  public void testReadValidSchematronValidXML () throws Exception
  {
    final ISchematronResource aSchematron = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON);
    final IReadableResource aXML = new ClassPathResource (VALID_XMLINSTANCE);
    final SchematronOutputType aSO = aSchematron.applySchematronValidationToSVRL (aXML);
    assertNotNull ("Failed to parse Schematron output", aSO);
  }

  @Test
  public void testReadValidSchematronInvalidXML () throws Exception
  {
    final SchematronOutputType aSO = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON)
                                                          .applySchematronValidationToSVRL (new ClassPathResource (VALID_XMLINSTANCE +
                                                                                                                   ".does.not.exist"));
    assertNull ("Invalid XML", aSO);
  }

  @Test
  public void testReadInvalidSchematronValidXML () throws Exception
  {
    final SchematronOutputType aSO = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON + ".does.not.exist")
                                                          .applySchematronValidationToSVRL (new ClassPathResource (VALID_XMLINSTANCE));
    assertNull ("Invalid Schematron", aSO);
  }

  @Test
  public void testReadInvalidSchematronInvalidXML () throws Exception
  {
    final SchematronOutputType aSO = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON + ".does.not.exist")
                                                          .applySchematronValidationToSVRL (new ClassPathResource (VALID_XMLINSTANCE +
                                                                                                                   ".does.not.exist"));
    assertNull ("Invalid Schematron and XML", aSO);
  }

  @Test
  public void testReadNull () throws Exception
  {
    try
    {
      // null-XML not allowed
      SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON).applySchematronValidationToSVRL ((IReadableResource) null);
      fail ();
    }
    catch (final NullPointerException ex)
    {
      /* expected */
    }

    try
    {
      // null-XML not allowed
      SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON).applySchematronValidationToSVRL ((Source) null);
      fail ();
    }
    catch (final NullPointerException ex)
    {
      /* expected */
    }
  }
}
