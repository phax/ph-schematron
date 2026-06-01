/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
import com.helger.base.state.EContinue;
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
 * Implementation of {@link IPSValidationHandler} that emits runtime telemetry &mdash; counters,
 * spans and a duration histogram &mdash; via ph-telemetry. Install on a
 * {@code SchematronResourcePure} by calling {@code setTelemetry(true)} (which composes this with
 * any caller-supplied custom handler).
 * <p>
 * Two granularity modes:
 * <ul>
 * <li><b>Aggregate (default)</b> &mdash; one {@code schematron.validate} span around the whole
 * validation, child counters for fired-rules / failed-asserts / successful-reports /
 * active-patterns, and a {@code schematron.validate.duration} histogram entry on completion.</li>
 * <li><b>Per-assertion</b> &mdash; in addition, an extra {@code schematron.assertion} child span is
 * created and immediately closed for every assert and report evaluation. Useful for diagnostic
 * deep-dives; significant overhead.</li>
 * </ul>
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public final class TelemetryValidationHandler implements IPSValidationHandler
{
  // === metric instrument names (OpenTelemetry conventions) ===
  public static final String SPAN_VALIDATE = "schematron.validate";
  public static final String SPAN_ASSERTION = "schematron.assertion";
  public static final String METRIC_ASSERTIONS_FAILED = "schematron.assertions.failed";
  public static final String METRIC_REPORTS_FIRED = "schematron.reports.fired";
  public static final String METRIC_RULES_FIRED = "schematron.rules.fired";
  public static final String METRIC_PATTERNS_ACTIVE = "schematron.patterns.active";
  public static final String METRIC_VALIDATE_DURATION = "schematron.validate.duration";

  // === attribute keys ===
  public static final String ATTR_ENGINE = "schematron.engine";
  public static final String ATTR_PHASE = "schematron.phase";
  public static final String ATTR_OUTCOME = "schematron.outcome";
  public static final String ATTR_PATTERN_ID = "schematron.pattern.id";
  public static final String ATTR_RULE_CONTEXT = "schematron.rule.context";
  public static final String ATTR_RULE_ID = "schematron.rule.id";
  public static final String ATTR_ASSERT_ID = "schematron.assert.id";
  public static final String ATTR_ASSERT_TEST = "schematron.assert.test";
  public static final String ATTR_ASSERT_KIND = "schematron.assert.kind";
  public static final String ATTR_ASSERT_FAILED = "schematron.assert.failed";

  // Outcome attribute values
  public static final String OUTCOME_VALID = "valid";
  public static final String OUTCOME_INVALID = "invalid";

  // Pre-resolved instruments. Created once on class load; emit-time cost is just a SPI call.
  private static final ITelemetryCounter COUNTER_FAILED = TelemetryMetrics.counter (METRIC_ASSERTIONS_FAILED,
                                                                                    "Number of failed Schematron assertions",
                                                                                    "{count}");
  private static final ITelemetryCounter COUNTER_REPORTS = TelemetryMetrics.counter (METRIC_REPORTS_FIRED,
                                                                                     "Number of fired Schematron reports",
                                                                                     "{count}");
  private static final ITelemetryCounter COUNTER_RULES = TelemetryMetrics.counter (METRIC_RULES_FIRED,
                                                                                   "Number of fired Schematron rules",
                                                                                   "{count}");
  private static final ITelemetryCounter COUNTER_PATTERNS = TelemetryMetrics.counter (METRIC_PATTERNS_ACTIVE,
                                                                                      "Number of active Schematron patterns visited",
                                                                                      "{count}");
  private static final ITelemetryHistogram HIST_DURATION = TelemetryMetrics.histogram (METRIC_VALIDATE_DURATION,
                                                                                       "Schematron validation duration",
                                                                                       "ms");

  private final String m_sEngine;
  private final boolean m_bPerAssertionSpans;

  // Per-validation state. Reset on every onStart - this handler is not safe to share concurrently
  // (the @NotThreadSafe annotation makes that explicit).
  private long m_nStartNanos;
  private int m_nFailedAsserts;
  private int m_nFiredReports;
  private TelemetryAttributes m_aEngineAttributes;
  private String m_sCurrentPhase;

  /**
   * @param sEngine
   *        Short identifier for the engine emitting events (e.g. {@code "pure"} or
   *        {@code "pure-saxon"}). Becomes the value of the {@link #ATTR_ENGINE} attribute on every
   *        span and metric.
   * @param bPerAssertionSpans
   *        <code>true</code> to additionally emit one {@link #SPAN_ASSERTION} span per assert /
   *        report evaluation.
   */
  public TelemetryValidationHandler (@NonNull final String sEngine, final boolean bPerAssertionSpans)
  {
    m_sEngine = sEngine;
    m_bPerAssertionSpans = bPerAssertionSpans;
  }

  @Override
  public void onStart (@NonNull final PSSchema aSchema,
                       @Nullable final PSPhase aActivePhase,
                       @Nullable final String sBaseURI) throws SchematronValidationException
  {
    m_nStartNanos = System.nanoTime ();
    m_nFailedAsserts = 0;
    m_nFiredReports = 0;
    m_sCurrentPhase = aActivePhase == null ? null : aActivePhase.getID ();
    m_aEngineAttributes = TelemetryAttributes.builder ().put (ATTR_ENGINE, m_sEngine).build ();
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
    try (final ITelemetrySpan aSpan = Telemetry.startSpan (SPAN_ASSERTION, ETelemetrySpanKind.INTERNAL))
    {
      aSpan.setAttribute (ATTR_ENGINE, m_sEngine);
      if (aAR.getID () != null)
        aSpan.setAttribute (ATTR_ASSERT_ID, aAR.getID ());
      aSpan.setAttribute (ATTR_ASSERT_TEST, sTestExpression);
      aSpan.setAttribute (ATTR_ASSERT_KIND, aAR.isAssert () ? "assert" : "report");
      aSpan.setAttribute (ATTR_ASSERT_FAILED, bFailed);
      if (aRule.getContext () != null)
        aSpan.setAttribute (ATTR_RULE_CONTEXT, aRule.getContext ());
      if (aRule.getID () != null)
        aSpan.setAttribute (ATTR_RULE_ID, aRule.getID ());
      if (m_sCurrentPhase != null)
        aSpan.setAttribute (ATTR_PHASE, m_sCurrentPhase);
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
    COUNTER_FAILED.add (1, m_aEngineAttributes);
    if (m_bPerAssertionSpans)
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
    COUNTER_REPORTS.add (1, m_aEngineAttributes);
    if (m_bPerAssertionSpans)
      _emitAssertionSpan (aOwningRule, aAssertReport, sTestExpression, false);
    return EContinue.CONTINUE;
  }

  @Override
  public void onEnd (@NonNull final PSSchema aSchema, @Nullable final PSPhase aActivePhase)
                                                                                            throws SchematronValidationException
  {
    final double dDurationMs = (System.nanoTime () - m_nStartNanos) / 1_000_000.0;
    final String sOutcome = (m_nFailedAsserts == 0 && m_nFiredReports == 0) ? OUTCOME_VALID : OUTCOME_INVALID;
    final TelemetryAttributes aDurAttrs = TelemetryAttributes.builder ()
                                                             .put (ATTR_ENGINE, m_sEngine)
                                                             .put (ATTR_OUTCOME, sOutcome)
                                                             .build ();
    HIST_DURATION.record (dDurationMs, aDurAttrs);
  }
}
