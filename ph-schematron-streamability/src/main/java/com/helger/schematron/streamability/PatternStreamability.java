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
 * The streamability of a single <code>sch:pattern</code>: the pattern needs what its worst rule needs.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class PatternStreamability
{
  private final String m_sID;
  private final ICommonsList <RuleStreamability> m_aRules;
  private final EStreamabilityClass m_eClass;

  /**
   * @param sID
   *        The ID of the pattern. May be <code>null</code>.
   * @param aRules
   *        The analysed rules of the pattern. May not be <code>null</code>.
   */
  public PatternStreamability (@Nullable final String sID, @NonNull final List <RuleStreamability> aRules)
  {
    ValueEnforcer.noNullValue (aRules, "Rules");
    m_sID = sID;
    m_aRules = new CommonsArrayList <> (aRules);
    EStreamabilityClass eClass = EStreamabilityClass.MOTIONLESS;
    for (final RuleStreamability aRule : aRules)
      eClass = eClass.getWorse (aRule.getStreamabilityClass ());
    m_eClass = eClass;
  }

  /**
   * @return The ID of the pattern. May be <code>null</code>.
   */
  @Nullable
  public String getID ()
  {
    return m_sID;
  }

  /**
   * @return The analysed rules of the pattern. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <RuleStreamability> getAllRules ()
  {
    return m_aRules.getClone ();
  }

  /**
   * @return The worst class of all rules of the pattern, {@link EStreamabilityClass#MOTIONLESS} for a pattern without
   *         rules. Never <code>null</code>.
   */
  @NonNull
  public EStreamabilityClass getStreamabilityClass ()
  {
    return m_eClass;
  }

  /**
   * @return The pattern as text, e.g. <code>pattern [P1]</code>. Never <code>null</code>.
   */
  @NonNull
  public String getAsText ()
  {
    return "pattern" + (StringHelper.isNotEmpty (m_sID) ? " [" + m_sID + "]" : "");
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (null).appendIfNotNull ("ID", m_sID)
                                       .append ("Rules", m_aRules)
                                       .append ("Class", m_eClass)
                                       .getToString ();
  }
}
