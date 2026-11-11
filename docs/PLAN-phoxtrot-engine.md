# Plan: ph-schematron 11 with a choice of XSLT processor (Saxon or phoxtrot)

Draft, 2026-11-08, updated 2026-11-09 for phoxtrot suggestions S9 to S16 and S18, and 2026-11-10 for the release.
Rewritten 2026-11-10 for the decisions on version 11 (branch `phoxtrot`), updated 2026-11-11 for phoxtrot
0.2.0-SNAPSHOT (S27 and S29 done).

phoxtrot (the XPath/XSLT engine formerly named ph-xslt) 0.1.0 is released (2026-11-10, tag
`phoxtrot-parent-pom-0.1.0`), as `com.helger.phoxtrot:phoxtrot-xslt` (with `phoxtrot-xpath` and `phoxtrot-xdm`). It
contains the suggestions S9 to S16, S18 to S24 and items 1, 2 and 4 of S25. The classes named below
are in the packages `com.helger.phoxtrot.xslt` (`XsltCompiler`, `XsltExecutable`, ...), `com.helger.phoxtrot.xpath`
(`XPathException`, `context.IResourceResolver`, ...) and `com.helger.phoxtrot.xdm` (`IXdmNode`, `XdmParser`,
`XdmTreeBuilder`, `bridge.DomToXdm`, ...).

## Goal

ph-schematron 11.0.0 separates two things that are one today: the **pipeline** (how SCH becomes XSLT) and the
**XSLT processor** (what runs the XSLT). The JAXP-based pipelines run on Saxon or on phoxtrot:

| Pipeline (`ESchematronEngine`) | Saxon | phoxtrot |
|---|---|---|
| `ISO_SCHEMATRON` (`ph-schematron-isosch`) | yes | yes |
| `SCHXSLT1` (`ph-schematron-schxslt`) | yes | yes |
| `SCHXSLT2` (`ph-schematron-schxslt2`) | yes | yes |
| `XSLT_PREBUILT` (`ph-schematron-xslt`) | yes | yes |
| `PURE_XSLT` (`ph-schematron-pure-xslt`) | yes | no (s9api; postponed, see D12) |
| `PURE_XPATH` (`ph-schematron-pure` + binding) | `ph-schematron-pure-xpath-saxon` | `ph-schematron-pure-xpath-phoxtrot` (new) |

- The JAXP pipeline modules do not depend on any processor. The user adds `ph-schematron-saxon` or
  `ph-schematron-phoxtrot`.
- The pure engine is split into a processor-free core and one XPath binding per processor (D13).
- With phoxtrot, no Saxon is on the class path.
- The SVRL on phoxtrot must be identical to the SVRL on Saxon for all test files of this project, per pipeline.
- Builder, cache, error listener, URI resolver, parameters, telemetry, Maven plugin and Ant task work with both
  processors.
- The benchmarks compare both processors per pipeline.

## Decisions

| # | Decision | Result |
|---|---|---|
| D1 | Java baseline | **Java 21 for all modules** of ph-schematron 11 (phoxtrot requires 21; confirmed 2026-11-11): `java.version` 21 in the root POM, the enforcer requires JDK 21. No `jdk21` profile, no "unavailable on JDK 17" path, CI matrix 21 and 25, snapshot deploy from the Java 21 job |
| D2 | ISO XSLT files without Saxon | **No separate module** (decided 2026-11-10): `ph-schematron-isosch` itself becomes Saxon-free, the files stay where they are |
| D3 | Engine identity | **Two dimensions**: `ESchematronEngine` stays the pipeline; the XSLT processor is a separate setting |
| D4 | Module and package | `ph-schematron-phoxtrot`, package `com.helger.schematron.phoxtrot`: the processor binding, symmetric to `ph-schematron-saxon` |
| D5 | `document()`/`doc()` at validation time | **Same as Saxon** (corrected 2026-11-11): the JAXP pipelines do not use `SaxonSecureResourceResolver` (that is the s9api path of the pure engines). They rely on secure processing on the factory (`XMLFactory.defaultCustomizeTransformerFactory`) and resolve through `DefaultTransformURIResolver`; the behaviour is pinned by `SchematronSecureProcessingTest` (remote `document()` gives an empty document, remote `xsl:include` fails, local include works, `xsl:result-document` rejected, `system-property ()` empty, an explicit resolver may allow `http`). phoxtrot must pass the same test (P2) |
| D6 | Step limit | **Unlimited** by default (`UNLIMITED_STEPS`), a limit as option |
| D7 | Processor lookup | `ServiceLoader` SPI in `ph-schematron-api`, implemented by both processor modules |
| D8 | Architecture | Saxon-free base classes with a processor interface (see below) |
| D9 | Threading on phoxtrot | **`THREAD_POOL`** by default, with an option to change it |
| D10 | Processor dependency of the pipeline modules | **None**: users add a processor module explicitly (breaking, documented in `Migrations.md`) |
| D11 | Processor selection | Explicit setting wins. Without one: the only processor on the class path. **Two processors and none set: error**; none: error naming both modules. The same rule selects the XPath binding of the pure engine |
| D12 | `pure-xslt` | **Unchanged** (decided 2026-11-10): name, s9api and the direct dependency on `ph-schematron-saxon` stay. Running it on phoxtrot is postponed; phoxtrot may first need an API for custom loading. The generator is already Saxon-free, which keeps the option open |
| D13 | `pure-xpath` | **Split** (decided 2026-11-10) into the processor-free core `ph-schematron-pure` and the binding `ph-schematron-pure-xpath-saxon`; a new binding `ph-schematron-pure-xpath-phoxtrot` on the native phoxtrot-xpath API is **part of v11** |
| D14 | Saxon version for v11 | **Saxon-HE 13.1** (decided 2026-11-11; Maven Central, 15 October 2026), from 12.10. 13.1 class files are Java 17, and all 54 Saxon classes imported by ph-schematron exist in it. Saxonica's Java download page still called Saxon 12 "the most stable and reliable release" on 2026-11-11; to be checked again before the v11 release |

