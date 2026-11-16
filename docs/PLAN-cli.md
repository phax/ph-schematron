# Plan: command line client (issue #188)

Issue [#188](https://github.com/phax/ph-schematron/issues/188): "Create a commandline client - Based on the Maven
Plugin functionality - eventually provide as a Docker image as well".

## 1. Inventory: what the Maven plugin and the Ant task can do

| Function | Maven goal | Ant task | Notes |
|----------|-----------|----------|-------|
| Validate XML against a Schematron | `validate` (`SchematronValidationMojo`) | `<schematron>` (`Schematron`) | both: all 6 engines, XSLT processor selection |
| Convert SCH to XSLT | `convert` (`Schematron2XSLTMojo`) | - | XSLT based engines only (`iso-schematron`, `schxslt`, `schxslt2`, `pure-xslt`) |
| Preprocess SCH | `preprocess` (`SchematronPreprocessMojo`) | `<schematronpreprocess>` (`SchematronPreprocess`) | the two implementations differ, see 4.3 |
| Streamability report | `streamability` (`SchematronStreamabilityMojo`) | `<schematronstreamability>` (`SchematronStreamability`) | identical semantics |
| Validate the Schematron itself (RNC) | - | - | `SchematronValidator` in `ph-schematron-validator`, not exposed anywhere yet |

### 1.1 Validation options

| Option | Maven | Ant | Applies to engines |
|--------|-------|-----|--------------------|
| Schematron file | `schematronFile` | `schematronFile` | all |
| Engine | `schematronProcessingEngine` (default `iso-schematron`) | `schematronProcessingEngine` | - |
| XSLT processor | `xsltProcessor` | `xsltProcessor` | `isXsltProcessorSelectable ()` |
| Phase | `phaseName` | `phaseName` | all but `xslt` |
| Language code | `languageCode` | `languageCode` | `iso-schematron`, `schxslt`, `schxslt2` |
| Custom XSLT parameters | `parameters` (map) | nested `<parameter name value>` | XSLT pipeline engines + `xslt` |
| Force cache result | `forceCacheResult` | `forceCacheResult` | SCH/SchXslt engines |
| Lenient (deprecated namespaces) | `lenient` | - | `pure-xpath` |
| Positive inputs | `xmlDirectory` + `xmlIncludes`/`xmlExcludes` | nested resource collections (`<fileset>` ...) | - |
| Negative inputs (must fail) | `xmlErrorDirectory` + `xmlErrorIncludes`/`xmlErrorExcludes` | `expectSuccess=false` (whole task) | - |
| SVRL output | `svrlDirectory`, `svrlErrorDirectory` | `svrlDirectory` | - |
| Ignore warnings | `ignoreWarnings` | - | - |
| Fail fast vs. collect | `failFast` | `failOnError` (generic) | - |
| Fail on level | - | `failOnValidationError/Warn/Info` | - |
| Custom error roles (#66) | - | nested `<errorRole role>` | - |
| XML catalog (entity + URI resolver) | - | nested `<xmlcatalog>` | not `pure-xslt` |

### 1.2 Conversion options (Maven only)

`schematronDirectory` + `schematronPattern` (`**/*.sch`), `xsltDirectory`, `xsltExtension` (`.xslt`),
`overwriteWithoutQuestion`, `phaseName`, `languageCode`, `parameters`, `forceCacheResult`, `xsltHeader`, `showProgress`,
`stopOnError`, `schematronEngine` (default `iso-schematron`), `xsltProcessor`. Output post-processing: header comment,
root namespace declarations collected and `svrl` prefix ensured.

### 1.3 Preprocess options

Maven: `sourceFile`, `targetFile`, `overwriteWithoutNotice`, `keepTitles`, `keepDiagnostics`, `keepReports`,
`keepEmptyPatterns`, `schHeader`. Ant: `srcFile`, `dstFile`, the four `keep*` flags.

### 1.4 Streamability options

`schematronFile`, `maximumClass` (`motionless`, `burst`, `non-local`).

## 2. Module

- New module `ph-schematron-cli` (artifact `ph-schematron-cli`), package `com.helger.schematron.cli`, placed in the
  root `pom.xml` after `ph-schematron-validator` and before `ph-schematron-maven-plugin`. Not in
  `ph-schematron-bom`: the BOM is generated from `EProject` in `../meta`, and applications are no BOM members.
- Dependencies: the same set as the Maven plugin (`api`, `saxon`, `model`, `isosch`, `xslt`, `schxslt`, `schxslt2`,
  `pure`, `pure-xslt`, `streamability`), plus `ph-schematron-validator` (if `check` is in scope), `jaxb-impl` (runtime),
  `slf4j-simple` (runtime), `info.picocli:picocli` 4.7.7.
- picocli is the ecosystem precedent (`phlox-cli`, `ph-redact-cli`, `en16931-ubl2cii-cli`): `picocli.version`
  property + `dependencyManagement` entry in the root POM.
- Packaging like `phlox-cli`: `maven-shade-plugin` with `shadedArtifactAttached`, `ServicesResourceTransformer`
  (required - the XSLT processor registry and the query bindings use `ServiceLoader`), signature files dropped,
  `Main-Class` manifest. forbiddenapis skipped for this module (System.out/err), as in `phlox-cli`.
- Both XSLT processors are in the shaded jar (`ph-schematron-saxon` and `ph-schematron-phoxtrot`). If
  `--xslt-processor` is not given, the CLI passes `SaxonXsltProcessor.ID` explicitly, because
  `SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (null)` throws when more than one processor is on the
  class path. The Maven plugin and the Ant task keep their current behaviour (only processor on the class path).

## 3. Command structure

```
ph-schematron [-hV] [-v|-q] <command>
  validate       Validate XML files against a Schematron
  convert        Convert Schematron files to XSLT
  preprocess     Write a preprocessed (resolved) Schematron
  streamability  Report the streamability class of a Schematron
  check          Validate a Schematron file against the ISO RNC schema   (optional, Q5)
```

Top level class `SchematronCli` (`@Command` with `subcommands`, `mixinStandardHelpOptions`, version provider from
the Maven filtered project version), one class per subcommand implementing `Callable <Integer>`. Shared options
(engine, XSLT processor, phase, language, parameters, force cache, catalogs) live in a picocli `@Mixin` class
`SchematronEngineOptions`, used by `validate` and `convert`.

### 3.1 `validate`

```
ph-schematron validate -s rules.sch [options] <file-or-dir>...
  -s, --schematron FILE            required
  -e, --engine ID                  default iso-schematron; IDs and aliases from ESchematronEngine
  -x, --xslt-processor ID          saxon | phoxtrot; default: the only one on the class path
      --phase NAME
      --language CODE
  -P, --param NAME=VALUE           repeatable
      --force-cache-result
      --lenient                    pure-xpath only
      --catalog FILE               repeatable, XML catalog (entity + URI resolver)
      --include GLOB / --exclude GLOB   for directory arguments; default include **/*.xml
      --expect-invalid PATH        repeatable; files/dirs that must produce at least one failed assertion
      --svrl-dir DIR               SVRL per input, relative path + ".svrl" (as Maven/Ant)
      --ignore-warnings
      --error-role ROLE            repeatable; flag/role values treated as ERROR (#66)
      --fail-on error|warning|info default error
      --fail-fast                  stop at the first failing file (default: process all, then exit)
```

Validation flow is the Maven one (`_performValidation`): build the resource by engine, collect Schematron errors,
abort on any `ERROR`, then validate each file, write SVRL, compare against the expectation. Results go to stdout
(one line per file plus the failed assertions as `SVRLResourceError` text), diagnostics/logging to stderr.

### 3.2 `convert`

```
ph-schematron convert [engine options] -o OUT_DIR <sch-file-or-dir>...
      --pattern GLOB          for directory arguments; default **/*.sch
      --show-progress         log "still converting" every 5 seconds (Maven showProgress); off by default
  -o, --out DIR | -           "-" = stdout, only with exactly one input
      --xslt-extension EXT    default .xslt
      --no-overwrite
      --xslt-header TEXT
      --continue-on-error     inverse of Maven stopOnError
```

Engine restricted to `isXSLTBased ()` minus `xslt`. The XSLT build + write code (header comment, namespace collection)
is moved into the shared factory (4.1). The progress logging is only active with `--show-progress`.

### 3.3 `preprocess`

```
ph-schematron preprocess -s in.sch [-o out.sch] [--keep-titles] [--keep-diagnostics]
                         [--keep-reports] [--keep-empty-patterns] [--sch-header TEXT] [--no-overwrite]
```

Stdout when `-o` is missing.

### 3.4 `streamability`

```
ph-schematron streamability [--max-class motionless|burst|non-local] <sch-file>...
```

### 3.5 Exit codes

| Code | Meaning |
|------|---------|
| 0 | success / all expectations met |
| 1 | validation expectation not met, streamability above maximum |
| 2 | usage error (picocli default) |
| 3 | invalid Schematron or technical error (I/O, transformation) |

## 4. Implementation notes

### 4.1 Shared engine construction

Decision: one shared factory, used by the Mojos, the Ant task and the CLI.

- New module `ph-schematron-engine-factory` (add to the BOM), placed after `ph-schematron-pure-xslt`.
  Dependencies: `api`, `isosch`, `xslt`, `schxslt`, `schxslt2`, `pure`, `pure-xslt`; no XSLT processor dependency (like
  the JAXP pipeline modules), so its tests run in the two surefire executions (Saxon only / phoxtrot only).
- Settings object `SchematronEngineSettings` (builder): engine, XSLT processor (resolved instance), phase, language
  code, custom parameters, force cache result, lenient, URI resolver, entity resolver.
- `SchematronEngineFactory.createValidationResource (File, settings)` - all 6 engines; returns the resource plus the
  collected Schematron errors (`IErrorList`), replacing the `switch` in `SchematronValidationMojo` and `Schematron`.
- `SchematronEngineFactory.createXSLT (IReadableResource, settings, ErrorListener)` - the 4 XSLT based engines incl.
  the `schxslt.compile.metadata=false` parameter for SchXslt 1, replacing the `switch` in `Schematron2XSLTMojo`.
- The XSLT post-processing (header comment, root namespace collection, write) becomes a public helper in the same
  module, so `convert` and the Mojo share it.
- Existing drifts are unified by the settings: Maven keeps passing no resolvers, Ant keeps passing the catalog; the
  factory applies `lenient` for `pure-xpath` only, as today. Engine options a given engine ignores are logged at debug
  level, not rejected.
- Order of work: factory + switch Mojo/Ant to it (existing plugin tests must stay green) first, then the CLI.

### 4.2 Catalog support

Ant uses `org.apache.tools.ant.types.XMLCatalog`. The CLI can use the JDK `javax.xml.catalog.CatalogManager.catalogResolver (...)`,
whose `CatalogResolver` is both `EntityResolver` and `URIResolver`. Its behaviour with relative `systemSuffix` /
`rewriteURI` entries and `resolve` features must be verified against the JDK docs
(https://docs.oracle.com/en/java/javase/21/docs/api/java.xml/javax/xml/catalog/package-summary.html) before relying on it.

### 4.3 Preprocess divergence

Verified against `SchematronPreprocessMojo`, `SchematronPreprocess`, `PSPreprocessor`, `PSReader` and `PSWriter`:

| # | Aspect | Maven `preprocess` | Ant `<schematronpreprocess>` |
|---|--------|--------------------|------------------------------|
| 1 | Reading | `new PSReader (res, null, null)` | `new PSReader (res)` - identical (delegates to the same) |
| 2 | Query binding | from the schema (`PSQueryBindingRegistry.getQueryBindingOfNameOrThrow (getQueryBinding ())`) - unknown binding fails | always `PSXPathQueryBinding`, regardless of `queryBinding` |
| 3 | Method | `getForcedPreprocessedSchema` - always rebuilds | `getAsPreprocessedSchema` - returns the schema unchanged if `isPreprocessed ()` (no ID uniquification, keep flags not applied) |
| 4 | Keep empty schema | library default (`true`) | set explicitly to `true` - same effect |
| 5 | Default `keepEmptyPatterns` | `false` (Maven parameter default) | `true` (`PSPreprocessor.DEFAULT_KEEP_EMPTY_PATTERNS`) |
| 6 | Other `keep*` defaults | `false` | `false` (library defaults) - same |
| 7 | `null` result | throws `SchematronPreprocessException` | not checked (cannot happen with keep empty schema `true`) |
| 8 | Writer | `MicroWriter` directly | `PSWriter` (wraps `MicroWriter`) |
| 9 | Version check before writing | no | yes, `PSVersionChecker` via `PSWriter.runVersionCheck` (logs) |
| 10 | Indentation | `INDENT_AND_ALIGN` | `XMLWriterSettings` default |
| 11 | Namespace context | default NS = Schematron, `xsl`, `svrl`, plus every `<ns>` of the schema | none (namespaces as on the micro elements) |
| 12 | Header comment | `schHeader` | - |
| 13 | Existing target, no overwrite | `overwriteWithoutNotice=false` only logs "Skipping" and then **writes anyway** (bug) | no option, always overwrites |
| 14 | Write failure | logs an error, the build continues | logs success only; failure is not detected (`ESuccess` ignored) |
| 15 | Error handling | `MojoExecutionException` | `failOnError` (fail or log) |

Decided shared behaviour (Q4): Maven behaviour for 2, 3, 10, 11, 12; adopt the version
check (9); write failure is an error everywhere (14); fix the overwrite bug (13). Default of `keepEmptyPatterns` (5)
is `false` everywhere - a behaviour change for Ant users (news entry).### 4.4 Global state

The Ant task sets `SVRLHelper.setErrorLevelDeterminator (...)` globally for error roles. Acceptable in a one-shot CLI
process; must be documented if the factory (Q1) is shared.

### 4.5 Docker

`Dockerfile` in the module: `FROM eclipse-temurin:25-jre`, copy the shaded jar,
copy `target/ph-schematron-cli-*-shaded.jar` to the fixed name `/opt/ph-schematron/ph-schematron-cli.jar`, `ENTRYPOINT ["java", "-jar", "/opt/ph-schematron/ph-schematron-cli.jar"]`, `WORKDIR /data` for volume mounts.
Published to Docker Hub as `phelger/schematron`, tags `<version>` and `latest`, platforms `linux/amd64` and
`linux/arm64` (`docker buildx`). Published manually by the maintainer; the wiki documents the `docker buildx build --platform linux/amd64,linux/arm64 --push` command. No CI workflow.

## 5. Tests

JUnit 4, one test class per public class:

- `SchematronCliTest`: help/version, unknown command exit code.
- `ValidateCommandTest`: every engine against `ph-schematron-testfiles` samples (valid and invalid), SVRL written,
  `--expect-invalid`, `--fail-on`, `--error-role`, `--ignore-warnings`, `-P`.
- `ConvertCommandTest`, `PreprocessCommandTest`, `StreamabilityCommandTest`: output files, exit codes.
- Run picocli in-process via `new CommandLine (...).execute (...)` with captured `PrintWriter`s.
- XSLT processor: the module runs the two surefire executions (Saxon only / phoxtrot only) like the pipeline modules,
  if phoxtrot is supported (Q3).

## 6. Documentation

- Wiki: new page `Command-line-client.md` (usage, all options, exit codes, Docker), `_Sidebar.md`, `Home.md`.
- `News-and-noteworthy.md`: v11.0.0 entry "Added the new module `ph-schematron-cli` ... (#188)".
- `CLAUDE.md`: module list (new entries and renumbering).
- Wiki pages of the Maven plugin and Ant task: only if the shared factory changes visible behaviour (preprocess).

## 7. Decisions

| # | Question | Decision |
|---|----------|----------|
| Q1 | Shared engine factory or third copy? | Shared factory (4.1) |
| Q2 | Docker | Dockerfile, Java 25, published to Docker Hub |
| Q3 | phoxtrot in the shaded jar? | Both processors; Saxon when `--xslt-processor` is missing |
| Q4 | Preprocess behaviour | Proposal in 4.3 accepted |
| Q5 | `check` command | Yes |
| Q6 | Progress logging for `convert` | Only with `--show-progress` |
| Q7 | JSON output | Later |
| Q8 | Fail fast | Process all files, `--fail-fast` opt-in |
| Q9 | Factory module name | `ph-schematron-engine-factory` |
| Q10 | Docker Hub | `phelger/schematron`, tags `<version>` + `latest`, `linux/amd64` + `linux/arm64`, pushed manually |
| Q4a | `keepEmptyPatterns` default | `false` everywhere (change for Ant users) |

## 8. Status

Step 1 is implemented: module `ph-schematron-engine-factory` (package `com.helger.schematron.enginefactory`), with the
Maven plugin and the Ant tasks switched to it and aligned. Decisions made while implementing it:

| Topic | Decision |
|-------|----------|
| Which messages decide | Only error and fatal error (former Ant rule) for Maven and Ant; warnings and information only with `failOnValidationWarn` / `failOnValidationInfo` |
| Maven additions | `failOnValidationError`, `failOnValidationWarn`, `failOnValidationInfo`, `errorRoles`, `catalogFiles` |
| Ant additions | `lenient`, `ignoreWarnings`, `failFast` on `schematron`; new task `schematron-convert`; `schHeader`, `overwriteWithoutNotice` on `schematron-preprocess` |
| Error roles | Applied per run, the global `SVRLHelper` determinator is no longer changed |
| Ant level failures (#50) | `failOnValidation*` still fail independent of `failOnError` |
| Catalog for XML files | With a catalog, each XML file is read into a DOM with it; external DTDs and entities only from the catalog, an unknown one fails the file (option 3) |

Next: step 2 (`ph-schematron-cli`) on top of the factory.

Step 2 is implemented: module `ph-schematron-cli` (package `com.helger.schematron.cli`). Differences to section 3:

| Topic | Implemented |
|-------|-------------|
| Fail on levels | `--fail-on-error`, `--fail-on-warning`, `--fail-on-info` (names aligned with Maven/Ant `failOnValidation*`) instead of `--fail-on LEVEL` |
| Logging options | `-v` / `-q` on every command (picocli mixin), not on the top level |
| Catalogs | `--catalog` on `validate` only (`convert` has no catalog, like Maven and Ant) |
| Published JAR | Classifier `shaded`: `ph-schematron-cli-x.y.z-shaded.jar`, the same name locally in `target/` and deployed |
| Library logging | slf4j-simple to stderr from level warn (`simplelogger.properties`) |

Next: step 3 (Dockerfile, `phelger/schematron`).

Step 3 is implemented: `ph-schematron-cli/Dockerfile` as in 4.5, plus a `.dockerignore` that sends only the shaded
JAR as build context. Verified locally (image built, `validate` on Saxon and phoxtrot, `--user` for non-root output
files). The image is not published yet; publishing is a manual release step (command on the wiki page
`Command-line-client.md`).

