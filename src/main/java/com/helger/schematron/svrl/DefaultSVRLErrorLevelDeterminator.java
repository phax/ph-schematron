/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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

import org.oclc.purl.dsdl.svrl.FailedAssert;
import org.oclc.purl.dsdl.svrl.SuccessfulReport;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.error.EErrorLevel;

/**
 * The default implementation of {@link ISVRLErrorLevelDeterminator}.
 *
 * @author Philip Helger
 */
public class DefaultSVRLErrorLevelDeterminator implements ISVRLErrorLevelDeterminator
{
  public static final EErrorLevel DEFAULT_ERROR_LEVEL = EErrorLevel.ERROR;

  /**
   * Get the error level associated with a single failed assertion.
   *
   * @param sFlag
   *        The flag to be queried. May be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @Nonnull
  public EErrorLevel getErrorLevelFromFlag (@Nullable final String sFlag)
  {
    if (sFlag == null)
      return DEFAULT_ERROR_LEVEL;

    if (sFlag.equalsIgnoreCase ("warning") || sFlag.equalsIgnoreCase ("warn"))
      return EErrorLevel.WARN;

    if (sFlag.equalsIgnoreCase ("error") || sFlag.equalsIgnoreCase ("err"))
      return EErrorLevel.ERROR;

    if (sFlag.equalsIgnoreCase ("fatal") ||
        sFlag.equalsIgnoreCase ("fatal_error") ||
        sFlag.equalsIgnoreCase ("fatalerror"))
      return EErrorLevel.FATAL_ERROR;

    throw new IllegalArgumentException ("Cannot convert the SVRL failed assertion flag '" +
                                        sFlag +
                                        "' to an error level. Please extend the preceeding list!");
  }

  @Nonnull
  public EErrorLevel getErrorLevelFromFailedAssert (@Nonnull final FailedAssert aFailedAssert)
  {
    ValueEnforcer.notNull (aFailedAssert, "FailedAssert");

    return getErrorLevelFromFlag (aFailedAssert.getFlag ());
  }

  @Nonnull
  public EErrorLevel getErrorLevelFromSuccessfulReport (@Nonnull final SuccessfulReport aSuccessfulReport)
  {
    ValueEnforcer.notNull (aSuccessfulReport, "SuccessfulReport");

    return getErrorLevelFromFlag (aSuccessfulReport.getFlag ());
  }
}
