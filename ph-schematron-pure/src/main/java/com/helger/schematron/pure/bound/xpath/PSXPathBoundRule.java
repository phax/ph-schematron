/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.bound.xpath;

import javax.xml.xpath.XPathExpression;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.annotation.style.ReturnsMutableObject;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.pure.binding.xpath.PSXPathVariables;
import com.helger.schematron.pure.model.PSRule;

/**
 * This class represents a single XPath-bound rule-element.
 *
 * @author Philip Helger
 */
@Immutable
public class PSXPathBoundRule
{
  private final PSRule m_aRule;
  private final String m_sRuleContext;
  private final XPathExpression m_aBoundRuleContext;
  private final ICommonsList <PSXPathBoundAssertReport> m_aBoundAssertReports;
  private final PSXPathVariables m_aVariables;

  public PSXPathBoundRule (@NonNull final PSRule aRule,
                           @NonNull final String sRuleContext,
                           @NonNull final XPathExpression aBoundRuleContext,
                           @NonNull final ICommonsList <PSXPathBoundAssertReport> aBoundAssertReports,
                           @NonNull final PSXPathVariables aVariables)
  {
    ValueEnforcer.notNull (aRule, "Rule");
    ValueEnforcer.notEmpty (sRuleContext, "RuleContext");
    ValueEnforcer.notNull (aBoundRuleContext, "BoundRuleContext");
    ValueEnforcer.notNull (aBoundAssertReports, "BoundAssertReports");
    ValueEnforcer.notNull (aVariables, "Variables");
    m_aRule = aRule;
    m_sRuleContext = sRuleContext;
    m_aBoundRuleContext = aBoundRuleContext;
    m_aBoundAssertReports = aBoundAssertReports;
    m_aVariables = aVariables;
  }

  @NonNull
  public final PSRule getRule ()
  {
    return m_aRule;
  }

  @NonNull
  public final String getRuleContext ()
  {
    return m_sRuleContext;
  }

  @NonNull
  public final XPathExpression getBoundRuleContext ()
  {
    return m_aBoundRuleContext;
  }

  @NonNull
  @ReturnsMutableObject
  public final ICommonsList <PSXPathBoundAssertReport> boundAssertReports ()
  {
    return m_aBoundAssertReports;
  }

  @NonNull
  @ReturnsMutableCopy
  public final ICommonsList <PSXPathBoundAssertReport> getAllBoundAssertReports ()
  {
    return m_aBoundAssertReports.getClone ();
  }

  @NonNull
  public final PSXPathVariables getVariables ()
  {
    return m_aVariables;
  }


  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Rule", m_aRule)
                                       .append ("RuleExpression", m_sRuleContext)
                                       .append ("BoundRuleExpression", m_aBoundRuleContext)
                                       .append ("BoundAssertReports", m_aBoundAssertReports)
                                       .append ("Variables", m_aVariables)
                                       .getToString ();
  }
}
