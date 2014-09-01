/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
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
package com.helger.schematron.pure;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import javax.xml.namespace.QName;
import javax.xml.xpath.XPathFunction;
import javax.xml.xpath.XPathFunctionResolver;

import org.junit.Test;
import org.xml.sax.SAXException;

import com.helger.commons.charset.CCharset;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.io.streams.StringInputStream;
import com.helger.commons.xml.serialize.DOMReader;
import com.helger.commons.xml.xpath.MapBasedXPathVariableResolver;
import com.helger.schematron.SchematronException;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematrontest.SchematronTestHelper;

/**
 * Test class for class {@link SchematronResourcePure}.
 *
 * @author Philip Helger
 */
public final class SchematronResourcePureTest
{
  @Test
  public void testBasic () throws Exception
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      // The validity is tested in another test case!
      // Parse them
      final SchematronResourcePure aResPure = new SchematronResourcePure (aRes);
      assertTrue (aRes.getPath (), aResPure.isValidSchematron ());
    }
  }

  @Test
  public void testFromByteArray ()
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\r\n"
                         + "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \r\n"
                         + "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \r\n"
                         + "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\r\n"
                         + "         queryBinding='xslt2'\r\n"
                         + "         schemaVersion=\"ISO19757-3\">\r\n"
                         + "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\r\n"
                         + "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\r\n"
                         + " <iso:pattern >\r\n"
                         + "    <iso:title>A very simple pattern with a title</iso:title>\r\n"
                         + "    <iso:rule context=\"chapter\">\r\n"
                         + "      <iso:assert test=\"title\">Chapter should have a title</iso:assert>\r\n"
                         + "      <iso:report test=\"count(para)\">\r\n"
                         + "      <iso:value-of select=\"count(para)\"/> paragraphs</iso:report>\r\n"
                         + "    </iso:rule>\r\n"
                         + "  </iso:pattern>\r\n"
                         + "\r\n"
                         + "</iso:schema>";
    assertTrue (SchematronResourcePure.fromByteArray (sTest.getBytes (CCharset.CHARSET_ISO_8859_1_OBJ))
                                      .isValidSchematron ());
    assertTrue (SchematronResourcePure.fromInputStream (new StringInputStream (sTest, CCharset.CHARSET_ISO_8859_1_OBJ))
                                      .isValidSchematron ());
  }

  @Test
  public void testParseWithXPathError ()
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\r\n"
                         + "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \r\n"
                         + "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \r\n"
                         + "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\r\n"
                         + "         queryBinding='xslt2'\r\n"
                         + "         schemaVersion=\"ISO19757-3\">\r\n"
                         + "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\r\n"
                         + "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\r\n"
                         + " <iso:pattern >\r\n"
                         + "    <iso:title>A very simple pattern with a title</iso:title>\r\n"
                         + "    <iso:rule context=\"chapter\">\r\n"
                         // This line contains the XPath error
                         + "      <iso:assert test=\"title xor 55\">Chapter should have a title</iso:assert>\r\n"
                         + "      <iso:report test=\"count(para)\">\r\n"
                         + "      <iso:value-of select=\"count(para)\"/> paragraphs</iso:report>\r\n"
                         + "    </iso:rule>\r\n"
                         + "  </iso:pattern>\r\n"
                         + "\r\n"
                         + "</iso:schema>";
    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();
    assertFalse (SchematronResourcePure.fromByteArray (sTest.getBytes (CCharset.CHARSET_ISO_8859_1_OBJ))
                                       .setErrorHandler (aErrorHandler)
                                       .isValidSchematron ());
    assertEquals ("Expected only one error: " + aErrorHandler.getResourceErrors ().toString (),
                  1,
                  aErrorHandler.getResourceErrors ().size ());
    System.out.println (aErrorHandler.getResourceErrors ().toString ());
  }

  @Test
  public void testResolveVariables () throws SchematronException, SAXException
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\r\n"
                         + "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \r\n"
                         + "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \r\n"
                         + "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\r\n"
                         + "         queryBinding='xslt2'\r\n"
                         + "         schemaVersion=\"ISO19757-3\">\r\n"
                         + "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\r\n"
                         + "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\r\n"
                         + "  <iso:pattern >\r\n"
                         + "    <iso:title>A very simple pattern with a title</iso:title>\r\n"
                         + "    <iso:rule context=\"chapter\">\r\n"
                         + "      <iso:assert test=\"$title-element\">Chapter should have a title</iso:assert>\r\n"
                         + "      <iso:report test=\"dp:count(para)\">\r\n"
                         + "      <iso:value-of select=\"count(para)\"/> paragraphs</iso:report>\r\n"
                         + "    </iso:rule>\r\n"
                         + "  </iso:pattern>\r\n"
                         + "\r\n"
                         + "</iso:schema>";
    assertFalse (SchematronResourcePure.fromString (sTest, CCharset.CHARSET_ISO_8859_1_OBJ).isValidSchematron ());
    final MapBasedXPathVariableResolver aVarResolver = new MapBasedXPathVariableResolver ();
    aVarResolver.addUniqueVariable ("title-element", "title");

    final XPathFunctionResolver aFunctionResolver = new XPathFunctionResolver ()
    {
      public XPathFunction resolveFunction (final QName functionName, final int arity)
      {
        System.out.println (functionName.getNamespaceURI () + "::" + functionName.getLocalPart () + " " + arity);
        return null;
      }
    };
    assertNotNull (SchematronResourcePure.fromString (sTest, CCharset.CHARSET_ISO_8859_1_OBJ)
                                         .setVariableResolver (aVarResolver)
                                         .setFunctionResolver (aFunctionResolver)
                                         .applySchematronValidation (DOMReader.readXMLDOM ("<?xml version='1.0'?><chapter><title /></chapter>")));
  }
}
