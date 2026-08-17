<?xml version="1.0" encoding="UTF-8"?>
<!--
  Reduced test case for https://github.com/phax/ph-schematron/issues/189
  Per ISO 19757-3, a <let> without a 'value' attribute takes its expression from the
  element content. All three scopes (schema, pattern and rule) are covered here.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">
  <ns prefix="hl7" uri="urn:hl7-org:v3"/>

  <!-- Global <let> with the expression in the element content -->
  <let name="docCode">string(/hl7:ClinicalDocument/hl7:code/@code)</let>

  <pattern>
    <!-- Pattern level <let> with the expression in the element content -->
    <let name="obsCount">count(//hl7:observation)</let>

    <rule context="//hl7:observation">
      <!-- Rule level <let> with the expression in the element content -->
      <let name="valueCount">count(hl7:value)</let>
      <assert test="$valueCount &gt; 0">Observation without hl7:value in document '<value-of select="$docCode"/>' (<value-of select="$obsCount"/> observations in total)</assert>
    </rule>
  </pattern>
</schema>
