<?xml version="1.0" encoding="UTF-8"?>
<!--
  Maximum-features Schematron schema for ISO/IEC 19757-3:2006 (v1).
  Uses every element / attribute permitted by the v1 RNC, plus a simple foreign element.
  Notably absent (because they were added later):
    - <pattern documents="...">                              (2016)
    - <extends href="...">                                    (2016)
    - <let> without @value                                    (2016)
    - <properties> / <property> / @properties on assert/report (2016)
    - <p> as child of <rule>                                  (2016)
    - <diagnostic role="...">                                 (2020 RNC)
    - schematronEdition / group / library / rules / severity / visit-each /
      from / when / let@as / multi-token flag / dynamic content in dir/emph/span
      (2025)
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:ext="http://example.com/ext"
            id="m2006"
            schemaVersion="1.0"
            defaultPhase="phaseA"
            queryBinding="xslt"
            xml:lang="en">
  <ext:metadata author="ph-schematron"/>
  <sch:title>Maximum 2006 features</sch:title>
  <sch:ns prefix="x" uri="http://example.com/x"/>
  <sch:p>Schema-level paragraph before any pattern.</sch:p>
  <sch:let name="rootName" value="name(/*)"/>
  <sch:phase id="phaseA" icon="phase.png" see="http://example.com/see" fpi="-//phase//A">
    <sch:p>Phase paragraph.</sch:p>
    <sch:let name="phaseLet" value="1"/>
    <sch:active pattern="patAbs"/>
    <sch:active pattern="patConcrete"/>
  </sch:phase>
  <!-- Abstract pattern -->
  <sch:pattern abstract="true" id="patAbs" icon="abs.png">
    <sch:title>Abstract pattern</sch:title>
    <sch:p>Abstract pattern prose.</sch:p>
    <sch:rule context="$ctx" id="absMainRule" flag="warn">
      <sch:assert test="@id" id="absA" diagnostics="diag1" subject="@id">
        <sch:value-of select="@id"/> required for <sch:name path="."/>.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!-- is-a instantiation -->
  <sch:pattern is-a="patAbs" id="patIsa">
    <sch:param name="ctx" value="x:thing"/>
  </sch:pattern>
  <!-- Concrete pattern -->
  <sch:pattern id="patConcrete" icon="cp.png">
    <sch:title>Concrete pattern</sch:title>
    <sch:rule context="x:item" id="ruleConcrete" flag="info">
      <sch:let name="local" value="@id"/>
      <sch:assert test="$local" id="assConcrete" flag="critical" role="primary">
        <sch:emph>Required:</sch:emph> id missing on <sch:name/>.
      </sch:assert>
      <sch:report test="not(@id)" id="rptConcrete">
        <sch:dir value="ltr">Reporting</sch:dir>: <sch:span class="hi">missing id</sch:span>
      </sch:report>
      <sch:extends rule="absInline"/>
    </sch:rule>
    <sch:rule abstract="true" id="absInline">
      <sch:assert test="true()">abstract assertion</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:p>Closing schema paragraph.</sch:p>
  <sch:diagnostics>
    <sch:diagnostic id="diag1">
      Diagnostic text for assert: <sch:value-of select="$rootName"/>.
    </sch:diagnostic>
  </sch:diagnostics>
</sch:schema>
