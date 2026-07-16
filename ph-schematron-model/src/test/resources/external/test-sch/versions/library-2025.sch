<?xml version="1.0" encoding="UTF-8"?>
<!--
  Mock Schematron <library> document for ISO/IEC 19757-3:2025.
  The <library> root element was introduced in 2025 (alongside the v4 RNC's
  chart = schema | include production). It is used to hold external declarations
  (abstract patterns, abstract rules, params, lets, ...) that are then pulled
  into a hosting <schema> via top-level <extends href="...#fragment"/>.

  This mock exercises the full v4 library content model:
    - rich attributes (id, xml:lang)
    - foreign attributes / elements
    - inclusion + extends interleaved at the top level
    - title?, p*
    - param*
    - let*
    - abstract-rules*
    - (rule-set | pattern)*
    - diagnostics?
    - properties?
-->
<sch:library xmlns:sch="http://purl.oclc.org/dsdl/schematron"
             xmlns:ext="http://example.com/ext"
             id="libContent"
             xml:lang="en">
  <ext:metadata kind="library" edition="2025"/>
  <sch:title>Shared library of abstract rules and patterns</sch:title>
  <sch:p>Library-level paragraph.</sch:p>
  <sch:param name="defaultThreshold" value="3"/>
  <sch:let name="libRoot" value="name(/*)"/>
  <!-- 2025 abstract-rules container - reusable by any importing schema. -->
  <sch:rules id="libRules">
    <sch:rule abstract="true" id="libAbsRule">
      <sch:assert test="@id" flag="warning shared">library-level shared abstract rule</sch:assert>
    </sch:rule>
  </sch:rules>
  <!-- Abstract pattern in the library. -->
  <sch:pattern abstract="true" id="libAbsPattern" role="lib-abstract">
    <sch:let name="absLet" value="."/>
    <sch:param name="ctx"/>
    <sch:rule context="$ctx" id="libAbsMain" severity="warning">
      <sch:assert test="@id" id="libAbsA" severity="error">
        Library abstract: <sch:value-of select="@id"/> required for <sch:name/>.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!-- Concrete group living inside the library. -->
  <sch:group id="libGroup" role="lib-group">
    <sch:rule context="x:item" id="libGroupRule" flag="info">
      <sch:assert test="@id" id="libGroupA">
        <sch:emph>Required <sch:value-of select="@id"/>:</sch:emph> id required.
      </sch:assert>
    </sch:rule>
  </sch:group>
  <sch:diagnostics>
    <sch:diagnostic id="libDiag" role="info">
      Library diagnostic: <sch:value-of select="$libRoot"/>.
    </sch:diagnostic>
  </sch:diagnostics>
  <sch:properties>
    <sch:property id="libProp1" role="info">
      Library property text with <sch:name/>.
    </sch:property>
  </sch:properties>
</sch:library>
