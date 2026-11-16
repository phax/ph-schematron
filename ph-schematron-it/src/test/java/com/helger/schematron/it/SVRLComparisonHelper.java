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
package com.helger.schematron.it;

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
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.CommonsTreeMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
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
  private static final Pattern IS_A = Pattern.compile ("is-a=\"([^\"]+)\"");
  /**
   * A complete <code>generate-id()</code> value: Saxon on a wrapped DOM (<code>w84110aab7</code>),
   * Saxon on its own tree (<code>d84976e9</code>), phoxtrot (<code>d1n1</code>); phoxtrot suggestion
   * S37.
   */
  private static final Pattern GENERATED_ID = Pattern.compile ("\\b(?:w[0-9]+[a-z][0-9a-z]*|d[0-9]+e[0-9]+|d[0-9]+n[0-9]+)\\b");

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
   * of <code>generate-id()</code> are implementation-dependent (Saxon e.g. <code>w141aac11</code> on
   * a wrapped DOM, <code>d251e98</code> on its own tree, phoxtrot e.g. <code>d1n1</code>; phoxtrot
   * suggestion S37). Replace that part with a fixed text.
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
      ret = ret.replaceAll ("(?:w[0-9a-z]+|d[0-9]+e[0-9]+|d[0-9]+n[0-9]+)(" + Pattern.quote (sIsA) + ")", "GENERATED-ID$1");

    // Whole generated IDs (e.g. the template names, modes and keys of SchXslt) are numbered in the
    // order of their first occurrence, so that a different reference stays visible
    final ICommonsMap <String, String> aMapping = new CommonsHashMap <> ();
    final Matcher aMatcher = GENERATED_ID.matcher (ret);
    final StringBuilder aSB = new StringBuilder ();
    while (aMatcher.find ())
    {
      final String sReplacement = aMapping.computeIfAbsent (aMatcher.group (),
                                                            k -> "GENID-" + (aMapping.size () + 1));
      aMatcher.appendReplacement (aSB, sReplacement);
    }
    aMatcher.appendTail (aSB);
    return aSB.toString ();
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
