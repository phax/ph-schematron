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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.helger.schematron.api.telemetry.CSchematronTelemetry;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.telemetry.Telemetry;
import com.helger.telemetry.TelemetryMetrics;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Verifies that <code>telemetry(boolean)</code> emits the expected phase spans (parse, preprocess,
 * generate, compile, execute) plus post-hoc counters derived from the SVRL output, and that
 * <code>perAssertionResultTelemetry(boolean)</code> produces one <code>SPAN_SVRL_ASSERTION</code>
 * span per assertion fired during the run.
 *
 * @author Philip Helger
 */
// Fixed order so the counter/histogram-asserting test runs first and owns the eager instrument
// binding (ph-telemetry binds instruments to the first installed meter)
@org.junit.FixMethodOrder (org.junit.runners.MethodSorters.NAME_ASCENDING)
public final class SchematronResourcePureXsltTelemetryTest
{
  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                           "  <iso:pattern id='p1'>\n" +
                                           "    <iso:rule context='/root'>\n" +
                                           "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                           "      <iso:assert test='count(item) ge 2'>at least two items expected</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "</iso:schema>";

  private static final String XML = "<?xml version='1.0' encoding='UTF-8'?><root/>";

  private CapturingTelemetry m_aCapture;

  @Before
  public void install ()
  {
    m_aCapture = new CapturingTelemetry ();
    Telemetry.install (m_aCapture);
    TelemetryMetrics.install (m_aCapture);
  }

  @After
  public void uninstall ()
  {
    Telemetry.install (null);
    TelemetryMetrics.install (null);
  }

  @Test
  public void testAggregateTelemetryEmitsPhaseSpansAndCounters () throws Exception
  {
    // setUseCache(false) so the cache does not short-circuit the pipeline; this test exists to
    // verify the per-phase spans fire on a fresh compile.
    final SchematronResourcePureXslt aSch = SchematronResourcePureXslt.builderFromString (SCHEMATRON)
                                                                      .telemetry (true)
                                                                      .useCache (false)
                                                                      .build ();
    final SchematronOutputType aSVRL = aSch.applySchematronValidationToSVRL (DOMReader.readXMLDOM (XML), null);
    assertNotNull (aSVRL);

    // Expect exactly one of each phase span plus one root validate span
    assertEquals (1, m_aCapture.countSpansNamed (CSchematronTelemetry.SPAN_VALIDATE));
    assertEquals (1, m_aCapture.countSpansNamed (CSchematronTelemetry.SPAN_PARSE));
    assertEquals (1, m_aCapture.countSpansNamed (CSchematronTelemetry.SPAN_PREPROCESS));
    assertEquals (1, m_aCapture.countSpansNamed (CSchematronTelemetry.SPAN_GENERATE));
    assertEquals (1, m_aCapture.countSpansNamed (CSchematronTelemetry.SPAN_COMPILE));
    assertEquals (1, m_aCapture.countSpansNamed (CSchematronTelemetry.SPAN_EXECUTE));
    // No per-assertion spans without the second flag
    assertEquals (0, m_aCapture.countSpansNamed (CSchematronTelemetry.SPAN_SVRL_ASSERTION));

    // Post-hoc counters: 2 failed asserts, 1 fired rule, 1 active pattern
    assertEquals (2, m_aCapture.getCounterValue (CSchematronTelemetry.METRIC_ASSERTIONS_FAILED));
    assertEquals (1, m_aCapture.getCounterValue (CSchematronTelemetry.METRIC_RULES_FIRED));
    assertEquals (1, m_aCapture.getCounterValue (CSchematronTelemetry.METRIC_PATTERNS_ACTIVE));

    // Duration histogram entry
    assertEquals (1, m_aCapture.getHistogramValues (CSchematronTelemetry.METRIC_VALIDATE_DURATION).size ());
    assertTrue (m_aCapture.getHistogramValues (CSchematronTelemetry.METRIC_VALIDATE_DURATION).get (0).doubleValue () >=
                0.0);
  }

  @Test
  public void testPerAssertionResultTelemetryEmitsOneSpanPerAssertion () throws Exception
  {
    final SchematronResourcePureXslt aSch = SchematronResourcePureXslt.builderFromString (SCHEMATRON)
                                                                      .telemetry (true)
                                                                      .perAssertionResultTelemetry (true)
                                                                      .build ();
    aSch.applySchematronValidationToSVRL (DOMReader.readXMLDOM (XML), null);
    assertEquals (2, m_aCapture.countSpansNamed (CSchematronTelemetry.SPAN_SVRL_ASSERTION));

    m_aCapture.getSpans ()
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
    final SchematronResourcePureXslt aSch = SchematronResourcePureXslt.builderFromString (SCHEMATRON).build ();
    aSch.applySchematronValidationToSVRL (DOMReader.readXMLDOM (XML), null);

    assertEquals (0, m_aCapture.getSpans ().size ());
    assertEquals (0, m_aCapture.getCounterValue (CSchematronTelemetry.METRIC_ASSERTIONS_FAILED));
    assertEquals (0, m_aCapture.getHistogramValues (CSchematronTelemetry.METRIC_VALIDATE_DURATION).size ());
  }
}
