/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.xslt.SchematronResourceSCH;

/**
 * Test class for class {@link SVRLWriter}.
 *
 * @author Philip Helger
 */
public final class SVRLWriterTest
{
  private static final String VALID_SCHEMATRON = "test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "test-xml/valid01.xml";

  @Test
  public void testWriteValid () throws Exception
  {
    final Document aDoc = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON)
                                               .applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
    assertNotNull (aDoc);
    final SchematronOutputType aSO = SVRLReader.readXML (aDoc);

    // Create XML
    final Document aDoc2 = SVRLWriter.createXML (aSO);
    assertNotNull (aDoc2);
    assertEquals (CSVRL.SVRL_NAMESPACE_URI, aDoc2.getDocumentElement ().getNamespaceURI ());

    // Create String
    final String sDoc2 = SVRLWriter.createXMLString (aSO);
    assertTrue (StringHelper.hasText (sDoc2));
    assertTrue (sDoc2.contains (CSVRL.SVRL_NAMESPACE_URI));
  }
}
