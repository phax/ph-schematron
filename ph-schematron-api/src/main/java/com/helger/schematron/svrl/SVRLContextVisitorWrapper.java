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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EContinue;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.schematron.svrl.jaxb.Active;
import com.helger.schematron.svrl.jaxb.ActiveGroup;
import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;

/**
 * Wraps an {@link ISVRLContextVisitor} into an {@link ISVRLVisitor}. It keeps track of the current
 * active pattern or group and the current fired rule and passes them to the wrapped visitor. A new
 * active pattern or group resets the current fired rule.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
@NotThreadSafe
public class SVRLContextVisitorWrapper implements ISVRLVisitor
{
  private final ISVRLContextVisitor m_aVisitor;
  private Active m_aCurrentActive;
  private FiredRule m_aCurrentFiredRule;

  /**
   * Constructor
   *
   * @param aVisitor
   *        The visitor to be wrapped. May not be <code>null</code>.
   */
  public SVRLContextVisitorWrapper (@NonNull final ISVRLContextVisitor aVisitor)
  {
    ValueEnforcer.notNull (aVisitor, "Visitor");
    m_aVisitor = aVisitor;
  }

  /**
   * @return The wrapped visitor as passed in the constructor. Never <code>null</code>.
   */
  @NonNull
  public final ISVRLContextVisitor getWrappedVisitor ()
  {
    return m_aVisitor;
  }

  /**
   * @return The current active pattern or group. May be <code>null</code>.
   */
  @Nullable
  public final Active getCurrentActive ()
  {
    return m_aCurrentActive;
  }

  /**
   * @return The current fired rule. May be <code>null</code>.
   */
  @Nullable
  public final FiredRule getCurrentFiredRule ()
  {
    return m_aCurrentFiredRule;
  }

  @Override
  @NonNull
  public EContinue onSchematronOutputStart (@NonNull final SchematronOutputType aSchematronOutput)
  {
    // Allow reusing the wrapper for another SVRL document
    m_aCurrentActive = null;
    m_aCurrentFiredRule = null;
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onActivePatternStart (@NonNull final ActivePattern aActivePattern)
  {
    m_aCurrentActive = aActivePattern;
    m_aCurrentFiredRule = null;
    return m_aVisitor.onActivePattern (aActivePattern);
  }

  @Override
  @NonNull
  public EContinue onActiveGroupStart (@NonNull final ActiveGroup aActiveGroup)
  {
    m_aCurrentActive = aActiveGroup;
    m_aCurrentFiredRule = null;
    return m_aVisitor.onActiveGroup (aActiveGroup);
  }

  @Override
  @NonNull
  public EContinue onFiredRule (@NonNull final SchematronOutputType aParent, @NonNull final FiredRule aFiredRule)
  {
    m_aCurrentFiredRule = aFiredRule;
    return m_aVisitor.onFiredRule (m_aCurrentActive, aFiredRule);
  }

  @Override
  @NonNull
  public EContinue onFailedAssertStart (@NonNull final FailedAssert aFailedAssert)
  {
    return m_aVisitor.onFailedAssert (m_aCurrentActive, m_aCurrentFiredRule, aFailedAssert);
  }

  @Override
  @NonNull
  public EContinue onSuccessfulReportStart (@NonNull final SuccessfulReport aSuccessfulReport)
  {
    return m_aVisitor.onSuccessfulReport (m_aCurrentActive, m_aCurrentFiredRule, aSuccessfulReport);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Visitor", m_aVisitor)
                                       .append ("CurrentActive", m_aCurrentActive)
                                       .append ("CurrentFiredRule", m_aCurrentFiredRule)
                                       .getToString ();
  }
}
