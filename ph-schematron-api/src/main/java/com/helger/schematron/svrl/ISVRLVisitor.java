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

import com.helger.base.state.EContinue;
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
 * Visitor for an SVRL document ({@link SchematronOutputType}) as used by {@link SVRLVisitor}.
 * Elements that may have children are reported with a <code>...Start</code> and a
 * <code>...End</code> callback, all other elements with a single callback that also receives the
 * parent element. Returning {@link EContinue#BREAK} from any callback stops the whole walk
 * immediately - no further callback (including the outstanding <code>...End</code> callbacks) is
 * invoked.<br>
 * All methods have a default implementation that does nothing and returns
 * {@link EContinue#CONTINUE}, so only the relevant methods need to be overridden.<br>
 * Use {@link ISVRLVoidVisitor} together with {@link SVRLVoidVisitorWrapper} if stopping the walk
 * is not needed.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
public interface ISVRLVisitor
{
  /**
   * Called before the children of the <code>&lt;schematron-output&gt;</code> root element are visited.
   *
   * @param aSchematronOutput
   *        The SVRL root element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSchematronOutputStart (@NonNull final SchematronOutputType aSchematronOutput)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of the <code>&lt;schematron-output&gt;</code> root element were visited.
   *
   * @param aSchematronOutput
   *        The SVRL root element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSchematronOutputEnd (@NonNull final SchematronOutputType aSchematronOutput)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of an <code>&lt;error&gt;</code> element are visited.
   *
   * @param aError
   *        The error. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onErrorStart (@NonNull final Error aError)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of an <code>&lt;error&gt;</code> element were visited.
   *
   * @param aError
   *        The error. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onErrorEnd (@NonNull final Error aError)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;text&gt;</code> element are visited.
   *
   * @param aText
   *        The text. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onTextStart (@NonNull final Text aText)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;text&gt;</code> element were visited.
   *
   * @param aText
   *        The text. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onTextEnd (@NonNull final Text aText)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of an <code>&lt;active-pattern&gt;</code> element are visited.
   *
   * @param aActivePattern
   *        The active pattern. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onActivePatternStart (@NonNull final ActivePattern aActivePattern)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of an <code>&lt;active-pattern&gt;</code> element were visited.
   *
   * @param aActivePattern
   *        The active pattern. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onActivePatternEnd (@NonNull final ActivePattern aActivePattern)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of an <code>&lt;active-group&gt;</code> element are visited.
   *
   * @param aActiveGroup
   *        The active group. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onActiveGroupStart (@NonNull final ActiveGroup aActiveGroup)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of an <code>&lt;active-group&gt;</code> element were visited.
   *
   * @param aActiveGroup
   *        The active group. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onActiveGroupEnd (@NonNull final ActiveGroup aActiveGroup)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;failed-assert&gt;</code> element are visited.
   *
   * @param aFailedAssert
   *        The failed assert. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onFailedAssertStart (@NonNull final FailedAssert aFailedAssert)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;failed-assert&gt;</code> element were visited.
   *
   * @param aFailedAssert
   *        The failed assert. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onFailedAssertEnd (@NonNull final FailedAssert aFailedAssert)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;successful-report&gt;</code> element are visited.
   *
   * @param aSuccessfulReport
   *        The successful report. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSuccessfulReportStart (@NonNull final SuccessfulReport aSuccessfulReport)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;successful-report&gt;</code> element were visited.
   *
   * @param aSuccessfulReport
   *        The successful report. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSuccessfulReportEnd (@NonNull final SuccessfulReport aSuccessfulReport)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;diagnostic-reference&gt;</code> element are visited.
   *
   * @param aDiagnosticReference
   *        The diagnostic reference. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDiagnosticReferenceStart (@NonNull final DiagnosticReference aDiagnosticReference)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;diagnostic-reference&gt;</code> element were visited.
   *
   * @param aDiagnosticReference
   *        The diagnostic reference. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDiagnosticReferenceEnd (@NonNull final DiagnosticReference aDiagnosticReference)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called before the children of a <code>&lt;property-reference&gt;</code> element are visited.
   *
   * @param aPropertyReference
   *        The property reference. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPropertyReferenceStart (@NonNull final PropertyReference aPropertyReference)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called after the children of a <code>&lt;property-reference&gt;</code> element were visited.
   *
   * @param aPropertyReference
   *        The property reference. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onPropertyReferenceEnd (@NonNull final PropertyReference aPropertyReference)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for the optional foreign element at the beginning of the SVRL root element (e.g. SchXslt metadata).
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aAnyElement
   *        The foreign element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onAnyElement (@NonNull final SchematronOutputType aParent, @NonNull final Object aAnyElement)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;ns-prefix-in-attribute-values&gt;</code> element.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aNsPrefixInAttributeValues
   *        The namespace prefix declaration. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onNsPrefixInAttributeValues (@NonNull final SchematronOutputType aParent,
                                                 @NonNull final NsPrefixInAttributeValues aNsPrefixInAttributeValues)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;fired-rule&gt;</code> element. The failed asserts and successful reports
   * of a fired rule are its following siblings and not its children.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aFiredRule
   *        The fired rule. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onFiredRule (@NonNull final SchematronOutputType aParent, @NonNull final FiredRule aFiredRule)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;dir&gt;</code> element in rich text.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aDir
   *        The dir element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onDir (@NonNull final RichText aParent, @NonNull final Dir aDir)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;emph&gt;</code> element in rich text.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aEmph
   *        The emph element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onEmph (@NonNull final RichText aParent, @NonNull final Emph aEmph)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each <code>&lt;span&gt;</code> element in rich text.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aSpan
   *        The span element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onSpan (@NonNull final RichText aParent, @NonNull final Span aSpan)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each text node in rich text.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param sText
   *        The text. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onTextContent (@NonNull final RichText aParent, @NonNull final String sText)
  {
    return EContinue.CONTINUE;
  }

  /**
   * Called for each foreign (non-SVRL) element in rich text. Foreign elements are not descended
   * into.
   *
   * @param aParent
   *        The parent element. Never <code>null</code>.
   * @param aForeignElement
   *        The foreign element. Never <code>null</code>.
   * @return {@link EContinue#BREAK} to stop the walk.
   */
  @NonNull
  default EContinue onForeignElement (@NonNull final RichText aParent, @NonNull final Element aForeignElement)
  {
    return EContinue.CONTINUE;
  }
}
