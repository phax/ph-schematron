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

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EContinue;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.xml.microdom.IMicroElement;

/**
 * Wraps an {@link IPSVoidVisitor} into an {@link IPSVisitor}. All callbacks are forwarded to the
 * wrapped visitor and always return {@link EContinue#CONTINUE}.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
@Immutable
public class PSVoidVisitorWrapper implements IPSVisitor
{
  private final IPSVoidVisitor m_aVisitor;

  /**
   * Constructor
   *
   * @param aVisitor
   *        The visitor to be wrapped. May not be <code>null</code>.
   */
  public PSVoidVisitorWrapper (@NonNull final IPSVoidVisitor aVisitor)
  {
    ValueEnforcer.notNull (aVisitor, "Visitor");
    m_aVisitor = aVisitor;
  }

  /**
   * @return The wrapped visitor as passed in the constructor. Never <code>null</code>.
   */
  @NonNull
  public final IPSVoidVisitor getWrappedVisitor ()
  {
    return m_aVisitor;
  }

  @Override
  @NonNull
  public EContinue onSchemaStart (@NonNull final PSSchema aSchema)
  {
    m_aVisitor.onSchemaStart (aSchema);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSchemaEnd (@NonNull final PSSchema aSchema)
  {
    m_aVisitor.onSchemaEnd (aSchema);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onInclude (@NonNull final IPSElement aParent, @NonNull final PSInclude aInclude)
  {
    m_aVisitor.onInclude (aParent, aInclude);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onExtends (@NonNull final IPSElement aParent, @NonNull final PSExtends aExtends)
  {
    m_aVisitor.onExtends (aParent, aExtends);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onNs (@NonNull final IPSElement aParent, @NonNull final PSNS aNs)
  {
    m_aVisitor.onNs (aParent, aNs);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onParam (@NonNull final IPSElement aParent, @NonNull final PSParam aParam)
  {
    m_aVisitor.onParam (aParent, aParam);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onLet (@NonNull final IPSElement aParent, @NonNull final PSLet aLet)
  {
    m_aVisitor.onLet (aParent, aLet);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onTitleStart (@NonNull final PSTitle aTitle)
  {
    m_aVisitor.onTitleStart (aTitle);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onTitleEnd (@NonNull final PSTitle aTitle)
  {
    m_aVisitor.onTitleEnd (aTitle);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPStart (@NonNull final PSP aP)
  {
    m_aVisitor.onPStart (aP);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPEnd (@NonNull final PSP aP)
  {
    m_aVisitor.onPEnd (aP);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPhaseStart (@NonNull final PSPhase aPhase)
  {
    m_aVisitor.onPhaseStart (aPhase);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPhaseEnd (@NonNull final PSPhase aPhase)
  {
    m_aVisitor.onPhaseEnd (aPhase);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onActiveStart (@NonNull final PSActive aActive)
  {
    m_aVisitor.onActiveStart (aActive);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onActiveEnd (@NonNull final PSActive aActive)
  {
    m_aVisitor.onActiveEnd (aActive);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onRulesStart (@NonNull final PSRules aRules)
  {
    m_aVisitor.onRulesStart (aRules);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onRulesEnd (@NonNull final PSRules aRules)
  {
    m_aVisitor.onRulesEnd (aRules);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPatternStart (@NonNull final PSPattern aPattern)
  {
    m_aVisitor.onPatternStart (aPattern);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPatternEnd (@NonNull final PSPattern aPattern)
  {
    m_aVisitor.onPatternEnd (aPattern);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onGroupStart (@NonNull final PSGroup aGroup)
  {
    m_aVisitor.onGroupStart (aGroup);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onGroupEnd (@NonNull final PSGroup aGroup)
  {
    m_aVisitor.onGroupEnd (aGroup);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onRuleStart (@NonNull final PSRule aRule)
  {
    m_aVisitor.onRuleStart (aRule);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onRuleEnd (@NonNull final PSRule aRule)
  {
    m_aVisitor.onRuleEnd (aRule);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onAssertReportStart (@NonNull final PSAssertReport aAssertReport)
  {
    m_aVisitor.onAssertReportStart (aAssertReport);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onAssertReportEnd (@NonNull final PSAssertReport aAssertReport)
  {
    m_aVisitor.onAssertReportEnd (aAssertReport);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDiagnosticsStart (@NonNull final PSDiagnostics aDiagnostics)
  {
    m_aVisitor.onDiagnosticsStart (aDiagnostics);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDiagnosticsEnd (@NonNull final PSDiagnostics aDiagnostics)
  {
    m_aVisitor.onDiagnosticsEnd (aDiagnostics);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDiagnosticStart (@NonNull final PSDiagnostic aDiagnostic)
  {
    m_aVisitor.onDiagnosticStart (aDiagnostic);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDiagnosticEnd (@NonNull final PSDiagnostic aDiagnostic)
  {
    m_aVisitor.onDiagnosticEnd (aDiagnostic);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPropertiesStart (@NonNull final PSProperties aProperties)
  {
    m_aVisitor.onPropertiesStart (aProperties);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPropertiesEnd (@NonNull final PSProperties aProperties)
  {
    m_aVisitor.onPropertiesEnd (aProperties);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPropertyStart (@NonNull final PSProperty aProperty)
  {
    m_aVisitor.onPropertyStart (aProperty);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPropertyEnd (@NonNull final PSProperty aProperty)
  {
    m_aVisitor.onPropertyEnd (aProperty);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDirStart (@NonNull final PSDir aDir)
  {
    m_aVisitor.onDirStart (aDir);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDirEnd (@NonNull final PSDir aDir)
  {
    m_aVisitor.onDirEnd (aDir);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onEmphStart (@NonNull final PSEmph aEmph)
  {
    m_aVisitor.onEmphStart (aEmph);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onEmphEnd (@NonNull final PSEmph aEmph)
  {
    m_aVisitor.onEmphEnd (aEmph);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSpanStart (@NonNull final PSSpan aSpan)
  {
    m_aVisitor.onSpanStart (aSpan);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSpanEnd (@NonNull final PSSpan aSpan)
  {
    m_aVisitor.onSpanEnd (aSpan);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onName (@NonNull final IPSElement aParent, @NonNull final PSName aName)
  {
    m_aVisitor.onName (aParent, aName);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onValueOf (@NonNull final IPSElement aParent, @NonNull final PSValueOf aValueOf)
  {
    m_aVisitor.onValueOf (aParent, aValueOf);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onTextContent (@NonNull final IPSElement aParent, @NonNull final String sText)
  {
    m_aVisitor.onTextContent (aParent, sText);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onForeignElement (@NonNull final IPSElement aParent, @NonNull final IMicroElement aForeignElement)
  {
    m_aVisitor.onForeignElement (aParent, aForeignElement);
    return EContinue.CONTINUE;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Visitor", m_aVisitor).getToString ();
  }
}