## Facts the plan rests on

ph-schematron (10.3.2-SNAPSHOT):

- Every JAXP pipeline module (`isosch`, `schxslt`, `schxslt2`, `xslt`) depends on `ph-schematron-saxon`, but touches
  Saxon only through `SchematronTransformerFactory` (`getDefault ()` for the conversion steps,
  `createTransformerFactory (...)` for the final compile, with tracing for telemetry) and the Javadoc of
  `transformerFactoryCustomizer`.
- `AbstractSchematronXSLTBasedResource` and `SchematronXSLTValidator` live in `ph-schematron-saxon` (package
  `com.helger.schematron.api.xslt`) and use Saxon in three places: `SaxonDOMSource` for internally parsed input, the
  Saxon tree built once per validation (`TransformerImpl`), and `SaxonTraceListenerInstaller` for the per-rule
  telemetry. `SerializedXSLTDocument` (same package) is Saxon-free.
- `ISchematronXSLTBasedProvider`, `ISchematronResource`, `AbstractSchematronResource`, `AbstractSchematronCache`,
  `SVRLMarshaller` and `SvrlTelemetryEmitter` are in `ph-schematron-api`, which has no Saxon dependency.
- `SchematronTransformerFactory` holds global Saxon state (default factory, customizer, XInclude flag).
- `SaxonSecureResourceResolver` (Saxon `ResourceResolver`, installed only by `SchematronProcessorFactory`, i.e. the
  s9api path of the pure engines): relative URIs and local schemes allowed, remote network schemes
  (`XMLResourceSchemeHelper.getAllRemoteNetworkSchemes ()`) blocked unless allowed, `jar:` checked against the nested
  URI; a blocked URI throws, because `null` would let Saxon resolve it.
- `SchematronTransformerFactory` (the JAXP path of the XSLT pipelines) applies
  `XMLFactory.defaultCustomizeTransformerFactory` (secure processing), line numbering, XInclude off by default, and
  `COMPILE_WITH_TRACING` on request.
- `pure-xslt`: the generator (`PureXsltStylesheetGenerator`, `SchematronToXsltConverter`, `EPureXsltVersion`,
  `PureXsltQueryBindingTransform`) has no Saxon import; `SchematronResourcePureXslt`, its config and cache use s9api
  (compile, `applyTemplates` into a `DOMDestination`, `XdmNode` input, resolver and error wrappers).
- `pure-xpath` (directory `ph-schematron-pure-xpath`, artifact `ph-schematron-pure`), 38 classes:
  - Saxon-free (about 20): `SchematronResourcePure`, `SchematronResourcePureXPath` (2 Saxon imports, to be checked),
    `SchematronPureXPathConfig`, `SchematronPureXPathCache`, the validation handlers, `AbstractPSBoundSchema`,
    `IPSBoundSchema`, `PSBoundSchemaCacheKey`, `IPSQueryBinding`, `PSQueryBindingRegistry` (query bindings `xslt`,
    `xslt2`, `xslt3`, ...).
  - Saxon-bound (about 18): `PSXPathQueryBinding`, `PSXPathBoundSchema` and the other `bound.xpath` classes,
    `PSXPathVariables`, `PSXPathValidationHandlerSVRL`, and the `xpath` package (`XPathConfig`, `XPathConfigBuilder`
    with s9api `Processor`, `ExtensionFunction`, `XdmValue` in its public API, `XQueryAsXPathFunctionConverter`,
    `XPathFunctionFromUserFunction`, `XPathLetVariableResolver`, `XPathEvaluationContext`, `XPathEvaluationHelper`).
  - `IPSQueryBinding` with `PSQueryBindingRegistry` is the seam for one binding per processor.
- No `module-info.java` in the project, so a package may span the core and a binding JAR.
- Engine switches: `SchematronValidationMojo` and `XSLTMojo` in the Maven plugin, `Schematron` in the Ant task.
  `ph-schematron-validator` uses Jing and Trang only and has no Schematron engine.
