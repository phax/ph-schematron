/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.streamability;

import java.util.List;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;

/**
 * The streamability of a single <code>sch:rule</code>: its context, its <code>sch:let</code>s, assertions, reports and
 * the expressions of their messages. The rule needs what its worst expression needs.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class RuleStreamability
{
  private final String m_sID;
  private final String m_sContext;
  private final ICommonsList <StreamabilityExpression> m_aExpressions;
  private final EStreamabilityClass m_eClass;

  /**
   * @param sID
   *        The ID of the rule. May be <code>null</code>.
   * @param sContext
   *        The rule context. May not be <code>null</code>.
   * @param aExpressions
   *        The analysed expressions of the rule, starting with the context. May not be <code>null</code>.
   */
  public RuleStreamability (@Nullable final String sID,
                            @NonNull final String sContext,
                            @NonNull final List <StreamabilityExpression> aExpressions)
  {
    ValueEnforcer.notNull (sContext, "Context");
    ValueEnforcer.noNullValue (aExpressions, "Expressions");
    m_sID = sID;
    m_sContext = sContext;
    m_aExpressions = new CommonsArrayList <> (aExpressions);
    EStreamabilityClass eClass = EStreamabilityClass.MOTIONLESS;
    for (final StreamabilityExpression aExpression : aExpressions)
      eClass = eClass.getWorse (aExpression.getStreamabilityClass ());
    m_eClass = eClass;
  }

  /**
   * @return The ID of the rule. May be <code>null</code>.
   */
  @Nullable
  public String getID ()
  {
    return m_sID;
  }

  /**
   * @return The rule context. Never <code>null</code>.
   */
  @NonNull
  public String getContext ()
  {
    return m_sContext;
  }

  /**
   * @return The analysed expressions of the rule, starting with the context. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <StreamabilityExpression> getAllExpressions ()
  {
    return m_aExpressions.getClone ();
  }

  /**
   * @return The worst class of all expressions of the rule. Never <code>null</code>.
   */
  @NonNull
  public EStreamabilityClass getStreamabilityClass ()
  {
    return m_eClass;
  }

  /**
   * @return The rule as text, e.g. <code>rule [R1] 'cac:InvoiceLine'</code>. Never <code>null</code>.
   */
  @NonNull
  public String getAsText ()
  {
    return "rule" + (StringHelper.isNotEmpty (m_sID) ? " [" + m_sID + "]" : "") + " '" + m_sContext + "'";
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (null).appendIfNotNull ("ID", m_sID)
                                       .append ("Context", m_sContext)
                                       .append ("Expressions", m_aExpressions)
                                       .append ("Class", m_eClass)
                                       .getToString ();
  }
}
