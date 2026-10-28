/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.exchange;

import java.util.Map;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.collection.commons.ICommonsSet;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronXML;
import com.helger.schematron.ESchematronVersion;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSDiagnostic;
import com.helger.schematron.model.PSDiagnostics;
import com.helger.schematron.model.PSLet;
import com.helger.schematron.model.PSLinkableGroup;
import com.helger.schematron.model.PSNS;
import com.helger.schematron.model.PSName;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSProperties;
import com.helger.schematron.model.PSProperty;
import com.helger.schematron.model.PSRichGroup;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSTitle;
import com.helger.schematron.model.PSValueOf;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.microdom.IMicroComment;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.IMicroNode;
import com.helger.xml.microdom.IMicroText;
import com.helger.xml.microdom.serialize.MicroReader;

/**
 * Reverse engineers a {@link PSSchema} from an XSLT that was created from a Schematron by the ISO
 * Schematron XSLT pipeline (<code>iso_svrl_for_xslt1.xsl</code> /
 * <code>iso_svrl_for_xslt2.xsl</code> as used by ph-schematron), by SchXslt 1.x or by SchXslt2. The
 * result can be serialized to a <code>.sch</code> file using {@link PSWriter}.<br>
 * The conversion is necessarily lossy, because the original Schematron is not stored in the XSLT:
 * <ul>
 * <li>Included files and abstract patterns/rules are already expanded. Every instance of an
 * abstract pattern becomes a separate regular pattern with the parameters replaced.</li>
 * <li>Phases are not contained in the XSLT, because only the patterns of the selected phase were
 * compiled. All patterns found are written without any phase.</li>
 * <li>Documentation elements (<code>p</code>, <code>emph</code>, <code>dir</code>,
 * <code>span</code>) are dropped; <code>emph</code>, <code>dir</code> and <code>span</code> content
 * is kept as plain text.</li>
 * <li>Comments, the <code>see</code>, <code>icon</code> and <code>fpi</code> attributes and
 * attributes not known to the skeleton are only retained if they are part of the SVRL output.</li>
 * <li>The pattern title cannot be distinguished from the pattern ID in the generated comment, so
 * the title is taken from the SVRL text of the pattern.</li>
 * </ul>
 * What is retained: namespace prefixes, schema title and version, global and pattern
 * <code>let</code> elements, pattern IDs, rule contexts, IDs, flags and roles, rule level
 * <code>let</code> elements, assert/report tests, IDs, flags, roles, messages (including
 * <code>name</code> and <code>value-of</code>), diagnostics, properties as well as top-level
 * <code>xsl:function</code> and <code>xsl:key</code> declarations.<br>
 * Differences for SchXslt and SchXslt2: pattern level lets are global variables in the XSLT and
 * therefore become schema level lets. SchXslt 1.x drops <code>xsl:function</code> and
 * <code>xsl:key</code> declarations of the schema, so they cannot be restored. The query binding is
 * always <code>xslt2</code> because the XSLT version does not tell the binding.
 *
 * @author Philip Helger
 * @since 10.3.0
 */
