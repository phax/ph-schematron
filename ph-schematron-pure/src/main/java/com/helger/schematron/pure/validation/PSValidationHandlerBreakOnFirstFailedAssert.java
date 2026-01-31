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
package com.helger.schematron.pure.validation;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Node;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.state.EContinue;
import com.helger.base.state.EValidity;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSRule;

/**
 * A simple implementation if {@link IPSValidationHandler} that stops validation
 * upon the first failed assertion. The final validation result can be retrieved
 * by invoking {@link #getValidity()}.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSValidationHandlerBreakOnFirstFailedAssert implements IPSPartialValidationHandler
{
  private EValidity m_eValidity = EValidity.VALID;

  @Override
  @NonNull
  public EContinue onFailedAssert (@NonNull final PSRule aOwningRule,
                                   @NonNull final PSAssertReport aAssertReport,
                                   @NonNull final String sTestExpression,
                                   @NonNull final Node aRuleMatchingNode,
                                   final int nNodeIndex,
                                   @Nullable final Object aContext,
                                   @Nullable final Exception aEvaluationException)
  {
    m_eValidity = EValidity.INVALID;
    return EContinue.BREAK;
  }

  /**
   * @return The validity of the XML file. {@link EValidity#VALID} if no failed
   *         assertion and no successful report occurred,
   *         {@link EValidity#INVALID} otherwise.
   */
  @Override
  @NonNull
  public EValidity getValidity ()
  {
    return m_eValidity;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Validity", m_eValidity).getToString ();
  }
}
