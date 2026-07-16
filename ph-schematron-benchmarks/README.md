# ph-schematron-benchmarks

[JMH](https://github.com/openjdk/jmh) micro-benchmarks comparing the different
ph-schematron validation engines against each other. This module is **not**
deployed to Maven Central &ndash; it only exists to profile the implementations.

## Building

```
mvn -pl ph-schematron-benchmarks -am -DskipTests package
```

This produces a self-contained runnable JAR at
`ph-schematron-benchmarks/target/benchmarks.jar`.

## Running

Run all benchmarks:

```
java -jar ph-schematron-benchmarks/target/benchmarks.jar
```

Run a subset by regular expression (matched against the fully qualified
method name), e.g. only the cross-engine validity comparison:

```
java -jar ph-schematron-benchmarks/target/benchmarks.jar BenchmarkSchematronValidity
```

The engines log verbosely via `slf4j-simple`; raise the level to keep the JMH
output readable:

```
java -Dorg.slf4j.simpleLogger.defaultLogLevel=warn -jar ph-schematron-benchmarks/target/benchmarks.jar ...
```

## Benchmarks

| Class | What it measures |
|-------|------------------|
| `BenchmarkSchematronValidity` | End-to-end SCH&nbsp;&rarr;&nbsp;SVRL validation of one fixed schema/XML across **all** engines (`sch`, `schXslt`, `schXslt2`, `pureXPath`, `pureSaxon`), fresh resource per iteration (includes compile cost). |
| `BenchmarkXsltVsSaxon` | Head-to-head of the ISO XSLT pipeline (`SchematronResourceSCH`) vs. the pure-Java-to-XSLT&nbsp;3.0 pipeline (`SchematronResourcePureXslt`), in `cold` (per-invocation compile) and `warm` (validate only) profiles. |
| `BenchmarkPureXsltVersion` | The three XSLT language versions the pure-XSLT engine can emit (`1.0` / `2.0` / `3.0`), isolating the cost of the SVRL `location` fallback scaffolding lower versions require. `cold` and `warm` profiles. |
| `BenchmarkDomVsTinyTree` | The two XML-to-Saxon bridges used by the pure-XPath engine: a `org.w3c.dom` tree vs. the Saxon TinyTree DOM facade, parameterized by document size. |
| `BenchmarkIsValidSchematronMulti` | `isValidSchematron()` (parse + bind cost, no validation) for a single schema across all engines. |
| `BenchmarkIsValidSchematron` | `isValidSchematron()` across the full curated set of valid schema files. |

The engines under comparison:

* `SchematronResourceSCH` &ndash; the original ISO Schematron XSLT stylesheet chain.
* `SchematronResourceSchXslt_XSLT2` &ndash; the SchXslt 1.x XSLT&nbsp;2 pipeline.
* `SchematronResourceSchXslt2` &ndash; the SchXslt 2.x pipeline.
* `SchematronResourcePureXPath` &ndash; pure-Java, XPath-only, no XSLT.
* `SchematronResourcePureXslt` &ndash; pure-Java schema walk emitting XSLT run through Saxon.
