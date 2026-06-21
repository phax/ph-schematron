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
package com.helger.schematron.sch;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.function.LongSupplier;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.After;
import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.api.telemetry.CSchematronTelemetry;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.telemetry.ITelemetryCounter;
import com.helger.telemetry.ITelemetryGauge;
import com.helger.telemetry.ITelemetryHistogram;
import com.helger.telemetry.ITelemetryMeterSPI;
import com.helger.telemetry.ITelemetryUpDownCounter;
import com.helger.telemetry.TelemetryMetrics;
import com.helger.xml.serialize.read.DOMReader;

/**
 * End-to-end test that enabling per-assertion telemetry on the ISO-Schematron (XSLT) engine wires
 * the Saxon trace listener and records {@link CSchematronTelemetry#METRIC_RULE_DURATION} entries via
 * the built-in {@code RuleDurationTemplateTelemetry}.
 *
 * @author Philip Helger
 */
public final class SchematronSCHRuleTimingTest
{
  private static final ClassPathResource VALID_SCHEMATRON = new ClassPathResource ("external/test-sch/valid01.sch");
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("external/test-xml/valid01.xml");

  /** Minimal in-memory meter that only captures the rule-duration histogram. */
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
  public void testPerAssertionEmitsRuleDuration () throws Exception
  {
    final CapturingMeter aMeter = new CapturingMeter ();
    TelemetryMetrics.install (aMeter);

    final SchematronResourceSCH aValidator = SchematronResourceSCH.builder (VALID_SCHEMATRON)
                                                                  .telemetry (true)
                                                                  .perAssertionTelemetry (true)
                                                                  .build ();
    final Document aXMLDoc = DOMReader.readXMLDOM (VALID_XMLINSTANCE);
    assertNotNull (aXMLDoc);

    final SchematronOutputType aSVRL = aValidator.applySchematronValidationToSVRL (aXMLDoc, null);
    assertNotNull (aSVRL);

    // Tracing was forced and at least one match template (rule) duration was recorded
    assertTrue ("Expected at least one rule.duration entry, got " + aMeter.m_aRuleDurations.size (),
                aMeter.m_aRuleDurations.size () >= 1);
    aMeter.m_aRuleDurations.forEach (x -> assertTrue (x.doubleValue () >= 0.0));
  }
}
