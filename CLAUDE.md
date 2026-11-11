# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

ph-schematron is a Java library for validating XML documents via ISO Schematron, SchXslt, or a pure-Java implementation. Published to Maven Central under `com.helger.schematron`.

Parent POM: `com.helger:parent-pom:3.1.0` — many plugin defaults (compiler, surefire, javadoc, license, formatter if any) are inherited from there, not declared in this repo.

## Modules

Multi-module Maven build. Order matters (later modules depend on earlier ones), as in the root `pom.xml`:

1. `ph-schematron-testfiles` — shared test resources (`.sch` / XML samples).
2. `ph-schematron-api` — public API surface: `ISchematronResource`, base classes (incl. the XSLT base classes `AbstractSchematronXSLTBasedResource`, `SchematronXSLTValidator`), SVRL JAXB bindings, the XSLT processor interface `ISchematronXsltProcessor` and its registry.
3. `ph-schematron-saxon` — the Saxon XSLT processor (`SaxonXsltProcessor`) and the other Saxon specific parts (transformer factory, DOM bridge, trace listener, s9api processor factory).
4. `ph-schematron-phoxtrot` — the phoxtrot specific parts (still empty, see `docs/PLAN-phoxtrot-engine.md`).
5. `ph-schematron-xslt` — engine for prebuilt XSLT files (`SchematronResourceXSLT`).
6. `ph-schematron-isosch` — ISO Schematron XSLT pipeline (`SchematronResourceSCH`).
7. `ph-schematron-schxslt` — SchXslt 1.x engine.
8. `ph-schematron-schxslt2` — SchXslt 2.x engine.
9. `ph-schematron-model` — the Schematron object model (`PSSchema`, reader, writer, preprocessor).
10. `ph-schematron-pure-xpath` (artifact `ph-schematron-pure`) — pure-Java engine (no XSLT; XPath-only Schematron, Saxon XPath).
11. `ph-schematron-pure-xslt` — pure-Java SCH → XSLT generator, run on Saxon s9api.
12. `ph-schematron-validator` — XML Schema and RELAX NG validation of Schematron files (Jing/Trang); no Schematron engine.
13. `ph-schematron-maven-plugin` — Maven plugin (`packaging = maven-plugin`).
14. `ph-schematron-ant-task` — Ant task.
15. `ph-schematron-benchmarks` — JMH benchmarks.
16. `ph-schematron-it` — integration tests (all engines, telemetry).

Version 11 (branch `phoxtrot`) separates the pipeline (`ESchematronEngine`) from the XSLT processor (Saxon or phoxtrot);
the plan with all decisions is `docs/PLAN-phoxtrot-engine.md`. The JAXP pipeline modules (`isosch`, `xslt`, `schxslt`,
`schxslt2`) have no processor dependency; they use `ph-schematron-saxon` only as test dependency. With exactly one
processor on the class path it is used automatically, otherwise it must be set via `xsltProcessor (...)`.

Public API entry points users see first: `SchematronResourceSCH`, `SchematronResourceXSLT`, `SchematronResourcePure`, `SchematronResourceSchXslt`.

## Build & Test

- Full build: `mvn --batch-mode --update-snapshots install`
- Single module: `mvn -pl ph-schematron-pure-xpath -am install`
- Single test: `mvn -pl ph-schematron-pure-xpath -Dtest=SchematronResourcePureXPathTest test`
- Snapshot deploy (CI only, JDK 21): `mvn -P release-snapshot deploy`

Java 21 is the baseline from version 11 on (`java.version` in the root `pom.xml`; phoxtrot requires 21). Build with JDK 21 or later.
CI runs the matrix on JDK 21 and 25 (`.github/workflows/maven.yml`). Anything that compiles on 21 must still compile on 25 — avoid removed/preview APIs.

phoxtrot (`com.helger.phoxtrot`, version in the `phoxtrot.version` property) is a sibling project at `../phoxtrot`; while it is a SNAPSHOT that is not deployed, it must be installed locally (`mvn install` there) before this build.

## Tests

- JUnit **4** (`org.junit.Test`, `org.junit.Assert.*`). Do not introduce JUnit 5 here unless converting the whole module.
- One test class per public class, suffix `Test` (e.g. `SchematronResourcePureXPathTest`). No `FuncTest`/`IT` split.
- Shared test schematrons / XML live in `ph-schematron-testfiles` — reuse them rather than inlining samples.

## Style

Follow the rules already in `~/.claude/rules/naming.md` and `~/.claude/rules/behaviour.md` — they describe this codebase's conventions accurately. Quick reminders specific to this repo:

- Hungarian notation is used throughout (`m_sPhase`, `m_aErrorHandler`, `aResource`, `sPhase`). New fields/params must match.
- Nullness annotations come from `org.jspecify.annotations` (`@NonNull`, `@Nullable`), not JSR-305. `@Nonempty` comes from `com.helger.annotation`.
- Logger pattern: `private static final Logger LOGGER = LoggerFactory.getLogger (ClassName.class);` — use inline string concatenation in log calls, not SLF4J `{}` placeholders.
- License header: Apache 2.0, copyright "Philip Helger" — template at `src/etc/license-template.txt`. Year range currently `2014-2026`.
- No formatter plugin is declared in this repo. Match surrounding files exactly (spacing before parens, before generics' angle brackets).

## Git

- **Never** run `git push` — the user always pushes. A PreToolUse hook in `.claude/settings.json` blocks it deterministically.
- `git commit` only when the user has given permission for the task at hand; otherwise stage with `git add <specific paths>` and stop. Commit messages carry no assistant attribution.
- Read-only git commands (`status`, `diff`, `log`, `show`, `branch`) are fine.

## Wiki

User-facing docs live in a separate repo: `https://github.com/phax/ph-schematron/wiki` (clone is typically a sibling directory if present). Don't write user docs into this repo's README.
