/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.concurrent.TimeUnit;

import org.jspecify.annotations.NonNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;

import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.CSchematronVersion;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.telemetry.ETelemetrySpanKind;
import com.helger.telemetry.Telemetry;
import com.helger.telemetry.TelemetryMetrics;
import com.helger.telemetry.otel.OtelTelemetryMeterSPI;
import com.helger.telemetry.otel.OtelTelemetryTracerSPI;
import com.helger.xml.serialize.read.DOMReader;

import io.opentelemetry.api.common.AttributeKey;
import io.opentelemetry.api.common.Attributes;
import io.opentelemetry.exporter.otlp.metrics.OtlpGrpcMetricExporter;
import io.opentelemetry.exporter.otlp.trace.OtlpGrpcSpanExporter;
import io.opentelemetry.sdk.OpenTelemetrySdk;
import io.opentelemetry.sdk.metrics.SdkMeterProvider;
import io.opentelemetry.sdk.metrics.export.PeriodicMetricReader;
import io.opentelemetry.sdk.resources.Resource;
import io.opentelemetry.sdk.trace.SdkTracerProvider;
import io.opentelemetry.sdk.trace.export.BatchSpanProcessor;

/**
 * Runnable demo that drives every SCH-consuming Schematron engine with ph-telemetry enabled and
 * ships the resulting spans + metrics to an OTLP endpoint - so you can eyeball <b>real</b> data in
 * Grafana before shipping a release.
 * <p>
 * Quick start:
 *
 * <pre>
 * docker run --rm -p 3000:3000 -p 4317:4317 -p 4318:4318 grafana/otel-lgtm
 * mvn -pl ph-schematron-it -am install -DskipTests
 * mvn -pl ph-schematron-it exec:java -Dexec.mainClass=com.helger.schematron.it.GrafanaDemo
 * </pre>
 *
 * Then open Grafana at <code>http://localhost:3000</code> - traces land in Tempo, metrics in
 * Prometheus, both keyed by the <code>schematron.engine</code> attribute. The OTLP/gRPC endpoint
 * defaults to <code>http://localhost:4317</code> and can be overridden via the
 * <code>OTEL_EXPORTER_OTLP_ENDPOINT</code> environment variable. The number of rounds per engine
 * can be passed as the first argument (default 25).
 *
 * @author Philip Helger
 */
public final class MainOtelDemo
{
  private static final Logger LOGGER = LoggerFactory.getLogger (MainOtelDemo.class);

  private static final String DEFAULT_ENDPOINT = "http://localhost:4317";
  private static final String SERVICE_NAME = "ph-schematron-it";
  private static final String INSTRUMENTATION_SCOPE = "com.helger.schematron";
  private static final String INSTRUMENTATION_VERSION = CSchematronVersion.BUILD_VERSION;

  // queryBinding=xslt2 so every engine (including the SchXslt XSLT2/3 ones) emits SVRL; the rules
  // use plain XPath only, so the XPath-only pure engine handles them too.
  private static final String SCH = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                    "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                                    "  <iso:pattern>\n" +
                                    "    <iso:rule context='/root'>\n" +
                                    "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                    "      <iso:assert test='count(item) >= 2'>at least two items expected</iso:assert>\n" +
                                    "      <iso:report test='count(item) > 5'>more than five items present</iso:report>\n" +
                                    "    </iso:rule>\n" +
                                    "  </iso:pattern>\n" +
                                    "</iso:schema>";

  private static final String XML_VALID = "<?xml version='1.0' encoding='UTF-8'?><root><item/><item/><item/></root>";
  private static final String XML_INVALID = "<?xml version='1.0' encoding='UTF-8'?><root/>";

  // The ph-telemetry-otel SPIs have protected constructors - subclass to provide the scope
  private static final class SchematronOtelTracer extends OtelTelemetryTracerSPI
  {
    SchematronOtelTracer ()
    {
      super (INSTRUMENTATION_SCOPE, INSTRUMENTATION_VERSION);
    }
  }

  private static final class SchematronOtelMeter extends OtelTelemetryMeterSPI
  {
    SchematronOtelMeter ()
    {
      super (INSTRUMENTATION_SCOPE, INSTRUMENTATION_VERSION);
    }
  }

  @FunctionalInterface
  private interface IEngineBuilder
  {
    @NonNull
    ISchematronResource build (@NonNull IReadableResource aResource);
  }

  private MainOtelDemo ()
  {}

  @NonNull
  private static OpenTelemetrySdk _buildAndRegisterSdk (@NonNull final String sEndpoint)
  {
    final Resource aResource = Resource.getDefault ()
                                       .merge (Resource.create (Attributes.of (AttributeKey.stringKey ("service.name"),
                                                                               SERVICE_NAME)));

    final OtlpGrpcSpanExporter aSpanExporter = OtlpGrpcSpanExporter.builder ().setEndpoint (sEndpoint).build ();
    final SdkTracerProvider aTracerProvider = SdkTracerProvider.builder ()
                                                               .addSpanProcessor (BatchSpanProcessor.builder (aSpanExporter)
                                                                                                    .build ())
                                                               .setResource (aResource)
                                                               .build ();

    final OtlpGrpcMetricExporter aMetricExporter = OtlpGrpcMetricExporter.builder ().setEndpoint (sEndpoint).build ();
    final SdkMeterProvider aMeterProvider = SdkMeterProvider.builder ()
                                                            .registerMetricReader (PeriodicMetricReader.builder (aMetricExporter)
                                                                                                       .setInterval (Duration.ofSeconds (2))
                                                                                                       .build ())
                                                            .setResource (aResource)
                                                            .build ();

    return OpenTelemetrySdk.builder ()
                           .setTracerProvider (aTracerProvider)
                           .setMeterProvider (aMeterProvider)
                           .buildAndRegisterGlobal ();
  }

