# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

ph-schematron is a Java library for validating XML documents via ISO Schematron, SchXslt, or a pure-Java implementation. Published to Maven Central under `com.helger.schematron`.

Parent POM: `com.helger:parent-pom:3.0.5` — many plugin defaults (compiler, surefire, javadoc, license, formatter if any) are inherited from there, not declared in this repo.

## Modules

Multi-module Maven build. Order matters (later modules depend on earlier ones):

1. `ph-schematron-testfiles` — shared test resources (`.sch` / XML samples).
2. `ph-schematron-api` — public API surface: `ISchematronResource`, base classes, SVRL JAXB bindings.
3. `ph-schematron-xslt` — XSLT-based engine using the original ISO Schematron XSLT.
4. `ph-schematron-schxslt` — SchXslt 1.x engine.
5. `ph-schematron-schxslt2` — SchXslt 2.x engine.
6. `ph-schematron-pure` — pure-Java engine (no XSLT; XPath-only Schematron).
7. `ph-schematron-validator` — high-level validator wrapper.
8. `ph-schematron-maven-plugin` — Maven plugin (`packaging = maven-plugin`).
9. `ph-schematron-ant-task` — Ant task.

Public API entry points users see first: `SchematronResourceSCH`, `SchematronResourceXSLT`, `SchematronResourcePure`, `SchematronResourceSchXslt`.

## Build & Test

- Full build: `mvn --batch-mode --update-snapshots install`
- Single module: `mvn -pl ph-schematron-pure -am install`
- Single test: `mvn -pl ph-schematron-pure -Dtest=SchematronResourcePureTest test`
- Snapshot deploy (CI only, JDK 17): `mvn -P release-snapshot deploy`

CI runs the matrix on JDK 17, 21, 25 (`.github/workflows/maven.yml`). Anything that compiles on 17 must still compile on 25 — avoid removed/preview APIs.

## Tests

- JUnit **4** (`org.junit.Test`, `org.junit.Assert.*`). Do not introduce JUnit 5 here unless converting the whole module.
- One test class per public class, suffix `Test` (e.g. `SchematronResourcePureTest`). No `FuncTest`/`IT` split.
- Shared test schematrons / XML live in `ph-schematron-testfiles` — reuse them rather than inlining samples.

## Style

Follow the rules already in `~/.claude/rules/naming.md` and `~/.claude/rules/behaviour.md` — they describe this codebase's conventions accurately. Quick reminders specific to this repo:

- Hungarian notation is used throughout (`m_sPhase`, `m_aErrorHandler`, `aResource`, `sPhase`). New fields/params must match.
- Nullness annotations come from `org.jspecify.annotations` (`@NonNull`, `@Nullable`), not JSR-305. `@Nonempty` comes from `com.helger.annotation`.
- Logger pattern: `private static final Logger LOGGER = LoggerFactory.getLogger (ClassName.class);` — use inline string concatenation in log calls, not SLF4J `{}` placeholders.
- License header: Apache 2.0, copyright "Philip Helger" — template at `src/etc/license-template.txt`. Year range currently `2014-2026`.
- No formatter plugin is declared in this repo. Match surrounding files exactly (spacing before parens, before generics' angle brackets).

## Git

- **Never** run `git commit` or `git push` — the user always commits/pushes themselves. Stage with `git add <specific paths>` and stop. A PreToolUse hook in `.claude/settings.json` blocks these commands deterministically.
- Read-only git commands (`status`, `diff`, `log`, `show`, `branch`) are fine.

## Wiki

User-facing docs live in a separate repo: `https://github.com/phax/ph-schematron/wiki` (clone is typically a sibling directory if present). Don't write user docs into this repo's README.
