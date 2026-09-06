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
package com.helger.schematron.sch;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.After;
import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.api.telemetry.CSchematronTelemetry;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.telemetry.mock.CapturingTelemetry;
import com.helger.xml.serialize.read.DOMReader;

/**
 * End-to-end test that enabling per-rule execution telemetry on the ISO-Schematron (XSLT) engine
 * wires the Saxon trace listener and records {@link CSchematronTelemetry#METRIC_RULE_DURATION}
 * entries via the built-in {@code RuleDurationTemplateTelemetry}.
 *
 * @author Philip Helger
 */
public final class SchematronSCHRuleTimingTest
{
  private static final ClassPathResource VALID_SCHEMATRON = new ClassPathResource ("external/test-sch/valid01.sch");
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("external/test-xml/valid01.xml");

  @After
  public void uninstall ()
  {
    CapturingTelemetry.uninstall ();
  }

  @Test
  public void testPerRuleExecutionEmitsRuleDuration () throws Exception
  {
    final CapturingTelemetry aCapture = new CapturingTelemetry ();
    aCapture.install ();

    final SchematronResourceSCH aValidator = SchematronResourceSCH.builder (VALID_SCHEMATRON)
                                                                  .telemetry (true)
                                                                  .perRuleExecutionTelemetry (true)
                                                                  .build ();
    final Document aXMLDoc = DOMReader.readXMLDOM (VALID_XMLINSTANCE);
    assertNotNull (aXMLDoc);

    final SchematronOutputType aSVRL = aValidator.applySchematronValidationToSVRL (aXMLDoc, null);
    assertNotNull (aSVRL);

    // Tracing was forced and at least one match template (rule) duration was recorded
    final ICommonsList <Double> aRuleDurations = aCapture.getHistogramValues (CSchematronTelemetry.METRIC_RULE_DURATION);
    assertTrue ("Expected at least one rule.duration entry, got " + aRuleDurations.size (),
                aRuleDurations.size () >= 1);
    aRuleDurations.forEach (x -> assertTrue (x.doubleValue () >= 0.0));
  }
}