- `ph-schematron-it` and `ph-schematron-benchmarks` depend on all pipelines; the benchmarks also on Saxon-HE directly.
- The SchXslt artifacts (`name.dmaus.schxslt:schxslt` 1.10.1, `schxslt2` 1.11.3) contain only XSLT, no classes, and
  bring no transitive dependency (their Saxon-HE entries are build plugin dependencies; checked with
  `dependency:tree -Dverbose`, 2026-11-11). So `ph-schematron-schxslt` and `ph-schematron-schxslt2` become
  processor-free exactly like `ph-schematron-isosch`: one module per pipeline, the processor chosen by the user.

phoxtrot 0.1.0 and 0.2.0-SNAPSHOT:

- XPath 3.1 and XSLT 3.0, about 99.9 % of the applicable XSLT 3.0 test cases. An XSLT 2.0 stylesheet runs as 3.0.
- XSLT 1.0 backwards compatible processing is implemented and claimed by default
  (`XsltCompileOptions.DEFAULT_BACKWARDS_COMPATIBLE_CLAIM`), plus EXSLT - Common (`exsl:node-set`,
  `exsl:object-type`). Relevant for `XSLT_PREBUILT` with XSLT 1.0 files.
- It requires Java 21. 0.1.0 uses ph-commons 12.5.2, 0.2.0-SNAPSHOT uses ph-commons 12.6.0.
- **JAXP adapter** `com.helger.phoxtrot.xslt.jaxp.PhoxtrotTransformerFactory`:
  - `Templates` (`PhoxtrotTemplates`, thread-safe, `getExecutable ()` gives the native `XsltExecutable`) and
    `Transformer` (`PhoxtrotTransformer`, one thread at a time).
  - Not registered in `META-INF/services`; it is created directly or by class name.
  - Sources: `StreamSource`, `DOMSource`, `SAXSource`, `XdmSource` (a phoxtrot tree). Results: `StreamResult`,
    `DOMResult`, `SAXResult`.
  - Parameters: `String` (as `xs:untypedAtomic`), numbers, `Boolean`, `URI`, `QName`, DOM nodes, phoxtrot items and
    sequences, arrays and collections.
  - `URIResolver` for `xsl:include`/`xsl:import`, `document()`, `doc()`, `unparsed-text()`. What it does not resolve
    is read directly if `XMLConstants.ACCESS_EXTERNAL_STYLESHEET` allows the scheme (default `all`).
  - Errors: compile errors go to `ErrorListener.fatalError` and are thrown as
    `TransformerConfigurationException`, run errors as `TransformerException` with code, module, line and column.
    `xsl:message` arrives as `ErrorListener.warning` while the transformation runs.
  - Factory attributes: `ATTR_LOAD_EXTERNAL_ENTITIES`, `ATTR_SCHEMA_AWARE`, `ATTR_BACKWARDS_COMPATIBLE`,
    `ATTR_MESSAGE_LISTENER`, `ATTR_TRACE_LISTENER`, `ATTR_MAX_STEPS`, `ATTR_THREADING` (S19).
  - Interruption: `PhoxtrotTransformer.transform` stops the run when the calling thread is interrupted, also on a
    worker thread (S20). Compilation (`newTemplates`) has no interrupt hook.
  - Not supported: `SAXTransformerFactory`, StAX, writing secondary results.
- **Resolver of the JAXP adapter:** the gaps found for D5 (no entity resolver for `document()`/`doc()` and
  stylesheet modules, `ACCESS_EXTERNAL_DTD` without effect, nested `jar:` schemes, untested refusing `URIResolver`)
  are phoxtrot suggestion S27, done on phoxtrot `main` after 0.1.0 (2026-11-10, factory attribute
  `ATTR_ENTITY_RESOLVER`, `XdmParser.setAccessExternalDtd`, tests in `JaxpResolverTest`). ph-schematron needs the
  phoxtrot 0.2.0 for it. D5 does not rely on `ACCESS_EXTERNAL_STYLESHEET`: the ph-schematron
  `URIResolver` throws for every blocked URI before phoxtrot reads anything directly.
