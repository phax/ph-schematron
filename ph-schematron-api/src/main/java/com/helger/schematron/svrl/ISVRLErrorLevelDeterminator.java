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
package com.helger.schematron.svrl;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.error.level.IErrorLevel;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;

/**
 * Interface that helps in determining an error level from SVRL elements.
 *
 * @author Philip Helger
 */
@FunctionalInterface
public interface ISVRLErrorLevelDeterminator
{
  /**
   * Get the error level associated with a single failed assertion/successful
   * report.
   *
   * @param sValue
   *        The value to be queried. May be <code>null</code>.
   * @return The error level and never <code>null</code>.
   * @since 5.0.2
   */
  @Nonnull
  IErrorLevel getErrorLevelFromString (@Nullable String sValue);

  /**
   * Get the error level associated with a single failed assertion.
   *
   * @param aFailedAssert
   *        The failed assert to be queried. May not be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @Nonnull
  default IErrorLevel getErrorLevelFromFailedAssert (@Nonnull final FailedAssert aFailedAssert)
  {
    ValueEnforcer.notNull (aFailedAssert, "FailedAssert");

    // First try "flag" (for backwards compatibility)
    String sValue = aFailedAssert.getFlag ();
    if (StringHelper.hasNoText (sValue))
    {
      // Fall back to "role"
      sValue = aFailedAssert.getRole ();
    }
    return getErrorLevelFromString (sValue);
  }

  /**
   * Get the error level associated with a single successful report.
   *
   * @param aSuccessfulReport
   *        The failed assert to be queried. May not be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @Nonnull
  default IErrorLevel getErrorLevelFromSuccessfulReport (@Nonnull final SuccessfulReport aSuccessfulReport)
  {
    ValueEnforcer.notNull (aSuccessfulReport, "SuccessfulReport");

    // First try "flag" (for backwards compatibility)
    String sValue = aSuccessfulReport.getFlag ();
    if (StringHelper.hasNoText (sValue))
    {
      // Fall back to "role"
      sValue = aSuccessfulReport.getRole ();
    }
    return getErrorLevelFromString (sValue);
  }
}
