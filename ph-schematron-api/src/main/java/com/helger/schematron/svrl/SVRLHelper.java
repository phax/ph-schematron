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

import java.util.regex.Matcher;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.concurrent.SimpleReadWriteLock;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringReplace;
import com.helger.cache.regex.RegExHelper;
import com.helger.collection.CollectionFind;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.level.IErrorLevel;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.PropertyReference;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.Text;

/**
 * Miscellaneous utility methods for handling Schematron output (SVRL).
 *
 * @author Philip Helger
 */
@ThreadSafe
public final class SVRLHelper
{
  private static final SimpleReadWriteLock RW_LOCK = new SimpleReadWriteLock ();

  private static ISVRLErrorLevelDeterminator s_aELD = new DefaultSVRLErrorLevelDeterminator ();

  @PresentForCodeCoverage
  private static final SVRLHelper INSTANCE = new SVRLHelper ();

  private SVRLHelper ()
  {}

  @Nullable
  public static String getAsString (@Nullable final Text aText)
  {
    if (aText == null)
      return null;

    final StringBuilder aSB = new StringBuilder ();
    for (final Object aObj : aText.getContent ())
      aSB.append (aObj);
    return aSB.toString ();
  }

  /**
   * Get a list of all failed assertions in a given schematron output.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May be <code>null</code>.
   * @return A non-<code>null</code> list with all failed assertions.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <SVRLFailedAssert> getAllFailedAssertions (@Nullable final SchematronOutputType aSchematronOutput)
  {
    final ICommonsList <SVRLFailedAssert> ret = new CommonsArrayList <> ();
    if (aSchematronOutput != null)
      for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
        if (aObj instanceof FailedAssert)
          ret.add (new SVRLFailedAssert ((FailedAssert) aObj));
    return ret;
  }

  /**
   * Get a list of all failed assertions in a given schematron output, with an error level equally
   * or more severe than the passed error level.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May be <code>null</code>.
   * @param aErrorLevel
   *        Minimum error level to be queried
   * @return A non-<code>null</code> list with all failed assertions.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <SVRLFailedAssert> getAllFailedAssertionsMoreOrEqualSevereThan (@Nullable final SchematronOutputType aSchematronOutput,
                                                                                             @NonNull final IErrorLevel aErrorLevel)
  {
    final ICommonsList <SVRLFailedAssert> ret = new CommonsArrayList <> ();
    if (aSchematronOutput != null)
      for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
        if (aObj instanceof FailedAssert)
        {
          final SVRLFailedAssert aFA = new SVRLFailedAssert ((FailedAssert) aObj);
          if (aFA.getFlag ().isGE (aErrorLevel))
            ret.add (aFA);
        }
    return ret;
  }

  /**
   * Get a list of all successful reports in a given schematron output.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May be <code>null</code>.
   * @return A non-<code>null</code> list with all successful reports.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <SVRLSuccessfulReport> getAllSuccessfulReports (@Nullable final SchematronOutputType aSchematronOutput)
  {
    final ICommonsList <SVRLSuccessfulReport> ret = new CommonsArrayList <> ();
    if (aSchematronOutput != null)
      for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
        if (aObj instanceof SuccessfulReport)
          ret.add (new SVRLSuccessfulReport ((SuccessfulReport) aObj));
    return ret;
  }

  /**
   * Get a list of all successful reports in a given schematron output, with an error level equally
   * or more severe than the passed error level.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May be <code>null</code>.
   * @param aErrorLevel
   *        Minimum error level to be queried
   * @return A non-<code>null</code> list with all successful reports.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <SVRLSuccessfulReport> getAllSuccessfulReportsMoreOrEqualSevereThan (@Nullable final SchematronOutputType aSchematronOutput,
                                                                                                  @NonNull final IErrorLevel aErrorLevel)
  {
    final ICommonsList <SVRLSuccessfulReport> ret = new CommonsArrayList <> ();
    if (aSchematronOutput != null)
      for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
        if (aObj instanceof SuccessfulReport)
        {
          final SVRLSuccessfulReport aSR = new SVRLSuccessfulReport ((SuccessfulReport) aObj);
          if (aSR.getFlag ().isGE (aErrorLevel))
            ret.add (aSR);
        }
    return ret;
  }

  /**
   * Get a list of all failed assertions and successful reports in a given schematron output.
   *
   * @param aSchematronOutput
   *        The schematron output to be used. May be <code>null</code>.
   * @return A non-<code>null</code> list with all failed assertions and successful reports. Maybe
   *         an empty list if the input is <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <AbstractSVRLMessage> getAllFailedAssertionsAndSuccessfulReports (@Nullable final SchematronOutputType aSchematronOutput)
  {
    final ICommonsList <AbstractSVRLMessage> ret = new CommonsArrayList <> ();
    if (aSchematronOutput != null)
      for (final Object aObj : aSchematronOutput.getActivePatternAndFiredRuleAndFailedAssert ())
        if (aObj instanceof FailedAssert)
          ret.add (new SVRLFailedAssert ((FailedAssert) aObj));
        else
          if (aObj instanceof SuccessfulReport)
            ret.add (new SVRLSuccessfulReport ((SuccessfulReport) aObj));
    return ret;
  }

  /**
   * Get the error level associated with a single failed assertion.
   *
   * @param aFailedAssert
   *        The failed assert to be queried. May not be <code>null</code>.
   * @return The error level and never <code>null</code>.
   */
  @NonNull
  public static IErrorLevel getErrorLevelFromFailedAssert (@NonNull final FailedAssert aFailedAssert)
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
  @NonNull
  public static IErrorLevel getErrorLevelFromSuccessfulReport (@NonNull final SuccessfulReport aSuccessfulReport)
  {
    return getErrorLevelDeterminator ().getErrorLevelFromSuccessfulReport (aSuccessfulReport);
  }

