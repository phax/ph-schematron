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
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EContinue;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.schematron.svrl.jaxb.ActiveGroup;
import com.helger.schematron.svrl.jaxb.ActivePattern;
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
 * Wraps an {@link ISVRLVoidVisitor} into an {@link ISVRLVisitor}. All callbacks are forwarded to
 * the wrapped visitor and always return {@link EContinue#CONTINUE}.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
@Immutable
public class SVRLVoidVisitorWrapper implements ISVRLVisitor
{
  private final ISVRLVoidVisitor m_aVisitor;

  /**
   * Constructor
   *
   * @param aVisitor
   *        The visitor to be wrapped. May not be <code>null</code>.
   */
  public SVRLVoidVisitorWrapper (@NonNull final ISVRLVoidVisitor aVisitor)
  {
    ValueEnforcer.notNull (aVisitor, "Visitor");
    m_aVisitor = aVisitor;
  }

  /**
   * @return The wrapped visitor as passed in the constructor. Never <code>null</code>.
   */
  @NonNull
  public final ISVRLVoidVisitor getWrappedVisitor ()
  {
    return m_aVisitor;
  }

  @Override
  @NonNull
  public EContinue onSchematronOutputStart (@NonNull final SchematronOutputType aSchematronOutput)
  {
    m_aVisitor.onSchematronOutputStart (aSchematronOutput);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSchematronOutputEnd (@NonNull final SchematronOutputType aSchematronOutput)
  {
    m_aVisitor.onSchematronOutputEnd (aSchematronOutput);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onErrorStart (@NonNull final Error aError)
  {
    m_aVisitor.onErrorStart (aError);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onErrorEnd (@NonNull final Error aError)
  {
    m_aVisitor.onErrorEnd (aError);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onTextStart (@NonNull final Text aText)
  {
    m_aVisitor.onTextStart (aText);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onTextEnd (@NonNull final Text aText)
  {
    m_aVisitor.onTextEnd (aText);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onActivePatternStart (@NonNull final ActivePattern aActivePattern)
  {
    m_aVisitor.onActivePatternStart (aActivePattern);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onActivePatternEnd (@NonNull final ActivePattern aActivePattern)
  {
    m_aVisitor.onActivePatternEnd (aActivePattern);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onActiveGroupStart (@NonNull final ActiveGroup aActiveGroup)
  {
    m_aVisitor.onActiveGroupStart (aActiveGroup);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onActiveGroupEnd (@NonNull final ActiveGroup aActiveGroup)
  {
    m_aVisitor.onActiveGroupEnd (aActiveGroup);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onFailedAssertStart (@NonNull final FailedAssert aFailedAssert)
  {
    m_aVisitor.onFailedAssertStart (aFailedAssert);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onFailedAssertEnd (@NonNull final FailedAssert aFailedAssert)
  {
    m_aVisitor.onFailedAssertEnd (aFailedAssert);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSuccessfulReportStart (@NonNull final SuccessfulReport aSuccessfulReport)
  {
    m_aVisitor.onSuccessfulReportStart (aSuccessfulReport);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSuccessfulReportEnd (@NonNull final SuccessfulReport aSuccessfulReport)
  {
    m_aVisitor.onSuccessfulReportEnd (aSuccessfulReport);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDiagnosticReferenceStart (@NonNull final DiagnosticReference aDiagnosticReference)
  {
    m_aVisitor.onDiagnosticReferenceStart (aDiagnosticReference);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDiagnosticReferenceEnd (@NonNull final DiagnosticReference aDiagnosticReference)
  {
    m_aVisitor.onDiagnosticReferenceEnd (aDiagnosticReference);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPropertyReferenceStart (@NonNull final PropertyReference aPropertyReference)
  {
    m_aVisitor.onPropertyReferenceStart (aPropertyReference);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onPropertyReferenceEnd (@NonNull final PropertyReference aPropertyReference)
  {
    m_aVisitor.onPropertyReferenceEnd (aPropertyReference);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onAnyElement (@NonNull final SchematronOutputType aParent, @NonNull final Object aAnyElement)
  {
    m_aVisitor.onAnyElement (aParent, aAnyElement);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onNsPrefixInAttributeValues (@NonNull final SchematronOutputType aParent,
                                                @NonNull final NsPrefixInAttributeValues aNsPrefixInAttributeValues)
  {
    m_aVisitor.onNsPrefixInAttributeValues (aParent, aNsPrefixInAttributeValues);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onFiredRule (@NonNull final SchematronOutputType aParent, @NonNull final FiredRule aFiredRule)
  {
    m_aVisitor.onFiredRule (aParent, aFiredRule);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onDir (@NonNull final RichText aParent, @NonNull final Dir aDir)
  {
    m_aVisitor.onDir (aParent, aDir);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onEmph (@NonNull final RichText aParent, @NonNull final Emph aEmph)
  {
    m_aVisitor.onEmph (aParent, aEmph);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSpan (@NonNull final RichText aParent, @NonNull final Span aSpan)
  {
    m_aVisitor.onSpan (aParent, aSpan);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onTextContent (@NonNull final RichText aParent, @NonNull final String sText)
  {
    m_aVisitor.onTextContent (aParent, sText);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onForeignElement (@NonNull final RichText aParent, @NonNull final Element aForeignElement)
  {
    m_aVisitor.onForeignElement (aParent, aForeignElement);
    return EContinue.CONTINUE;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Visitor", m_aVisitor).getToString ();
  }
}
