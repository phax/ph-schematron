/**
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.fail;

import org.junit.Test;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import com.helger.commons.io.IReadableResource;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.xml.XMLFactory;
import com.helger.commons.xml.serialize.DOMReader;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.xslt.SchematronResourceSCH;
import com.helger.schematrontest.SchematronTestHelper;

/**
 * Test class for class {@link SVRLReader}.
 *
 * @author Philip Helger
 */
public final class SVRLReaderTest
{
  private static final String VALID_SCHEMATRON = "test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "test-xml/valid01.xml";

  @Test
  public void testCreate () throws Exception
  {
    final ISchematronResource aSV = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON);
    assertNotNull ("Failed to parse Schematron", aSV);
    final Document aDoc = aSV.applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
    assertNotNull ("Failed to parse demo XML", aDoc);

    final SchematronOutputType aSO = SVRLReader.readXML (aDoc);
    assertNotNull ("Failed to parse Schematron output", aSO);
  }

  @Test
  public void testRead () throws SAXException
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSVRLFiles ())
      assertNotNull (aRes.getPath (), SVRLReader.readXML (DOMReader.readXMLDOM (aRes)));
  }

  @Test
  public void testReadInvalidSchematron ()
  {
    try
    {
      // Read null
      SVRLReader.readXML ((Node) null);
      fail ();
    }
    catch (final NullPointerException ex)
    {}

    try
    {
      // Read empty XML
      SVRLReader.readXML (XMLFactory.newDocument ());
      fail ();
    }
    catch (final NullPointerException ex)
    {}

    // Read XML that is not SVRL
    final SchematronOutputType aSVRL = SVRLReader.readXML (new ClassPathResource ("test-xml/goodOrder01.xml"));
    assertNull (aSVRL);
  }
}
