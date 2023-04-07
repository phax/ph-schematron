<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:08.447+01:00</ns1:created>
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
                <ns3:prefLabel xmlns:ns3="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns3:prefLabel>
                <ns3:schxslt.compile.typed-variables xmlns:ns3="https://doi.org/10.5281/zenodo.1495494#">true</ns3:schxslt.compile.typed-variables>
              </ns1:Agent>
            </ns1:creator>
            <ns1:created>2022-11-17T08:43:08.447+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w1001aac11" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="NONAT T14 bound to UBL">
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
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
  <template name="w1001aac11">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w1001aac11">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="UBL-T14" name="UBL-T14">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w1001aac11" select="root()" />
    </ns0:document>
  </template>
  <template match="//cac:AccountingCustomerParty/cac:Party" mode="w1001aac11" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w1001aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w1001aac11">
          <comment>WARNING: Rule for context "//cac:AccountingCustomerParty/cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty/cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w1001aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not((cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))</attribute>
              <ns1:text>[NONAT-T14-R004]-A customer postal address in an invoice MUST contain at least, Street name, city name, zip code and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w1001aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingSupplierParty/cac:Party" mode="w1001aac11" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w1001aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w1001aac11">
          <comment>WARNING: Rule for context "//cac:AccountingSupplierParty/cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty/cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w1001aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not((cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))</attribute>
              <ns1:text>[NONAT-T14-R001]-PartyLegalEntity for AccountingSupplierParty MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))</attribute>
              <ns1:text>[NONAT-T14-R003]-A supplier postal address in an invoice MUST contain at least, Street name, city name, zip code and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w1001aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:CreditNoteLine" mode="w1001aac11" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w1001aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w1001aac11">
          <comment>WARNING: Rule for context "//cac:CreditNoteLine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:CreditNoteLine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w1001aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:CreditNoteLine</attribute>
          </ns1:fired-rule>
          <if test="not(cbc:CreditedQuantity and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">cbc:CreditedQuantity and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))</attribute>
              <ns1:text>[NONAT-T14-R002]-Each credit note line MUST contain a quantity according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 3" </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w1001aac11')" />
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
