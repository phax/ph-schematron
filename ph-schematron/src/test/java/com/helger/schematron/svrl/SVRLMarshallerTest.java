/**
 * Copyright (C) 2014-2019 Philip Helger (www.helger.com)
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
package com.helger.schematron.svrl;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.schematron.xslt.SchematronResourceSCH;
import com.helger.xml.XMLFactory;

/**
 * Test class for class {@link SVRLMarshaller}.
 *
 * @author Philip Helger
 */
public final class SVRLMarshallerTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SVRLMarshallerTest.class);
  private static final String VALID_SCHEMATRON = "test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "test-xml/valid01.xml";

  @Test
  public void testCreate () throws Exception
  {
    final ISchematronResource aSV = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON);
    assertNotNull ("Failed to parse Schematron", aSV);
    final Document aDoc = aSV.applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
    assertNotNull ("Failed to parse demo XML", aDoc);

    final SchematronOutputType aSO = new SVRLMarshaller ().read (aDoc);
    assertNotNull ("Failed to parse Schematron output", aSO);
  }

  @Test
  public void testRead ()
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSVRLFiles ())
    {
      LOGGER.info ("Reading " + aRes.getPath ());
      assertNotNull (aRes.getPath (), new SVRLMarshaller ().read (aRes));
    }
  }

  @Test
  public void testReadInvalidSchematron ()
  {
    try
    {
      // Read null
      new SVRLMarshaller ().read ((Node) null);
      fail ();
    }
    catch (final NullPointerException ex)
    {}

    try
    {
      // Read empty XML
      new SVRLMarshaller ().read (XMLFactory.newDocument ());
      fail ();
    }
    catch (final NullPointerException ex)
    {}

    // Read XML that is not SVRL
    final SchematronOutputType aSVRL = new SVRLMarshaller ().read (new ClassPathResource ("test-xml/goodOrder01.xml"));
    assertNull (aSVRL);
  }

  @Test
  public void testWriteValid () throws Exception
  {
    final Document aDoc = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON)
                                               .applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
    assertNotNull (aDoc);
    final SchematronOutputType aSO = new SVRLMarshaller ().read (aDoc);

    // Create XML
    final Document aDoc2 = new SVRLMarshaller ().getAsDocument (aSO);
    assertNotNull (aDoc2);
    assertEquals (CSVRL.SVRL_NAMESPACE_URI, aDoc2.getDocumentElement ().getNamespaceURI ());

    // Create String
    final String sDoc2 = new SVRLMarshaller ().getAsString (aSO);
    assertTrue (StringHelper.hasText (sDoc2));
    assertTrue (sDoc2.contains (CSVRL.SVRL_NAMESPACE_URI));
  }
}
