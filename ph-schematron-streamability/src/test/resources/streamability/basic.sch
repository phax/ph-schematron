<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2014-2026 Philip Helger (www.helger.com)
    philip[at]helger[dot]com

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
  <ns prefix="cbc" uri="urn:cbc" />
  <ns prefix="cac" uri="urn:cac" />
  <ns prefix="u" uri="urn:u" />
  <let name="currency" value="'EUR'" />
  <let name="codes" value="document('codes.xml')//code" />
  <let name="invoiceID" value="/cac:Invoice/cbc:ID" />
  <pattern id="lines">
    <rule id="line" context="cac:InvoiceLine">
      <assert id="attr" test="@id">The line needs an ID</assert>
      <assert id="two-children" test="cbc:A = 'x' or cbc:B = 'y'">A or B</assert>
      <report id="global-path" test="//cbc:ID">Any ID</report>
      <assert id="constant-let" test="cbc:Amount/@currencyID = $currency">Currency</assert>
      <assert id="other-document" test="cbc:Code = $codes">Code</assert>
      <assert id="ancestor" test="ancestor::cac:Invoice/@version">Version</assert>
      <assert id="parent-child" test="../cbc:ID">Parent ID</assert>
      <assert id="document-element" test="/cac:Invoice/@version">Invoice version</assert>
      <assert id="first-pass-let" test="cbc:ID != $invoiceID">Invoice ID</assert>
      <assert id="first-pass-let-path" test="$invoiceID/@schemeID">Invoice ID scheme</assert>
    </rule>
    <rule id="party" context="cac:Party">
      <let name="name" value="cbc:Name" />
      <let name="len" value="string-length($name)" />
      <assert id="rule-let" test="$len &gt; 0">Name <value-of select="$name" /></assert>
      <assert id="diagnostic" test="@id" diagnostics="d1">Party ID</assert>
      <assert id="name" test="@id"><name path=".." /> has a party</assert>
    </rule>
    <rule id="parent-let" context="cac:Contact">
      <let name="p" value=".." />
      <assert id="parent-let-test" test="$p/cbc:Name">Parent name</assert>
    </rule>
  </pattern>
  <pattern id="functions">
    <rule id="tax" context="cac:TaxTotal">
      <assert id="value-of" test="@id">Total <value-of select="preceding-sibling::cac:TaxTotal/@id" /></assert>
      <assert id="unknown-function" test="u:check(@id)">Check</assert>
      <assert id="declared-function" test="u:absorbing(cbc:Amount)">Absorbing</assert>
      <assert id="key" test="key('k', @id)">Key</assert>
      <assert id="static-error" test="cbc:X[">Broken</assert>
    </rule>
    <rule id="predicate" context="cac:Line[cbc:Q &lt; 0]">
      <assert id="in-predicate-rule" test="@id">ID</assert>
    </rule>
  </pattern>
  <pattern abstract="true" id="abstract-required">
    <rule context="$element">
      <assert test="$child">The child is required</assert>
    </rule>
  </pattern>
  <pattern id="required-name" is-a="abstract-required">
    <param name="element" value="cac:Item" />
    <param name="child" value="cbc:Name" />
  </pattern>
  <diagnostics>
    <diagnostic id="d1">All IDs: <value-of select="//cbc:ID" /></diagnostic>
  </diagnostics>
  <xsl:key name="k" match="cac:X" use="@id" />
  <xsl:function name="u:absorbing" streamability="absorbing">
    <xsl:param name="a" />
    <xsl:sequence select="string($a)" />
  </xsl:function>
</schema>
