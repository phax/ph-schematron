# Task: extract `ph-schematron-saxon` from `ph-schematron-api`

Status: proposed, 2026-09-28. Nothing implemented yet.

## Why

`ph-schematron-api` declares `net.sf.saxon:Saxon-HE` as a hard compile
dependency. Saxon-HE 12.10 is 5.5 MB and brings `org.xmlresolver:xmlresolver`
(plus its `data` classifier) with it. Every consumer of `ph-schematron-api`
pays that, including consumers that never run a validation.

The visible symptom is one library away. `phive-api` references Schematron in
exactly one file:

```
phive-api/src/main/java/com/helger/phive/api/EValidationType.java:25
    import com.helger.schematron.ESchematronEngine;
```

`ESchematronEngine` is a plain `IHasID<String>` enum with no Saxon code, but
that single import puts Saxon on the classpath of everything that touches a
phive `ValidationResultList` — including a REST client that only deserializes
results. The same applies to `com.helger.schematron.svrl.SVRLResourceError`,
which `PhiveJsonHelper.getAsIError` constructs for every Schematron finding;
it extends `SingleError` and needs only `ph-base` and `ph-diagnostics`, yet it
lives in the Saxon-carrying module.

Measured on a REST-client dependency set: removing Saxon takes the typed phive
model from 13.6 MB to 5.7 MB. Full numbers in
`../phorm-client/docs/lightweight-model-analysis.md`.

## The cut is small — 9 files

Starting from the 7 files that import `net.sf.saxon` and taking the transitive
closure of everything that references them inside `ph-schematron-api`:

| File | Why it moves |
|---|---|
| `saxon/SaxonNamespaceContext.java` | imports Saxon |
| `saxon/SaxonSecureResourceResolver.java` | imports Saxon |
| `saxon/SchematronProcessorFactory.java` | imports Saxon |
| `saxon/SchematronTransformerFactory.java` | imports Saxon |
| `api/telemetry/SaxonTraceListenerInstaller.java` | imports Saxon |
| `api/telemetry/SchematronTraceListener.java` | imports Saxon |
| `api/xslt/SchematronXSLTValidator.java` | imports Saxon |
| `api/xslt/AbstractSchematronXSLTBasedResource.java` | calls `SchematronXSLTValidator.applyValidation` (line 455) |
| `saxon/SaxonDOMSource.java` | no Saxon import, but it belongs to the `saxon` package and is used by `ph-schematron-xslt` |

**45 files stay**, including the complete `svrl/` package (13 files, among them
`SVRLResourceError`, `SVRLHelper`, `SVRLMarshaller`) and `ESchematronEngine` —
i.e. exactly the classes the wider ecosystem actually consumes.

Watch out for one false positive: `api/xslt/SchematronXSLTBaseURL.java` mentions
`AbstractSchematronXSLTBasedResource` only in a javadoc sentence (line 31). It
has no code dependency and **stays**. A plain `grep` will tell you otherwise.

## Does the split cut through telemetry?

No — the two telemetry classes that move are a closed block, and no telemetry
*definition* crosses the module boundary. Checked class by class.

`com.helger.schematron.api.telemetry` holds 7 classes. Cross-references inside
the package:

| Class | Referenced by (same package) | Moves? |
|---|---|---|
| `CSchematronTelemetry` — span/attribute/metric names | `RuleDurationTemplateTelemetry`, `SvrlTelemetryEmitter` | stays |
| `ISchematronTemplateTelemetry` — the callback SPI | `RuleDurationTemplateTelemetry`, `SchematronTemplateInfo`, `SchematronTraceListener` | stays |
| `SchematronTemplateInfo` — plain value object | `ISchematronTemplateTelemetry`, `RuleDurationTemplateTelemetry`, `SchematronTraceListener` | stays |
| `RuleDurationTemplateTelemetry` — histogram impl | — | stays |
| `SvrlTelemetryEmitter` — derives metrics from SVRL | `CSchematronTelemetry` | stays |
| `SchematronTraceListener` | *nothing* | **moves** |
| `SaxonTraceListenerInstaller` | *nothing* | **moves** |

The two movers are **leaves**: nothing in the package — and nothing Saxon-free
anywhere — references them. The dependency arrows point the other way, into the
classes that stay.

They are a Saxon adapter, nothing more:

