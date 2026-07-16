<?xml version="1.0" encoding="UTF-8"?>
<!--
  Maximum-features Schematron schema for ISO/IEC 19757-3:2020 (v3).
  Inherits everything from max-2016.sch and adds the new 2020 features:
    - queryBinding="xslt3"  (xslt3 reserved name added in 2020)
    - <diagnostic role="..."> (RNC now declares it - was a NOTE in 2016)
  Intentionally absent (2025 features):
    - schematronEdition / group / library / rules / severity / visit-each /
      from / when / let@as / multi-token flag / dynamic content in dir/emph/span
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:ext="http://example.com/ext"
            id="m2020"
            schemaVersion="3.0"
            defaultPhase="phaseA"
            queryBinding="xslt3">
  <ext:metadata edition="2020"/>
  <sch:title>Maximum 2020 features</sch:title>
  <sch:ns prefix="x" uri="http://example.com/x"/>
  <sch:let name="rootName" value="name(/*)"/>
  <sch:phase id="phaseA">
    <sch:active pattern="patAbs"/>
  </sch:phase>
  <sch:pattern abstract="true" id="patAbs">
    <sch:rule context="$ctx" id="absMain" flag="warn">
      <sch:assert test="@id" id="absA" diagnostics="diag1" properties="prop1">
        <sch:value-of select="@id"/> required for <sch:name/>.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern is-a="patAbs" id="patIsa">
    <sch:param name="ctx" value="x:thing"/>
  </sch:pattern>
  <sch:pattern id="patConcrete" documents="@subordinate-iri">
    <sch:rule context="x:item" id="ruleConcrete" flag="info">
      <sch:p>Inline rule paragraph</sch:p>
      <sch:assert test="@id" id="assConcrete" properties="prop1 prop2">
        <sch:emph>Required</sch:emph> id on <sch:name/>.
      </sch:assert>
      <sch:report test="not(@id)" id="rptConcrete" properties="prop2">
        <sch:dir value="ltr">Reporting</sch:dir> <sch:span class="hi">missing id</sch:span>
      </sch:report>
      <sch:extends href="abstract-rules.xml#absRule"/>
    </sch:rule>
  </sch:pattern>
  <sch:diagnostics>
    <!-- 2020: 'role' is now formally part of the RNC -->
    <sch:diagnostic id="diag1" role="warning">
      Diagnostic: <sch:value-of select="$rootName"/>.
    </sch:diagnostic>
  </sch:diagnostics>
  <sch:properties>
    <sch:property id="prop1" role="info" scheme="ISO 4217">
      <sch:value-of select="."/>
    </sch:property>
    <sch:property id="prop2">
      Static property text with <sch:name/>.
    </sch:property>
  </sch:properties>
</sch:schema>
