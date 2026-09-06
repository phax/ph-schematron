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

import org.junit.After;
import org.junit.Test;

import com.helger.collection.commons.ICommonsList;
import com.helger.telemetry.mock.CapturingTelemetry;

/**
 * Test for {@link RuleDurationTemplateTelemetry} - it records a
 * {@link CSchematronTelemetry#METRIC_RULE_DURATION} entry for every match template (rule), and skips
 * named templates (functions).
 *
 * @author Philip Helger
 */
public final class RuleDurationTemplateTelemetryTest
{
  @After
  public void uninstall ()
  {
    CapturingTelemetry.uninstall ();
  }

  @Test
  public void testRecordsMatchTemplatesOnly ()
  {
    final CapturingTelemetry aCapture = new CapturingTelemetry ();
    aCapture.install ();

    final RuleDurationTemplateTelemetry aTelemetry = new RuleDurationTemplateTelemetry ("iso-schematron");

    // A match template (= a rule) with a 2 ms duration -> recorded
    aTelemetry.onTemplateLeave (new SchematronTemplateInfo (null, "root", null, null, -1), 2_000_000L);
    // A named template / function (no match pattern) -> skipped
    aTelemetry.onTemplateLeave (new SchematronTemplateInfo ("{ns}helper", null, null, null, -1), 5_000_000L);

    final ICommonsList <Double> aRuleDurations = aCapture.getHistogramValues (CSchematronTelemetry.METRIC_RULE_DURATION);
    assertEquals (1, aRuleDurations.size ());
    // 2_000_000 ns == 2.0 ms
    assertEquals (2.0, aRuleDurations.get (0).doubleValue (), 0.0001);
  }
}
