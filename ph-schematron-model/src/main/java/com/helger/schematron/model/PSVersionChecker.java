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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.diagnostics.error.SingleError;
import com.helger.schematron.ESchematronVersion;
import com.helger.schematron.errorhandler.IPSErrorHandler;

/**
 * Central helper that emits warnings when the model uses a Schematron feature whose minimum
 * required edition is higher than the {@code schematronEdition} declared on the carrying
 * {@link PSSchema}. The warning text and severity are produced in a single place
 * ({@link #_warnFeatureUnavailable(IPSElement, String, ESchematronVersion, ESchematronVersion, IPSErrorHandler)})
 * so the policy can be changed in one place &mdash; for example, to demote warnings to info
 * messages, or to make them errors, without touching every call site.
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
    // v4 RNC adds <let> and <param> to the abstract branch of rule-set-or-pattern.
    // Pre-2025 RNCs did not permit them on abstract patterns - warn through the central channel.
    if (aPattern.isAbstract ())
    {
      if (aPattern.hasAnyLet ())
        _warnIfTooOld (aPattern,
                       "<let> inside abstract <" + (aPattern instanceof PSGroup ? "group" : "pattern") + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
      if (aPattern.hasAnyParam ())
        _warnIfTooOld (aPattern,
                       "<param> inside abstract <" + (aPattern instanceof PSGroup ? "group" : "pattern") + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
    }
    for (final PSLet aLet : aPattern.getAllLets ())
      _checkLet (aLet, eDeclared, aErrorHandler);
    for (final PSRule aRule : aPattern.getAllRules ())
      _checkRule (aRule, eDeclared, aErrorHandler);
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
    for (final PSLet aLet : aRule.getAllLets ())
      _checkLet (aLet, eDeclared, aErrorHandler);
    for (final PSAssertReport aAR : aRule.getAllAssertReports ())
      if (StringHelper.isNotEmpty (aAR.getSeverity ()))
        _warnIfTooOld (aAR,
                       "'severity' attribute on <" + (aAR.isAssert () ? "assert" : "report") + ">",
                       ESchematronVersion.SCHEMATRON_2025,
                       eDeclared,
                       aErrorHandler);
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

    // Schema-level lets (2025 'as' attribute)
    for (final PSLet aLet : aSchema.getAllLets ())
      _checkLet (aLet, eDeclared, aErrorHandler);

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
  }
}
