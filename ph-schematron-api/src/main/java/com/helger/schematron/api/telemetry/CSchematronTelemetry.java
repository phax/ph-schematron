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

import com.helger.annotation.concurrent.Immutable;

/**
 * Shared constant names for the ph-telemetry surface emitted by all Schematron engines. Centralised
 * here so that the pure-Java engine ({@code TelemetryValidationHandler}), the XSLT-based engines
 * (via {@link SvrlTelemetryEmitter}) and the {@code SchematronResourcePureXslt} engine all use
 * literally the same span / metric / attribute names. That uniformity is what lets a single Grafana
 * dashboard aggregate across every engine via the {@link #ATTR_ENGINE} dimension.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class CSchematronTelemetry
{
  // === span names (OpenTelemetry conventions) ===
  /** Span wrapping a whole validation run. */
  public static final String SPAN_VALIDATE = "schematron.validate";
  /**
   * Optional child span for a single failed-assert / successful-report derived from the SVRL output
   * (post-hoc analysis by the XSLT-based engines). Namespaced under {@code schematron.svrl.}
   * because it is reconstructed from the SVRL rather than observed during live validation.
   */
  public static final String SPAN_SVRL_ASSERTION = "schematron.svrl.assertion";
  /** Optional child span for a single executed XSLT template. */
  public static final String SPAN_TEMPLATE = "schematron.template";
  /** Phase span: reading / parsing the Schematron. */
  public static final String SPAN_PARSE = "schematron.parse";
  /** Phase span: pre-processing (includes / abstract pattern expansion). */
  public static final String SPAN_PREPROCESS = "schematron.preprocess";
  /** Phase span: generating the XSLT stylesheet. */
  public static final String SPAN_GENERATE = "schematron.generate";
  /** Phase span: compiling the XSLT stylesheet. */
  public static final String SPAN_COMPILE = "schematron.compile";
  /** Phase span: executing the validation against the XML instance. */
  public static final String SPAN_EXECUTE = "schematron.execute";

  // === metric instrument names ===
  /** Counter: number of failed assertions. */
  public static final String METRIC_ASSERTIONS_FAILED = "schematron.assertions.failed";
  /** Counter: number of fired reports. */
  public static final String METRIC_REPORTS_FIRED = "schematron.reports.fired";
  /** Counter: number of fired rules. */
  public static final String METRIC_RULES_FIRED = "schematron.rules.fired";
  /** Counter: number of active patterns visited. */
  public static final String METRIC_PATTERNS_ACTIVE = "schematron.patterns.active";
  /** Histogram: total validation duration in milliseconds. */
  public static final String METRIC_VALIDATE_DURATION = "schematron.validate.duration";

  // === attribute keys ===
  /** The engine emitting the event, e.g. {@code pure-xpath} or {@code iso-schematron}. */
  public static final String ATTR_ENGINE = "schematron.engine";
  /** The active phase, or absent for all phases. */
  public static final String ATTR_PHASE = "schematron.phase";
  /** The validation outcome - {@link #OUTCOME_VALID} or {@link #OUTCOME_INVALID}. */
  public static final String ATTR_OUTCOME = "schematron.outcome";
  /** The pattern ID. */
  public static final String ATTR_PATTERN_ID = "schematron.pattern.id";
  /** The rule context expression. */
  public static final String ATTR_RULE_CONTEXT = "schematron.rule.context";
  /** The rule ID. */
  public static final String ATTR_RULE_ID = "schematron.rule.id";
  /** The assert / report ID. */
  public static final String ATTR_ASSERT_ID = "schematron.assert.id";
  /** The assert / report test expression. */
  public static final String ATTR_ASSERT_TEST = "schematron.assert.test";
  /** The assert kind - {@link #ASSERT_KIND_ASSERT} or {@link #ASSERT_KIND_REPORT}. */
  public static final String ATTR_ASSERT_KIND = "schematron.assert.kind";
  /** Whether the assert failed (i.e. is a real validation problem). */
  public static final String ATTR_ASSERT_FAILED = "schematron.assert.failed";
  /** The SVRL location of the assert / report. */
  public static final String ATTR_ASSERT_LOCATION = "schematron.assert.location";

  // === attribute values ===
  /** {@link #ATTR_OUTCOME} value for a valid document. */
  public static final String OUTCOME_VALID = "valid";
  /** {@link #ATTR_OUTCOME} value for an invalid document. */
  public static final String OUTCOME_INVALID = "invalid";
  /** {@link #ATTR_ASSERT_KIND} value for an {@code assert}. */
  public static final String ASSERT_KIND_ASSERT = "assert";
  /** {@link #ATTR_ASSERT_KIND} value for a {@code report}. */
  public static final String ASSERT_KIND_REPORT = "report";

  // === metric descriptions and units (used when creating the instruments) ===
  public static final String UNIT_COUNT = "{count}";
  public static final String UNIT_MILLIS = "ms";

  private CSchematronTelemetry ()
  {}
}
