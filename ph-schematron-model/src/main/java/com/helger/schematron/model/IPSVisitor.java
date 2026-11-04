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

import com.helger.base.state.EContinue;
import com.helger.xml.microdom.IMicroElement;

/**
 * Visitor for a {@link PSSchema} as used by {@link PSVisitor}. Elements that may have children are
 * reported with a <code>...Start</code> and a <code>...End</code> callback, all other elements with
 * a single callback that also receives the parent element. Returning {@link EContinue#BREAK} from
 * any callback stops the whole walk immediately - no further callback (including the outstanding
 * <code>...End</code> callbacks) is invoked.<br>
 * All methods have a default implementation that does nothing and returns
 * {@link EContinue#CONTINUE}, so only the relevant methods need to be overridden.<br>
 * Use {@link IPSVoidVisitor} together with {@link PSVoidVisitorWrapper} if stopping the walk is
 * not needed.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
public interface IPSVisitor
{
  /**
   * Called before the children of the schema are visited.
   *
   * @param aSchema
   *        The schema. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSchemaStart (@NonNull final PSSchema aSchema)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of the schema were visited.
   *
   * @param aSchema
   *        The schema. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSchemaEnd (@NonNull final PSSchema aSchema)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;include&gt;</code> element. Includes are not resolved.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aInclude
   *        The include. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onInclude (@NonNull final IPSElement aParent, @NonNull final PSInclude aInclude)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;extends&gt;</code> element. Extends are not resolved.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aExtends
   *        The extends. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onExtends (@NonNull final IPSElement aParent, @NonNull final PSExtends aExtends)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;ns&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aNs
   *        The namespace declaration. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onNs (@NonNull final IPSElement aParent, @NonNull final PSNS aNs)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;param&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aParam
   *        The parameter. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onParam (@NonNull final IPSElement aParent, @NonNull final PSParam aParam)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;let&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aLet
   *        The variable. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onLet (@NonNull final IPSElement aParent, @NonNull final PSLet aLet)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;title&gt;</code> element are visited.
   *
   * @param aTitle
   *        The title. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onTitleStart (@NonNull final PSTitle aTitle)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;title&gt;</code> element were visited.
   *
   * @param aTitle
   *        The title. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onTitleEnd (@NonNull final PSTitle aTitle)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;p&gt;</code> element are visited.
   *
   * @param aP
   *        The paragraph. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPStart (@NonNull final PSP aP)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;p&gt;</code> element were visited.
   *
   * @param aP
   *        The paragraph. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPEnd (@NonNull final PSP aP)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;phase&gt;</code> element are visited.
   *
   * @param aPhase
   *        The phase. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPhaseStart (@NonNull final PSPhase aPhase)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;phase&gt;</code> element were visited.
   *
   * @param aPhase
   *        The phase. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPhaseEnd (@NonNull final PSPhase aPhase)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of an <code>&lt;active&gt;</code> element are visited.
   *
   * @param aActive
   *        The active pattern reference. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onActiveStart (@NonNull final PSActive aActive)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of an <code>&lt;active&gt;</code> element were visited.
   *
   * @param aActive
   *        The active pattern reference. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onActiveEnd (@NonNull final PSActive aActive)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;rules&gt;</code> element are visited.
   *
   * @param aRules
   *        The abstract rules container. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onRulesStart (@NonNull final PSRules aRules)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;rules&gt;</code> element were visited.
   *
   * @param aRules
   *        The abstract rules container. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onRulesEnd (@NonNull final PSRules aRules)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;pattern&gt;</code> element are visited.
   *
   * @param aPattern
   *        The pattern. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPatternStart (@NonNull final PSPattern aPattern)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;pattern&gt;</code> element were visited.
   *
   * @param aPattern
   *        The pattern. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPatternEnd (@NonNull final PSPattern aPattern)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;group&gt;</code> element are visited.
   *
   * @param aGroup
   *        The group. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onGroupStart (@NonNull final PSGroup aGroup)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;group&gt;</code> element were visited.
   *
   * @param aGroup
   *        The group. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onGroupEnd (@NonNull final PSGroup aGroup)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;rule&gt;</code> element are visited.
   *
   * @param aRule
   *        The rule. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onRuleStart (@NonNull final PSRule aRule)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;rule&gt;</code> element were visited.
   *
   * @param aRule
   *        The rule. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onRuleEnd (@NonNull final PSRule aRule)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of an <code>&lt;assert&gt;</code> or <code>&lt;report&gt;</code>
   * element are visited.
   *
   * @param aAssertReport
   *        The assert or report. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onAssertReportStart (@NonNull final PSAssertReport aAssertReport)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of an <code>&lt;assert&gt;</code> or <code>&lt;report&gt;</code>
   * element were visited.
   *
   * @param aAssertReport
   *        The assert or report. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onAssertReportEnd (@NonNull final PSAssertReport aAssertReport)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of the <code>&lt;diagnostics&gt;</code> element are visited.
   *
   * @param aDiagnostics
   *        The diagnostics container. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDiagnosticsStart (@NonNull final PSDiagnostics aDiagnostics)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of the <code>&lt;diagnostics&gt;</code> element were visited.
   *
   * @param aDiagnostics
   *        The diagnostics container. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDiagnosticsEnd (@NonNull final PSDiagnostics aDiagnostics)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;diagnostic&gt;</code> element are visited.
   *
   * @param aDiagnostic
   *        The diagnostic. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDiagnosticStart (@NonNull final PSDiagnostic aDiagnostic)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;diagnostic&gt;</code> element were visited.
   *
   * @param aDiagnostic
   *        The diagnostic. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDiagnosticEnd (@NonNull final PSDiagnostic aDiagnostic)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of the <code>&lt;properties&gt;</code> element are visited.
   *
   * @param aProperties
   *        The properties container. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPropertiesStart (@NonNull final PSProperties aProperties)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of the <code>&lt;properties&gt;</code> element were visited.
   *
   * @param aProperties
   *        The properties container. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPropertiesEnd (@NonNull final PSProperties aProperties)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;property&gt;</code> element are visited.
   *
   * @param aProperty
   *        The property. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPropertyStart (@NonNull final PSProperty aProperty)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;property&gt;</code> element were visited.
   *
   * @param aProperty
   *        The property. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPropertyEnd (@NonNull final PSProperty aProperty)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;dir&gt;</code> element are visited.
   *
   * @param aDir
   *        The dir element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDirStart (@NonNull final PSDir aDir)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;dir&gt;</code> element were visited.
   *
   * @param aDir
   *        The dir element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDirEnd (@NonNull final PSDir aDir)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of an <code>&lt;emph&gt;</code> element are visited.
   *
   * @param aEmph
   *        The emph element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onEmphStart (@NonNull final PSEmph aEmph)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of an <code>&lt;emph&gt;</code> element were visited.
   *
   * @param aEmph
   *        The emph element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onEmphEnd (@NonNull final PSEmph aEmph)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;span&gt;</code> element are visited.
   *
   * @param aSpan
   *        The span element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSpanStart (@NonNull final PSSpan aSpan)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;span&gt;</code> element were visited.
   *
   * @param aSpan
   *        The span element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSpanEnd (@NonNull final PSSpan aSpan)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;name&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aName
   *        The name element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onName (@NonNull final IPSElement aParent, @NonNull final PSName aName)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;value-of&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aValueOf
   *        The value-of element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onValueOf (@NonNull final IPSElement aParent, @NonNull final PSValueOf aValueOf)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each text node of an element with mixed content.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param sText
   *        The text. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onTextContent (@NonNull final IPSElement aParent, @NonNull final String sText)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each foreign (non-Schematron) element. Foreign elements are not descended into.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aForeignElement
   *        The foreign element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onForeignElement (@NonNull final IPSElement aParent, @NonNull final IMicroElement aForeignElement)
  {
    return EContinue.CONTINUE;
  }
}
