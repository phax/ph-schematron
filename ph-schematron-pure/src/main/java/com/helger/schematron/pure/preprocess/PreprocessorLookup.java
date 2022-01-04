/*
 * Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.preprocess;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.CommonsTreeSet;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.collection.impl.ICommonsSortedSet;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;

/**
 * Utility lookup cache for ID to pattern and ID to rule, to avoid the linear
 * access when scanning a schema or a pattern. This cache only contains abstract
 * patterns and rules.
 *
 * @author Philip Helger
 */
@NotThreadSafe
final class PreprocessorLookup
{
  private final ICommonsMap <String, PSPattern> m_aPatterns = new CommonsHashMap <> ();
  private final ICommonsMap <String, PSRule> m_aRules = new CommonsHashMap <> ();

  public PreprocessorLookup (@Nonnull final PSSchema aSchema)
  {
    ValueEnforcer.notNull (aSchema, "Schema");

    for (final PSPattern aPattern : aSchema.getAllPatterns ())
    {
      // Only handle abstract patterns
      if (aPattern.isAbstract ())
        m_aPatterns.put (aPattern.getID (), aPattern);

      for (final PSRule aRule : aPattern.getAllRules ())
      {
        // Only handle abstract rules
        if (aRule.isAbstract ())
          m_aRules.put (aRule.getID (), aRule);
      }
    }
  }

  /**
   * Get the abstract pattern with the specified ID.
   *
   * @param sID
   *        The pattern ID to search. May be <code>null</code>.
   * @return <code>null</code> if no such abstract pattern is contained.
   */
  @Nullable
  public PSPattern getAbstractPatternOfID (@Nullable final String sID)
  {
    return m_aPatterns.get (sID);
  }

  /**
   * Get the abstract rule with the specified ID.
   *
   * @param sID
   *        The rule ID to search. May be <code>null</code>.
   * @return <code>null</code> if no such abstract rule is contained.
   */
  @Nullable
  public PSRule getAbstractRuleOfID (@Nullable final String sID)
  {
    return m_aRules.get (sID);
  }

  /**
   * @return A sorted set with all abstract rules IDs present.
   */
  @Nonnull
  @ReturnsMutableCopy
  public ICommonsSortedSet <String> getAllAbstractRuleIDs ()
  {
    return new CommonsTreeSet <> (m_aRules.keySet ());
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("patterns", m_aPatterns).append ("rules", m_aRules).getToString ();
  }
}