- **Native XPath API** (`phoxtrot-xpath`, for the pure binding): no JAXP `XPathFactory`.
  `XPathCompiler.compile (String, StaticContext)` gives a `CompiledXPath` with `createDynamicContext ()`,
  `evaluate (DynamicContext)` and `evaluateEffectiveBooleanValue (DynamicContext)`. `StaticContext`: namespaces,
  default element and function namespace, base URI, `FunctionLibrary`, XPath 1.0 compatibility, declared variables,
  collation. `DynamicContext`: `withFocus`, `withVariable`, `withLazyVariable` (fits `sch:let`),
  `setGlobalVariableResolver`, `setResourceResolver`, `setInterrupt`). From 0.2.0 on (phoxtrot suggestion S29, done
  2026-11-11):
  - The public, source compatible API is listed in phoxtrot's README ("XPath API"): `XPathCompiler`, `CompiledXPath`,
    `XPathException`, `EThreading`, `LargeStackRunner`, `StaticContext`, `DynamicContext`, `IResourceResolver`,
    `FunctionLibrary`, `IXPathFunction`, `SeqType`, `ItemType`, `EOccurrence`, the value types, `XPathOperators` and
    the node model of `phoxtrot-xdm`.
  - DOM input: `DomToXdm.convertWithMapping (Node, String)` gives a `DomNodeMapping` with `getDomNode (IXdmNode)` (a
    merged text node maps to the first DOM text node of its run).
  - Extension functions: `FunctionLibrary.register (XdmQName, List <SeqType>, SeqType, IXPathFunction)`, arguments
    converted by the XPath 3.1 function conversion rules; register into `FunctionLibrary.getDefault ().createChild ()`.
  - User functions without Java code: a module with `xsl:function`s (and the keys and global variables they use) is
    compiled with `XsltCompiler`; the expressions are compiled against `XsltExecutable.createStaticContext ()` and
    evaluated with `XsltExecutable.createEvaluation (request).createDynamicContext ()`.
  - Limits: `DynamicContext.setMaxSteps` (unlimited by default), `LargeStackRunner.run (..., EThreading)`.
  - `CompiledXPath.getFreeVariables ()`.
  - Errors: static errors with `XPathException.getExpressionOffset`/`Line`/`Column`; an error in an `xsl:function` is
    an `XsltException` with `getFunctionFrame ()`. Dynamic errors have no position in the expression.
  - Stream input: `XdmDomView` (`com.helger.phoxtrot.xdm.bridge`), a read-only DOM view over an XDM tree (phoxtrot
    S33, done 2026-11-11).
  - Streamability: `XPathStreamabilityAnalyzer` (`com.helger.phoxtrot.xpath`) with `XPathStreamabilityResult`
    (phoxtrot S34, done 2026-11-11).
- **DOM bridge** `com.helger.phoxtrot.xdm.bridge`: `DomToXdm.convertDocument (Node, String)`, `XdmToDom.toDocument
  (IXdmNode)`, `XdmToSax.emit (...)`, without serialising.
- **Listeners** on `XsltTransformRequest` and `PhoxtrotTransformer`:
  - `IXsltMessageListener` for messages while the transformation runs; `XsltException.getCollectedMessages ()`
    gives the messages up to an error.
  - `IXsltTraceListener` with balanced enter and leave calls for template rules and named templates
    (`XsltTraceTemplate`: match pattern, mode, name, priority, module URI, line, column), stylesheet functions and,
    on request, instructions.
- **Limits:** `setMaxSteps` defaults to 20,000,000 steps (XPDY0130 when exceeded);
  `XsltTransformRequest.UNLIMITED_STEPS` turns the limit off. `setMaxDepth` defaults to 10,000.
  `setInterrupt (BooleanSupplier)` ends a run with FOER0000.
- **Threading:** `EThreading` (package `com.helger.phoxtrot.xpath`, `EXsltThreading` in 0.1.0; `NEW_THREAD`, the
  default, `THREAD_POOL`, `CALLING_THREAD`); in the JAXP adapter
  `ATTR_THREADING` on the factory and `PhoxtrotTransformer.setThreading` per transformer.
  - `NEW_THREAD` and `THREAD_POOL` run on threads with a 2 GB stack (`LargeStackRunner.STACK_SIZE`, in
    `com.helger.phoxtrot.xpath` from 0.2.0 on, usable for plain XPath).
    `CALLING_THREAD` uses the stack of the caller, and a `StackOverflowError` becomes XPDY0130.
  - The ISO step `iso_dsdl_include.xsl` needs about 3 MB of stack for the Peppol TSR 1.0.5 rules: on the calling
    thread it fails with the Java default of 1 MB and with 2 MB (measured 2026-11-10).
- **Validation speed** (ISO pipeline, warm, against Saxon-HE 12.10 on the same machine, from the phoxtrot suggestions
  S21 to S25): `CEN-EN16931-UBL` faster than Saxon (10,000 lines 646 against 734 ms), `PEPPOL-EN16931-UBL` 1.4 to 1.5
  times Saxon's time (10,000 lines 1,118 against 767 ms, measured before S24), Peppol TSR and EUSR 1.04 to 1.36 times
  (50,000 entries: 2.5 against 1.9 s and 2.4 against 1.8 s). Compiling the created XSLT is faster than on Saxon.
- **Parser:** `XdmParser` (secure by default) with `setEntityResolver` and `setRecordLocations` (default `false`
  for input documents).
- **Memory:** the phoxtrot tree needs 1.4 to 4.3 times the heap of the Saxon TinyTree, and 32 to 54 % less than
  MicroDOM.

## Architecture

### Processor interface (`ph-schematron-api`)

Naming (decided 2026-11-11): new types and methods use strict camel case for abbreviations (`Xslt`, `Spi`, `Uri`),
`ID` stays upper case; moved or existing types keep their names (`AbstractSchematronXSLTBasedResource`,
`SchematronXSLTValidator`, `ESchematronEngine`).

Proposed names, package `com.helger.schematron.api.xslt.processor`:

