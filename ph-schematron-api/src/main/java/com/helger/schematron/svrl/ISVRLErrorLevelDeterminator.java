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

import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.diagnostics.error.level.IErrorLevel;
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
   * Get the error level associated with a single failed assertion/successful report.
   *
   * @param sValue
   *        The value to be queried. May be <code>null</code>.
   * @return The error level and never <code>null</code>.
   * @since 5.0.2
   */
  @NonNull
  IErrorLevel getErrorLevelFromString (@Nullable String sValue);

  /**
   * Get the error level associated with a single failed assertion.
   *
   * @param aFailedAssert
   *        The failed assert to be queried. May not be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @NonNull
  default IErrorLevel getErrorLevelFromFailedAssert (@NonNull final FailedAssert aFailedAssert)
  {
    ValueEnforcer.notNull (aFailedAssert, "FailedAssert");

    // Start with "severity"
    String sValue = aFailedAssert.getSeverity ();
    if (StringHelper.isEmpty (sValue))
    {
      // Next try "flag" (for backwards compatibility)
      sValue = aFailedAssert.hasFlagEntries () ? aFailedAssert.getFlagAtIndex (0) : null;
      if (StringHelper.isEmpty (sValue))
      {
        // Fall back to "role"
        sValue = aFailedAssert.getRole ();
      }
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
  @NonNull
  default IErrorLevel getErrorLevelFromSuccessfulReport (@NonNull final SuccessfulReport aSuccessfulReport)
  {
    ValueEnforcer.notNull (aSuccessfulReport, "SuccessfulReport");

    // Start with "severity"
    String sValue = aSuccessfulReport.getSeverity ();
    if (StringHelper.isEmpty (sValue))
    {
      // Next try "flag" (for backwards compatibility)
      sValue = aSuccessfulReport.hasFlagEntries () ? aSuccessfulReport.getFlagAtIndex (0) : null;
      if (StringHelper.isEmpty (sValue))
      {
        // Fall back to "role"
        sValue = aSuccessfulReport.getRole ();
      }
    }
    return getErrorLevelFromString (sValue);
  }
}
