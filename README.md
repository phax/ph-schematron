# ph-schematron

<!-- ph-badge-start -->
[![Sonatype Central](https://maven-badges.sml.io/sonatype-central/com.helger.schematron/ph-schematron-parent-pom/badge.svg)](https://maven-badges.sml.io/sonatype-central/com.helger.schematron/ph-schematron-parent-pom/)
[![javadoc](https://javadoc.io/badge2/com.helger.schematron/ph-schematron-testfiles/javadoc.svg)](https://javadoc.io/doc/com.helger.schematron/ph-schematron-testfiles)

> If this project saved you some time or made your day a little easier, a star would mean a lot — it helps others find it too.
<!-- ph-badge-end -->

ph-schematron is a Java library that validates XML documents via [ISO Schematron](http://www.schematron.com),
[SchXslt](https://codeberg.org/SchXslt/schxslt), [SchXslt2](https://codeberg.org/SchXslt/schxslt2) or a Java "Pure XPath" implementation.

Schematron is an XML based validation language to validate XML documents.

Schematron is part of the ISO 19757 standard "Information technology — Document Schema Definition Languages (DSDL)", Part 3 "Rule-based validation — Schematron".

## Version 11 is a breaking release

v11 separates the Schematron engine from the XSLT processor that runs it (Saxon or the new phoxtrot) and contains breaking changes, among others:

* Java 21 is the minimum requirement (previously Java 17).
* `ph-schematron-isosch`, `ph-schematron-xslt`, `ph-schematron-schxslt` and `ph-schematron-schxslt2` no longer depend on Saxon: add `ph-schematron-saxon` (or `ph-schematron-phoxtrot`) as a dependency.
* With both XSLT processors on the class path, the processor must be selected explicitly.
* Saxon HE was updated to 13.x, and all elements that were deprecated for removal since v10.0 were removed.

Before upgrading from v10.x, read the section "v10.x → v11.0" on the [Migrations](https://github.com/phax/ph-schematron/wiki/Migrations) wiki page.
The [XSLT processors](https://github.com/phax/ph-schematron/wiki/XSLT-processors) wiki page explains how to choose between Saxon and phoxtrot.

## Documentation

The full documentation is in the **[Wiki](https://github.com/phax/ph-schematron/wiki)**:

* [Usage](https://github.com/phax/ph-schematron/wiki/Usage)
* [XSLT processors](https://github.com/phax/ph-schematron/wiki/XSLT-processors)
* [Streamability](https://github.com/phax/ph-schematron/wiki/Streamability)
* [Schematron Best Practices](https://github.com/phax/ph-schematron/wiki/Schematron-Best-Practices)
* [News and noteworthy](https://github.com/phax/ph-schematron/wiki/News-and-noteworthy)
* [Maven plugin](https://github.com/phax/ph-schematron/wiki/Maven-plugin)
* [ANT tasks](https://github.com/phax/ph-schematron/wiki/ANT-tasks)
* [Command line client](https://github.com/phax/ph-schematron/wiki/Command-line-client)
* [Migrations](https://github.com/phax/ph-schematron/wiki/Migrations)
* [License](https://github.com/phax/ph-schematron/wiki/License)

The project is licensed under Apache 2.0 license.

Release notes are on the [News and noteworthy](https://github.com/phax/ph-schematron/wiki/News-and-noteworthy) wiki page.
Migration guides between major/minor versions live on the
[Migrations](https://github.com/phax/ph-schematron/wiki/Migrations) wiki page.

---

My personal [Coding Styleguide](https://github.com/phax/meta/blob/master/CodingStyleguide.md) |
It is appreciated if you star the GitHub project if you like it.
