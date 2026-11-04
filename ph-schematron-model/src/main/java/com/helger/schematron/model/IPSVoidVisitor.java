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

import com.helger.xml.microdom.IMicroElement;

/**
 * Visitor for a {@link PSSchema} that cannot stop the walk. It offers the same callbacks as
 * {@link IPSVisitor} but without a return value. Use {@link PSVoidVisitorWrapper} to turn it into
 * an {@link IPSVisitor}, or call {@link PSVisitor#visit(PSSchema, IPSVoidVisitor)} directly.<br>
 * All methods have a default implementation that does nothing, so only the relevant methods need
 * to be overridden.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
public interface IPSVoidVisitor
{
  /**
   * Called before the children of the schema are visited.
   *
   * @param aSchema
   *        The schema. Never <code>null</code>.
   */
  default void onSchemaStart (@NonNull final PSSchema aSchema)
  {}

  /**
   * Called after the children of the schema were visited.
   *
   * @param aSchema
   *        The schema. Never <code>null</code>.
   */
  default void onSchemaEnd (@NonNull final PSSchema aSchema)
  {}

  /**
   * Called for each <code>&lt;include&gt;</code> element. Includes are not resolved.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aInclude
   *        The include. Never <code>null</code>.
   */
  default void onInclude (@NonNull final IPSElement aParent, @NonNull final PSInclude aInclude)
  {}

  /**
   * Called for each <code>&lt;extends&gt;</code> element. Extends are not resolved.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aExtends
   *        The extends. Never <code>null</code>.
   */
  default void onExtends (@NonNull final IPSElement aParent, @NonNull final PSExtends aExtends)
  {}

  /**
   * Called for each <code>&lt;ns&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aNs
   *        The namespace declaration. Never <code>null</code>.
   */
  default void onNs (@NonNull final IPSElement aParent, @NonNull final PSNS aNs)
  {}

  /**
   * Called for each <code>&lt;param&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aParam
   *        The parameter. Never <code>null</code>.
   */
  default void onParam (@NonNull final IPSElement aParent, @NonNull final PSParam aParam)
  {}

  /**
   * Called for each <code>&lt;let&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aLet
   *        The variable. Never <code>null</code>.
   */
  default void onLet (@NonNull final IPSElement aParent, @NonNull final PSLet aLet)
  {}

  /**
   * Called before the children of a <code>&lt;title&gt;</code> element are visited.
   *
   * @param aTitle
   *        The title. Never <code>null</code>.
   */
  default void onTitleStart (@NonNull final PSTitle aTitle)
  {}

  /**
   * Called after the children of a <code>&lt;title&gt;</code> element were visited.
   *
   * @param aTitle
   *        The title. Never <code>null</code>.
   */
  default void onTitleEnd (@NonNull final PSTitle aTitle)
  {}

  /**
   * Called before the children of a <code>&lt;p&gt;</code> element are visited.
   *
   * @param aP
   *        The paragraph. Never <code>null</code>.
   */
  default void onPStart (@NonNull final PSP aP)
  {}

  /**
   * Called after the children of a <code>&lt;p&gt;</code> element were visited.
   *
   * @param aP
   *        The paragraph. Never <code>null</code>.
   */
  default void onPEnd (@NonNull final PSP aP)
  {}

  /**
   * Called before the children of a <code>&lt;phase&gt;</code> element are visited.
   *
   * @param aPhase
   *        The phase. Never <code>null</code>.
   */
  default void onPhaseStart (@NonNull final PSPhase aPhase)
  {}

  /**
   * Called after the children of a <code>&lt;phase&gt;</code> element were visited.
   *
   * @param aPhase
   *        The phase. Never <code>null</code>.
   */
  default void onPhaseEnd (@NonNull final PSPhase aPhase)
  {}

  /**
   * Called before the children of an <code>&lt;active&gt;</code> element are visited.
   *
   * @param aActive
   *        The active pattern reference. Never <code>null</code>.
   */
  default void onActiveStart (@NonNull final PSActive aActive)
  {}

  /**
   * Called after the children of an <code>&lt;active&gt;</code> element were visited.
   *
   * @param aActive
   *        The active pattern reference. Never <code>null</code>.
   */
  default void onActiveEnd (@NonNull final PSActive aActive)
  {}

  /**
   * Called before the children of a <code>&lt;rules&gt;</code> element are visited.
   *
   * @param aRules
   *        The abstract rules container. Never <code>null</code>.
   */
  default void onRulesStart (@NonNull final PSRules aRules)
  {}

  /**
   * Called after the children of a <code>&lt;rules&gt;</code> element were visited.
   *
   * @param aRules
   *        The abstract rules container. Never <code>null</code>.
   */
  default void onRulesEnd (@NonNull final PSRules aRules)
  {}

  /**
   * Called before the children of a <code>&lt;pattern&gt;</code> element are visited.
   *
   * @param aPattern
   *        The pattern. Never <code>null</code>.
   */
  default void onPatternStart (@NonNull final PSPattern aPattern)
  {}

  /**
   * Called after the children of a <code>&lt;pattern&gt;</code> element were visited.
   *
   * @param aPattern
   *        The pattern. Never <code>null</code>.
   */
  default void onPatternEnd (@NonNull final PSPattern aPattern)
  {}

  /**
   * Called before the children of a <code>&lt;group&gt;</code> element are visited.
   *
   * @param aGroup
   *        The group. Never <code>null</code>.
   */
  default void onGroupStart (@NonNull final PSGroup aGroup)
  {}

  /**
   * Called after the children of a <code>&lt;group&gt;</code> element were visited.
   *
   * @param aGroup
   *        The group. Never <code>null</code>.
   */
  default void onGroupEnd (@NonNull final PSGroup aGroup)
  {}

  /**
   * Called before the children of a <code>&lt;rule&gt;</code> element are visited.
   *
   * @param aRule
   *        The rule. Never <code>null</code>.
   */
  default void onRuleStart (@NonNull final PSRule aRule)
  {}

  /**
   * Called after the children of a <code>&lt;rule&gt;</code> element were visited.
   *
   * @param aRule
   *        The rule. Never <code>null</code>.
   */
  default void onRuleEnd (@NonNull final PSRule aRule)
  {}

  /**
   * Called before the children of an <code>&lt;assert&gt;</code> or <code>&lt;report&gt;</code>
   * element are visited.
   *
   * @param aAssertReport
   *        The assert or report. Never <code>null</code>.
   */
  default void onAssertReportStart (@NonNull final PSAssertReport aAssertReport)
  {}

  /**
   * Called after the children of an <code>&lt;assert&gt;</code> or <code>&lt;report&gt;</code>
   * element were visited.
   *
   * @param aAssertReport
   *        The assert or report. Never <code>null</code>.
   */
  default void onAssertReportEnd (@NonNull final PSAssertReport aAssertReport)
  {}

  /**
   * Called before the children of the <code>&lt;diagnostics&gt;</code> element are visited.
   *
   * @param aDiagnostics
   *        The diagnostics container. Never <code>null</code>.
   */
  default void onDiagnosticsStart (@NonNull final PSDiagnostics aDiagnostics)
  {}

  /**
   * Called after the children of the <code>&lt;diagnostics&gt;</code> element were visited.
   *
   * @param aDiagnostics
   *        The diagnostics container. Never <code>null</code>.
   */
  default void onDiagnosticsEnd (@NonNull final PSDiagnostics aDiagnostics)
  {}

  /**
   * Called before the children of a <code>&lt;diagnostic&gt;</code> element are visited.
   *
   * @param aDiagnostic
   *        The diagnostic. Never <code>null</code>.
   */
  default void onDiagnosticStart (@NonNull final PSDiagnostic aDiagnostic)
  {}

  /**
   * Called after the children of a <code>&lt;diagnostic&gt;</code> element were visited.
   *
   * @param aDiagnostic
   *        The diagnostic. Never <code>null</code>.
   */
  default void onDiagnosticEnd (@NonNull final PSDiagnostic aDiagnostic)
  {}

  /**
   * Called before the children of the <code>&lt;properties&gt;</code> element are visited.
   *
   * @param aProperties
   *        The properties container. Never <code>null</code>.
   */
  default void onPropertiesStart (@NonNull final PSProperties aProperties)
  {}

  /**
   * Called after the children of the <code>&lt;properties&gt;</code> element were visited.
   *
   * @param aProperties
   *        The properties container. Never <code>null</code>.
   */
  default void onPropertiesEnd (@NonNull final PSProperties aProperties)
  {}

  /**
   * Called before the children of a <code>&lt;property&gt;</code> element are visited.
   *
   * @param aProperty
   *        The property. Never <code>null</code>.
   */
  default void onPropertyStart (@NonNull final PSProperty aProperty)
  {}

  /**
   * Called after the children of a <code>&lt;property&gt;</code> element were visited.
   *
   * @param aProperty
   *        The property. Never <code>null</code>.
   */
  default void onPropertyEnd (@NonNull final PSProperty aProperty)
  {}

  /**
   * Called before the children of a <code>&lt;dir&gt;</code> element are visited.
   *
   * @param aDir
   *        The dir element. Never <code>null</code>.
   */
  default void onDirStart (@NonNull final PSDir aDir)
  {}

  /**
   * Called after the children of a <code>&lt;dir&gt;</code> element were visited.
   *
   * @param aDir
   *        The dir element. Never <code>null</code>.
   */
  default void onDirEnd (@NonNull final PSDir aDir)
  {}

  /**
   * Called before the children of an <code>&lt;emph&gt;</code> element are visited.
   *
   * @param aEmph
   *        The emph element. Never <code>null</code>.
   */
  default void onEmphStart (@NonNull final PSEmph aEmph)
  {}

  /**
   * Called after the children of an <code>&lt;emph&gt;</code> element were visited.
   *
   * @param aEmph
   *        The emph element. Never <code>null</code>.
   */
  default void onEmphEnd (@NonNull final PSEmph aEmph)
  {}

  /**
   * Called before the children of a <code>&lt;span&gt;</code> element are visited.
   *
   * @param aSpan
   *        The span element. Never <code>null</code>.
   */
  default void onSpanStart (@NonNull final PSSpan aSpan)
  {}

  /**
   * Called after the children of a <code>&lt;span&gt;</code> element were visited.
   *
   * @param aSpan
   *        The span element. Never <code>null</code>.
   */
  default void onSpanEnd (@NonNull final PSSpan aSpan)
  {}

  /**
   * Called for each <code>&lt;name&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aName
   *        The name element. Never <code>null</code>.
   */
  default void onName (@NonNull final IPSElement aParent, @NonNull final PSName aName)
  {}

  /**
   * Called for each <code>&lt;value-of&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aValueOf
   *        The value-of element. Never <code>null</code>.
   */
  default void onValueOf (@NonNull final IPSElement aParent, @NonNull final PSValueOf aValueOf)
  {}

  /**
   * Called for each text node of an element with mixed content.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param sText
   *        The text. Never <code>null</code>.
   */
  default void onTextContent (@NonNull final IPSElement aParent, @NonNull final String sText)
  {}

  /**
   * Called for each foreign (non-Schematron) element. Foreign elements are not descended into.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aForeignElement
   *        The foreign element. Never <code>null</code>.
   */
  default void onForeignElement (@NonNull final IPSElement aParent, @NonNull final IMicroElement aForeignElement)
  {}
}
