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

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;

/**
 * The streamability report of a Schematron, created by {@link SchematronStreamabilityAnalyzer}. The schema needs what
 * its worst global expression or pattern needs:
 * <ul>
 * <li>{@link EStreamabilityClass#MOTIONLESS}: every rule can be decided at the start tag of its context element.</li>
 * <li>{@link EStreamabilityClass#BURST}: every rule needs at most the subtree of its context element.</li>
 * <li>{@link EStreamabilityClass#NON_LOCAL}: at least one rule needs data outside the subtree of its context element,
 * or a global <code>sch:let</code> is computed from the instance (a first pass), or the schema uses a construct the
 * analysis does not cover.</li>
 * </ul>
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class SchematronStreamabilityReport
{
  private final ICommonsList <StreamabilityExpression> m_aGlobalExpressions;
  private final ICommonsList <PatternStreamability> m_aPatterns;
  private final EStreamabilityClass m_eClass;

  /**
   * @param aGlobalExpressions
   *        The expressions outside the rules: the global <code>sch:let</code>s and the unsupported constructs. May not
   *        be <code>null</code>.
   * @param aPatterns
   *        The analysed patterns. May not be <code>null</code>.
   */
  public SchematronStreamabilityReport (@NonNull final List <StreamabilityExpression> aGlobalExpressions,
                                        @NonNull final List <PatternStreamability> aPatterns)
  {
    ValueEnforcer.noNullValue (aGlobalExpressions, "GlobalExpressions");
    ValueEnforcer.noNullValue (aPatterns, "Patterns");
    m_aGlobalExpressions = new CommonsArrayList <> (aGlobalExpressions);
    m_aPatterns = new CommonsArrayList <> (aPatterns);
    EStreamabilityClass eClass = EStreamabilityClass.MOTIONLESS;
    for (final StreamabilityExpression aExpression : aGlobalExpressions)
      eClass = eClass.getWorse (aExpression.getStreamabilityClass ());
    for (final PatternStreamability aPattern : aPatterns)
      eClass = eClass.getWorse (aPattern.getStreamabilityClass ());
    m_eClass = eClass;
  }

  /**
   * @return The expressions outside the rules: the global <code>sch:let</code>s and the unsupported constructs. Never
   *         <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <StreamabilityExpression> getAllGlobalExpressions ()
  {
    return m_aGlobalExpressions.getClone ();
  }

  /**
   * @return The analysed patterns. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <PatternStreamability> getAllPatterns ()
  {
    return m_aPatterns.getClone ();
  }

  /**
   * @return The worst class of all global expressions and patterns. Never <code>null</code>.
   */
  @NonNull
  public EStreamabilityClass getStreamabilityClass ()
  {
    return m_eClass;
  }

  /**
   * @return The number of rules in all patterns.
   */
  public int getRuleCount ()
  {
    int ret = 0;
    for (final PatternStreamability aPattern : m_aPatterns)
      ret += aPattern.getAllRules ().size ();
    return ret;
  }

  /**
   * @param eClass
   *        The class to count. May not be <code>null</code>.
   * @return The number of rules in all patterns that have exactly this class.
   */
  public int getRuleCount (@NonNull final EStreamabilityClass eClass)
  {
    ValueEnforcer.notNull (eClass, "Class");
    int ret = 0;
    for (final PatternStreamability aPattern : m_aPatterns)
      for (final RuleStreamability aRule : aPattern.getAllRules ())
        if (aRule.getStreamabilityClass () == eClass)
          ret++;
    return ret;
  }

  /**
   * @return A single line summary, e.g. <code>burst: 3 patterns, 120 rules (100 motionless, 18 burst, 2 non-local),
   *         1 global expression</code>. Never <code>null</code>.
   */
  @NonNull
  public String getSummaryText ()
  {
    final StringBuilder aSB = new StringBuilder ();
    aSB.append (m_eClass.getID ())
       .append (": ")
       .append (m_aPatterns.size ())
       .append (m_aPatterns.size () == 1 ? " pattern, " : " patterns, ")
       .append (getRuleCount ())
       .append (getRuleCount () == 1 ? " rule (" : " rules (");
    boolean bFirst = true;
    for (final EStreamabilityClass e : EStreamabilityClass.values ())
    {
      if (bFirst)
        bFirst = false;
      else
        aSB.append (", ");
      aSB.append (getRuleCount (e)).append (' ').append (e.getID ());
    }
    aSB.append ("), ")
       .append (m_aGlobalExpressions.size ())
       .append (m_aGlobalExpressions.size () == 1 ? " global expression" : " global expressions");
    return aSB.toString ();
  }

  /**
   * @return One line for every expression that is not {@link EStreamabilityClass#MOTIONLESS}, with its pattern and
   *         rule, in schema order. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <String> getAllFindingTexts ()
  {
    final ICommonsList <String> ret = new CommonsArrayList <> ();
    for (final StreamabilityExpression aExpression : m_aGlobalExpressions)
      if (aExpression.getStreamabilityClass () != EStreamabilityClass.MOTIONLESS)
        ret.add (aExpression.getAsText ());
    for (final PatternStreamability aPattern : m_aPatterns)
      for (final RuleStreamability aRule : aPattern.getAllRules ())
        for (final StreamabilityExpression aExpression : aRule.getAllExpressions ())
          if (aExpression.getStreamabilityClass () != EStreamabilityClass.MOTIONLESS)
            ret.add (aPattern.getAsText () + ", " + aRule.getAsText () + ": " + aExpression.getAsText ());
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (null).append ("GlobalExpressions", m_aGlobalExpressions)
                                       .append ("Patterns", m_aPatterns)
                                       .append ("Class", m_eClass)
                                       .getToString ();
  }
}
