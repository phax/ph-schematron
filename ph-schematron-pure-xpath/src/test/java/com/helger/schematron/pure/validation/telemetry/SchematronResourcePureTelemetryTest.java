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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import com.helger.schematron.api.telemetry.CSchematronTelemetry;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.telemetry.mock.CapturingTelemetry;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Verifies that SchematronResourcePureXPath telemetry emits the expected spans and counters via
 * ph-telemetry, and that per-assertion telemetry produces one
 * {@link CSchematronTelemetry#SPAN_SVRL_ASSERTION} span per evaluated assertion.
 *
 * @author Philip Helger
 */
public final class SchematronResourcePureTelemetryTest
{
  // ph-telemetry binds metric instruments eagerly to the meter installed at class initialization
  // time, so a single instance must be installed before the first test method runs
  private static final CapturingTelemetry TELEMETRY = new CapturingTelemetry ();

  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                           "  <iso:pattern>\n" +
                                           "    <iso:rule context='/root'>\n" +
                                           "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                           "      <iso:assert test='count(item) ge 2'>at least two items expected</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "</iso:schema>";

  private static final String XML = "<?xml version='1.0' encoding='UTF-8'?><root/>";

  @BeforeClass
  public static void beforeClass ()
  {
    TELEMETRY.install ();
  }

  @AfterClass
  public static void afterClass ()
  {
    CapturingTelemetry.uninstall ();
  }

  @Before
  public void before ()
  {
    TELEMETRY.reset ();
  }

  @Test
  public void testAggregateAndExecutionTelemetry () throws Exception
  {
    // telemetry + per-rule execution timing, but NOT per-assertion-result spans
    final SchematronResourcePureXPath aSch = SchematronResourcePureXPath.builderFromString (SCHEMATRON)
                                                                        .telemetry (true)
                                                                        .perRuleExecutionTelemetry (true)
                                                                        .build ();
    final SchematronOutputType aSVRL = aSch.applySchematronValidationToSVRL (DOMReader.readXMLDOM (XML), null);
    assertNotNull (aSVRL);

    // Exactly one schematron.validate root span
    assertEquals (1, TELEMETRY.getSpanCount (CSchematronTelemetry.SPAN_VALIDATE));
    // No per-assertion-result spans since that flag is OFF
    assertEquals (0, TELEMETRY.getSpanCount (CSchematronTelemetry.SPAN_SVRL_ASSERTION));

    // Counters: 2 failed asserts (both fail on empty root), 1 fired rule, 1 active pattern
    assertEquals (2, TELEMETRY.getCounterValue (CSchematronTelemetry.METRIC_ASSERTIONS_FAILED));
    assertEquals (1, TELEMETRY.getCounterValue (CSchematronTelemetry.METRIC_RULES_FIRED));
    assertEquals (1, TELEMETRY.getCounterValue (CSchematronTelemetry.METRIC_PATTERNS_ACTIVE));

    // Duration histogram: one entry on this validation, value >= 0
    assertEquals (1, TELEMETRY.getHistogramValues (CSchematronTelemetry.METRIC_VALIDATE_DURATION).size ());
    assertTrue (TELEMETRY.getHistogramValues (CSchematronTelemetry.METRIC_VALIDATE_DURATION).get (0).doubleValue () >=
                0.0);

    // Per-rule execution timing: one rule -> 1 rule.duration + 1 context.duration; 2 asserts -> 2
    // assert.duration entries
    assertEquals (1, TELEMETRY.getHistogramValues (CSchematronTelemetry.METRIC_RULE_DURATION).size ());
    assertEquals (1, TELEMETRY.getHistogramValues (CSchematronTelemetry.METRIC_CONTEXT_DURATION).size ());
    assertEquals (2, TELEMETRY.getHistogramValues (CSchematronTelemetry.METRIC_ASSERT_DURATION).size ());
  }

  @Test
  public void testPerAssertionResultTelemetryEmitsOneSpanPerAssertion () throws Exception
  {
    final SchematronResourcePureXPath aSch = SchematronResourcePureXPath.builderFromString (SCHEMATRON)
                                                                        .telemetry (true)
                                                                        .perAssertionResultTelemetry (true)
                                                                        .build ();
    aSch.applySchematronValidationToSVRL (DOMReader.readXMLDOM (XML), null);

    // Two failed asserts -> two assertion spans
    assertEquals (2, TELEMETRY.getSpanCount (CSchematronTelemetry.SPAN_SVRL_ASSERTION));

    // Each assertion span must carry kind=assert and failed=true
    TELEMETRY.getSpans ()
             .stream ()
             .filter (x -> CSchematronTelemetry.SPAN_SVRL_ASSERTION.equals (x.getName ()))
             .forEach (x -> {
               assertEquals ("assert", x.getAttributes ().get (CSchematronTelemetry.ATTR_ASSERT_KIND));
               assertEquals (Boolean.TRUE, x.getAttributes ().get (CSchematronTelemetry.ATTR_ASSERT_FAILED));
               assertNotNull (x.getAttributes ().get (CSchematronTelemetry.ATTR_ASSERT_TEST));
             });
  }

  @Test
  public void testTelemetryOffEmitsNothing () throws Exception
  {
    // setTelemetry NOT called -> default off
    final SchematronResourcePureXPath aSch = SchematronResourcePureXPath.builderFromString (SCHEMATRON).build ();
    aSch.applySchematronValidationToSVRL (DOMReader.readXMLDOM (XML), null);

    assertEquals (0, TELEMETRY.getSpans ().size ());
    assertEquals (0, TELEMETRY.getCounterValue (CSchematronTelemetry.METRIC_ASSERTIONS_FAILED));
    assertEquals (0, TELEMETRY.getHistogramValues (CSchematronTelemetry.METRIC_VALIDATE_DURATION).size ());
  }
}
