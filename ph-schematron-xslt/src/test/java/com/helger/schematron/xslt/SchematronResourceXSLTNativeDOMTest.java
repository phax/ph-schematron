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
package com.helger.schematron.xslt;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertSame;

import java.io.StringReader;

import javax.xml.transform.Transformer;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.helger.schematron.saxon.SaxonDOMSource;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Checks source semantics when a DOM document is copied to Saxon's native tree.
 *
 * @author Philip Helger
 */
public final class SchematronResourceXSLTNativeDOMTest
{
  private static final String XSLT = """
      <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:t="urn:test">
        <xsl:param name="message"/>
        <xsl:strip-space elements="*"/>
        <xsl:template match="/|root">
          <svrl:schematron-output>
            <svrl:active-pattern id="check" documents="{document-uri(.)}"/>
            <xsl:for-each select="//t:item">
              <svrl:fired-rule context="t:item"/>
              <svrl:failed-assert test="false()" id="failure" flag="fatal"
                  location="{concat(position(), ':', namespace-uri(.), ':', base-uri(.))}">
                <svrl:text><xsl:value-of select="concat($message, ':', @t:code, ':', string(.), ':',
                    count(id('item-id')), ':', string(document('extra.xml')/extra), ':',
                    count(../comment()), ':', count(../processing-instruction()))"/></svrl:text>
              </svrl:failed-assert>
              <svrl:successful-report test="true()" id="report" role="warning" location="item">
                <svrl:text>Report</svrl:text>
              </svrl:successful-report>
            </xsl:for-each>
          </svrl:schematron-output>
        </xsl:template>
      </xsl:stylesheet>
      """;

  private static void _assertMatchesWrappedDOM (final DOMSource aSource, final boolean bNative) throws Exception
  {
    final URIResolver aResolver = (sHref, sBase) -> new StreamSource (new StringReader ("<extra>resolved</extra>"));
    final SchematronResourceXSLT aResource = SchematronResourceXSLT.builderFromString (XSLT)
                                                                  .validateSVRL (false)
                                                                  .parameter ("message", "custom")
                                                                  .uriResolver (aResolver)
                                                                  .build ();
    // The raw transformer retains the previous wrapped-DOM behavior.
    final Transformer aOriginal = aResource.getXSLTProvider ().getXSLTTransformer ();
    aOriginal.setParameter ("message", "custom");
    aOriginal.setURIResolver (aResolver);
    final DOMResult aExpected = new DOMResult ();
    aOriginal.transform (aSource, aExpected);

    final var aMarshaller = new SVRLMarshaller ().setUseSchema (false);
    final var aExpectedSVRL = aMarshaller.read (aExpected.getNode ());
    assertNotNull (aExpectedSVRL);
    final DOMSource aActualSource = bNative ? new SaxonDOMSource (aSource.getNode (), aSource.getSystemId ()) : aSource;
    assertEquals (aExpectedSVRL, aResource.applySchematronValidationToSVRL (aActualSource));
  }

  @Test
  public void testDocumentSemantics () throws Exception
  {
    final Document aDoc = DOMReader.readXMLDOM ("""
        <root xmlns:t="urn:test" xml:base="nested/">
          <!-- preserved comment --><?preserved value?>
          <t:item id="item-id" t:code="A">text<![CDATA[ + cdata]]></t:item>
          <t:item xml:space="preserve" t:code="B">  whitespace  </t:item>
        </root>
        """);
    ((Element) aDoc.getElementsByTagNameNS ("urn:test", "item").item (0)).setIdAttribute ("id", true);
    // Keep regular DOMSource behavior even when its system ID differs from the DOM URI.
    _assertMatchesWrappedDOM (new DOMSource (aDoc, "https://example.org/input.xml"), false);
    aDoc.setDocumentURI ("https://example.org/document-uri.xml");
    _assertMatchesWrappedDOM (new DOMSource (aDoc), false);
    aDoc.getDocumentElement ().setAttributeNS ("http://www.w3.org/XML/1998/namespace",
                                             "xml:base",
                                             "https://example.org/nested/");
    _assertMatchesWrappedDOM (new DOMSource (aDoc, aDoc.getDocumentURI ()), true);
    aDoc.setDocumentURI (null);
    aDoc.getDocumentElement ().removeAttributeNS ("http://www.w3.org/XML/1998/namespace", "base");
    _assertMatchesWrappedDOM (new DOMSource (aDoc), true);
  }

  @Test
  public void testElementSource () throws Exception
  {
    final Document aDoc = DOMReader.readXMLDOM ("<root xmlns:t='urn:test'><t:item t:code='C'>child</t:item></root>");
    _assertMatchesWrappedDOM (new DOMSource (aDoc.getDocumentElement (), "https://example.org/element.xml"), false);
    _assertMatchesWrappedDOM (new DOMSource (aDoc.getDocumentElement ()), true);
  }

  @Test
  public void testRelativeBaseURIAndSourceReuse () throws Exception
  {
    final Document aDoc = DOMReader.readXMLDOM ("<root xml:base='nested/'><item>before</item></root>");
    final var aOriginalItem = aDoc.getDocumentElement ().getFirstChild ();
    final SaxonDOMSource aSource = new SaxonDOMSource (aDoc, "https://example.org/input.xml");
    final SchematronResourceXSLT aResource = SchematronResourceXSLT.builderFromString ("""
        <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
          <xsl:template match="/">
            <svrl:schematron-output title="{concat(base-uri(root/item), '|', root/item)}"/>
          </xsl:template>
        </xsl:stylesheet>
        """).build ();
    assertEquals ("https://example.org/nested/|before",
                  aResource.applySchematronValidation (aSource).getDocumentElement ().getAttribute ("title"));
    // Conversion neither changes the original DOM nor caches a stale snapshot.
    assertSame (aOriginalItem, aDoc.getDocumentElement ().getFirstChild ());
    assertEquals ("nested/", aDoc.getDocumentElement ().getAttribute ("xml:base"));
    aOriginalItem.setTextContent ("after");
    assertEquals ("https://example.org/nested/|after",
                  aResource.applySchematronValidation (aSource).getDocumentElement ().getAttribute ("title"));
  }
}
