<?xml version="1.0" encoding="UTF-8"?>
<!--
  Reduced test case for https://github.com/phax/ph-schematron/issues/189
  A <let> without a 'value' attribute, the body of which is an XSLT sequence constructor.
  The <let> is taken verbatim from the reported Schematron of the Italian Ministry of Health.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        queryBinding="xslt2">
  <ns prefix="hl7" uri="urn:hl7-org:v3"/>

  <pattern>
    <rule context="hl7:observation">
      <let name="errorPathObs">
        <xsl:for-each select="ancestor::*[not(self::hl7:ClinicalDocument)]">
          <xsl:value-of select="concat('/', name())"/>
        </xsl:for-each>
      </let>
      <assert test="count(hl7:value) &gt; 0">Observation without hl7:value at <value-of select="$errorPathObs"/></assert>
    </rule>
  </pattern>
</schema>
