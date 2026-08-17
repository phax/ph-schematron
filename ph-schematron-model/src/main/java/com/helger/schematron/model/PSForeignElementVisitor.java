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

import java.util.function.BiConsumer;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.xml.microdom.IMicroElement;

/**
 * Central helper to find all foreign (non-Schematron) elements contained in a {@link PSSchema}.
 * Foreign elements are all elements that are not in the Schematron namespace - most commonly XSLT
 * elements like <code>&lt;xsl:function&gt;</code> or <code>&lt;xsl:variable&gt;</code>. They are
 * retained in the model by {@link com.helger.schematron.exchange.PSReader} but not every engine can
 * interpret them - engines that ignore them should tell the user about it.
 *
 * @author Philip Helger
 * @since 10.0.2
 */
@Immutable
public final class PSForeignElementVisitor
{
  @PresentForCodeCoverage
  private static final PSForeignElementVisitor INSTANCE = new PSForeignElementVisitor ();

  private PSForeignElementVisitor ()
  {}

  /**
   * Provide all foreign elements of a single element to the consumer. Elements that cannot have
   * foreign elements at all are silently ignored.
   *
   * @param aElement
   *        The element to be checked. May not be <code>null</code>.
   * @param aConsumer
   *        The consumer to be invoked for each foreign element. May not be <code>null</code>.
   */
  private static void _visitElement (@NonNull final IPSElement aElement,
                                     @NonNull final BiConsumer <IPSElement, IMicroElement> aConsumer)
  {
    if (aElement instanceof final IPSHasForeignElements aHasForeignElements)
      for (final IMicroElement aForeignElement : aHasForeignElements.getAllForeignElements ())
        aConsumer.accept (aElement, aForeignElement);
  }

  /**
   * Visit an element with mixed content (like <code>&lt;assert&gt;</code>,
   * <code>&lt;diagnostic&gt;</code> or <code>&lt;p&gt;</code>) and all of its rich text children
   * (<code>&lt;dir&gt;</code>, <code>&lt;emph&gt;</code> and <code>&lt;span&gt;</code>) - the latter
   * may carry foreign elements as well. Rich text children can only contain
   * <code>&lt;name&gt;</code> and <code>&lt;value-of&gt;</code> elements, so a single level of
   * nesting is sufficient here.
   *
   * @param aElement
   *        The element to be visited. May not be <code>null</code>.
   * @param aConsumer
   *        The consumer to be invoked for each foreign element. May not be <code>null</code>.
   */
  private static void _visitMixedContent (@NonNull final IPSElement aElement,
                                          @NonNull final BiConsumer <IPSElement, IMicroElement> aConsumer)
  {
    _visitElement (aElement, aConsumer);
    if (aElement instanceof final IPSHasMixedContent aMixedContent)
      for (final Object aContent : aMixedContent.getAllContentElements ())
        if (aContent instanceof final IPSElement aChildElement)
          _visitElement (aChildElement, aConsumer);
  }

  private static void _visitRule (@NonNull final PSRule aRule,
                                  @NonNull final BiConsumer <IPSElement, IMicroElement> aConsumer)
  {
    _visitElement (aRule, aConsumer);
    for (final PSAssertReport aAssertReport : aRule.getAllAssertReports ())
      _visitMixedContent (aAssertReport, aConsumer);
  }

  private static void _visitPatternLike (@NonNull final AbstractPSPatternLike aPatternLike,
                                         @NonNull final BiConsumer <IPSElement, IMicroElement> aConsumer)
  {
    _visitElement (aPatternLike, aConsumer);
    if (aPatternLike.hasTitle ())
      _visitMixedContent (aPatternLike.getTitle (), aConsumer);
    for (final PSP aP : aPatternLike.getAllPs ())
      _visitMixedContent (aP, aConsumer);
    for (final PSRule aRule : aPatternLike.getAllRules ())
      _visitRule (aRule, aConsumer);
  }

  private static void _visitPhase (@NonNull final PSPhase aPhase,
                                   @NonNull final BiConsumer <IPSElement, IMicroElement> aConsumer)
  {
    _visitElement (aPhase, aConsumer);
    for (final PSP aP : aPhase.getAllPs ())
      _visitMixedContent (aP, aConsumer);
    for (final PSActive aActive : aPhase.getAllActives ())
      _visitMixedContent (aActive, aConsumer);
  }

  private static void _visitRules (@NonNull final PSRules aRules,
                                   @NonNull final BiConsumer <IPSElement, IMicroElement> aConsumer)
  {
    if (aRules.hasTitle ())
      _visitMixedContent (aRules.getTitle (), aConsumer);
    for (final PSP aP : aRules.getAllPs ())
      _visitMixedContent (aP, aConsumer);
    for (final PSRule aRule : aRules.getAllAbstractRules ())
      _visitRule (aRule, aConsumer);
  }

  /**
   * Walk the whole schema and invoke the provided consumer for each contained foreign element. The
   * consumer receives the {@link IPSElement} in which the foreign element is contained as the first
   * parameter and the foreign element itself as the second parameter.
   *
   * @param aSchema
   *        The schema to be scanned. May not be <code>null</code>.
   * @param aConsumer
   *        The consumer to be invoked for each foreign element. May not be <code>null</code>.
   */
  public static void forEachForeignElement (@NonNull final PSSchema aSchema,
                                            @NonNull final BiConsumer <IPSElement, IMicroElement> aConsumer)
  {
    ValueEnforcer.notNull (aSchema, "Schema");
    ValueEnforcer.notNull (aConsumer, "Consumer");

    _visitElement (aSchema, aConsumer);
    if (aSchema.hasTitle ())
      _visitMixedContent (aSchema.getTitle (), aConsumer);
    for (final PSP aP : aSchema.getAllStartPs ())
      _visitMixedContent (aP, aConsumer);
    for (final PSPhase aPhase : aSchema.getAllPhases ())
      _visitPhase (aPhase, aConsumer);
    for (final PSRules aRules : aSchema.getAllAbstractRulesContainers ())
      _visitRules (aRules, aConsumer);
    // Patterns and groups share the content model - handle both the same way
    for (final PSPattern aPattern : aSchema.getAllPatterns ())
      _visitPatternLike (aPattern, aConsumer);
    for (final PSGroup aGroup : aSchema.getAllGroups ())
      _visitPatternLike (aGroup, aConsumer);
    for (final PSP aP : aSchema.getAllEndPs ())
      _visitMixedContent (aP, aConsumer);
    if (aSchema.hasDiagnostics ())
    {
      final PSDiagnostics aDiagnostics = aSchema.getDiagnostics ();
      _visitElement (aDiagnostics, aConsumer);
      for (final PSDiagnostic aDiagnostic : aDiagnostics.getAllDiagnostics ())
        _visitMixedContent (aDiagnostic, aConsumer);
    }
    if (aSchema.hasProperties ())
      for (final PSProperty aProperty : aSchema.getProperties ().getAllProperties ())
        _visitMixedContent (aProperty, aConsumer);
  }
}
