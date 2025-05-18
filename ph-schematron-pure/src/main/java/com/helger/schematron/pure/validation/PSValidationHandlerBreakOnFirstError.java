/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.state.EContinue;
import com.helger.commons.state.EValidity;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSRule;

import net.sf.saxon.s9api.XdmNode;

/**
 * A simple implementation if {@link IPSValidationHandler} that stops validation upon the first
 * error (the first failed assert or the first successful report). The final validation result can
 * be retrieved by invoking {@link #getValidity()}.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PSValidationHandlerBreakOnFirstError implements IPSPartialValidationHandler
{
  private EValidity m_eValidity = EValidity.VALID;

  @Override
  @Nonnull
  public EContinue onFailedAssert (@Nonnull final PSRule aOwningRule,
                                   @Nonnull final PSAssertReport aAssertReport,
                                   @Nonnull final String sTestExpression,
                                   @Nonnull final XdmNode aRuleMatchingNode,
                                   final int nNodeIndex,
                                   @Nullable final Object aContext,
                                   @Nullable final Exception aEvaluationException)
  {
    m_eValidity = EValidity.INVALID;
    return EContinue.BREAK;
  }

  @Override
  @Nonnull
  public EContinue onSuccessfulReport (@Nonnull final PSRule aOwningRule,
                                       @Nonnull final PSAssertReport aAssertReport,
                                       @Nonnull final String sTestExpression,
                                       @Nonnull final XdmNode aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext,
                                       @Nullable final Exception aEvaluationException)
  {
    m_eValidity = EValidity.INVALID;
    return EContinue.BREAK;
  }

  /**
   * @return The validity of the XML file. {@link EValidity#VALID} if no failed assertion and no
   *         successful report occurred, {@link EValidity#INVALID} otherwise.
   */
  @Nonnull
  public final EValidity getValidity ()
  {
    return m_eValidity;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Validity", m_eValidity).getToString ();
  }
}
