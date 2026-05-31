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
package com.helger.schematron.puresaxon.xslt;

import org.jspecify.annotations.NonNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.string.StringHelper;
import com.helger.base.string.StringImplode;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSNS;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.IMicroElement;
import com.helger.xml.microdom.MicroDocument;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Generates an XSLT 3.0 stylesheet from a parsed {@link PSSchema} that, when applied to an XML
 * instance, produces SVRL output.
 * <p>
 * <b>Phase 1 scope:</b> handles {@code <sch:ns>}, {@code <sch:pattern>}, {@code <sch:rule context>}
 * and {@code <sch:assert test>} with plain text content. Abstract patterns, reports, lets, phases,
 * {@code <sch:value-of>}, {@code <sch:name>} and diagnostics are silently skipped (with a WARN
 * log). These will be added in subsequent phases.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class XsltStylesheetGenerator
{
  public static final String XSLT_NS = "http://www.w3.org/1999/XSL/Transform";
  public static final String XSLT_PREFIX = "xsl";
  public static final String SVRL_PREFIX = "svrl";
  public static final String XSLT_VERSION = "3.0";

  private static final Logger LOGGER = LoggerFactory.getLogger (XsltStylesheetGenerator.class);

  private XsltStylesheetGenerator ()
  {}

  /**
   * Generate an XSLT 3.0 stylesheet from the passed Schematron schema.
   *
   * @param aSchema
   *        The parsed schema. May not be <code>null</code>.
   * @return An in-memory XSLT stylesheet document. Never <code>null</code>.
   */
  @NonNull
  public static IMicroDocument generate (@NonNull final PSSchema aSchema)
  {
    final IMicroDocument aDoc = new MicroDocument ();
    final IMicroElement aStylesheet = aDoc.addElementNS (XSLT_NS, "stylesheet");
    aStylesheet.setAttribute ("version", XSLT_VERSION);

    // <xsl:output method="xml" indent="no"/>
    final IMicroElement aOutput = aStylesheet.addElementNS (XSLT_NS, "output");
    aOutput.setAttribute ("method", "xml");
    aOutput.setAttribute ("indent", "no");

    // Root template: emit <svrl:schematron-output> and walk patterns
    _appendRootTemplate (aStylesheet, aSchema);

    // Per pattern: emit rule context templates + catch-all
    int nPatternIdx = 0;
    for (final PSPattern aPattern : aSchema.getAllPatterns ())
    {
      if (aPattern.isAbstract ())
      {
        LOGGER.warn ("Skipping abstract pattern '" +
                     aPattern.getID () +
                     "' - abstract patterns are not yet supported in the Saxon-native engine");
        continue;
      }
      _appendPatternTemplates (aStylesheet, aPattern, nPatternIdx);
      nPatternIdx++;
    }
    return aDoc;
  }

  private static void _appendRootTemplate (@NonNull final IMicroElement aStylesheet, @NonNull final PSSchema aSchema)
  {
    final IMicroElement aTemplate = aStylesheet.addElementNS (XSLT_NS, "template");
    aTemplate.setAttribute ("match", "/");

    final IMicroElement aSchemaOutput = aTemplate.addElementNS (CSVRL.SVRL_NAMESPACE_URI, "schematron-output");
    if (StringHelper.isNotEmpty (aSchema.getSchemaVersion ()))
      aSchemaOutput.setAttribute ("schemaVersion", aSchema.getSchemaVersion ());

    // <svrl:ns-prefix-in-attribute-values> per <sch:ns>
    for (final PSNS aNS : aSchema.getAllNSs ())
    {
      if (StringHelper.isEmpty (aNS.getPrefix ()) || StringHelper.isEmpty (aNS.getUri ()))
        continue;
      final IMicroElement aSvrlNS = aSchemaOutput.addElementNS (CSVRL.SVRL_NAMESPACE_URI,
                                                                "ns-prefix-in-attribute-values");
      aSvrlNS.setAttribute ("prefix", aNS.getPrefix ());
      aSvrlNS.setAttribute ("uri", aNS.getUri ());
    }

    // Per pattern: <svrl:active-pattern/> + <xsl:apply-templates select="/" mode="M{idx}"/>
    int nPatternIdx = 0;
    for (final PSPattern aPattern : aSchema.getAllPatterns ())
    {
      if (aPattern.isAbstract ())
        continue;
      final IMicroElement aActive = aSchemaOutput.addElementNS (CSVRL.SVRL_NAMESPACE_URI, "active-pattern");
      if (StringHelper.isNotEmpty (aPattern.getID ()))
        aActive.setAttribute ("id", aPattern.getID ());

      final IMicroElement aApply = aSchemaOutput.addElementNS (XSLT_NS, "apply-templates");
      aApply.setAttribute ("select", "/");
      aApply.setAttribute ("mode", _modeName (nPatternIdx));
      nPatternIdx++;
    }
  }

  private static void _appendPatternTemplates (@NonNull final IMicroElement aStylesheet,
                                               @NonNull final PSPattern aPattern,
                                               final int nPatternIdx)
  {
    final String sMode = _modeName (nPatternIdx);
    final var aRules = aPattern.getAllRules ();
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
      _appendRuleTemplate (aStylesheet, aRule, sMode, aRules.size () - nRuleIdx);
      nRuleIdx++;
    }

    // Catch-all for this mode: descend without firing rules
    final IMicroElement aCatchAll = aStylesheet.addElementNS (XSLT_NS, "template");
    aCatchAll.setAttribute ("match", "@*|node()");
    aCatchAll.setAttribute ("priority", "-1");
    aCatchAll.setAttribute ("mode", sMode);
    final IMicroElement aApply = aCatchAll.addElementNS (XSLT_NS, "apply-templates");
    aApply.setAttribute ("select", "@*|node()");
    aApply.setAttribute ("mode", sMode);
  }

  private static void _appendRuleTemplate (@NonNull final IMicroElement aStylesheet,
                                           @NonNull final PSRule aRule,
                                           @NonNull final String sMode,
                                           final int nPriority)
  {
    final IMicroElement aTemplate = aStylesheet.addElementNS (XSLT_NS, "template");
    aTemplate.setAttribute ("match", aRule.getContext ());
    aTemplate.setAttribute ("priority", Integer.toString (nPriority));
    aTemplate.setAttribute ("mode", sMode);

    // <svrl:fired-rule context="..."/>
    final IMicroElement aFired = aTemplate.addElementNS (CSVRL.SVRL_NAMESPACE_URI, "fired-rule");
    aFired.setAttribute ("context", _escapeAvt (aRule.getContext ()));
    if (StringHelper.isNotEmpty (aRule.getID ()))
      aFired.setAttribute ("id", _escapeAvt (aRule.getID ()));
    if (StringHelper.isNotEmpty (aRule.getFlag ()))
      aFired.setAttribute ("flag", _escapeAvt (aRule.getFlag ()));

    // Per assert/report
    for (final PSAssertReport aAR : aRule.getAllAssertReports ())
      _appendAssertReport (aTemplate, aAR);

    // Descend
    final IMicroElement aApply = aTemplate.addElementNS (XSLT_NS, "apply-templates");
    aApply.setAttribute ("mode", sMode);
  }

  private static void _appendAssertReport (@NonNull final IMicroElement aRuleTemplate,
                                           @NonNull final PSAssertReport aAR)
  {
    final String sTest = aAR.getTest ();
    if (StringHelper.isEmpty (sTest))
    {
      LOGGER.warn ("Skipping " + (aAR.isAssert () ? "assert" : "report") + " with empty test expression");
      return;
    }
    if (aAR.isReport ())
    {
      LOGGER.warn ("Skipping <sch:report> with test '" +
                   sTest +
                   "' - reports are not yet supported in the Saxon-native engine (Phase 1)");
      return;
    }
    // <xsl:if test="not({test})"><svrl:failed-assert
    // test="{test}"><svrl:text>...</svrl:text></svrl:failed-assert></xsl:if>
    final IMicroElement aIf = aRuleTemplate.addElementNS (XSLT_NS, "if");
    aIf.setAttribute ("test", "not(" + sTest + ")");

    final IMicroElement aFailed = aIf.addElementNS (CSVRL.SVRL_NAMESPACE_URI, "failed-assert");
    aFailed.setAttribute ("test", _escapeAvt (sTest));
    // XSLT attribute value template: Saxon evaluates fn:path(.) at runtime and substitutes
    // the canonical XPath of the offending context node. Required by the SVRL XSD.
    aFailed.setAttribute ("location", "{path(.)}");
    if (StringHelper.isNotEmpty (aAR.getID ()))
      aFailed.setAttribute ("id", _escapeAvt (aAR.getID ()));
    if (StringHelper.isNotEmpty (aAR.getFlag ()))
      aFailed.setAttribute ("flag", _escapeAvt (aAR.getFlag ()));

    final IMicroElement aText = aFailed.addElementNS (CSVRL.SVRL_NAMESPACE_URI, "text");
    aText.addText (_joinTexts (aAR));
  }

  @NonNull
  private static String _joinTexts (@NonNull final PSAssertReport aAR)
  {
    final var aTexts = aAR.getAllTexts ();
    if (aTexts.isEmpty ())
      return "";
    if (aTexts.size () == 1)
      return aTexts.getFirstOrNull ();
    return StringImplode.imploder ().source (aTexts).separator (' ').build ();
  }

  @NonNull
  private static String _modeName (final int nPatternIdx)
  {
    return "M" + nPatternIdx;
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
   * Build the namespace context used to serialize the generated stylesheet. Maps:
   * <ul>
   * <li>The XSLT namespace to the {@code xsl} prefix (so XSLT elements render as
   * {@code xsl:*})</li>
   * <li>The SVRL namespace to the {@code svrl} prefix</li>
   * <li>Each schema-declared {@code <sch:ns>} to its own prefix so XPath expressions referencing
   * those prefixes resolve correctly when Saxon compiles and runs the stylesheet</li>
   * </ul>
   *
   * @param aSchema
   *        The schema. May not be <code>null</code>.
   * @return A namespace context suitable for {@code XMLWriterSettings.setNamespaceContext}.
   */
  @NonNull
  public static MapBasedNamespaceContext namespaceContextFor (@NonNull final PSSchema aSchema)
  {
    final MapBasedNamespaceContext ret = new MapBasedNamespaceContext ();
    ret.addMapping (XSLT_PREFIX, XSLT_NS);
    ret.addMapping (SVRL_PREFIX, CSVRL.SVRL_NAMESPACE_URI);
    for (final PSNS aNS : aSchema.getAllNSs ())
    {
      final String sPrefix = aNS.getPrefix ();
      final String sURI = aNS.getUri ();
      if (StringHelper.isNotEmpty (sPrefix) && StringHelper.isNotEmpty (sURI) && !ret.isPrefixMapped (sPrefix))
        ret.addMapping (sPrefix, sURI);
    }
    return ret;
  }
}
