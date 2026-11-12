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

import java.util.regex.Pattern;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;

/**
 * The streamability of a single Schematron expression.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class StreamabilityExpression
{
  private static final Pattern WHITESPACE = Pattern.compile ("\\s+");

  private final EStreamabilityExpressionType m_eType;
  private final String m_sLabel;
  private final String m_sExpression;
  private final EStreamabilityClass m_eClass;
  private final String m_sReason;

  /**
   * @param eType
   *        The kind of expression. May not be <code>null</code>.
   * @param sLabel
   *        The label of the expression within its owner, e.g. the name of a <code>sch:let</code> or the ID of a
   *        <code>sch:assert</code>. May be <code>null</code>.
   * @param sExpression
   *        The expression as written in the schema (after the preprocessing). May be <code>null</code> for
   *        {@link EStreamabilityExpressionType#UNSUPPORTED}.
   * @param eClass
   *        The streamability class. May not be <code>null</code>.
   * @param sReason
   *        The reason for a class other than {@link EStreamabilityClass#MOTIONLESS}: the construct of the expression
   *        that needs more, or the static error. May be <code>null</code>.
   */
  public StreamabilityExpression (@NonNull final EStreamabilityExpressionType eType,
                                  @Nullable final String sLabel,
                                  @Nullable final String sExpression,
                                  @NonNull final EStreamabilityClass eClass,
                                  @Nullable final String sReason)
  {
    ValueEnforcer.notNull (eType, "Type");
    ValueEnforcer.notNull (eClass, "Class");
    m_eType = eType;
    m_sLabel = sLabel;
    m_sExpression = sExpression;
    m_eClass = eClass;
    m_sReason = sReason;
  }

  /**
   * @return The kind of expression. Never <code>null</code>.
   */
  @NonNull
  public EStreamabilityExpressionType getType ()
  {
    return m_eType;
  }

  /**
   * @return The label of the expression within its owner, e.g. the name of a <code>sch:let</code> or the ID of a
   *         <code>sch:assert</code>. May be <code>null</code>.
   */
  @Nullable
  public String getLabel ()
  {
    return m_sLabel;
  }

  /**
   * @return The expression as written in the schema (after the preprocessing). May be <code>null</code> for
   *         {@link EStreamabilityExpressionType#UNSUPPORTED}.
   */
  @Nullable
  public String getExpression ()
  {
    return m_sExpression;
  }

  /**
   * @return The streamability class. Never <code>null</code>.
   */
  @NonNull
  public EStreamabilityClass getStreamabilityClass ()
  {
    return m_eClass;
  }

  /**
   * @return The reason for a class other than {@link EStreamabilityClass#MOTIONLESS}: the construct of the expression
   *         that needs more, or the static error. May be <code>null</code>.
   */
  @Nullable
  public String getReason ()
  {
    return m_sReason;
  }

  /**
   * @return A single line describing the expression (with each whitespace sequence as one space) and its class, e.g.
   *         <code>sch:assert [BR-01] 'cbc:A = 'x' or cbc:B = 'y'': burst (expression operator or)</code>. Never
   *         <code>null</code>.
   */
  @NonNull
  public String getAsText ()
  {
    final StringBuilder aSB = new StringBuilder (m_eType.getDisplayName ());
    if (StringHelper.isNotEmpty (m_sLabel))
      aSB.append (" [").append (m_sLabel).append (']');
    if (m_sExpression != null)
      aSB.append (" '").append (WHITESPACE.matcher (m_sExpression.trim ()).replaceAll (" ")).append ('\'');
    aSB.append (": ").append (m_eClass.getID ());
    if (StringHelper.isNotEmpty (m_sReason))
      aSB.append (" (").append (m_sReason).append (')');
    return aSB.toString ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (null).append ("Type", m_eType)
                                       .appendIfNotNull ("Label", m_sLabel)
                                       .appendIfNotNull ("Expression", m_sExpression)
                                       .append ("Class", m_eClass)
                                       .appendIfNotNull ("Reason", m_sReason)
                                       .getToString ();
  }
}
