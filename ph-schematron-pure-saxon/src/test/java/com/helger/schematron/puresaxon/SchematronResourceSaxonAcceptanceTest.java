/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.puresaxon;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import javax.xml.transform.Source;

import org.junit.Test;

import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Acceptance test for {@link SchematronResourceSaxon} ported from
 * {@code com.helger.schematron.SchematronResourceSCHTest} in {@code ph-schematron-xslt}. Same
 * happy-path / null-edge-case coverage adapted to the Saxon-native engine.
 *
 * @author Philip Helger
 */
public final class SchematronResourceSaxonAcceptanceTest
{
  private static final String VALID_SCHEMATRON = "external/test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "external/test-xml/valid01.xml";

  @Test
  public void testReadValidSchematronValidXML () throws Exception
  {
    final ISchematronResource aSchematron = SchematronResourceSaxon.fromClassPath (VALID_SCHEMATRON);
    final IReadableResource aXML = new ClassPathResource (VALID_XMLINSTANCE);
    final SchematronOutputType aSO = aSchematron.applySchematronValidationToSVRL (aXML);
    assertNotNull ("Failed to parse Schematron output", aSO);
  }

  @Test
  public void testReadValidSchematronInvalidXML () throws Exception
  {
    final SchematronOutputType aSO = SchematronResourceSaxon.fromClassPath (VALID_SCHEMATRON)
                                                            .applySchematronValidationToSVRL (new ClassPathResource (VALID_XMLINSTANCE +
                                                                                                                     ".does.not.exist"));
    assertNull ("Invalid XML", aSO);
  }

  @Test
  public void testReadInvalidSchematronValidXML () throws Exception
  {
    try
    {
      SchematronResourceSaxon.fromClassPath (VALID_SCHEMATRON + ".does.not.exist")
                             .applySchematronValidationToSVRL (new ClassPathResource (VALID_XMLINSTANCE));
      fail ("Expected an exception or a null result when the Schematron source is missing");
    }
    catch (final Exception ex)
    {
      /* expected: PSReader cannot read a non-existent SCH and surfaces it */
    }
  }

  @Test
  public void testReadNull ()
  {
    try
    {
      SchematronResourceSaxon.fromClassPath (VALID_SCHEMATRON).applySchematronValidationToSVRL ((IReadableResource) null);
      fail ();
    }
    catch (final Exception ex)
    {
      /* expected */
    }

    try
    {
      SchematronResourceSaxon.fromClassPath (VALID_SCHEMATRON).applySchematronValidationToSVRL ((Source) null);
      fail ();
    }
    catch (final Exception ex)
    {
      /* expected */
    }
  }

  @Test
  public void testReadISOSchematron2006SCH ()
  {
    final SchematronResourceSaxon aSch = SchematronResourceSaxon.fromClassPath ("external/schematron/iso-schematron-2006.sch");
    assertTrue (aSch.isValidSchematron ());
  }

  @Test
  public void testReadISOSchematron2016SCH ()
  {
    final SchematronResourceSaxon aSch = SchematronResourceSaxon.fromClassPath ("external/schematron/iso-schematron-2016.sch");
    assertTrue (aSch.isValidSchematron ());
  }
}
