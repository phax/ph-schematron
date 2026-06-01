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
package com.helger.schematron.purexslt.telemetry;

import org.jspecify.annotations.NonNull;

import com.helger.schematron.svrl.jaxb.ActivePattern;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.telemetry.ETelemetrySpanKind;
import com.helger.telemetry.ITelemetryCounter;
import com.helger.telemetry.ITelemetryHistogram;
import com.helger.telemetry.ITelemetrySpan;
import com.helger.telemetry.Telemetry;
import com.helger.telemetry.TelemetryAttributes;
import com.helger.telemetry.TelemetryMetrics;

/**
 * Telemetry constants and helpers used by {@code SchematronResourcePureXslt}. The metric /
 * attribute name strings are deliberately identical to those defined on
 * {@code TelemetryValidationHandler} in {@code ph-schematron-pure} so dashboards can aggregate
 * across both engines via the {@link #ATTR_ENGINE} dimension.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public final class SaxonTelemetry
{
  // === span names ===
  public static final String SPAN_VALIDATE = "schematron.validate";
  public static final String SPAN_PARSE = "schematron.parse";
  public static final String SPAN_PREPROCESS = "schematron.preprocess";
  public static final String SPAN_GENERATE = "schematron.generate";
  public static final String SPAN_COMPILE = "schematron.compile";
  public static final String SPAN_EXECUTE = "schematron.execute";
  public static final String SPAN_ASSERTION = "schematron.assertion";

  // === metric names ===
  public static final String METRIC_ASSERTIONS_FAILED = "schematron.assertions.failed";
  public static final String METRIC_REPORTS_FIRED = "schematron.reports.fired";
  public static final String METRIC_RULES_FIRED = "schematron.rules.fired";
  public static final String METRIC_PATTERNS_ACTIVE = "schematron.patterns.active";
  public static final String METRIC_VALIDATE_DURATION = "schematron.validate.duration";

  // === attribute keys ===
  public static final String ATTR_ENGINE = "schematron.engine";
  public static final String ATTR_PHASE = "schematron.phase";
  public static final String ATTR_OUTCOME = "schematron.outcome";
  public static final String ATTR_ASSERT_TEST = "schematron.assert.test";
  public static final String ATTR_ASSERT_KIND = "schematron.assert.kind";
  public static final String ATTR_ASSERT_FAILED = "schematron.assert.failed";
  public static final String ATTR_ASSERT_LOCATION = "schematron.assert.location";
  public static final String ATTR_ASSERT_ID = "schematron.assert.id";
  public static final String ATTR_RULE_CONTEXT = "schematron.rule.context";
  public static final String ATTR_PATTERN_ID = "schematron.pattern.id";

  public static final String ENGINE_VALUE = "pure-saxon";
  public static final String OUTCOME_VALID = "valid";
  public static final String OUTCOME_INVALID = "invalid";

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

  private SaxonTelemetry ()
  {}

  /**
   * Walk the SVRL output and emit:
   * <ul>
   * <li>aggregate counters (failed asserts, fired reports, fired rules, active patterns) tagged
   * with {@link #ATTR_ENGINE}={@code pure-saxon};</li>
   * <li>a {@link #METRIC_VALIDATE_DURATION} histogram entry with the total wall-clock time and an
   * {@link #ATTR_OUTCOME} attribute derived from whether any failed assertion was present;</li>
   * <li>optionally, one {@link #SPAN_ASSERTION} span per failed-assert / successful-report when
   * {@code bPerAssertionSpans} is on. The spans carry no timing of their own (the Saxon transform
   * is one opaque step) but encode the assert metadata for trace-tree inspection.</li>
   * </ul>
   *
   * @param aSVRL
   *        The SVRL output produced by the validation. May not be <code>null</code>.
   * @param bPerAssertionSpans
   *        Whether to emit a span per assert / report.
   * @param dDurationMs
   *        Wall-clock duration of the entire validation in milliseconds.
   */
  public static void emitPostHoc (@NonNull final SchematronOutputType aSVRL,
                                  final boolean bPerAssertionSpans,
                                  final double dDurationMs)
  {
    final TelemetryAttributes aEngineAttrs = TelemetryAttributes.builder ().put (ATTR_ENGINE, ENGINE_VALUE).build ();

    int nFailed = 0;
    String sCurrentPatternID = null;
    for (final Object aObj : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
    {
      if (aObj instanceof final ActivePattern aAP)
      {
        COUNTER_PATTERNS.add (1, aEngineAttrs);
        sCurrentPatternID = aAP.getId ();
      }
      else
        if (aObj instanceof FiredRule)
        {
          COUNTER_RULES.add (1, aEngineAttrs);
        }
        else
          if (aObj instanceof final FailedAssert aFA)
          {
            nFailed++;
            COUNTER_FAILED.add (1, aEngineAttrs);
            if (bPerAssertionSpans)
              _emitAssertSpan (aFA.getId (), aFA.getTest (), aFA.getLocation (), sCurrentPatternID, true);
          }
          else
            if (aObj instanceof final SuccessfulReport aSR)
            {
              COUNTER_REPORTS.add (1, aEngineAttrs);
              if (bPerAssertionSpans)
                _emitAssertSpan (aSR.getId (), aSR.getTest (), aSR.getLocation (), sCurrentPatternID, false);
            }
    }

    final TelemetryAttributes aDurAttrs = TelemetryAttributes.builder ()
                                                             .put (ATTR_ENGINE, ENGINE_VALUE)
                                                             .put (ATTR_OUTCOME,
                                                                   nFailed == 0 ? OUTCOME_VALID : OUTCOME_INVALID)
                                                             .build ();
    HIST_DURATION.record (dDurationMs, aDurAttrs);
  }

  private static void _emitAssertSpan (final String sID,
                                       final String sTest,
                                       final String sLocation,
                                       final String sPatternID,
                                       final boolean bFailed)
  {
    try (final ITelemetrySpan aSpan = Telemetry.startSpan (SPAN_ASSERTION, ETelemetrySpanKind.INTERNAL))
    {
      aSpan.setAttribute (ATTR_ENGINE, ENGINE_VALUE);
      aSpan.setAttribute (ATTR_ASSERT_KIND, bFailed ? "assert" : "report");
      aSpan.setAttribute (ATTR_ASSERT_FAILED, bFailed);
      if (sTest != null)
        aSpan.setAttribute (ATTR_ASSERT_TEST, sTest);
      if (sLocation != null)
        aSpan.setAttribute (ATTR_ASSERT_LOCATION, sLocation);
      if (sID != null)
        aSpan.setAttribute (ATTR_ASSERT_ID, sID);
      if (sPatternID != null)
        aSpan.setAttribute (ATTR_PATTERN_ID, sPatternID);
    }
  }
}
