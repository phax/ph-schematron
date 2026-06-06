<?xml version="1.0" encoding="UTF-8"?>
<!--
  Maximum-features Schematron schema for ISO/IEC 19757-3:2025 (v4).
  Inherits everything from max-2020.sch and adds the new 2025 features:
    - schematronEdition="2025"
    - top-level <extends>, <param>, <rules>, <group>
    - <let as="...">
    - <phase from="..." when="...">
    - <rule visit-each="..." severity="..." flag="warning critical">
    - <assert severity="..."> / <report severity="...">
    - multi-token @flag
    - direct @role on <pattern> / <group>
    - dynamic content (<value-of>, <name>) inside <dir>, <emph>, <span>
    - queryBinding="xslt4" (reserved name added in 2025)
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:ext="http://example.com/ext"
            id="m2025"
            schemaVersion="4.0"
            schematronEdition="2025"
            defaultPhase="phaseA"
            queryBinding="xslt4">
  <ext:metadata edition="2025"/>
  <sch:title>Maximum 2025 features</sch:title>
  <sch:ns prefix="x" uri="http://example.com/x"/>
  <!-- Top-level 2025: <extends> on schema -->
  <sch:extends href="library-2025.xml#libContent"/>
  <!-- Top-level 2025: <param> on schema -->
  <sch:param name="schemaParam"/>
  <sch:let name="rootName" value="name(/*)"/>
  <sch:let name="typed" as="xs:integer" value="42"/>
  <!-- Phase with new 2025 attributes -->
  <sch:phase id="phaseA" from="/x:root" when="exists(/x:root)">
    <sch:active pattern="patAbs"/>
    <sch:active pattern="groupA"/>
  </sch:phase>
  <!-- 2025 abstract-rules container -->
  <sch:rules id="rulesA">
    <sch:title>Shared abstract rules</sch:title>
    <sch:rule abstract="true" id="absSharedRule">
      <sch:assert test="@id" flag="warning critical">shared abstract assertion</sch:assert>
    </sch:rule>
  </sch:rules>
  <!-- Abstract pattern with let* and param* (NEW in 2025 abstract branch) -->
  <sch:pattern abstract="true" id="patAbs" role="abstract-role">
    <sch:title>Abstract pattern</sch:title>
    <sch:let name="absLet" value="1"/>
    <sch:param name="ctx"/>
    <sch:rule context="$ctx" id="absMain" visit-each="$items" severity="warning">
      <sch:assert test="@id" id="absA" diagnostics="diag1" properties="prop1" severity="error">
        <sch:value-of select="@id"/> required for <sch:name/>.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern is-a="patAbs" id="patIsa">
    <sch:param name="ctx" value="x:thing"/>
  </sch:pattern>
  <!-- 2025 group: same content model, different rule semantics -->
  <sch:group id="groupA" role="group-role" documents="@subordinate-iri">
    <sch:title>Group</sch:title>
    <sch:rule context="x:item" id="ruleGroup" flag="info warn" severity="warning">
      <sch:p>Inline rule paragraph</sch:p>
      <sch:let name="local" as="xs:string" value="@id"/>
      <sch:assert test="$local" id="assGrp" properties="prop1 prop2" severity="error">
        <sch:emph>Required <sch:value-of select="@id"/>:</sch:emph>
        id on <sch:name/>.
      </sch:assert>
      <sch:report test="not(@id)" id="rptGrp" severity="info">
        <sch:dir value="ltr">Reporting <sch:value-of select="@type"/></sch:dir>
        <sch:span class="hi">missing <sch:name path="@id"/></sch:span>
      </sch:report>
      <sch:extends rule="absSharedRule"/>
    </sch:rule>
  </sch:group>
  <sch:diagnostics>
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
