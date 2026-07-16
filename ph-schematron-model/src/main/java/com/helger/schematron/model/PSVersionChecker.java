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
package com.helger.schematron.model;

import java.util.Map;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.SingleError;
import com.helger.schematron.ESchematronVersion;
import com.helger.schematron.errorhandler.IPSErrorHandler;

/**
 * Central helper that emits warnings when the model uses a Schematron feature whose minimum
 * required edition is higher than the {@code schematronEdition} declared on the carrying
 * {@link PSSchema}. The warning text and severity are produced in a single place
 * (_warnFeatureUnavailable) so the policy can be changed in one place - for example, to change
 * warnings to info messages, or to make them errors, without touching every call site.
 * <p>
 * Call {@link #checkSchematronVersionCompliance(PSSchema, IPSErrorHandler)} to walk a schema and
 * report every feature used outside the edition that introduced it.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class PSVersionChecker
{
  @PresentForCodeCoverage
  private static final PSVersionChecker INSTANCE = new PSVersionChecker ();

  private PSVersionChecker ()
  {}

  /**
   * The single point where all &quot;feature not available in declared edition&quot; warnings are
   * emitted. Change the formatting, the severity, or the channel (warning vs. error) here to affect
   * every check uniformly.
   *
   * @param aSourceElement
   *        The model element in which the feature appears. Used for the error field name.
   * @param sFeatureName
   *        A short, human-readable name of the feature, e.g. <code>"&lt;group&gt; element"</code>.
   * @param eRequiredEdition
   *        The minimum Schematron edition that introduced the feature.
   * @param eDeclaredEdition
   *        The edition declared by the schema, or <code>null</code> if no
   *        <code>schematronEdition</code> attribute is set.
   * @param aErrorHandler
   *        The error handler to receive the warning.
   */
  private static void _warnFeatureUnavailable (@NonNull final IPSElement aSourceElement,
                                               @NonNull @Nonempty final String sFeatureName,
                                               @NonNull final ESchematronVersion eRequiredEdition,
                                               @Nullable final ESchematronVersion eDeclaredEdition,
                                               @NonNull final IPSErrorHandler aErrorHandler)
  {
    final StringBuilder aSB = new StringBuilder ();
    aSB.append (sFeatureName)
       .append (" was introduced in ISO/IEC 19757-3:")
       .append (eRequiredEdition.getEditionYear ());
    if (eDeclaredEdition == null)
      aSB.append (" but the schema does not declare a schematronEdition.");
    else
      aSB.append (" but the schema declares schematronEdition='")
         .append (eDeclaredEdition.getEditionYear ())
         .append ("'.");
    aErrorHandler.handleError (SingleError.builderWarn ()
                                          .errorFieldName (IPSErrorHandler.getErrorFieldName (aSourceElement))
                                          .errorText (aSB.toString ())
                                          .build ());
  }

  private static void _warnIfTooOld (@NonNull final IPSElement aSource,
                                     @NonNull @Nonempty final String sFeature,
                                     @NonNull final ESchematronVersion eRequired,
                                     @Nullable final ESchematronVersion eDeclared,
                                     @NonNull final IPSErrorHandler aErrorHandler)
  {
    // Warn if the schema declares no edition, or declares an edition older than the feature
    // requires
    if (eDeclared == null || eDeclared.isOlderThan (eRequired))
      _warnFeatureUnavailable (aSource, sFeature, eRequired, eDeclared, aErrorHandler);
  }

  private static void _checkLet (@NonNull final PSLet aLet,
                                 @Nullable final ESchematronVersion eDeclared,
                                 @NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isNotEmpty (aLet.getAs ()))
      _warnIfTooOld (aLet, "'as' attribute on <let>", ESchematronVersion.SCHEMATRON_2025, eDeclared, aErrorHandler);
  }

  private static void _checkPhase (@NonNull final PSPhase aPhase,
                                   @Nullable final ESchematronVersion eDeclared,
                                   @NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isNotEmpty (aPhase.getFrom ()))
      _warnIfTooOld (aPhase,
                     "'from' attribute on <phase>",
                     ESchematronVersion.SCHEMATRON_2025,
                     eDeclared,
                     aErrorHandler);
    if (StringHelper.isNotEmpty (aPhase.getWhen ()))
      _warnIfTooOld (aPhase,
                     "'when' attribute on <phase>",
                     ESchematronVersion.SCHEMATRON_2025,
                     eDeclared,
                     aErrorHandler);
    for (final PSLet aLet : aPhase.getAllLets ())
      _checkLet (aLet, eDeclared, aErrorHandler);
  }

  private static void _checkPatternLike (@NonNull final AbstractPSPatternLike aPattern,
                                         @Nullable final ESchematronVersion eDeclared,
                                         @NonNull final IPSErrorHandler aErrorHandler)
  {
    final String sLocalName = aPattern instanceof PSGroup ? "group" : "pattern";

    // v2 (2016) introduced the 'documents' attribute on pattern.
    if (StringHelper.isNotEmpty (aPattern.getDocuments ()))
      _warnIfTooOld (aPattern,
                     "'documents' attribute on <" + sLocalName + ">",
                     ESchematronVersion.SCHEMATRON_2016,
                     eDeclared,
                     aErrorHandler);

    // v4 RNC adds <let> and <param> to the abstract branch of rule-set-or-pattern.
    // Pre-2025 RNCs did not permit them on abstract patterns - warn through the central channel.
    if (aPattern.isAbstract ())
    {
      if (aPattern.hasAnyLet ())
        _warnIfTooOld (aPattern,
                       "<let> inside abstract <" + sLocalName + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
      if (aPattern.hasAnyParam ())
        _warnIfTooOld (aPattern,
                       "<param> inside abstract <" + sLocalName + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
    }
    for (final PSLet aLet : aPattern.getAllLets ())
      _checkLet (aLet, eDeclared, aErrorHandler);
    for (final PSRule aRule : aPattern.getAllRules ())
      _checkRule (aRule, eDeclared, aErrorHandler);
  }

  /**
   * Reserved <code>queryBinding</code> names added in each ISO/IEC 19757-3 edition. The pre-2016
   * editions reserved only {@code xslt} and {@code xpath}; later editions added more.
   */
  private static final Map <String, ESchematronVersion> QUERY_BINDING_MIN = Map.ofEntries (Map.entry ("xslt",
                                                                                                      ESchematronVersion.SCHEMATRON_2006),
                                                                                           Map.entry ("xpath",
                                                                                                      ESchematronVersion.SCHEMATRON_2006),
                                                                                           Map.entry ("xslt1",
                                                                                                      ESchematronVersion.SCHEMATRON_2016),
                                                                                           Map.entry ("xslt2",
                                                                                                      ESchematronVersion.SCHEMATRON_2016),
                                                                                           Map.entry ("xpath2",
                                                                                                      ESchematronVersion.SCHEMATRON_2016),
                                                                                           Map.entry ("exslt",
                                                                                                      ESchematronVersion.SCHEMATRON_2016),
                                                                                           Map.entry ("stx",
                                                                                                      ESchematronVersion.SCHEMATRON_2016),
                                                                                           Map.entry ("xquery",
                                                                                                      ESchematronVersion.SCHEMATRON_2016),
                                                                                           Map.entry ("xslt3",
                                                                                                      ESchematronVersion.SCHEMATRON_2020),
                                                                                           Map.entry ("xpath3",
                                                                                                      ESchematronVersion.SCHEMATRON_2020),
                                                                                           Map.entry ("xpath31",
                                                                                                      ESchematronVersion.SCHEMATRON_2020),
                                                                                           Map.entry ("xquery3",
                                                                                                      ESchematronVersion.SCHEMATRON_2020),
                                                                                           Map.entry ("xquery31",
                                                                                                      ESchematronVersion.SCHEMATRON_2020),
                                                                                           Map.entry ("xslt4",
                                                                                                      ESchematronVersion.SCHEMATRON_2025),
                                                                                           Map.entry ("xpath4",
                                                                                                      ESchematronVersion.SCHEMATRON_2025),
                                                                                           Map.entry ("xquery4",
                                                                                                      ESchematronVersion.SCHEMATRON_2025));

  private static void _checkExtends (@NonNull final PSExtends aExtends,
                                     @Nullable final ESchematronVersion eDeclared,
                                     @NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isNotEmpty (aExtends.getHref ()))
      _warnIfTooOld (aExtends,
                     "'href' attribute on <extends>",
                     ESchematronVersion.SCHEMATRON_2016,
                     eDeclared,
                     aErrorHandler);
  }

  private static void _checkDirEmphSpan (@NonNull final IPSElement aOwner,
                                         @NonNull @Nonempty final String sOwnerLabel,
                                         @NonNull final ICommonsList <Object> aChildren,
                                         @Nullable final ESchematronVersion eDeclared,
                                         @NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aChild : aChildren)
    {
      if (aChild instanceof PSValueOf)
      {
        _warnIfTooOld (aOwner,
                       "<value-of> inside <" + sOwnerLabel + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
        return;
      }
      if (aChild instanceof PSName)
      {
        _warnIfTooOld (aOwner,
                       "<name> inside <" + sOwnerLabel + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
        return;
      }
    }
  }

  private static void _checkMessageChildren (@NonNull final ICommonsList <Object> aContent,
                                             @Nullable final ESchematronVersion eDeclared,
                                             @NonNull final IPSErrorHandler aErrorHandler)
  {
    for (final Object aChild : aContent)
    {
      if (aChild instanceof final PSDir aDir)
      {
        final ICommonsList <Object> aDirContent = new CommonsArrayList <> ();
        for (final String sText : aDir.getAllTexts ())
          aDirContent.add (sText);
        for (final PSName aName : aDir.getAllNames ())
          aDirContent.add (aName);
        for (final PSValueOf aVO : aDir.getAllValueOfs ())
          aDirContent.add (aVO);
        _checkDirEmphSpan (aDir, "dir", aDirContent, eDeclared, aErrorHandler);
      }
      else
        if (aChild instanceof final PSEmph aEmph)
        {
          final ICommonsList <Object> aEmphContent = new CommonsArrayList <> ();
          for (final String sText : aEmph.getAllTexts ())
            aEmphContent.add (sText);
          for (final PSName aName : aEmph.getAllNames ())
            aEmphContent.add (aName);
          for (final PSValueOf aVO : aEmph.getAllValueOfs ())
            aEmphContent.add (aVO);
          _checkDirEmphSpan (aEmph, "emph", aEmphContent, eDeclared, aErrorHandler);
        }
        else
          if (aChild instanceof final PSSpan aSpan)
          {
            final ICommonsList <Object> aSpanContent = new CommonsArrayList <> ();
            for (final String sText : aSpan.getAllTexts ())
              aSpanContent.add (sText);
            for (final PSName aName : aSpan.getAllNames ())
              aSpanContent.add (aName);
            for (final PSValueOf aVO : aSpan.getAllValueOfs ())
              aSpanContent.add (aVO);
            _checkDirEmphSpan (aSpan, "span", aSpanContent, eDeclared, aErrorHandler);
          }
    }
  }

  private static void _checkDiagnostic (@NonNull final PSDiagnostic aDiagnostic,
                                        @Nullable final ESchematronVersion eDeclared,
                                        @NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isNotEmpty (aDiagnostic.getRole ()))
      _warnIfTooOld (aDiagnostic,
                     "'role' attribute on <diagnostic>",
                     ESchematronVersion.SCHEMATRON_2020,
                     eDeclared,
                     aErrorHandler);
    _checkMessageChildren (aDiagnostic.getAllContentElements (), eDeclared, aErrorHandler);
  }

  private static void _checkRule (@NonNull final PSRule aRule,
                                  @Nullable final ESchematronVersion eDeclared,
                                  @NonNull final IPSErrorHandler aErrorHandler)
  {
    if (StringHelper.isNotEmpty (aRule.getVisitEach ()))
      _warnIfTooOld (aRule,
                     "'visit-each' attribute on <rule>",
                     ESchematronVersion.SCHEMATRON_2025,
                     eDeclared,
                     aErrorHandler);
    if (StringHelper.isNotEmpty (aRule.getSeverity ()))
      _warnIfTooOld (aRule,
                     "'severity' attribute on <rule>",
                     ESchematronVersion.SCHEMATRON_2025,
                     eDeclared,
                     aErrorHandler);
    // Multi-token flag is only allowed by the 2025 RNC (list { token+ }); earlier editions
    // treated flag as a single token.
    if (aRule.getAllFlags ().size () > 1)
      _warnIfTooOld (aRule,
                     "multi-token 'flag' attribute on <rule>",
                     ESchematronVersion.SCHEMATRON_2025,
                     eDeclared,
                     aErrorHandler);
    for (final PSLet aLet : aRule.getAllLets ())
      _checkLet (aLet, eDeclared, aErrorHandler);
    for (final PSAssertReport aAR : aRule.getAllAssertReports ())
    {
      final String sAR = aAR.isAssert () ? "assert" : "report";
      if (StringHelper.isNotEmpty (aAR.getSeverity ()))
        _warnIfTooOld (aAR,
                       "'severity' attribute on <" + sAR + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
      if (aAR.getAllFlags ().size () > 1)
        _warnIfTooOld (aAR,
                       "multi-token 'flag' attribute on <" + sAR + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
      if (!aAR.getAllProperties ().isEmpty ())
        _warnIfTooOld (aAR,
                       "'properties' IDREFS on <" + sAR + ">",
                       ESchematronVersion.SCHEMATRON_2016,
                       eDeclared,
                       aErrorHandler);
      _checkMessageChildren (aAR.getAllContentElements (), eDeclared, aErrorHandler);
    }
  }

  /**
   * Walk the given schema and emit a warning for every Schematron feature whose introducing edition
   * is newer than the schema's declared {@link PSSchema#getSchematronEdition() schematronEdition}
   * (or whenever no edition is declared at all). The walk visits the schema's own
   * attributes/children, every contained {@link PSPattern}/{@link PSGroup} (including their rules
   * and assert/report children), every {@link PSPhase}, every top-level
   * {@link PSExtends}/{@link PSParam} and every {@link PSRules} abstract-rules container.
   *
   * @param aSchema
   *        The schema to check. May not be <code>null</code>.
   * @param aErrorHandler
   *        Where warnings are sent. May not be <code>null</code>.
   */
  public static void checkSchematronVersionCompliance (@NonNull final PSSchema aSchema,
                                                       @NonNull final IPSErrorHandler aErrorHandler)
  {
    ValueEnforcer.notNull (aSchema, "Schema");
    ValueEnforcer.notNull (aErrorHandler, "ErrorHandler");

    final ESchematronVersion eDeclared = aSchema.getSchematronEdition ();

    // Schema-level 2025 features
    if (aSchema.hasAnyExtends ())
      _warnIfTooOld (aSchema, "top-level <extends>", ESchematronVersion.SCHEMATRON_2025, eDeclared, aErrorHandler);
    if (aSchema.hasAnyParam ())
      _warnIfTooOld (aSchema, "top-level <param>", ESchematronVersion.SCHEMATRON_2025, eDeclared, aErrorHandler);
    if (aSchema.hasAnyGroup ())
      _warnIfTooOld (aSchema, "<group> element", ESchematronVersion.SCHEMATRON_2025, eDeclared, aErrorHandler);
    if (aSchema.hasAnyAbstractRulesContainer ())
      _warnIfTooOld (aSchema,
                     "<rules> abstract-rules container",
                     ESchematronVersion.SCHEMATRON_2025,
                     eDeclared,
                     aErrorHandler);

    // queryBinding reserved names map to edition: warn ONLY when the schema declares an edition
    // older than the one that introduced the binding name. Pre-2025 schemas typically never
    // declared a schematronEdition, so eDeclared == null is treated as &quot;unknown, no
    // warning&quot;
    // here (unlike most other checks where missing edition triggers the warning).
    if (eDeclared != null && StringHelper.isNotEmpty (aSchema.getQueryBinding ()))
    {
      final ESchematronVersion eBindingMin = QUERY_BINDING_MIN.get (aSchema.getQueryBinding ());
      if (eBindingMin != null && eDeclared.isOlderThan (eBindingMin))
        _warnFeatureUnavailable (aSchema,
                                 "queryBinding='" + aSchema.getQueryBinding () + "'",
                                 eBindingMin,
                                 eDeclared,
                                 aErrorHandler);
    }

    // 2016 properties feature (schema-level container)
    if (aSchema.hasProperties ())
      _warnIfTooOld (aSchema, "<properties> container", ESchematronVersion.SCHEMATRON_2016, eDeclared, aErrorHandler);

    // Schema-level lets (2025 'as' attribute)
    for (final PSLet aLet : aSchema.getAllLets ())
      _checkLet (aLet, eDeclared, aErrorHandler);

    // Top-level extends carry the 2016 'href' attribute alternative
    for (final PSExtends aExtends : aSchema.getAllExtends ())
      _checkExtends (aExtends, eDeclared, aErrorHandler);

    // Phases
    for (final PSPhase aPhase : aSchema.getAllPhases ())
      _checkPhase (aPhase, eDeclared, aErrorHandler);

    // Patterns and groups share content model - check both the same way.
    for (final PSPattern aPattern : aSchema.getAllPatterns ())
      _checkPatternLike (aPattern, eDeclared, aErrorHandler);
    for (final PSGroup aGroup : aSchema.getAllGroups ())
      _checkPatternLike (aGroup, eDeclared, aErrorHandler);

    // 2025 abstract-rules containers carry rules that may use new attributes
    for (final PSRules aRules : aSchema.getAllAbstractRulesContainers ())
      for (final PSRule aRule : aRules.getAllAbstractRules ())
        _checkRule (aRule, eDeclared, aErrorHandler);

    // Diagnostics: 2020 introduced the 'role' attribute on <diagnostic>.
    if (aSchema.hasDiagnostics ())
      for (final PSDiagnostic aDiagnostic : aSchema.getDiagnostics ().getAllDiagnostics ())
        _checkDiagnostic (aDiagnostic, eDeclared, aErrorHandler);
  }
}
