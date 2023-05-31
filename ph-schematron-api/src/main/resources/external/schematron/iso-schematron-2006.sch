<?xml version="1.0" encoding="utf-8"?>
<!--
(c) International Organization for Standardization 2005.
Permission to copy in any form is granted for use with conforming
SGML systems and applications as defined in ISO 8879,
provided this notice is included in all copies.
-->
<!-- [PH] added queryBinding -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xml:lang="en" queryBinding="xslt2">
  <sch:title>Schema for Schematron Validation Report Language</sch:title>
  <sch:ns prefix="svrl" uri="http://purl.oclc.org/dsdl/svrl" />
  <sch:p>The Schematron Validation Report Language is a simple language
    for implementations to use to compare their
    conformance. It is
    basically a list of all the assertions that fail when validating
    a document, in any order, together
    with other information such
    as which rules fire.
  </sch:p>
  <sch:p>This schema can be used to validate SVRL documents, and provides
    examples of the use of abstract rules and
    abstract patterns.
  </sch:p>
  <sch:pattern>
    <sch:title>Elements</sch:title>
    <!--Abstract Rules -->
    <sch:rule abstract="true" id="second-level">
      <sch:assert test="../svrl:schematron-output">
        The <sch:name /> element is a child of schematron-output.
      </sch:assert>
    </sch:rule>
    <sch:rule abstract="true" id="childless">
      <sch:assert test="count(*)=0">
        The <sch:name /> element should not contain any elements.
      </sch:assert>
    </sch:rule>
    <sch:rule abstract="true" id="empty">
      <sch:extends rule="childless" />
      <!-- [PH] changed to normalize-space -->
      <sch:assert test="string-length(normalize-space(.)) = 0">
        The <sch:name /> element should be empty.
      </sch:assert>
    </sch:rule>
    
    <!-- Rules-->
    <sch:rule context="svrl:schematron-output">
      <sch:assert test="not(../*)">
        The <sch:name /> element is the root element.
      </sch:assert>
      <sch:assert test="count(svrl:text) + 
                        count(svrl:ns-prefix-in-attribute-values) +
                        count(svrl:active-pattern) +
                        count(svrl:fired-rule) + 
                        count(svrl:failed-assert)+
                        count(svrl:successful-report) = count(*)">
        <sch:name /> may only contain the following elements: text, ns-prefix-in-attribute-values, active-pattern, fired-rule, failed-assert and successful-report.
      </sch:assert>
      <sch:assert test="svrl:active-pattern">
        <sch:name /> should have at least one active pattern.
      </sch:assert>
    </sch:rule>
    <sch:rule context="svrl:text">
      <sch:extends rule="childless" />
    </sch:rule>
    <sch:rule context="svrl:diagnostic-reference">
      <sch:extends rule="childless" />
      <sch:assert test="string-length(@diagnostic) &gt; 0">
        <sch:name /> should have a diagnostic attribute, giving the id of the diagnostic.
      </sch:assert>
    </sch:rule>
    <sch:rule context="svrl:ns-prefix-in-attribute-values">
      <sch:extends rule="second-level" />
      <sch:extends rule="empty" />
      <sch:assert test="following-sibling::svrl:active-pattern or following-sibling::svrl:ns-prefix-in-attribute-value">
        A <sch:name /> comes before an active-pattern or another ns-prefix-in-attribute-values element.
      </sch:assert>
    </sch:rule>
    <sch:rule context="svrl:active-pattern">
      <sch:extends rule="second-level" />
      <sch:extends rule="empty" />
    </sch:rule>
    <sch:rule context="svrl:fired-rule">
      <sch:extends rule="second-level" />
      <sch:extends rule="empty" />
      <sch:assert test="preceding-sibling::active-pattern |
                        preceding-sibling::svrl:fired-rule |
                        preceding-sibling::svrl:failed-assert |
                        preceding-sibling::svrl:successful-report">
        A <sch:name /> comes after an active-pattern, an empty fired-rule, a failed-assert or a successful report.
      </sch:assert>
      <sch:assert test="string-length(@context) &gt; 0">
        The <sch:name /> element should have a context attribute giving the current context, in simple XPath format.
      </sch:assert>
    </sch:rule>
    <sch:rule context="svrl:failed-assert | svrl:successful-report">
      <sch:extends rule="second-level" />
      <sch:assert test="count(svrl:diagnostic-reference) + count(svrl:text) = count(*)">
        The <sch:name /> element should only contain a text element and diagnostic reference elements.
      </sch:assert>
      <sch:assert test="count(svrl:text) = 1">
        The <sch:name /> element should only contain a text element.
      </sch:assert>
      <sch:assert test="preceding-sibling::svrl:fired-rule |
                        preceding-sibling::svrl:failed-assert |
                        preceding-sibling::svrl:successful-report">
        A <sch:name /> comes after a fired-rule, a failed-assert or a successful-report.
      </sch:assert>
    </sch:rule>
    <!-- Catch-all rule-->
    <sch:rule context="*">
      <sch:report test="true()">
        An unknown <sch:name /> element has been used.
      </sch:report>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern>
    <sch:title>Unique Ids</sch:title>
    <sch:rule context="*[@id]">
      <!-- current() is an XSLT function -->
      <!-- [PH] added trailing ")" -->
      <sch:assert test="not(preceding::*[@id=current()/@id][1])">
        Id attributes should be unique in a document.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern abstract="true" id="requiredAttribute">
    <sch:title>Required Attributes</sch:title>
    <sch:rule context=" $context ">
      <sch:assert test="string-length( $attribute ) &gt; 0">
        The <sch:name /> element should have a <sch:value-of select="$attribute/name()" /> attribute.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!-- [PH] added id attribute -->
  <sch:pattern is-a="requiredAttribute" id="ra1">
    <sch:param name="context" value="svrl:diagnostic-reference" />
    <sch:param name="attribute" value="@diagnostic" />
  </sch:pattern>
  <!-- [PH] added id attribute -->
  <sch:pattern is-a="requiredAttribute" id="ra2">
    <!-- [PH] changed "or" to "|" -->
    <sch:param name="context" value="svrl:failed-assert | svrl:successful-report" />
    <sch:param name="attribute" value="@location" />
  </sch:pattern>
  <!-- [PH] added id attribute -->
  <sch:pattern is-a="requiredAttribute" id="ra3">
    <!-- [PH] changed "or" to "|" -->
    <sch:param name="context" value="svrl:failed-assert | svrl:successful-report" />
    <sch:param name="attribute" value="@test" />
  </sch:pattern>
  <!-- [PH] added id attribute -->
  <sch:pattern is-a="requiredAttribute" id="ra4">
    <sch:param name="context" value="svrl:ns-prefix-in-attribute-values" />
    <sch:param name="attribute" value="@uri" />
  </sch:pattern>
  <!-- [PH] added id attribute -->
  <sch:pattern is-a="requiredAttribute" id="ra5">
    <sch:param name="context" value="svrl:ns-prefix-in-attribute-values" />
    <sch:param name="attribute" value="@prefix" />
  </sch:pattern>
</sch:schema>
