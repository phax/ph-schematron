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
package com.helger.schematron.pure.validation.telemetry;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Node;

import com.helger.annotation.Nonnegative;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.CGlobal;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EContinue;
import com.helger.base.timing.StopWatch;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.telemetry.CSchematronTelemetry;
import com.helger.schematron.api.telemetry.RuleDurationTemplateTelemetry;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSPhase;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.validation.SchematronValidationException;
import com.helger.telemetry.ETelemetrySpanKind;
import com.helger.telemetry.ITelemetryCounter;
import com.helger.telemetry.ITelemetryHistogram;
import com.helger.telemetry.ITelemetrySpan;
import com.helger.telemetry.Telemetry;
import com.helger.telemetry.TelemetryAttributes;
import com.helger.telemetry.TelemetryMetrics;

/**
 * Implementation of {@link IPSValidationHandler} that emits runtime telemetry - counters, spans and
 * a duration histogram - via ph-telemetry. Install on a {@code SchematronResourcePure} by calling
 * {@code setTelemetry(true)} (which composes this with any caller-supplied custom handler). All
 * span / metric / attribute names come from the shared {@link CSchematronTelemetry} vocabulary so
 * every engine stays in lock-step.
 * <p>
 * Independently controllable modes:
 * <ul>
 * <li><b>Aggregate</b> - one {@link CSchematronTelemetry#SPAN_VALIDATE} span around the whole
 * validation, child counters for fired-rules / failed-asserts / successful-reports /
 * active-patterns, and a {@link CSchematronTelemetry#METRIC_VALIDATE_DURATION} histogram entry on
 * completion.</li>
 * <li><b>Per-assertion result spans</b> - an extra <code>SPAN_ASSERTION</code> child span per
 * failed-assert / successful-report (post-evaluation findings).</li>
 * <li><b>Per-rule execution timing</b> - {@link CSchematronTelemetry#METRIC_RULE_DURATION},
 * {@link CSchematronTelemetry#METRIC_CONTEXT_DURATION} and
 * {@link CSchematronTelemetry#METRIC_ASSERT_DURATION} histograms for finding the most expensive
 * rules. The per-assert histogram fires once per assert per matching node; significant
 * overhead.</li>
 * </ul>
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public final class TelemetryValidationHandler implements IPSValidationHandler
{
  // Pre-resolved instruments. Created once on class load; emit-time cost is just a SPI call.
  private static final ITelemetryCounter COUNTER_FAILED_ASSERTS = TelemetryMetrics.counter (CSchematronTelemetry.METRIC_ASSERTIONS_FAILED,
                                                                                            "Number of failed Schematron assertions",
                                                                                            CSchematronTelemetry.UNIT_COUNT);
  private static final ITelemetryCounter COUNTER_SUCCESSFUL_REPORTS = TelemetryMetrics.counter (CSchematronTelemetry.METRIC_REPORTS_FIRED,
                                                                                                "Number of fired Schematron reports",
                                                                                                CSchematronTelemetry.UNIT_COUNT);
  private static final ITelemetryCounter COUNTER_RULES = TelemetryMetrics.counter (CSchematronTelemetry.METRIC_RULES_FIRED,
                                                                                   "Number of fired Schematron rules",
                                                                                   CSchematronTelemetry.UNIT_COUNT);
  private static final ITelemetryCounter COUNTER_PATTERNS = TelemetryMetrics.counter (CSchematronTelemetry.METRIC_PATTERNS_ACTIVE,
                                                                                      "Number of active Schematron patterns visited",
                                                                                      CSchematronTelemetry.UNIT_COUNT);
  private static final ITelemetryHistogram HIST_DURATION = TelemetryMetrics.histogram (CSchematronTelemetry.METRIC_VALIDATE_DURATION,
                                                                                       "Schematron validation duration",
                                                                                       CSchematronTelemetry.UNIT_MILLIS);
  private static final ITelemetryHistogram HIST_CONTEXT_DURATION = TelemetryMetrics.histogram (CSchematronTelemetry.METRIC_CONTEXT_DURATION,
                                                                                               "Per-rule context selection duration",
                                                                                               CSchematronTelemetry.UNIT_MILLIS);
  private static final ITelemetryHistogram HIST_ASSERT_DURATION = TelemetryMetrics.histogram (CSchematronTelemetry.METRIC_ASSERT_DURATION,
                                                                                              "Per-assert test evaluation duration",
                                                                                              CSchematronTelemetry.UNIT_MILLIS);

  private static double _toMillis (final long nNanos)
  {
    return nNanos / (double) CGlobal.NANOSECONDS_PER_MILLISECOND;
  }

  private final String m_sEngine;
  // Per-failed-assertion / successful-report spans (post-evaluation findings)
  private final boolean m_bPerAssertionResultSpans;
  // Per-rule / per-context / per-assert execution timing
  private final boolean m_bMeasureExecutionTiming;

  // Per-validation state. Reset on every onStart - this handler is not safe to share concurrently
  // (the @NotThreadSafe annotation makes that explicit).
  private StopWatch m_aSW;
  private int m_nFailedAsserts;
  private int m_nFiredReports;
  private TelemetryAttributes m_aEngineAttributes;
  private String m_sCurrentPhase;

  /**
   * @param eEngine
   *        Schematron engine emitting events (e.g. {@code "pure-xpath"}). Becomes the value of the
   *        {@link CSchematronTelemetry#ATTR_ENGINE} attribute on every span and metric.
   * @param bPerAssertionResultSpans
   *        <code>true</code> to emit one <code>SPAN_ASSERTION</code> span per failed-assert /
   *        successful-report (post-evaluation findings).
   * @param bMeasureExecutionTiming
   *        <code>true</code> to record per-rule / per-context / per-assert execution-duration
   *        histograms.
   */
  public TelemetryValidationHandler (@NonNull final ESchematronEngine eEngine,
                                     final boolean bPerAssertionResultSpans,
                                     final boolean bMeasureExecutionTiming)
  {
    ValueEnforcer.notNull (eEngine, "Engine");
    m_sEngine = eEngine.getID ();
    m_bPerAssertionResultSpans = bPerAssertionResultSpans;
    m_bMeasureExecutionTiming = bMeasureExecutionTiming;
  }

  @Override
  public void onStart (@NonNull final PSSchema aSchema,
                       @Nullable final PSPhase aActivePhase,
                       @Nullable final String sBaseURI) throws SchematronValidationException
  {
    m_aSW = StopWatch.createdStarted ();
    m_nFailedAsserts = 0;
    m_nFiredReports = 0;
    m_sCurrentPhase = aActivePhase == null ? null : aActivePhase.getID ();
    m_aEngineAttributes = TelemetryAttributes.builder ().put (CSchematronTelemetry.ATTR_ENGINE, m_sEngine).build ();
  }

  @Override
  public void onPattern (@NonNull final PSPattern aPattern) throws SchematronValidationException
  {
    COUNTER_PATTERNS.add (1, m_aEngineAttributes);
  }

  @Override
  public void onFiredRule (@NonNull final PSRule aRule,
                           @NonNull final String sContext,
                           @Nonnegative final int nNodeIndex,
                           @Nonnegative final int nNodeCount) throws SchematronValidationException
  {
    COUNTER_RULES.add (1, m_aEngineAttributes);
  }

  private void _emitAssertionSpan (@NonNull final PSRule aRule,
                                   @NonNull final PSAssertReport aAR,
                                   @NonNull final String sTestExpression,
                                   final boolean bFailed)
  {
    try (final ITelemetrySpan aSpan = Telemetry.startSpan (CSchematronTelemetry.SPAN_SVRL_ASSERTION,
                                                           ETelemetrySpanKind.INTERNAL))
    {
      aSpan.setAttribute (CSchematronTelemetry.ATTR_ENGINE, m_sEngine);
      if (aAR.getID () != null)
        aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_ID, aAR.getID ());
      aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_TEST, sTestExpression);
      aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_KIND,
                          aAR.isAssert () ? CSchematronTelemetry.ASSERT_KIND_ASSERT
                                          : CSchematronTelemetry.ASSERT_KIND_REPORT);
      aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_FAILED, bFailed);
      if (aRule.getContext () != null)
        aSpan.setAttribute (CSchematronTelemetry.ATTR_RULE_CONTEXT, aRule.getContext ());
      if (aRule.getID () != null)
        aSpan.setAttribute (CSchematronTelemetry.ATTR_RULE_ID, aRule.getID ());
      if (m_sCurrentPhase != null)
        aSpan.setAttribute (CSchematronTelemetry.ATTR_PHASE, m_sCurrentPhase);
    }
  }

  @Override
  @NonNull
  public EContinue onFailedAssert (@NonNull final PSRule aOwningRule,
                                   @NonNull final PSAssertReport aAssertReport,
                                   @NonNull final String sTestExpression,
                                   @NonNull final Node aRuleMatchingNode,
                                   final int nNodeIndex,
                                   @Nullable final Object aContext,
                                   @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    m_nFailedAsserts++;
    COUNTER_FAILED_ASSERTS.add (1, m_aEngineAttributes);
    if (m_bPerAssertionResultSpans)
      _emitAssertionSpan (aOwningRule, aAssertReport, sTestExpression, true);
    return EContinue.CONTINUE;
  }

  @Override
  @NonNull
  public EContinue onSuccessfulReport (@NonNull final PSRule aOwningRule,
                                       @NonNull final PSAssertReport aAssertReport,
                                       @NonNull final String sTestExpression,
                                       @NonNull final Node aRuleMatchingNode,
                                       final int nNodeIndex,
                                       @Nullable final Object aContext,
                                       @Nullable final Exception aEvaluationException) throws SchematronValidationException
  {
    m_nFiredReports++;
    COUNTER_SUCCESSFUL_REPORTS.add (1, m_aEngineAttributes);
    if (m_bPerAssertionResultSpans)
      _emitAssertionSpan (aOwningRule, aAssertReport, sTestExpression, false);
    return EContinue.CONTINUE;
  }

  @Override
  public void onEnd (@NonNull final PSSchema aSchema, @Nullable final PSPhase aActivePhase)
                                                                                            throws SchematronValidationException
  {
    m_aSW.stop ();
    final String sOutcome = (m_nFailedAsserts == 0 && m_nFiredReports == 0) ? CSchematronTelemetry.OUTCOME_VALID
                                                                            : CSchematronTelemetry.OUTCOME_INVALID;
    final TelemetryAttributes aDurAttrs = TelemetryAttributes.builder ()
                                                             .put (CSchematronTelemetry.ATTR_ENGINE, m_sEngine)
                                                             .put (CSchematronTelemetry.ATTR_OUTCOME, sOutcome)
                                                             .build ();
    HIST_DURATION.record (_toMillis (m_aSW.getNanos ()), aDurAttrs);
  }

  @Override
  public boolean isMeasureTiming ()
  {
    // Per-rule and per-context timing - gated by per-rule-execution telemetry
    return m_bMeasureExecutionTiming;
  }

  @Override
  public boolean isMeasureAssertionTiming ()
  {
    // Per-assert timing (once per assert per matching node) - same execution-telemetry gate
    return m_bMeasureExecutionTiming;
  }

  @Override
  public void onContextEvaluated (@NonNull final PSRule aRule,
                                  @Nonnegative final long nDurationNanos,
                                  @Nonnegative final int nMatchCount)
  {
    final var aAttrs = TelemetryAttributes.builder ().put (CSchematronTelemetry.ATTR_ENGINE, m_sEngine);
    if (aRule.getContext () != null)
      aAttrs.put (CSchematronTelemetry.ATTR_RULE_CONTEXT, aRule.getContext ());
    if (aRule.getID () != null)
      aAttrs.put (CSchematronTelemetry.ATTR_RULE_ID, aRule.getID ());
    HIST_CONTEXT_DURATION.record (_toMillis (nDurationNanos), aAttrs.build ());
  }

  @Override
  public void onRuleEvaluated (@NonNull final PSRule aRule, @Nonnegative final long nDurationNanos)
  {
    final var aAttrs = TelemetryAttributes.builder ().put (CSchematronTelemetry.ATTR_ENGINE, m_sEngine);
    if (aRule.getContext () != null)
      aAttrs.put (CSchematronTelemetry.ATTR_RULE_CONTEXT, aRule.getContext ());
    if (aRule.getID () != null)
      aAttrs.put (CSchematronTelemetry.ATTR_RULE_ID, aRule.getID ());
    if (m_sCurrentPhase != null)
      aAttrs.put (CSchematronTelemetry.ATTR_PHASE, m_sCurrentPhase);
    RuleDurationTemplateTelemetry.HIST_RULE_DURATION.record (_toMillis (nDurationNanos), aAttrs.build ());
  }

  @Override
  public void onTestEvaluated (@NonNull final PSRule aRule,
                               @NonNull final PSAssertReport aAssertReport,
                               @NonNull final String sTestExpression,
                               @Nonnegative final long nDurationNanos,
                               final boolean bTestResult)
  {
    final var aAttrs = TelemetryAttributes.builder ()
                                          .put (CSchematronTelemetry.ATTR_ENGINE, m_sEngine)
                                          .put (CSchematronTelemetry.ATTR_ASSERT_TEST, sTestExpression)
                                          .put (CSchematronTelemetry.ATTR_ASSERT_KIND,
                                                aAssertReport.isAssert () ? CSchematronTelemetry.ASSERT_KIND_ASSERT
                                                                          : CSchematronTelemetry.ASSERT_KIND_REPORT);
    if (aRule.getContext () != null)
      aAttrs.put (CSchematronTelemetry.ATTR_RULE_CONTEXT, aRule.getContext ());
    if (aAssertReport.getID () != null)
      aAttrs.put (CSchematronTelemetry.ATTR_ASSERT_ID, aAssertReport.getID ());
    HIST_ASSERT_DURATION.record (_toMillis (nDurationNanos), aAttrs.build ());
  }
}
