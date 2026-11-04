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
 * Visitor for an SVRL document ({@link SchematronOutputType}) that cannot stop the walk. It offers
 * the same callbacks as {@link ISVRLVisitor} but without a return value. Use
 * {@link SVRLVoidVisitorWrapper} to turn it into an {@link ISVRLVisitor}, or call
 * {@link SVRLVisitor#visit(SchematronOutputType, ISVRLVoidVisitor)} directly.<br>
 * All methods have a default implementation that does nothing, so only the relevant methods need
 * to be overridden.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
public interface ISVRLVoidVisitor
{
  /**
   * Called before the children of the <code>&lt;schematron-output&gt;</code> root element are visited.
   *
   * @param aSchematronOutput
   *        The SVRL root element. Never <code>null</code>.
   */
  default void onSchematronOutputStart (@NonNull final SchematronOutputType aSchematronOutput)
  {}

  /**
   * Called after the children of the <code>&lt;schematron-output&gt;</code> root element were visited.
   *
   * @param aSchematronOutput
   *        The SVRL root element. Never <code>null</code>.
   */
  default void onSchematronOutputEnd (@NonNull final SchematronOutputType aSchematronOutput)
  {}

  /**
   * Called before the children of an <code>&lt;error&gt;</code> element are visited.
   *
   * @param aError
   *        The error. Never <code>null</code>.
   */
  default void onErrorStart (@NonNull final Error aError)
  {}

  /**
   * Called after the children of an <code>&lt;error&gt;</code> element were visited.
   *
   * @param aError
   *        The error. Never <code>null</code>.
   */
  default void onErrorEnd (@NonNull final Error aError)
  {}

  /**
   * Called before the children of a <code>&lt;text&gt;</code> element are visited.
   *
   * @param aText
   *        The text. Never <code>null</code>.
   */
  default void onTextStart (@NonNull final Text aText)
  {}

  /**
   * Called after the children of a <code>&lt;text&gt;</code> element were visited.
   *
   * @param aText
   *        The text. Never <code>null</code>.
   */
  default void onTextEnd (@NonNull final Text aText)
  {}

  /**
   * Called before the children of an <code>&lt;active-pattern&gt;</code> element are visited.
   *
   * @param aActivePattern
   *        The active pattern. Never <code>null</code>.
   */
  default void onActivePatternStart (@NonNull final ActivePattern aActivePattern)
  {}

  /**
   * Called after the children of an <code>&lt;active-pattern&gt;</code> element were visited.
   *
   * @param aActivePattern
   *        The active pattern. Never <code>null</code>.
   */
  default void onActivePatternEnd (@NonNull final ActivePattern aActivePattern)
  {}

  /**
   * Called before the children of an <code>&lt;active-group&gt;</code> element are visited.
   *
   * @param aActiveGroup
   *        The active group. Never <code>null</code>.
   */
  default void onActiveGroupStart (@NonNull final ActiveGroup aActiveGroup)
  {}

  /**
   * Called after the children of an <code>&lt;active-group&gt;</code> element were visited.
   *
   * @param aActiveGroup
   *        The active group. Never <code>null</code>.
   */
  default void onActiveGroupEnd (@NonNull final ActiveGroup aActiveGroup)
  {}

  /**
   * Called before the children of a <code>&lt;failed-assert&gt;</code> element are visited.
   *
   * @param aFailedAssert
   *        The failed assert. Never <code>null</code>.
   */
  default void onFailedAssertStart (@NonNull final FailedAssert aFailedAssert)
  {}

  /**
   * Called after the children of a <code>&lt;failed-assert&gt;</code> element were visited.
   *
   * @param aFailedAssert
   *        The failed assert. Never <code>null</code>.
   */
  default void onFailedAssertEnd (@NonNull final FailedAssert aFailedAssert)
  {}

  /**
   * Called before the children of a <code>&lt;successful-report&gt;</code> element are visited.
   *
   * @param aSuccessfulReport
   *        The successful report. Never <code>null</code>.
   */
  default void onSuccessfulReportStart (@NonNull final SuccessfulReport aSuccessfulReport)
  {}

  /**
   * Called after the children of a <code>&lt;successful-report&gt;</code> element were visited.
   *
   * @param aSuccessfulReport
   *        The successful report. Never <code>null</code>.
   */
  default void onSuccessfulReportEnd (@NonNull final SuccessfulReport aSuccessfulReport)
  {}

  /**
   * Called before the children of a <code>&lt;diagnostic-reference&gt;</code> element are visited.
   *
   * @param aDiagnosticReference
   *        The diagnostic reference. Never <code>null</code>.
   */
  default void onDiagnosticReferenceStart (@NonNull final DiagnosticReference aDiagnosticReference)
  {}

  /**
   * Called after the children of a <code>&lt;diagnostic-reference&gt;</code> element were visited.
   *
   * @param aDiagnosticReference
   *        The diagnostic reference. Never <code>null</code>.
   */
  default void onDiagnosticReferenceEnd (@NonNull final DiagnosticReference aDiagnosticReference)
  {}

  /**
   * Called before the children of a <code>&lt;property-reference&gt;</code> element are visited.
   *
   * @param aPropertyReference
   *        The property reference. Never <code>null</code>.
   */
  default void onPropertyReferenceStart (@NonNull final PropertyReference aPropertyReference)
  {}

  /**
   * Called after the children of a <code>&lt;property-reference&gt;</code> element were visited.
   *
   * @param aPropertyReference
   *        The property reference. Never <code>null</code>.
   */
  default void onPropertyReferenceEnd (@NonNull final PropertyReference aPropertyReference)
  {}

  /**
   * Called for the optional foreign element at the beginning of the SVRL root element (e.g. SchXslt metadata).
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aAnyElement
   *        The foreign element. Never <code>null</code>.
   */
  default void onAnyElement (@NonNull final SchematronOutputType aParent, @NonNull final Object aAnyElement)
  {}

  /**
   * Called for each <code>&lt;ns-prefix-in-attribute-values&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aNsPrefixInAttributeValues
   *        The namespace prefix declaration. Never <code>null</code>.
   */
  default void onNsPrefixInAttributeValues (@NonNull final SchematronOutputType aParent,
                                            @NonNull final NsPrefixInAttributeValues aNsPrefixInAttributeValues)
  {}

  /**
   * Called for each <code>&lt;fired-rule&gt;</code> element. The failed asserts and successful reports
   * of a fired rule are its following siblings and not its children.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aFiredRule
   *        The fired rule. Never <code>null</code>.
   */
  default void onFiredRule (@NonNull final SchematronOutputType aParent, @NonNull final FiredRule aFiredRule)
  {}

  /**
   * Called for each <code>&lt;dir&gt;</code> element in rich text.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aDir
   *        The dir element. Never <code>null</code>.
   */
  default void onDir (@NonNull final RichText aParent, @NonNull final Dir aDir)
  {}

  /**
   * Called for each <code>&lt;emph&gt;</code> element in rich text.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aEmph
   *        The emph element. Never <code>null</code>.
   */
  default void onEmph (@NonNull final RichText aParent, @NonNull final Emph aEmph)
  {}

  /**
   * Called for each <code>&lt;span&gt;</code> element in rich text.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aSpan
   *        The span element. Never <code>null</code>.
   */
  default void onSpan (@NonNull final RichText aParent, @NonNull final Span aSpan)
  {}

  /**
   * Called for each text node in rich text.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param sText
   *        The text. Never <code>null</code>.
   */
  default void onTextContent (@NonNull final RichText aParent, @NonNull final String sText)
  {}

  /**
   * Called for each foreign (non-SVRL) element in rich text. Foreign elements are not descended
   * into.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aForeignElement
   *        The foreign element. Never <code>null</code>.
   */
  default void onForeignElement (@NonNull final RichText aParent, @NonNull final Element aForeignElement)
  {}
}