| Type | Role |
|---|---|
| `ISchematronXsltProcessor` | One XSLT processor (`IHasID`: `"saxon"`, `"phoxtrot"`): `getDefaultTransformerFactory ()` (shared, for the conversion steps and the untraced final compile), `createTransformerFactory (boolean bEnableTracing)` and a default `createTransformerFactory (ErrorListener, URIResolver, boolean)`, `createSourceForInternalDocument (Document, String sBaseUri)` for internally parsed input, `getEffectiveSource (Source, Transformer)` right before the validation transform, `installTemplateTelemetry (Transformer, ISchematronTemplateTelemetry)` |
| `ISchematronXsltProcessorSpi` | `ServiceLoader` interface (`@IsSPIInterface`, extends `ISchematronXsltProcessor`), one implementation per processor module, like `ISVRLLocationBeautifierSPI` |
| `SchematronXsltProcessorRegistry` | Finds the processors on the class path: `getAllProcessors ()`, `getProcessorOfID (String)`, `getDefaultProcessor ()` (D11; the error texts name the modules to add) |

Implemented in P1 (2026-11-11):

- `ISchematronXSLTBasedProvider.getXsltProcessor ()`: the validator and the resource reach the processor through
  the provider.
- The processor is resolved once, when a config is built (explicit setting, else the registry default); its ID is
  part of the cache key. The resources keep the explicit setting only (`getXsltProcessor ()` may be `null`).
- The conversion stylesheets of the ISO and SchXslt pipelines are cached per processor ID
  (`cacheXSLTTemplates (ISchematronXsltProcessor)`; the no-argument variant uses the default processor).
- `SchematronProviderXSLTPrebuild` has a constructor with the processor; the existing ones use the default.
- No Saxon-free resource access helper: with the D5 correction the JAXP path does not need one. P2 adds it only if
  `SchematronSecureProcessingTest` requires it on phoxtrot.


### Moves in `ph-schematron-api` and `ph-schematron-saxon`

- `AbstractSchematronXSLTBasedResource`, `SchematronXSLTValidator` and `SerializedXSLTDocument` move to
  `ph-schematron-api`, same package `com.helger.schematron.api.xslt`. The three Saxon places go through
  `ISchematronXsltProcessor`.
- `ph-schematron-saxon` keeps `SchematronTransformerFactory`, `SaxonDOMSource`, `SaxonTinyTreeHelper`,
  `SchematronProcessorFactory`, the trace listener classes and `SaxonSecureResourceResolver`, and adds `SaxonXsltProcessor` with exactly today's behaviour (TinyTree built
  once per validation, trace listener and `COMPILE_WITH_TRACING` only with telemetry).
- Gate: all tests of all existing modules pass on Saxon, unchanged except for the added processor dependency.

### Pipeline modules

- `isosch`, `schxslt`, `schxslt2`, `xslt` depend on `ph-schematron-api` only (plus their XSLT resources).
  `ph-schematron-saxon` becomes a test dependency.
- Their providers ask the processor for the factories instead of `SchematronTransformerFactory`.
- Their configs and builders get `xsltProcessor (ISchematronXsltProcessor)` (or by ID); the processor ID is part of
  the cache key.
- `transformerFactoryCustomizer` stays `Consumer <TransformerFactory>`; the Javadoc names both factory classes.

### `ph-schematron-phoxtrot`

Depends on `ph-schematron-api` and `com.helger.phoxtrot:phoxtrot-xslt` 0.2.0-SNAPSHOT, not on Saxon.

| Class | Role |
|---|---|
| `PhoxtrotXsltProcessor` | `ISchematronXsltProcessorSpi` (ID `phoxtrot`): factories from `PhoxtrotTransformerFactories`; internal documents become an `XdmSource` (`DomToXdm.convertDocument`); other sources are passed on unchanged (phoxtrot converts them itself); telemetry via `PhoxtrotTransformer.setTraceListener` |
| `META-INF/services/...ISchematronXsltProcessorSpi` | `ServiceLoader` registration of `PhoxtrotXsltProcessor` |
| `PhoxtrotTemplateTelemetry` | `IXsltTraceListener` → `ISchematronTemplateTelemetry`: template rules and named templates become `SchematronTemplateInfo` (name, match pattern, mode, module URI, line); the duration from enter to leave; functions and instructions are not forwarded, as with the Saxon listener |
| `PhoxtrotTransformerFactories` | Like `SchematronTransformerFactory`: shared default factory and new factories with `XMLFactory.defaultCustomizeTransformerFactory` (secure processing), `ATTR_MAX_STEPS` (D6, default `UNLIMITED_STEPS`) and `ATTR_THREADING` (D9, default `THREAD_POOL`); `setMaxSteps`/`setThreading` apply to factories created afterwards |

Details:

- **Conversion steps:** the pipelines exchange intermediate results as W3C DOM today. On phoxtrot, keeping the
  intermediate trees as `XdmSource` avoids two conversions per step. First version: DOM as today (correctness), the
  native trees as an optimisation measured by `BenchmarkPhoxtrotCompile`.
- **Interruption:** the pipelines check `Thread.interrupted ()` between the steps; phoxtrot stops a running
  transformation when the calling thread is interrupted (S20). Compilation has no interrupt hook.
- **Telemetry:** phoxtrot needs no tracing at compile time, so the tracing flag of `createTransformerFactory` only
  selects the listener.

### Pure engine: core and XPath bindings (D13)