- `SchematronTraceListener implements net.sf.saxon.lib.TraceListener` holds an
  `ISchematronTemplateTelemetry`, converts Saxon's `Traceable` / `NamedTemplate`
  / `TemplateRule` into a `SchematronTemplateInfo` (`_toInfo`, line 125) and
  calls the four SPI callbacks.
- `SaxonTraceListenerInstaller` is pure Saxon plumbing —
  `install (Transformer, TraceListener)` returning `EChange`. It references no
  telemetry type at all.

The seam already exists and is Saxon-free: `ISchematronTemplateTelemetry`
(`onTransformStart` / `onTemplateEnter` / `onTemplateLeave` / `onTransformEnd`)
plus the `SchematronTemplateInfo` value object. The whole wiring is one line,
in a file that moves anyway:

```
api/xslt/SchematronXSLTValidator.java:168
    if (aTelemetry != null)
      SaxonTraceListenerInstaller.install (aTransformer, new SchematronTraceListener (aTelemetry));
```

`AbstractSchematronXSLTBasedResource` moves too and does use telemetry, but only
as a **consumer** of what stays behind — it defines nothing:

- line 293 — composes `new RuleDurationTemplateTelemetry (...)`
- line 499 — opens a span with `CSchematronTelemetry.SPAN_VALIDATE`
- line 502 — sets `CSchematronTelemetry.ATTR_ENGINE`
- line 521 — calls `SvrlTelemetryEmitter.emitPostHoc (...)`

So every span name, attribute name, metric, histogram implementation and the
SVRL-derived emitter stay in `ph-schematron-api`. `ph-schematron-saxon` declares
`ph-telemetry` because it calls that API, and emits the same spans with the same
names as today.

**Consequence: no telemetry needs to be reduced.** Cutting telemetry detail
would buy nothing here — `ph-telemetry` is not what makes the module heavy
(Saxon-HE is 5.5 MB; `ph-telemetry` is a thin facade that `ph-schematron-api`
keeps either way), and the telemetry surface is already split along the right
line by an interface that predates this task.

## Blast radius — smaller than the reputation of the library suggests

Checked across the whole local workspace:

- **Zero** `.java` files outside `ph-schematron` reference any of the 9 moving
  classes. Every reference is inside the reactor.
- Only two external POMs declare `ph-schematron-api` directly: `meta/deps` and
  `phive/phive-api`.
- Ten external repositories use `com.helger.schematron.svrl` — `phorm`,
  `phive` (`phive-result`, `phive-xml`), `peppol-commons/peppol-mls`,
  `peppol-reporting`, `peppol-ap-support`, `peppol-om`, `peppol-uae`,
  `peppol-practical`, `en16931-tools`, `vefa-validator`. That package **stays**,
  so none of them need a change.

Anyone who calls `SchematronTransformerFactory.setAllowXInclude(...)` (public
API, documented in the wiki) necessarily has an engine module on the classpath —
you cannot validate without one — and the engine modules will depend on the new
module transitively. So they keep compiling too.

A welcome side effect: `ph-schematron-model`, `ph-schematron-validator` and
`ph-schematron-testfiles` use neither Saxon nor any moving class, so after the
split they become Saxon-free as well.

## Target layout

```
ph-schematron-api      Saxon-free. svrl/, ESchematronEngine, the SCH resource
                       interfaces, api/cache, api/xslt/validator, resolve/,
                       the SVRL JAXB build.
                       -> ph-xml, ph-datetime, ph-jaxb, ph-jaxb-adapter,
                          ph-xsds-xml, ph-telemetry

ph-schematron-saxon    The 9 files above.
       (new)           -> ph-schematron-api, Saxon-HE, ph-telemetry, ph-xml
```

Reactor order: `ph-schematron-testfiles`, `ph-schematron-api`,
**`ph-schematron-saxon`**, then the engines.

## Decisions to confirm before starting

1. **Keep the artifact name `ph-schematron-api` for the Saxon-free part.**
   The alternative — leaving Saxon in `ph-schematron-api` and creating a new
   `ph-schematron-core` — would force every one of the ten `svrl` consumers to
   change their POM to gain nothing. Proposed: **keep the name**, so the common
   case needs no change at all.
2. **Version: `10.2.0-SNAPSHOT`** (decided). Classes move between JARs without
   changing a single fully-qualified name, no package changes and nothing in the
   workspace breaks, so the change is additive in practice. Only a direct
   `ph-schematron-api` consumer that uses one of the nine moved classes needs to
   add a dependency — and there is none in the workspace.
