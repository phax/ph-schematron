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
package com.helger.schematron.xslt;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;

import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.stream.NonBlockingByteArrayInputStream;
import com.helger.commons.io.stream.StreamHelper;

/**
 * Test class for class {@link SchematronResourceXSLT}.
 *
 * @author Philip Helger
 */
public final class SchematronResourceXSLTTest
{
  private static final ClassPathResource VALID_XSLT_SCHEMATRON = new ClassPathResource ("external/test-xslt/valid01.xslt");
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("external/test-xml/valid01.xml");

  @Test
  public void testFromUrl () throws Exception
  {
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromURL (VALID_XSLT_SCHEMATRON.getAsURL ());
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromStringUrl () throws Exception
  {
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromURL (VALID_XSLT_SCHEMATRON.getAsURL ()
                                                                                            .toExternalForm ());
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromInputStream () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromInputStream ("mock-res-id",
                                                                               new NonBlockingByteArrayInputStream (aPayload));
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromByteArray () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromByteArray (aPayload);
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromString () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.fromString (new String (aPayload, StandardCharsets.UTF_8),
                                                                          StandardCharsets.UTF_8);
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }
}
