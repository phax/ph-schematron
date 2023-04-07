<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:08.339+01:00</ns1:created>
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
            <ns1:created>2022-11-17T08:43:08.339+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w926aac11" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="ITNAT T10 bound to UBL">
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
  <template name="w926aac11">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w926aac11">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="UBL-T10" name="UBL-T10">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w926aac11" select="root()" />
    </ns0:document>
  </template>
  <template match="//cac:DocumentReference" mode="w926aac11" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w926aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <comment>WARNING: Rule for context "//cac:DocumentReference" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:DocumentReference</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:DocumentReference</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R032]-If the supplier country code is “IT”, the reference to the transport document at line level in an invoice MUST contain document identifier, issue date, reference law.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w926aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:TaxRepresentativeParty" mode="w926aac11" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w926aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <comment>WARNING: Rule for context "//cac:TaxRepresentativeParty" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxRepresentativeParty</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxRepresentativeParty</attribute>
          </ns1:fired-rule>
          <if test="not((cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'IT:VAT'] and cac:PartyName/cbc:Name) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'IT:VAT'] and cac:PartyName/cbc:Name) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R003]-If Tax Representative Party exists and its country code is “IT”, an invoice MUST contain VAT Company Identifier and name of the Tax Representative Party.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w926aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingSupplierParty/cac:Party" mode="w926aac11" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w926aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not(not(cac:PartyLegalEntity/cbc:CompanyID[@schemeID = 'IT:CC']) or (cac:PartyLegalEntity[cbc:CompanyID/@schemeID = 'IT:CC']/cac:CorporateRegistrationScheme/cac:JurisdictionRegionAddress/cbc:CountrySubentity) or (cac:PartyLegalEntity[cbc:CompanyID/@schemeID = 'IT:CC']/cac:CorporateRegistrationScheme/cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Warning" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PartyLegalEntity/cbc:CompanyID[@schemeID = 'IT:CC']) or (cac:PartyLegalEntity[cbc:CompanyID/@schemeID = 'IT:CC']/cac:CorporateRegistrationScheme/cac:JurisdictionRegionAddress/cbc:CountrySubentity) or (cac:PartyLegalEntity[cbc:CompanyID/@schemeID = 'IT:CC']/cac:CorporateRegistrationScheme/cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R013]-If the supplier country code is “IT” and is registered in the Italian Chamber of Commerce, the information about supplier’s Items Registration Company SHOULD include Country Subentity (as code or text) of Chambers of Commerce of company register.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w926aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="w926aac11" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w926aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <comment>WARNING: Rule for context "//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R008]-A customer postal address in an invoice MUST contain at least, Street name, city name, zip code, country subentity and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w926aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice" mode="w926aac11" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w926aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice</attribute>
          </ns1:fired-rule>
          <if test="not(cbc:InvoiceTypeCode and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Fatal" location="{schxslt:location(.)}">
              <attribute name="test">cbc:InvoiceTypeCode and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R016]-If the supplier country code is “IT”, an invoice MUST contain the invoice type.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w926aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:DespatchDocumentReference" mode="w926aac11" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w926aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <comment>WARNING: Rule for context "//cac:DespatchDocumentReference" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:DespatchDocumentReference</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:DespatchDocumentReference</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R017]-If the supplier country code is “IT”, the reference to the transport document in an invoice MUST contain document identifier, issue date, reference law.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w926aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:InvoiceLine" mode="w926aac11" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w926aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <comment>WARNING: Rule for context "//cac:InvoiceLine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:InvoicedQuantity) and (cbc:InvoicedQuantity/@unitCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:InvoicedQuantity) and (cbc:InvoicedQuantity/@unitCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R024]-Each invoice line MUST contain the quantity and unit of measure.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:Price/cbc:PriceAmount) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cac:Price/cbc:PriceAmount) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R031]-If the supplier country code is “IT”, each invoice line MUST contain the product/service unit price.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w926aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" mode="w926aac11" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w926aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <comment>WARNING: Rule for context "//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w926aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="Fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))</attribute>
              <ns1:text>[IT-T10-R005]-A suppliers postal address in an invoice MUST contain at least, Street name, city name, zip code, country subentity and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w926aac11')" />
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
