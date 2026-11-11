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
package com.helger.schematron.phoxtrot;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jspecify.annotations.NonNull;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.io.stream.StreamHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.CommonsTreeMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.collection.commons.ICommonsSortedMap;
import com.helger.io.resource.IReadableResource;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Helper for comparing the results of Saxon and phoxtrot.
 *
 * @author Philip Helger
 */
@Immutable
final class SVRLComparisonHelper
{
  /**
   * Saxon takes very long for these (see SchematronSCHCacheTest in ph-schematron-isosch), so they are only converted on
   * phoxtrot.
   */
  static final ICommonsSet <String> NO_SAXON_REFERENCE = new CommonsHashSet <> ("external/test-sch/biicore/BIICORE-UBL-T01.sch",
                                                                                        "external/test-sch/biicore/BIICORE-UBL-T10.sch",
                                                                                        "external/test-sch/biicore/BIICORE-UBL-T14.sch",
                                                                                        "external/test-sch/biicore/BIICORE-UBL-T15.sch");

  /**
   * The include step nests deeper than the phoxtrot limit of 10,000 levels, which the JAXP adapter
   * cannot raise yet (phoxtrot suggestion S35).
   */
  static final ICommonsSet <String> KNOWN_PHOXTROT_FAILURES = new CommonsHashSet <> ("external/test-sch/eugen/EUGEN-UBL-T14.sch",
                                                                                             "external/test-sch/eugen/EUGEN-UBL-T15.sch");

  private static final Pattern IS_A = Pattern.compile ("is-a=\"([^\"]+)\"");

  private SVRLComparisonHelper ()
  {}

  /**
   * @return All <code>is-a</code> values of the abstract pattern instances in the provided
   *         Schematron file (not in its includes).
   */
  @NonNull
  static ICommonsSet <String> getAllIsA (@NonNull final IReadableResource aSCH)
  {
    final ICommonsSet <String> ret = new CommonsHashSet <> ();
    final String sSCH = StreamHelper.getAllBytesAsString (aSCH, XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
    final Matcher aMatcher = IS_A.matcher (sSCH);
    while (aMatcher.find ())
      ret.add (aMatcher.group (1));
    return ret;
  }

  /**
   * The ISO Schematron pipeline builds the IDs of pattern instances as
   * <code>concat(generate-id(.), $is-a)</code> (<code>iso_abstract_expand.xsl</code>), and the values
   * of <code>generate-id()</code> are implementation-dependent (Saxon e.g. <code>w141aac11</code>,
   * phoxtrot e.g. <code>id1</code>). Replace that part with a fixed text.
   *
   * @param sText
   *        The text (an XSLT or SVRL) to normalise. May not be <code>null</code>.
   * @param aIsA
   *        The <code>is-a</code> values of the Schematron.
   * @return The normalised text.
   */
  @NonNull
  static String normaliseGeneratedIDs (@NonNull final String sText, @NonNull final ICommonsSet <String> aIsA)
  {
    String ret = sText;
    for (final String sIsA : aIsA)
      ret = ret.replaceAll ("(?:w[0-9a-z]+|id[0-9]+)(" + Pattern.quote (sIsA) + ")", "GENERATED-ID$1");
    return ret;
  }

  private static void _appendStartTag (@NonNull final Element aElement, @NonNull final StringBuilder aSB)
  {
    aSB.append ('<').append (aElement.getLocalName ());
    // Attributes in a fixed order
    final ICommonsSortedMap <String, String> aAttrs = new CommonsTreeMap <> ();
    final NamedNodeMap aAttrMap = aElement.getAttributes ();
    for (int i = 0; i < aAttrMap.getLength (); ++i)
    {
      final Attr aAttr = (Attr) aAttrMap.item (i);
      if (!"http://www.w3.org/2000/xmlns/".equals (aAttr.getNamespaceURI ()))
        aAttrs.put (aAttr.getName (), aAttr.getValue ());
    }
    aAttrs.forEach ( (k, v) -> aSB.append (' ').append (k).append ("=\"").append (v).append ('"'));
    aSB.append ('>');
  }

  private static void _appendRecursive (@NonNull final Element aElement, @NonNull final StringBuilder aSB)
  {
    _appendStartTag (aElement, aSB);
    for (Node aChild = aElement.getFirstChild (); aChild != null; aChild = aChild.getNextSibling ())
    {
      if (aChild instanceof final Element aChildElement)
        _appendRecursive (aChildElement, aSB);
      else
        if (aChild.getNodeType () == Node.TEXT_NODE || aChild.getNodeType () == Node.CDATA_SECTION_NODE)
        {
          final String sText = aChild.getNodeValue ();
          // Whitespace between elements is not relevant
          if (!sText.isBlank ())
            aSB.append (sText);
        }
    }
    aSB.append ("</").append (aElement.getLocalName ()).append ('>');
  }

  /**
   * Get the SVRL as one canonical line per child element of the root element, in document order:
   * element name, all attributes sorted by name, then the content (elements recursively, text as it
   * is; whitespace-only text is ignored).
   *
   * @param aSVRL
   *        The SVRL document. May not be <code>null</code>.
   * @return The lines. Never <code>null</code>.
   */
  @NonNull
  static ICommonsList <String> getCanonicalEntries (@NonNull final Document aSVRL)
  {
    final ICommonsList <String> ret = new CommonsArrayList <> ();
    final Element aRoot = aSVRL.getDocumentElement ();
    final StringBuilder aRootSB = new StringBuilder ();
    _appendStartTag (aRoot, aRootSB);
    ret.add (aRootSB.toString ());
    for (Node aChild = aRoot.getFirstChild (); aChild != null; aChild = aChild.getNextSibling ())
      if (aChild instanceof final Element aChildElement)
      {
        final StringBuilder aSB = new StringBuilder ();
        _appendRecursive (aChildElement, aSB);
        ret.add (aSB.toString ());
      }
    return ret;
  }
}
