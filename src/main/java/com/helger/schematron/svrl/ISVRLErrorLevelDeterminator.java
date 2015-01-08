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

import org.oclc.purl.dsdl.svrl.FailedAssert;
import org.oclc.purl.dsdl.svrl.SuccessfulReport;

import com.helger.commons.error.EErrorLevel;

/**
 * Interface that helps in determining an error level from SVRL elements.
 * 
 * @author Philip Helger
 */
public interface ISVRLErrorLevelDeterminator
{
  /**
   * Get the error level associated with a single failed assertion.
   * 
   * @param aFailedAssert
   *        The failed assert to be queried. May not be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @Nonnull
  EErrorLevel getErrorLevelFromFailedAssert (@Nonnull FailedAssert aFailedAssert);

  /**
   * Get the error level associated with a single successful report.
   * 
   * @param aSuccessfulReport
   *        The failed assert to be queried. May not be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @Nonnull
  EErrorLevel getErrorLevelFromSuccessfulReport (@Nonnull SuccessfulReport aSuccessfulReport);
}