| Module | Content |
|---|---|
| `ph-schematron-pure` (directory renamed from `ph-schematron-pure-xpath`) | The Saxon-free classes: resource, config, cache, validation handlers, `AbstractPSBoundSchema`, `IPSQueryBinding`, `PSQueryBindingRegistry`. Depends on `ph-schematron-api` and `ph-schematron-model` only |
| `ph-schematron-pure-xpath-saxon` | Today's binding, packages and API unchanged (`XPathConfig` keeps the s9api types) |
| `ph-schematron-pure-xpath-phoxtrot` | New binding on the native phoxtrot-xpath API: bound schema, rule, assert/report and variables on `CompiledXPath` (only the free variables bound), `sch:let` as lazy variables, Java functions through a child `FunctionLibrary`, user functions from an `xsl:function` module (instead of XQuery modules), SVRL handler, evaluation through `LargeStackRunner` with `THREAD_POOL` (D9) and the step limit unlimited (D6); its own config (functions, function module, variables, step limit, threading) |

- The bindings register through `ServiceLoader` with the rules of D11; `PSQueryBindingRegistry` keeps its public
  registration method.
- Input: a DOM is converted with `DomToXdm.convertWithMapping`, and the handlers get the original DOM nodes. A
  stream is parsed with `XdmParser`, and the handlers get nodes of an `XdmDomView`.
- The SVRL of the phoxtrot binding must equal the SVRL of the Saxon binding (test 3).
- Telemetry: the core's `TelemetryValidationHandler` is binding-neutral.

### P2 results (2026-11-11)

Test 2 (`IsoSchematronPhoxtrotVsSaxonComparisonTest`) for the 75 valid Schematron test files:

- 71 created XSLTs are identical after one normalisation: the IDs of patterns instantiated from abstract patterns are
  `concat(generate-id(.), $is-a)` (`iso_abstract_expand.xsl` line 234), and `generate-id()` values are
  implementation-dependent (Saxon `w141aac11…`, phoxtrot `id1…`). Accepted; the SVRL comparator (test 3) must
  normalise the same IDs in `active-pattern/@id`.
- `BIICORE-UBL-T01`, `-T10`, `-T14`, `-T15` take 56 to 96 s each on Saxon (known, skipped in `SchematronSCHCacheTest`)
  and about 1 s on phoxtrot; they are converted on phoxtrot only.
- `EUGEN-UBL-T14`, `-T15` fail on phoxtrot with XPDY0130 (nesting deeper than 10,000; a 23,537 character code list
  expression in the include step). The depth limit cannot be raised through the JAXP adapter: phoxtrot suggestion S35.
  The test expects exactly these two failures until then.

### P3 results (2026-11-11)

- Test 3 (`IsoSchematronSVRLPhoxtrotVsSaxonComparisonTest`): every valid Schematron test file (without the
  `NO_SAXON_REFERENCE` and `KNOWN_PHOXTROT_FAILURES` of P2) against every test XML file, 497 pairs: the SVRL is
  identical (canonical form of `SVRLComparisonHelper`: each child of the root with sorted attributes and its content;
  generated pattern IDs normalised as in P2). No pair raised an error on either processor.
- Test 4: same validity for all invalid Schematron files; `xs:integer('abc')` in an assert fails with FORG0001 on
  both.
- Test 6 (`PhoxtrotSecureProcessingTest`, the assertions of `SchematronSecureProcessingTest` on phoxtrot, with copies
  of its test files): remote `document()` gives an empty document, `system-property()` is empty, remote
  `xsl:include` fails, local include works, an explicit resolver may allow `http`.
  **One difference, open for decision:** Saxon rejects a stylesheet with `xsl:result-document` under secure
  processing; phoxtrot accepts it and never writes secondary results (only `PhoxtrotTransformer.getLastResult ()`),
  so no file is written either way. Decided 2026-11-11: phoxtrot shall reject it like Saxon (phoxtrot suggestion
  S36); until then the test documents the phoxtrot behaviour.
- Input from streams: the resource parses the DOM as before (`getAsNode`, with the entity resolver) and phoxtrot
  converts it once (`createSourceForInternalDocument`). Parsing streams directly with `XdmParser` is an optimisation
  for P5 (benchmarks decide).

## Integration

- `ESchematronEngine`: unchanged constants; Javadoc names the processors per pipeline. New method
  `isProcessorSelectable ()` (or similar) for the four JAXP pipelines and `PURE_XPATH`.
- `ph-schematron-maven-plugin` (`SchematronValidationMojo`, `XSLTMojo`): new parameter `xsltProcessor`
  (`saxon`/`phoxtrot`, default: D11). The plugin itself depends on no processor; the user adds one as plugin
  dependency. Error message if none or two without the parameter. Plugin documentation.
- `ph-schematron-ant-task` (`Schematron`): attribute `xsltProcessor`, same rules.
- `ph-schematron-it`: all JAXP pipelines on both processors (`SchematronAllEnginesTelemetryTest`, `MainOtelDemo`).
- Root `pom.xml`: version 11.0.0-SNAPSHOT, `java.version` 21, Saxon-HE 13.1, phoxtrot 0.2.0-SNAPSHOT in the dependency management, module
  `ph-schematron-phoxtrot`.
