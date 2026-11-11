# Benchmarks: phoxtrot vs. Saxon (2026-11-11)

First measurement of the XSLT based engines on both XSLT processors (`docs/PLAN-phoxtrot-engine.md`, phase P5).

## Setup

| Item | Value |
| ---- | ----- |
| Date | 2026-11-11, 19:28 to 19:41 |
| Machine | Apple M5, 10 cores, 24 GB |
| JDK | Temurin 21.0.13 |
| Saxon | Saxon-HE 13.1 |
| phoxtrot | 0.2.0-SNAPSHOT, commit `7fab8a1` (2026-11-11 19:22) |
| ph-schematron | 11.0.0-SNAPSHOT, branch `phoxtrot`, commit `f0503441` |
| JMH | as annotated in the classes: 3 warmup iterations of 2 s, 5 measurement iterations of 3 s, 1 fork, `-prof gc` |

Command:

```
java -jar ph-schematron-benchmarks/target/benchmarks.jar "BenchmarkProcessorSize|BenchmarkProcessorCompile|BenchmarkSchematronValidity|BenchmarkXsltVsSaxon" -prof gc
```

One run on a developer machine (Eclipse open, no other build running). Treat differences below about 10 % as noise.

## Warm validation by document size (`BenchmarkProcessorSize`)

ISO Schematron engine, the Schematron of `BenchmarkDomVsTinyTree` (2 rules, 6 asserts), compiled once; `itemCount` `item` elements.
"DOM" passes a W3C DOM document of the caller, "stream" lets ph-schematron parse the bytes (the difference is the input conversion).

| Input | Items | Saxon [ms] | phoxtrot [ms] | phoxtrot / Saxon | Saxon alloc [MB/op] | phoxtrot alloc [MB/op] |
| ----- | ----: | ---------: | ------------: | ---------------: | ------------------: | ---------------------: |
| DOM | 1,000 | 1.89 ± 0.04 | 2.36 ± 0.09 | 1.25 | 3.7 | 7.3 |
| DOM | 5,000 | 10.39 ± 0.53 | 12.54 ± 0.38 | 1.21 | 18.1 | 36.3 |
| DOM | 20,000 | 42.76 ± 1.50 | 56.54 ± 0.94 | 1.32 | 71.5 | 147.8 |
| stream | 1,000 | 2.15 ± 0.09 | 2.80 ± 0.09 | 1.30 | 4.4 | 8.1 |
| stream | 5,000 | 11.02 ± 0.23 | 14.27 ± 0.43 | 1.30 | 21.6 | 40.9 |
| stream | 20,000 | 46.62 ± 3.93 | 62.09 ± 2.51 | 1.33 | 85.2 | 162.4 |

phoxtrot takes 1.2 to 1.3 times Saxon's time and allocates about twice as much per validation.
The input conversion (stream minus DOM) is about 4 ms (Saxon) and 5.5 ms (phoxtrot) for 20,000 items.

## Schematron to XSLT conversion (`BenchmarkProcessorCompile`)

`EUGEN-UBL-T10.sch` (includes, abstract patterns), conversion only (no compilation of the created XSLT), conversion
stylesheets cached per processor.

| Pipeline | Saxon [ms] | phoxtrot [ms] | phoxtrot / Saxon | Saxon alloc [MB/op] | phoxtrot alloc [MB/op] |
| -------- | ---------: | ------------: | ---------------: | ------------------: | ---------------------: |
| ISO | 64.89 ± 1.62 | 8.34 ± 0.18 | 0.13 | 219.9 | 42.1 |
| SchXslt 1 | 8.71 ± 0.11 | 8.07 ± 0.29 | 0.93 | 31.4 | 31.4 |
| SchXslt 2 | 7.03 ± 0.39 | 8.26 ± 0.25 | 1.18 | 18.8 | 33.0 |

The ISO conversion is about 8 times faster on phoxtrot (with a fifth of the allocation); SchXslt 1 is on par,
SchXslt 2 18 % slower.

## Small end-to-end validation (`BenchmarkSchematronValidity`, `BenchmarkXsltVsSaxon`)

`valid03.sch` against `valid03.xml`. Note: the "cold" variants build a new resource per call but use the compilation
cache, so they measure cache lookup plus validation, not the compilation.

| Benchmark | Saxon [µs] | phoxtrot [µs] | phoxtrot / Saxon |
| --------- | ---------: | ------------: | ---------------: |
| `BenchmarkSchematronValidity.sch` | 55.8 ± 1.2 | 65.6 ± 1.0 | 1.18 |
| `BenchmarkSchematronValidity.schXslt` | 691.3 ± 144.7 | 443.5 ± 24.4 | 0.64 |
| `BenchmarkSchematronValidity.schXslt2` | 52.5 ± 1.4 | 61.3 ± 1.6 | 1.17 |
| `BenchmarkXsltVsSaxon.coldXslt` | 54.6 ± 0.7 | 65.5 ± 0.7 | 1.20 |
| `BenchmarkXsltVsSaxon.warmXslt` | 56.9 ± 1.1 | 65.2 ± 2.0 | 1.15 |

The pure engines (`pureXPath`, `pureSaxon`/`coldSaxon`/`warmSaxon`) do not depend on the parameter; their results are
the same for both parameter values (within 2 %), which shows the noise level of this run.

## Summary

* Validation: phoxtrot 1.15 to 1.33 times Saxon's time, about twice the allocation.
* Conversion: ISO about 8 times faster on phoxtrot, SchXslt 1 on par, SchXslt 2 1.18 times Saxon's time.
* Not measured yet: the retained heap of a compiled engine, and DOM against native trees between the conversion
  steps on phoxtrot (the pipelines still exchange DOM documents).
