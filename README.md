# ph-schematron

<!-- ph-badge-start -->
[![Sonatype Central](https://maven-badges.sml.io/sonatype-central/com.helger.schematron/ph-schematron-parent-pom/badge.svg)](https://maven-badges.sml.io/sonatype-central/com.helger.schematron/ph-schematron-parent-pom/)
[![javadoc](https://javadoc.io/badge2/com.helger.schematron/ph-schematron-testfiles/javadoc.svg)](https://javadoc.io/doc/com.helger.schematron/ph-schematron-testfiles)
<!-- ph-badge-end -->

ph-schematron is a Java library that validates XML documents via [ISO Schematron](http://www.schematron.com), [SchXslt](https://github.com/schxslt/schxslt) or a Java "pure" implementation.

Schematron is an XML based validation language to validate XML documents.

Schematron is part of the ISO 19757 standard "Information technology — Document Schema Definition Languages (DSDL)", Part 3 "Rule-based validation — Schematron".

See **[the Wiki](https://github.com/phax/ph-schematron/wiki)** for more details.

The project is licensed under Apache 2.0 license.

---

## Version 9.2.0 (upcoming) — `ph-schematron-pure` breaking API changes

The `ph-schematron-pure` engine has been migrated from the JAXP XPath API
(`javax.xml.xpath.*`, internally limited to XPath 1.0) to the Saxon s9api
(`net.sf.saxon.s9api.*`). Schematron expressions in `pure` are now compiled
and evaluated with **XPath 3.1** instead of XPath 1.0.

User-facing entry points (`SchematronResourcePure`, `IPSBoundSchema`,
`IPSValidationHandler`, `IPSErrorHandler`) keep their DOM `Node` / `NodeList`
signatures. The breaking changes are concentrated in the XPath configuration
surface and in the bound-schema internals:

- `IXPathConfig` / `XPathConfig` / `XPathConfigBuilder` no longer expose
  `XPathFactory`, `XPathVariableResolver` or `XPathFunctionResolver`. They
  now expose a Saxon `Processor`, a list of Saxon `ExtensionFunction`s, and
  a map of external `QName` → `XdmValue` variables.
  - `setXPathFactory(...)`, `setXPathFactoryClass(...)`,
    `setGlobalXPathFactory(...)`, `setXPathVariableResolver(...)` and
    `setXPathFunctionResolver(...)` on `XPathConfigBuilder` are removed.
  - Replacements: `setProcessor(Processor)`,
    `setXPathVersion(EXPathVersion)` (default `EXPathVersion.XPATH_3_1`,
    passed to Saxon's `XPathCompiler.setLanguageVersion`; `1.0`, `2.0`,
    `3.0`, `3.1`, `4.0`),
    `addExtensionFunction(ExtensionFunction)` /
    `addAllExtensionFunctions(...)`, and
    `addExternalVariable(QName, XdmValue)` /
    `addAllExternalVariables(...)`.
- Custom function resolvers based on `javax.xml.xpath.XPathFunction` and
  `MapBasedXPathFunctionResolver` (from `ph-commons`) are no longer wired
  into the engine. Migrate by implementing
  `net.sf.saxon.s9api.ExtensionFunction` instead. Function arguments now
  arrive as `XdmValue[]` (not `List<Object>` of DOM `Node`s).
- `XQueryAsXPathFunctionConverter.loadXQuery(InputStream)` returns
  `ICommonsList<ExtensionFunction>` instead of
  `MapBasedXPathFunctionResolver`. Feed the returned list into
  `XPathConfigBuilder.addAllExtensionFunctions(...)`.
- `XPathFunctionFromUserFunction` now implements `ExtensionFunction` and is
  Saxon-typed throughout.
- `XPathEvaluationHelper` is reshaped around `XPathExecutable` / `XdmItem`
  / `XdmValue`. Variants such as `evaluateAsNodeList(...)` returning DOM
  `NodeList` are gone; use `evaluateAsXdmNodes(...)` or `evaluate(...)`.
- `XPathLetVariableResolver` no longer implements
  `javax.xml.xpath.XPathVariableResolver`. It is now a per-thread
  `QName` → `XdmValue` store used internally during validation.
- A new `XPathEvaluationContext` (thread-local) is published as part of the
  `pure` SPI. The bound schema installs one per `validate(...)` call; the
  SVRL handler uses it to re-wrap DOM nodes against the same Saxon
  `DocumentWrapper` and to read the current `<let>` variable bindings.
- The bound-schema and bound-element types (`PSXPathBoundSchema`,
  `PSXPathBoundRule`, `PSXPathBoundAssertReport`, `PSXPathBoundElement`,
  `PSXPathVariables`, `IPSXPathVariables`) now hold Saxon `XPathExecutable`
  instances instead of `javax.xml.xpath.XPathExpression`.

Behavioural consequence of moving from XPath 1.0 to XPath 3.1: expressions
that were silently re-interpreted under XPath 1.0 (single-item conversion,
implicit string coercion, `eq`/`ne` being syntax errors, etc.) now behave
per the XPath 3.1 spec. Schematrons that target XPath 2.0/3.x in their
`queryBinding` attribute will work as written; Schematrons that relied on
XPath 1.0 quirks may need adjustment.

### Saxon TinyTree input path

`SchematronResourcePure.getAsNode(...)` now parses the input XML straight
into a Saxon TinyTree (via `Processor.newDocumentBuilder()`) and presents
it as a DOM facade (`net.sf.saxon.dom.NodeOverNodeInfo` /
`DocumentOverNodeInfo`). Every overload of
`applySchematronValidationToSVRL`, `getSchematronValidity` and
`applySchematronValidation` that takes a `Source` or `IHasInputStream`
goes through this path. The internal validation loop short-circuits the
DOM-bridge (`DocumentWrapper.wrap`) when it sees a Saxon-backed facade,
so XPath evaluation runs directly against the TinyTree.

What it buys you (see `MainBenchmarkDomVsTinyTree`): for a representative
~1 MiB document (20k items, 6 asserts per rule) on JDK 21:

| Phase             | DOM (Xerces) | Saxon TinyTree | Δ        |
| ----------------- | ------------ | -------------- | -------- |
| Parse only        | ~4.1 ms      | ~5.7 ms        | -28 %    |
| Validate only     | ~58.4 ms     | ~54.2 ms       | +8 %     |
| Parse + validate  | ~63.1 ms     | ~59.6 ms       | +6 %     |

So XPath evaluation is modestly faster on TinyTree, while Saxon's
DocumentBuilder parses a bit slower than Xerces DOM. Net win is small but
real, and grows for more XPath-heavy schemas / repeated validations of
the same document.

Caveats:

- When a custom XML `EntityResolver` is configured on the resource, the
  TinyTree path is bypassed and the previous DOM parsing route is used
  so the resolver still works.
- The `org.w3c.dom.Node` returned by `getAsNode(...)` in the fast path is
  Saxon's read-only facade. Code that *mutates* the returned DOM would
  hit `NOT_SUPPORTED_ERR`; pure-read consumers (XPath, traversal,
  serialisation) are unaffected.
- Overloads that take a pre-built `org.w3c.dom.Node` keep their existing
  behaviour (the engine still wraps the DOM via `DocumentWrapper`).

---

My personal [Coding Styleguide](https://github.com/phax/meta/blob/master/CodingStyleguide.md) |
It is appreciated if you star the GitHub project if you like it.