3. **`ThirdPartyModuleProvider_ph_schematron`** declares `Saxon HE` as the
   library's third-party module. It should move to `ph-schematron-saxon`, since
   `ph-schematron-api` will no longer ship Saxon. Open: move it as-is, or rename
   it to `ThirdPartyModuleProvider_ph_schematron_saxon` to match the module.

---

## Tasks

### T1 — Create the `ph-schematron-saxon` module

- `ph-schematron-saxon/pom.xml`, parent `com.helger.schematron:ph-schematron-parent-pom`,
  packaging `jar`, `<url>https://github.com/phax/ph-schematron/ph-schematron-saxon</url>`,
  `<inceptionYear>2014</inceptionYear>`, same `<licenses>` / `<organization>` /
  `<developers>` blocks as `ph-schematron-api/pom.xml`.
- Dependencies: `ph-schematron-api`, `net.sf.saxon:Saxon-HE`,
  `com.helger.telemetry:ph-telemetry` (used directly by
  `AbstractSchematronXSLTBasedResource`), `com.helger.commons:ph-xml`.
- Test dependencies: `junit`, `slf4j-simple`, `ph-unittest-support-ext`.
- No JAXB plugin and no javadoc `<sourcepath>` override — the SVRL generation
  stays in `ph-schematron-api` (T4).

### T2 — Register the module

- Add `<module>ph-schematron-saxon</module>` to the root `<modules>`, positioned
  **after** `ph-schematron-api` and **before** `ph-schematron-xslt`.
- Add a `<dependencyManagement>` entry for `ph-schematron-saxon` at
  `${project.version}`, next to the existing module entries.

*Done when* `mvn -q validate` resolves the reactor in the right order.

### T3 — Move the 9 files and their tests

`git mv` the nine main files listed in the table above. No source edits: the
packages (`com.helger.schematron.saxon`, `.api.telemetry`, `.api.xslt`) are
unchanged, so no import in the moved files or in the engine modules changes.

Tests that move with them:

- `saxon/SaxonSecureResourceResolverTest.java`
- `saxon/SchematronProcessorFactoryTest.java`
- `saxon/SchematronTransformerFactoryTest.java`
- `saxon/MainClassCastExceptionError.java`

Tests that stay in `ph-schematron-api`: `CSchematronVersionTest`,
`ESchematronEngineTest`, `SPITest`, `svrl/CSVRLTest`,
`api/telemetry/RuleDurationTemplateTelemetryTest` (verified: no Saxon).

Copy `src/test/resources/simplelogger.properties` into the new module.

### T4 — Trim `ph-schematron-api`

- Remove the `Saxon-HE` dependency, including the "Saxon is required!" comment.
- Keep everything else: `ph-xml`, `ph-datetime`, `ph-jaxb`, `ph-jaxb-adapter`,
  `ph-xsds-xml`, `ph-telemetry`.
- Keep the whole SVRL JAXB build: the `svrl` execution (`binding.xjb`,
  `catalog.txt`, `src/main/resources/external/schemas/svrl.xsd`, the
  `ph-xsds-xml` episode) and the javadoc `<sourcepath>` override that adds
  `${project.build.directory}/generated-sources/svrl`.
- Keep `CSchematronVersion` and `src/main/resources/ph-schematron-version.properties`
  here and **only** here — two filtered `ph-schematron-version.properties` at
  the root of two JARs would collide on the classpath.
- Keep `external/schematron/iso-schematron-2006.sch` and
  `iso-schematron-2016.sch`.

*Done when* `mvn -o dependency:tree -pl ph-schematron-api` shows no `Saxon-HE`
and no `xmlresolver`.

### T5 — Move the third-party module SPI

Per decision 3, move to `ph-schematron-saxon`:

- `config/ThirdPartyModuleProvider_ph_schematron.java`
- `src/main/resources/META-INF/services/com.helger.base.thirdparty.IThirdPartyModuleProviderSPI`

Add an `SPITest` to the new module so the SPI registration keeps being checked.

### T6 — Add the dependency to the six engine modules

Add `ph-schematron-saxon` to:

| Module | Uses |
|---|---|
| `ph-schematron-xslt` | `SchematronTransformerFactory`, `SchematronTraceListener`, `AbstractSchematronXSLTBasedResource`, `SaxonDOMSource` |
| `ph-schematron-isosch` | `SchematronTransformerFactory`, `SchematronTraceListener`, `AbstractSchematronXSLTBasedResource` |
| `ph-schematron-schxslt` | same three |
| `ph-schematron-schxslt2` | same three |
| `ph-schematron-pure-xpath` | `SchematronProcessorFactory` |
| `ph-schematron-pure-xslt` | `SchematronProcessorFactory`, `SchematronTraceListener` |

