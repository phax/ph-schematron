# Issue: SVRL of SchXslt2 cannot be read when a rule or pattern has an ID

**Status:** fixed in 11.1.0 (see "Resolution" and "SchXslt 1" at the end).

Found on 2026-11-22 while running the EN 16931 UBL Schematron with XMLPerm (`../xmlperm`, use case
`examples/en16931-ubl`). Affects ph-schematron 11.0.0 (`schxslt2.version` 1.11.3), with Saxon and with phoxtrot.

## Symptom

As soon as an assertion fails (or a report succeeds) inside a `sch:rule` or `sch:pattern` that has an `@id`, the
SVRL cannot be read and the validation produces no result:

```
ERROR JAXB [fatal_error] cvc-complex-type.3.2.2: Attribut 'patternId' darf nicht in Element 'svrl:failed-assert' vorkommen.
ERROR Failed to parse XML document: cvc-complex-type.3.2.2: Attribut 'patternId' darf nicht in Element 'svrl:failed-assert' vorkommen.
[error] Validating XML file 'doc.xml' against Schematron rules from '.../with-id.sch' created no SVRL
```

A document on which nothing fires is not affected, so the error stays hidden until a rule fires. Real world
Schematrons give their patterns IDs (EN 16931: `UBL-model`, `UBL-syntax`, `Codesmodel`), so with the engine
`schxslt2` every invalid EN 16931 invoice fails this way. The engine `iso-schematron` works.

## Reproduction

`doc.xml`:

```xml
<root><a/></root>
```

`with-id.sch`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern id="P1">
    <rule context="/root">
      <assert id="A1" test="b">There must be a b</assert>
    </rule>
  </pattern>
</schema>
```

```bash
java -jar ph-schematron-cli/target/ph-schematron-cli-11.0.0-shaded.jar validate -e schxslt2 \
     --xslt-processor saxon -s with-id.sch --expect-invalid doc.xml
```

Results with the 11.0.0 CLI (same for `--xslt-processor phoxtrot`):

| Variant of `with-id.sch` | Result |
|--------------------------|--------|
| `<pattern>` without `@id` | OK: `[error] [A1] ... There must be a b` |
| `<pattern id="P1">` (as above) | no SVRL: `patternId` not allowed on `svrl:failed-assert` |
| `<pattern>` and `<rule id="R1" ...>` | no SVRL: `ruleId` not allowed on `svrl:failed-assert` |
| `<pattern id="P1">` with `<report id="A1" test="a">` | no SVRL: `patternId` not allowed on `svrl:successful-report` |
| `<pattern>` and `schematronEdition="2025"` on `sch:schema` | no SVRL: `schematronEdition` not allowed on `svrl:schematron-output` |

## Cause

SchXslt2 writes SVRL with documented extensions. They are listed in `content/svrl-schxslt.rnc` of the
`name.dmaus.schxslt:schxslt2` JAR ("This grammar documents the derivations from the official SVRL grammar"), and
`content/transpile.xsl` creates them:

| Extension | Where | Created by `transpile.xsl` |
|-----------|-------|----------------------------|
| `@ruleId` (`xsd:NMTOKEN`, optional) | `svrl:failed-assert`, `svrl:successful-report` | template `schxslt:failed-assertion-attributes` (called for asserts and reports, lines 795 and 825): `<attribute name="ruleId" select="../@id"/>` inside `xsl:where-populated` - so only when the rule has an `@id` |
| `@patternId` or `@groupId` (`xsd:NMTOKEN`, optional) | same | `<attribute name="{local-name(../..)}Id" select="../../@id"/>` - `patternId` for a `sch:pattern`, `groupId` for a `sch:group` |
| `@xml:lang` | same | only if the language differs from the schema - **not** allowed either (`attlist.assert-and-report` has no foreign attributes) |
| `@schematronEdition` | `svrl:schematron-output` | copied from `sch:schema/@schematronEdition` (line 584: `select="(@schemaVersion, @schematronEdition)"`) |
| `svrl:skipped-assert`, `svrl:skipped-report` with `@severityThreshold` | output, next to failed asserts / successful reports | static parameter `schxslt:report-skipped-assertion` (default `true`), for assertions below the severity threshold |

ph-schematron reads the SVRL with `SVRLMarshaller`, which calls `setUseSchema (true)` with
`ph-schematron-api/src/main/resources/external/schemas/svrl.xsd` (`CSVRL.SVRL_XSD_PATH`). Commit `cf8d771a` ("Added
extensions for SchXslt SVRL output": `svrl:suppressed-rule`, `svrl:message-code`, `svrl:message-category`) is in
9.2.0, but the XSD rewrite for 10.0.0 (merged in `a65b8ea0`) dropped all three - and with them `attlist.rich`
(`xml:lang`, `xml:space`, `see`, `icon`, `fpi`) on `fired-rule`, `failed-assert` and `successful-report`.
`svrl:suppressed-rule` is emitted by default by SchXslt 1 and SchXslt2 (`schxslt:report-suppressed-rule` = `true`)
whenever two rules of one pattern match the same node, so since 10.0.0 such SVRL cannot be read either
(`cvc-complex-type.2.4.a: ... 'svrl:suppressed-rule'`). `message-code` and `message-category` are emitted by no SchXslt
version and need not come back. The XSD does not contain the extensions in the table above:

* `attlist.assert-and-report` has `id`, `location`, `test`, `role`, `flag`, `severity` and the
  `##other` foreign attributes - `ruleId`/`patternId`/`groupId` are unqualified, so they are rejected.
