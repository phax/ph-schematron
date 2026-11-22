<?xml version="1.0" encoding="UTF-8"?>
<!--
  Triggers the SVRL extensions of SchXslt / SchXslt2 (see content/svrl-schxslt.rnc
  of SchXslt2): schematronEdition on the output, ruleId / patternId on failed
  asserts and successful reports, a suppressed rule, and - with the SchXslt2
  parameter severity-threshold set to "error" - a skipped assert. See
  schxslt-svrl-rich.sch for the attributes SchXslt 1 copies.
  Use together with schxslt-svrl-extensions.xml.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt2"
        schematronEdition="2025">
  <pattern id="P1">
    <rule id="R1" context="/root">
      <assert id="A1" test="b" severity="error">There must be a b</assert>
      <report id="S1" test="a" severity="error">There is an a</report>
      <assert id="A2" test="c" severity="warning">There should be a c</assert>
    </rule>
    <!-- Matches the same node as R1, so it is suppressed -->
    <rule id="R2" context="/root">
      <assert id="A3" test="d">There must be a d</assert>
    </rule>
  </pattern>
</schema>
