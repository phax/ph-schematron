/**
 * Copyright (C) 2014-2019 Philip Helger (www.helger.com)
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

import java.io.Serializable;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

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
 * @see com.helger.schematron.pure.bound.IPSBoundSchema#validate(Node,String,
 *      IPSValidationHandler)
 * @author Philip Helger
 */
public interface IPSValidationHandler extends Serializable
{
  /**
   * This is the first method called.
   *
   * @param aSchema
   *        The Schematron to be validated. Never <code>null</code>.
   * @param aActivePhase
   *        The selected phase, if any special phase was selected. May be
   *        <code>null</code>.
   * @param sBaseURI
   *        The Base URI of the XML to be validated. May be <code>null</code>.
   * @see #onEnd(PSSchema, PSPhase)
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  default void onStart (@Nonnull final PSSchema aSchema,
                        @Nullable final PSPhase aActivePhase,
                        @Nullable final String sBaseURI) throws SchematronValidationException
  {}

  /**
   * This method is called for every pattern inside the schema.
   *
   * @param aPattern
   *        The current pattern. Never <code>null</code>.
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  default void onPattern (@Nonnull final PSPattern aPattern) throws SchematronValidationException
  {}

  /**
   * Called once for each rule, even if the context list is empty.
   *
   * @param aRule
   *        The rule that is to be executed.
   * @param aContextList
   *        The list of context nodes. Never <code>null</code> but maybe empty.
   * @throws SchematronValidationException
   *         In case of errors
   */
  default void onRuleStart (@Nonnull final PSRule aRule,
                            @Nonnull final NodeList aContextList) throws SchematronValidationException
  {}

  /**
   * This method is called for every rule inside the current pattern. Was called
   * "onRule" previously.
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
  default void onFiredRule (@Nonnull final PSRule aRule,
                            @Nonnull final String sContext) throws SchematronValidationException
  {}

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
  default EContinue onFailedAssert (@Nonnull final PSAssertReport aAssertReport,
                                    @Nonnull final String sTestExpression,
                                    @Nonnull final Node aRuleMatchingNode,
                                    final int nNodeIndex,
                                    @Nullable final Object aContext) throws SchematronValidationException
  {
    return EContinue.CONTINUE;
  }

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
  default EContinue onSuccessfulReport (@Nonnull final PSAssertReport aAssertReport,
                                        @Nonnull final String sTestExpression,
                                        @Nonnull final Node aRuleMatchingNode,
                                        final int nNodeIndex,
                                        @Nullable final Object aContext) throws SchematronValidationException
  {
    return EContinue.CONTINUE;
  }

  /**
   * This is the last method called. It indicates that the validation for the
   * current scheme ended.
   *
   * @param aSchema
   *        The Schematron that was be validated. Never <code>null</code>.
   * @param aActivePhase
   *        The selected phase, if any special phase was selected. May be
   *        <code>null</code>.
   * @see #onStart(PSSchema, PSPhase, String)
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  default void onEnd (@Nonnull final PSSchema aSchema,
                      @Nullable final PSPhase aActivePhase) throws SchematronValidationException
  {}

  /**
   * Create a new validation handler that first invokes all methods from this
   * handler, and than later on from the passed validation handler.
   *
   * @param rhs
   *        The validation handler to be invoked after this one. May not be
   *        <code>null</code>.
   * @return The new validation handler that invokes this and the passed on
   */
  @Nonnull
  default IPSValidationHandler and (@Nonnull final IPSValidationHandler rhs)
  {
    return and (this, rhs);
  }

  /**
   * Create a new validation handler that first invokes all methods from the
   * first handler and second from the second handler.
   *
   * @param lhs
   *        The first validation handler to be invoked. May not be
   *        <code>null</code>.
   * @param rhs
   *        The second validation handler to be invoked. May not be
   *        <code>null</code>.
   * @return The new validation handler that invokes both handlers. Never
   *         <code>null</code>.
   */
  @Nonnull
  static IPSValidationHandler and (@Nonnull final IPSValidationHandler lhs, @Nonnull final IPSValidationHandler rhs)
  {
    return new IPSValidationHandler ()
    {
      public void onStart (@Nonnull final PSSchema aSchema,
                           @Nullable final PSPhase aActivePhase,
                           @Nullable final String sBaseURI) throws SchematronValidationException
      {
        lhs.onStart (aSchema, aActivePhase, sBaseURI);
        rhs.onStart (aSchema, aActivePhase, sBaseURI);
      }

      public void onPattern (@Nonnull final PSPattern aPattern) throws SchematronValidationException
      {
        lhs.onPattern (aPattern);
        rhs.onPattern (aPattern);
      }

      public void onRuleStart (@Nonnull final PSRule aRule,
                               @Nonnull final NodeList aContextList) throws SchematronValidationException
      {
        lhs.onRuleStart (aRule, aContextList);
        rhs.onRuleStart (aRule, aContextList);
      }

      public void onFiredRule (@Nonnull final PSRule aRule,
                               @Nonnull final String sContext) throws SchematronValidationException
      {
        lhs.onFiredRule (aRule, sContext);
        rhs.onFiredRule (aRule, sContext);
      }

      @Nonnull
      public EContinue onFailedAssert (@Nonnull final PSAssertReport aAssertReport,
                                       @Nonnull final String sTestExpression,
                                       @Nonnull final Node aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext) throws SchematronValidationException
      {
        EContinue eCtd = lhs.onFailedAssert (aAssertReport, sTestExpression, aRuleMatchingNode, nNodeIndex, aContext);
        if (eCtd.isContinue ())
          eCtd = rhs.onFailedAssert (aAssertReport, sTestExpression, aRuleMatchingNode, nNodeIndex, aContext);
        return eCtd;
      }

      @Nonnull
      public EContinue onSuccessfulReport (@Nonnull final PSAssertReport aAssertReport,
                                           @Nonnull final String sTestExpression,
                                           @Nonnull final Node aRuleMatchingNode,
                                           final int nNodeIndex,
                                           @Nullable final Object aContext) throws SchematronValidationException
      {
        EContinue eCtd = lhs.onSuccessfulReport (aAssertReport,
                                                 sTestExpression,
                                                 aRuleMatchingNode,
                                                 nNodeIndex,
                                                 aContext);
        if (eCtd.isContinue ())
          eCtd = rhs.onSuccessfulReport (aAssertReport, sTestExpression, aRuleMatchingNode, nNodeIndex, aContext);
        return eCtd;
      }

      public void onEnd (@Nonnull final PSSchema aSchema,
                         @Nullable final PSPhase aActivePhase) throws SchematronValidationException
      {
        lhs.onEnd (aSchema, aActivePhase);
        rhs.onEnd (aSchema, aActivePhase);
      }
    };
  }
}
