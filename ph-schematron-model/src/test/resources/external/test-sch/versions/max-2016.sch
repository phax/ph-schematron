<?xml version="1.0" encoding="UTF-8"?>
<!--
  Maximum-features Schematron schema for ISO/IEC 19757-3:2016 (v2).
  Includes everything in max-2006.sch PLUS the new 2016 features:
    - queryBinding="xslt2"  (xslt2 reserved name added in 2016)
    - <pattern documents="...">
    - <extends href="..."> (alternative to @rule)
    - <let> without @value (foreign body content)
    - <properties> / <property>
    - properties IDREFS on <assert>/<report>
    - <p> as child of <rule>
  Intentionally absent (2020 / 2025 features):
    - <diagnostic role="...">
    - schematronEdition / group / library / rules / severity / visit-each /
      from / when / let@as / multi-token flag / dynamic content in dir/emph/span
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:ext="http://example.com/ext"
            id="m2016"
            schemaVersion="2.0"
            defaultPhase="phaseA"
            queryBinding="xslt2">
  <ext:metadata edition="2016"/>
  <sch:title>Maximum 2016 features</sch:title>
  <sch:ns prefix="x" uri="http://example.com/x"/>
  <sch:p>Schema-level paragraph.</sch:p>
  <sch:let name="rootName" value="name(/*)"/>
  <sch:phase id="phaseA">
    <sch:active pattern="patAbs"/>
  </sch:phase>
  <!-- Abstract pattern -->
  <sch:pattern abstract="true" id="patAbs">
    <sch:title>Abstract pattern</sch:title>
    <sch:rule context="$ctx" id="absMain" flag="warn">
      <sch:assert test="@id" id="absA" diagnostics="diag1" properties="prop1">
        <sch:value-of select="@id"/> required for <sch:name/>.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!-- is-a pattern -->
  <sch:pattern is-a="patAbs" id="patIsa">
    <sch:param name="ctx" value="x:thing"/>
  </sch:pattern>
  <!-- Concrete pattern using 2016 'documents' attribute -->
  <sch:pattern id="patConcrete" documents="@subordinate-iri">
    <sch:p>Pattern prose</sch:p>
    <sch:rule context="x:item" id="ruleConcrete" flag="info">
      <sch:p>Inline rule paragraph (NEW in 2016)</sch:p>
      <sch:let name="local" value="@id"/>
      <sch:assert test="$local" id="assConcrete" properties="prop1 prop2">
        <sch:emph>Required:</sch:emph> id missing on <sch:name/>.
      </sch:assert>
      <sch:report test="not(@id)" id="rptConcrete" properties="prop2">
        <sch:dir value="ltr">Reporting</sch:dir>: <sch:span class="hi">missing id</sch:span>
      </sch:report>
      <!-- 2016 href alternative on extends -->
      <sch:extends href="abstract-rules.xml#absRule"/>
    </sch:rule>
  </sch:pattern>
  <!-- 2016 let without @value (body content as foreign element) -->
  <sch:pattern id="patBodyLet">
    <sch:rule context="/">
      <sch:let name="dynLet">
        <ext:expression>concat('a','b')</ext:expression>
      </sch:let>
      <sch:assert test="$dynLet">computed let body required</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:diagnostics>
    <sch:diagnostic id="diag1">
      Diagnostic: <sch:value-of select="$rootName"/>.
    </sch:diagnostic>
  </sch:diagnostics>
  <!-- 2016 properties container -->
  <sch:properties>
    <sch:property id="prop1" role="info" scheme="ISO 4217">
      <sch:value-of select="."/>
    </sch:property>
    <sch:property id="prop2">
      Static property text with <sch:name/>.
    </sch:property>
  </sch:properties>
</sch:schema>