  @NonNull
  private static ICommonsOrderedMap <String, ISchematronResource> _buildEngines (@NonNull final byte [] aSch)
  {
    // Demo: emit everything - per-finding spans AND per-rule execution timing. The XSLT-based
    // engines force Saxon tracing for the rule timing (slower, fine for a demo). The pure-XSLT
    // engine has no per-rule execution timing, so it only gets the per-finding spans.
    final ICommonsMap <ESchematronEngine, IEngineBuilder> aBuilders = new CommonsLinkedHashMap <> ();
    aBuilders.put (ESchematronEngine.PURE_XPATH,
                   r -> SchematronResourcePureXPath.builder (r)
                                                   .telemetry (true)
                                                   .perAssertionResultTelemetry (true)
                                                   .perRuleExecutionTelemetry (true)
                                                   .build ());
    aBuilders.put (ESchematronEngine.PURE_XSLT,
                   r -> SchematronResourcePureXslt.builder (r)
                                                  .telemetry (true)
                                                  .perAssertionResultTelemetry (true)
                                                  .build ());
    aBuilders.put (ESchematronEngine.ISO_SCHEMATRON,
                   r -> SchematronResourceSCH.builder (r)
                                             .telemetry (true)
                                             .perAssertionResultTelemetry (true)
                                             .perRuleExecutionTelemetry (true)
                                             .build ());
    aBuilders.put (ESchematronEngine.SCHXSLT1,
                   r -> SchematronResourceSchXslt_XSLT2.builder (r)
                                                       .telemetry (true)
                                                       .perAssertionResultTelemetry (true)
                                                       .perRuleExecutionTelemetry (true)
                                                       .build ());
    aBuilders.put (ESchematronEngine.SCHXSLT2,
                   r -> SchematronResourceSchXslt2.builder (r)
                                                  .telemetry (true)
                                                  .perAssertionResultTelemetry (true)
                                                  .perRuleExecutionTelemetry (true)
                                                  .build ());

    // Convert
    final ICommonsOrderedMap <String, ISchematronResource> ret = new CommonsLinkedHashMap <> ();
    for (final var e : aBuilders.entrySet ())
      ret.put (e.getKey ().getID (), e.getValue ().build (new ReadableResourceByteArray (aSch)));
    return ret;
  }

  public static void main (final String [] aArgs) throws Exception
  {
    final String sEnvEndpoint = System.getenv ("OTEL_EXPORTER_OTLP_ENDPOINT");
    final String sEndpoint = StringHelper.isNotEmpty (sEnvEndpoint) ? sEnvEndpoint : DEFAULT_ENDPOINT;
    final int nRounds = aArgs.length > 0 ? Integer.parseInt (aArgs[0]) : 25;

    LOGGER.info ("Exporting Schematron telemetry to OTLP endpoint '" + sEndpoint + "' (" + nRounds + " rounds/engine)");

    // 1. Stand up the OTel SDK and register it as the global - the ph-telemetry-otel SPIs read it
    try (final OpenTelemetrySdk aSdk = _buildAndRegisterSdk (sEndpoint))
    {
      // 2. Bridge ph-telemetry to OTel. Must happen BEFORE the first telemetry-enabled validation,
      // because ph-telemetry binds each metric instrument to the meter installed at
      // instrument-creation
      // time (which is class-load time for the engines' static counters / histograms).
      Telemetry.install (new SchematronOtelTracer ());
      TelemetryMetrics.install (new SchematronOtelMeter ());

      try
      {
        final byte [] aSch = SCH.getBytes (StandardCharsets.UTF_8);
        final Node aValid = DOMReader.readXMLDOM (XML_VALID);
        final Node aInvalid = DOMReader.readXMLDOM (XML_INVALID);

        final var aEngines = _buildEngines (aSch);

        for (int i = 0; i < nRounds; i++)
        {
          // Mix valid and invalid instances so the dashboards show both outcomes
          final Node aXML = (i % 3) == 0 ? aInvalid : aValid;
          final int nRound = i;
          for (final var aEngine : aEngines.entrySet ())
          {
            Telemetry.withSpanVoidThrowing ("ph-schemtron-it", ETelemetrySpanKind.INTERNAL, aSpan -> {
              aSpan.setAttribute ("round", nRound).setAttribute ("engine", aEngine.getKey ());
              aEngine.getValue ().applySchematronValidationToSVRL (aXML, null);
              aSpan.setStatusOk ();
            });
          }
        }

        LOGGER.info ("Emitted telemetry for " +
                     (nRounds * aEngines.size ()) +
                     " validations across " +
                     aEngines.size () +
                     " engines");
      }
      finally
      {
        // 3. Flush everything out before the JVM exits, then shut the SDK down
        aSdk.getSdkTracerProvider ().forceFlush ().join (10, TimeUnit.SECONDS);
        aSdk.getSdkMeterProvider ().forceFlush ().join (10, TimeUnit.SECONDS);
        LOGGER.info ("Flushed and shut down the OpenTelemetry SDK - check Grafana at http://localhost:3000");
      }
    }
  }
}
