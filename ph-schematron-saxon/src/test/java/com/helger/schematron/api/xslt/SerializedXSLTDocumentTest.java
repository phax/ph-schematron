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
package com.helger.schematron.api.xslt;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import javax.xml.transform.TransformerException;

import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.helger.xml.XMLFactory;

/**
 * Test class for class {@link SerializedXSLTDocument}.
 *
 * @author Philip Helger
 */
public final class SerializedXSLTDocumentTest
{
  private static final String XSLT_NS = "http://www.w3.org/1999/XSL/Transform";
  private static final String CBC_NS = "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2";

  @Test
  public void testNamespaceOnlyUsedInAttributeValueIsRetained () throws TransformerException
  {
    final Document aDoc = XMLFactory.newDocument ();
    final Element aStylesheet = aDoc.createElementNS (XSLT_NS, "xsl:stylesheet");
    aStylesheet.setAttribute ("version", "2.0");
    // The "cbc" prefix is only used inside an XPath expression
    aStylesheet.setAttributeNS ("http://www.w3.org/2000/xmlns/", "xmlns:cbc", CBC_NS);
    aDoc.appendChild (aStylesheet);
    final Element aTemplate = aDoc.createElementNS (XSLT_NS, "xsl:template");
    aTemplate.setAttribute ("match", "cbc:ID");
    aStylesheet.appendChild (aTemplate);

    final SerializedXSLTDocument aSerialized = SerializedXSLTDocument.create (aDoc);
    assertTrue (aSerialized.getByteCount () > 0);

    final Document aParsed = aSerialized.getDocument ();
    assertNotNull (aParsed);
    // Parsed only once
    assertSame (aParsed, aSerialized.getDocument ());

    final Element aRoot = aParsed.getDocumentElement ();
    assertEquals (XSLT_NS, aRoot.getNamespaceURI ());
    assertEquals ("stylesheet", aRoot.getLocalName ());
    assertEquals (CBC_NS, aRoot.lookupNamespaceURI ("cbc"));
    assertEquals ("cbc:ID", ((Element) aRoot.getElementsByTagNameNS (XSLT_NS, "template").item (0)).getAttribute ("match"));
  }
}
