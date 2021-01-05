/**
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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

import java.io.Serializable;
import java.util.List;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.error.level.IErrorLevel;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.svrl.SVRLResourceError.SVRLErrorBuilder;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;

/**
 * A wrapper around FailedAssert and SuccessfulReport with easier error level
 * handling.
 *
 * @author Philip Helger
 */
public abstract class AbstractSVRLMessage implements Serializable
{
  protected ICommonsList <DiagnosticReference> m_aDiagnosticReferences;
  protected String m_sText;
  protected String m_sID;
  protected String m_sLocation;
  protected String m_sTest;
  protected String m_sRole;
  protected IErrorLevel m_aFlag;

  public AbstractSVRLMessage (@Nullable final List <DiagnosticReference> aDiagnosticReferences,
                              @Nullable final String sID,
                              @Nullable final String sText,
                              @Nullable final String sLocation,
                              @Nullable final String sTest,
                              @Nullable final String sRole,
                              @Nullable final IErrorLevel aFlag)
  {
    m_aDiagnosticReferences = new CommonsArrayList <> (aDiagnosticReferences);
    m_sID = StringHelper.trim (sID);
    m_sText = StringHelper.trim (sText);
    m_sLocation = sLocation;
    m_sTest = sTest;
    m_sRole = sRole;
    m_aFlag = aFlag;
  }

  @Nonnull
  @ReturnsMutableCopy
  public final ICommonsList <DiagnosticReference> getDiagnisticReferences ()
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

  @Nonnull
  public final IErrorLevel getFlag ()
  {
    return m_aFlag;
  }

  @Nonnull
  public SVRLResourceError getAsResourceError (@Nullable final String sResourceName)
  {
    return new SVRLErrorBuilder (m_sTest).setErrorLevel (m_aFlag)
                                         .setErrorID (m_sID)
                                         .setErrorFieldName (m_sLocation)
                                         .setErrorLocation (sResourceName)
                                         .setErrorText (m_sText)
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
                                       .append ("Flag", m_aFlag)
                                       .getToString ();
  }
}
