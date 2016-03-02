/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
import javax.annotation.concurrent.ThreadSafe;

import org.oclc.purl.dsdl.svrl.FailedAssert;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.oclc.purl.dsdl.svrl.SuccessfulReport;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.PresentForCodeCoverage;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.ext.CommonsArrayList;
import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.concurrent.SimpleReadWriteLock;
import com.helger.commons.error.IErrorLevel;

/**
 * Miscellaneous utility methods for handling Schematron output (SVRL).
 *
 * @author Philip Helger
 */
@ThreadSafe
public final class SVRLHelper
{
  private static final SimpleReadWriteLock s_aRWLock = new SimpleReadWriteLock ();

  private static ISVRLErrorLevelDeterminator s_aELD = new DefaultSVRLErrorLevelDeterminator ();

  @PresentForCodeCoverage
  private static final SVRLHelper s_aInstance = new SVRLHelper ();

  private SVRLHelper ()
  {}

  /**
   * Get a list of all failed assertions in a given schematron output.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May not be <code>null</code>.
   * @return A non-<code>null</code> list with all failed assertions.
   */
  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <SVRLFailedAssert> getAllFailedAssertions (@Nonnull final SchematronOutputType aSchematronOutput)
  {
    final ICommonsList <SVRLFailedAssert> ret = new CommonsArrayList <> ();
    for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof FailedAssert)
        ret.add (new SVRLFailedAssert ((FailedAssert) aObj));
    return ret;
  }

  /**
   * Get a list of all failed assertions in a given schematron output, with an
   * error level equally or more severe than the passed error level.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May not be <code>null</code>.
   * @param aErrorLevel
   *        Minimum error level to be queried
   * @return A non-<code>null</code> list with all failed assertions.
   */
  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <SVRLFailedAssert> getAllFailedAssertionsMoreOrEqualSevereThan (@Nonnull final SchematronOutputType aSchematronOutput,
                                                                                             @Nonnull final IErrorLevel aErrorLevel)
  {
    final ICommonsList <SVRLFailedAssert> ret = new CommonsArrayList <> ();
    for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof FailedAssert)
      {
        final SVRLFailedAssert aFA = new SVRLFailedAssert ((FailedAssert) aObj);
        if (aFA.getFlag ().isMoreOrEqualSevereThan (aErrorLevel))
          ret.add (aFA);
      }
    return ret;
  }

  /**
   * Get a list of all successful reports in a given schematron output.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May not be <code>null</code>.
   * @return A non-<code>null</code> list with all successful reports.
   */
  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <SVRLSuccessfulReport> getAllSuccessfulReports (@Nonnull final SchematronOutputType aSchematronOutput)
  {
    final ICommonsList <SVRLSuccessfulReport> ret = new CommonsArrayList <> ();
    for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof SuccessfulReport)
        ret.add (new SVRLSuccessfulReport ((SuccessfulReport) aObj));
    return ret;
  }

  /**
   * Get a list of all successful reports in a given schematron output, with an
   * error level equally or more severe than the passed error level.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May not be <code>null</code>.
   * @param aErrorLevel
   *        Minimum error level to be queried
   * @return A non-<code>null</code> list with all successful reports.
   */
  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <SVRLSuccessfulReport> getAllSuccessfulReportsMoreOrEqualSevereThan (@Nonnull final SchematronOutputType aSchematronOutput,
                                                                                                  @Nonnull final IErrorLevel aErrorLevel)
  {
    final ICommonsList <SVRLSuccessfulReport> ret = new CommonsArrayList <> ();
    for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof SuccessfulReport)
      {
        final SVRLSuccessfulReport aFA = new SVRLSuccessfulReport ((SuccessfulReport) aObj);
        if (aFA.getFlag ().isMoreOrEqualSevereThan (aErrorLevel))
          ret.add (aFA);
      }
    return ret;
  }

  /**
   * Get the error level associated with a single failed assertion.
   *
   * @param aFailedAssert
   *        The failed assert to be queried. May not be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @Nonnull
  public static IErrorLevel getErrorLevelFromFailedAssert (@Nonnull final FailedAssert aFailedAssert)
  {
    return getErrorLevelDeterminator ().getErrorLevelFromFailedAssert (aFailedAssert);
  }

  /**
   * Get the error level associated with a single successful report.
   *
   * @param aSuccessfulReport
   *        The failed assert to be queried. May not be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @Nonnull
  public static IErrorLevel getErrorLevelFromSuccessfulReport (@Nonnull final SuccessfulReport aSuccessfulReport)
  {
    return getErrorLevelDeterminator ().getErrorLevelFromSuccessfulReport (aSuccessfulReport);
  }

  @Nonnull
  public static ISVRLErrorLevelDeterminator getErrorLevelDeterminator ()
  {
    return s_aRWLock.readLocked ( () -> s_aELD);
  }

  public static void setErrorLevelDeterminator (@Nonnull final ISVRLErrorLevelDeterminator aELD)
  {
    ValueEnforcer.notNull (aELD, "ErrorLevelDeterminator");

    s_aRWLock.readLocked ( () -> s_aELD = aELD);
  }
}
