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
package com.helger.schematron.api.telemetry;

import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.equals.EqualsHelper;
import com.helger.base.hashcode.HashCodeGenerator;
import com.helger.base.tostring.ToStringGenerator;

/**
 * Immutable identifier of a single XSLT template execution reported via
 * {@link ISchematronTemplateTelemetry}. Carries the static information about the template (name,
 * match pattern, source location) &mdash; the dynamic part (duration, hit counter) is handled by
 * the consumer.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class SchematronTemplateInfo
{
  private final String m_sName;
  private final String m_sMatchPattern;
  private final String m_sMode;
  private final String m_sSystemID;
  private final int m_nLineNumber;

  /**
   * @param sName
   *        The template name in Clark notation (<code>{ns}local</code>), or <code>null</code> for
   *        anonymous match templates.
   * @param sMatchPattern
   *        The XSLT match pattern as a short string, or <code>null</code> for named templates.
   * @param sMode
   *        The XSLT mode name in Clark notation, or <code>null</code> for the default/unnamed mode
   *        and for named templates. SchXslt uses modes (typically <code>M1</code>, <code>M2</code>,
   *        &hellip;) to separate the validation phases, so the same match pattern may legitimately
   *        appear in multiple modes.
   * @param sSystemID
   *        The system ID (URI) of the XSLT source. May be <code>null</code> if unknown.
   * @param nLineNumber
   *        The 1-based line number in the XSLT source, or <code>-1</code> if unknown.
   */
  public SchematronTemplateInfo (@Nullable final String sName,
                                 @Nullable final String sMatchPattern,
                                 @Nullable final String sMode,
                                 @Nullable final String sSystemID,
                                 final int nLineNumber)
  {
    m_sName = sName;
    m_sMatchPattern = sMatchPattern;
    m_sMode = sMode;
    m_sSystemID = sSystemID;
    m_nLineNumber = nLineNumber;
  }

  /**
   * @return The template name in Clark notation, or <code>null</code> for anonymous match
   *         templates.
   */
  @Nullable
  public String getName ()
  {
    return m_sName;
  }

  /**
   * @return The XSLT match pattern as a short string, or <code>null</code> for named templates.
   */
  @Nullable
  public String getMatchPattern ()
  {
    return m_sMatchPattern;
  }

  /**
   * @return The XSLT mode name in Clark notation, or <code>null</code> for the default/unnamed mode
   *         and for named templates.
   */
  @Nullable
  public String getMode ()
  {
    return m_sMode;
  }

  /**
   * @return The system ID (URI) of the XSLT source, or <code>null</code> if unknown.
   */
  @Nullable
  public String getSystemID ()
  {
    return m_sSystemID;
  }

  /**
   * @return The 1-based line number in the XSLT source, or <code>-1</code> if unknown.
   */
  public int getLineNumber ()
  {
    return m_nLineNumber;
  }

  @Override
  public boolean equals (final Object o)
  {
    if (o == this)
      return true;
    if (o == null || !getClass ().equals (o.getClass ()))
      return false;
    final SchematronTemplateInfo rhs = (SchematronTemplateInfo) o;
    return EqualsHelper.equals (m_sName, rhs.m_sName) &&
           EqualsHelper.equals (m_sMatchPattern, rhs.m_sMatchPattern) &&
           EqualsHelper.equals (m_sMode, rhs.m_sMode) &&
           EqualsHelper.equals (m_sSystemID, rhs.m_sSystemID) &&
           m_nLineNumber == rhs.m_nLineNumber;
  }

  @Override
  public int hashCode ()
  {
    return new HashCodeGenerator (this).append (m_sName)
                                       .append (m_sMatchPattern)
                                       .append (m_sMode)
                                       .append (m_sSystemID)
                                       .append (m_nLineNumber)
                                       .getHashCode ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (null).appendIfNotNull ("Name", m_sName)
                                       .appendIfNotNull ("MatchPattern", m_sMatchPattern)
                                       .appendIfNotNull ("Mode", m_sMode)
                                       .appendIfNotNull ("SystemID", m_sSystemID)
                                       .append ("LineNumber", m_nLineNumber)
                                       .getToString ();
  }
}
