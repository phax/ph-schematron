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
package com.helger.schematron.svrl;

import java.util.List;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.level.IErrorLevel;
import com.helger.schematron.svrl.SVRLResourceError.SVRLErrorBuilder;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;

/**
 * A wrapper around FailedAssert and SuccessfulReport with easier error level handling.
 *
 * @author Philip Helger
 */
@Immutable
public abstract class AbstractSVRLMessage
{
  private final ICommonsList <DiagnosticReference> m_aDiagnosticReferences;
  private final String m_sText;
  private final String m_sID;
  private final String m_sLocation;
  private final String m_sTest;
  private final String m_sRole;
  private final String m_sRuleID;
  private final String m_sPatternID;
  private final String m_sGroupID;
  private final IErrorLevel m_aFlag;

  public AbstractSVRLMessage (@Nullable final List <DiagnosticReference> aDiagnosticReferences,
                              @Nullable final String sID,
                              @Nullable final String sText,
                              @Nullable final String sLocation,
                              @Nullable final String sTest,
                              @Nullable final String sRole,
                              @Nullable final String sRuleID,
                              @Nullable final String sPatternID,
                              @Nullable final String sGroupID,
                              @Nullable final IErrorLevel aFlag)
  {
    m_aDiagnosticReferences = new CommonsArrayList <> (aDiagnosticReferences);
    m_sID = StringHelper.trim (sID);
    m_sText = StringHelper.trim (sText);
    m_sLocation = sLocation;
    m_sTest = sTest;
    m_sRole = sRole;
    m_sRuleID = sRuleID;
    m_sPatternID = sPatternID;
    m_sGroupID = sGroupID;
    m_aFlag = aFlag;
  }

  @NonNull
  @ReturnsMutableCopy
  public final ICommonsList <DiagnosticReference> getDiagnosticReferences ()
  {
    return m_aDiagnosticReferences.getClone ();
  }

  @Nullable
  public final String getID ()
  {
    return m_sID;
  }

  @Nullable
  public final String getText ()
  {
    return m_sText;
  }

  @Nullable
  public final String getLocation ()
  {
    return m_sLocation;
  }

  @Nullable
  public final String getTest ()
  {
    return m_sTest;
  }

  @Nullable
  public final String getRole ()
  {
    return m_sRole;
  }

  /**
   * @return The ID of the rule containing the assert or report. Only provided by SchXslt2 and only
   *         if the rule has an ID. May be <code>null</code>.
   * @since 11.1.0
   */
  @Nullable
  public final String getRuleID ()
  {
    return m_sRuleID;
  }

  /**
   * @return The ID of the pattern containing the assert or report. Only provided by SchXslt2 and
   *         only if the pattern has an ID. May be <code>null</code>.
   * @since 11.1.0
   */
  @Nullable
  public final String getPatternID ()
  {
    return m_sPatternID;
  }

  /**
   * @return The ID of the group containing the assert or report. Only provided by SchXslt2 and only
   *         if the group has an ID. May be <code>null</code>.
   * @since 11.1.0
   */
  @Nullable
  public final String getGroupID ()
  {
    return m_sGroupID;
  }

  @NonNull
  public final IErrorLevel getFlag ()
  {
    return m_aFlag;
  }

  @NonNull
  public SVRLResourceError getAsResourceError (@Nullable final String sResourceName)
  {
    return new SVRLErrorBuilder (m_sTest).errorLevel (m_aFlag)
                                         .errorID (m_sID)
                                         .errorFieldName (m_sLocation)
                                         .errorLocation (sResourceName)
                                         .errorText (m_sText)
                                         .build ();
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("DiagnosticRefs", m_aDiagnosticReferences)
                                       .append ("ID", m_sID)
                                       .append ("Text", m_sText)
                                       .append ("Location", m_sLocation)
                                       .append ("Test", m_sTest)
                                       .appendIfNotNull ("Role", m_sRole)
                                       .appendIfNotNull ("RuleID", m_sRuleID)
                                       .appendIfNotNull ("PatternID", m_sPatternID)
                                       .appendIfNotNull ("GroupID", m_sGroupID)
                                       .append ("Flag", m_aFlag)
                                       .getToString ();
  }
}
