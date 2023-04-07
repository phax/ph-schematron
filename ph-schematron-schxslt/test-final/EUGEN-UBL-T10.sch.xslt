<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:08.147+01:00</ns1:created>
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
            <ns1:created>2022-11-17T08:43:08.147+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w812aac13" />
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="EUGEN T10 bound to UBL">
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
  <template name="w812aac13">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w812aac13">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="Codes-T10" name="Codes-T10">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w812aac15">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="UBL-T10" name="UBL-T10">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w812aac13" select="root()" />
    </ns0:document>
  </template>
  <template match="cac:FinancialInstitution/cbc:ID//@schemeID" mode="w812aac13" priority="19">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <comment>WARNING: Rule for context "cac:FinancialInstitution/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:FinancialInstitution/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:FinancialInstitution/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�BIC�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�BIC�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-010-002]-If FinancialAccountID is IBAN then Financial InstitutionID SHOULD be BIC code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:PostalAddress/cbc:ID//@schemeID" mode="w812aac13" priority="18">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <comment>WARNING: Rule for context "cac:PostalAddress/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PostalAddress/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PostalAddress/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�GLN�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�GLN�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-010-003]-Postal address identifiers SHOULD be GLN.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID" mode="w812aac13" priority="17">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <comment>WARNING: Rule for context "cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�GLN�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�GLN�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-010-004]-Location identifiers SHOULD be GLN</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID" mode="w812aac13" priority="16">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <comment>WARNING: Rule for context "cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�GTIN�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�GTIN�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-010-005]-Standard item identifiers SHOULD be GTIN.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID" mode="w812aac13" priority="15">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <comment>WARNING: Rule for context "cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�CPV�UNSPSC�eCLASS�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�CPV�UNSPSC�eCLASS�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-010-006]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cbc:TaxExemptionReasonCode" mode="w812aac13" priority="14">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <comment>WARNING: Rule for context "cbc:TaxExemptionReasonCode" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:TaxExemptionReasonCode</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:TaxExemptionReasonCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AAA Exempt�AAB Exempt�AAC Exempt�AAE Reverse Charge�AAF Exempt�AAG Exempt�AAH Margin Scheme�AAI Margin Scheme�AAJ Reverse Charge�AAK Reverse Charge�AAL Reverse Charge Exempt�AAM Exempt New Means of Transport�AAN Exempt Triangulation�AAO Reverse Charge�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AAA Exempt�AAB Exempt�AAC Exempt�AAE Reverse Charge�AAF Exempt�AAG Exempt�AAH Margin Scheme�AAI Margin Scheme�AAJ Reverse Charge�AAK Reverse Charge�AAL Reverse Charge Exempt�AAM Exempt New Means of Transport�AAN Exempt Triangulation�AAO Reverse Charge�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-010-007]-Tax exemption reasons MUST be coded using Use CWA 15577 tax exemption code list. Version 2006</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:PartyIdentification/cbc:ID//@schemeID" mode="w812aac13" priority="13">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <comment>WARNING: Rule for context "cac:PartyIdentification/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PartyIdentification/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PartyIdentification/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-010-008]-Party Identifiers MUST use the PEPPOL PartyID list</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cbc:EndpointID//@schemeID" mode="w812aac13" priority="12">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <comment>WARNING: Rule for context "cbc:EndpointID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:EndpointID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:EndpointID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-010-009]-Endpoint Identifiers MUST use the PEPPOL PartyID list.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:TaxCategory" mode="w812aac13" priority="11">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <comment>WARNING: Rule for context "//cac:TaxCategory" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxCategory</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxCategory</attribute>
          </ns1:fired-rule>
          <if test="not((parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')</attribute>
              <ns1:text>[EUGEN-T10-R008]-For each tax subcategory the category ID and the applicable tax percentage MUST be provided.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AllowanceCharge" mode="w812aac13" priority="10">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <comment>WARNING: Rule for context "//cac:AllowanceCharge" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AllowanceCharge</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AllowanceCharge</attribute>
          </ns1:fired-rule>
          <if test="not((((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())=&quot;Invoice&quot;)) or not(local-name(parent:: node())=&quot;Invoice&quot;))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())="Invoice")) or not(local-name(parent:: node())="Invoice")</attribute>
              <ns1:text>[EUGEN-T10-R006]-If the VAT total amount in an invoice exists then an Allowances Charges amount on document level MUST have Tax category for VAT.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(number(cbc:Amount)>=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(cbc:Amount)&gt;=0</attribute>
              <ns1:text>[EUGEN-T10-R022]-An allowance or charge amount MUST NOT be negative.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:AllowanceChargeReason))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:AllowanceChargeReason)</attribute>
              <ns1:text>[EUGEN-T10-R023]-AllowanceChargeReason text SHOULD be specified for all allowances and charges</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) >=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0</attribute>
              <ns1:text>[EUGEN-T10-R012]-An allowance percentage MUST NOT be negative.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)) )">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)) </attribute>
              <ns1:text>[EUGEN-T10-R013]-In allowances, both or none of percentage and base amount SHOULD be provided</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingCustomerParty/cac:Party" mode="w812aac13" priority="9">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not((cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)</attribute>
              <ns1:text>[EUGEN-T10-R002]-A customer postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:LegalMonetaryTotal" mode="w812aac13" priority="8">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <comment>WARNING: Rule for context "//cac:LegalMonetaryTotal" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:LegalMonetaryTotal</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:LegalMonetaryTotal</attribute>
          </ns1:fired-rule>
          <if test="not(number(cbc:PayableAmount) >= 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(cbc:PayableAmount) &gt;= 0</attribute>
              <ns1:text>[EUGEN-T10-R019]-Total payable amount in an invoice MUST NOT be negative</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:Delivery/cac:DeliveryLocation/cac:Address" mode="w812aac13" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <comment>WARNING: Rule for context "//cac:Delivery/cac:DeliveryLocation/cac:Address" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Delivery/cac:DeliveryLocation/cac:Address</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Delivery/cac:DeliveryLocation/cac:Address</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)</attribute>
              <ns1:text>[EUGEN-T10-R005]-A Delivery address in an invoice SHOULD contain at least, city, zip code and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingSupplierParty/cac:Party" mode="w812aac13" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not((cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)</attribute>
              <ns1:text>[EUGEN-T10-R001]-A supplier postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice" mode="w812aac13" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice</attribute>
          </ns1:fired-rule>
          <if test="not(((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))</attribute>
              <ns1:text>[EUGEN-T10-R007]-If the VAT total amount in an invoice exists it MUST contain the suppliers VAT number.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)</attribute>
              <ns1:text>[EUGEN-T10-R010]-If payee information is provided then the payee name MUST be specified.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')</attribute>
              <ns1:text>[EUGEN-T10-R015]-IF VAT = "AE" (reverse charge) THEN it MUST contain Supplier VAT id and Customer VAT</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)</attribute>
              <ns1:text>[EUGEN-T10-R016]-IF VAT = "AE" (reverse charge) THEN VAT MAY NOT contain other VAT categories.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')</attribute>
              <ns1:text>[EUGEN-T10-R017]-IF VAT = "AE" (reverse charge) THEN The taxable amount MUST equal the invoice total without VAT amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')</attribute>
              <ns1:text>[EUGEN-T10-R018]-IF VAT = "AE" (reverse charge) THEN VAT tax amount MUST be zero.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(//@currencyID != //cbc:DocumentCurrencyCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">not(//@currencyID != //cbc:DocumentCurrencyCode)</attribute>
              <ns1:text>[EUGEN-T10-R024]-Currency Identifier MUST be in stated in the currency stated on header level.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:InvoicePeriod" mode="w812aac13" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <comment>WARNING: Rule for context "//cac:InvoicePeriod" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoicePeriod</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoicePeriod</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:StartDate))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:StartDate)</attribute>
              <ns1:text>[EUGEN-T10-R020]-If the invoice refers to a period, the period MUST have an start date.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:EndDate))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:EndDate)</attribute>
              <ns1:text>[EUGEN-T10-R021]-If the invoice refers to a period, the period MUST have an end date.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:PaymentMeans" mode="w812aac13" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <comment>WARNING: Rule for context "//cac:PaymentMeans" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:PaymentMeans</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:PaymentMeans</attribute>
          </ns1:fired-rule>
          <if test="not(((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN'))))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))</attribute>
              <ns1:text>[EUGEN-T10-R004]-If the payment means are international account transfer and the account id is IBAN then the financial institution should be identified by using the BIC id.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:Item/cac:ClassifiedTaxCategory" mode="w812aac13" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <comment>WARNING: Rule for context "//cac:Item/cac:ClassifiedTaxCategory" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Item/cac:ClassifiedTaxCategory</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Item/cac:ClassifiedTaxCategory</attribute>
          </ns1:fired-rule>
          <if test="not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))</attribute>
              <ns1:text>[EUGEN-T10-R011]-If the VAT total amount in an invoice exists then each invoice line item MUST have a VAT category ID.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:InvoiceLine" mode="w812aac13" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
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
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode)</attribute>
              <ns1:text>[EUGEN-T10-R003]-Each invoice line SHOULD contain the quantity and unit of measure</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:TaxSubtotal" mode="w812aac13" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w812aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <comment>WARNING: Rule for context "//cac:TaxSubtotal" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxSubtotal</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w812aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxSubtotal</attribute>
          </ns1:fired-rule>
          <if test="not(((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or  (cac:TaxCategory/cbc:ID != 'E'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or  (cac:TaxCategory/cbc:ID != 'E')</attribute>
              <ns1:text>[EUGEN-T10-R009]-If the category for VAT is exempt (E) then an exemption reason SHOULD be provided.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w812aac15')" />
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
