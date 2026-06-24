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
package com.helger.schematron.it;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.jspecify.annotations.NonNull;
import org.junit.After;
import org.junit.Test;
import org.w3c.dom.Node;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.api.telemetry.CSchematronTelemetry;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.telemetry.Telemetry;
import com.helger.telemetry.TelemetryMetrics;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Verifies that <em>every</em> SCH-consuming Schematron engine emits a consistent ph-telemetry
 * surface: exactly one {@link CSchematronTelemetry#SPAN_VALIDATE} span carrying the engine's ID,
 * and one {@link CSchematronTelemetry#SPAN_SVRL_ASSERTION} span per failed assertion when
 * per-assertion telemetry is enabled.
 * <p>
 * Assertions are span-based on purpose - spans re-resolve the installed tracer on every
 * {@code Telemetry.startSpan} call, so a fresh {@link CapturingTelemetry} per engine captures
 * cleanly (unlike the counters / histograms, which ph-telemetry binds eagerly to the first
 * installed meter).
 *
 * @author Philip Helger
 */
public final class SchematronAllEnginesTelemetryTest
{
  // queryBinding=xslt2 so the SchXslt (XSLT2/3) engines emit SVRL; the tests use plain XPath only,
  // so the XPath-only pure engine handles them too.
  private static final String SCH = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                    "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                                    "  <iso:pattern>\n" +
                                    "    <iso:rule context='/root'>\n" +
                                    "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                    "      <iso:assert test='count(item) >= 2'>at least two items expected</iso:assert>\n" +
                                    "    </iso:rule>\n" +
                                    "  </iso:pattern>\n" +
                                    "</iso:schema>";

  // Empty root - both asserts fail
  private static final String XML_INVALID = "<?xml version='1.0' encoding='UTF-8'?><root/>";

  @FunctionalInterface
  private interface IEngineBuilder
  {
    @NonNull
    ISchematronResource build (@NonNull IReadableResource aResource);
  }

  private static final class Engine
  {
    final String m_sEngineID;
    final IEngineBuilder m_aBuilder;

    Engine (@NonNull final String sEngineID, @NonNull final IEngineBuilder aBuilder)
    {
      m_sEngineID = sEngineID;
      m_aBuilder = aBuilder;
    }
  }

  @NonNull
  private static ICommonsList <Engine> _engines ()
  {
    final ICommonsList <Engine> ret = new CommonsArrayList <> ();
    ret.add (new Engine ("pure-xpath",
                         r -> SchematronResourcePureXPath.builder (r)
                                                         .telemetry (true)
                                                         .perAssertionResultTelemetry (true)
                                                         .build ()));
    ret.add (new Engine ("pure-xslt",
                         r -> SchematronResourcePureXslt.builder (r)
                                                        .telemetry (true)
                                                        .perAssertionResultTelemetry (true)
                                                        .build ()));
    ret.add (new Engine ("iso-schematron",
                         r -> SchematronResourceSCH.builder (r)
                                                   .telemetry (true)
                                                   .perAssertionResultTelemetry (true)
                                                   .build ()));
    ret.add (new Engine ("schxslt",
                         r -> SchematronResourceSchXslt_XSLT2.builder (r)
                                                             .telemetry (true)
                                                             .perAssertionResultTelemetry (true)
                                                             .build ()));
    ret.add (new Engine ("schxslt2",
                         r -> SchematronResourceSchXslt2.builder (r)
                                                        .telemetry (true)
                                                        .perAssertionResultTelemetry (true)
                                                        .build ()));
    return ret;
  }

  @After
  public void uninstall ()
  {
    Telemetry.install (null);
    TelemetryMetrics.install (null);
  }

  @Test
  public void testEveryEngineEmitsConsistentValidateSpan () throws Exception
  {
    final Node aInvalid = DOMReader.readXMLDOM (XML_INVALID);
    assertNotNull (aInvalid);

    for (final Engine aEngine : _engines ())
    {
      // Fresh capture per engine - spans re-resolve the tracer per call so this is clean
      final CapturingTelemetry aCapture = new CapturingTelemetry ();
      Telemetry.install (aCapture);
      TelemetryMetrics.install (aCapture);

      final ISchematronResource aRes = aEngine.m_aBuilder.build (ReadableResourceString.utf8 (SCH));
      assertNotNull ("Engine " + aEngine.m_sEngineID + " produced no resource", aRes);
      assertNotNull ("Engine " + aEngine.m_sEngineID + " produced no SVRL",
                     aRes.applySchematronValidationToSVRL (aInvalid, null));

      // Exactly one root validate span ...
      assertEquals ("Engine " + aEngine.m_sEngineID + " must emit exactly one validate span",
                    1,
                    aCapture.countSpansNamed (CSchematronTelemetry.SPAN_VALIDATE));

      // ... tagged with this engine's ID
      final CapturingTelemetry.CapturedSpan aValidate = aCapture.getFirstSpanNamed (CSchematronTelemetry.SPAN_VALIDATE);
      assertNotNull (aValidate);
      assertEquals (aEngine.m_sEngineID, aValidate.getAttributes ().get (CSchematronTelemetry.ATTR_ENGINE));

      // Two failing asserts -> two per-assertion spans. pure-xpath emits the live
      // schematron.assertion span; the SVRL-based engines emit schematron.svrl.assertion - count
      // both.
      assertEquals ("Engine " + aEngine.m_sEngineID + " must emit one assertion span per failed assert",
                    2,
                    aCapture.countSpansNamed (CSchematronTelemetry.SPAN_SVRL_ASSERTION));
    }
  }
}
