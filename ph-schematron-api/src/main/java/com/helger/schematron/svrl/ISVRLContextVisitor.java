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

import com.helger.base.state.EContinue;
import com.helger.schematron.svrl.jaxb.Active;
import com.helger.schematron.svrl.jaxb.ActiveGroup;
import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;

/**
 * Visitor for the validation results of an SVRL document that receives the active pattern or group
 * and the fired rule each result belongs to. In SVRL these are preceding siblings and not parents,
 * so {@link SVRLContextVisitorWrapper} keeps track of them while {@link SVRLVisitor} walks the
 * document.<br>
 * Returning {@link EContinue#BREAK} from any callback stops the whole walk immediately. All methods
 * have a default implementation that does nothing and returns {@link EContinue#CONTINUE}, so only
 * the relevant methods need to be overridden.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
public interface ISVRLContextVisitor
{
  /**
   * Called for each <code>&lt;active-pattern&gt;</code> element.
   *
   * @param aActivePattern
   *        The active pattern. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onActivePattern (@NonNull final ActivePattern aActivePattern)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;active-group&gt;</code> element.
   *
   * @param aActiveGroup
   *        The active group. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onActiveGroup (@NonNull final ActiveGroup aActiveGroup)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;fired-rule&gt;</code> element.
   *
   * @param aActive
   *        The active pattern or group the rule belongs to. May be <code>null</code> if the rule is
   *        not preceded by an active pattern or group.
   * @param aFiredRule
   *        The fired rule. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onFiredRule (@Nullable final Active aActive, @NonNull final FiredRule aFiredRule)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;failed-assert&gt;</code> element.
   *
   * @param aActive
   *        The active pattern or group the assert belongs to. May be <code>null</code> if the assert
   *        is not preceded by an active pattern or group.
   * @param aFiredRule
   *        The fired rule the assert belongs to. May be <code>null</code> if the assert is not
   *        preceded by a fired rule of the same active pattern or group.
   * @param aFailedAssert
   *        The failed assert. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onFailedAssert (@Nullable final Active aActive,
                                    @Nullable final FiredRule aFiredRule,
                                    @NonNull final FailedAssert aFailedAssert)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;successful-report&gt;</code> element.
   *
   * @param aActive
   *        The active pattern or group the report belongs to. May be <code>null</code> if the report
   *        is not preceded by an active pattern or group.
   * @param aFiredRule
   *        The fired rule the report belongs to. May be <code>null</code> if the report is not
   *        preceded by a fired rule of the same active pattern or group.
   * @param aSuccessfulReport
   *        The successful report. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSuccessfulReport (@Nullable final Active aActive,
                                        @Nullable final FiredRule aFiredRule,
                                        @NonNull final SuccessfulReport aSuccessfulReport)
  {
    return EContinue.CONTINUE;
  }
}
