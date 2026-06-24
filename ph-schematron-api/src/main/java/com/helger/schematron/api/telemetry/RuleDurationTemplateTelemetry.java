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

import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.base.CGlobal;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.telemetry.ITelemetryHistogram;
import com.helger.telemetry.TelemetryAttributes;
import com.helger.telemetry.TelemetryMetrics;

/**
 * Built-in {@link ISchematronTemplateTelemetry} that records a
 * {@link CSchematronTelemetry#METRIC_RULE_DURATION} histogram entry for every executed rule
 * template, keyed by the rule context ({@link CSchematronTelemetry#ATTR_RULE_CONTEXT}) and engine.
 * This is the XSLT-engine equivalent of the pure-XPath per-rule timing - the {@code sum} per
 * {@code rule.context} ranks the most expensive rules.
 * <p>
 * It relies on Saxon's per-template trace events, so the XSLT engines must be compiled with
 * {@code COMPILE_WITH_TRACING} (which they do whenever any template telemetry is configured). Named
 * templates and functions (no match pattern) are ignored - only match templates, which correspond
 * to Schematron rules, are recorded. The reported duration is <em>inclusive</em> of nested template
 * calls.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@ThreadSafe
public final class RuleDurationTemplateTelemetry implements ISchematronTemplateTelemetry
{
  public static final ITelemetryHistogram HIST_RULE_DURATION = TelemetryMetrics.histogram (CSchematronTelemetry.METRIC_RULE_DURATION,
                                                                                           "Per-rule evaluation duration",
                                                                                           CSchematronTelemetry.UNIT_MILLIS);

  private final String m_sEngineID;

  /**
   * @param sEngineID
   *        The engine ID to tag the recorded metric with (the value of
   *        {@link CSchematronTelemetry#ATTR_ENGINE}). May not be <code>null</code>.
   */
  public RuleDurationTemplateTelemetry (@NonNull final String sEngineID)
  {
    ValueEnforcer.notNull (sEngineID, "EngineID");
    m_sEngineID = sEngineID;
  }

  @Override
  public void onTemplateLeave (@NonNull final SchematronTemplateInfo aInfo, final long nDurationNanos)
  {
    // Only match templates (= Schematron rules) carry a match pattern; skip named templates
    final String sMatchPattern = aInfo.getMatchPattern ();
    if (StringHelper.isNotEmpty (sMatchPattern))
    {
      final TelemetryAttributes aAttrs = TelemetryAttributes.builder ()
                                                            .put (CSchematronTelemetry.ATTR_ENGINE, m_sEngineID)
                                                            .put (CSchematronTelemetry.ATTR_RULE_CONTEXT, sMatchPattern)
                                                            .build ();
      HIST_RULE_DURATION.record (nDurationNanos / (double) CGlobal.NANOSECONDS_PER_MILLISECOND, aAttrs);
    }
  }
}
