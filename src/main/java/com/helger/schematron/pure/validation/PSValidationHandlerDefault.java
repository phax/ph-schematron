/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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

import org.w3c.dom.Node;

import com.helger.commons.state.EContinue;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;

/**
 * The empty default implementation of {@link IPSValidationHandler}. This class
 * may serve as the basis for your implementations.
 * 
 * @author Philip Helger
 */
@NotThreadSafe
public class PSValidationHandlerDefault implements IPSValidationHandler
{
  public void onStart (@Nonnull final PSSchema aSchema, @Nullable final PSPhase aActivePhase) throws SchematronValidationException
  {
    // empty
  }

  public void onPattern (@Nonnull final PSPattern aPattern) throws SchematronValidationException
  {
    // empty
  }

  public void onRule (@Nonnull final PSRule aRule, @Nonnull final String sContext) throws SchematronValidationException
  {
    // empty
  }

  @Nonnull
  public EContinue onFailedAssert (@Nonnull final PSAssertReport aAssertReport,
                                   @Nonnull final String sTestExpression,
                                   @Nonnull final Node aRuleMatchingNode,
                                   final int nNodeIndex,
                                   @Nullable final Object aContext) throws SchematronValidationException
  {
    return EContinue.CONTINUE;
  }

  @Nonnull
  public EContinue onSuccessfulReport (@Nonnull final PSAssertReport aAssertReport,
                                       @Nonnull final String sTestExpression,
                                       @Nonnull final Node aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext) throws SchematronValidationException
  {
    return EContinue.CONTINUE;
  }

  public void onEnd (@Nonnull final PSSchema aSchema, @Nullable final PSPhase aActivePhase) throws SchematronValidationException
  {
    // empty
  }
}
