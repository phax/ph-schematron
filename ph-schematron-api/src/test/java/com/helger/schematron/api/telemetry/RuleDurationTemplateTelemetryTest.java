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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.function.LongSupplier;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.After;
import org.junit.Test;

import com.helger.telemetry.ITelemetryCounter;
import com.helger.telemetry.ITelemetryGauge;
import com.helger.telemetry.ITelemetryHistogram;
import com.helger.telemetry.ITelemetryMeterSPI;
import com.helger.telemetry.ITelemetryUpDownCounter;
import com.helger.telemetry.TelemetryMetrics;

/**
 * Test for {@link RuleDurationTemplateTelemetry} - it records a
 * {@link CSchematronTelemetry#METRIC_RULE_DURATION} entry for every match template (rule), and skips
 * named templates (functions).
 *
 * @author Philip Helger
 */
public final class RuleDurationTemplateTelemetryTest
{
  /** Minimal in-memory meter that only captures histogram recordings. */
  private static final class CapturingMeter implements ITelemetryMeterSPI
  {
    private final List <Double> m_aRuleDurations = new CopyOnWriteArrayList <> ();

    @Override
    @NonNull
    public ITelemetryHistogram createHistogram (@NonNull final String sName,
                                                @Nullable final String sDescription,
                                                @Nullable final String sUnit)
    {
      if (CSchematronTelemetry.METRIC_RULE_DURATION.equals (sName))
        return (dValue, aAttrs) -> m_aRuleDurations.add (Double.valueOf (dValue));
      return (dValue, aAttrs) -> {};
    }

    @Override
    @NonNull
    public ITelemetryCounter createCounter (@NonNull final String sName,
                                            @Nullable final String sDescription,
                                            @Nullable final String sUnit)
    {
      return (nValue, aAttrs) -> {};
    }

    @Override
    @NonNull
    public ITelemetryUpDownCounter createUpDownCounter (@NonNull final String sName,
                                                        @Nullable final String sDescription,
                                                        @Nullable final String sUnit)
    {
      return (nValue, aAttrs) -> {};
    }

    @Override
    @NonNull
    public ITelemetryGauge createGauge (@NonNull final String sName,
                                        @Nullable final String sDescription,
                                        @Nullable final String sUnit,
                                        @NonNull final LongSupplier aSupplier)
    {
      return () -> {};
    }
  }

  @After
  public void uninstall ()
  {
    TelemetryMetrics.install (null);
  }

  @Test
  public void testRecordsMatchTemplatesOnly ()
  {
    final CapturingMeter aMeter = new CapturingMeter ();
    TelemetryMetrics.install (aMeter);

    final RuleDurationTemplateTelemetry aTelemetry = new RuleDurationTemplateTelemetry ("iso-schematron");

    // A match template (= a rule) with a 2 ms duration -> recorded
    aTelemetry.onTemplateLeave (new SchematronTemplateInfo (null, "root", null, null, -1), 2_000_000L);
    // A named template / function (no match pattern) -> skipped
    aTelemetry.onTemplateLeave (new SchematronTemplateInfo ("{ns}helper", null, null, null, -1), 5_000_000L);

    assertNotNull (aMeter.m_aRuleDurations);
    assertEquals (1, aMeter.m_aRuleDurations.size ());
    // 2_000_000 ns == 2.0 ms
    assertEquals (2.0, aMeter.m_aRuleDurations.get (0).doubleValue (), 0.0001);
  }
}
