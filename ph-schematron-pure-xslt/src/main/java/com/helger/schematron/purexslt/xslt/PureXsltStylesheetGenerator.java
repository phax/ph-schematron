/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.xslt;

import javax.xml.XMLConstants;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.schematron.CSchematron;
import com.helger.schematron.CSchematronVersion;
import com.helger.schematron.model.PSActive;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSDiagnostic;
import com.helger.schematron.model.PSDiagnostics;
import com.helger.schematron.model.PSDir;
import com.helger.schematron.model.PSEmph;
import com.helger.schematron.model.PSLet;
import com.helger.schematron.model.PSLinkableGroup;
import com.helger.schematron.model.PSNS;
import com.helger.schematron.model.PSName;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSPhase;
import com.helger.schematron.model.PSProperties;
import com.helger.schematron.model.PSProperty;
import com.helger.schematron.model.PSRichGroup;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSSpan;
import com.helger.schematron.model.PSValueOf;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.XMLFactory;
import com.helger.xml.microdom.IMicroCDATA;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.IMicroNode;
import com.helger.xml.microdom.IMicroText;

/**
 * Generates an XSLT 3.0 stylesheet from a parsed {@link PSSchema} that, when applied to an XML
 * instance, produces SVRL output. The result is a {@link Document} so that downstream consumers can
 * feed it directly to Saxon's {@code XsltCompiler} via {@link javax.xml.transform.dom.DOMSource}
 * (no intermediate serialize-then-parse round trip).
 * <p>
 * <b>Supported scope:</b> {@code <sch:ns>}, {@code <sch:pattern>}, {@code <sch:rule context>},
 * {@code <sch:assert test>}, {@code <sch:report test>}, {@code <sch:value-of select>} and
 * {@code <sch:name path>} interpolation in message text, rich-text spans ({@code <sch:emph>},
 * {@code <sch:dir>}, {@code <sch:span>}) emitted as their SVRL counterparts, {@code <sch:phase>} /
 * {@code <sch:active>} phase selection (including {@code #ALL} and {@code #DEFAULT}),
 * {@code <sch:let>} variable bindings at schema/phase/pattern/rule scope, {@code <sch:diagnostic>}
 * references on asserts and reports, {@code <sch:property>} references emitted as
 * {@code <svrl:property-reference>}, the {@code role} / {@code see} / {@code icon} / {@code fpi}
 * attributes on rules / asserts / reports / diagnostic-references, and pass-through of all foreign
 * elements (XSLT and non-XSLT) declared at schema level. Abstract patterns / {@code <sch:extends>}
 * / {@code <sch:include>} are expected to be expanded by a preprocessor before this generator runs.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class PureXsltStylesheetGenerator
{
  public static final String XSLT_NS = "http://www.w3.org/1999/XSL/Transform";
  public static final String XSLT_PREFIX = "xsl";
  public static final String SVRL_PREFIX = "svrl";

  /**
   * @deprecated Use {@link EPureXsltVersion#DEFAULT} ({@code EXsltVersion.XSLT_3_0}) instead. Kept
   *             as a constant string for API stability of any callers that read it.
   */
  @Deprecated
  public static final String XSLT_VERSION = EPureXsltVersion.DEFAULT.getVersion ();

  private static final Logger LOGGER = LoggerFactory.getLogger (PureXsltStylesheetGenerator.class);

  private PureXsltStylesheetGenerator ()
  {}

  /**
   * Generate a stylesheet at the default XSLT version ({@link EPureXsltVersion#DEFAULT}) from the
   * passed Schematron schema, processing all patterns.
   *
   * @param aSchema
   *        The parsed schema. May not be <code>null</code>.
   * @return An in-memory XSLT stylesheet document. Never <code>null</code>.
   */
  @NonNull
  public static Document generate (@NonNull final PSSchema aSchema)
  {
    return generate (aSchema, null, EPureXsltVersion.DEFAULT);
  }

  /**
   * Generate a stylesheet at the default XSLT version ({@link EPureXsltVersion#DEFAULT}) from the
   * passed Schematron schema, restricted to the patterns activated by the named phase.
   *
   * @param aSchema
   *        The parsed schema. May not be <code>null</code>.
   * @param sPhase
   *        The phase to evaluate. May be <code>null</code>, empty or {@link CSchematron#PHASE_ALL}
   *        (process all patterns), {@link CSchematron#PHASE_DEFAULT} (use
   *        {@link PSSchema#getDefaultPhase()}), or a specific phase id.
   * @return An in-memory XSLT stylesheet document. Never <code>null</code>.
   */
  @NonNull
  public static Document generate (@NonNull final PSSchema aSchema, @Nullable final String sPhase)
  {
    return generate (aSchema, sPhase, EPureXsltVersion.DEFAULT);
  }

  /**
   * Resolve the special phase tokens {@code null} / empty / {@code #ALL} / {@code #DEFAULT} against
   * the schema.
   *
   * @return either {@code null} (meaning "all patterns active") or a concrete phase id.
   */
  @Nullable
  private static String _resolvePhase (@NonNull final PSSchema aSchema, @Nullable final String sPhase)
  {
    if (StringHelper.isEmpty (sPhase))
      return CSchematron.PHASE_ALL;

    if (CSchematron.PHASE_DEFAULT.equals (sPhase))
    {
      final String sDefault = aSchema.getDefaultPhase ();
      if (StringHelper.isEmpty (sDefault))
        return null;

      return sDefault;
    }

    return sPhase;
  }

  /*
   * Return the concrete (non-abstract) patterns active in the given resolved phase id. A {@code
   * null} phase means all concrete patterns are active.
   */
  @NonNull
  private static ICommonsList <PSPattern> _resolveActivePatterns (@NonNull final PSSchema aSchema,
                                                                  @Nullable final String sResolvedPhase)
  {
    final ICommonsList <PSPattern> ret = new CommonsArrayList <> ();
    final ICommonsSet <String> aAllowedIDs;
    if (StringHelper.isEmpty (sResolvedPhase) || CSchematron.PHASE_ALL.equals (sResolvedPhase))
    {
      aAllowedIDs = null;
    }
    else
    {
      final PSPhase aPhase = aSchema.getPhaseOfID (sResolvedPhase);
      if (aPhase == null)
      {
        LOGGER.warn ("Phase '" + sResolvedPhase + "' is not defined in the schema; processing zero patterns");
        return ret;
      }
      aAllowedIDs = new CommonsHashSet <> ();
      for (final PSActive aActive : aPhase.getAllActives ())
        if (StringHelper.isNotEmpty (aActive.getPattern ()))
          aAllowedIDs.add (aActive.getPattern ());
    }

    for (final PSPattern aPattern : aSchema.getAllPatterns ())
    {
      if (aPattern.isAbstract ())
      {
        LOGGER.warn ("Skipping abstract pattern '" +
                     aPattern.getID () +
                     "' - abstract patterns are not yet supported in the Saxon-native engine");
      }
      else
      {
        if (aAllowedIDs == null || aAllowedIDs.contains (aPattern.getID ()))
          ret.add (aPattern);
      }
    }
    return ret;
  }

  /**
   * Declare {@code xmlns:xsl}, {@code xmlns:svrl} and one {@code xmlns:<prefix>} per
   * {@code <sch:ns>} on the stylesheet root. Required so Saxon can resolve prefixes that occur only
   * inside XPath attribute values (e.g. {@code test="my:func(.)"}).
   */
  private static void _declareNamespacesOnStylesheet (@NonNull final Element aStylesheet,
                                                      @NonNull final PSSchema aSchema)
  {
    aStylesheet.setAttributeNS (XMLConstants.XMLNS_ATTRIBUTE_NS_URI,
                                XMLConstants.XMLNS_ATTRIBUTE + ":" + XSLT_PREFIX,
                                XSLT_NS);
    aStylesheet.setAttributeNS (XMLConstants.XMLNS_ATTRIBUTE_NS_URI,
                                XMLConstants.XMLNS_ATTRIBUTE + ":" + SVRL_PREFIX,
                                CSVRL.SVRL_NAMESPACE_URI);

    final ICommonsSet <String> aAlreadyDeclared = new CommonsHashSet <> ();
    aAlreadyDeclared.add (XSLT_PREFIX);
    aAlreadyDeclared.add (SVRL_PREFIX);
    for (final PSNS aNS : aSchema.getAllNSs ())
    {
      final String sPrefix = aNS.getPrefix ();
      final String sURI = aNS.getUri ();
      if (StringHelper.isNotEmpty (sPrefix) && StringHelper.isNotEmpty (sURI) && aAlreadyDeclared.add (sPrefix))
        aStylesheet.setAttributeNS (XMLConstants.XMLNS_ATTRIBUTE_NS_URI,
                                    XMLConstants.XMLNS_ATTRIBUTE + ":" + sPrefix,
                                    sURI);
    }
  }

  /**
   * Recursively materialize the given Micro-DOM subtree as a DOM child of {@code aDomParent}. Used
   * to graft schema-level {@code <xsl:*>} foreign elements (which the {@link PSSchema} stores as
   * {@link IMicroElement}) into the DOM stylesheet without going through a serialize-and-reparse
   * round trip. Honors XSLT/SVRL prefix conventions on element names so the result serializes
   * cleanly.
   */
  private static void _appendMicroAsDom (@NonNull final Element aDomParent, @NonNull final IMicroElement aSrc)
  {
    final Document aDoc = aDomParent.getOwnerDocument ();
    final String sNS = aSrc.getNamespaceURI ();
    final String sLocal = aSrc.getLocalName ();
    final Element aDomElem;
    if (StringHelper.isEmpty (sNS))
      aDomElem = aDoc.createElement (sLocal);
    else
    {
      final String sQName;
      if (XSLT_NS.equals (sNS))
        sQName = XSLT_PREFIX + ":" + sLocal;
      else
        if (CSVRL.SVRL_NAMESPACE_URI.equals (sNS))
          sQName = SVRL_PREFIX + ":" + sLocal;
        else
          sQName = sLocal;
      aDomElem = aDoc.createElementNS (sNS, sQName);
    }
    aDomParent.appendChild (aDomElem);

    aSrc.forAllAttributes ((sAttrNS, sAttrName, sAttrValue) -> {
      if (StringHelper.isEmpty (sAttrNS))
        aDomElem.setAttribute (sAttrName, sAttrValue);
      else
        aDomElem.setAttributeNS (sAttrNS, sAttrName, sAttrValue);
    });

    final ICommonsList <IMicroNode> aChildren = aSrc.getAllChildren ();
    if (aChildren != null)
      for (final IMicroNode aChild : aChildren)
      {
        if (aChild instanceof final IMicroElement aChildElem)
          _appendMicroAsDom (aDomElem, aChildElem);
        else
          if (aChild instanceof final IMicroText aText)
            aDomElem.appendChild (aDoc.createTextNode (aText.getData ().toString ()));
          else
            if (aChild instanceof final IMicroCDATA aCDATA)
              aDomElem.appendChild (aDoc.createCDATASection (aCDATA.getData ().toString ()));
            else
              LOGGER.warn ("Skipping unsupported foreign node " + aChild.getClass ().getSimpleName ());
      }
  }

  /**
   * Copy every schema-level foreign element into the generated stylesheet root. XSLT-namespace
   * elements (e.g. {@code <xsl:function>}, {@code <xsl:variable>}, {@code <xsl:key>}) are
   * interpreted by Saxon as top-level XSLT declarations; non-XSLT vendor extensions are preserved
   * verbatim — Saxon ignores anything it does not recognize at stylesheet level.
   */
  private static void _appendForeignElements (@NonNull final Element aStylesheet,
                                              @NonNull final ICommonsList <IMicroElement> aForeignElements)
  {
    for (final IMicroElement aForeign : aForeignElements)
      _appendMicroAsDom (aStylesheet, aForeign);
  }

  /**
   * Append a new element in the XSLT namespace (with the {@code xsl:} prefix) as the last child of
   * {@code aParent}.
   */
  @NonNull
  private static Element _addXsltChild (@NonNull final Element aParent, @NonNull final String sLocalName)
  {
    final Element aChild = aParent.getOwnerDocument ().createElementNS (XSLT_NS, XSLT_PREFIX + ":" + sLocalName);
    aParent.appendChild (aChild);
    return aChild;
  }

  /**
   * Append one {@code <xsl:variable name="..." select="..."/>} per {@link PSLet}. Used to bind
   * Schematron {@code <sch:let>} variables at whichever XSLT scope (stylesheet root for
   * schema/phase, rule template for pattern/rule) the parent element represents.
   */
  private static void _appendLetsAsXsltVariables (@NonNull final Element aParent,
                                                  @NonNull final ICommonsList <PSLet> aLets)
  {
    for (final PSLet aLet : aLets)
    {
      if (StringHelper.isEmpty (aLet.getName ()))
      {
        LOGGER.warn ("Skipping <sch:let> with empty name attribute");
        continue;
      }
      final Element aVar = _addXsltChild (aParent, "variable");
      aVar.setAttribute ("name", aLet.getName ());
      // Preference: select attribute wins (one-liner expression form). If the let has body
      // elements (XSLT sequence constructor form preserved by PSReader's
      // preserveLetBodyElements flag), copy them as the variable body instead.
      if (StringHelper.isNotEmpty (aLet.getValue ()))
        aVar.setAttribute ("select", aLet.getValue ());
      else
        if (aLet.hasBodyElements ())
          for (final IMicroElement aBody : aLet.getAllBodyElements ())
            _appendMicroAsDom (aVar, aBody);
    }
  }

  @NonNull
  private static String _getModeName (final int nPatternIdx)
  {
    return "M" + nPatternIdx;
  }

  /**
   * Append a new element in the SVRL namespace (with the {@code svrl:} prefix) as the last child of
   * {@code aParent}.
   */
  @NonNull
  private static Element _addSvrlChild (@NonNull final Element aParent, @NonNull final String sLocalName)
  {
    final Element aChild = aParent.getOwnerDocument ()
                                  .createElementNS (CSVRL.SVRL_NAMESPACE_URI, SVRL_PREFIX + ":" + sLocalName);
    aParent.appendChild (aChild);
    return aChild;
  }

  private static void _appendRootTemplate (@NonNull final Element aStylesheet,
                                           @NonNull final PSSchema aSchema,
                                           @NonNull final ICommonsList <PSPattern> aActivePatterns,
                                           @Nullable final String sResolvedPhase)
  {
    final Element aTemplate = _addXsltChild (aStylesheet, "template");
    aTemplate.setAttribute ("match", "/");

    final Element aSchemaOutput = _addSvrlChild (aTemplate, "schematron-output");
    if (StringHelper.isNotEmpty (aSchema.getSchemaVersion ()))
      aSchemaOutput.setAttribute ("schemaVersion", aSchema.getSchemaVersion ());
    if (StringHelper.isNotEmpty (sResolvedPhase))
      aSchemaOutput.setAttribute ("phase", sResolvedPhase);

    // <svrl:ns-prefix-in-attribute-values> per <sch:ns>
    for (final PSNS aNS : aSchema.getAllNSs ())
    {
      if (StringHelper.isEmpty (aNS.getPrefix ()) || StringHelper.isEmpty (aNS.getUri ()))
        continue;
      final Element aSvrlNS = _addSvrlChild (aSchemaOutput, "ns-prefix-in-attribute-values");
      aSvrlNS.setAttribute ("prefix", aNS.getPrefix ());
      aSvrlNS.setAttribute ("uri", aNS.getUri ());
    }

    // Per pattern: <svrl:active-pattern/> + <xsl:apply-templates select="/" mode="M{idx}"/>
    int nPatternIdx = 0;
    for (final PSPattern aPattern : aActivePatterns)
    {
      final Element aActive = _addSvrlChild (aSchemaOutput, "active-pattern");
      if (StringHelper.isNotEmpty (aPattern.getID ()))
        aActive.setAttribute ("id", aPattern.getID ());

      final Element aApply = _addXsltChild (aSchemaOutput, "apply-templates");
      aApply.setAttribute ("select", "/");
      aApply.setAttribute ("mode", _getModeName (nPatternIdx));
      nPatternIdx++;
    }
  }

  /**
   * Append an {@code <xsl:value-of select="...">} for a {@link PSValueOf}. {@code null} or empty
   * select is silently skipped (the source already produces a Schematron read warning).
   */
  private static void _appendValueOf (@NonNull final Element aParent, @NonNull final PSValueOf aValueOf)
  {
    final String sSelect = aValueOf.getSelect ();
    if (StringHelper.isEmpty (sSelect))
      return;
    final Element aVO = _addXsltChild (aParent, "value-of");
    aVO.setAttribute ("select", sSelect);
  }

  /**
   * Append an {@code <xsl:value-of select="name(...)" />} for a {@link PSName}. With no
   * {@code path} the select is just {@code name()}.
   */
  private static void _appendName (@NonNull final Element aParent, @NonNull final PSName aName)
  {
    final Element aVO = _addXsltChild (aParent, "value-of");
    final String sPath = aName.getPath ();
    aVO.setAttribute ("select", StringHelper.isEmpty (sPath) ? "name()" : "name(" + sPath + ")");
  }

  /**
   * Translate a {@link PSEmph} / {@link PSDir} / {@link PSSpan} rich-text span into its SVRL
   * counterpart ({@code <svrl:emph>} / {@code <svrl:dir>} / {@code <svrl:span>}) preserving
   * attributes and recursively translating mixed content. SchXslt2 emits the same shape.
   */
  private static void _appendRichTextSpan (@NonNull final Element aParent, @NonNull final Object aSpan)
  {
    if (aSpan instanceof final PSEmph aEmph)
    {
      final Element aOut = _addSvrlChild (aParent, "emph");
      for (final Object aPiece : aEmph.getAllContentElements ())
        _appendRichTextPiece (aOut, aPiece);
    }
    else
      if (aSpan instanceof final PSDir aDir)
      {
        final Element aOut = _addSvrlChild (aParent, "dir");
        if (aDir.getValue () != null)
          aOut.setAttribute ("dir", aDir.getValue ().getID ());
        for (final Object aPiece : aDir.getAllContentElements ())
          _appendRichTextPiece (aOut, aPiece);
      }
      else
        if (aSpan instanceof final PSSpan aSp)
        {
          final Element aOut = _addSvrlChild (aParent, "span");
          if (StringHelper.isNotEmpty (aSp.getClazz ()))
            aOut.setAttribute ("class", _escapeAvt (aSp.getClazz ()));
          for (final Object aPiece : aSp.getAllContentElements ())
            _appendRichTextPiece (aOut, aPiece);
        }
  }

  /**
   * Append a single mixed-content piece (text, {@code <sch:value-of>}, {@code <sch:name>},
   * {@code <sch:emph>}, {@code <sch:dir>}, {@code <sch:span>}, or a foreign micro-element) onto the
   * supplied parent. Shared by assert/report message content, diagnostic content and the recursive
   * content of rich-text spans.
   */
  private static void _appendRichTextPiece (@NonNull final Element aParent, @NonNull final Object aPiece)
  {
    if (aPiece instanceof final String sText)
      aParent.appendChild (aParent.getOwnerDocument ().createTextNode (sText));
    else
      if (aPiece instanceof final PSValueOf aValueOf)
        _appendValueOf (aParent, aValueOf);
      else
        if (aPiece instanceof final PSName aName)
          _appendName (aParent, aName);
        else
          if (aPiece instanceof PSEmph || aPiece instanceof PSDir || aPiece instanceof PSSpan)
            _appendRichTextSpan (aParent, aPiece);
          else
            if (aPiece instanceof final IMicroElement aForeign)
              _appendMicroAsDom (aParent, aForeign);
            else
              LOGGER.warn ("Skipping unsupported rich-text content of type " + aPiece.getClass ().getSimpleName ());
  }

  /**
   * Walk the mixed content of a {@link PSDiagnostic} in source order, emitting plain text,
   * {@code <xsl:value-of>} for {@link PSValueOf} / {@link PSName} pieces, and SVRL rich-text spans
   * for {@link PSEmph} / {@link PSDir} / {@link PSSpan}.
   */
  private static void _appendDiagnosticContent (@NonNull final Element aSvrlRef, @NonNull final PSDiagnostic aDiag)
  {
    for (final Object aPiece : aDiag.getAllContentElements ())
      _appendRichTextPiece (aSvrlRef, aPiece);
  }

  /**
   * Walk the mixed content of a {@link PSProperty} in source order. The content model matches
   * {@link PSDiagnostic}; reuses {@link #_appendRichTextPiece}.
   */
  private static void _appendPropertyContent (@NonNull final Element aSvrlText, @NonNull final PSProperty aProp)
  {
    for (final Object aPiece : aProp.getAllContentElements ())
      _appendRichTextPiece (aSvrlText, aPiece);
  }

  /**
   * Emit one {@code <svrl:diagnostic-reference diagnostic="id">} per id in the assert/report's
   * {@code diagnostics} attribute. The reference's text content is the resolved diagnostic's mixed
   * content (text + value-of + name) - interpolated the same way as assert/report messages.
   */
  private static void _appendDiagnosticReferences (@NonNull final Element aSvrlParent,
                                                   @NonNull final PSAssertReport aAR,
                                                   @Nullable final PSDiagnostics aDiagnostics)
  {
    final ICommonsList <String> aIDs = aAR.getAllDiagnostics ();
    if (aIDs == null || aIDs.isEmpty ())
      return;

    if (aDiagnostics == null)
    {
      LOGGER.warn ("Assert/report references diagnostics " +
                   aIDs +
                   " but the schema has no <sch:diagnostics> container");
      return;
    }

    for (final String sID : aIDs)
    {
      final PSDiagnostic aDiag = aDiagnostics.getDiagnosticOfID (sID);
      if (aDiag == null)
      {
        LOGGER.warn ("Diagnostic id '" + sID + "' referenced by an assert/report is not defined");
        continue;
      }
      final Element aRef = _addSvrlChild (aSvrlParent, "diagnostic-reference");
      aRef.setAttribute ("diagnostic", sID);
      // Wrap the diagnostic content in <svrl:text>. The SVRL XSD permits both mixed content
      // directly and a single optional <svrl:text> child, but only the latter is round-trippable
      // through the SVRL JAXB binding (rich-text spans are typed children of <svrl:text> only).
      // SchXslt2 takes the same approach.
      final Element aText = _addSvrlChild (aRef, "text");
      // Per ISO/IEC 19757-3 Annex D, see/icon/fpi live on the <text> child (human-text), not on
      // <diagnostic-reference>.
      _appendRichAttrs (aText, aDiag.getRich ());
      _appendDiagnosticContent (aText, aDiag);
    }
  }

  /**
   * Escape an unparsed string for use as a literal attribute value on a literal result element. In
   * XSLT, attribute values on LREs are attribute value templates: curly braces are interpreted as
   * embedded XPath expressions. Doubling the braces is the documented way to emit literal braces.
   * Verbatim schema content (test expressions, context paths, ids, flags) frequently contains regex
   * quantifiers like {@code {4}}; without this escaping Saxon would evaluate them at runtime.
   */
  @NonNull
  private static String _escapeAvt (@NonNull final String sValue)
  {
    if (sValue.indexOf ('{') < 0 && sValue.indexOf ('}') < 0)
      return sValue;
    return sValue.replace ("{", "{{").replace ("}", "}}");
  }

  /**
   * Walk the mixed message content of an assert/report in source order. Text becomes literal text,
   * {@link PSValueOf} / {@link PSName} expand to {@code <xsl:value-of>}, and {@link PSEmph} /
   * {@link PSDir} / {@link PSSpan} are emitted as their SVRL counterparts. Delegates to the shared
   * piece walker so diagnostic / property content use the same logic.
   */
  private static void _appendMessageContent (@NonNull final Element aTextElement, @NonNull final PSAssertReport aAR)
  {
    for (final Object aPiece : aAR.getAllContentElements ())
      _appendRichTextPiece (aTextElement, aPiece);
  }

  /**
   * Emit the {@code role} attribute (from the source's {@link PSLinkableGroup}) on the supplied
   * SVRL element. Per ISO/IEC 19757-3 Annex D, {@code role} is allowed on
   * {@code <svrl:fired-rule>}, {@code <svrl:failed-assert>} and {@code <svrl:successful-report>}.
   */
  private static void _appendRoleAttr (@NonNull final Element aSvrlOut, @Nullable final PSLinkableGroup aLinkable)
  {
    if (aLinkable != null && StringHelper.isNotEmpty (aLinkable.getRole ()))
      aSvrlOut.setAttribute ("role", _escapeAvt (aLinkable.getRole ()));
  }

  /**
   * Emit {@code see}, {@code icon}, {@code fpi}, {@code xml:lang} and {@code xml:space} attributes
   * (from the source's {@link PSRichGroup}) on the supplied SVRL element. Per ISO/IEC 19757-3
   * Annex D these attributes belong on {@code <svrl:text>} (the {@code human-text} production) and
   * on {@code <svrl:diagnostic-reference>}, not on the surrounding failed-assert /
   * successful-report / fired-rule.
   */
  private static void _appendRichAttrs (@NonNull final Element aSvrlOut, @Nullable final PSRichGroup aRich)
  {
    if (aRich == null)
      return;
    if (StringHelper.isNotEmpty (aRich.getSee ()))
      aSvrlOut.setAttribute ("see", _escapeAvt (aRich.getSee ()));
    if (StringHelper.isNotEmpty (aRich.getIcon ()))
      aSvrlOut.setAttribute ("icon", _escapeAvt (aRich.getIcon ()));
    if (StringHelper.isNotEmpty (aRich.getFPI ()))
      aSvrlOut.setAttribute ("fpi", _escapeAvt (aRich.getFPI ()));
    if (StringHelper.isNotEmpty (aRich.getXmlLang ()))
      aSvrlOut.setAttributeNS (XMLConstants.XML_NS_URI, "xml:lang", aRich.getXmlLang ());
    if (aRich.getXmlSpace () != null)
      aSvrlOut.setAttributeNS (XMLConstants.XML_NS_URI, "xml:space", aRich.getXmlSpace ().getID ());
  }

  /**
   * Emit one {@code <svrl:property-reference property="id">} per id in the assert/report's
   * {@code properties} attribute. The reference's text content is the resolved property's mixed
   * content - interpolated the same way as assert/report messages.
   */
  private static void _appendPropertyReferences (@NonNull final Element aSvrlParent,
                                                 @NonNull final PSAssertReport aAR,
                                                 @Nullable final PSProperties aProperties)
  {
    final ICommonsList <String> aIDs = aAR.getAllProperties ();
    if (aIDs == null || aIDs.isEmpty ())
      return;

    if (aProperties == null)
    {
      LOGGER.warn ("Assert/report references properties " + aIDs + " but the schema has no <sch:properties> container");
      return;
    }

    for (final String sID : aIDs)
    {
      final PSProperty aProp = aProperties.getPropertyOfID (sID);
      if (aProp == null)
      {
        LOGGER.warn ("Property id '" + sID + "' referenced by an assert/report is not defined");
        continue;
      }
      final Element aRef = _addSvrlChild (aSvrlParent, "property-reference");
      aRef.setAttribute ("property", sID);
      if (StringHelper.isNotEmpty (aProp.getRole ()))
        aRef.setAttribute ("role", _escapeAvt (aProp.getRole ()));
      if (StringHelper.isNotEmpty (aProp.getScheme ()))
        aRef.setAttribute ("scheme", _escapeAvt (aProp.getScheme ()));
      // SVRL property-reference wraps its text content in an <svrl:text> child
      final Element aText = _addSvrlChild (aRef, "text");
      _appendPropertyContent (aText, aProp);
    }
  }

  private static void _appendAssertReport (@NonNull final Element aRuleTemplate,
                                           @NonNull final PSAssertReport aAR,
                                           @Nullable final PSDiagnostics aDiagnostics,
                                           @Nullable final PSProperties aProperties)
  {
    final String sTest = aAR.getTest ();
    if (StringHelper.isEmpty (sTest))
    {
      LOGGER.warn ("Skipping " + (aAR.isAssert () ? "assert" : "report") + " with empty test expression");
      return;
    }

    // Assert: fail when test is FALSE -> guard "not(test)" emits <svrl:failed-assert>
    // Report: fire when test is TRUE -> guard "test" emits <svrl:successful-report>
    final boolean bIsAssert = aAR.isAssert ();
    final Element aIf = _addXsltChild (aRuleTemplate, "if");
    aIf.setAttribute ("test", bIsAssert ? "not(" + sTest + ")" : sTest);

    final String sSvrlElementName = bIsAssert ? "failed-assert" : "successful-report";
    final Element aOut = _addSvrlChild (aIf, sSvrlElementName);
    aOut.setAttribute ("test", _escapeAvt (sTest));
    // XSLT attribute value template: Saxon evaluates fn:path(.) at runtime and substitutes
    // the canonical XPath of the offending context node. Required by the SVRL XSD.
    aOut.setAttribute ("location", "{path(.)}");
    if (StringHelper.isNotEmpty (aAR.getID ()))
      aOut.setAttribute ("id", _escapeAvt (aAR.getID ()));
    if (StringHelper.isNotEmpty (aAR.getFlag ()))
      aOut.setAttribute ("flag", _escapeAvt (aAR.getFlag ()));
    // Per ISO/IEC 19757-3 Annex D, only role belongs on failed-assert / successful-report;
    // see/icon/fpi belong on the inner <svrl:text> (human-text production).
    _appendRoleAttr (aOut, aAR.getLinkable ());

    // Diagnostic-references must come before the text child per the SVRL XSD ordering
    _appendDiagnosticReferences (aOut, aAR, aDiagnostics);
    // Property-references go alongside diagnostic-references (SVRL XSD choice group)
    _appendPropertyReferences (aOut, aAR, aProperties);

    final Element aText = _addSvrlChild (aOut, "text");
    _appendRichAttrs (aText, aAR.getRich ());
    _appendMessageContent (aText, aAR);
  }

  private static void _appendRuleTemplate (@NonNull final Element aStylesheet,
                                           @NonNull final PSPattern aPattern,
                                           @NonNull final PSRule aRule,
                                           @NonNull final String sMode,
                                           final int nPriority,
                                           @Nullable final PSDiagnostics aDiagnostics,
                                           @Nullable final PSProperties aProperties)
  {
    final Element aTemplate = _addXsltChild (aStylesheet, "template");
    aTemplate.setAttribute ("match", aRule.getContext ());
    aTemplate.setAttribute ("priority", Integer.toString (nPriority));
    aTemplate.setAttribute ("mode", sMode);

    // Pattern- and rule-level <sch:let> become <xsl:variable> at the top of the rule template.
    // Pattern lets are duplicated across every rule template in the pattern (rather than factored
    // out) because they must be in scope inside whichever rule context fires.
    _appendLetsAsXsltVariables (aTemplate, aPattern.getAllLets ());
    _appendLetsAsXsltVariables (aTemplate, aRule.getAllLets ());

    // <svrl:fired-rule context="..."/>
    final Element aFired = _addSvrlChild (aTemplate, "fired-rule");
    aFired.setAttribute ("context", _escapeAvt (aRule.getContext ()));
    if (StringHelper.isNotEmpty (aRule.getID ()))
      aFired.setAttribute ("id", _escapeAvt (aRule.getID ()));
    if (StringHelper.isNotEmpty (aRule.getFlag ()))
      aFired.setAttribute ("flag", _escapeAvt (aRule.getFlag ()));
    // Per ISO/IEC 19757-3 Annex D, <svrl:fired-rule> takes only role from the source rule (see /
    // icon / fpi are not allowed on fired-rule).
    _appendRoleAttr (aFired, aRule.getLinkable ());

    // Per assert/report
    for (final PSAssertReport aAR : aRule.getAllAssertReports ())
      _appendAssertReport (aTemplate, aAR, aDiagnostics, aProperties);

    // Descend
    final Element aApply = _addXsltChild (aTemplate, "apply-templates");
    aApply.setAttribute ("mode", sMode);
  }

  private static void _appendPatternTemplates (@NonNull final Element aStylesheet,
                                               @NonNull final PSPattern aPattern,
                                               final int nPatternIdx,
                                               @Nullable final PSDiagnostics aDiagnostics,
                                               @Nullable final PSProperties aProperties)
  {
    final String sMode = _getModeName (nPatternIdx);
    final ICommonsList <PSRule> aRules = aPattern.getAllRules ();
    int nRuleIdx = 0;
    for (final PSRule aRule : aRules)
    {
      if (aRule.isAbstract ())
      {
        LOGGER.warn ("Skipping abstract rule '" +
                     aRule.getID () +
                     "' - abstract rules are not yet supported in the Saxon-native engine");
        continue;
      }
      if (StringHelper.isEmpty (aRule.getContext ()))
      {
        LOGGER.warn ("Skipping rule with empty context in pattern '" + aPattern.getID () + "'");
        continue;
      }
      _appendRuleTemplate (aStylesheet, aPattern, aRule, sMode, aRules.size () - nRuleIdx, aDiagnostics, aProperties);
      nRuleIdx++;
    }

    // Catch-all for this mode: descend without firing rules
    final Element aCatchAll = _addXsltChild (aStylesheet, "template");
    aCatchAll.setAttribute ("match", "@*|node()");
    aCatchAll.setAttribute ("priority", "-1");
    aCatchAll.setAttribute ("mode", sMode);

    final Element aApply = _addXsltChild (aCatchAll, "apply-templates");
    aApply.setAttribute ("select", "@*|node()");
    aApply.setAttribute ("mode", sMode);
  }

  /**
   * Generate an XSLT stylesheet from the passed Schematron schema, restricted to the patterns
   * activated by the named phase, targeting the given XSLT language version.
   *
   * @param aSchema
   *        The parsed schema. May not be <code>null</code>.
   * @param sPhase
   *        The phase to evaluate. May be <code>null</code>, empty or {@link CSchematron#PHASE_ALL}
   *        (process all patterns), {@link CSchematron#PHASE_DEFAULT} (use
   *        {@link PSSchema#getDefaultPhase()}), or a specific phase id.
   * @param eVersion
   *        The XSLT language version to declare on the generated stylesheet's {@code version}
   *        attribute. May not be <code>null</code>.
   * @return An in-memory XSLT stylesheet document. Never <code>null</code>.
   */
  @NonNull
  public static Document generate (@NonNull final PSSchema aSchema,
                                   @Nullable final String sPhase,
                                   @NonNull final EPureXsltVersion eVersion)
  {
    final String sResolvedPhase = _resolvePhase (aSchema, sPhase);
    final ICommonsList <PSPattern> aActivePatterns = _resolveActivePatterns (aSchema, sResolvedPhase);
    final PSDiagnostics aDiagnostics = aSchema.getDiagnostics ();
    final PSProperties aProperties = aSchema.getProperties ();

    final Document aDoc = XMLFactory.newDocument ();
    aDoc.appendChild (aDoc.createComment (" Created by ph-schematron-pure-xslt " +
                                          CSchematronVersion.BUILD_VERSION +
                                          " "));
    final Element aStylesheet = aDoc.createElementNS (XSLT_NS, XSLT_PREFIX + ":stylesheet");
    aDoc.appendChild (aStylesheet);

    // Declare all in-scope namespace prefixes on the root so Saxon can resolve the prefixes that
    // appear in XPath attribute values (e.g. my:func() inside test="..."). Without this, only the
    // namespaces referenced as element or attribute names would have visible xmlns bindings.
    _declareNamespacesOnStylesheet (aStylesheet, aSchema);

    aStylesheet.setAttribute ("version", eVersion.getVersion ());

    // <xsl:output method="xml" indent="no"/>
    final Element aOutput = _addXsltChild (aStylesheet, "output");
    aOutput.setAttribute ("method", "xml");
    aOutput.setAttribute ("indent", "no");

    // Pass through ALL schema-level foreign elements. The XSLT-namespace ones (xsl:function,
    // xsl:include, xsl:key, xsl:import, xsl:variable, ...) give Saxon-native schemas the ability
    // to declare helper functions and modules that are then callable from <sch:assert> /
    // <sch:report> expressions - the differentiating feature of this engine vs
    // ph-schematron-pure. Non-XSLT vendor extensions are passed through verbatim: Saxon ignores
    // anything it does not recognize at stylesheet level, so they are harmless if unused and
    // available to whichever extension is installed.
    _appendForeignElements (aStylesheet, aSchema.getAllForeignElements ());

    // Schema-level <sch:let> become global <xsl:variable>s. Visible in all rule templates.
    _appendLetsAsXsltVariables (aStylesheet, aSchema.getAllLets ());

    // Phase-level <sch:let>: if a specific phase was selected, its lets are additionally global.
    if (sResolvedPhase != null)
    {
      final PSPhase aPhase = aSchema.getPhaseOfID (sResolvedPhase);
      if (aPhase != null)
        _appendLetsAsXsltVariables (aStylesheet, aPhase.getAllLets ());
    }

    // Root template: emit <svrl:schematron-output> and walk patterns
    _appendRootTemplate (aStylesheet, aSchema, aActivePatterns, sResolvedPhase);

    // Per pattern: emit rule context templates + catch-all
    int nPatternIdx = 0;
    for (final PSPattern aPattern : aActivePatterns)
    {
      _appendPatternTemplates (aStylesheet, aPattern, nPatternIdx, aDiagnostics, aProperties);
      nPatternIdx++;
    }
    return aDoc;
  }
}
