<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:08.311+01:00</ns1:created>
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
            <ns1:created>2022-11-17T08:43:08.311+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w901aac11" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="EUGEN T19 bound to UBL">
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" />
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
  <template name="w901aac11">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w901aac11">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="UBL-T19" name="UBL-T19">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w901aac11" select="root()" />
    </ns0:document>
  </template>
  <template match="//cac:ContractorCustomerParty/cac:Party" mode="w901aac11" priority="15">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:ContractorCustomerParty/cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ContractorCustomerParty/cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ContractorCustomerParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not(((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))</attribute>
              <ns1:text>[EUGEN-T19-R025]-In cross border trade the VAT identifier for the customer should be prefixed with country code.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((not(cac:PartyIdentification/cbc:ID) and (cac:PartyName/cbc:Name)) or (cac:PartyIdentification/cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(not(cac:PartyIdentification/cbc:ID) and (cac:PartyName/cbc:Name)) or (cac:PartyIdentification/cbc:ID)</attribute>
              <ns1:text>[EUGEN-T19-R024]-If buyer customer party ID is not specified, buyer party name is mandatory</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Catalogue" mode="w901aac11" priority="14">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "/ubl:Catalogue" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Catalogue</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Catalogue</attribute>
          </ns1:fired-rule>
          <if test="not(count(cac:ReferencedContract) &lt;=1)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">count(cac:ReferencedContract) &lt;=1</attribute>
              <ns1:text>[EUGEN-T19-R028]-Contract reference SHOULD be only one</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:ProfileID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:ProfileID)</attribute>
              <ns1:text>[EUGEN-T19-R003]-The profile ID is dependent on the profile in which the transaction is being used.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:CustomizationID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:CustomizationID)</attribute>
              <ns1:text>[EUGEN-T19-R002]-CustomizationID MUST  comply with CEN/BII transactions definitions</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:UBLVersionID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:UBLVersionID)</attribute>
              <ns1:text>[EUGEN-T19-R001]-UBL VersionID MUST define a supported syntaxbinding</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:ProviderParty" mode="w901aac11" priority="13">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:ProviderParty" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ProviderParty</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ProviderParty</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:EndpointID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:EndpointID)</attribute>
              <ns1:text>[EUGEN-T19-R031]-Provider party endpoint identifier MUST be filled in </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:RequiredItemLocationQuantity" mode="w901aac11" priority="12">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:RequiredItemLocationQuantity" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:RequiredItemLocationQuantity</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:RequiredItemLocationQuantity</attribute>
          </ns1:fired-rule>
          <if test="not(((cbc:MaximumQuantity) and (cbc:MinimumQuantity) and (number(cbc:MaximumQuantity) >= number(cbc:MinimumQuantity))) or not(cbc:MaximumQuantity) or not(cbc:MinimumQuantity))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:MaximumQuantity) and (cbc:MinimumQuantity) and (number(cbc:MaximumQuantity) &gt;= number(cbc:MinimumQuantity))) or not(cbc:MaximumQuantity) or not(cbc:MinimumQuantity)</attribute>
              <ns1:text>[EUGEN-T19-R034]-Catalogue line Maximum_quantity SHOULD be greater than the Minimum quantity (it is applied to the section Item location.quantity.maximum_quantity) </ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((//cac:ValidityPeriod) and (/ubl:Catalogue/cac:ValidityPeriod) and (//cac:ValidityPeriod/cbc:StartDate)>(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate) and (//cac:ValidityPeriod/cbc:EndDate)&lt;(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate)) or not(//cac:ValidityPeriod) or not(/ubl:Catalogue/cac:ValidityPeriod))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((//cac:ValidityPeriod) and (/ubl:Catalogue/cac:ValidityPeriod) and (//cac:ValidityPeriod/cbc:StartDate)&gt;(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate) and (//cac:ValidityPeriod/cbc:EndDate)&lt;(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate)) or not(//cac:ValidityPeriod) or not(/ubl:Catalogue/cac:ValidityPeriod)</attribute>
              <ns1:text>[EUGEN-T19-R016]-Line validity period SHOULD be within the range of the whole catalogue validity period</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:Party" mode="w901aac11" priority="11">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not((cac:PartyLegalEntity/cbc:CompanyID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PartyLegalEntity/cbc:CompanyID)</attribute>
              <ns1:text>[EUGEN-T19-R005]-Party.Party Tax Scheme. Company Identifier SHOULD be present</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:ReceiverParty" mode="w901aac11" priority="10">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:ReceiverParty" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ReceiverParty</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ReceiverParty</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:EndpointID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:EndpointID)</attribute>
              <ns1:text>[EUGEN-T19-R030]-Receiver party endpoint identifier MUST be filled in </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:RequiredItemLocationQuantity/cac:Price" mode="w901aac11" priority="9">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:RequiredItemLocationQuantity/cac:Price" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:RequiredItemLocationQuantity/cac:Price</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:RequiredItemLocationQuantity/cac:Price</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:PriceAmount) >=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:PriceAmount) &gt;=0</attribute>
              <ns1:text>[EUGEN-T19-R013]-Prices of items MUST be positive or equal to zero NOT negative amounts</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:ReferencedContract" mode="w901aac11" priority="8">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:ReferencedContract" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ReferencedContract</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ReferencedContract</attribute>
          </ns1:fired-rule>
          <if test="not((not(cbc:ID) and (cbc:ContractType)) or (cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(not(cbc:ID) and (cbc:ContractType)) or (cbc:ID)</attribute>
              <ns1:text>[EUGEN-T19-R027]-If Contract Identifier is not specified SHOULD Contract Type text be used for Contract Reference </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:SellerSupplierParty/cac:Party/cac:PostalAddress" mode="w901aac11" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:SellerSupplierParty/cac:Party/cac:PostalAddress" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:SellerSupplierParty/cac:Party/cac:PostalAddress</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:SellerSupplierParty/cac:Party/cac:PostalAddress</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)</attribute>
              <ns1:text>[EUGEN-T19-R010]-A seller party address in an catalogue SHOULD contain at least Street Name, City name and Zip code and Country code </ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:SellerSupplierParty/cac:Party" mode="w901aac11" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:SellerSupplierParty/cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:SellerSupplierParty/cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:SellerSupplierParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not(((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))</attribute>
              <ns1:text>[EUGEN-T19-R009]-In cross border trade the VAT identifier for the supplier MUST be prefixed with country code.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((not(cac:PartyIdentification/cbc:ID) and (cac:PartyName/cbc:Name)) or (cac:PartyIdentification/cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(not(cac:PartyIdentification/cbc:ID) and (cac:PartyName/cbc:Name)) or (cac:PartyIdentification/cbc:ID)</attribute>
              <ns1:text>[EUGEN-T19-R007]-If seller supplier party ID is not specified, seller supplier party name is mandatory</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:ValidityPeriod" mode="w901aac11" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:ValidityPeriod" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ValidityPeriod</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ValidityPeriod</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:StartDate,'-','')) > number(translate(cbc:EndDate,'-',''))) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:StartDate,'-','')) &gt; number(translate(cbc:EndDate,'-',''))) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-',''))</attribute>
              <ns1:text>[EUGEN-T19-R029]-A validity period end date SHOULD be later or equal to a validity period start date</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:Item" mode="w901aac11" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:Item" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Item</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Item</attribute>
          </ns1:fired-rule>
          <if test="not((cac:SellersItemIdentification/cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:SellersItemIdentification/cbc:ID)</attribute>
              <ns1:text>[EUGEN-T19-R041]-Sellers_ Item Identification. Item Identification section SHOULD be present</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID)</attribute>
              <ns1:text>[EUGEN-T19-R019]-Item Tax Scheme SHOULD be present</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cac:ClassifiedTaxCategory/cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:ClassifiedTaxCategory/cbc:ID)</attribute>
              <ns1:text>[EUGEN-T19-R018]-Item Tax Category SHOULD be present</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:Description))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:Description)</attribute>
              <ns1:text>[EUGEN-T19-R017]-Item should have a Description – Invoice is the NAME!!</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cac:CommodityClassification/cbc:CommodityCode) and (cac:CommodityClassification/cbc:ItemClassificationCode)) or not(cac:CommodityClassification))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">((cac:CommodityClassification/cbc:CommodityCode) and (cac:CommodityClassification/cbc:ItemClassificationCode)) or not(cac:CommodityClassification)</attribute>
              <ns1:text>[EUGEN-T19-R015]-Item Commodity Classification: both Classification Commodity codes and Item classification code MUST be filled</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)</attribute>
              <ns1:text>[EUGEN-T19-R012]-If standard identifiers are provided within an item description, an Schema Identifier SHOULD be provided (e.g. GTIN)</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:SellerSupplierParty/cac:Party/cac:Contact" mode="w901aac11" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:SellerSupplierParty/cac:Party/cac:Contact" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:SellerSupplierParty/cac:Party/cac:Contact</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:SellerSupplierParty/cac:Party/cac:Contact</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:Telephone))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:Telephone)</attribute>
              <ns1:text>[EUGEN-T19-R006]-A party contact telephone text SHOULD be filled in</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:CatalogueLine" mode="w901aac11" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:CatalogueLine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:CatalogueLine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:CatalogueLine</attribute>
          </ns1:fired-rule>
          <if test="not(((cbc:PriceAmount) and (cbc:BaseQuantity)) or not (cbc:PriceAmount))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:PriceAmount) and (cbc:BaseQuantity)) or not (cbc:PriceAmount)</attribute>
              <ns1:text>[EUGEN-T19-R042]-If Price amount is used than Price Base Quantity SHOUL be higher than zero</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:ID))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:ID)</attribute>
              <ns1:text>[EUGEN-T19-R040]-Contract reference SHOULD always present</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cbc:MaximumOrderQuantity) and (cbc:MaximumOrderQuantity) >=0) or not(cbc:MaximumOrderQuantity))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:MaximumOrderQuantity) and (cbc:MaximumOrderQuantity) &gt;=0) or not(cbc:MaximumOrderQuantity)</attribute>
              <ns1:text>[EUGEN-T19-R039]-Catalogue line Maximum_quantity SHOULD NOT be negative</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:MinimumOrderQuantity))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:MinimumOrderQuantity)</attribute>
              <ns1:text>[EUGEN-T19-R038]-Catalogue line Mimimum_quantity SHOULD be present</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:MaximumOrderQuantity))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:MaximumOrderQuantity)</attribute>
              <ns1:text>[EUGEN-T19-R037]-Catalogue line Maximum_quantity SHOULD be present</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cbc:MinimumOrderQuantity) and (cbc:MinimumOrderQuantity) >=0) or not(cbc:MinimumOrderQuantity))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:MinimumOrderQuantity) and (cbc:MinimumOrderQuantity) &gt;=0) or not(cbc:MinimumOrderQuantity)</attribute>
              <ns1:text>[EUGEN-T19-R036]-Catalogue line Mimimum_quantity SHOULD NOT be negative</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cbc:MaximumOrderQuantity) and (cbc:MinimumOrderQuantity) and (number(cbc:MaximumOrderQuantity) >= number(cbc:MinimumOrderQuantity))) or not(cbc:MaximumOrderQuantity) or not(cbc:MinimumOrderQuantity))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:MaximumOrderQuantity) and (cbc:MinimumOrderQuantity) and (number(cbc:MaximumOrderQuantity) &gt;= number(cbc:MinimumOrderQuantity))) or not(cbc:MaximumOrderQuantity) or not(cbc:MinimumOrderQuantity)</attribute>
              <ns1:text>[EUGEN-T19-R033]-Catalogue line Maximum_quantity SHOULD be greater or equal to the Minimum quantity: it is applied in all the section in  a Catalogue line where are included Maximum and minimum quantity (it is applied at section Max order quantity)</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(((cbc:OrderableIndicator=true()) and cbc:OrderableUnit) or (cbc:OrderableIndicator=false()) or not(cbc:OrderableIndicator))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:OrderableIndicator=true()) and cbc:OrderableUnit) or (cbc:OrderableIndicator=false()) or not(cbc:OrderableIndicator)</attribute>
              <ns1:text>[EUGEN-T19-R032]-If Orderable Indicator is se to Yes than Orderable Unit (text) MUST not be blank</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:ContractorCustomerParty/cac:Party/cac:PostalAddress" mode="w901aac11" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <comment>WARNING: Rule for context "//cac:ContractorCustomerParty/cac:Party/cac:PostalAddress" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ContractorCustomerParty/cac:Party/cac:PostalAddress</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:ContractorCustomerParty/cac:Party/cac:PostalAddress</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)</attribute>
              <ns1:text>[EUGEN-T19-R023]-A Customer party address in an catalogue SHOULD contain at least Street Name, City name and Zip code and Country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:DocumentReference" mode="w901aac11" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w901aac11']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w901aac11">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:DocumentReference</attribute>
          </ns1:fired-rule>
          <if test="not((cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode)</attribute>
              <ns1:text>[EUGEN-T19-R020]-Mime code Should be given for embedded binary object accordingly to codelist</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w901aac11')" />
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
