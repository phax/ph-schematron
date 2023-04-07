<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 12.0</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2023-02-10T17:48:54.6803007+01:00</ns1:created>
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
            <ns1:created>2023-02-10T17:48:54.6803007+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w116aac15" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl">
      <ns0:ns-prefix-in-attribute-values prefix="ead" uri="urn:isbn:1-931666-22-9" />
      <ns0:ns-prefix-in-attribute-values prefix="mets" uri="http://www.loc.gov/METS/" />
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
  <template name="w116aac15">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w116aac15">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="Co-OccurrenceConstraints" name="Co-OccurrenceConstraints">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w116aac17">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="DMDID-IDIDREF" name="DMDID-IDIDREF">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w116aac15" select="root()" />
    </ns0:document>
  </template>
  <template match="mets:mdWrap" mode="w116aac15" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w116aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w116aac15">
          <comment>WARNING: Rule for context "mets:mdWrap" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">mets:mdWrap</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w116aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">mets:mdWrap</attribute>
          </ns1:fired-rule>
          <if test="not((contains(string(@MDTYPE), 'OTHER')) and (normalize-space(@OTHERMDTYPE)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">(contains(string(@MDTYPE), 'OTHER')) and (normalize-space(@OTHERMDTYPE))</attribute>
              <ns1:text>If the value of a MDTYPE attribute is
                "OTHER', then the OTHERMDTYPE attribute must be used </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w116aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="mets:mdRef" mode="w116aac15" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w116aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w116aac15">
          <comment>WARNING: Rule for context "mets:mdRef" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">mets:mdRef</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w116aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">mets:mdRef</attribute>
          </ns1:fired-rule>
          <if test="not((contains(string(@LOCTYPE), 'OTHER')) and (normalize-space(@OTHERLOCTYPE)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">(contains(string(@LOCTYPE), 'OTHER')) and (normalize-space(@OTHERLOCTYPE))</attribute>
              <ns1:text>If the value of a LOCTYPE attribute is
                "OTHER", then the OTHERLOCTYPE attribute must be used </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((contains(string(@MDTYPE), 'OTHER')) and (normalize-space(@OTHERMDTYPE)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">(contains(string(@MDTYPE), 'OTHER')) and (normalize-space(@OTHERMDTYPE))</attribute>
              <ns1:text>If the value of a MDTYPE attribute is
                "OTHER', then the OTHERMDTYPE attribute must be used </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w116aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="mets:*[@DMDID]" mode="w116aac15" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w116aac17']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w116aac17">
          <comment>WARNING: Rule for context "mets:*[@DMDID]" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">mets:*[@DMDID]</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w116aac17">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">mets:*[@DMDID]</attribute>
          </ns1:fired-rule>
          <if test="not(count(                 ancestor::mets:mets/mets:dmdSec/@ID[                  contains( concat(' ', ./@DMDID, ' '),                            concat(' ', normalize-space(), ' ')                             )                  ] )                 = string-length(normalize-space(@DMDID)) - string-length(translate(normalize-space(@DMDID), ' ','')) + 1)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" location="{schxslt:location(.)}">
              <attribute name="test">count(                 ancestor::mets:mets/mets:dmdSec/@ID[                  contains( concat(' ', ./@DMDID, ' '),                            concat(' ', normalize-space(), ' ')                             )                  ] )                 = string-length(normalize-space(@DMDID)) - string-length(translate(normalize-space(@DMDID), ' ','')) + 1</attribute>
              <ns1:diagnostic-reference diagnostic="DMDID-en">
                <ns1:text id="DMDID-en">An IDREF in a DMDID attribute must be the value of a
            dmdSec/@ID in the same METS document</ns1:text>
              </ns1:diagnostic-reference>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w116aac17')" />
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