  /**
   * @return The default error level determinator. May not be <code>null</code>.
   */
  @NonNull
  public static ISVRLErrorLevelDeterminator getErrorLevelDeterminator ()
  {
    return RW_LOCK.readLockedGet ( () -> s_aELD);
  }

  /**
   * Set the global error level determinator.
   *
   * @param aELD
   *        The determinator to use. May not be <code>null</code>.
   */
  public static void setErrorLevelDeterminator (@NonNull final ISVRLErrorLevelDeterminator aELD)
  {
    ValueEnforcer.notNull (aELD, "ErrorLevelDeterminator");

    RW_LOCK.writeLocked ( () -> s_aELD = aELD);
  }

  /**
   * Convert an "unsexy" location string in the for, of <code>*:xx[namespace-uri()='yy']</code> to
   * something more readable like <code>prefix:xx</code> by using the mapping registered in the
   * {@link SVRLLocationBeautifierRegistry}.
   *
   * @param sLocation
   *        The original location string. May not be <code>null</code>.
   * @return The beautified string. Never <code>null</code>. Might be identical to the original
   *         string if the pattern was not found.
   * @since 5.0.1
   */
  @NonNull
  public static String getBeautifiedLocation (@NonNull final String sLocation)
  {
    return getBeautifiedLocation (sLocation, SVRLLocationBeautifierRegistry::getBeautifiedLocation);
  }

  /**
   * Convert an "unsexy" location string in the for, of <code>*:xx[namespace-uri()='yy']</code> to
   * something more readable like <code>prefix:xx</code> by using the mapping registered in the
   * {@link SVRLLocationBeautifierRegistry}.
   *
   * @param sLocation
   *        The original location string. May not be <code>null</code>.
   * @param aLocationBeautifier
   *        The location beautifier to be used. May not be <code>null</code>.
   * @return The beautified string. Never <code>null</code>. Might be identical to the original
   *         string if the pattern was not found.
   * @since 6.0.4
   */
  @NonNull
  public static String getBeautifiedLocation (@NonNull final String sLocation,
                                              @NonNull final ISVRLLocationBeautifier aLocationBeautifier)
  {
    ValueEnforcer.notNull (sLocation, "Location");
    ValueEnforcer.notNull (aLocationBeautifier, "LocationBeautifier");

    String sResult = sLocation;
    // Handle namespaces:
    // Search for "*:xx[namespace-uri()='yy']" where xx is the localname and yy
    // is the namespace URI
    final Matcher aMatcher = RegExHelper.getMatcher ("\\Q*:\\E([a-zA-Z0-9_]+)\\Q[namespace-uri()='\\E([^']+)\\Q']\\E",
                                                     sResult);
    while (aMatcher.find ())
    {
      final String sLocalName = aMatcher.group (1);
      final String sNamespaceURI = aMatcher.group (2);

      // Check if there is a known beautifier for this pair of namespace and
      // local name
      final String sBeautified = aLocationBeautifier.getReplacementText (sNamespaceURI, sLocalName);
      if (sBeautified != null)
        sResult = StringReplace.replaceAll (sResult, aMatcher.group (), sBeautified);
    }
    return sResult;
  }

  @NonNull
  public static ICommonsList <DiagnosticReference> getAllDiagnosticReferences (@NonNull final FailedAssert aFA)
  {
    return CommonsArrayList.createFiltered (aFA.getDiagnosticReferenceOrPropertyReferenceOrText (),
                                            DiagnosticReference.class::isInstance,
                                            DiagnosticReference.class::cast);
  }

  @NonNull
  public static ICommonsList <PropertyReference> getAllPropertyReferences (@NonNull final FailedAssert aFA)
  {
    return CommonsArrayList.createFiltered (aFA.getDiagnosticReferenceOrPropertyReferenceOrText (),
                                            PropertyReference.class::isInstance,
                                            PropertyReference.class::cast);
  }

  @NonNull
  public static Text getText (@NonNull final FailedAssert aFA)
  {
    return CollectionFind.findFirstMapped (aFA.getDiagnosticReferenceOrPropertyReferenceOrText (),
                                           Text.class::isInstance,
                                           Text.class::cast);
  }

  @NonNull
  public static ICommonsList <DiagnosticReference> getAllDiagnosticReferences (@NonNull final SuccessfulReport aSR)
  {
    return CommonsArrayList.createFiltered (aSR.getDiagnosticReferenceOrPropertyReferenceOrText (),
                                            DiagnosticReference.class::isInstance,
                                            DiagnosticReference.class::cast);
  }

  @NonNull
  public static ICommonsList <PropertyReference> getAllPropertyReferences (@NonNull final SuccessfulReport aSR)
  {
    return CommonsArrayList.createFiltered (aSR.getDiagnosticReferenceOrPropertyReferenceOrText (),
                                            PropertyReference.class::isInstance,
                                            PropertyReference.class::cast);
  }

  @NonNull
  public static Text getText (@NonNull final SuccessfulReport aSR)
  {
    return CollectionFind.findFirstMapped (aSR.getDiagnosticReferenceOrPropertyReferenceOrText (),
                                           Text.class::isInstance,
                                           Text.class::cast);
  }
}