- CI: matrix 21 and 25, snapshot deploy from the Java 21 job.
- Documentation:
  - `CLAUDE.md`: modules, Java 21, CI, snapshot deploy JDK.
  - Wiki: `Migrations.md` (10 → 11: add a processor module; moved classes; Java 21; Saxon-HE 13.1), engine overview with the
    pipeline × processor table, a page on the processors (phoxtrot: step limit, memory, threading, D5 policy),
    `Maven-plugin.md`, `ANT-tasks.md`, `_Sidebar.md`, `Home.md`.
  - `News-and-noteworthy.md`: `v11.0.0 - work in progress`.

## Streamability assessment (open, 2026-11-11)

Goal: tell upfront, per rule, whether a Schematron can be validated while streaming:

| Class | Rule context and tests use | Streaming |
|---|---|---|
| Motionless | context node, its attributes, ancestors, literals | one pass, constant memory |
| Burst | only the subtree of the context node | one pass, the matched subtree buffered (memory = largest matched subtree) |
| Non-local | `//` from the root, `preceding`/`following`, keys or `id ()` over the instance, document-wide `sch:let` | two passes (global values first) or the whole tree |

- The rule context must also be matchable on the current node alone (motionless pattern).
- The analysis is the XSLT 3.0 posture and sweep analysis (section 19). phoxtrot has it internally
  (`com.helger.phoxtrot.xpath.stream`); a public facade is phoxtrot suggestion S34.
- **Saxon-HE has no streamability analysis.** The 12.10 JAR contains only `net.sf.saxon.trans.FunctionStreamability`;
  streaming and its analysis are Saxon-EE features. So the assessment cannot be a per-processor engine parameter on
  Saxon-HE. Proposal: the analysis is a property of the schema, not of the processor, and runs on phoxtrot-xpath for
  every engine (a separate analysis module or part of `ph-schematron-pure`), so it works for SCH files regardless of
  the processor used for validation.
- Not decided: scope in v11 (report only, or also a streaming validation mode), API shape (per-rule report object,
  Maven plugin goal), and how the pipelines' `sch:let`/`xsl:function`/`xsl:key` are classified.

## Tests

1. Unit tests per class: processor registry (none, one, two, explicit ID, unknown ID), D5 resource access (local,
   remote blocked, allowed remote, nested `jar:`), phoxtrot input sources (stream with entity resolver, DOM with
   namespaces, base URI, `xml:base`), telemetry bridge (balanced enter and leave, durations, named templates, an
   error inside a template), factory configuration (resolver, step limit, threading), cache keys with the
   processor ID.
2. Pipeline equality per pipeline: the created XSLT of every valid SCH of `ph-schematron-testfiles` on phoxtrot equals
   the one on Saxon after canonical serialisation, or every difference is explained.
3. SVRL equality per pipeline:
   - For all SCH/XML pairs of `ph-schematron-testfiles` and the `external/issues` tests, the SVRL on phoxtrot is
     compared with the SVRL on Saxon.
   - A new SVRL comparator: `PureXsltVsSchXslt2ComparisonTest` only compares counts. It compares, in document
     order, `active-pattern`, `fired-rule`, `failed-assert` and `successful-report` with their IDs, flags, roles,
     locations and texts.
   - It requires 0 differences, except an explicit list of accepted ones with their reason.
4. Error equivalence: both processors give the same `isValidSchematron ()` for the invalid SCH files (corrected
   2026-11-11: these files are invalid for the pure engine; the ISO pipeline accepts 5 of the 8 on both processors);
   XML that raises a dynamic error on Saxon raises one on phoxtrot with the same error code.
5. The existing tests of the four pipeline modules run on both processors (parameterised by processor); the existing
   pure tests run on both XPath bindings.
6. D5 end to end: `SchematronSecureProcessingTest` (`ph-schematron-xslt`) passes on both processors with the same
   outcome.
7. Limits: a large document (e.g. 20,000 `item` elements, as generated in `BenchmarkDomVsTinyTree`) with the default
   step limit; interruption; a deep `and`/`or` chain.

## Benchmarks (`ph-schematron-benchmarks`)

With the Java 21 baseline the phoxtrot benchmarks are ordinary classes; the module depends on both processors.

| Benchmark | Change |
|---|---|
| `BenchmarkSchematronValidity` | `@Param` processor for `sch`, `schXslt`, `schXslt2`, `pureXPath` |
| `BenchmarkIsValidSchematronMulti`, `BenchmarkIsValidSchematron` | `@Param` processor: conversion and compile cost without validation |
| `BenchmarkXsltVsSaxon` | `cold` and `warm` on both processors (rename to fit) |
| new `BenchmarkProcessorSize` | Warm validation, Saxon against phoxtrot, by document size (`@Param` 1,000 / 5,000 / 20,000 items, generated like in `BenchmarkDomVsTinyTree`), input as `IHasInputStream` and as DOM `Node` |
| new `BenchmarkProcessorCompile` | The SCH → XSLT conversion alone for a schema with many abstract patterns and includes, per pipeline and processor; also DOM against native trees between the steps on phoxtrot |
| Memory | All new benchmarks once with `-prof gc`; allocation per operation and the retained heap of a compiled engine |

