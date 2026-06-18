# ph-schematron-it

Cross-engine integration tests plus a runnable OpenTelemetry / Grafana telemetry demo. This module
is **not published** to Maven Central — it exists to exercise the library end-to-end.

## What's here

| File | Purpose |
|------|---------|
| `SchematronAllEnginesTelemetryTest` | Asserts that every SCH-consuming engine (pure-xpath, pure-xslt, iso-schematron, schxslt, schxslt2) emits a consistent ph-telemetry surface — one `schematron.validate` span tagged with the engine ID, plus one `schematron.assertion` span per failed assert. Runs in CI; no network needed. |
| `GrafanaDemo` | Runnable `main` that drives all engines with telemetry on and exports **real** spans + metrics over OTLP so you can eyeball dashboards in Grafana before a release. |
| `CapturingTelemetry` | In-memory ph-telemetry SPI used by the test to capture spans. |

## See real data in Grafana

1. Start the all-in-one Grafana + Tempo + Prometheus stack (OTLP receiver on 4317/4318, Grafana on 3000):

   ```sh
   docker run --rm -p 3000:3000 -p 4317:4317 -p 4318:4318 grafana/otel-lgtm
   ```

2. Build the reactor up to this module:

   ```sh
   mvn -pl ph-schematron-it -am install -DskipTests
   ```

3. Run the demo (25 rounds per engine by default; pass a number to change it):

   ```sh
   mvn -pl ph-schematron-it exec:java -Dexec.mainClass=com.helger.schematron.it.GrafanaDemo
   # or, e.g. 200 rounds:
   mvn -pl ph-schematron-it exec:java -Dexec.mainClass=com.helger.schematron.it.GrafanaDemo -Dexec.args=200
   ```

4. Open Grafana at <http://localhost:3000>:
   - **Traces** (Tempo): `schematron.validate` spans, with per-assertion children when that mode is on — `schematron.assertion` for the pure-XPath engine (observed live) and `schematron.svrl.assertion` for the SVRL-based engines (reconstructed from the SVRL output).
   - **Metrics** (Prometheus): `schematron.validate.duration`, `schematron.assertions.failed`, `schematron.reports.fired`, `schematron.rules.fired`, `schematron.patterns.active`.
   - Everything is keyed by the `schematron.engine` attribute, so you can compare engines side by side.

The OTLP/gRPC endpoint defaults to `http://localhost:4317`. Override it with the standard
`OTEL_EXPORTER_OTLP_ENDPOINT` environment variable.

## Notes

- The demo bridges ph-telemetry to OpenTelemetry via `ph-telemetry-otel`, which reads the
  `GlobalOpenTelemetry` instance — so the SDK is built and registered as global *before* any
  telemetry-enabled validation runs. ph-telemetry binds metric instruments eagerly at creation time,
  so installing the bridge late would silently drop metrics.
- The sample Schematron uses `queryBinding="xslt2"` with plain-XPath rules so that the XSLT-based
  engines emit SVRL while the XPath-only pure engine still accepts the expressions.
- Every engine reports its canonical `ESchematronEngine` ID via `schematron.engine`
  (`pure-xpath`, `pure-xslt`, `iso-schematron`, `schxslt`, `schxslt2`).