Each of these already declares `Saxon-HE` directly or gets it transitively;
leave those declarations alone — they use Saxon in their own code.

Do **not** add it to `ph-schematron-model`, `ph-schematron-validator` or
`ph-schematron-testfiles`: they become Saxon-free, which is part of the point.

### T7 — Per-module `src/etc` and packaged resources

`parent-pom` references the license header template by the relative path
`src/etc/license-template.txt`, which resolves per module.

- `ph-schematron-saxon/src/etc/license-template.txt` — copy from `ph-schematron-api`.
- `ph-schematron-saxon/src/etc/javadoc.css` — copy from `ph-schematron-api`.
- `ph-schematron-saxon/src/main/resources/LICENSE` and `NOTICE` — copy, so the
  new JAR carries them too.

### T8 — Verify the saving

```bash
mvn -o dependency:tree -pl ph-schematron-api
mvn -o dependency:tree -pl ph-schematron-model,ph-schematron-validator
```

*Done when* none of those three trees contains `Saxon-HE` or `xmlresolver`, and
a consumer of `ph-httpclient` + `ph-json` + `ph-xml` + `phive-result` resolves
to 35 JARs / 5.7 MB instead of 55 JARs / 13.6 MB (that second number also needs
the `phive-result` change — see "Related work").

### T9 — Full reactor and integration build

`mvn clean install` from the root, including `ph-schematron-it`,
`ph-schematron-benchmarks`, `ph-schematron-maven-plugin` and
`ph-schematron-ant-task`. The `SchematronRemoteAccessTest` in
`ph-schematron-it` exercises every engine through the moved
`SchematronProcessorFactory` / `SchematronTransformerFactory` and is the best
single check that the split did not change behaviour.

### T10 — Wiki: News and noteworthy

Add a `v10.2.0 - work in progress` entry at the top of
`../ph-schematron.wiki/News-and-noteworthy.md`, stating that the Saxon-dependent
classes moved to the new `ph-schematron-saxon` module, that
`ph-schematron-api` is now Saxon-free, and that consumers of an engine module
need no change.

### T11 — Wiki: Migrations

Add a `## v10.1 → v10.2` section to `../ph-schematron.wiki/Migrations.md`,
following the shape already used for the v9.2 → v10.0 restructuring:

- "At a glance" table.
- "New module: `ph-schematron-saxon`" with the list of moved classes.
- "New reactor order".
- Who needs to act: only someone depending on `ph-schematron-api` directly *and*
  using one of the nine classes — they add one dependency. Everyone else, and in
  particular every user of `com.helger.schematron.svrl`, does nothing.

Update `_Sidebar.md` and `Home.md` if the new sections need navigation entries.

### T12 — Downstream check

- `phive` — rebuild; `phive-api` should pick up a Saxon-free
  `ph-schematron-api`. This is the change that makes S1 in the phorm-client
  analysis pay off.
- `meta/deps` — the only other external POM naming `ph-schematron-api`; add
  `ph-schematron-saxon` to the aggregation.
- Spot-check two `svrl` consumers that do *not* declare `ph-schematron-api`
  (e.g. `peppol-reporting`, `phorm`) and confirm they build untouched.

---

## Related work

This is S1 of three independent splits identified in
`../phorm-client/docs/lightweight-model-analysis.md`:

- **S1 (this file)** — `ph-schematron-api` → Saxon-free core + `ph-schematron-saxon`.
  Removes ~5.5 MB and, via `SVRLResourceError`, is the one that unblocks
  deserializing phive results without an engine.
- **S2** — `phive-result` currently depends on `phive-xml` for one branch of
  `PhiveResultHelper.createValidationSource`. Moving that branch into
  `phive-xml` behind the existing `IValidationSourceRestorer` interface drops
  nine JARs. Independent of this task; do it after, in the `phive` repository.
- **S3** — split `ddd` into `ddd-model` and `ddd`. Written up in
  `../ddd/docs/split-ddd-model.md`.

## Out of scope

No behaviour change, no renamed class, no changed package, no touched method
signature. If a diff in this task changes anything other than POMs, file
locations and the two wiki pages, it has gone too far.
