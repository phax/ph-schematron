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
package com.helger.schematron.pure.validation;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.w3c.dom.Node;

import com.helger.commons.state.EContinue;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;

/**
 * Base interface for a Schematron validation callback handler. It is only
 * invoked when validating an XML against a Schematron file.
 *
 * @see com.helger.schematron.pure.bound.IPSBoundSchema#validate(Node,
 *      IPSValidationHandler)
 * @author Philip Helger
 */
public interface IPSValidationHandler
{
  /**
   * This is the first method called.
   *
   * @param aSchema
   *        The Schematron to be validated. Never <code>null</code>.
   * @param aActivePhase
   *        The selected phase, if any special phase was selected. May be
   *        <code>null</code>.
   * @see #onEnd(PSSchema, PSPhase)
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  void onStart (@Nonnull PSSchema aSchema, @Nullable PSPhase aActivePhase) throws SchematronValidationException;

  /**
   * This method is called for every pattern inside the schema.
   *
   * @param aPattern
   *        The current pattern. Never <code>null</code>.
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  void onPattern (@Nonnull PSPattern aPattern) throws SchematronValidationException;

  /**
   * This method is called for every rule inside the current pattern.
   *
   * @param aRule
   *        The current rule. Never <code>null</code>.
   * @param sContext
   *        The real context to be used in validation. May differ from the
   *        result of {@link PSRule#getContext()} because of replaced variables
   *        from &lt;let&gt; elements.
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  void onRule (@Nonnull PSRule aRule, @Nonnull String sContext) throws SchematronValidationException;

  /**
   * This method is called for every failed assert.
   *
   * @param aAssertReport
   *        The current assert element. Never <code>null</code>.
   * @param sTestExpression
   *        The source XPath expression that was evaluated for this node. It may
   *        be different from the test expression contained in the passed
   *        assert/report element because of replaced &lt;let&gt; elements.
   *        Never <code>null</code>.
   * @param aRuleMatchingNode
   *        The XML node of the document to be validated.
   * @param nNodeIndex
   *        The index of the matched node, relative to the current rule.
   * @param aContext
   *        A context object - implementation dependent. For the default query
   *        binding this is e.g. an
   *        {@link com.helger.schematron.pure.bound.xpath.PSXPathBoundAssertReport}
   *        object.
   * @return {@link EContinue#BREAK} to stop validating immediately.
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  @Nonnull
  EContinue onFailedAssert (@Nonnull PSAssertReport aAssertReport,
                            @Nonnull String sTestExpression,
                            @Nonnull Node aRuleMatchingNode,
                            int nNodeIndex,
                            @Nullable Object aContext) throws SchematronValidationException;

  /**
   * This method is called for every failed assert.
   *
   * @param aAssertReport
   *        The current assert element. Never <code>null</code>.
   * @param sTestExpression
   *        The source XPath expression that was evaluated for this node. It may
   *        be different from the test expression contained in the passed
   *        assert/report element because of replaced &lt;let&gt; elements.
   *        Never <code>null</code>.
   * @param aRuleMatchingNode
   *        The XML node of the document to be validated.
   * @param nNodeIndex
   *        The index of the matched node, relative to the current rule.
   * @param aContext
   *        A context object - implementation dependent. For the default query
   *        binding this is e.g. an
   *        {@link com.helger.schematron.pure.bound.xpath.PSXPathBoundAssertReport}
   *        object.
   * @return {@link EContinue#BREAK} to stop validating immediately.
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  @Nonnull
  EContinue onSuccessfulReport (@Nonnull PSAssertReport aAssertReport,
                                @Nonnull String sTestExpression,
                                @Nonnull Node aRuleMatchingNode,
                                int nNodeIndex,
                                @Nullable Object aContext) throws SchematronValidationException;

  /**
   * This is the last method called. It indicates that the validation for the
   * current scheme ended.
   *
   * @param aSchema
   *        The Schematron that was be validated. Never <code>null</code>.
   * @param aActivePhase
   *        The selected phase, if any special phase was selected. May be
   *        <code>null</code>.
   * @see #onStart(PSSchema, PSPhase)
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  void onEnd (@Nonnull PSSchema aSchema, @Nullable PSPhase aActivePhase) throws SchematronValidationException;
}