* `svrl:schematron-output` allows `schemaFrontEdition` (as the ISO 19757-3:2025 SVRL grammar does), but not
  `schematronEdition`, which SchXslt2 copies from the schema. This one is a deviation of SchXslt2 from the
  standard SVRL and could also be reported upstream.
* `svrl:skipped-assert` and `svrl:skipped-report` are not declared. Not reproduced: whether ph-schematron ever sets a
  severity threshold that makes SchXslt2 skip assertions has not been checked.

## Proposed fix

Follow the precedent of `cf8d771a` and extend `svrl.xsd`, each addition marked with a `[ph]` / "SchXslt2 extension"
comment:

1. In `attlist.assert-and-report` (used by `svrl:failed-assert` and `svrl:successful-report`):
   `<xs:attribute name="ruleId" type="xs:NMTOKEN"/>`, `<xs:attribute name="patternId" type="xs:NMTOKEN"/>`,
   `<xs:attribute name="groupId" type="xs:NMTOKEN"/>`.
2. On `svrl:schematron-output`: `<xs:attribute name="schematronEdition"/>`.
3. Optionally `svrl:skipped-assert` / `svrl:skipped-report` (empty, `@severityThreshold` plus the attributes of
   `attlist.assert-and-report`) in the choice next to `svrl:failed-assert` / `svrl:successful-report`.

The JAXB classes of the SVRL are generated from this XSD (`ph-schematron-api/pom.xml`, JAXB plugin with
`<schemaInclude>svrl.xsd</schemaInclude>`), so the new attributes become getters of `FailedAssert` /
`SuccessfulReport`. `ruleId` and `patternId` would be useful in
`SVRLFailedAssert` / `AbstractSVRLMessage` too, because they tell which rule and pattern fired - that is a
separate decision.

Not recommended: switching off the schema validation in `SVRLMarshaller` (`setUseSchema (false)`). That would hide
the next unknown extension as well, but it also removes the only check of the SVRL structure.

## Tests to add

In `ph-schematron-schxslt2` (both surefire executions, Saxon and phoxtrot) and in `ph-schematron-it`:

* a Schematron in `ph-schematron-testfiles` with `pattern/@id`, `rule/@id`, a failing `assert` and a successful
  `report`, plus `schematronEdition="2025"` on the schema;
* expected: the SVRL is read, one failed assert and one successful report with their IDs.

After the fix, add a bullet to "News and noteworthy" of the upcoming version (`v11.0.1 - work in progress`).

## Impact on XMLPerm

XMLPerm (`ph-xmlperm-schematron`, CLI `--sch-converter schxslt2`, the default) uses
`SchematronResourceSchXslt2` with ph-schematron 11.0.0. Until this is fixed, the XMLPerm EN 16931 use case runs with
`--sch-converter iso`. The XMLPerm tests did not catch it because their Schematrons have no pattern or rule IDs.

## Resolution (11.1.0)

* `svrl.xsd`: `ruleId`, `patternId`, `groupId` and `xml:lang` on `failed-assert` / `successful-report`
  (`attlist.schxslt-assert-and-report`), `schematronEdition` on `schematron-output`, `svrl:suppressed-rule` as
  alternative to `svrl:fired-rule`, and `svrl:skipped-assert` / `svrl:skipped-report` (the attributes of
  `failed-assert` plus `severityThreshold` - SchXslt2 also emits `location` on them) next to the failed asserts.
