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
import org.w3c.dom.Element;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EContinue;
import com.helger.schematron.svrl.jaxb.ActiveGroup;
import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.AssertionMessage;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;
import com.helger.schematron.svrl.jaxb.Dir;
import com.helger.schematron.svrl.jaxb.Emph;
import com.helger.schematron.svrl.jaxb.Error;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.NsPrefixInAttributeValues;
import com.helger.schematron.svrl.jaxb.PropertyReference;
import com.helger.schematron.svrl.jaxb.RichText;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.Span;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.Text;

/**
 * Walks an SVRL document ({@link SchematronOutputType}) and invokes an {@link ISVRLVisitor} for
 * every contained element, in document order.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
@Immutable
public final class SVRLVisitor
{
  @PresentForCodeCoverage
  private static final SVRLVisitor INSTANCE = new SVRLVisitor ();

  private SVRLVisitor ()
  {}

  @NonNull
  private static EContinue _visitRichTextContent (@NonNull final RichText aRichText,
                                                  @NonNull final ISVRLVisitor aVisitor)
  {
    for (final Object aContent : aRichText.getContent ())
    {
      final EContinue eResult;
      if (aContent instanceof final String sText)
        eResult = aVisitor.onTextContent (aRichText, sText);
      else
        if (aContent instanceof final Dir aDir)
          eResult = aVisitor.onDir (aRichText, aDir);
        else
          if (aContent instanceof final Emph aEmph)
            eResult = aVisitor.onEmph (aRichText, aEmph);
          else
            if (aContent instanceof final Span aSpan)
              eResult = aVisitor.onSpan (aRichText, aSpan);
            else
              if (aContent instanceof final Element aForeignElement)
                eResult = aVisitor.onForeignElement (aRichText, aForeignElement);
              else
                throw new IllegalStateException ("Unsupported SVRL rich text content to visit: " + aContent);
      if (eResult.isBreak ())
        return EContinue.BREAK;
    }
    return EContinue.CONTINUE;
  }

  @NonNull
  private static EContinue _visitError (@NonNull final Error aError, @NonNull final ISVRLVisitor aVisitor)
  {
    if (aVisitor.onErrorStart (aError).isBreak ())
      return EContinue.BREAK;
    if (_visitRichTextContent (aError, aVisitor).isBreak ())
      return EContinue.BREAK;
    return aVisitor.onErrorEnd (aError);
  }

  @NonNull
  private static EContinue _visitText (@NonNull final Text aText, @NonNull final ISVRLVisitor aVisitor)
  {
    if (aVisitor.onTextStart (aText).isBreak ())
      return EContinue.BREAK;
    if (_visitRichTextContent (aText, aVisitor).isBreak ())
      return EContinue.BREAK;
    return aVisitor.onTextEnd (aText);
  }

  @NonNull
  private static EContinue _visitDiagnosticReference (@NonNull final DiagnosticReference aDiagnosticReference,
                                                      @NonNull final ISVRLVisitor aVisitor)
  {
    if (aVisitor.onDiagnosticReferenceStart (aDiagnosticReference).isBreak ())
      return EContinue.BREAK;
    final Text aText = aDiagnosticReference.getText ();
    if (aText != null && _visitText (aText, aVisitor).isBreak ())
      return EContinue.BREAK;
    return aVisitor.onDiagnosticReferenceEnd (aDiagnosticReference);
  }

  @NonNull
  private static EContinue _visitPropertyReference (@NonNull final PropertyReference aPropertyReference,
                                                    @NonNull final ISVRLVisitor aVisitor)
  {
    if (aVisitor.onPropertyReferenceStart (aPropertyReference).isBreak ())
      return EContinue.BREAK;
    final Text aText = aPropertyReference.getText ();
    if (aText != null && _visitText (aText, aVisitor).isBreak ())
      return EContinue.BREAK;
    return aVisitor.onPropertyReferenceEnd (aPropertyReference);
  }

  /**
   * Visit the children shared by failed asserts and successful reports.
   *
   * @param aAssertionMessage
   *        The failed assert or successful report. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   * @return {@link EContinue#BREAK} if the visitor stopped the walk.
   */
  @NonNull
  private static EContinue _visitAssertionMessageChildren (@NonNull final AssertionMessage aAssertionMessage,
                                                           @NonNull final ISVRLVisitor aVisitor)
  {
    for (final DiagnosticReference aDiagnosticReference : aAssertionMessage.getDiagnosticReference ())
      if (_visitDiagnosticReference (aDiagnosticReference, aVisitor).isBreak ())
        return EContinue.BREAK;
    for (final PropertyReference aPropertyReference : aAssertionMessage.getPropertyReference ())
      if (_visitPropertyReference (aPropertyReference, aVisitor).isBreak ())
        return EContinue.BREAK;
    final Text aText = aAssertionMessage.getText ();
    if (aText != null && _visitText (aText, aVisitor).isBreak ())
      return EContinue.BREAK;
    return EContinue.CONTINUE;
  }

  @NonNull
  private static EContinue _visitActivePatternOrGroupOrRule (@NonNull final SchematronOutputType aSchematronOutput,
                                                             @NonNull final Object aObject,
                                                             @NonNull final ISVRLVisitor aVisitor)
  {
    if (aObject instanceof final ActivePattern aActivePattern)
    {
      if (aVisitor.onActivePatternStart (aActivePattern).isBreak ())
        return EContinue.BREAK;
      for (final Error aError : aActivePattern.getError ())
        if (_visitError (aError, aVisitor).isBreak ())
          return EContinue.BREAK;
      return aVisitor.onActivePatternEnd (aActivePattern);
    }
    if (aObject instanceof final ActiveGroup aActiveGroup)
    {
      if (aVisitor.onActiveGroupStart (aActiveGroup).isBreak ())
        return EContinue.BREAK;
      for (final Error aError : aActiveGroup.getError ())
        if (_visitError (aError, aVisitor).isBreak ())
          return EContinue.BREAK;
      return aVisitor.onActiveGroupEnd (aActiveGroup);
    }
    if (aObject instanceof final FiredRule aFiredRule)
      return aVisitor.onFiredRule (aSchematronOutput, aFiredRule);
    if (aObject instanceof final FailedAssert aFailedAssert)
    {
      if (aVisitor.onFailedAssertStart (aFailedAssert).isBreak ())
        return EContinue.BREAK;
      if (_visitAssertionMessageChildren (aFailedAssert, aVisitor).isBreak ())
        return EContinue.BREAK;
      return aVisitor.onFailedAssertEnd (aFailedAssert);
    }
    if (aObject instanceof final SuccessfulReport aSuccessfulReport)
    {
      if (aVisitor.onSuccessfulReportStart (aSuccessfulReport).isBreak ())
        return EContinue.BREAK;
      if (_visitAssertionMessageChildren (aSuccessfulReport, aVisitor).isBreak ())
        return EContinue.BREAK;
      return aVisitor.onSuccessfulReportEnd (aSuccessfulReport);
    }
    throw new IllegalStateException ("Unsupported SVRL object to visit: " + aObject);
  }

  /**
   * Walk the whole SVRL document and invoke the visitor for each contained element.
   *
   * @param aSchematronOutput
   *        The SVRL document to be visited. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   * @return {@link EContinue#BREAK} if the visitor stopped the walk, {@link EContinue#CONTINUE}
   *         if the whole SVRL document was visited.
   */
  @NonNull
  public static EContinue visit (@NonNull final SchematronOutputType aSchematronOutput,
                                 @NonNull final ISVRLVisitor aVisitor)
  {
    ValueEnforcer.notNull (aSchematronOutput, "SchematronOutput");
    ValueEnforcer.notNull (aVisitor, "Visitor");

    if (aVisitor.onSchematronOutputStart (aSchematronOutput).isBreak ())
      return EContinue.BREAK;

    final Object aAnyElement = aSchematronOutput.getAny ();
    if (aAnyElement != null && aVisitor.onAnyElement (aSchematronOutput, aAnyElement).isBreak ())
      return EContinue.BREAK;
    for (final Error aError : aSchematronOutput.getError ())
      if (_visitError (aError, aVisitor).isBreak ())
        return EContinue.BREAK;
    for (final Text aText : aSchematronOutput.getText ())
      if (_visitText (aText, aVisitor).isBreak ())
        return EContinue.BREAK;
    for (final NsPrefixInAttributeValues aNsPrefix : aSchematronOutput.getNsPrefixInAttributeValues ())
      if (aVisitor.onNsPrefixInAttributeValues (aSchematronOutput, aNsPrefix).isBreak ())
        return EContinue.BREAK;
    for (final Object aObject : aSchematronOutput.getActivePatternOrActiveGroupAndFiredRule ())
      if (_visitActivePatternOrGroupOrRule (aSchematronOutput, aObject, aVisitor).isBreak ())
        return EContinue.BREAK;

    return aVisitor.onSchematronOutputEnd (aSchematronOutput);
  }

  /**
   * Walk the whole SVRL document and invoke the visitor for each contained element.
   *
   * @param aSchematronOutput
   *        The SVRL document to be visited. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   */
  public static void visit (@NonNull final SchematronOutputType aSchematronOutput,
                            @NonNull final ISVRLVoidVisitor aVisitor)
  {
    ValueEnforcer.notNull (aVisitor, "Visitor");

    visit (aSchematronOutput, new SVRLVoidVisitorWrapper (aVisitor));
  }

  /**
   * Walk the whole SVRL document and invoke the visitor for each failed assert and successful
   * report together with the active pattern or group and fired rule it belongs to.
   *
   * @param aSchematronOutput
   *        The SVRL document to be visited. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   * @return {@link EContinue#BREAK} if the visitor stopped the walk, {@link EContinue#CONTINUE}
   *         if the whole SVRL document was visited.
   * @see SVRLContextVisitorWrapper
   */
  @NonNull
  public static EContinue visit (@NonNull final SchematronOutputType aSchematronOutput,
                                 @NonNull final ISVRLContextVisitor aVisitor)
  {
    ValueEnforcer.notNull (aVisitor, "Visitor");

    return visit (aSchematronOutput, new SVRLContextVisitorWrapper (aVisitor));
  }
}