@NotThreadSafe
public class PSXsltReader
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PSXsltReader.class);

  private static final String ELEMENT_ACTIVE_PATTERN = "active-pattern";
  private static final String ELEMENT_APPLY_TEMPLATES = "apply-templates";
  private static final String ELEMENT_ATTRIBUTE = "attribute";
  private static final String ELEMENT_CHOOSE = "choose";
  private static final String ELEMENT_DIAGNOSTIC_REFERENCE = "diagnostic-reference";
  private static final String ELEMENT_FAILED_ASSERT = "failed-assert";
  private static final String ELEMENT_FIRED_RULE = "fired-rule";
  private static final String ELEMENT_FUNCTION = "function";
  private static final String ELEMENT_IF = "if";
  private static final String ELEMENT_KEY = "key";
  private static final String ELEMENT_NS_PREFIX = "ns-prefix-in-attribute-values";
  private static final String ELEMENT_OTHERWISE = "otherwise";
  private static final String ELEMENT_PARAM = "param";
  private static final String ELEMENT_PROPERTY = "property";
  private static final String ELEMENT_PROPERTY_REFERENCE = "property-reference";
  private static final String ELEMENT_SCHEMATRON_OUTPUT = "schematron-output";
  private static final String ELEMENT_STYLESHEET = "stylesheet";
  private static final String ELEMENT_SUCCESSFUL_REPORT = "successful-report";
  private static final String ELEMENT_TEMPLATE = "template";
  private static final String ELEMENT_TEXT = "text";
  private static final String ELEMENT_TRANSFORM = "transform";
  private static final String ELEMENT_VARIABLE = "variable";
  private static final String ELEMENT_WHEN = "when";

  private static final String ATTR_DIAGNOSTIC = "diagnostic";
  private static final String ATTR_MATCH = "match";
  private static final String ATTR_MODE = "mode";
  private static final String ATTR_PROPERTY = "property";
  private static final String ATTR_TITLE = "title";
  private static final String ATTR_VERSION = "version";

  private static final String ELEMENT_FOR_EACH = "for-each";
  private static final String ELEMENT_NEXT_MATCH = "next-match";
  private static final String ELEMENT_WITH_PARAM = "with-param";
  private static final String ELEMENT_SCHXSLT_PATTERN = "pattern";
  private static final String ATTR_AS = "as";
  private static final String ATTR_PATTERN = "pattern";
  private static final String ATTR_PATTERN_ID = "patternId";
  private static final String ATTR_SELECT = "select";
  private static final String NS_SCHXSLT1 = "https://doi.org/10.5281/zenodo.1495494";
  private static final String SCHXSLT_MARKER = "schxslt";

  private static final String COMMENT_PATTERN_PREFIX = "PATTERN";
  private static final String NAME_FUNCTION_PREFIX = "name(";

  /** Global declarations that are part of each generated XSLT and don't originate from a let */
  private static final ICommonsSet <String> SKELETON_GLOBALS = new CommonsHashSet <> ("archiveDirParameter",
                                                                                      "archiveNameParameter",
                                                                                      "fileNameParameter",
                                                                                      "fileDirParameter",
                                                                                      "document-uri",
                                                                                      "phase",
                                                                                      "langCode");

  /** The match patterns of the default templates at the end of each pattern */
  private static final ICommonsSet <String> DEFAULT_MATCHES = new CommonsHashSet <> ("text()", "@*|node()");

  private final IReadableResource m_aResource;
  private final ICommonsOrderedMap <String, PSDiagnostic> m_aDiagnostics = new CommonsLinkedHashMap <> ();
  private final ICommonsOrderedMap <String, PSProperty> m_aProperties = new CommonsLinkedHashMap <> ();

  /**
   * Constructor
   *
   * @param aResource
   *        The XSLT resource to read. May not be <code>null</code>.
   */
  public PSXsltReader (@NonNull final IReadableResource aResource)
  {
    ValueEnforcer.notNull (aResource, "Resource");
    m_aResource = aResource;
  }

  /**
   * @return The resource from which the XSLT is read. Never <code>null</code>.
   */
  @NonNull
  public final IReadableResource getResource ()
  {
    return m_aResource;
  }

  private static boolean _is (@NonNull final IMicroElement aElement,
                              @NonNull final String sNamespaceURI,
                              @NonNull final String sLocalName)
  {
    return aElement.hasNamespaceURI (sNamespaceURI) && aElement.getLocalName ().equals (sLocalName);
  }

  private static boolean _isXsl (@NonNull final IMicroElement aElement, @NonNull final String sLocalName)
  {
    return _is (aElement, CSchematron.NAMESPACE_URI_XSL, sLocalName);
  }

  private static boolean _isSvrl (@NonNull final IMicroElement aElement, @NonNull final String sLocalName)
  {
    return _is (aElement, CSVRL.SVRL_NAMESPACE_URI, sLocalName);
  }

  @Nullable
  private static IMicroElement _getFirstChildSvrl (@NonNull final IMicroElement aParent,
                                                   @NonNull final String sLocalName)
  {
    return aParent.getFirstChildElement (CSVRL.SVRL_NAMESPACE_URI, sLocalName);
  }

  /**
   * Get the literal attributes and the attributes created with a simple
   * <code>&lt;xsl:attribute name="x"&gt;value&lt;/xsl:attribute&gt;</code> of an SVRL element.
   * Attributes created by an XSLT instruction (like <code>location</code>) are ignored.
   */
  @NonNull
  private static ICommonsOrderedMap <String, String> _getSvrlAttributes (@NonNull final IMicroElement eSvrl)
  {
    final ICommonsOrderedMap <String, String> ret = new CommonsLinkedHashMap <> ();
    eSvrl.forAllAttributes ((sNS, sAttrName, sVal) -> ret.put (sAttrName, sVal));
    eSvrl.forAllChildElements (eChild -> {
      if (_isXsl (eChild, ELEMENT_ATTRIBUTE) && !eChild.hasChildElements ())
      {
        final String sAttrName = eChild.getAttributeValue (CSchematronXML.ATTR_NAME);
        if (StringHelper.isNotEmpty (sAttrName))
          ret.put (sAttrName, eChild.getTextContent ());
      }
    });
    return ret;
  }

  private static void _applyRichAndLinkable (@NonNull final ICommonsOrderedMap <String, String> aAttrs,
                                             @NonNull final Consumer <PSRichGroup> aRichSetter,
                                             @NonNull final Consumer <PSLinkableGroup> aLinkableSetter)
  {
    final PSRichGroup aRich = new PSRichGroup ();
    final PSLinkableGroup aLinkable = new PSLinkableGroup ();
    boolean bAnyRich = false;
    boolean bAnyLinkable = false;
    for (final Map.Entry <String, String> aEntry : aAttrs.entrySet ())
    {
      final String sAttrName = aEntry.getKey ();
      final String sAttrValue = aEntry.getValue ();
      if (sAttrName.equals (CSchematronXML.ATTR_ICON))
      {
        aRich.setIcon (sAttrValue);
        bAnyRich = true;
      }
      else
        if (sAttrName.equals (CSchematronXML.ATTR_SEE))
        {
          aRich.setSee (sAttrValue);
          bAnyRich = true;
        }
        else
          if (sAttrName.equals (CSchematronXML.ATTR_FPI))
          {
            aRich.setFPI (sAttrValue);
            bAnyRich = true;
          }
          else
            if (sAttrName.equals (CSchematronXML.ATTR_ROLE))
            {
              aLinkable.setRole (sAttrValue);
              bAnyLinkable = true;
            }
            else
              if (sAttrName.equals (CSchematronXML.ATTR_SUBJECT))
              {
                aLinkable.setSubject (sAttrValue);
                bAnyLinkable = true;
              }
    }
    if (bAnyRich)
      aRichSetter.accept (aRich);
    if (bAnyLinkable)
      aLinkableSetter.accept (aLinkable);
  }

  /**
   * Split <code>name(path)</code> into the path. The skeleton creates <code>name(.)</code> for
   * <code>&lt;name/&gt;</code> and <code>name(path)</code> for
   * <code>&lt;name path="path"/&gt;</code>.
   *
   * @return <code>null</code> if the select expression is not exactly one call to <code>name</code>
   */
  @Nullable
  private static String _getNamePath (@NonNull final String sSelect)
  {
    final String sTrimmed = sSelect.trim ();
    if (sTrimmed.equals ("name()"))
      return ".";
    if (!sTrimmed.startsWith (NAME_FUNCTION_PREFIX) || !sTrimmed.endsWith (")"))
      return null;

    // The opening parenthesis must be closed by the last character
    int nDepth = 0;
    for (int i = NAME_FUNCTION_PREFIX.length () - 1; i < sTrimmed.length (); ++i)
    {
      final char c = sTrimmed.charAt (i);
      if (c == '(')
        nDepth++;
      else
        if (c == ')')
        {
          nDepth--;
          if (nDepth == 0 && i < sTrimmed.length () - 1)
            return null;
        }
    }
    return sTrimmed.substring (NAME_FUNCTION_PREFIX.length (), sTrimmed.length () - 1);
  }

  private static void _addText (@NonNull final ICommonsList <Object> aTarget, @Nullable final String sText)
  {
    if (StringHelper.isEmpty (sText))
      return;
    final int nLast = aTarget.size () - 1;
    if (nLast >= 0 && aTarget.get (nLast) instanceof final String sPrev)
      aTarget.set (nLast, sPrev + sText);
    else
      aTarget.add (sText);
  }

  /**
   * Convert the mixed content of an SVRL text (or a copied Schematron element) to a list of
   * {@link String}, {@link PSName} and {@link PSValueOf}.
   */
  private static void _readContentRecursive (@NonNull final IMicroElement eParent,
                                             @NonNull final ICommonsList <Object> aTarget)
  {
    eParent.forAllChildren (aChild -> {
      if (aChild.isText ())
      {
        final String sText = ((IMicroText) aChild).getData ().toString ();
        // Whitespace that only exists because of pretty printing
        if (!(sText.isBlank () && sText.indexOf ('\n') >= 0))
          _addText (aTarget, sText);
      }
      else
        if (aChild.isElement ())
        {
          final IMicroElement eChild = (IMicroElement) aChild;
          if (_isXsl (eChild, ELEMENT_TEXT))
            _addText (aTarget, eChild.getTextContent ());
          else
            if (_isXsl (eChild, ELEMENT_FOR_EACH) ||
                _isSvrl (eChild, CSchematronXML.ELEMENT_EMPH) ||
                _isSvrl (eChild, CSchematronXML.ELEMENT_DIR) ||
                _isSvrl (eChild, CSchematronXML.ELEMENT_SPAN))
              _readContentRecursive (eChild, aTarget);
            else
              if (_isXsl (eChild, CSchematronXML.ELEMENT_VALUE_OF))
              {
                final String sSelect = eChild.getAttributeValue (CSchematronXML.ATTR_SELECT);
                final String sNamePath = sSelect == null ? null : _getNamePath (sSelect);
                if (sNamePath == null)
                  aTarget.add (PSValueOf.ofSelect (sSelect));
                else
                  aTarget.add (sNamePath.equals (".") ? new PSName () : PSName.ofPath (sNamePath));
              }
              else
                if (_is (eChild, CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_VALUE_OF))
                  aTarget.add (PSValueOf.ofSelect (eChild.getAttributeValue (CSchematronXML.ATTR_SELECT)));
                else
                  if (_is (eChild, CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_NAME))
                    aTarget.add (PSName.ofPath (eChild.getAttributeValue (CSchematronXML.ATTR_PATH)));
                  else
                    if (_is (eChild, CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_EMPH) ||
                        _is (eChild, CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_DIR) ||
                        _is (eChild, CSchematron.NAMESPACE_SCHEMATRON, CSchematronXML.ELEMENT_SPAN))
                      _readContentRecursive (eChild, aTarget);
                    else
                      LOGGER.warn ("Ignoring unsupported element '" + eChild.getTagName () + "' inside the SVRL text");
        }
    });
  }

  @NonNull
  private static ICommonsList <Object> _readContent (@NonNull final IMicroElement eParent)
  {
    final ICommonsList <Object> ret = new CommonsArrayList <> ();
    _readContentRecursive (eParent, ret);
    return ret;
  }

  private static void _applyContent (@NonNull final ICommonsList <Object> aContent,
                                     @NonNull final Consumer <String> aTextConsumer,
                                     @NonNull final Consumer <PSName> aNameConsumer,
                                     @NonNull final Consumer <PSValueOf> aValueOfConsumer)
  {
    for (final Object aItem : aContent)
      if (aItem instanceof final String sText)
        aTextConsumer.accept (sText);
      else
        if (aItem instanceof final PSName aName)
          aNameConsumer.accept (aName);
        else
          aValueOfConsumer.accept ((PSValueOf) aItem);
  }

  @NonNull
  private static PSValueOf _nameToValueOf (@NonNull final PSName aName)
  {
    return PSValueOf.ofSelect (NAME_FUNCTION_PREFIX + (aName.hasPath () ? aName.getPath () : ".") + ")");
  }

  /**
   * Get the element that contains the content of a diagnostic or property: either the nested SVRL
   * text or - if that does not exist - the element itself.
   */
  @NonNull
  private static IMicroElement _getContentElement (@NonNull final IMicroElement eRef)
  {
    final IMicroElement eText = _getFirstChildSvrl (eRef, ELEMENT_TEXT);
    return eText != null ? eText : eRef;
  }

  @NonNull
  private static PSLet _readLet (@NonNull final IMicroElement eVariable)
  {
    final PSLet ret = new PSLet ();
    ret.setName (eVariable.getAttributeValue (CSchematronXML.ATTR_NAME));
    ret.setValue (eVariable.getAttributeValue (CSchematronXML.ATTR_SELECT));
    ret.setAs (eVariable.getAttributeValue (CSchematronXML.ATTR_AS));
    if (!eVariable.hasAttribute (CSchematronXML.ATTR_SELECT))
    {
      // Variable with a body - only the elements can be preserved
      eVariable.forAllChildElements (eChild -> ret.addBodyElement (eChild.getClone ()));
    }
    return ret;
  }

  private void _readDiagnosticReference (@NonNull final IMicroElement eRef, @NonNull final PSAssertReport aAssertReport)
  {
    final String sID = eRef.getAttributeValue (ATTR_DIAGNOSTIC);
    if (StringHelper.isEmpty (sID))
      return;

    final ICommonsList <String> aIDs = aAssertReport.getAllDiagnostics ();
    aIDs.add (sID);
    aAssertReport.setDiagnostics (aIDs);

    if (!m_aDiagnostics.containsKey (sID))
    {
      final PSDiagnostic aDiagnostic = new PSDiagnostic ();
      aDiagnostic.setID (sID);
      _applyContent (_readContent (_getContentElement (eRef)),
                     aDiagnostic::addText,
                     aName -> aDiagnostic.addValueOf (_nameToValueOf (aName)),
                     aDiagnostic::addValueOf);
      m_aDiagnostics.put (sID, aDiagnostic);
    }
  }

  private void _readPropertyReference (@NonNull final IMicroElement eRef, @NonNull final PSAssertReport aAssertReport)
  {
    // SVRL uses "property" for the ID in the reference, the copied Schematron element uses "id"
    final String sID = StringHelper.getNotEmpty (eRef.getAttributeValue (ATTR_PROPERTY),
                                                 eRef.getAttributeValue (CSchematronXML.ATTR_ID));
    if (StringHelper.isEmpty (sID))
      return;

    final ICommonsList <String> aIDs = aAssertReport.getAllProperties ();
    aIDs.add (sID);
    aAssertReport.setProperties (aIDs);

    if (!m_aProperties.containsKey (sID))
    {
      final PSProperty aProperty = new PSProperty ();
      aProperty.setID (sID);
      aProperty.setRole (eRef.getAttributeValue (CSchematronXML.ATTR_ROLE));
      aProperty.setScheme (eRef.getAttributeValue (CSchematronXML.ATTR_SCHEME));
      _applyContent (_readContent (_getContentElement (eRef)),
                     aProperty::addText,
                     aProperty::addName,
                     aProperty::addValueOf);
      m_aProperties.put (sID, aProperty);
    }
  }

  @NonNull
  private PSAssertReport _readAssertReport (final boolean bIsAssert,
                                            @Nullable final String sTest,
                                            @NonNull final IMicroElement eSvrl)
  {
    final PSAssertReport ret = new PSAssertReport (bIsAssert);

    final ICommonsOrderedMap <String, String> aAttrs = _getSvrlAttributes (eSvrl);
    // SchXslt provides the original test as an attribute
    ret.setTest (sTest != null ? sTest : aAttrs.get (CSchematronXML.ATTR_TEST));
    ret.setID (aAttrs.get (CSchematronXML.ATTR_ID));
    ret.setFlag (aAttrs.get (CSchematronXML.ATTR_FLAG));

    eSvrl.forAllChildElements (eChild -> {
      if (_isSvrl (eChild, ELEMENT_DIAGNOSTIC_REFERENCE))
        _readDiagnosticReference (eChild, ret);
      else
        if (_isSvrl (eChild, ELEMENT_PROPERTY_REFERENCE) || _isSvrl (eChild, ELEMENT_PROPERTY))
          _readPropertyReference (eChild, ret);
        else
          if (_isSvrl (eChild, ELEMENT_TEXT))
          {
            // SchXslt2 puts "see" etc. to the text
            aAttrs.putAll (_getSvrlAttributes (eChild));
            _applyContent (_readContent (eChild), ret::addText, ret::addName, ret::addValueOf);
          }
    });
    _applyRichAndLinkable (aAttrs, ret::setRich, ret::setLinkable);
    return ret;
  }

  @Nullable
  private PSAssertReport _readAssertFromChoose (@NonNull final IMicroElement eChoose)
  {
    final IMicroElement eWhen = eChoose.getFirstChildElement (CSchematron.NAMESPACE_URI_XSL, ELEMENT_WHEN);
    final IMicroElement eOtherwise = eChoose.getFirstChildElement (CSchematron.NAMESPACE_URI_XSL, ELEMENT_OTHERWISE);
    if (eWhen == null || eOtherwise == null)
      return null;
    final IMicroElement eFailedAssert = _getFirstChildSvrl (eOtherwise, ELEMENT_FAILED_ASSERT);
    if (eFailedAssert == null)
      return null;

    // Use the "test" of the xsl:when and not the one of the SVRL element, because the latter is
    // whitespace normalized and escaped
    return _readAssertReport (true, eWhen.getAttributeValue (CSchematronXML.ATTR_TEST), eFailedAssert);
  }

  @Nullable
  private PSAssertReport _readReportFromIf (@NonNull final IMicroElement eIf)
  {
    final IMicroElement eSuccessfulReport = _getFirstChildSvrl (eIf, ELEMENT_SUCCESSFUL_REPORT);
    if (eSuccessfulReport == null)
      return null;
    return _readAssertReport (false, eIf.getAttributeValue (CSchematronXML.ATTR_TEST), eSuccessfulReport);
  }

  @NonNull
  private PSRule _readRule (@NonNull final IMicroElement eTemplate, @Nullable final IMicroElement eFiredRule)
  {
    final PSRule ret = new PSRule ();
    ret.setContext (eTemplate.getAttributeValue (ATTR_MATCH));

    // Older skeletons don't create the SVRL fired-rule element
    if (eFiredRule != null)
    {
      final ICommonsOrderedMap <String, String> aAttrs = _getSvrlAttributes (eFiredRule);
      ret.setID (aAttrs.get (CSchematronXML.ATTR_ID));
      ret.setFlag (aAttrs.get (CSchematronXML.ATTR_FLAG));
      _applyRichAndLinkable (aAttrs, ret::setRich, ret::setLinkable);
    }

    eTemplate.forAllChildElements (eChild -> {
      if (_isXsl (eChild, ELEMENT_VARIABLE))
        ret.addLet (_readLet (eChild));
      else
        if (_isXsl (eChild, ELEMENT_CHOOSE))
        {
          final PSAssertReport aAssert = _readAssertFromChoose (eChild);
          if (aAssert != null)
            ret.addAssertReport (aAssert);
        }
        else
          if (_isXsl (eChild, ELEMENT_IF))
          {
            final PSAssertReport aReport = _readReportFromIf (eChild);
            if (aReport != null)
              ret.addAssertReport (aReport);
          }
    });
    return ret;
  }

  @NonNull
  private static PSTitle _createTitle (@NonNull final String sTitle)
  {
    final PSTitle ret = new PSTitle ();
    ret.addText (sTitle);
    return ret;
  }

  @Nullable
  private static IMicroElement _findFirstDescendantRecursive (@NonNull final IMicroElement eParent,
                                                              @NonNull final String sNamespaceURI,
                                                              @NonNull final String sLocalName)
  {
    for (final IMicroElement eChild : eParent.getAllChildElements ())
    {
      if (_is (eChild, sNamespaceURI, sLocalName))
        return eChild;
      final IMicroElement eDescendant = _findFirstDescendantRecursive (eChild, sNamespaceURI, sLocalName);
      if (eDescendant != null)
        return eDescendant;
    }
    return null;
  }

  private static void _findAllDescendantsRecursive (@NonNull final IMicroElement eParent,
                                                    @NonNull final String sNamespaceURI,
                                                    @NonNull final String sLocalName,
                                                    @NonNull final ICommonsList <IMicroElement> aTarget)
  {
    for (final IMicroElement eChild : eParent.getAllChildElements ())
    {
      if (_is (eChild, sNamespaceURI, sLocalName))
        aTarget.add (eChild);
      _findAllDescendantsRecursive (eChild, sNamespaceURI, sLocalName, aTarget);
    }
  }

  @NonNull
  private static PSSchema _createSchema (@NonNull final IReadableResource aResource,
                                         @NonNull final IMicroElement eStylesheet,
                                         @NonNull final IMicroElement eOutput)
  {
    final PSSchema ret = new PSSchema (aResource);
    final String sXsltVersion = eStylesheet.getAttributeValue (ATTR_VERSION);
    // SchXslt2 creates XSLT 3.0 even for the xslt2 query binding
    if ("2.0".equals (sXsltVersion) || "3.0".equals (sXsltVersion))
      ret.setQueryBinding ("xslt2");
    final String sSchemaVersion = eOutput.getAttributeValue (CSchematronXML.ATTR_SCHEMA_VERSION);
    if (StringHelper.isNotEmpty (sSchemaVersion))
      ret.setSchemaVersion (sSchemaVersion);
    final String sTitle = eOutput.getAttributeValue (ATTR_TITLE);
    if (StringHelper.isNotEmpty (sTitle))
      ret.setTitle (_createTitle (sTitle));
    eOutput.forAllChildElements (eChild -> {
      if (_isSvrl (eChild, ELEMENT_NS_PREFIX))
        ret.addNS (PSNS.ofPrefixAndUri (eChild.getAttributeValue (CSchematronXML.ATTR_PREFIX),
                                        eChild.getAttributeValue (CSchematronXML.ATTR_URI)));
    });
    return ret;
  }

  private static boolean _isSchXsltInternal (@Nullable final String sName)
  {
    return sName == null || sName.contains (SCHXSLT_MARKER) || SKELETON_GLOBALS.contains (sName);
  }

  /**
   * SchXslt: Collect the lets and the asserts/reports of a rule template. Everything created by the
   * compiler itself (variables with a "schxslt" name, skipped assertions, suppressed rules) is
   * ignored.
   */
  private void _readRuleContentRecursive (@NonNull final IMicroElement eParent, @NonNull final PSRule aRule)
  {
    for (final IMicroElement eChild : eParent.getAllChildElements ())
      if (_isSvrl (eChild, ELEMENT_FAILED_ASSERT))
        aRule.addAssertReport (_readAssertReport (true, null, eChild));
      else
        if (_isSvrl (eChild, ELEMENT_SUCCESSFUL_REPORT))
          aRule.addAssertReport (_readAssertReport (false, null, eChild));
        else
          if (!eChild.hasNamespaceURI (CSVRL.SVRL_NAMESPACE_URI))
          {
            if (_isXsl (eChild, ELEMENT_VARIABLE))
            {
              final String sAs = eChild.getAttributeValue (ATTR_AS);
              if (sAs != null && sAs.startsWith ("element(svrl:"))
              {
                // SchXslt2 stores the assert in a variable
                _readRuleContentRecursive (eChild, aRule);
              }
              else
                if (!_isSchXsltInternal (eChild.getAttributeValue (CSchematronXML.ATTR_NAME)))
                  aRule.addLet (_readLet (eChild));
            }
            else
              _readRuleContentRecursive (eChild, aRule);
          }
  }

  @NonNull
  private PSRule _readSchXsltRule (@NonNull final IMicroElement eTemplate, @NonNull final IMicroElement eFiredRule)
  {
    final PSRule ret = new PSRule ();
    ret.setContext (eTemplate.getAttributeValue (ATTR_MATCH));
    final ICommonsOrderedMap <String, String> aAttrs = _getSvrlAttributes (eFiredRule);
    ret.setID (aAttrs.get (CSchematronXML.ATTR_ID));
    ret.setFlag (aAttrs.get (CSchematronXML.ATTR_FLAG));
    _applyRichAndLinkable (aAttrs, ret::setRich, ret::setLinkable);
    _readRuleContentRecursive (eTemplate, ret);
    return ret;
  }

  @NonNull
  private static PSPattern _createSchXsltPattern (@NonNull final IMicroElement eActivePattern)
  {
    final PSPattern ret = new PSPattern ();
    final ICommonsOrderedMap <String, String> aAttrs = _getSvrlAttributes (eActivePattern);
    ret.setID (aAttrs.get (CSchematronXML.ATTR_ID));
    final String sName = aAttrs.get (CSchematronXML.ATTR_NAME);
    if (StringHelper.isNotEmpty (sName))
      ret.setTitle (_createTitle (sName));
    return ret;
  }

  /**
   * SchXslt2 identifies the pattern of a rule only by a generated ID in the first parameter of the
   * <code>next-match</code> instruction.
   */
  @Nullable
  private static String _getSchXslt2PatternKey (@NonNull final IMicroElement eTemplate)
  {
    // The next-match of the shadowed branch has no parameter
    final ICommonsList <IMicroElement> aNextMatches = new CommonsArrayList <> ();
    _findAllDescendantsRecursive (eTemplate, CSchematron.NAMESPACE_URI_XSL, ELEMENT_NEXT_MATCH, aNextMatches);
    String sSelect = null;
    for (final IMicroElement eNextMatch : aNextMatches)
    {
      final IMicroElement eWithParam = eNextMatch.getFirstChildElement (CSchematron.NAMESPACE_URI_XSL,
                                                                        ELEMENT_WITH_PARAM);
      if (eWithParam != null)
      {
        sSelect = eWithParam.getAttributeValue (ATTR_SELECT);
        break;
      }
    }
    if (sSelect == null)
      return null;
    final Matcher aMatcher = Pattern.compile ("^\\(?\\s*'([^']*)'").matcher (sSelect);
    return aMatcher.find () ? aMatcher.group (1) : null;
  }

  @Nullable
  private static String _getSchXslt2PatternID (@NonNull final IMicroElement eTemplate)
  {
    final ICommonsList <IMicroElement> aAll = new CommonsArrayList <> ();
    _findAllDescendantsRecursive (eTemplate, CSVRL.SVRL_NAMESPACE_URI, ELEMENT_FAILED_ASSERT, aAll);
    _findAllDescendantsRecursive (eTemplate, CSVRL.SVRL_NAMESPACE_URI, ELEMENT_SUCCESSFUL_REPORT, aAll);
    for (final IMicroElement e : aAll)
    {
      final String sID = e.getAttributeValue (ATTR_PATTERN_ID);
      if (sID != null)
        return sID;
    }
    return null;
  }

  /**
   * Read the XSLT created by SchXslt (1.x) or SchXslt2. Both are not structured like the ISO
   * skeleton. Since pattern level lets are global variables, they end up as schema level lets.
   */
  @NonNull
  private PSSchema _readSchXslt (@NonNull final IMicroElement eStylesheet,
                                 @NonNull final IMicroElement eOutput) throws SchematronReadException
  {
    final PSSchema ret = _createSchema (m_aResource, eStylesheet, eOutput);

    final ICommonsList <IMicroElement> aTemplates = new CommonsArrayList <> ();
    for (final IMicroElement eChild : eStylesheet.getAllChildElements ())
      if (_isXsl (eChild, ELEMENT_TEMPLATE))
        aTemplates.add (eChild);

    // Global lets, functions and keys
    for (final IMicroElement eChild : eStylesheet.getAllChildElements ())
      if (_isXsl (eChild, ELEMENT_PARAM) || _isXsl (eChild, ELEMENT_VARIABLE))
      {
        if (!_isSchXsltInternal (eChild.getAttributeValue (CSchematronXML.ATTR_NAME)))
          ret.addLet (_readLet (eChild));
      }
      else
        if (_isXsl (eChild, ELEMENT_FUNCTION) || _isXsl (eChild, ELEMENT_KEY))
        {
          final String sName = eChild.getAttributeValue (CSchematronXML.ATTR_NAME);
          if (sName == null || !sName.contains (SCHXSLT_MARKER))
            ret.addForeignElement (eChild.getClone ());
        }

    final ICommonsList <PSPattern> aPatterns = new CommonsArrayList <> ();

    // SchXslt 1.x: the patterns are listed in the schxslt:pattern elements
    final ICommonsList <IMicroElement> aSchXslt1Patterns = new CommonsArrayList <> ();
    for (final IMicroElement eTemplate : aTemplates)
      _findAllDescendantsRecursive (eTemplate, NS_SCHXSLT1, ELEMENT_SCHXSLT_PATTERN, aSchXslt1Patterns);
    if (!aSchXslt1Patterns.isEmpty ())
    {
      final ICommonsOrderedMap <String, PSPattern> aPatternsByKey = new CommonsLinkedHashMap <> ();
      for (final IMicroElement eSchXsltPattern : aSchXslt1Patterns)
      {
        final IMicroElement eActivePattern = _findFirstDescendantRecursive (eSchXsltPattern,
                                                                            CSVRL.SVRL_NAMESPACE_URI,
                                                                            ELEMENT_ACTIVE_PATTERN);
        final PSPattern aPattern = eActivePattern != null ? _createSchXsltPattern (eActivePattern) : new PSPattern ();
        aPatternsByKey.put (eSchXsltPattern.getAttributeValue (CSchematronXML.ATTR_ID), aPattern);
        aPatterns.add (aPattern);
      }
      for (final IMicroElement eTemplate : aTemplates)
      {
        final IMicroElement eFiredRule = _findFirstDescendantRecursive (eTemplate,
                                                                        CSVRL.SVRL_NAMESPACE_URI,
                                                                        ELEMENT_FIRED_RULE);
        if (eFiredRule != null && eFiredRule.getParent () instanceof final IMicroElement eRuleWrapper)
        {
          final PSPattern aPattern = aPatternsByKey.get (eRuleWrapper.getAttributeValue (ATTR_PATTERN));
          if (aPattern != null)
            aPattern.addRule (_readSchXsltRule (eTemplate, eFiredRule));
        }
      }
    }
    else
    {
      // SchXslt2: the patterns are listed as svrl:active-pattern in the validation template
      final ICommonsList <IMicroElement> aActivePatterns = new CommonsArrayList <> ();
      for (final IMicroElement eTemplate : aTemplates)
        _findAllDescendantsRecursive (eTemplate, CSVRL.SVRL_NAMESPACE_URI, ELEMENT_ACTIVE_PATTERN, aActivePatterns);
      if (aActivePatterns.isEmpty ())
        throw new SchematronReadException (m_aResource,
                                           "The XSLT does not contain any svrl:active-pattern. It was not created by the ISO Schematron XSLT pipeline, SchXslt or SchXslt2");
      for (final IMicroElement eActivePattern : aActivePatterns)
        aPatterns.add (_createSchXsltPattern (eActivePattern));

      // Collect the rules by their generated pattern key
      final ICommonsOrderedMap <String, ICommonsList <PSRule>> aRulesByKey = new CommonsLinkedHashMap <> ();
      final ICommonsOrderedMap <String, String> aUserPatternIDByKey = new CommonsLinkedHashMap <> ();
      for (final IMicroElement eTemplate : aTemplates)
      {
        final IMicroElement eFiredRule = _findFirstDescendantRecursive (eTemplate,
                                                                        CSVRL.SVRL_NAMESPACE_URI,
                                                                        ELEMENT_FIRED_RULE);
        if (eFiredRule != null)
        {
          final String sKey = StringHelper.getNotNull (_getSchXslt2PatternKey (eTemplate));
          aRulesByKey.computeIfAbsent (sKey, k -> new CommonsArrayList <> ())
                     .add (_readSchXsltRule (eTemplate, eFiredRule));
          final String sPatternID = _getSchXslt2PatternID (eTemplate);
          if (sPatternID != null)
            aUserPatternIDByKey.putIfAbsent (sKey, sPatternID);
        }
      }

      // First match by the pattern ID, than by order
      final ICommonsOrderedMap <String, PSPattern> aPatternsByKey = new CommonsLinkedHashMap <> ();
      for (final String sKey : aRulesByKey.keySet ())
      {
        final String sPatternID = aUserPatternIDByKey.get (sKey);
        if (sPatternID != null)
          for (final PSPattern aPattern : aPatterns)
            if (sPatternID.equals (aPattern.getID ()) && !aPatternsByKey.containsValue (aPattern))
            {
              aPatternsByKey.put (sKey, aPattern);
              break;
            }
      }
      for (final String sKey : aRulesByKey.keySet ())
        if (!aPatternsByKey.containsKey (sKey))
        {
          PSPattern aFree = null;
          for (final PSPattern aPattern : aPatterns)
            if (!aPatternsByKey.containsValue (aPattern))
            {
              aFree = aPattern;
              break;
            }
          if (aFree == null)
          {
            aFree = new PSPattern ();
            aPatterns.add (aFree);
          }
          aPatternsByKey.put (sKey, aFree);
        }
      for (final Map.Entry <String, ICommonsList <PSRule>> aEntry : aRulesByKey.entrySet ())
        for (final PSRule aRule : aEntry.getValue ())
          aPatternsByKey.get (aEntry.getKey ()).addRule (aRule);
    }

    for (final PSPattern aPattern : aPatterns)
      ret.addPattern (aPattern);
    _applyDiagnosticsAndProperties (ret);
    return ret;
  }

  private void _applyDiagnosticsAndProperties (@NonNull final PSSchema aSchema)
  {
    if (m_aDiagnostics.isNotEmpty ())
    {
      final PSDiagnostics aDiagnostics = new PSDiagnostics ();
      for (final PSDiagnostic aDiagnostic : m_aDiagnostics.values ())
        aDiagnostics.addDiagnostic (aDiagnostic);
      aSchema.setDiagnostics (aDiagnostics);
    }
    if (m_aProperties.isNotEmpty ())
    {
      final PSProperties aProperties = new PSProperties ();
      for (final PSProperty aProperty : m_aProperties.values ())
        aProperties.addProperty (aProperty);
      aSchema.setProperties (aProperties);
      // <properties> was introduced in Schematron 2016
      aSchema.setSchematronEdition (ESchematronVersion.SCHEMATRON_2016);
    }
  }

  /**
   * Convert the provided XSLT root element to a Schematron schema.
   *
   * @param eStylesheet
   *        The <code>xsl:stylesheet</code> or <code>xsl:transform</code> element. May not be
   *        <code>null</code>.
   * @return The created schema. Never <code>null</code>.
   * @throws SchematronReadException
   *         If the element is not an XSLT created from an ISO Schematron
   */
  @NonNull
  public PSSchema readSchemaFromXML (@NonNull final IMicroElement eStylesheet) throws SchematronReadException
  {
    ValueEnforcer.notNull (eStylesheet, "Stylesheet");

    if (!_isXsl (eStylesheet, ELEMENT_STYLESHEET) && !_isXsl (eStylesheet, ELEMENT_TRANSFORM))
      throw new SchematronReadException (m_aResource,
                                         "The root element is '" +
                                                      eStylesheet.getTagName () +
                                                      "' and not an XSLT stylesheet");

    // The one template without a mode matching the root creates the SVRL output
    IMicroElement eSetupTemplate = null;
    for (final IMicroElement eChild : eStylesheet.getAllChildElements ())
      if (_isXsl (eChild, ELEMENT_TEMPLATE) &&
          "/".equals (eChild.getAttributeValue (ATTR_MATCH)) &&
          !eChild.hasAttribute (ATTR_MODE) &&
          eChild.getFirstChildElement (CSVRL.SVRL_NAMESPACE_URI, ELEMENT_SCHEMATRON_OUTPUT) != null)
      {
        eSetupTemplate = eChild;
        break;
      }
    m_aDiagnostics.clear ();
    m_aProperties.clear ();

    if (eSetupTemplate == null)
    {
      // Maybe SchXslt or SchXslt2
      final IMicroElement eAnyOutput = _findFirstDescendantRecursive (eStylesheet,
                                                                      CSVRL.SVRL_NAMESPACE_URI,
                                                                      ELEMENT_SCHEMATRON_OUTPUT);
      if (eAnyOutput == null)
        throw new SchematronReadException (m_aResource,
                                           "The XSLT does not contain the svrl:schematron-output element. It was not created from a Schematron");
      return _readSchXslt (eStylesheet, eAnyOutput);
    }
    final IMicroElement eOutput = _getFirstChildSvrl (eSetupTemplate, ELEMENT_SCHEMATRON_OUTPUT);

    final PSSchema ret = _createSchema (m_aResource, eStylesheet, eOutput);

    // The patterns in the order of execution, accessible by their mode
    final ICommonsList <PSPattern> aPatterns = new CommonsArrayList <> ();
    final ICommonsOrderedMap <String, PSPattern> aPatternsByMode = new CommonsLinkedHashMap <> ();
    final ICommonsList <String> aPatternTitleFallbacks = new CommonsArrayList <> ();
    PSPattern aCurrentPattern = null;
    for (final IMicroElement eChild : eOutput.getAllChildElements ())
      if (_isSvrl (eChild, ELEMENT_ACTIVE_PATTERN))
      {
        aCurrentPattern = new PSPattern ();
        final ICommonsOrderedMap <String, String> aAttrs = _getSvrlAttributes (eChild);
        aCurrentPattern.setID (aAttrs.get (CSchematronXML.ATTR_ID));
        aPatterns.add (aCurrentPattern);
        aPatternTitleFallbacks.add (aAttrs.get (CSchematronXML.ATTR_NAME));
      }
      else
        if (_isXsl (eChild, ELEMENT_APPLY_TEMPLATES) && aCurrentPattern != null)
        {
          aPatternsByMode.put (eChild.getAttributeValue (ATTR_MODE), aCurrentPattern);
          aCurrentPattern = null;
        }

    // SchXslt 1.x may use the same setup template, but lists the patterns elsewhere
    if (aPatterns.isEmpty ())
      return _readSchXslt (eStylesheet, eOutput);

    // The global part: lets, functions, keys, rules
    int nPatternComments = 0;
    PSPattern aLetPattern = null;
    boolean bSchemaTitleSeen = false;
    for (final IMicroNode aNode : eStylesheet.getAllChildren ())
    {
      if (aNode.isComment ())
      {
        final String sComment = ((IMicroComment) aNode).getData ().toString ();
        if (sComment.startsWith (COMMENT_PATTERN_PREFIX))
        {
          aLetPattern = nPatternComments < aPatterns.size () ? aPatterns.get (nPatternComments) : null;
          nPatternComments++;
        }
      }
      else
        if (aNode.isElement ())
        {
          final IMicroElement eChild = (IMicroElement) aNode;
          if (_isXsl (eChild, ELEMENT_PARAM) || _isXsl (eChild, ELEMENT_VARIABLE))
          {
            final String sName = eChild.getAttributeValue (CSchematronXML.ATTR_NAME);
            if (!SKELETON_GLOBALS.contains (sName))
            {
              final PSLet aLet = _readLet (eChild);
              if (aLetPattern != null)
                aLetPattern.addLet (aLet);
              else
                ret.addLet (aLet);
            }
          }
          else
            if (_isXsl (eChild, ELEMENT_FUNCTION) || _isXsl (eChild, ELEMENT_KEY))
              ret.addForeignElement (eChild.getClone ());
            else
              if (_isSvrl (eChild, ELEMENT_TEXT))
              {
                // Title of the schema or of the current pattern
                final String sText = eChild.getTextContent ();
                if (StringHelper.isNotEmpty (sText))
                  if (aLetPattern == null)
                  {
                    if (!bSchemaTitleSeen && !ret.hasTitle ())
                      ret.setTitle (_createTitle (sText));
                    bSchemaTitleSeen = true;
                  }
                  else
                    if (!aLetPattern.hasTitle ())
                      aLetPattern.setTitle (_createTitle (sText));
              }
              else
                if (_isXsl (eChild, ELEMENT_TEMPLATE))
                {
                  final PSPattern aPattern = aPatternsByMode.get (eChild.getAttributeValue (ATTR_MODE));
                  final String sMatch = eChild.getAttributeValue (ATTR_MATCH);
                  // Skip the default templates that end each pattern
                  if (aPattern != null && !DEFAULT_MATCHES.contains (sMatch))
                    aPattern.addRule (_readRule (eChild, _getFirstChildSvrl (eChild, ELEMENT_FIRED_RULE)));
                }
        }
    }

    for (int i = 0; i < aPatterns.size (); ++i)
    {
      final PSPattern aPattern = aPatterns.get (i);
      final String sFallback = aPatternTitleFallbacks.get (i);
      if (!aPattern.hasTitle () && StringHelper.isNotEmpty (sFallback))
        aPattern.setTitle (_createTitle (sFallback));
      ret.addPattern (aPattern);
    }

    _applyDiagnosticsAndProperties (ret);
    return ret;
  }

  /**
   * Read the XSLT from the resource supplied in the constructor and convert it to a Schematron
   * schema.
   *
   * @return The created schema. Never <code>null</code>.
   * @throws SchematronReadException
   *         If reading the XML fails or if the XSLT was not created from an ISO Schematron
   */
  @NonNull
  public PSSchema readSchema () throws SchematronReadException
  {
    final IMicroDocument aDoc = MicroReader.readMicroXML (m_aResource);
    if (aDoc == null || aDoc.getDocumentElement () == null)
      throw new SchematronReadException (m_aResource, "Failed to read XSLT resource " + m_aResource);
    return readSchemaFromXML (aDoc.getDocumentElement ());
  }
}