The README gets the benchmark table, and a results section with date, machine, JDK, phoxtrot and Saxon version (or a
dated file `docs/benchmarks/...md`). The first results are measured before the release.

## Phases

| Phase | Content | Exit criterion |
|---|---|---|
| P0 | Version 11.0.0-SNAPSHOT, Java 21, CI matrix 21/25 and deploy from 21, Saxon-HE 13.1 (D14), phoxtrot 0.2.0-SNAPSHOT in the dependency management, empty `ph-schematron-phoxtrot`, news entry | `mvn install` green on JDK 21 and 25 |
| P1 | Processor interface and registry in `ph-schematron-api`; moves of the base classes; `SaxonXsltProcessor`; pipeline modules on the interface, Saxon as test dependency; plugin, Ant task, IT and benchmarks add `ph-schematron-saxon` | all existing tests green on Saxon |
| P2 | `PhoxtrotXsltProcessor` with D5, D6, D9; ISO pipeline on phoxtrot | tests 1 and 2 (ISO) green — done 2026-11-11, see "P2 results" |
| P3 | Validation on phoxtrot: input sources, telemetry bridge; SVRL comparator | tests 3, 4, 6 green for ISO — done 2026-11-11, see "P3 results" |
| P4 | SchXslt1, SchXslt2, prebuilt XSLT on phoxtrot; tests parameterised by processor; Maven plugin, Ant task, IT | tests 2 to 6 green for all four pipelines; test 7 |
| P4a | Split of the pure engine into `ph-schematron-pure` and `ph-schematron-pure-xpath-saxon`, binding SPI | all existing pure tests green, unchanged |
| P4b | `ph-schematron-pure-xpath-phoxtrot` | tests 3 to 5 green for the pure engine on both bindings |
| P5 | Benchmarks, first results, wiki (`Migrations.md` and the rest), news, `CLAUDE.md` | results recorded, documentation complete |

## Risks

Input for phoxtrot from this plan is recorded in phoxtrot's `docs/SUGGESTIONS.md`: S9 to S20 (all done except S17,
a decision, and one item of S18; S20 without compilation), S21 to S25 from the validation profiles of the Peppol rules
(all done except item 3 of S25), S27 for the resolver of the JAXP adapter (done) and S29 for the pure XPath binding.

- **Breaking change for every user:** the pipeline modules no longer bring Saxon, so an upgrade without adding
  `ph-schematron-saxon` fails at run time. The registry error must name the module, and `Migrations.md` must lead
  with it.
- **Java 21 baseline:** users on Java 17 stay on 10.x. Decide whether 10.x gets maintenance releases.
- **Semantic differences phoxtrot vs. Saxon** (lazy variable evaluation, early exit, error behaviour of rule tests),
  now for four pipelines instead of one: the SVRL equality test (test 3) is the gate. Every difference is either
  fixed in phoxtrot or accepted with a documented reason.
- **SchXslt2 is XSLT 3.0** and has not been run on phoxtrot yet (the measurements so far are ISO only). Which XSLT
  3.0 features it uses is still to be checked; conformance of phoxtrot is about 99.9 %, so failures are possible and
  are found by test 2.
- **Base class refactoring** touches every XSLT engine; `SaxonXsltProcessor` must keep today's behaviour exactly. The
  unchanged existing tests are the gate (P1).
- **phoxtrot XPath binding is new code** (P4b), not an adapter. XQuery function modules
  (`XQueryAsXPathFunctionConverter`) have no phoxtrot counterpart; the phoxtrot binding takes `xsl:function` modules
  instead, a documented difference between the bindings.
- **phoxtrot version:** v11 is developed against phoxtrot 0.2.0-SNAPSHOT (S27, S29, S33, S34) and released only
  after phoxtrot 0.2.0. phoxtrot stays a snapshot until the streamability assessment is resolved. Until it is
  deployed (not in Central snapshots on 2026-11-11), the branch builds only locally against the installed snapshot,
  and its CI fails.
- **Threading and stack:** `THREAD_POOL` (D9) gives the 2 GB stack; `CALLING_THREAD` as option fails on the ISO
  include step for long expressions unless the caller has a large stack. To be documented.
- **Speed:** the Peppol billing rules and large Peppol reports are still slower on phoxtrot (see "Validation
  speed"); the processor is announced with the measured numbers, not as a faster replacement.
- **Memory:** 1.4 to 4.3 times the heap of the TinyTree for the input document; documented on the wiki page.
- **Saxon 13:** the upgrade from 12.10 to 13.1 happens in P0, before the refactoring, so a failure is attributable
  to Saxon and not to P1. Only the presence of the imported classes is checked so far; the Saxon 13 change log
  (s9api, `ResourceResolver`, trace listeners, `DocumentWrapper`/`NodeOverNodeInfo`, XQuery function libraries used by
  `XQueryAsXPathFunctionConverter`) is read before the switch. The phoxtrot speed and memory figures above were
  measured against 12.10 and are measured again against 13.1. If Saxonica still recommends 12 at the v11 release,
  decide whether to release on 13.1 anyway.
- **ph-commons version:** phoxtrot 0.2.0-SNAPSHOT and ph-schematron (since 05b41744 on the branch) both use
  ph-commons 12.6.0.
