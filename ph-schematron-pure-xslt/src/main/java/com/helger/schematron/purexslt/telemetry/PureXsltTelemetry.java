/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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

import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.telemetry.CSchematronTelemetry;
import com.helger.schematron.api.telemetry.SvrlTelemetryEmitter;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Telemetry constants and helpers used by {@code SchematronResourcePureXslt}. The metric /
 * attribute name strings are deliberately identical to those defined on
 * {@code TelemetryValidationHandler} in {@code ph-schematron-pure} so dashboards can aggregate
 * across both engines via the {@link #ATTR_ENGINE} dimension.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public final class PureXsltTelemetry
{
  // === span names (aliased to the shared CSchematronTelemetry vocabulary) ===
  public static final String SPAN_VALIDATE = CSchematronTelemetry.SPAN_VALIDATE;
  public static final String SPAN_PARSE = CSchematronTelemetry.SPAN_PARSE;
  public static final String SPAN_PREPROCESS = CSchematronTelemetry.SPAN_PREPROCESS;
  public static final String SPAN_GENERATE = CSchematronTelemetry.SPAN_GENERATE;
  public static final String SPAN_COMPILE = CSchematronTelemetry.SPAN_COMPILE;
  public static final String SPAN_EXECUTE = CSchematronTelemetry.SPAN_EXECUTE;
  // Per-assertion spans are reconstructed from the SVRL, hence the schematron.svrl.* namespace
  public static final String SPAN_SVRL_ASSERTION = CSchematronTelemetry.SPAN_SVRL_ASSERTION;

  // === metric names ===
  public static final String METRIC_ASSERTIONS_FAILED = CSchematronTelemetry.METRIC_ASSERTIONS_FAILED;
  public static final String METRIC_REPORTS_FIRED = CSchematronTelemetry.METRIC_REPORTS_FIRED;
  public static final String METRIC_RULES_FIRED = CSchematronTelemetry.METRIC_RULES_FIRED;
  public static final String METRIC_PATTERNS_ACTIVE = CSchematronTelemetry.METRIC_PATTERNS_ACTIVE;
  public static final String METRIC_VALIDATE_DURATION = CSchematronTelemetry.METRIC_VALIDATE_DURATION;

  // === attribute keys ===
  public static final String ATTR_ENGINE = CSchematronTelemetry.ATTR_ENGINE;
  public static final String ATTR_PHASE = CSchematronTelemetry.ATTR_PHASE;
  public static final String ATTR_OUTCOME = CSchematronTelemetry.ATTR_OUTCOME;
  public static final String ATTR_ASSERT_TEST = CSchematronTelemetry.ATTR_ASSERT_TEST;
  public static final String ATTR_ASSERT_KIND = CSchematronTelemetry.ATTR_ASSERT_KIND;
  public static final String ATTR_ASSERT_FAILED = CSchematronTelemetry.ATTR_ASSERT_FAILED;
  public static final String ATTR_ASSERT_LOCATION = CSchematronTelemetry.ATTR_ASSERT_LOCATION;
  public static final String ATTR_ASSERT_ID = CSchematronTelemetry.ATTR_ASSERT_ID;
  public static final String ATTR_RULE_CONTEXT = CSchematronTelemetry.ATTR_RULE_CONTEXT;
  public static final String ATTR_PATTERN_ID = CSchematronTelemetry.ATTR_PATTERN_ID;

  /** Engine ID this engine tags telemetry with - the canonical {@link ESchematronEngine#PURE_XSLT} ID. */
  public static final String ENGINE_VALUE = ESchematronEngine.PURE_XSLT.getID ();
  public static final String OUTCOME_VALID = CSchematronTelemetry.OUTCOME_VALID;
  public static final String OUTCOME_INVALID = CSchematronTelemetry.OUTCOME_INVALID;

  private PureXsltTelemetry ()
  {}

  /**
   * Walk the SVRL output and emit the aggregate counters, the duration histogram and (optionally) a
   * {@link #SPAN_SVRL_ASSERTION} span per failed-assert / successful-report. Delegates to the shared
   * {@link SvrlTelemetryEmitter} so the pure-XSLT engine emits exactly the same metric surface
   * (tagged {@link #ATTR_ENGINE}={@link #ENGINE_VALUE}) as the other XSLT-based engines.
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
    SvrlTelemetryEmitter.emitPostHoc (aSVRL, ENGINE_VALUE, bPerAssertionSpans, dDurationMs);
  }
}