* `binding.xjb` pins the name of `SchematronOutputType.getActivePatternOrActiveGroupAndFiredRule ()`.
* New default methods `onSuppressedRule`, `onSkippedAssert`, `onSkippedReport` in `ISVRLVisitor`,
  `ISVRLVoidVisitor` and `ISVRLContextVisitor`; `SVRLVisitor` no longer throws on these elements.
* `AbstractSVRLMessage.getRuleID ()`, `getPatternID ()`, `getGroupID ()` (new constructor parameters, hence 11.1.0).
* Tests: `external/schxslt-svrl-extensions/schxslt-svrl-extensions.sch`, `schxslt2-svrl-extensions-lang.sch` and
  `schxslt-svrl-rich.sch` with
  `external/schxslt-svrl-extensions/schxslt-svrl-extensions.xml` in `ph-schematron-testfiles`; `SchXslt2SVRLExtensionsTest`,
  `SchXsltSVRLExtensionsTest`, `SchematronAllEnginesSVRLExtensionsTest` and the wrapper tests in `ph-schematron-api`.
  The files are not in `test-sch` / `test-xml`: the Schematron uses Schematron 2025 features (`severity`,
  `schematronEdition`), and every file in `test-sch` is checked against the 2006 grammar by `SchematronValidatorTest`.

## SchXslt 1

SchXslt 1 (`xslt/2.0/svrl.xsl` of `name.dmaus.schxslt:schxslt` 1.10.1) copies attributes of the Schematron into the
SVRL that the XSD rejected (found by dumping the SVRL of `schxslt-svrl-rich.sch` and validating it with `xmllint`):

| SVRL element | Copied by SchXslt 1 | 9.2.0 XSD | 11.0.0 XSD |
|--------------|---------------------|-----------|------------|
| `schematron-output` | `sch:schema/@xml:*` | rejected | rejected |
| `active-pattern` | `@id`, `@role`, `@xml:*` | `@xml:*` rejected | `@xml:*` rejected |
| `fired-rule`, `suppressed-rule` | `@see`, `@icon`, `@fpi`, `@xml:*` (`suppressed-rule` without `@xml:*`) | allowed (`attlist.rich`) | rejected |
| `failed-assert`, `successful-report` | `@see`, `@icon`, `@fpi`, `@xml:*`, inherited `@xml:lang` | allowed (`attlist.rich`) | rejected |
| `diagnostic-reference`, `property-reference` | `@xml:*` | partly allowed | rejected |
| `text` of a diagnostic | all attributes of `sch:diagnostic` (`id`, `role`, `see`, `icon`, `fpi`, `xml:*`) | `id`, `role` rejected | `id`, `role` rejected |
| `text` of a `sch:p` | `@id`, `@class`, `@icon`, `@xml:*` | `id`, `class` rejected | `id`, `class` rejected |
| `dir`, `emph`, `span` | `@xml:*`; `dir` also `@value` of `sch:dir` | rejected | rejected |

So with SchXslt 1 the SVRL could not be read as soon as the Schematron had `xml:lang` on `sch:schema`, or
`see` / `icon` / `fpi` on a rule or assertion, or referenced a diagnostic. The ISO pipeline emits the rich attributes
only with `allow-foreign=true`, which ph-schematron does not set by default.

Fixed in 11.1.0 with the attribute groups `attlist.xml` (`xml:lang`, `xml:space` and a wildcard for the other
`xml:*` attributes) and `attlist.rich` (`see`, `icon`, `fpi` plus `attlist.xml`), the attributes `id`, `class`, `role`
on `svrl:text` and `value` on `svrl:dir`. Tested by `SchXsltSVRLExtensionsTest.testRichAttributes` and
`SchematronAllEnginesSVRLExtensionsTest.testAllEnginesRichAttributes`.

## ISO Schematron: svrl:property

Found by `SchematronAllEnginesSVRLExtensionsTest.testAllEnginesRichAttributes`: the ISO pipeline
(`iso_svrl_for_xslt2.xsl`, template `process-property`, marked "EXPERIMENTAL" since 2008) wrote
`<svrl:property id="..." name="..." value="...">` with the copied content for every property an assertion references.
No SVRL grammar allows that element (the 9.2.0 XSD neither), so `iso-schematron` created no SVRL as soon as an
assertion used `@properties`. Fixed in 11.1.0 in the bundled stylesheets: `process-property` now writes the official
`svrl:property-reference` (`@property`, `@role`, `@scheme`, `svrl:text` with the rich attributes and the processed
property content, as for diagnostics); the skeleton passes `role`, `scheme` and the rich attributes. The historical
copy in `ph-schematron-xslt/src/test/resources/external/schematron-old/` is unchanged.

