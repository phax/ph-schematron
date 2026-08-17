<?xml version="1.0" encoding="UTF-8"?>
<!--
  Test case for https://github.com/phax/ph-schematron/issues/186
  The pure engine can only evaluate Schematron elements and XPath expressions - all foreign
  (non-Schematron) elements are ignored and must therefore be reported as warnings.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        queryBinding="xpath2">

  <!-- Foreign element on schema level -->
  <xsl:function name="local"/>

  <pattern>
    <rule context="/root">
      <!-- Foreign element on rule level -->
      <xsl:variable name="v" select="1"/>
      <assert test="count(item) &gt; 0">At least one item is required</assert>
    </rule>
  </pattern>
</schema>
