<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 12.0</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2023-02-10T17:48:54.8707144+01:00</ns1:created>
  </ns0:Description>
  <output indent="yes" />
  <template match="root()">
    <variable as="element()?" name="metadata">
      <ns0:metadata xmlns:ns0="http://purl.oclc.org/dsdl/svrl">
        <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
          <ns1:Agent>
            <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">
              <value-of select="(system-property('xsl:product-name'), system-property('xsl:product-version'))" separator="/" />
            </ns2:prefLabel>
          </ns1:Agent>
        </ns1:creator>
        <ns1:created xmlns:ns1="http://purl.org/dc/terms/">
          <value-of select="current-dateTime()" />
        </ns1:created>
        <ns1:source xmlns:ns1="http://purl.org/dc/terms/">
          <ns2:Description xmlns:ns2="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <ns1:creator>
              <ns1:Agent>
                <ns3:prefLabel xmlns:ns3="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 12.0</ns3:prefLabel>
                <ns3:schxslt.compile.typed-variables xmlns:ns3="https://doi.org/10.5281/zenodo.1495494#">true</ns3:schxslt.compile.typed-variables>
              </ns1:Agent>
            </ns1:creator>
            <ns1:created>2023-02-10T17:48:54.8707144+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w170aac11" />
      </ns0:report>
    </variable>
    <variable as="node()*" name="schxslt:report">
      <sequence select="$metadata" />
      <for-each select="$report/schxslt:document">
        <for-each select="schxslt:pattern">
          <sequence select="node()" />
          <sequence select="../schxslt:rule[@pattern = current()/@id]/node()" />
        </for-each>
      </for-each>
    </variable>
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="Schema for Schematron Validation Report Language">
      <ns0:text>The Schematron Validation Report Language is a simple language 
        for implementations to use to compare their conformance. It is 
        basically a list of all the assertions that fail when validating 
        a document, in any order, together with other information such 
    as which rules fire.
    </ns0:text>
      <ns0:text>This schema can be used to validate SVRL documents, and provides
        examples of the use of abstract rules and abstract patterns.</ns0:text>
      <ns0:ns-prefix-in-attribute-values prefix="svrl" uri="http://purl.oclc.org/dsdl/svrl" />
      <ns0:ns-prefix-in-attribute-values prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />
      <sequence select="$schxslt:report" />
    </ns0:schematron-output>
  </template>
  <template match="text() | @*" mode="#all" priority="-10" />
  <template match="/" mode="#all" priority="-10">
    <apply-templates mode="#current" select="node()" />
  </template>
  <template match="*" mode="#all" priority="-10">
    <apply-templates mode="#current" select="@*" />
    <apply-templates mode="#current" select="node()" />
  </template>
  <template name="w170aac11">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w170aac11">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" name="Elements">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w170aac13">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" name="Unique Ids">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w170aac15">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" name="Required Attributes">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w170aac17">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" name="Required Attributes">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w170aac19">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" name="Required Attributes">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w170aac21">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" name="Required Attributes">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w170aac23">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" name="Required Attributes">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w170aac11" select="root()" />
    </ns0:document>
  </template>
  <template match="svrl:schematron-output" mode="w170aac11" priority="13">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <comment>WARNING: Rule for context "svrl:schematron-output" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:schematron-output</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:schematron-output</attribute>
          </ns1:fired-rule>
          <if test="not(not(../*))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">not(../*)</attribute>
              <ns1:text>
                The <value-of select="name()" /> element is the root element.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(svrl:text)+ count(svrl:ns-prefix-in-attribute-values) +   count(svrl:active-pattern)+                     count(svrl:fired-rule) + count(svrl:failed-assert)+                     count(svrl:successful-report) = count(*))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(svrl:text)+ count(svrl:ns-prefix-in-attribute-values) +   count(svrl:active-pattern)+                     count(svrl:fired-rule) + count(svrl:failed-assert)+                     count(svrl:successful-report) = count(*)</attribute>
              <ns1:text>
                <value-of select="name()" /> may only contain the following elements: 
                text, ns-prefix-in-attribute-values, active-pattern, fired-rule, failed-assert 
                and successful-report.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(svrl:active-pattern)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">svrl:active-pattern</attribute>
              <ns1:text>
                <value-of select="name()" /> should have at least one active pattern.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="svrl:text" mode="w170aac11" priority="12">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <comment>WARNING: Rule for context "svrl:text" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:text</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:text</attribute>
          </ns1:fired-rule>
          <if test="not(count(*)=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(*)=0</attribute>
              <ns1:text> 
                The <value-of select="name()" /> element should not contain any elements.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="svrl:diagnostic-reference" mode="w170aac11" priority="11">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <comment>WARNING: Rule for context "svrl:diagnostic-reference" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:diagnostic-reference</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:diagnostic-reference</attribute>
          </ns1:fired-rule>
          <if test="not(count(*)=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(*)=0</attribute>
              <ns1:text> 
                The <value-of select="name()" /> element should not contain any elements.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(string-length(@diagnostic) > 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length(@diagnostic) &gt; 0</attribute>
              <ns1:text>
                <value-of select="name()" /> should have a diagnostic attribute, 
                giving the id of the diagnostic.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="svrl:ns-prefix-in-attribute-values" mode="w170aac11" priority="10">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <comment>WARNING: Rule for context "svrl:ns-prefix-in-attribute-values" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:ns-prefix-in-attribute-values</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:ns-prefix-in-attribute-values</attribute>
          </ns1:fired-rule>
          <if test="not(../svrl:schematron-output)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">../svrl:schematron-output</attribute>
              <ns1:text>
                The <value-of select="name()" /> element is a child of schematron-output.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(string-length(.) = 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length(.) = 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should be empty.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(*)=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(*)=0</attribute>
              <ns1:text> 
                The <value-of select="name()" /> element should not contain any elements.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(following-sibling::svrl:active-pattern                        or following-sibling::svrl:ns-prefix-in-attribute-value)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">following-sibling::svrl:active-pattern                        or following-sibling::svrl:ns-prefix-in-attribute-value</attribute>
              <ns1:text> 
                A <value-of select="name()" /> comes before an active-pattern or another 
                ns-prefix-in-attribute-values element.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="svrl:active-pattern" mode="w170aac11" priority="9">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <comment>WARNING: Rule for context "svrl:active-pattern" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:active-pattern</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:active-pattern</attribute>
          </ns1:fired-rule>
          <if test="not(../svrl:schematron-output)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">../svrl:schematron-output</attribute>
              <ns1:text>
                The <value-of select="name()" /> element is a child of schematron-output.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(string-length(.) = 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length(.) = 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should be empty.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(*)=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(*)=0</attribute>
              <ns1:text> 
                The <value-of select="name()" /> element should not contain any elements.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="svrl:fired-rule" mode="w170aac11" priority="8">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <comment>WARNING: Rule for context "svrl:fired-rule" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:fired-rule</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:fired-rule</attribute>
          </ns1:fired-rule>
          <if test="not(../svrl:schematron-output)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">../svrl:schematron-output</attribute>
              <ns1:text>
                The <value-of select="name()" /> element is a child of schematron-output.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(string-length(.) = 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length(.) = 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should be empty.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(*)=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(*)=0</attribute>
              <ns1:text> 
                The <value-of select="name()" /> element should not contain any elements.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(preceding-sibling::active-pattern |                     preceding-sibling::svrl:fired-rule |                     preceding-sibling::svrl:failed-assert |                     preceding-sibling::svrl:successful-report)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">preceding-sibling::active-pattern |                     preceding-sibling::svrl:fired-rule |                     preceding-sibling::svrl:failed-assert |                     preceding-sibling::svrl:successful-report</attribute>
              <ns1:text>
                A <value-of select="name()" /> comes after an active-pattern, an empty 
                fired-rule, a failed-assert or a successful report.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(string-length(@context) > 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length(@context) &gt; 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should have a context attribute 
                giving the current context, in simple XPath format.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="svrl:failed-assert | svrl:successful-report" mode="w170aac11" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <comment>WARNING: Rule for context "svrl:failed-assert | svrl:successful-report" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:failed-assert | svrl:successful-report</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">svrl:failed-assert | svrl:successful-report</attribute>
          </ns1:fired-rule>
          <if test="not(../svrl:schematron-output)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">../svrl:schematron-output</attribute>
              <ns1:text>
                The <value-of select="name()" /> element is a child of schematron-output.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(svrl:diagnostic-reference) + count(svrl:text) = count(*))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(svrl:diagnostic-reference) + count(svrl:text) = count(*)</attribute>
              <ns1:text> 
                The <value-of select="name()" /> element should only contain a text element 
                and diagnostic reference elements.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(svrl:text) = 1)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(svrl:text) = 1</attribute>
              <ns1:text> 
                The <value-of select="name()" /> element should only contain a text element.
            </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(preceding-sibling::svrl:fired-rule |                 preceding-sibling::svrl:failed-assert |                 preceding-sibling::svrl:successful-report)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">preceding-sibling::svrl:fired-rule |                 preceding-sibling::svrl:failed-assert |                 preceding-sibling::svrl:successful-report</attribute>
              <ns1:text> 
                A <value-of select="name()" /> comes after a fired-rule, a failed-assert or a
                successful-report.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="*" mode="w170aac11" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <comment>WARNING: Rule for context "*" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">*</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">*</attribute>
          </ns1:fired-rule>
          <if test="true()">
            <ns1:successful-report xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">true()</attribute>
              <ns1:text>
                An unknown <value-of select="name()" /> element has been used.
            </ns1:text>
            </ns1:successful-report>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="*[@id]" mode="w170aac11" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac13">
          <comment>WARNING: Rule for context "*[@id]" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">*[@id]</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">*[@id]</attribute>
          </ns1:fired-rule>
          <if test="not(not(preceding::*[@id=./@id][1]))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">not(preceding::*[@id=./@id][1])</attribute>
              <ns1:text> 
                Id attributes should be unique in a document.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match=" svrl:diagnostic-reference " mode="w170aac11" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac15">
          <comment>WARNING: Rule for context " svrl:diagnostic-reference " shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:diagnostic-reference </attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:diagnostic-reference </attribute>
          </ns1:fired-rule>
          <if test="not(string-length( @diagnostic ) > 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length( @diagnostic ) &gt; 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should have a 
                <value-of select="fn:name(@diagnostic)" /> attribute.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match=" svrl:failed-assert | svrl:successful-report " mode="w170aac11" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac17']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac17">
          <comment>WARNING: Rule for context " svrl:failed-assert | svrl:successful-report " shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:failed-assert | svrl:successful-report </attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac17">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:failed-assert | svrl:successful-report </attribute>
          </ns1:fired-rule>
          <if test="not(string-length( @location ) > 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length( @location ) &gt; 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should have a 
                <value-of select="fn:name(@location)" /> attribute.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac17')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match=" svrl:failed-assert | svrl:successful-report " mode="w170aac11" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac19']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac19">
          <comment>WARNING: Rule for context " svrl:failed-assert | svrl:successful-report " shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:failed-assert | svrl:successful-report </attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac19">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:failed-assert | svrl:successful-report </attribute>
          </ns1:fired-rule>
          <if test="not(string-length( @test ) > 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length( @test ) &gt; 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should have a 
                <value-of select="fn:name(@test)" /> attribute.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac19')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match=" svrl:ns-prefix-in-attribute-values " mode="w170aac11" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac21']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac21">
          <comment>WARNING: Rule for context " svrl:ns-prefix-in-attribute-values " shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:ns-prefix-in-attribute-values </attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac21">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:ns-prefix-in-attribute-values </attribute>
          </ns1:fired-rule>
          <if test="not(string-length( @uri ) > 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length( @uri ) &gt; 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should have a 
                <value-of select="fn:name(@uri)" /> attribute.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac21')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match=" svrl:ns-prefix-in-attribute-values " mode="w170aac11" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w170aac23']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac23">
          <comment>WARNING: Rule for context " svrl:ns-prefix-in-attribute-values " shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:ns-prefix-in-attribute-values </attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w170aac23">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context"> svrl:ns-prefix-in-attribute-values </attribute>
          </ns1:fired-rule>
          <if test="not(string-length( @prefix ) > 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">string-length( @prefix ) &gt; 0</attribute>
              <ns1:text>
                The <value-of select="name()" /> element should have a 
                <value-of select="fn:name(@prefix)" /> attribute.
            </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w170aac23')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <function as="xs:string" name="schxslt:location">
    <param as="node()" name="node" />
    <variable as="xs:string*" name="segments">
      <for-each select="($node/ancestor-or-self::node())">
        <variable name="position">
          <number level="single" />
        </variable>
        <choose>
          <when test=". instance of element()">
            <value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')" />
          </when>
          <when test=". instance of attribute()">
            <value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))" />
          </when>
          <when test=". instance of processing-instruction()">
            <value-of select="concat('processing-instruction(&quot;', name(.), '&quot;)[', $position, ']')" />
          </when>
          <when test=". instance of comment()">
            <value-of select="concat('comment()[', $position, ']')" />
          </when>
          <when test=". instance of text()">
            <value-of select="concat('text()[', $position, ']')" />
          </when>
          <otherwise />
        </choose>
      </for-each>
    </variable>
    <value-of select="concat('/', string-join($segments, '/'))" />
  </function>
</transform>
