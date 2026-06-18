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
package com.helger.schematron.api.telemetry;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
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
 * Derives the aggregate ph-telemetry metrics of a validation run from its SVRL output. Because every
 * XSLT-based Schematron engine produces an SVRL {@link SchematronOutputType}, walking that output is
 * an engine-agnostic way to obtain the same counters (failed asserts, fired reports, fired rules,
 * active patterns) and the same {@link CSchematronTelemetry#METRIC_VALIDATE_DURATION} histogram that
 * the pure-Java engine emits through its validation handler. All events are tagged with
 * {@link CSchematronTelemetry#ATTR_ENGINE} so a single dashboard can aggregate across engines.
 * <p>
 * The instruments are pre-resolved once on class load; emit-time cost is a single SPI call per
 * counter add / histogram record. When no ph-telemetry SPI is installed the underlying no-op
 * instruments make every call essentially free.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class SvrlTelemetryEmitter
{
  private static final ITelemetryCounter COUNTER_FAILED_ASSERTS = TelemetryMetrics.counter (CSchematronTelemetry.METRIC_ASSERTIONS_FAILED,
                                                                                            "Number of failed Schematron assertions",
                                                                                            CSchematronTelemetry.UNIT_COUNT);
  private static final ITelemetryCounter COUNTER_SUCCESSFUL_REPORTS = TelemetryMetrics.counter (CSchematronTelemetry.METRIC_REPORTS_FIRED,
                                                                                                "Number of fired Schematron reports",
                                                                                                CSchematronTelemetry.UNIT_COUNT);
  private static final ITelemetryCounter COUNTER_FIRED_RULES = TelemetryMetrics.counter (CSchematronTelemetry.METRIC_RULES_FIRED,
                                                                                         "Number of fired Schematron rules",
                                                                                         CSchematronTelemetry.UNIT_COUNT);
  private static final ITelemetryCounter COUNTER_PATTERNS = TelemetryMetrics.counter (CSchematronTelemetry.METRIC_PATTERNS_ACTIVE,
                                                                                      "Number of active Schematron patterns visited",
                                                                                      CSchematronTelemetry.UNIT_COUNT);
  private static final ITelemetryHistogram HIST_DURATION = TelemetryMetrics.histogram (CSchematronTelemetry.METRIC_VALIDATE_DURATION,
                                                                                       "Schematron validation duration",
                                                                                       CSchematronTelemetry.UNIT_MILLIS);

  private SvrlTelemetryEmitter ()
  {}

  private static void _emitAssertSpan (@NonNull final String sEngineID,
                                       @Nullable final String sID,
                                       @Nullable final String sTest,
                                       @Nullable final String sLocation,
                                       @Nullable final String sPatternID,
                                       final boolean bFailed)
  {
    try (final ITelemetrySpan aSpan = Telemetry.startSpan (CSchematronTelemetry.SPAN_SVRL_ASSERTION,
                                                           ETelemetrySpanKind.INTERNAL))
    {
      aSpan.setAttribute (CSchematronTelemetry.ATTR_ENGINE, sEngineID);
      aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_KIND,
                          bFailed ? CSchematronTelemetry.ASSERT_KIND_ASSERT : CSchematronTelemetry.ASSERT_KIND_REPORT);
      aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_FAILED, bFailed);
      if (sTest != null)
        aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_TEST, sTest);
      if (sLocation != null)
        aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_LOCATION, sLocation);
      if (sID != null)
        aSpan.setAttribute (CSchematronTelemetry.ATTR_ASSERT_ID, sID);
      if (sPatternID != null)
        aSpan.setAttribute (CSchematronTelemetry.ATTR_PATTERN_ID, sPatternID);
    }
  }

  /**
   * Walk the SVRL output and emit the aggregate counters, the duration histogram and (optionally) a
   * span per failed-assert / successful-report.
   *
   * @param aSVRL
   *        The SVRL output produced by the validation. May not be <code>null</code>.
   * @param sEngineID
   *        The engine ID to tag every event with (the value of
   *        {@link CSchematronTelemetry#ATTR_ENGINE}). May not be <code>null</code>.
   * @param bPerAssertionSpans
   *        Whether to emit one {@link CSchematronTelemetry#SPAN_SVRL_ASSERTION} span per assert /
   *        report.
   *        The spans carry no timing of their own (the transform is one opaque step) but encode the
   *        assert metadata for trace-tree inspection.
   * @param dDurationMs
   *        Wall-clock duration of the entire validation in milliseconds.
   */
  public static void emitPostHoc (@NonNull final SchematronOutputType aSVRL,
                                  @NonNull final String sEngineID,
                                  final boolean bPerAssertionSpans,
                                  final double dDurationMs)
  {
    ValueEnforcer.notNull (aSVRL, "SVRL");
    ValueEnforcer.notNull (sEngineID, "EngineID");

    final TelemetryAttributes aEngineAttrs = TelemetryAttributes.builder ()
                                                                .put (CSchematronTelemetry.ATTR_ENGINE, sEngineID)
                                                                .build ();

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
          COUNTER_FIRED_RULES.add (1, aEngineAttrs);
        }
        else
          if (aObj instanceof final FailedAssert aFA)
          {
            nFailed++;
            COUNTER_FAILED_ASSERTS.add (1, aEngineAttrs);
            if (bPerAssertionSpans)
              _emitAssertSpan (sEngineID, aFA.getId (), aFA.getTest (), aFA.getLocation (), sCurrentPatternID, true);
          }
          else
            if (aObj instanceof final SuccessfulReport aSR)
            {
              nFailed++;
              COUNTER_SUCCESSFUL_REPORTS.add (1, aEngineAttrs);
              if (bPerAssertionSpans)
                _emitAssertSpan (sEngineID, aSR.getId (), aSR.getTest (), aSR.getLocation (), sCurrentPatternID, false);
            }
    }

    final TelemetryAttributes aDurAttrs = TelemetryAttributes.builder ()
                                                             .put (CSchematronTelemetry.ATTR_ENGINE, sEngineID)
                                                             .put (CSchematronTelemetry.ATTR_OUTCOME,
                                                                   nFailed == 0 ? CSchematronTelemetry.OUTCOME_VALID
                                                                                : CSchematronTelemetry.OUTCOME_INVALID)
                                                             .build ();
    HIST_DURATION.record (dDurationMs, aDurAttrs);
  }
}
