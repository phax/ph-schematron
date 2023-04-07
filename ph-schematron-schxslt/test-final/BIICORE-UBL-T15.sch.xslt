<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:07.008+01:00</ns1:created>
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
            <ns1:created>2022-11-17T08:43:07.008+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w382aac11" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="BIICORE T15 bound to UBL">
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
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
  <template name="w382aac11">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w382aac11">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="UBL-T15" name="UBL-T15">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w382aac11" select="root()" />
    </ns0:document>
  </template>
  <template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" mode="w382aac11" priority="8">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:AccountingCustomerParty/cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:AccountingCustomerParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not(count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R398]-Element 'PartyIdentification' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R399]-Element 'PartyName' must occur exactly 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R400]-Element 'PartyTaxScheme' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:PayeeParty" mode="w382aac11" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:PayeeParty" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:PayeeParty</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:PayeeParty</attribute>
          </ns1:fired-rule>
          <if test="not(count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R413]-Element 'PartyIdentification' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cac:PartyName)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PartyName)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R414]-Element 'PartyName' may occur at maximum 1 times</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount" mode="w382aac11" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount</attribute>
          </ns1:fired-rule>
          <if test="not(count(cbc:ID)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cbc:ID)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R415]-Element 'ID' must occur exactly 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:InvoiceLine" mode="w382aac11" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:InvoiceLine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:InvoiceLine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:InvoiceLine</attribute>
          </ns1:fired-rule>
          <if test="not(count(cac:TaxTotal)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:TaxTotal)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R405]-Element 'TaxTotal' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cac:Price)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:Price)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R406]-Element 'Price' must occur exactly 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" mode="w382aac11" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:AccountingSupplierParty/cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:AccountingSupplierParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not(count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R401]-Element 'PartyIdentification' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R402]-Element 'PartyName' must occur exactly 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cac:PostalAddress)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PostalAddress)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R403]-Element 'PostalAddress' must occur exactly 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R404]-Element 'PartyTaxScheme' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:InvoiceLine/cac:Item" mode="w382aac11" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:InvoiceLine/cac:Item" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:InvoiceLine/cac:Item</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:InvoiceLine/cac:Item</attribute>
          </ns1:fired-rule>
          <if test="not(count(cbc:Description)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cbc:Description)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R407]-Element 'Description' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cbc:Name)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cbc:Name)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R408]-Element 'Name' must occur exactly 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cac:ClassifiedTaxCategory)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:ClassifiedTaxCategory)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R409]-Element 'ClassifiedTaxCategory' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:InvoiceLine/cac:Price" mode="w382aac11" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:InvoiceLine/cac:Price" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:InvoiceLine/cac:Price</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:InvoiceLine/cac:Price</attribute>
          </ns1:fired-rule>
          <if test="not(count(cac:AllowanceCharge)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:AllowanceCharge)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R410]-Element 'AllowanceCharge' may occur at maximum 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice" mode="w382aac11" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice</attribute>
          </ns1:fired-rule>
          <if test="not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')</attribute>
              <ns1:text>[BIICORE-T15-R000]-This XML instance is NOT a BiiTrdm015 transaction</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(count(//*[not(text())]) > 0))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(count(//*[not(text())]) &gt; 0)</attribute>
              <ns1:text>[BIICORE-T15-R001]-An invoice SHOULD not contain empty elements.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R002]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R003]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R004]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:TaxCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:TaxCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R005]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:PricingCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:PricingCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R006]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:PaymentCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:PaymentCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R007]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:PaymentAlternativeCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:PaymentAlternativeCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R008]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R009]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:LineCountNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:LineCountNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R010]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:SelfBilledInvoiceDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:SelfBilledInvoiceDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R011]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:DespatchDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:DespatchDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R012]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:ReceiptDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:ReceiptDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R013]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:OriginatorDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:OriginatorDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R014]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Signature) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Signature) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R015]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BuyerCustomerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BuyerCustomerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R016]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:SellerSupplierParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:SellerSupplierParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R017]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxRepresentativeParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxRepresentativeParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R018]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:DeliveryTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:DeliveryTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R019]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PrepaidPayment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PrepaidPayment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R020]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R021]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PricingExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PricingExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R022]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R023]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentAlternativeExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentAlternativeExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R024]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoicePeriod/cbc:StartTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoicePeriod/cbc:StartTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R025]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoicePeriod/cbc:EndTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoicePeriod/cbc:EndTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R026]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoicePeriod/cbc:DurationMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoicePeriod/cbc:DurationMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R027]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoicePeriod/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoicePeriod/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R028]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoicePeriod/cbc:DescriptionCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoicePeriod/cbc:DescriptionCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R029]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:OrderReference/cbc:SalesOrderID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:OrderReference/cbc:SalesOrderID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R030]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:OrderReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:OrderReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R031]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:OrderReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:OrderReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R032]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:OrderReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:OrderReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R033]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:OrderReference/cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:OrderReference/cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R034]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:OrderReference/cbc:CustomerReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:OrderReference/cbc:CustomerReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R035]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:OrderReference/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:OrderReference/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R036]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:ContractDocumentReference/cbc:CooyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:ContractDocumentReference/cbc:CooyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R037]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:ContractDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:ContractDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R038]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:ContractDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:ContractDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R039]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:ContractDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:ContractDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R040]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:ContractDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:ContractDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R041]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:ContractDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:ContractDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R042]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AdditionalDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AdditionalDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R043]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AdditionalDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AdditionalDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R044]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AdditionalDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AdditionalDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R045]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R046]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AdditionalDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AdditionalDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R047]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R048]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R049]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R050]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R051]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R052]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cbc:DataSendingCapability) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cbc:DataSendingCapability) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R053]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:DespatchContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:DespatchContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R054]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R055]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:SellerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:SellerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R056]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R057]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R058]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R059]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R060]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R061]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R062]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R063]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R064]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R065]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R066]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R067]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R068]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R069]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R070]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R071]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R072]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R073]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R074]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R075]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R076]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R077]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R078]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R079]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R080]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R081]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R082]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R083]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R084]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R085]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R086]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R087]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R088]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R089]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R090]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R091]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R092]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R093]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R094]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R095]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R096]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R097]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R098]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R099]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R100]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R101]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R102]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R103]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R104]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R105]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R106]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R107]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R108]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R109]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R110]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R111]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R112]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R113]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R114]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R115]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R116]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R117]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R118]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R119]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R120]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R121]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R122]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R123]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R124]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:DeliveryContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:DeliveryContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R125]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R126]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:BuyerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:BuyerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R127]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R128]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R129]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R130]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R131]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R132]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R133]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R134]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R135]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R136]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R137]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R138]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R139]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R140]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R141]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R142]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R143]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R144]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R145]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R146]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R147]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R148]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R149]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R150]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R151]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R152]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R153]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R154]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R155]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R156]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R157]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R158]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R159]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R160]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R161]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R162]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R163]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R164]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R165]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R166]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R167]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R168]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R169]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R170]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R171]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R172]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R173]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R174]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R175]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R176]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R177]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R178]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R179]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R180]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R181]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R182]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R183]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R184]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R185]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R186]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R187]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R188]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R189]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R190]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R191]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R192]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R193]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R194]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R195]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R196]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R197]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:PostalAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:PostalAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R198]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R199]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:PartyTaxScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:PartyTaxScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R200]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R201]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R202]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R203]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:Contact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:Contact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R204]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:Person) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:Person) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R205]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R206]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R207]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cbc:Quantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cbc:Quantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R208]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cbc:MinimumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cbc:MinimumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R209]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cbc:MaximumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cbc:MaximumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R210]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cbc:ActualDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cbc:ActualDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R211]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cbc:LatestDeliveryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cbc:LatestDeliveryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R212]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cbc:LatestDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cbc:LatestDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R213]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cbc:TrackingID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cbc:TrackingID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R214]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R215]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R216]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R217]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R218]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R219]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R220]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R221]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R222]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R223]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R224]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R225]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R226]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R227]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R228]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R229]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R230]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R231]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R232]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R233]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R234]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R235]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R236]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R237]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R238]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R239]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R240]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:PromisedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:PromisedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R241]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:EstimatedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:EstimatedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R242]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R243]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:Delivery/cac:DeliveryLocation/cac:Despatch) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:Delivery/cac:DeliveryLocation/cac:Despatch) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R244]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R245]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cbc:InstructionID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cbc:InstructionID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R246]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cbc:InstructionNote) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cbc:InstructionNote) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R247]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:CardAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:CardAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R248]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayerFinancialAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayerFinancialAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R249]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:CreditAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:CreditAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R250]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R251]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R252]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R253]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R254]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R255]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R256]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R257]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R258]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R259]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cbc:PaymentMeansID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cbc:PaymentMeansID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R260]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R261]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cbc:ReferenceEventCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cbc:ReferenceEventCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R262]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cbc:SettlementDiscountPercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cbc:SettlementDiscountPercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R263]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cbc:PenaltySurchargePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cbc:PenaltySurchargePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R264]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cbc:Amount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cbc:Amount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R265]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cac:SettlementPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cac:SettlementPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R266]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PaymentTerms/cac:PenaltyPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PaymentTerms/cac:PenaltyPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R267]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R268]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R269]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R270]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R271]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R272]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R273]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R274]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R275]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R276]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R277]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R278]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R279]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R280]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R281]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R282]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R283]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R284]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R285]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R286]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R287]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R288]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R289]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R290]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R291]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R292]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R293]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R294]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R295]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R296]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R297]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R298]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R299]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cbc:FreeOfChargeIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cbc:FreeOfChargeIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R300]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:OrderLineReference/cbc:SalesOrderLineID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:OrderLineReference/cbc:SalesOrderLineID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R301]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:DespatchLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:DespatchLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R302]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:ReceiptLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:ReceiptLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R303]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R304]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R305]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:PricingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:PricingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R306]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:OriginatorParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:OriginatorParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R307]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Delivery) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Delivery) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R308]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:PaymentTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:PaymentTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R309]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R310]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R311]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R312]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R313]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R314]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R315]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R316]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R317]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R318]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R319]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R320]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R321]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R322]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R323]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cbc:PackQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cbc:PackQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R324]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cbc:PackSizeNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cbc:PackSizeNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R325]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cbc:CatalogueIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cbc:CatalogueIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R326]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cbc:HazardousRiskIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cbc:HazardousRiskIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R327]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cbc:AdditionalInformation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cbc:AdditionalInformation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R328]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cbc:Keyword) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cbc:Keyword) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R329]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cbc:BrandName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cbc:BrandName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R330]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cbc:ModelName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cbc:ModelName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R331]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R332]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R333]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R334]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R335]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R336]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R337]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R338]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R339]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R340]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:NatureCargo) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:NatureCargo) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R341]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R342]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CommodityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CommodityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R343]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:ManufacturersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:ManufacturersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R344]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:CatalogueItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:CatalogueItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R345]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:AdditionalItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:AdditionalItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R346]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:CatalogueDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:CatalogueDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R347]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:ItemSpecificationDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:ItemSpecificationDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R348]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:OriginCountry) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:OriginCountry) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R349]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TransactionConditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TransactionConditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R350]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:HazardousItem) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:HazardousItem) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R351]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:ManufacturerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:ManufacturerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R352]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:InformationContentProviderParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:InformationContentProviderParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R353]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:OriginAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:OriginAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R354]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:ItemInstance) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:ItemInstance) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R355]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R356]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R357]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbcPerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbcPerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R358]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R359]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R360]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R361]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R362]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R363]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R364]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R365]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R366]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:UsabilityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:UsabilityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R367]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:ItemPropertyGroup) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:ItemPropertyGroup) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R368]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cbc:PriceChangeReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cbc:PriceChangeReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R369]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cbc:PriceTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cbc:PriceTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R370]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cbc:PriceType) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cbc:PriceType) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R371]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cbc:OrderableUnitFactorRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cbc:OrderableUnitFactorRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R372]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R373]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:PriceList) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:PriceList) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R374]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R375]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R376]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R377]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R378]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R379]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R380]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R381]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R382]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R383]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:OrderLineReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:OrderLineReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R384]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:OrderLineReference/cbc:LineStatusCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:OrderLineReference/cbc:LineStatusCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R385]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:InvoiceLine/cac:OrderLineReference/cac:OrderReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:InvoiceLine/cac:OrderLineReference/cac:OrderReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R386]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R387]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:DebitNoteDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:DebitNoteDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R388]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:ReminderDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:ReminderDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R389]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:AdditionalDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:AdditionalDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R390]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:BillingReferenceLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:BillingReferenceLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R391]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R392]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R393]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R394]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R395]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R396]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R397]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice/cac:LegalMonetaryTotal" mode="w382aac11" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w382aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <comment>WARNING: Rule for context "/ubl:Invoice/cac:LegalMonetaryTotal" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:LegalMonetaryTotal</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w382aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice/cac:LegalMonetaryTotal</attribute>
          </ns1:fired-rule>
          <if test="not(count(cbc:TaxExclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cbc:TaxExclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R411]-Element 'TaxExclusiveAmount' must occur exactly 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(count(cbc:TaxInclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cbc:TaxInclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0') or not (contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm015:ver1.0'))</attribute>
              <ns1:text>[BIICORE-T15-R412]-Element 'TaxInclusiveAmount' must occur exactly 1 times.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w382aac11')" />
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
