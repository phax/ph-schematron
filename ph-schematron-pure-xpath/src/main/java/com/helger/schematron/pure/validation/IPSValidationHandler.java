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
package com.helger.schematron.pure.validation;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.helger.annotation.Nonnegative;
import com.helger.base.state.EContinue;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSPhase;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSSchema;

/**
 * Base interface for a Schematron validation callback handler. It is only
 * invoked when validating an XML against a Schematron file.
 *
 * @see com.helger.schematron.pure.bound.IPSBoundSchema#validate(Node,String,
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
   * @param sBaseURI
   *        The Base URI of the XML to be validated. May be <code>null</code>.
   * @see #onEnd(PSSchema, PSPhase)
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  default void onStart (@NonNull final PSSchema aSchema,
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
  default void onPattern (@NonNull final PSPattern aPattern) throws SchematronValidationException
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
  default void onRuleStart (@NonNull final PSRule aRule, @NonNull final NodeList aContextList)
                                                                                               throws SchematronValidationException
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
   * @param nNodeIndex
   *        0-based node index currently fired
   * @param nNodeCount
   *        The total number of nodes for this rule. Always &gt; 0.
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  default void onFiredRule (@NonNull final PSRule aRule,
                            @NonNull final String sContext,
                            @Nonnegative final int nNodeIndex,
                            @Nonnegative final int nNodeCount) throws SchematronValidationException
  {}

  /**
   * This method is called for every failed assert.
   *
   * @param aOwningRule
   *        The rule element that contains the current assertion/report. Never
   *        <code>null</code>. Since v8.0.0.
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
   * @param aEvaluationException
   *        An optional evaluation exception. May be <code>null</code>.
   * @return {@link EContinue#BREAK} to stop validating immediately.
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  @NonNull
  default EContinue onFailedAssert (@NonNull final PSRule aOwningRule,
                                    @NonNull final PSAssertReport aAssertReport,
                                    @NonNull final String sTestExpression,
                                    @NonNull final Node aRuleMatchingNode,
                                    final int nNodeIndex,
                                    @Nullable final Object aContext,
                                    @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    return EContinue.CONTINUE;
  }

  /**
   * This method is called for every failed assert.
   *
   * @param aOwningRule
   *        The rule element that contains the current assertion/report. Never
   *        <code>null</code>. Since v8.0.0.
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
   * @param aEvaluationException
   *        An optional evaluation exception. May be <code>null</code>.
   * @return {@link EContinue#BREAK} to stop validating immediately.
   * @throws SchematronValidationException
   *         In case of validation errors
   */
  @NonNull
  default EContinue onSuccessfulReport (@NonNull final PSRule aOwningRule,
                                        @NonNull final PSAssertReport aAssertReport,
                                        @NonNull final String sTestExpression,
                                        @NonNull final Node aRuleMatchingNode,
                                        final int nNodeIndex,
                                        @Nullable final Object aContext,
                                        @Nullable final Exception aEvaluationException) throws SchematronValidationException
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
  default void onEnd (@NonNull final PSSchema aSchema, @Nullable final PSPhase aActivePhase)
                                                                                             throws SchematronValidationException
  {}

  /**
   * @return <code>true</code> if this handler wants per-rule and per-context evaluation timing. When
   *         <code>false</code> (the default), the engine skips the timing instrumentation entirely,
   *         so there is zero overhead. Drives {@link #onRuleEvaluated(PSRule, long)} and
   *         {@link #onContextEvaluated(PSRule, long, int)}.
   * @since 10.0.0
   */
  default boolean isMeasureTiming ()
  {
    return false;
  }

  /**
   * @return <code>true</code> if this handler wants per-assert evaluation timing (one measurement
   *         per assert / report evaluation per matching node). Significantly more overhead than
   *         {@link #isMeasureTiming()}. Drives
   *         {@link #onTestEvaluated(PSRule, PSAssertReport, String, long, boolean)}. Default is
   *         <code>false</code>.
   * @since 10.0.0
   */
  default boolean isMeasureAssertionTiming ()
  {
    return false;
  }

  /**
   * Called once per rule with the time taken to evaluate its {@code context} expression (the node
   * selection). Only invoked when {@link #isMeasureTiming()} is <code>true</code>.
   *
   * @param aRule
   *        The rule whose context was evaluated. Never <code>null</code>.
   * @param nDurationNanos
   *        The wall-clock duration of the context evaluation in nanoseconds.
   * @param nMatchCount
   *        The number of nodes the context expression selected.
   * @throws SchematronValidationException
   *         In case of validation errors
   * @since 10.0.0
   */
  default void onContextEvaluated (@NonNull final PSRule aRule,
                                   @Nonnegative final long nDurationNanos,
                                   @Nonnegative final int nMatchCount) throws SchematronValidationException
  {}

  /**
   * Called once per assert / report evaluation per matching node - for passing and failing
   * evaluations alike - with the time taken to evaluate the {@code test} expression. Only invoked
   * when {@link #isMeasureAssertionTiming()} is <code>true</code>.
   *
   * @param aRule
   *        The rule that owns the assert / report. Never <code>null</code>.
   * @param aAssertReport
   *        The assert / report whose test was evaluated. Never <code>null</code>.
   * @param sTestExpression
   *        The actual (let-resolved) test expression that was evaluated. Never <code>null</code>.
   * @param nDurationNanos
   *        The wall-clock duration of the test evaluation in nanoseconds.
   * @param bTestResult
   *        The boolean result of the test evaluation.
   * @throws SchematronValidationException
   *         In case of validation errors
   * @since 10.0.0
   */
  default void onTestEvaluated (@NonNull final PSRule aRule,
                                @NonNull final PSAssertReport aAssertReport,
                                @NonNull final String sTestExpression,
                                @Nonnegative final long nDurationNanos,
                                final boolean bTestResult) throws SchematronValidationException
  {}

  /**
   * Called once per rule with the total time taken for the rule - its context selection plus every
   * assert / report evaluation across all matching nodes. This is the per-rule cost used to rank the
   * most expensive rules. Only invoked when {@link #isMeasureTiming()} is <code>true</code>.
   *
   * @param aRule
   *        The rule that was evaluated. Never <code>null</code>.
   * @param nDurationNanos
   *        The total wall-clock duration of the rule in nanoseconds.
   * @throws SchematronValidationException
   *         In case of validation errors
   * @since 10.0.0
   */
  default void onRuleEvaluated (@NonNull final PSRule aRule, @Nonnegative final long nDurationNanos)
                                                                                                     throws SchematronValidationException
  {}

  /**
   * Create a new validation handler that first invokes all methods from this
   * handler, and than later on from the passed validation handler.
   *
   * @param rhs
   *        The validation handler to be invoked after this one. May be
   *        <code>null</code>.
   * @return The new validation handler that invokes this and the passed on
   */
  @NonNull
  default IPSValidationHandler and (@Nullable final IPSValidationHandler rhs)
  {
    if (rhs == null)
      return this;
    return and (this, rhs);
  }

  /**
   * Create a new validation handler that first invokes all methods from the
   * first handler and second from the second handler.
   *
   * @param lhs
   *        The first validation handler to be invoked. May be
   *        <code>null</code>.
   * @param rhs
   *        The second validation handler to be invoked. May be
   *        <code>null</code>.
   * @return The new validation handler that invokes both handlers. May be
   *         <code>null</code> if both are null.
   */
  @NonNull
  static IPSValidationHandler and (@Nullable final IPSValidationHandler lhs, @Nullable final IPSValidationHandler rhs)
  {
    if (lhs == null)
      return rhs;

    if (rhs == null)
      return lhs;

    return new IPSValidationHandler ()
    {
      @Override
      public void onStart (@NonNull final PSSchema aSchema,
                           @Nullable final PSPhase aActivePhase,
                           @Nullable final String sBaseURI) throws SchematronValidationException
      {
        lhs.onStart (aSchema, aActivePhase, sBaseURI);
        rhs.onStart (aSchema, aActivePhase, sBaseURI);
      }

      @Override
      public void onPattern (@NonNull final PSPattern aPattern) throws SchematronValidationException
      {
        lhs.onPattern (aPattern);
        rhs.onPattern (aPattern);
      }

      @Override
      public void onRuleStart (@NonNull final PSRule aRule, @NonNull final NodeList aContextList)
                                                                                                  throws SchematronValidationException
      {
        lhs.onRuleStart (aRule, aContextList);
        rhs.onRuleStart (aRule, aContextList);
      }

      @Override
      public void onFiredRule (@NonNull final PSRule aRule,
                               @NonNull final String sContext,
                               @Nonnegative final int nNodeIndex,
                               @Nonnegative final int nNodeCount) throws SchematronValidationException
      {
        lhs.onFiredRule (aRule, sContext, nNodeIndex, nNodeCount);
        rhs.onFiredRule (aRule, sContext, nNodeIndex, nNodeCount);
      }

      @NonNull
      @Override
      public EContinue onFailedAssert (@NonNull final PSRule aOwningRule,
                                       @NonNull final PSAssertReport aAssertReport,
                                       @NonNull final String sTestExpression,
                                       @NonNull final Node aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext,
                                       @Nullable final Exception aEvaluationException) throws SchematronValidationException
      {
        EContinue eCtd = lhs.onFailedAssert (aOwningRule,
                                             aAssertReport,
                                             sTestExpression,
                                             aRuleMatchingNode,
                                             nNodeIndex,
                                             aContext,
                                             aEvaluationException);
        if (eCtd.isContinue ())
          eCtd = rhs.onFailedAssert (aOwningRule,
                                     aAssertReport,
                                     sTestExpression,
                                     aRuleMatchingNode,
                                     nNodeIndex,
                                     aContext,
                                     aEvaluationException);
        return eCtd;
      }

      @NonNull
      @Override
      public EContinue onSuccessfulReport (@NonNull final PSRule aOwningRule,
                                           @NonNull final PSAssertReport aAssertReport,
                                           @NonNull final String sTestExpression,
                                           @NonNull final Node aRuleMatchingNode,
                                           final int nNodeIndex,
                                           @Nullable final Object aContext,
                                           @Nullable final Exception aEvaluationException) throws SchematronValidationException
      {
        EContinue eCtd = lhs.onSuccessfulReport (aOwningRule,
                                                 aAssertReport,
                                                 sTestExpression,
                                                 aRuleMatchingNode,
                                                 nNodeIndex,
                                                 aContext,
                                                 aEvaluationException);
        if (eCtd.isContinue ())
          eCtd = rhs.onSuccessfulReport (aOwningRule,
                                         aAssertReport,
                                         sTestExpression,
                                         aRuleMatchingNode,
                                         nNodeIndex,
                                         aContext,
                                         aEvaluationException);
        return eCtd;
      }

      @Override
      public void onEnd (@NonNull final PSSchema aSchema, @Nullable final PSPhase aActivePhase)
                                                                                                throws SchematronValidationException
      {
        lhs.onEnd (aSchema, aActivePhase);
        rhs.onEnd (aSchema, aActivePhase);
      }

      @Override
      public boolean isMeasureTiming ()
      {
        return lhs.isMeasureTiming () || rhs.isMeasureTiming ();
      }

      @Override
      public boolean isMeasureAssertionTiming ()
      {
        return lhs.isMeasureAssertionTiming () || rhs.isMeasureAssertionTiming ();
      }

      @Override
      public void onContextEvaluated (@NonNull final PSRule aRule,
                                      @Nonnegative final long nDurationNanos,
                                      @Nonnegative final int nMatchCount) throws SchematronValidationException
      {
        lhs.onContextEvaluated (aRule, nDurationNanos, nMatchCount);
        rhs.onContextEvaluated (aRule, nDurationNanos, nMatchCount);
      }

      @Override
      public void onTestEvaluated (@NonNull final PSRule aRule,
                                   @NonNull final PSAssertReport aAssertReport,
                                   @NonNull final String sTestExpression,
                                   @Nonnegative final long nDurationNanos,
                                   final boolean bTestResult) throws SchematronValidationException
      {
        lhs.onTestEvaluated (aRule, aAssertReport, sTestExpression, nDurationNanos, bTestResult);
        rhs.onTestEvaluated (aRule, aAssertReport, sTestExpression, nDurationNanos, bTestResult);
      }

      @Override
      public void onRuleEvaluated (@NonNull final PSRule aRule, @Nonnegative final long nDurationNanos)
                                                                                                        throws SchematronValidationException
      {
        lhs.onRuleEvaluated (aRule, nDurationNanos);
        rhs.onRuleEvaluated (aRule, nDurationNanos);
      }
    };
  }
}
