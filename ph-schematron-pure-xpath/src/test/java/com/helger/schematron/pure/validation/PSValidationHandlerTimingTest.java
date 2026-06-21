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
package com.helger.schematron.pure.validation;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Verifies that the pure-XPath engine fires the per-rule / per-context / per-assert timing
 * callbacks on {@link IPSValidationHandler}, with the right cardinality and values. Uses a plain
 * recording handler (no ph-telemetry) so the test is deterministic and independent of instrument
 * binding.
 *
 * @author Philip Helger
 */
public final class PSValidationHandlerTimingTest
{
  private static final String SCH = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                    "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                    "  <iso:pattern>\n" +
                                    "    <iso:rule context='/root'>\n" +
                                    "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                    "      <iso:assert test='count(item) ge 2'>at least two items expected</iso:assert>\n" +
                                    "    </iso:rule>\n" +
                                    "  </iso:pattern>\n" +
                                    "</iso:schema>";

  // Empty root - context matches one node, both asserts fail
  private static final String XML = "<?xml version='1.0' encoding='UTF-8'?><root/>";

  private static final class RecordingHandler implements IPSValidationHandler
  {
    private final boolean m_bMeasure;
    private final ICommonsList <Long> m_aRuleNanos = new CommonsArrayList <> ();
    private final ICommonsList <Integer> m_aContextMatchCounts = new CommonsArrayList <> ();
    private final ICommonsList <Long> m_aContextNanos = new CommonsArrayList <> ();
    private final ICommonsList <Boolean> m_aTestResults = new CommonsArrayList <> ();
    private final ICommonsList <Long> m_aTestNanos = new CommonsArrayList <> ();

    RecordingHandler (final boolean bMeasure)
    {
      m_bMeasure = bMeasure;
    }

    @Override
    public boolean isMeasureTiming ()
    {
      return m_bMeasure;
    }

    @Override
    public boolean isMeasureAssertionTiming ()
    {
      return m_bMeasure;
    }

    @Override
    public void onContextEvaluated (@NonNull final PSRule aRule, final long nDurationNanos, final int nMatchCount)
    {
      m_aContextMatchCounts.add (Integer.valueOf (nMatchCount));
      m_aContextNanos.add (Long.valueOf (nDurationNanos));
    }

    @Override
    public void onTestEvaluated (@NonNull final PSRule aRule,
                                 @NonNull final PSAssertReport aAssertReport,
                                 @NonNull final String sTestExpression,
                                 final long nDurationNanos,
                                 final boolean bTestResult)
    {
      m_aTestResults.add (Boolean.valueOf (bTestResult));
      m_aTestNanos.add (Long.valueOf (nDurationNanos));
    }

    @Override
    public void onRuleEvaluated (@NonNull final PSRule aRule, final long nDurationNanos)
    {
      m_aRuleNanos.add (Long.valueOf (nDurationNanos));
    }
  }

  @Test
  public void testTimingCallbacksFire () throws Exception
  {
    final RecordingHandler aHandler = new RecordingHandler (true);
    final SchematronResourcePureXPath aSch = SchematronResourcePureXPath.builderFromString (SCH)
                                                                        .customValidationHandler (aHandler)
                                                                        .build ();
    aSch.applySchematronValidationToSVRL (DOMReader.readXMLDOM (XML), null);

    // Exactly one rule -> one rule-evaluated event
    assertEquals (1, aHandler.m_aRuleNanos.size ());

    // One context evaluation, selecting exactly one /root node
    assertEquals (new CommonsArrayList <> (Integer.valueOf (1)), aHandler.m_aContextMatchCounts);

    // Two asserts evaluated against the single matching node, both failing
    assertEquals (new CommonsArrayList <> (Boolean.FALSE, Boolean.FALSE), aHandler.m_aTestResults);

    // All durations are non-negative
    assertTrue (aHandler.m_aRuleNanos.getFirstOrNull ().longValue () >= 0);
    assertTrue (aHandler.m_aContextNanos.getFirstOrNull ().longValue () >= 0);
    aHandler.m_aTestNanos.forEach (x -> assertTrue (x.longValue () >= 0));
  }

  @Test
  public void testTimingOffByDefault () throws Exception
  {
    // A handler that does NOT opt into timing must receive no timing callbacks
    final RecordingHandler aHandler = new RecordingHandler (false);
    final SchematronResourcePureXPath aSch = SchematronResourcePureXPath.builderFromString (SCH)
                                                                        .customValidationHandler (aHandler)
                                                                        .build ();
    aSch.applySchematronValidationToSVRL (DOMReader.readXMLDOM (XML), null);

    assertEquals (0, aHandler.m_aRuleNanos.size ());
    assertEquals (0, aHandler.m_aContextMatchCounts.size ());
    assertEquals (0, aHandler.m_aTestResults.size ());
  }
}
