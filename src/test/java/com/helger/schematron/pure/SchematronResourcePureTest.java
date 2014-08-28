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

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.commons.charset.CCharset;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.io.streams.StringInputStream;
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
}
