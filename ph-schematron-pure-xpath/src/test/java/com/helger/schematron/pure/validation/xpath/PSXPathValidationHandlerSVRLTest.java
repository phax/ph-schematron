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
package com.helger.schematron.pure.validation.xpath;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.nio.charset.StandardCharsets;

import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.helger.base.io.nonblocking.NonBlockingByteArrayInputStream;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.saxon.SaxonTinyTreeHelper;
import com.helger.schematron.saxon.SchematronProcessorFactory;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.XMLHelper;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Test class for class {@link PSXPathValidationHandlerSVRL}.
 *
 * @author Philip Helger
 */
public final class PSXPathValidationHandlerSVRLTest
{
  // Every element and every attribute named "x" fails an assert
  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                           "  <iso:ns prefix='a' uri='urn:a'/>\n" +
                                           "  <iso:pattern>\n" +
                                           "    <iso:rule context='*'>\n" +
                                           "      <iso:assert test='false()'>element</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "  <iso:pattern>\n" +
                                           "    <iso:rule context='@x'>\n" +
                                           "      <iso:assert test='false()'>attribute</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "</iso:schema>";

  // Siblings with the same local name in different namespaces, nested lists and mixed content
  private static final String XML = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                    "<root xmlns:a='urn:a' xmlns:b='urn:b'>\n" +
                                    "  <item/>\n" +
                                    "  <a:item x='1'/>\n" +
                                    "  <item><sub/><sub x='2'/><other/></item>\n" +
                                    "  <b:item/>\n" +
                                    "  text <!-- comment --> <?pi data?>\n" +
                                    "  <a:item><a:sub/></a:item>\n" +
                                    "  <b:item x='3'><item/></b:item>\n" +
                                    "  <single/>\n" +
                                    "  <item/>\n" +
                                    "</root>";

  @NonNull
  private static String _getExpectedPath (@NonNull final Node aNode, @NonNull final MapBasedNamespaceContext aNSCtx)
  {
    // Same settings as the uncached path creation of the SVRL handler
    return XMLHelper.pathToNodeBuilder ()
                    .node (aNode)
                    .separator ("/")
                    .excludeDocumentNode ()
                    .oneBasedIndex ()
                    .forceUseIndex (false)
                    .trailingSeparator (false)
                    .compareIncludingNamespaceURI (true)
                    .namespaceContext (aNSCtx)
                    .build ();
  }

  @NonNull
  private static ICommonsList <String> _getAllLocations (@NonNull final SchematronOutputType aSVRL)
  {
    final ICommonsList <String> ret = new CommonsArrayList <> ();
    for (final Object aObj : aSVRL.getActivePatternOrActiveGroupAndFiredRule ())
      if (aObj instanceof final FailedAssert aFA)
        ret.add (aFA.getLocation ());
    return ret;
  }

  @Test
  public void testLocationsAreIdenticalToXMLHelper () throws Exception
  {
    final Document aDoc = DOMReader.readXMLDOM (XML);
    assertNotNull (aDoc);

    // Expected: all elements in document order, then all "x" attributes in document order
    final MapBasedNamespaceContext aNSCtx = new MapBasedNamespaceContext ().addMapping ("a", "urn:a");
    final ICommonsList <String> aExpected = new CommonsArrayList <> ();
    final ICommonsList <Attr> aAttrs = new CommonsArrayList <> ();
    final NodeList aElements = aDoc.getElementsByTagNameNS ("*", "*");
    for (int i = 0; i < aElements.getLength (); ++i)
    {
      final Element aElement = (Element) aElements.item (i);
      aExpected.add (_getExpectedPath (aElement, aNSCtx));
      final NamedNodeMap aAttrMap = aElement.getAttributes ();
      for (int j = 0; j < aAttrMap.getLength (); ++j)
        if (aAttrMap.item (j).getNodeName ().equals ("x"))
          aAttrs.add ((Attr) aAttrMap.item (j));
    }
    for (final Attr aAttr : aAttrs)
      aExpected.add (_getExpectedPath (aAttr, aNSCtx));
    // Sanity check of the expectation itself
    assertEquals ("/root/item[1]", aExpected.get (1));
    assertEquals ("/root/a:item[1]", aExpected.get (2));
    assertEquals ("/root/item[2]/sub[2]", aExpected.get (5));
    assertEquals ("/root/item[2]/other", aExpected.get (6));

    final SchematronResourcePureXPath aSch = SchematronResourcePureXPath.builderFromString (SCHEMATRON).build ();

    // DOM input
    final SchematronOutputType aSVRL = aSch.applySchematronValidationToSVRL (aDoc, null);
    assertNotNull (aSVRL);
    assertEquals (aExpected, _getAllLocations (aSVRL));

    // The same handler class used a second time must not use the paths of the first document
    final Document aDoc2 = DOMReader.readXMLDOM ("<root><item/><item/></root>");
    assertNotNull (aDoc2);
    final SchematronOutputType aSVRL2 = aSch.applySchematronValidationToSVRL (aDoc2, null);
    assertEquals (new CommonsArrayList <> ("/root", "/root/item[1]", "/root/item[2]"), _getAllLocations (aSVRL2));

    // Saxon tree input - previously failed with an IllegalStateException
    final Document aFacade = SaxonTinyTreeHelper.buildDocumentFacade (SchematronProcessorFactory.getDefault (),
                                                                      new StreamSource (new NonBlockingByteArrayInputStream (XML.getBytes (StandardCharsets.UTF_8))));
    final SchematronOutputType aSVRL3 = aSch.applySchematronValidationToSVRL (aFacade, null);
    assertNotNull (aSVRL3);
    assertEquals (aExpected, _getAllLocations (aSVRL3));
  }
}
