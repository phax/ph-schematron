<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<param name="archiveDirParameter" />
  <param name="archiveNameParameter" />
  <param name="fileNameParameter" />
  <param name="fileDirParameter" />
  <variable name="document-uri">
    <value-of select="document-uri(/)" />
  </variable>

<!--PHASES-->


<!--PROLOG-->
<output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<template match="*" mode="schematron-select-full-path">
    <apply-templates mode="schematron-get-full-path" select="." />
  </template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<template match="*" mode="schematron-get-full-path">
    <apply-templates mode="schematron-get-full-path" select="parent::*" />
    <text>/</text>
    <choose>
      <when test="namespace-uri()=''">
        <value-of select="name()" />
      </when>
      <otherwise>
        <text>*:</text>
        <value-of select="local-name()" />
        <text>[namespace-uri()='</text>
        <value-of select="namespace-uri()" />
        <text>']</text>
      </otherwise>
    </choose>
    <variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <text>[</text>
    <value-of select="1+ $preceding" />
    <text>]</text>
  </template>
  <template match="@*" mode="schematron-get-full-path">
    <apply-templates mode="schematron-get-full-path" select="parent::*" />
    <text>/</text>
    <choose>
      <when test="namespace-uri()=''">@<value-of select="name()" />
</when>
      <otherwise>
        <text>@*[local-name()='</text>
        <value-of select="local-name()" />
        <text>' and namespace-uri()='</text>
        <value-of select="namespace-uri()" />
        <text>']</text>
      </otherwise>
    </choose>
  </template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<template match="node() | @*" mode="schematron-get-full-path-2">
    <for-each select="ancestor-or-self::*">
      <text>/</text>
      <value-of select="name(.)" />
      <if test="preceding-sibling::*[name(.)=name(current())]">
        <text>[</text>
        <value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <text>]</text>
      </if>
    </for-each>
    <if test="not(self::*)">
      <text />/@<value-of select="name(.)" />
    </if>
  </template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<template match="node() | @*" mode="schematron-get-full-path-3">
    <for-each select="ancestor-or-self::*">
      <text>/</text>
      <value-of select="name(.)" />
      <if test="parent::*">
        <text>[</text>
        <value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <text>]</text>
      </if>
    </for-each>
    <if test="not(self::*)">
      <text />/@<value-of select="name(.)" />
    </if>
  </template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<template match="/" mode="generate-id-from-path" />
  <template match="text()" mode="generate-id-from-path">
    <apply-templates mode="generate-id-from-path" select="parent::*" />
    <value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </template>
  <template match="comment()" mode="generate-id-from-path">
    <apply-templates mode="generate-id-from-path" select="parent::*" />
    <value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </template>
  <template match="processing-instruction()" mode="generate-id-from-path">
    <apply-templates mode="generate-id-from-path" select="parent::*" />
    <value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </template>
  <template match="@*" mode="generate-id-from-path">
    <apply-templates mode="generate-id-from-path" select="parent::*" />
    <value-of select="concat('.@', name())" />
  </template>
  <template match="*" mode="generate-id-from-path" priority="-0.5">
    <apply-templates mode="generate-id-from-path" select="parent::*" />
    <text>.</text>
    <value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </template>

<!--MODE: GENERATE-ID-2 -->
<template match="/" mode="generate-id-2">U</template>
  <template match="*" mode="generate-id-2" priority="2">
    <text>U</text>
    <number count="*" level="multiple" />
  </template>
  <template match="node()" mode="generate-id-2">
    <text>U.</text>
    <number count="*" level="multiple" />
    <text>n</text>
    <number count="node()" />
  </template>
  <template match="@*" mode="generate-id-2">
    <text>U.</text>
    <number count="*" level="multiple" />
    <text>_</text>
    <value-of select="string-length(local-name(.))" />
    <text>_</text>
    <value-of select="translate(name(),':','.')" />
  </template>
<!--Strip characters-->  <template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<template match="/">
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" schemaVersion="" title="">
      <comment>
        <value-of select="$archiveDirParameter" />   
		 <value-of select="$archiveNameParameter" />  
		 <value-of select="$fileNameParameter" />  
		 <value-of select="$fileDirParameter" />
      </comment>
      <ns0:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" />
      <ns0:ns-prefix-in-attribute-values prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <ns0:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <attribute name="id">UBL-model</attribute>
        <attribute name="name">UBL-model</attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M10" select="/" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <attribute name="id">UBL-syntax</attribute>
        <attribute name="name">UBL-syntax</attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M11" select="/" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <attribute name="id">Codesmodel</attribute>
        <attribute name="name">Codesmodel</attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M12" select="/" />
    </ns0:schematron-output>
  </template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN UBL-model-->


	<!--RULE -->
<template match="cac:AdditionalDocumentReference" mode="M10" priority="1066">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:ID) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID) != ''">
          <attribute name="id">BR-52</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount" mode="M10" priority="1065">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount" />

		<!--ASSERT -->
<choose>
      <when test="((. > 0) and (exists(//cbc:DueDate) or exists(//cac:PaymentTerms/cbc:Note))) or (. &lt;= 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((. > 0) and (exists(//cbc:DueDate) or exists(//cac:PaymentTerms/cbc:Note))) or (. &lt;= 0)">
          <attribute name="id">BR-CO-25</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-25]-In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" mode="M10" priority="1064">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<choose>
      <when test="exists(@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(@schemeID)">
          <attribute name="id">BR-63</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-63]-The Buyer electronic address (BT-49) shall have a Scheme identifier.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M10" priority="1063">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<choose>
      <when test="(cac:Country/cbc:IdentificationCode) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Country/cbc:IdentificationCode) != ''">
          <attribute name="id">BR-11</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-11]-The Buyer postal address shall contain a Buyer country code (BT-55).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PaymentMeans/cac:CardAccount" mode="M10" priority="1062">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PaymentMeans/cac:CardAccount" />

		<!--ASSERT -->
<choose>
      <when test="string-length(cbc:PrimaryAccountNumberID)>=4 and string-length(cbc:PrimaryAccountNumberID)&lt;=6" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:PrimaryAccountNumberID)>=4 and string-length(cbc:PrimaryAccountNumberID)&lt;=6">
          <attribute name="id">BR-51</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-51]-The last 4 to 6 digits of the Payment card primary account number (BT-87) shall be present if Payment card information (BG-18) is provided in the Invoice.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:Delivery/cac:DeliveryLocation/cac:Address" mode="M10" priority="1061">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:Delivery/cac:DeliveryLocation/cac:Address" />

		<!--ASSERT -->
<choose>
      <when test="exists(cac:Country/cbc:IdentificationCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:Country/cbc:IdentificationCode)">
          <attribute name="id">BR-57</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-57]-Each Deliver to address (BG-15) shall contain a Deliver to country code (BT-80).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M10" priority="1060">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:Amount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:Amount)">
          <attribute name="id">BR-31</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <attribute name="id">BR-32</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <attribute name="id">BR-33</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-33]-Each Document level allowance (BG-20) shall have a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="true()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="true()">
          <attribute name="id">BR-CO-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-05]-Document level allowance reason code (BT-98) and Document level allowance reason (BT-97) shall indicate the same type of allowance.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <attribute name="id">BR-CO-21</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-21]-Each Document level allowance (BG-20) shall contain a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98), or both.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-01]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-02]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M10" priority="1059">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:Amount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:Amount)">
          <attribute name="id">BR-36</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-36]-Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <attribute name="id">BR-37</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <attribute name="id">BR-38</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-38]-Each Document level charge (BG-21) shall have a Document level charge reason (BT-104) or a Document level charge reason code (BT-105).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="true()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="true()">
          <attribute name="id">BR-CO-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-06]-Document level charge reason code (BT-105) and Document level charge reason (BT-104) shall indicate the same type of charge.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <attribute name="id">BR-CO-22</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-22]-Each Document level charge (BG-21) shall contain a Document level charge reason (BT-104) or a Document level charge reason code (BT-105), or both.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-05]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-06]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:LegalMonetaryTotal" mode="M10" priority="1058">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:LegalMonetaryTotal" />

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:LineExtensionAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:LineExtensionAmount)">
          <attribute name="id">BR-12</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-12]-An Invoice shall have the Sum of Invoice line net amount (BT-106).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxExclusiveAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxExclusiveAmount)">
          <attribute name="id">BR-13</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxInclusiveAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxInclusiveAmount)">
          <attribute name="id">BR-14</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:PayableAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:PayableAmount)">
          <attribute name="id">BR-15</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:LineExtensionAmount) = xs:decimal(round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:LineExtensionAmount) = xs:decimal(round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100))">
          <attribute name="id">BR-CO-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-10]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))">
          <attribute name="id">BR-CO-11</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-11]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="xs:decimal(cbc:ChargeTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or (not(cbc:ChargeTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(cbc:ChargeTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or (not(cbc:ChargeTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]))">
          <attribute name="id">BR-CO-12</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-12]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 )) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))">
          <attribute name="id">BR-CO-13</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-13]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cbc:PrepaidAmount) and not(exists(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(exists(cbc:PrepaidAmount)) and not(exists(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (exists(cbc:PrepaidAmount) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or  (not(exists(cbc:PrepaidAmount)) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount)))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cbc:PrepaidAmount) and not(exists(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(exists(cbc:PrepaidAmount)) and not(exists(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (exists(cbc:PrepaidAmount) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(exists(cbc:PrepaidAmount)) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount)))">
          <attribute name="id">BR-CO-16</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) +Rounding amount (BT-114).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-09]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-10]-The allowed maximum number of decimals for the Sum of allowanced on document level (BT-107) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-11</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-11]-The allowed maximum number of decimals for the Sum of charges on document level (BT-108) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-12</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-12]-The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-14</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-14]-The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-16</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-16]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-17</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-17]-The allowed maximum number of decimals for the Rounding amount (BT-114) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-18</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-18]-The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.  </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1057">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:CustomizationID) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:CustomizationID) != ''">
          <attribute name="id">BR-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-01]-An Invoice shall have a Specification identifier (BT-24).   </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cbc:ID) !=''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID) !=''">
          <attribute name="id">BR-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-02]-An Invoice shall have an Invoice number (BT-1).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cbc:IssueDate) !=''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueDate) !=''">
          <attribute name="id">BR-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cbc:InvoiceTypeCode) !='' or (cbc:CreditNoteTypeCode) !=''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:InvoiceTypeCode) !='' or (cbc:CreditNoteTypeCode) !=''">
          <attribute name="id">BR-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-04]-An Invoice shall have an Invoice type code (BT-3).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cbc:DocumentCurrencyCode) !=''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:DocumentCurrencyCode) !=''">
          <attribute name="id">BR-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">
          <attribute name="id">BR-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-06]-An Invoice shall contain the Seller name (BT-27).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">
          <attribute name="id">BR-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-07]-An Invoice shall contain the Buyer name (BT-44).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress)">
          <attribute name="id">BR-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-08]-An Invoice shall contain the Seller postal address. </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress)">
          <attribute name="id">BR-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-10]-An Invoice shall contain the Buyer postal address (BG-8).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:InvoiceLine) or exists(cac:CreditNoteLine)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:InvoiceLine) or exists(cac:CreditNoteLine)">
          <attribute name="id">BR-16</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-16]-An Invoice shall have at least one Invoice line (BG-25)</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])">
          <attribute name="id">BR-53</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-53]-If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="count(cac:PaymentMeans/cac:CardAccount) &lt;= 1" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count(cac:PaymentMeans/cac:CardAccount) &lt;= 1">
          <attribute name="id">BR-66</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-66]-An Invoice shall contain maximum one Payment Card account (BG-18).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="count(cac:PaymentMeans/cac:PaymentMandate) &lt;= 1" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count(cac:PaymentMeans/cac:PaymentMandate) &lt;= 1">
          <attribute name="id">BR-67</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-67]-An Invoice shall contain maximum one Payment Mandate (BG-19).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']))">
          <attribute name="id">BR-AE-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Reverse charge" shall contain in the VAT Breakdown (BG-23) exactly one VAT category code (BT-118) equal with "VAT reverse charge".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-AE-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-AE-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-AE-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))">
          <attribute name="id">BR-CO-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-03]-Value added tax point date (BT-7) and Value added tax point date code (BT-8) are mutually exclusive.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="every $Currency in cbc:DocumentCurrencyCode satisfies (count(cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) eq 1) and (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) * 10 * 10) div 100)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="every $Currency in cbc:DocumentCurrencyCode satisfies (count(cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) eq 1) and (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) * 10 * 10) div 100)">
          <attribute name="id">BR-CO-15</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-15]-Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:TaxTotal/cac:TaxSubtotal)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:TaxTotal/cac:TaxSubtotal)">
          <attribute name="id">BR-CO-18</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-18]-An Invoice shall at least have one VAT breakdown group (BG-23).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))">
          <attribute name="id">BR-DEC-13</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-13]-The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))">
          <attribute name="id">BR-DEC-15</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-15]-The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))">
          <attribute name="id">BR-E-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Exempt from VAT" shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-E-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-E-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-E-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']))">
          <attribute name="id">BR-G-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Export outside the EU" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-G-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-G-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-G-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">
          <attribute name="id">BR-IC-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Intra-community supply" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Intra-community supply".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])">
          <attribute name="id">BR-IC-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-IC-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-IC-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K'])  and (string-length(cac:Delivery/cbc:ActualDeliveryDate) > 1 or (cac:InvoicePeriod/*))) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and (string-length(cac:Delivery/cbc:ActualDeliveryDate) > 1 or (cac:InvoicePeriod/*))) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">
          <attribute name="id">BR-IC-11</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-11]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and (string-length(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode) >1)) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and (string-length(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode) >1)) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">
          <attribute name="id">BR-IC-12</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-12]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Deliver to country code (BT-80) shall not be blank.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'L']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'L']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)">
          <attribute name="id">BR-IG-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IGIC" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IGIC".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-IG-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-IG-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-IG-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)">
          <attribute name="id">BR-IP-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IPSI" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IPSI".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-IP-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-IP-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-IP-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))">
          <attribute name="id">BR-O-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Not subject to VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])">
          <attribute name="id">BR-O-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-O-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-O-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">
          <attribute name="id">BR-O-11</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-11]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain other VAT breakdown groups (BG-23).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">
          <attribute name="id">BR-O-12</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-12]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is not "Not subject to VAT".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">
          <attribute name="id">BR-O-13</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-13]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level allowances (BG-20) where Document level allowance VAT category code (BT-95) is not "Not subject to VAT".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">
          <attribute name="id">BR-O-14</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-14]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level charges (BG-21) where Document level charge VAT category code (BT-102) is not "Not subject to VAT".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)">
          <attribute name="id">BR-S-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']))">
          <attribute name="id">BR-S-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-S-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-S-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))">
          <attribute name="id">BR-Z-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Zero rated" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Zero rated".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-Z-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-02]-An Invoice that contains an Invoice line where the Invoiced item VAT category code (BT-151) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-Z-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <attribute name="id">BR-Z-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-04]-An Invoice that contains a Document level charge where the Document level charge VAT category code (BT-102) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(not(//cbc:IdentificationCode != 'IT') and (//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B')) or (not(//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B'))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(not(//cbc:IdentificationCode != 'IT') and (//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B')) or (not(//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B'))">
          <attribute name="id">BR-B-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-B-01]-An Invoice where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment” shall be a domestic Italian invoice.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B') and (not(//cac:TaxCategory/cbc:ID ='S' or //cac:ClassifiedTaxCategory/cbc:ID = 'S'))) or (not(//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B'))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B') and (not(//cac:TaxCategory/cbc:ID ='S' or //cac:ClassifiedTaxCategory/cbc:ID = 'S'))) or (not(//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B'))">
          <attribute name="id">BR-B-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-B-02]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment" shall not contain an invoice line (BG-25), a Document level allowance (BG-20) or  a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated”.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M10" priority="1056">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:ID) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID) != ''">
          <attribute name="id">BR-21</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)">
          <attribute name="id">BR-22</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-22]-Each Invoice line (BG-25) shall have an Invoiced quantity (BT-129).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:InvoicedQuantity/@unitCode) or exists(cbc:CreditedQuantity/@unitCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:InvoicedQuantity/@unitCode) or exists(cbc:CreditedQuantity/@unitCode)">
          <attribute name="id">BR-23</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-23]-An Invoice line (BG-25) shall have an Invoiced quantity unit of measure code (BT-130).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:LineExtensionAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:LineExtensionAmount)">
          <attribute name="id">BR-24</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cac:Item/cbc:Name) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Item/cbc:Name) != ''">
          <attribute name="id">BR-25</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:Price/cbc:PriceAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:Price/cbc:PriceAmount)">
          <attribute name="id">BR-26</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cac:Price/cbc:PriceAmount) >= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Price/cbc:PriceAmount) >= 0">
          <attribute name="id">BR-27</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-27]-The Item net price (BT-146) shall NOT be negative.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) >= 0 or not(exists(cac:Price/cac:AllowanceCharge/cbc:BaseAmount))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) >= 0 or not(exists(cac:Price/cac:AllowanceCharge/cbc:BaseAmount))">
          <attribute name="id">BR-28</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-28]-The Item gross price (BT-148) shall NOT be negative.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID)">
          <attribute name="id">BR-CO-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-23</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-23]-The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M10" priority="1055">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:Amount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:Amount)">
          <attribute name="id">BR-41</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <attribute name="id">BR-42</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-42]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="true()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="true()">
          <attribute name="id">BR-CO-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-07]-Invoice line allowance reason code (BT-140) and Invoice line allowance reason (BT-139) shall indicate the same type of allowance reason.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <attribute name="id">BR-CO-23</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-23]-Each Invoice line allowance (BG-27) shall contain an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140), or both.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-24</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-24]-The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-25</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-25]-The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M10" priority="1054">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:Amount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:Amount)">
          <attribute name="id">BR-43</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-43]-Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <attribute name="id">BR-44</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-44]-Each Invoice line charge shall have an Invoice line charge reason or an invoice line allowance reason code. </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="true()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="true()">
          <attribute name="id">BR-CO-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-08]-Invoice line charge reason code (BT-145) and Invoice line charge reason (BT-144) shall indicate the same type of charge reason.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <attribute name="id">BR-CO-24</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-24]-Each Invoice line charge (BG-28) shall contain an Invoice line charge reason (BT-144) or an Invoice line charge reason code (BT-145), or both.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-27</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-27]-The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-28</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-28]-The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod" mode="M10" priority="1053">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod" />

		<!--ASSERT -->
<choose>
      <when test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">
          <attribute name="id">BR-30</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-30]-If both Invoice line period start date (BT-134) and Invoice line period end date (BT-135) are given then the Invoice line period end date (BT-135) shall be later or equal to the Invoice line period start date (BT-134).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:StartDate) or exists(cbc:EndDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:StartDate) or exists(cbc:EndDate)">
          <attribute name="id">BR-CO-20</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-20]-If Invoice line period (BG-26) is used, the Invoice line period start date (BT-134) or the Invoice line period end date (BT-135) shall be filled, or both.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoicePeriod" mode="M10" priority="1052">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoicePeriod" />

		<!--ASSERT -->
<choose>
      <when test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">
          <attribute name="id">BR-29</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-29]-If both Invoicing period start date (BT-73) and Invoicing period end date (BT-74) are given then the Invoicing period end date (BT-74) shall be later or equal to the Invoicing period start date (BT-73).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:StartDate) or exists(cbc:EndDate) or (exists(cbc:DescriptionCode) and not(exists(cbc:StartDate)) and not(exists(cbc:EndDate)))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:StartDate) or exists(cbc:EndDate) or (exists(cbc:DescriptionCode) and not(exists(cbc:StartDate)) and not(exists(cbc:EndDate)))">
          <attribute name="id">BR-CO-19</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-19]-If Invoicing period (BG-14) is used, the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled, or both.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="//cac:AdditionalItemProperty" mode="M10" priority="1051">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//cac:AdditionalItemProperty" />

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:Name) and exists(cbc:Value)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:Name) and exists(cbc:Value)">
          <attribute name="id">BR-54</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-54]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" mode="M10" priority="1050">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" />

		<!--ASSERT -->
<choose>
      <when test="exists(@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(@listID)">
          <attribute name="id">BR-65</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-65]-The Item classification identifier (BT-158) shall have a Scheme identifier.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID | cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ID" mode="M10" priority="1049">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID | cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="exists(@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(@schemeID)">
          <attribute name="id">BR-64</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-64]-The Item standard identifier (BT-157) shall have a Scheme identifier.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:Invoice/cbc:Note | /cn:CreditNote/cbc:Note" mode="M10" priority="1048">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cbc:Note | /cn:CreditNote/cbc:Note" />

		<!--ASSERT -->
<choose>
      <when test="(contains(.,'#') and string-length(substring-before(substring-after(.,'#'),'#'))=3 and ( ( contains(' AAA AAB AAC AAD AAE AAF AAG AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABZ ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACM ACN ACO ACP ACQ ACR ACS ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADH ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHW AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ARR ARS AUT AUU AUV AUW AUX AUY AUZ AVA AVB AVC AVD AVE AVF BAG BAH BAI BAJ BAK BAL BAM BAN BAO BAP BAQ BAR BAS BLC BLD BLE BLF BLG BLH BLI BLJ BLK BLL BLM BLN BLO BLP BLQ BLR BLS BLT BLU BLV BLW BLX BLY BLZ BMA BMB BMC BMD BME CCI CEX CHG CIP CLP CLR COI CUR CUS DAR DCL DEL DIN DOC DUT EUR FBC GBL GEN GS7 HAN HAZ ICN IIN IMI IND INS INV IRP ITR ITS LAN LIN LOI MCO MDH MKS ORI OSI PAC PAI PAY PKG PKT PMD PMT PRD PRF PRI PUR QIN QQD QUT RAH REG RET REV RQR SAF SIC SIN SLR SPA SPG SPH SPP SPT SRN SSR SUR TCA TDT TRA TRR TXD WHI ZZZ ',substring-before(substring-after(.,'#'),'#') ) ) )) or not(contains(.,'#')) or not(string-length(substring-before(substring-after(.,'#'),'#'))=3)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(contains(.,'#') and string-length(substring-before(substring-after(.,'#'),'#'))=3 and ( ( contains(' AAA AAB AAC AAD AAE AAF AAG AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABZ ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACM ACN ACO ACP ACQ ACR ACS ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADH ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHW AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ARR ARS AUT AUU AUV AUW AUX AUY AUZ AVA AVB AVC AVD AVE AVF BAG BAH BAI BAJ BAK BAL BAM BAN BAO BAP BAQ BAR BAS BLC BLD BLE BLF BLG BLH BLI BLJ BLK BLL BLM BLN BLO BLP BLQ BLR BLS BLT BLU BLV BLW BLX BLY BLZ BMA BMB BMC BMD BME CCI CEX CHG CIP CLP CLR COI CUR CUS DAR DCL DEL DIN DOC DUT EUR FBC GBL GEN GS7 HAN HAZ ICN IIN IMI IND INS INV IRP ITR ITS LAN LIN LOI MCO MDH MKS ORI OSI PAC PAI PAY PKG PKT PMD PMT PRD PRF PRI PUR QIN QQD QUT RAH REG RET REV RQR SAF SIC SIN SLR SPA SPG SPH SPP SPT SRN SSR SUR TCA TDT TRA TRR TXD WHI ZZZ ',substring-before(substring-after(.,'#'),'#') ) ) )) or not(contains(.,'#')) or not(string-length(substring-before(substring-after(.,'#'),'#'))=3)">
          <attribute name="id">BR-CL-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-08]-Invoiced note subject code shall be coded using UNCL4451</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PayeeParty" mode="M10" priority="1047">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PayeeParty" />

		<!--ASSERT -->
<choose>
      <when test="exists(cac:PartyName/cbc:Name) and (not(cac:PartyName/cbc:Name = ../cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name) and not(cac:PartyIdentification/cbc:ID = ../cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:PartyName/cbc:Name) and (not(cac:PartyName/cbc:Name = ../cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name) and not(cac:PartyIdentification/cbc:ID = ../cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) )">
          <attribute name="id">BR-17</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-17]-The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4)</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount" mode="M10" priority="1046">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:ID) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID) != ''">
          <attribute name="id">BR-50</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-50]-A Payment account identifier (BT-84) shall be present if Credit transfer (BG-17) information is provided in the Invoice.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PaymentMeans" mode="M10" priority="1045">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PaymentMeans" />

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:PaymentMeansCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:PaymentMeansCode)">
          <attribute name="id">BR-49</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(exists(cac:PayeeFinancialAccount/cbc:ID) and ((normalize-space(cbc:PaymentMeansCode) = '30') or (normalize-space(cbc:PaymentMeansCode) = '58') )) or ((normalize-space(cbc:PaymentMeansCode) != '30') and (normalize-space(cbc:PaymentMeansCode) != '58'))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:PayeeFinancialAccount/cbc:ID) and ((normalize-space(cbc:PaymentMeansCode) = '30') or (normalize-space(cbc:PaymentMeansCode) = '58') )) or ((normalize-space(cbc:PaymentMeansCode) != '30') and (normalize-space(cbc:PaymentMeansCode) != '58'))">
          <attribute name="id">BR-61</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-61]-If the Payment means type code (BT-81) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (BT-84) shall be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:BillingReference" mode="M10" priority="1044">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:BillingReference" />

		<!--ASSERT -->
<choose>
      <when test="exists(cac:InvoiceDocumentReference/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:InvoiceDocumentReference/cbc:ID)">
          <attribute name="id">BR-55</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AccountingSupplierParty" mode="M10" priority="1043">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty" />

		<!--ASSERT -->
<choose>
      <when test="exists(cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(cac:Party/cac:PartyIdentification/cbc:ID) or exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(cac:Party/cac:PartyIdentification/cbc:ID) or exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)">
          <attribute name="id">BR-CO-26</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-26]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller VAT identifier (BT-31) shall be present.  </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" mode="M10" priority="1042">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<choose>
      <when test="exists(@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(@schemeID)">
          <attribute name="id">BR-62</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-62]-The Seller electronic address (BT-34) shall have a Scheme identifier.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" mode="M10" priority="1041">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<choose>
      <when test="(cac:Country/cbc:IdentificationCode) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Country/cbc:IdentificationCode) != ''">
          <attribute name="id">BR-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:TaxRepresentativeParty" mode="M10" priority="1040">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<choose>
      <when test="(cac:PartyName/cbc:Name) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyName/cbc:Name) != ''">
          <attribute name="id">BR-18</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-18]-The Seller tax representative name (BT-62) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11)</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:PostalAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:PostalAddress)">
          <attribute name="id">BR-19</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-19]-The Seller tax representative postal address (BG-12) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)">
          <attribute name="id">BR-56</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-56]-Each Seller tax representative party (BG-11) shall have a Seller tax representative VAT identifier (BT-63).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:TaxRepresentativeParty/cac:PostalAddress" mode="M10" priority="1039">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:TaxRepresentativeParty/cac:PostalAddress" />

		<!--ASSERT -->
<choose>
      <when test="(cac:Country/cbc:IdentificationCode) != ''" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Country/cbc:IdentificationCode) != ''">
          <attribute name="id">BR-20</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-20]-The Seller tax representative postal address (BG-12) shall contain a Tax representative country code (BT-69), if the Seller (BG-4) has a Seller tax representative party (BG-11).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal" mode="M10" priority="1038">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)">
          <attribute name="id">BR-CO-14</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:TaxTotal/cac:TaxSubtotal" mode="M10" priority="1037">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxableAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxableAmount)">
          <attribute name="id">BR-45</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxAmount)">
          <attribute name="id">BR-46</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <attribute name="id">BR-47</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')">
          <attribute name="id">BR-48</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 > round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 > round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ))) or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))">
          <attribute name="id">BR-CO-17</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-19</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-19]-The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2">
          <attribute name="id">BR-DEC-20</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-DEC-20]-The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.    </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="//cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1036">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="( contains( ' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ',substring(cbc:CompanyID,1,2) ) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( contains( ' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ',substring(cbc:CompanyID,1,2) ) )">
          <attribute name="id">BR-CO-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CO-09]-The Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) shall have a prefix in accordance with ISO code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece may use the prefix ‘EL’.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1035">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)))))">
          <attribute name="id">BR-AE-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Reverse charge".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(../cbc:TaxAmount) = 0">
          <attribute name="id">BR-AE-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">
          <attribute name="id">BR-AE-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1034">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-AE-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1033">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-AE-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" the Document level charge VAT rate (BT-103) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1032">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-AE-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-AE-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1031">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">
          <attribute name="id">BR-E-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Exempt from VAT".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(../cbc:TaxAmount) = 0">
          <attribute name="id">BR-E-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-09]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">
          <attribute name="id">BR-E-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1030">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-E-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1029">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-E-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1028">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-E-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1027">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)))))">
          <attribute name="id">BR-G-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Export outside the EU".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(../cbc:TaxAmount) = 0">
          <attribute name="id">BR-G-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">
          <attribute name="id">BR-G-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-10]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1026">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-G-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1025">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-G-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1024">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-G-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-G-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1023">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)))))">
          <attribute name="id">BR-IC-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Intra-community supply".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(../cbc:TaxAmount) = 0">
          <attribute name="id">BR-IC-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">
          <attribute name="id">BR-IC-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-10]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1022">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-IC-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1021">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-IC-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" the Document level charge VAT rate (BT-103) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1020">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-IC-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IC-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intracommunity supply" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1019">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))">
          <attribute name="id">BR-IG-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IGIC", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IGIC" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 >  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt; round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 > round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">
          <attribute name="id">BR-IG-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <attribute name="id">BR-IG-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1018">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) >= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) >= 0">
          <attribute name="id">BR-IG-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1017">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) >= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) >= 0">
          <attribute name="id">BR-IG-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1016">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) >= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) >= 0">
          <attribute name="id">BR-IG-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IG-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" the invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1015">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))">
          <attribute name="id">BR-IP-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IPSI", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IPSI" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 >  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt; round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 > round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">
          <attribute name="id">BR-IP-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IPSI" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <attribute name="id">BR-IP-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1014">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) >= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) >= 0">
          <attribute name="id">BR-IP-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1013">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) >= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) >= 0">
          <attribute name="id">BR-IP-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1012">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) >= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) >= 0">
          <attribute name="id">BR-IP-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-IP-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" the Invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1011">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))">
          <attribute name="id">BR-O-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Not subject to VAT".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(../cbc:TaxAmount) = 0">
          <attribute name="id">BR-O-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">
          <attribute name="id">BR-O-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1010">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="not(cbc:Percent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:Percent)">
          <attribute name="id">BR-O-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-06]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1009">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="not(cbc:Percent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:Percent)">
          <attribute name="id">BR-O-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-07]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Not subject to VAT" shall not contain a Document level charge VAT rate (BT-103).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1008">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="not(cbc:Percent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:Percent)">
          <attribute name="id">BR-O-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-O-05]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1007">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))">
          <attribute name="id">BR-S-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "Standard rated" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 >  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt; round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 > round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">
          <attribute name="id">BR-S-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <attribute name="id">BR-S-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1006">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) > 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) > 0">
          <attribute name="id">BR-S-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1005">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) > 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) > 0">
          <attribute name="id">BR-S-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.  </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1004">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(cbc:Percent) > 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:Percent) > 0">
          <attribute name="id">BR-S-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1003">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))">
          <attribute name="id">BR-Z-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amount (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Zero rated".</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(../cbc:TaxAmount) = 0">
          <attribute name="id">BR-Z-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))">
          <attribute name="id">BR-Z-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1002">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-Z-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-Z-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M10" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<choose>
      <when test="(xs:decimal(cbc:Percent) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(xs:decimal(cbc:Percent) = 0)">
          <attribute name="id">BR-Z-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>
  <template match="text()" mode="M10" priority="-1" />
  <template match="@*|node()" mode="M10" priority="-2">
    <apply-templates mode="M10" select="@*|*" />
  </template>

<!--PATTERN UBL-syntax-->


	<!--RULE -->
<template match="cac:AccountingSupplierParty/cac:Party" mode="M11" priority="1013">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party" />

		<!--ASSERT -->
<choose>
      <when test="(count(cac:PartyTaxScheme) &lt;= 2)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:PartyTaxScheme) &lt;= 2)">
          <attribute name="id">UBL-SR-42</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-42]-Party tax scheme shall occur maximum twice in accounting supplier party</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AdditionalDocumentReference" mode="M11" priority="1012">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<choose>
      <when test="(count(cbc:DocumentDescription) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cbc:DocumentDescription) &lt;= 1)">
          <attribute name="id">UBL-SR-33</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-33]-Supporting document description shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((cbc:DocumentTypeCode='130') or ((local-name(/*) = 'CreditNote') and (cbc:DocumentTypeCode='50')) or (not(cbc:ID/@scheme) and not(cbc:DocumentTypeCode)))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((cbc:DocumentTypeCode='130') or ((local-name(/*) = 'CreditNote') and (cbc:DocumentTypeCode='50')) or (not(cbc:ID/@scheme) and not(cbc:DocumentTypeCode)))">
          <attribute name="id">UBL-SR-43</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-43]-Scheme identifier shall only be used for invoiced object (document type code with value 130)</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="//*[ends-with(name(), 'Amount') and not(ends-with(name(),'PriceAmount')) and not(ancestor::cac:Price/cac:AllowanceCharge)]" mode="M11" priority="1011">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//*[ends-with(name(), 'Amount') and not(ends-with(name(),'PriceAmount')) and not(ancestor::cac:Price/cac:AllowanceCharge)]" />

		<!--ASSERT -->
<choose>
      <when test="string-length(substring-after(.,'.'))&lt;=2" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="string-length(substring-after(.,'.'))&lt;=2">
          <attribute name="id">UBL-DT-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-01]-Amounts shall be decimal up to two fraction digits</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="//*[ends-with(name(), 'BinaryObject')]" mode="M11" priority="1010">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//*[ends-with(name(), 'BinaryObject')]" />

		<!--ASSERT -->
<choose>
      <when test="(@mimeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(@mimeCode)">
          <attribute name="id">UBL-DT-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-06]-Binary object elements shall contain the mime code attribute</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(@filename)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(@filename)">
          <attribute name="id">UBL-DT-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-07]-Binary object elements shall contain the file name attribute</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:Delivery" mode="M11" priority="1009">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:Delivery" />

		<!--ASSERT -->
<choose>
      <when test="(count(cac:DeliveryParty/cac:PartyName/cbc:Name) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:DeliveryParty/cac:PartyName/cbc:Name) &lt;= 1)">
          <attribute name="id">UBL-SR-25</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-25]-Deliver to party name shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M11" priority="1008">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<choose>
      <when test="(count(cbc:AllowanceChargeReason) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cbc:AllowanceChargeReason) &lt;= 1)">
          <attribute name="id">UBL-SR-30</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-30]-Document level allowance reason shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M11" priority="1007">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<choose>
      <when test="(count(cbc:AllowanceChargeReason) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cbc:AllowanceChargeReason) &lt;= 1)">
          <attribute name="id">UBL-SR-31</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-31]-Document level charge reason shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:Invoice | /cn:CreditNote" mode="M11" priority="1006">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<choose>
      <when test="not(ext:UBLExtensions)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(ext:UBLExtensions)">
          <attribute name="id">UBL-CR-001</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-001]-A UBL invoice should not include extensions</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:UBLVersionID) or cbc:UBLVersionID = '2.1'" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:UBLVersionID) or cbc:UBLVersionID = '2.1'">
          <attribute name="id">UBL-CR-002</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-002]-A UBL invoice should not include the UBLVersionID or it should be 2.1</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:ProfileExecutionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:ProfileExecutionID)">
          <attribute name="id">UBL-CR-003</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-003]-A UBL invoice should not include the ProfileExecutionID </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-004</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-004]-A UBL invoice should not include the CopyIndicator </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:UUID)">
          <attribute name="id">UBL-CR-005</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-005]-A UBL invoice should not include the UUID </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:IssueTime)">
          <attribute name="id">UBL-CR-006</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-006]-A UBL invoice should not include the IssueTime </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:PricingCurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PricingCurrencyCode)">
          <attribute name="id">UBL-CR-007</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-007]-A UBL invoice should not include the PricingCurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:PaymentCurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PaymentCurrencyCode)">
          <attribute name="id">UBL-CR-008</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-008]-A UBL invoice should not include the PaymentCurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:PaymentAlternativeCurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PaymentAlternativeCurrencyCode)">
          <attribute name="id">UBL-CR-009</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-009]-A UBL invoice should not include the PaymentAlternativeCurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:AccountingCostCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:AccountingCostCode)">
          <attribute name="id">UBL-CR-010</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-010]-A UBL invoice should not include the AccountingCostCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:LineCountNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:LineCountNumeric)">
          <attribute name="id">UBL-CR-011</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-011]-A UBL invoice should not include the LineCountNumeric</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:InvoicePeriod/cbc:StartTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:StartTime)">
          <attribute name="id">UBL-CR-012</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-012]-A UBL invoice should not include the InvoicePeriod StartTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:InvoicePeriod/cbc:EndTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:EndTime)">
          <attribute name="id">UBL-CR-013</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-013]-A UBL invoice should not include the InvoicePeriod EndTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:InvoicePeriod/cbc:DurationMeasure)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:DurationMeasure)">
          <attribute name="id">UBL-CR-014</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-014]-A UBL invoice should not include the InvoicePeriod DurationMeasure</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:InvoicePeriod/cbc:Description)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:Description)">
          <attribute name="id">UBL-CR-015</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-015]-A UBL invoice should not include the InvoicePeriod Description</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OrderReference/cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-016</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-016]-A UBL invoice should not include the OrderReference CopyIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OrderReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:UUID)">
          <attribute name="id">UBL-CR-017</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-017]-A UBL invoice should not include the OrderReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OrderReference/cbc:IssueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:IssueDate)">
          <attribute name="id">UBL-CR-018</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-018]-A UBL invoice should not include the OrderReference IssueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OrderReference/cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:IssueTime)">
          <attribute name="id">UBL-CR-019</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-019]-A UBL invoice should not include the OrderReference IssueTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OrderReference/cbc:CustomerReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:CustomerReference)">
          <attribute name="id">UBL-CR-020</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-020]-A UBL invoice should not include the OrderReference CustomerReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OrderReference/cbc:OrderTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:OrderTypeCode)">
          <attribute name="id">UBL-CR-021</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-021]-A UBL invoice should not include the OrderReference OrderTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OrderReference/cac:DocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cac:DocumentReference)">
          <attribute name="id">UBL-CR-022</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-022]-A UBL invoice should not include the OrderReference DocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-023</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-023]-A UBL invoice should not include the BillingReference CopyIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID)">
          <attribute name="id">UBL-CR-024</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-024]-A UBL invoice should not include the BillingReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueTime)">
          <attribute name="id">UBL-CR-025</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-025]-A UBL invoice should not include the BillingReference IssueTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode)">
          <attribute name="id">UBL-CR-026</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-026]-A UBL invoice should not include the BillingReference DocumentTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentType)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentType)">
          <attribute name="id">UBL-CR-027</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-027]-A UBL invoice should not include the BillingReference DocumentType</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:XPath)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:XPath)">
          <attribute name="id">UBL-CR-028</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-028]-A UBL invoice should not include the BillingReference Xpath</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:LanguageID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:LanguageID)">
          <attribute name="id">UBL-CR-029</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-029]-A UBL invoice should not include the BillingReference LanguageID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:LocaleCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:LocaleCode)">
          <attribute name="id">UBL-CR-030</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-030]-A UBL invoice should not include the BillingReference LocaleCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:VersionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:VersionID)">
          <attribute name="id">UBL-CR-031</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-031]-A UBL invoice should not include the BillingReference VersionID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode)">
          <attribute name="id">UBL-CR-032</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-032]-A UBL invoice should not include the BillingReference DocumentStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentDescription)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentDescription)">
          <attribute name="id">UBL-CR-033</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-033]-A UBL invoice should not include the BillingReference DocumenDescription</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment)">
          <attribute name="id">UBL-CR-034</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-034]-A UBL invoice should not include the BillingReference Attachment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-035</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-035]-A UBL invoice should not include the BillingReference ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:IssuerParty)">
          <attribute name="id">UBL-CR-036</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-036]-A UBL invoice should not include the BillingReference IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:ResultOfVerification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:ResultOfVerification)">
          <attribute name="id">UBL-CR-037</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-037]-A UBL invoice should not include the BillingReference ResultOfVerification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:SelfBilledInvoiceDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:SelfBilledInvoiceDocumentReference)">
          <attribute name="id">UBL-CR-038</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-038]-A UBL invoice should not include the BillingReference SelfBilledInvoiceDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:CreditNoteDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:CreditNoteDocumentReference)">
          <attribute name="id">UBL-CR-039</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-039]-A UBL invoice should not include the BillingReference CreditNoteDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference)">
          <attribute name="id">UBL-CR-040</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-040]-A UBL invoice should not include the BillingReference SelfBilledCreditNoteDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:DebitNoteDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:DebitNoteDocumentReference)">
          <attribute name="id">UBL-CR-041</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-041]-A UBL invoice should not include the BillingReference DebitNoteDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:ReminderDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:ReminderDocumentReference)">
          <attribute name="id">UBL-CR-042</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-042]-A UBL invoice should not include the BillingReference ReminderDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:AdditionalDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:AdditionalDocumentReference)">
          <attribute name="id">UBL-CR-043</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-043]-A UBL invoice should not include the BillingReference AdditionalDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BillingReference/cac:BillingReferenceLine)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:BillingReferenceLine)">
          <attribute name="id">UBL-CR-044</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-044]-A UBL invoice should not include the BillingReference BillingReferenceLine</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-045</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-045]-A UBL invoice should not include the DespatchDocumentReference CopyIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:UUID)">
          <attribute name="id">UBL-CR-046</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-046]-A UBL invoice should not include the DespatchDocumentReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:IssueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:IssueDate)">
          <attribute name="id">UBL-CR-047</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-047]-A UBL invoice should not include the DespatchDocumentReference IssueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:IssueTime)">
          <attribute name="id">UBL-CR-048</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-048]-A UBL invoice should not include the DespatchDocumentReference IssueTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:DocumentTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:DocumentTypeCode)">
          <attribute name="id">UBL-CR-049</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-049]-A UBL invoice should not include the DespatchDocumentReference DocumentTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:DocumentType)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:DocumentType)">
          <attribute name="id">UBL-CR-050</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-050]-A UBL invoice should not include the DespatchDocumentReference DocumentType</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:XPath)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:XPath)">
          <attribute name="id">UBL-CR-051</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-051]-A UBL invoice should not include the DespatchDocumentReference Xpath</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:LanguageID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:LanguageID)">
          <attribute name="id">UBL-CR-052</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-052]-A UBL invoice should not include the DespatchDocumentReference LanguageID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:LocaleCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:LocaleCode)">
          <attribute name="id">UBL-CR-053</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-053]-A UBL invoice should not include the DespatchDocumentReference LocaleCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:VersionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:VersionID)">
          <attribute name="id">UBL-CR-054</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-054]-A UBL invoice should not include the DespatchDocumentReference VersionID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:DocumentStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:DocumentStatusCode)">
          <attribute name="id">UBL-CR-055</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-055]-A UBL invoice should not include the DespatchDocumentReference DocumentStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cbc:DocumentDescription)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cbc:DocumentDescription)">
          <attribute name="id">UBL-CR-056</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-056]-A UBL invoice should not include the DespatchDocumentReference DocumentDescription</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cac:Attachment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cac:Attachment)">
          <attribute name="id">UBL-CR-057</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-057]-A UBL invoice should not include the DespatchDocumentReference Attachment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-058</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-058]-A UBL invoice should not include the DespatchDocumentReference ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cac:IssuerParty)">
          <attribute name="id">UBL-CR-059</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-059]-A UBL invoice should not include the DespatchDocumentReference IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DespatchDocumentReference/cac:ResultOfVerification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference/cac:ResultOfVerification)">
          <attribute name="id">UBL-CR-060</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-060]-A UBL invoice should not include the DespatchDocumentReference ResultOfVerification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-061</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-061]-A UBL invoice should not include the ReceiptDocumentReference CopyIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:UUID)">
          <attribute name="id">UBL-CR-062</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-062]-A UBL invoice should not include the ReceiptDocumentReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:IssueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:IssueDate)">
          <attribute name="id">UBL-CR-063</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-063]-A UBL invoice should not include the ReceiptDocumentReference IssueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:IssueTime)">
          <attribute name="id">UBL-CR-064</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-064]-A UBL invoice should not include the ReceiptDocumentReference IssueTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:DocumentTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:DocumentTypeCode)">
          <attribute name="id">UBL-CR-065</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-065]-A UBL invoice should not include the ReceiptDocumentReference DocumentTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:DocumentType)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:DocumentType)">
          <attribute name="id">UBL-CR-066</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-066]-A UBL invoice should not include the ReceiptDocumentReference DocumentType</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:XPath)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:XPath)">
          <attribute name="id">UBL-CR-067</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-067]-A UBL invoice should not include the ReceiptDocumentReference Xpath</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:LanguageID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:LanguageID)">
          <attribute name="id">UBL-CR-068</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-068]-A UBL invoice should not include the ReceiptDocumentReference LanguageID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:LocaleCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:LocaleCode)">
          <attribute name="id">UBL-CR-069</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-069]-A UBL invoice should not include the ReceiptDocumentReference LocaleCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:VersionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:VersionID)">
          <attribute name="id">UBL-CR-070</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-070]-A UBL invoice should not include the ReceiptDocumentReference VersionID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:DocumentStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:DocumentStatusCode)">
          <attribute name="id">UBL-CR-071</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-071]-A UBL invoice should not include the ReceiptDocumentReference DocumentStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cbc:DocumentDescription)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cbc:DocumentDescription)">
          <attribute name="id">UBL-CR-072</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-072]-A UBL invoice should not include the ReceiptDocumentReference DocumentDescription</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cac:Attachment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cac:Attachment)">
          <attribute name="id">UBL-CR-073</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-073]-A UBL invoice should not include the ReceiptDocumentReference Attachment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-074</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-074]-A UBL invoice should not include the ReceiptDocumentReference ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cac:IssuerParty)">
          <attribute name="id">UBL-CR-075</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-075]-A UBL invoice should not include the ReceiptDocumentReference IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ReceiptDocumentReference/cac:ResultOfVerification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference/cac:ResultOfVerification)">
          <attribute name="id">UBL-CR-076</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-076]-A UBL invoice should not include the ReceiptDocumentReference ResultOfVerification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:StatementDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:StatementDocumentReference)">
          <attribute name="id">UBL-CR-077</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-077]-A UBL invoice should not include the StatementDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-078</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-078]-A UBL invoice should not include the OriginatorDocumentReference CopyIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:UUID)">
          <attribute name="id">UBL-CR-079</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-079]-A UBL invoice should not include the OriginatorDocumentReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:IssueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:IssueDate)">
          <attribute name="id">UBL-CR-080</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-080]-A UBL invoice should not include the OriginatorDocumentReference IssueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:IssueTime)">
          <attribute name="id">UBL-CR-081</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-081]-A UBL invoice should not include the OriginatorDocumentReference IssueTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:DocumentTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:DocumentTypeCode)">
          <attribute name="id">UBL-CR-082</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-082]-A UBL invoice should not include the OriginatorDocumentReference DocumentTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:DocumentType)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:DocumentType)">
          <attribute name="id">UBL-CR-083</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-083]-A UBL invoice should not include the OriginatorDocumentReference DocumentType</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:XPath)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:XPath)">
          <attribute name="id">UBL-CR-084</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-084]-A UBL invoice should not include the OriginatorDocumentReference Xpath</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:LanguageID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:LanguageID)">
          <attribute name="id">UBL-CR-085</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-085]-A UBL invoice should not include the OriginatorDocumentReference LanguageID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:LocaleCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:LocaleCode)">
          <attribute name="id">UBL-CR-086</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-086]-A UBL invoice should not include the OriginatorDocumentReference LocaleCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:VersionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:VersionID)">
          <attribute name="id">UBL-CR-087</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-087]-A UBL invoice should not include the OriginatorDocumentReference VersionID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:DocumentStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:DocumentStatusCode)">
          <attribute name="id">UBL-CR-088</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-088]-A UBL invoice should not include the OriginatorDocumentReference DocumentStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cbc:DocumentDescription)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cbc:DocumentDescription)">
          <attribute name="id">UBL-CR-089</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-089]-A UBL invoice should not include the OriginatorDocumentReference DocumentDescription</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cac:Attachment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cac:Attachment)">
          <attribute name="id">UBL-CR-090</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-090]-A UBL invoice should not include the OriginatorDocumentReference Attachment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-091</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-091]-A UBL invoice should not include the OriginatorDocumentReference ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cac:IssuerParty)">
          <attribute name="id">UBL-CR-092</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-092]-A UBL invoice should not include the OriginatorDocumentReference IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:OriginatorDocumentReference/cac:ResultOfVerification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference/cac:ResultOfVerification)">
          <attribute name="id">UBL-CR-093</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-093]-A UBL invoice should not include the OriginatorDocumentReference ResultOfVerification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-094</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-094]-A UBL invoice should not include the ContractDocumentReference CopyIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:UUID)">
          <attribute name="id">UBL-CR-095</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-095]-A UBL invoice should not include the ContractDocumentReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:IssueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:IssueDate)">
          <attribute name="id">UBL-CR-096</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-096]-A UBL invoice should not include the ContractDocumentReference IssueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:IssueTime)">
          <attribute name="id">UBL-CR-097</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-097]-A UBL invoice should not include the ContractDocumentReference IssueTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:DocumentTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:DocumentTypeCode)">
          <attribute name="id">UBL-CR-098</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-098]-A UBL invoice should not include the ContractDocumentReference DocumentTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:DocumentType)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:DocumentType)">
          <attribute name="id">UBL-CR-099</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-099]-A UBL invoice should not include the ContractDocumentReference DocumentType</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:XPath)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:XPath)">
          <attribute name="id">UBL-CR-100</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-100]-A UBL invoice should not include the ContractDocumentReference Xpath</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:LanguageID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:LanguageID)">
          <attribute name="id">UBL-CR-101</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-101]-A UBL invoice should not include the ContractDocumentReference LanguageID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:LocaleCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:LocaleCode)">
          <attribute name="id">UBL-CR-102</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-102]-A UBL invoice should not include the ContractDocumentReference LocaleCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:VersionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:VersionID)">
          <attribute name="id">UBL-CR-103</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-103]-A UBL invoice should not include the ContractDocumentReference VersionID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:DocumentStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:DocumentStatusCode)">
          <attribute name="id">UBL-CR-104</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-104]-A UBL invoice should not include the ContractDocumentReference DocumentStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cbc:DocumentDescription)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:DocumentDescription)">
          <attribute name="id">UBL-CR-105</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-105]-A UBL invoice should not include the ContractDocumentReference DocumentDescription</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cac:Attachment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cac:Attachment)">
          <attribute name="id">UBL-CR-106</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-106]-A UBL invoice should not include the ContractDocumentReference Attachment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-107</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-107]-A UBL invoice should not include the ContractDocumentReference ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cac:IssuerParty)">
          <attribute name="id">UBL-CR-108</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-108]-A UBL invoice should not include the ContractDocumentReference IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ContractDocumentReference/cac:ResultOfVerification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cac:ResultOfVerification)">
          <attribute name="id">UBL-CR-109</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-109]-A UBL invoice should not include the ContractDocumentReference ResultOfVerification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-110</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-110]-A UBL invoice should not include the AdditionalDocumentReference CopyIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:UUID)">
          <attribute name="id">UBL-CR-111</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-111]-A UBL invoice should not include the AdditionalDocumentReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:IssueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:IssueDate)">
          <attribute name="id">UBL-CR-112</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-112]-A UBL invoice should not include the AdditionalDocumentReference IssueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:IssueTime)">
          <attribute name="id">UBL-CR-113</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-113]-A UBL invoice should not include the AdditionalDocumentReference IssueTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:DocumentType)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:DocumentType)">
          <attribute name="id">UBL-CR-114</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-114]-A UBL invoice should not include the AdditionalDocumentReference DocumentType</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:XPath)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:XPath)">
          <attribute name="id">UBL-CR-115</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-115]-A UBL invoice should not include the AdditionalDocumentReference Xpath</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:LanguageID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:LanguageID)">
          <attribute name="id">UBL-CR-116</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-116]-A UBL invoice should not include the AdditionalDocumentReference LanguageID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:LocaleCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:LocaleCode)">
          <attribute name="id">UBL-CR-117</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-117]-A UBL invoice should not include the AdditionalDocumentReference LocaleCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:VersionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:VersionID)">
          <attribute name="id">UBL-CR-118</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-118]-A UBL invoice should not include the AdditionalDocumentReference VersionID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:DocumentStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:DocumentStatusCode)">
          <attribute name="id">UBL-CR-119</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-119]-A UBL invoice should not include the AdditionalDocumentReference DocumentStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash)">
          <attribute name="id">UBL-CR-121</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-121]-A UBL invoice should not include the AdditionalDocumentReference Attachment External DocumentHash</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod)">
          <attribute name="id">UBL-CR-122</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-122]-A UBL invoice should not include the AdditionalDocumentReference Attachment External HashAlgorithmMethod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate)">
          <attribute name="id">UBL-CR-123</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-123]-A UBL invoice should not include the AdditionalDocumentReference Attachment External ExpiryDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime)">
          <attribute name="id">UBL-CR-124</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-124]-A UBL invoice should not include the AdditionalDocumentReference Attachment External ExpiryTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode)">
          <attribute name="id">UBL-CR-125</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-125]-A UBL invoice should not include the AdditionalDocumentReference Attachment External MimeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FormatCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FormatCode)">
          <attribute name="id">UBL-CR-126</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-126]-A UBL invoice should not include the AdditionalDocumentReference Attachment External FormatCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:EncodingCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:EncodingCode)">
          <attribute name="id">UBL-CR-127</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-127]-A UBL invoice should not include the AdditionalDocumentReference Attachment External EncodingCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:CharacterSetCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:CharacterSetCode)">
          <attribute name="id">UBL-CR-128</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-128]-A UBL invoice should not include the AdditionalDocumentReference Attachment External CharacterSetCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)">
          <attribute name="id">UBL-CR-129</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-129]-A UBL invoice should not include the AdditionalDocumentReference Attachment External FileName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:Description)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:Description)">
          <attribute name="id">UBL-CR-130</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-130]-A UBL invoice should not include the AdditionalDocumentReference Attachment External Descriprion</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-131</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-131]-A UBL invoice should not include the AdditionalDocumentReference ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:IssuerParty)">
          <attribute name="id">UBL-CR-132</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-132]-A UBL invoice should not include the AdditionalDocumentReference IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cac:ResultOfVerification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:ResultOfVerification)">
          <attribute name="id">UBL-CR-133</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-133]-A UBL invoice should not include the AdditionalDocumentReference ResultOfVerification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ProjectReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ProjectReference/cbc:UUID)">
          <attribute name="id">UBL-CR-134</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-134]-A UBL invoice should not include the ProjectReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ProjectReference/cbc:IssueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ProjectReference/cbc:IssueDate)">
          <attribute name="id">UBL-CR-135</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-135]-A UBL invoice should not include the ProjectReference IssueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:ProjectReference/cac:WorkPhaseReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:ProjectReference/cac:WorkPhaseReference)">
          <attribute name="id">UBL-CR-136</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-136]-A UBL invoice should not include the ProjectReference WorkPhaseReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Signature)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Signature)">
          <attribute name="id">UBL-CR-137</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-137]-A UBL invoice should not include the Signature</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID)">
          <attribute name="id">UBL-CR-138</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-138]-A UBL invoice should not include the AccountingSupplierParty CustomerAssignedAccountID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID)">
          <attribute name="id">UBL-CR-139</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-139]-A UBL invoice should not include the AccountingSupplierParty AdditionalAccountID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability)">
          <attribute name="id">UBL-CR-140</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-140]-A UBL invoice should not include the AccountingSupplierParty DataSendingCapability</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator)">
          <attribute name="id">UBL-CR-141</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-141]-A UBL invoice should not include the AccountingSupplierParty Party MarkCareIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator)">
          <attribute name="id">UBL-CR-142</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-142]-A UBL invoice should not include the AccountingSupplierParty Party MarkAttentionIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI)">
          <attribute name="id">UBL-CR-143</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-143]-A UBL invoice should not include the AccountingSupplierParty Party WebsiteURI</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID)">
          <attribute name="id">UBL-CR-144</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-144]-A UBL invoice should not include the AccountingSupplierParty Party LogoReferenceID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cbc:IndustryClassificationCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:IndustryClassificationCode)">
          <attribute name="id">UBL-CR-145</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-145]-A UBL invoice should not include the AccountingSupplierParty Party IndustryClassificationCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:Language)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Language)">
          <attribute name="id">UBL-CR-146</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-146]-A UBL invoice should not include the AccountingSupplierParty Party Language</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:ID)">
          <attribute name="id">UBL-CR-147</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-147]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode)">
          <attribute name="id">UBL-CR-148</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-148]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress AddressTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode)">
          <attribute name="id">UBL-CR-149</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-149]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress AddressFormatCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Postbox)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Postbox)">
          <attribute name="id">UBL-CR-150</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-150]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Postbox</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor)">
          <attribute name="id">UBL-CR-151</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-151]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Floor</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room)">
          <attribute name="id">UBL-CR-152</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-152]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Room</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName)">
          <attribute name="id">UBL-CR-153</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-153]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BlockName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName)">
          <attribute name="id">UBL-CR-154</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-154]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BuildingName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber)">
          <attribute name="id">UBL-CR-155</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-155]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BuildingNumber</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail)">
          <attribute name="id">UBL-CR-156</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-156]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress InhouseMail</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Department)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Department)">
          <attribute name="id">UBL-CR-157</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-157]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Department</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention)">
          <attribute name="id">UBL-CR-158</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-158]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress MarkAttention</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare)">
          <attribute name="id">UBL-CR-159</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-159]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress MarkCare</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)">
          <attribute name="id">UBL-CR-160</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-160]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress PlotIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)">
          <attribute name="id">UBL-CR-161</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-161]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress CitySubdivisionName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)">
          <attribute name="id">UBL-CR-162</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-162]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress CountrySubentityCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region)">
          <attribute name="id">UBL-CR-163</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-163]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Region</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District)">
          <attribute name="id">UBL-CR-164</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-164]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress District</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset)">
          <attribute name="id">UBL-CR-165</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-165]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress TimezoneOffset</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name)">
          <attribute name="id">UBL-CR-166</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-166]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Country Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate)">
          <attribute name="id">UBL-CR-167</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-167]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress LocationCoordinate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation)">
          <attribute name="id">UBL-CR-168</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-168]-A UBL invoice should not include the AccountingSupplierParty Party PhysicalLocation</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName)">
          <attribute name="id">UBL-CR-169</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-169]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme RegistrationName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode)">
          <attribute name="id">UBL-CR-170</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-170]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxLevelCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">
          <attribute name="id">UBL-CR-171</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-171]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme ExemptionReasonCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason)">
          <attribute name="id">UBL-CR-172</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-172]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme ExemptionReason</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress)">
          <attribute name="id">UBL-CR-173</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-173]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme RegistrationAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">
          <attribute name="id">UBL-CR-174</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-174]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">
          <attribute name="id">UBL-CR-175</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-175]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme TaxTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">
          <attribute name="id">UBL-CR-176</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-176]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme CurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">
          <attribute name="id">UBL-CR-177</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-177]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme JurisdictionRegionAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationDate)">
          <attribute name="id">UBL-CR-178</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-178]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">
          <attribute name="id">UBL-CR-179</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-179]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationExpirationDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">
          <attribute name="id">UBL-CR-180</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-180]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CompanyLegalFormCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">
          <attribute name="id">UBL-CR-181</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-181]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity SoleProprietorshipIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">
          <attribute name="id">UBL-CR-182</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-182]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CompanyLiquidationStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CorporateStockAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CorporateStockAmount)">
          <attribute name="id">UBL-CR-183</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-183]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CorporationStockAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">
          <attribute name="id">UBL-CR-184</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-184]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity FullyPaidSharesIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress)">
          <attribute name="id">UBL-CR-185</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-185]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">
          <attribute name="id">UBL-CR-186</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-186]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CorporateRegistrationScheme</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:HeadOfficeParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:HeadOfficeParty)">
          <attribute name="id">UBL-CR-187</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-187]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity HeadOfficeParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:ShareholderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:ShareholderParty)">
          <attribute name="id">UBL-CR-188</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-188]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity ShareholderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ID)">
          <attribute name="id">UBL-CR-189</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-189]-A UBL invoice should not include the AccountingSupplierParty Party Contact ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telefax)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telefax)">
          <attribute name="id">UBL-CR-190</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-190]-A UBL invoice should not include the AccountingSupplierParty Party Contact Telefax</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note)">
          <attribute name="id">UBL-CR-191</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-191]-A UBL invoice should not include the AccountingSupplierParty Party Contact Note</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication)">
          <attribute name="id">UBL-CR-192</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-192]-A UBL invoice should not include the AccountingSupplierParty Party Contact OtherCommunication</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person)">
          <attribute name="id">UBL-CR-193</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-193]-A UBL invoice should not include the AccountingSupplierParty Party Person</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty)">
          <attribute name="id">UBL-CR-194</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-194]-A UBL invoice should not include the AccountingSupplierParty Party AgentParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty)">
          <attribute name="id">UBL-CR-195</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-195]-A UBL invoice should not include the AccountingSupplierParty Party ServiceProviderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:PowerOfAttorney)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PowerOfAttorney)">
          <attribute name="id">UBL-CR-196</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-196]-A UBL invoice should not include the AccountingSupplierParty Party PowerOfAttorney</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:Party/cac:FinancialAccount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:FinancialAccount)">
          <attribute name="id">UBL-CR-197</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-197]-A UBL invoice should not include the AccountingSupplierParty Party FinancialAccount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:DespatchContact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:DespatchContact)">
          <attribute name="id">UBL-CR-198</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-198]-A UBL invoice should not include the AccountingSupplierParty DespatchContact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:AccountingContact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:AccountingContact)">
          <attribute name="id">UBL-CR-199</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-199]-A UBL invoice should not include the AccountingSupplierParty AccountingContact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingSupplierParty/cac:SellerContact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:SellerContact)">
          <attribute name="id">UBL-CR-200</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-200]-A UBL invoice should not include the AccountingSupplierParty SellerContact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID)">
          <attribute name="id">UBL-CR-201</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-201]-A UBL invoice should not include the AccountingCustomerParty CustomerAssignedAccountID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID)">
          <attribute name="id">UBL-CR-202</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-202]-A UBL invoice should not include the AccountingCustomerParty SupplierAssignedAccountID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID)">
          <attribute name="id">UBL-CR-203</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-203]-A UBL invoice should not include the AccountingCustomerParty AdditionalAccountID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator)">
          <attribute name="id">UBL-CR-204</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-204]-A UBL invoice should not include the AccountingCustomerParty Party MarkCareIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator)">
          <attribute name="id">UBL-CR-205</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-205]-A UBL invoice should not include the AccountingCustomerParty Party MarkAttentionIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI)">
          <attribute name="id">UBL-CR-206</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-206]-A UBL invoice should not include the AccountingCustomerParty Party WebsiteURI</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID)">
          <attribute name="id">UBL-CR-207</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-207]-A UBL invoice should not include the AccountingCustomerParty Party LogoReferenceID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cbc:IndustryClassificationCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:IndustryClassificationCode)">
          <attribute name="id">UBL-CR-208</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-208]-A UBL invoice should not include the AccountingCustomerParty Party IndustryClassificationCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:Language)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Language)">
          <attribute name="id">UBL-CR-209</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-209]-A UBL invoice should not include the AccountingCustomerParty Party Language</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:ID)">
          <attribute name="id">UBL-CR-210</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-210]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode)">
          <attribute name="id">UBL-CR-211</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-211]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress AddressTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode)">
          <attribute name="id">UBL-CR-212</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-212]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress AddressFormatCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Postbox)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Postbox)">
          <attribute name="id">UBL-CR-213</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-213]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Postbox</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor)">
          <attribute name="id">UBL-CR-214</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-214]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Floor</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room)">
          <attribute name="id">UBL-CR-215</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-215]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Room</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName)">
          <attribute name="id">UBL-CR-216</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-216]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BlockName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName)">
          <attribute name="id">UBL-CR-217</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-217]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BuildingName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber)">
          <attribute name="id">UBL-CR-218</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-218]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BuildingNumber</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail)">
          <attribute name="id">UBL-CR-219</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-219]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress InhouseMail</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Department)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Department)">
          <attribute name="id">UBL-CR-220</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-220]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Department</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention)">
          <attribute name="id">UBL-CR-221</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-221]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress MarkAttention</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare)">
          <attribute name="id">UBL-CR-222</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-222]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress MarkCare</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)">
          <attribute name="id">UBL-CR-223</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-223]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress PlotIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)">
          <attribute name="id">UBL-CR-224</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-224]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress CitySubdivisionName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)">
          <attribute name="id">UBL-CR-225</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-225]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress CountrySubentityCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region)">
          <attribute name="id">UBL-CR-226</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-226]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Region</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District)">
          <attribute name="id">UBL-CR-227</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-227]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress District</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset)">
          <attribute name="id">UBL-CR-228</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-228]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress TimezoneOffset</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name)">
          <attribute name="id">UBL-CR-229</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-229]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Country Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate)">
          <attribute name="id">UBL-CR-230</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-230]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress LocationCoordinate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation)">
          <attribute name="id">UBL-CR-231</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-231]-A UBL invoice should not include the AccountingCustomerParty Party PhysicalLocation</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName)">
          <attribute name="id">UBL-CR-232</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-232]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme RegistrationName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode)">
          <attribute name="id">UBL-CR-233</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-233]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxLevelCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">
          <attribute name="id">UBL-CR-234</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-234]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme ExemptionReasonCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason)">
          <attribute name="id">UBL-CR-235</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-235]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme ExemptionReason</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress)">
          <attribute name="id">UBL-CR-236</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-236]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme RegistrationAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">
          <attribute name="id">UBL-CR-237</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-237]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">
          <attribute name="id">UBL-CR-238</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-238]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme TaxTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">
          <attribute name="id">UBL-CR-239</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-239]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme CurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">
          <attribute name="id">UBL-CR-240</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-240]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme JurisdictionRegionAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationDate)">
          <attribute name="id">UBL-CR-241</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-241]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">
          <attribute name="id">UBL-CR-242</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-242]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationExpirationDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">
          <attribute name="id">UBL-CR-243</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-243]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLegalFormCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm)">
          <attribute name="id">UBL-CR-244</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-244]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLegalForm</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">
          <attribute name="id">UBL-CR-245</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-245]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity SoleProprietorshipIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">
          <attribute name="id">UBL-CR-246</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-246]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLiquidationStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CorporateStockAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CorporateStockAmount)">
          <attribute name="id">UBL-CR-247</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-247]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CorporationStockAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">
          <attribute name="id">UBL-CR-248</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-248]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity FullyPaidSharesIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress)">
          <attribute name="id">UBL-CR-249</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-249]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">
          <attribute name="id">UBL-CR-250</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-250]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CorporateRegistrationScheme</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:HeadOfficeParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:HeadOfficeParty)">
          <attribute name="id">UBL-CR-251</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-251]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity HeadOfficeParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:ShareholderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:ShareholderParty)">
          <attribute name="id">UBL-CR-252</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-252]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity ShareholderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID)">
          <attribute name="id">UBL-CR-253</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-253]-A UBL invoice should not include the AccountingCustomerParty Party Contact ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telefax)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telefax)">
          <attribute name="id">UBL-CR-254</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-254]-A UBL invoice should not include the AccountingCustomerParty Party Contact Telefax</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note)">
          <attribute name="id">UBL-CR-255</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-255]-A UBL invoice should not include the AccountingCustomerParty Party Contact Note</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication)">
          <attribute name="id">UBL-CR-256</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-256]-A UBL invoice should not include the AccountingCustomerParty Party Contact OtherCommunication</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person)">
          <attribute name="id">UBL-CR-257</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-257]-A UBL invoice should not include the AccountingCustomerParty Party Person</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty)">
          <attribute name="id">UBL-CR-258</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-258]-A UBL invoice should not include the AccountingCustomerParty Party AgentParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty)">
          <attribute name="id">UBL-CR-259</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-259]-A UBL invoice should not include the AccountingCustomerParty Party ServiceProviderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:PowerOfAttorney)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PowerOfAttorney)">
          <attribute name="id">UBL-CR-260</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-260]-A UBL invoice should not include the AccountingCustomerParty Party PowerOfAttorney</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:Party/cac:FinancialAccount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:FinancialAccount)">
          <attribute name="id">UBL-CR-261</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-261]-A UBL invoice should not include the AccountingCustomerParty Party FinancialAccount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:DeliveryContact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:DeliveryContact)">
          <attribute name="id">UBL-CR-262</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-262]-A UBL invoice should not include the AccountingCustomerParty DeliveryContact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:AccountingContact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:AccountingContact)">
          <attribute name="id">UBL-CR-263</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-263]-A UBL invoice should not include the AccountingCustomerParty AccountingContact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AccountingCustomerParty/cac:BuyerContact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:BuyerContact)">
          <attribute name="id">UBL-CR-264</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-264]-A UBL invoice should not include the AccountingCustomerParty BuyerContact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cbc:MarkCareIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:MarkCareIndicator)">
          <attribute name="id">UBL-CR-265</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-265]-A UBL invoice should not include the PayeeParty MarkCareIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cbc:MarkAttentionIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:MarkAttentionIndicator)">
          <attribute name="id">UBL-CR-266</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-266]-A UBL invoice should not include the PayeeParty MarkAttentionIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cbc:WebsiteURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:WebsiteURI)">
          <attribute name="id">UBL-CR-267</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-267]-A UBL invoice should not include the PayeeParty WebsiteURI</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cbc:LogoReferenceID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:LogoReferenceID)">
          <attribute name="id">UBL-CR-268</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-268]-A UBL invoice should not include the PayeeParty LogoReferenceID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cbc:EndpointID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:EndpointID)">
          <attribute name="id">UBL-CR-269</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-269]-A UBL invoice should not include the PayeeParty EndpointID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cbc:IndustryClassificationCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:IndustryClassificationCode)">
          <attribute name="id">UBL-CR-270</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-270]-A UBL invoice should not include the PayeeParty IndustryClassificationCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:Language)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Language)">
          <attribute name="id">UBL-CR-271</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-271]-A UBL invoice should not include the PayeeParty Language</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PostalAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PostalAddress)">
          <attribute name="id">UBL-CR-272</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-272]-A UBL invoice should not include the PayeeParty PostalAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PhysicalLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PhysicalLocation)">
          <attribute name="id">UBL-CR-273</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-273]-A UBL invoice should not include the PayeeParty PhysicalLocation</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyTaxScheme)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyTaxScheme)">
          <attribute name="id">UBL-CR-274</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-274]-A UBL invoice should not include the PayeeParty PartyTaxScheme</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName)">
          <attribute name="id">UBL-CR-275</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-275]-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationDate)">
          <attribute name="id">UBL-CR-276</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-276]-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">
          <attribute name="id">UBL-CR-277</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-277]-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationExpirationDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">
          <attribute name="id">UBL-CR-278</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-278]-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLegalFormCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLegalForm)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLegalForm)">
          <attribute name="id">UBL-CR-279</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-279]-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLegalForm</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">
          <attribute name="id">UBL-CR-280</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-280]-A UBL invoice should not include the PayeeParty PartyLegalEntity SoleProprietorshipIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">
          <attribute name="id">UBL-CR-281</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-281]-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLiquidationStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CorporateStockAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CorporateStockAmount)">
          <attribute name="id">UBL-CR-282</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-282]-A UBL invoice should not include the PayeeParty PartyLegalEntity CorporationStockAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">
          <attribute name="id">UBL-CR-283</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-283]-A UBL invoice should not include the PayeeParty PartyLegalEntity FullyPaidSharesIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress)">
          <attribute name="id">UBL-CR-284</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-284]-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">
          <attribute name="id">UBL-CR-285</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-285]-A UBL invoice should not include the PayeeParty PartyLegalEntity CorporateRegistrationScheme</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:HeadOfficeParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:HeadOfficeParty)">
          <attribute name="id">UBL-CR-286</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-286]-A UBL invoice should not include the PayeeParty PartyLegalEntity HeadOfficeParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:ShareholderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:ShareholderParty)">
          <attribute name="id">UBL-CR-287</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-287]-A UBL invoice should not include the PayeeParty PartyLegalEntity ShareholderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:Contact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Contact)">
          <attribute name="id">UBL-CR-288</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-288]-A UBL invoice should not include the PayeeParty Contact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:Person)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Person)">
          <attribute name="id">UBL-CR-289</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-289]-A UBL invoice should not include the PayeeParty Person</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:AgentParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:AgentParty)">
          <attribute name="id">UBL-CR-290</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-290]-A UBL invoice should not include the PayeeParty AgentParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:ServiceProviderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:ServiceProviderParty)">
          <attribute name="id">UBL-CR-291</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-291]-A UBL invoice should not include the PayeeParty ServiceProviderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:PowerOfAttorney)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PowerOfAttorney)">
          <attribute name="id">UBL-CR-292</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-292]-A UBL invoice should not include the PayeeParty PowerOfAttorney</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PayeeParty/cac:FinancialAccount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:FinancialAccount)">
          <attribute name="id">UBL-CR-293</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-293]-A UBL invoice should not include the PayeeParty FinancialAccount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:BuyerCustomerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:BuyerCustomerParty)">
          <attribute name="id">UBL-CR-294</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-294]-A UBL invoice should not include the BuyerCustomerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:SellerSupplierParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:SellerSupplierParty)">
          <attribute name="id">UBL-CR-295</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-295]-A UBL invoice should not include the SellerSupplierParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cbc:MarkCareIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cbc:MarkCareIndicator)">
          <attribute name="id">UBL-CR-296</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-296]-A UBL invoice should not include the TaxRepresentativeParty MarkCareIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cbc:MarkAttentionIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cbc:MarkAttentionIndicator)">
          <attribute name="id">UBL-CR-297</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-297]-A UBL invoice should not include the TaxRepresentativeParty MarkAttentionIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cbc:WebsiteURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cbc:WebsiteURI)">
          <attribute name="id">UBL-CR-298</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-298]-A UBL invoice should not include the TaxRepresentativeParty WebsiteURI</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cbc:LogoReferenceID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cbc:LogoReferenceID)">
          <attribute name="id">UBL-CR-299</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-299]-A UBL invoice should not include the TaxRepresentativeParty LogoReferenceID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cbc:EndpointID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cbc:EndpointID)">
          <attribute name="id">UBL-CR-300</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-300]-A UBL invoice should not include the TaxRepresentativeParty EndpointID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cbc:IndustryClassificationCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cbc:IndustryClassificationCode)">
          <attribute name="id">UBL-CR-301</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-301]-A UBL invoice should not include the TaxRepresentativeParty IndustryClassificationCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyIdentification)">
          <attribute name="id">UBL-CR-302</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-302]-A UBL invoice should not include the TaxRepresentativeParty PartyIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:Language)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:Language)">
          <attribute name="id">UBL-CR-303</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-303]-A UBL invoice should not include the TaxRepresentativeParty Language</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:ID)">
          <attribute name="id">UBL-CR-304</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-304]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AddressTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AddressTypeCode)">
          <attribute name="id">UBL-CR-305</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-305]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress AddressTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AddressFormatCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AddressFormatCode)">
          <attribute name="id">UBL-CR-306</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-306]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress AddressFormatCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Postbox)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Postbox)">
          <attribute name="id">UBL-CR-307</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-307]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Postbox</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Floor)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Floor)">
          <attribute name="id">UBL-CR-308</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-308]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Floor</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Room)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Room)">
          <attribute name="id">UBL-CR-309</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-309]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Room</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BlockName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BlockName)">
          <attribute name="id">UBL-CR-310</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-310]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BlockName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BuildingName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BuildingName)">
          <attribute name="id">UBL-CR-311</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-311]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BuildingName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BuildingNumber)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BuildingNumber)">
          <attribute name="id">UBL-CR-312</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-312]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BuildingNumber</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:InhouseMail)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:InhouseMail)">
          <attribute name="id">UBL-CR-313</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-313]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress InhouseMail</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Department)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Department)">
          <attribute name="id">UBL-CR-314</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-314]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Department</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:MarkAttention)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:MarkAttention)">
          <attribute name="id">UBL-CR-315</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-315]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress MarkAttention</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:MarkCare)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:MarkCare)">
          <attribute name="id">UBL-CR-316</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-316]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress MarkCare</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PlotIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PlotIdentification)">
          <attribute name="id">UBL-CR-317</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-317]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress PlotIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CitySubdivisionName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CitySubdivisionName)">
          <attribute name="id">UBL-CR-318</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-318]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress CitySubdivisionName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentityCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentityCode)">
          <attribute name="id">UBL-CR-319</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-319]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress CountrySubentityCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Region)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Region)">
          <attribute name="id">UBL-CR-320</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-320]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Region</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:District)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:District)">
          <attribute name="id">UBL-CR-321</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-321]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress District</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:TimezoneOffset)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:TimezoneOffset)">
          <attribute name="id">UBL-CR-322</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-322]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress TimezoneOffset</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:Name)">
          <attribute name="id">UBL-CR-323</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-323]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Country Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cac:LocationCoordinate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cac:LocationCoordinate)">
          <attribute name="id">UBL-CR-324</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-324]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress LocationCoordinate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PhysicalLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PhysicalLocation)">
          <attribute name="id">UBL-CR-325</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-325]-A UBL invoice should not include the TaxRepresentativeParty PhysicalLocation</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:RegistrationName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:RegistrationName)">
          <attribute name="id">UBL-CR-326</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-326]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme RegistrationName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:TaxLevelCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:TaxLevelCode)">
          <attribute name="id">UBL-CR-327</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-327]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxLevelCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:ExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">
          <attribute name="id">UBL-CR-328</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-328]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme ExemptionReasonCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:ExemptionReason)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:ExemptionReason)">
          <attribute name="id">UBL-CR-329</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-329]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme ExemptionReason</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:RegistrationAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:RegistrationAddress)">
          <attribute name="id">UBL-CR-330</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-330]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme RegistrationAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">
          <attribute name="id">UBL-CR-331</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-331]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">
          <attribute name="id">UBL-CR-332</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-332]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme TaxTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">
          <attribute name="id">UBL-CR-333</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-333]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme CurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">
          <attribute name="id">UBL-CR-334</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-334]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme JurisdictionRegionAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PartyLegalEntity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PartyLegalEntity)">
          <attribute name="id">UBL-CR-335</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-335]-A UBL invoice should not include the TaxRepresentativeParty PartyLegalEntity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:Contact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:Contact)">
          <attribute name="id">UBL-CR-336</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-336]-A UBL invoice should not include the TaxRepresentativeParty Contact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:Person)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:Person)">
          <attribute name="id">UBL-CR-337</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-337]-A UBL invoice should not include the TaxRepresentativeParty Person</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:AgentParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:AgentParty)">
          <attribute name="id">UBL-CR-338</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-338]-A UBL invoice should not include the TaxRepresentativeParty AgentParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:ServiceProviderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:ServiceProviderParty)">
          <attribute name="id">UBL-CR-339</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-339]-A UBL invoice should not include the TaxRepresentativeParty ServiceProviderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:PowerOfAttorney)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:PowerOfAttorney)">
          <attribute name="id">UBL-CR-340</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-340]-A UBL invoice should not include the TaxRepresentativeParty PowerOfAttorney</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxRepresentativeParty/cac:FinancialAccount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty/cac:FinancialAccount)">
          <attribute name="id">UBL-CR-341</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-341]-A UBL invoice should not include the TaxRepresentativeParty FinancialAccount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ID)">
          <attribute name="id">UBL-CR-342</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-342]-A UBL invoice should not include the Delivery ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:Quantity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:Quantity)">
          <attribute name="id">UBL-CR-343</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-343]-A UBL invoice should not include the Delivery Quantity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:MinimumQuantity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:MinimumQuantity)">
          <attribute name="id">UBL-CR-344</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-344]-A UBL invoice should not include the Delivery MinimumQuantity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:MaximumQuantity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:MaximumQuantity)">
          <attribute name="id">UBL-CR-345</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-345]-A UBL invoice should not include the Delivery MaximumQuantity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:ActualDeliveryTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ActualDeliveryTime)">
          <attribute name="id">UBL-CR-346</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-346]-A UBL invoice should not include the Delivery ActualDeliveryTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:LatestDeliveryDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:LatestDeliveryDate)">
          <attribute name="id">UBL-CR-347</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-347]-A UBL invoice should not include the Delivery LatestDeliveryDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:LatestDeliveryTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:LatestDeliveryTime)">
          <attribute name="id">UBL-CR-348</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-348]-A UBL invoice should not include the Delivery LatestDeliveryTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:ReleaseID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ReleaseID)">
          <attribute name="id">UBL-CR-349</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-349]-A UBL invoice should not include the Delivery ReleaseID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cbc:TrackingID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:TrackingID)">
          <attribute name="id">UBL-CR-350</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-350]-A UBL invoice should not include the Delivery TrackingID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description)">
          <attribute name="id">UBL-CR-351</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-351]-A UBL invoice should not include the Delivery DeliveryLocation Description</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions)">
          <attribute name="id">UBL-CR-352</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-352]-A UBL invoice should not include the Delivery DeliveryLocation Conditions</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity)">
          <attribute name="id">UBL-CR-353</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-353]-A UBL invoice should not include the Delivery DeliveryLocation CountrySubentity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode)">
          <attribute name="id">UBL-CR-354</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-354]-A UBL invoice should not include the Delivery DeliveryLocation CountrySubentityCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cbc:LocationTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:LocationTypeCode)">
          <attribute name="id">UBL-CR-355</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-355]-A UBL invoice should not include the Delivery DeliveryLocation LocationTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cbc:InformationURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:InformationURI)">
          <attribute name="id">UBL-CR-356</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-356]-A UBL invoice should not include the Delivery DeliveryLocation InformationURI</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Name)">
          <attribute name="id">UBL-CR-357</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-357]-A UBL invoice should not include the Delivery DeliveryLocation Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-358</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-358]-A UBL invoice should not include the Delivery DeliveryLocation ValidationPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:ID)">
          <attribute name="id">UBL-CR-359</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-359]-A UBL invoice should not include the Delivery DeliveryLocation Address ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode)">
          <attribute name="id">UBL-CR-360</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-360]-A UBL invoice should not include the Delivery DeliveryLocation Address AddressTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode)">
          <attribute name="id">UBL-CR-361</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-361]-A UBL invoice should not include the Delivery DeliveryLocation Address AddressFormatCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Postbox)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Postbox)">
          <attribute name="id">UBL-CR-362</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-362]-A UBL invoice should not include the Delivery DeliveryLocation Address Postbox</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor)">
          <attribute name="id">UBL-CR-363</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-363]-A UBL invoice should not include the Delivery DeliveryLocation Address Floor</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room)">
          <attribute name="id">UBL-CR-364</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-364]-A UBL invoice should not include the Delivery DeliveryLocation Address Room</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName)">
          <attribute name="id">UBL-CR-365</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-365]-A UBL invoice should not include the Delivery DeliveryLocation Address BlockName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName)">
          <attribute name="id">UBL-CR-366</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-366]-A UBL invoice should not include the Delivery DeliveryLocation Address BuildingName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingNumber)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingNumber)">
          <attribute name="id">UBL-CR-367</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-367]-A UBL invoice should not include the Delivery DeliveryLocation Address BuildingNumber</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail)">
          <attribute name="id">UBL-CR-368</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-368]-A UBL invoice should not include the Delivery DeliveryLocation Address InhouseMail</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department)">
          <attribute name="id">UBL-CR-369</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-369]-A UBL invoice should not include the Delivery DeliveryLocation Address Department</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention)">
          <attribute name="id">UBL-CR-370</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-370]-A UBL invoice should not include the Delivery DeliveryLocation Address MarkAttention</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare)">
          <attribute name="id">UBL-CR-371</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-371]-A UBL invoice should not include the Delivery DeliveryLocation Address MarkCare</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification)">
          <attribute name="id">UBL-CR-372</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-372]-A UBL invoice should not include the Delivery DeliveryLocation Address PlotIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName)">
          <attribute name="id">UBL-CR-373</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-373]-A UBL invoice should not include the Delivery DeliveryLocation Address CitySubdivisionName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode)">
          <attribute name="id">UBL-CR-374</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-374]-A UBL invoice should not include the Delivery DeliveryLocation Address CountrySubentityCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region)">
          <attribute name="id">UBL-CR-375</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-375]-A UBL invoice should not include the Delivery DeliveryLocation Address Region</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District)">
          <attribute name="id">UBL-CR-376</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-376]-A UBL invoice should not include the Delivery DeliveryLocation Address District</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset)">
          <attribute name="id">UBL-CR-377</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-377]-A UBL invoice should not include the Delivery DeliveryLocation Address TimezoneOffset</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name)">
          <attribute name="id">UBL-CR-378</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-378]-A UBL invoice should not include the Delivery DeliveryLocation Address Country Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate)">
          <attribute name="id">UBL-CR-379</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-379]-A UBL invoice should not include the Delivery DeliveryLocation Address LocationCoordinate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:SubsidiaryLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:SubsidiaryLocation)">
          <attribute name="id">UBL-CR-380</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-380]-A UBL invoice should not include the Delivery DeliveryLocation SubsidiaryLocation</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryLocation/cac:LocationCoordinate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:LocationCoordinate)">
          <attribute name="id">UBL-CR-381</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-381]-A UBL invoice should not include the Delivery DeliveryLocation LocationCoordinate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:AlternativeDeliveryLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:AlternativeDeliveryLocation)">
          <attribute name="id">UBL-CR-382</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-382]-A UBL invoice should not include the Delivery AlternativeDeliveryLocation</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:RequestedDeliveryPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:RequestedDeliveryPeriod)">
          <attribute name="id">UBL-CR-383</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-383]-A UBL invoice should not include the Delivery RequestedDeliveryPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:EstimatedDeliveryPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:EstimatedDeliveryPeriod)">
          <attribute name="id">UBL-CR-384</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-384]-A UBL invoice should not include the Delivery PromisedDeliveryPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:CarrierParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:CarrierParty)">
          <attribute name="id">UBL-CR-385</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-385]-A UBL invoice should not include the Delivery CarrierParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cbc:MarkCareIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cbc:MarkCareIndicator)">
          <attribute name="id">UBL-CR-386</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-386]-A UBL invoice should not include the DeliveryParty MarkCareIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cbc:MarkAttentionIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cbc:MarkAttentionIndicator)">
          <attribute name="id">UBL-CR-387</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-387]-A UBL invoice should not include the DeliveryParty MarkAttentionIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cbc:WebsiteURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cbc:WebsiteURI)">
          <attribute name="id">UBL-CR-388</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-388]-A UBL invoice should not include the DeliveryParty WebsiteURI</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cbc:LogoReferenceID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cbc:LogoReferenceID)">
          <attribute name="id">UBL-CR-389</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-389]-A UBL invoice should not include the DeliveryParty LogoReferenceID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cbc:EndpointID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cbc:EndpointID)">
          <attribute name="id">UBL-CR-390</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-390]-A UBL invoice should not include the DeliveryParty EndpointID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cbc:IndustryClassificationCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cbc:IndustryClassificationCode)">
          <attribute name="id">UBL-CR-391</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-391]-A UBL invoice should not include the DeliveryParty IndustryClassificationCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:PartyIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyIdentification)">
          <attribute name="id">UBL-CR-392</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-392]-A UBL invoice should not include the DeliveryParty PartyIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:Language)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:Language)">
          <attribute name="id">UBL-CR-393</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-393]-A UBL invoice should not include the DeliveryParty Language</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:PostalAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:PostalAddress)">
          <attribute name="id">UBL-CR-394</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-394]-A UBL invoice should not include the DeliveryParty PostalAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:PhysicalLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:PhysicalLocation)">
          <attribute name="id">UBL-CR-395</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-395]-A UBL invoice should not include the DeliveryParty PhysicalLocation</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:PartyTaxScheme)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyTaxScheme)">
          <attribute name="id">UBL-CR-396</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-396]-A UBL invoice should not include the DeliveryParty PartyTaxScheme</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:PartyLegalEntity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyLegalEntity)">
          <attribute name="id">UBL-CR-397</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-397]-A UBL invoice should not include the DeliveryParty PartyLegalEntity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:Contact)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:Contact)">
          <attribute name="id">UBL-CR-398</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-398]-A UBL invoice should not include the DeliveryParty Contact</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:Person)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:Person)">
          <attribute name="id">UBL-CR-399</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-399]-A UBL invoice should not include the DeliveryParty Person</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:AgentParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:AgentParty)">
          <attribute name="id">UBL-CR-400</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-400]-A UBL invoice should not include the DeliveryParty AgentParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:ServiceProviderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:ServiceProviderParty)">
          <attribute name="id">UBL-CR-401</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-401]-A UBL invoice should not include the DeliveryParty ServiceProviderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:PowerOfAttorney)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:PowerOfAttorney)">
          <attribute name="id">UBL-CR-402</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-402]-A UBL invoice should not include the DeliveryParty PowerOfAttorney</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryParty/cac:FinancialAccount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryParty/cac:FinancialAccount)">
          <attribute name="id">UBL-CR-403</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-403]-A UBL invoice should not include the DeliveryParty FinancialAccount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:NotifyParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:NotifyParty)">
          <attribute name="id">UBL-CR-404</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-404]-A UBL invoice should not include the Delivery NotifyParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:Despatch)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:Despatch)">
          <attribute name="id">UBL-CR-405</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-405]-A UBL invoice should not include the Delivery Despatch</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:DeliveryTerms)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryTerms)">
          <attribute name="id">UBL-CR-406</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-406]-A UBL invoice should not include the Delivery DeliveryTerms</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:MinimumDeliveryUnit)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:MinimumDeliveryUnit)">
          <attribute name="id">UBL-CR-407</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-407]-A UBL invoice should not include the Delivery MinimumDeliveryUnit</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:MaximumDeliveryUnit)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:MaximumDeliveryUnit)">
          <attribute name="id">UBL-CR-408</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-408]-A UBL invoice should not include the Delivery MaximumDeliveryUnit</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:Delivery/cac:Shipment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:Shipment)">
          <attribute name="id">UBL-CR-409</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-409]-A UBL invoice should not include the Delivery Shipment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:DeliveryTerms)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:DeliveryTerms)">
          <attribute name="id">UBL-CR-410</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-410]-A UBL invoice should not include the DeliveryTerms</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:ID)">
          <attribute name="id">UBL-CR-411</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-411]-A UBL invoice should not include the PaymentMeans ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cbc:PaymentDueDate) or ../cn:CreditNote" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:PaymentDueDate) or ../cn:CreditNote">
          <attribute name="id">UBL-CR-412</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-412]-A UBL invoice should not include the PaymentMeans PaymentDueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cbc:PaymentChannelCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:PaymentChannelCode)">
          <attribute name="id">UBL-CR-413</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-413]-A UBL invoice should not include the PaymentMeans PaymentChannelCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cbc:InstructionNote)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:InstructionNote)">
          <attribute name="id">UBL-CR-414</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-414]-A UBL invoice should not include the PaymentMeans InstructionID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CardAccount/cbc:CardTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CardTypeCode)">
          <attribute name="id">UBL-CR-415</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-415]-A UBL invoice should not include the PaymentMeans CardAccount CardTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CardAccount/cbc:ValidityStartDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ValidityStartDate)">
          <attribute name="id">UBL-CR-416</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-416]-A UBL invoice should not include the PaymentMeans CardAccount ValidityStartDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CardAccount/cbc:ExpiryDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ExpiryDate)">
          <attribute name="id">UBL-CR-417</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-417]-A UBL invoice should not include the PaymentMeans CardAccount ExpiryDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssuerID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssuerID)">
          <attribute name="id">UBL-CR-418</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-418]-A UBL invoice should not include the PaymentMeans CardAccount IssuerID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssueNumberID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssueNumberID)">
          <attribute name="id">UBL-CR-419</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-419]-A UBL invoice should not include the PaymentMeans CardAccount IssuerNumberID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CardAccount/cbc:CV2ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CV2ID)">
          <attribute name="id">UBL-CR-420</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-420]-A UBL invoice should not include the PaymentMeans CardAccount CV2ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CardAccount/cbc:CardChipCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CardChipCode)">
          <attribute name="id">UBL-CR-421</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-421]-A UBL invoice should not include the PaymentMeans CardAccount CardChipCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CardAccount/cbc:ChipApplicationID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ChipApplicationID)">
          <attribute name="id">UBL-CR-422</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-422]-A UBL invoice should not include the PaymentMeans CardAccount ChipApplicationID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AliasName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AliasName)">
          <attribute name="id">UBL-CR-424</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-424]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AliasName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode)">
          <attribute name="id">UBL-CR-425</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-425]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AccountTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountFormatCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountFormatCode)">
          <attribute name="id">UBL-CR-426</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-426]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AccountFormatCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode)">
          <attribute name="id">UBL-CR-427</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-427]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount CurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:PaymentNote)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:PaymentNote)">
          <attribute name="id">UBL-CR-428</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-428]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount PaymentNote</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name)">
          <attribute name="id">UBL-CR-429</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-429]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name)">
          <attribute name="id">UBL-CR-430</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-430]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch FinancialInstitution Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address)">
          <attribute name="id">UBL-CR-431</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-431]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch FinancialInstitution Address</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address)">
          <attribute name="id">UBL-CR-432</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-432]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch Address</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country)">
          <attribute name="id">UBL-CR-433</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-433]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount Country</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:CreditAccount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CreditAccount)">
          <attribute name="id">UBL-CR-434</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-434]-A UBL invoice should not include the PaymentMeans CreditAccount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MandateTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MandateTypeCode)">
          <attribute name="id">UBL-CR-435</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-435]-A UBL invoice should not include the PaymentMeans PaymentMandate MandateTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MaximumPaymentInstructionsNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MaximumPaymentInstructionsNumeric)">
          <attribute name="id">UBL-CR-436</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-436]-A UBL invoice should not include the PaymentMeans PaymentMandate MaximumPaymentInstructionsNumeric</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MaximumPaidAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MaximumPaidAmount)">
          <attribute name="id">UBL-CR-437</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-437]-A UBL invoice should not include the PaymentMeans PaymentMandate MaximumPaidAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:SignatureID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:SignatureID)">
          <attribute name="id">UBL-CR-438</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-438]-A UBL invoice should not include the PaymentMeans PaymentMandate SignatureID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty)">
          <attribute name="id">UBL-CR-439</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-439]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:Name)">
          <attribute name="id">UBL-CR-440</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-440]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AliasName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AliasName)">
          <attribute name="id">UBL-CR-441</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-441]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AliasName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AccountTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AccountTypeCode)">
          <attribute name="id">UBL-CR-442</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-442]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AccountTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AccountFormatCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AccountFormatCode)">
          <attribute name="id">UBL-CR-443</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-443]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AccountFormatCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:CurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:CurrencyCode)">
          <attribute name="id">UBL-CR-444</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-444]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount CurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:PaymentNote)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:PaymentNote)">
          <attribute name="id">UBL-CR-445</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-445]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount PaymentNote</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch)">
          <attribute name="id">UBL-CR-446</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-446]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount FinancialInstitutionBranch</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cac:Country)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cac:Country)">
          <attribute name="id">UBL-CR-447</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-447]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount Country</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-448</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-448]-A UBL invoice should not include the PaymentMeans PaymentMandate ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PaymentReversalPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PaymentReversalPeriod)">
          <attribute name="id">UBL-CR-449</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-449]-A UBL invoice should not include the PaymentMeans PaymentMandate PaymentReversalPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PaymentMandate/cac:Clause)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:Clause)">
          <attribute name="id">UBL-CR-450</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-450]-A UBL invoice should not include the PaymentMeans PaymentMandate Clause</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:TradeFinancing)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:TradeFinancing)">
          <attribute name="id">UBL-CR-451</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-451]-A UBL invoice should not include the PaymentMeans TradeFinancing</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:ID)">
          <attribute name="id">UBL-CR-452</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-452]-A UBL invoice should not include the PaymentTerms ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:PaymentMeansID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PaymentMeansID)">
          <attribute name="id">UBL-CR-453</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-453]-A UBL invoice should not include the PaymentTerms PaymentMeansID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID)">
          <attribute name="id">UBL-CR-454</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-454]-A UBL invoice should not include the PaymentTerms PrepaidPaymentReferenceID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:ReferenceEventCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:ReferenceEventCode)">
          <attribute name="id">UBL-CR-455</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-455]-A UBL invoice should not include the PaymentTerms ReferenceEventCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent)">
          <attribute name="id">UBL-CR-456</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-456]-A UBL invoice should not include the PaymentTerms SettlementDiscountPercent</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent)">
          <attribute name="id">UBL-CR-457</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-457]-A UBL invoice should not include the PaymentTerms PenaltySurchargePercent</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:PaymentPercent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PaymentPercent)">
          <attribute name="id">UBL-CR-458</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-458]-A UBL invoice should not include the PaymentTerms PaymentPercent</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:Amount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:Amount)">
          <attribute name="id">UBL-CR-459</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-459]-A UBL invoice should not include the PaymentTerms Amount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:SettlementDiscountAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:SettlementDiscountAmount)">
          <attribute name="id">UBL-CR-460</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-460]-A UBL invoice should not include the PaymentTerms SettlementDiscountAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:PenaltyAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PenaltyAmount)">
          <attribute name="id">UBL-CR-461</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-461]-A UBL invoice should not include the PaymentTerms PenaltyAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:PaymentTermsDetailsURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PaymentTermsDetailsURI)">
          <attribute name="id">UBL-CR-462</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-462]-A UBL invoice should not include the PaymentTerms PaymentTermsDetailsURI</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:PaymentDueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PaymentDueDate)">
          <attribute name="id">UBL-CR-463</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-463]-A UBL invoice should not include the PaymentTerms PaymentDueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:InstallmentDueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:InstallmentDueDate)">
          <attribute name="id">UBL-CR-464</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-464]-A UBL invoice should not include the PaymentTerms InstallmentDueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cbc:InvoicingPartyReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:InvoicingPartyReference)">
          <attribute name="id">UBL-CR-465</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-465]-A UBL invoice should not include the PaymentTerms InvoicingPartyReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cac:SettlementPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:SettlementPeriod)">
          <attribute name="id">UBL-CR-466</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-466]-A UBL invoice should not include the PaymentTerms SettlementPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cac:PenaltyPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:PenaltyPeriod)">
          <attribute name="id">UBL-CR-467</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-467]-A UBL invoice should not include the PaymentTerms PenaltyPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cac:ExchangeRate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:ExchangeRate)">
          <attribute name="id">UBL-CR-468</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-468]-A UBL invoice should not include the PaymentTerms ExchangeRate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentTerms/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-469</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-469]-A UBL invoice should not include the PaymentTerms ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PrepaidPayment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PrepaidPayment)">
          <attribute name="id">UBL-CR-470</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-470]-A UBL invoice should not include the PrepaidPayment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:ID)">
          <attribute name="id">UBL-CR-471</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-471]-A UBL invoice should not include the AllowanceCharge ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cbc:PrepaidIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:PrepaidIndicator)">
          <attribute name="id">UBL-CR-472</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-472]-A UBL invoice should not include the AllowanceCharge PrepaidIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cbc:SequenceNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:SequenceNumeric)">
          <attribute name="id">UBL-CR-473</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-473]-A UBL invoice should not include the AllowanceCharge SequenceNumeric</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cbc:AccountingCostCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AccountingCostCode)">
          <attribute name="id">UBL-CR-474</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-474]-A UBL invoice should not include the AllowanceCharge AccountingCostCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cbc:AccountingCost)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AccountingCost)">
          <attribute name="id">UBL-CR-475</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-475]-A UBL invoice should not include the AllowanceCharge AccountingCost</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cbc:PerUnitAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:PerUnitAmount)">
          <attribute name="id">UBL-CR-476</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-476]-A UBL invoice should not include the AllowanceCharge PerUnitAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name)">
          <attribute name="id">UBL-CR-477</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-477]-A UBL invoice should not include the AllowanceCharge TaxCategory Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure)">
          <attribute name="id">UBL-CR-478</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-478]-A UBL invoice should not include the AllowanceCharge TaxCategory BaseUnitMeasure</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount)">
          <attribute name="id">UBL-CR-479</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-479]-A UBL invoice should not include the AllowanceCharge TaxCategory PerUnitAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode)">
          <attribute name="id">UBL-CR-480</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-480]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxExemptionReasonCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason)">
          <attribute name="id">UBL-CR-481</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-481]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxExemptionReason</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange)">
          <attribute name="id">UBL-CR-482</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-482]-A UBL invoice should not include the AllowanceCharge TaxCategory TierRange</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent)">
          <attribute name="id">UBL-CR-483</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-483]-A UBL invoice should not include the AllowanceCharge TaxCategory TierRatePercent</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name)">
          <attribute name="id">UBL-CR-484</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-484]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">
          <attribute name="id">UBL-CR-485</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-485]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme TaxTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode)">
          <attribute name="id">UBL-CR-486</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-486]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme CurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdiccionRegionAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdiccionRegionAddress)">
          <attribute name="id">UBL-CR-487</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-487]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme JurisdiccionRegionAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:TaxTotal)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxTotal)">
          <attribute name="id">UBL-CR-488</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-488]-A UBL invoice should not include the AllowanceCharge TaxTotal</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AllowanceCharge/cac:PaymentMeans)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:PaymentMeans)">
          <attribute name="id">UBL-CR-489</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-489]-A UBL invoice should not include the AllowanceCharge PaymentMeans</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxExchangeRate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxExchangeRate)">
          <attribute name="id">UBL-CR-490</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-490]-A UBL invoice should not include the TaxExchangeRate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PricingExchangeRate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PricingExchangeRate)">
          <attribute name="id">UBL-CR-491</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-491]-A UBL invoice should not include the PricingExchangeRate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentExchangeRate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentExchangeRate)">
          <attribute name="id">UBL-CR-492</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-492]-A UBL invoice should not include the PaymentExchangeRate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentAlternativeExchangeRate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentAlternativeExchangeRate)">
          <attribute name="id">UBL-CR-493</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-493]-A UBL invoice should not include the PaymentAlternativeExchangeRate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cbc:RoundingAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:RoundingAmount)">
          <attribute name="id">UBL-CR-494</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-494]-A UBL invoice should not include the TaxTotal RoundingAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator)">
          <attribute name="id">UBL-CR-495</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-495]-A UBL invoice should not include the TaxTotal TaxEvidenceIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cbc:TaxIncludedIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:TaxIncludedIndicator)">
          <attribute name="id">UBL-CR-496</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-496]-A UBL invoice should not include the TaxTotal TaxIncludedIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric)">
          <attribute name="id">UBL-CR-497</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-497]-A UBL invoice should not include the TaxTotal TaxSubtotal CalulationSequenceNumeric</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount)">
          <attribute name="id">UBL-CR-498</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-498]-A UBL invoice should not include the TaxTotal TaxSubtotal TransactionCurrencyTaxAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent)">
          <attribute name="id">UBL-CR-499</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-499]-A UBL invoice should not include the TaxTotal TaxSubtotal Percent</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure)">
          <attribute name="id">UBL-CR-500</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-500]-A UBL invoice should not include the TaxTotal TaxSubtotal BaseUnitMeasure</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount)">
          <attribute name="id">UBL-CR-501</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-501]-A UBL invoice should not include the TaxTotal TaxSubtotal PerUnitAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange)">
          <attribute name="id">UBL-CR-502</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-502]-A UBL invoice should not include the TaxTotal TaxSubtotal TierRange</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent)">
          <attribute name="id">UBL-CR-503</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-503]-A UBL invoice should not include the TaxTotal TaxSubtotal TierRatePercent</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name)">
          <attribute name="id">UBL-CR-504</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-504]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure)">
          <attribute name="id">UBL-CR-505</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-505]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory BaseUnitMeasure</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount)">
          <attribute name="id">UBL-CR-506</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-506]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory PerUnitAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange)">
          <attribute name="id">UBL-CR-507</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-507]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TierRange</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent)">
          <attribute name="id">UBL-CR-508</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-508]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TierRatePercent</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name)">
          <attribute name="id">UBL-CR-509</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-509]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">
          <attribute name="id">UBL-CR-510</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-510]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme TaxTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode)">
          <attribute name="id">UBL-CR-511</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-511]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme CurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)">
          <attribute name="id">UBL-CR-512</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-512]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme JurisdiccionRegionAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:WithholdingTaxTotal)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:WithholdingTaxTotal)">
          <attribute name="id">UBL-CR-513</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-513]-A UBL invoice should not include the WithholdingTaxTotal</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:LegalMonetaryTotal/cbc:PayableAlternativeAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:LegalMonetaryTotal/cbc:PayableAlternativeAmount)">
          <attribute name="id">UBL-CR-514</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-514]-A UBL invoice should not include the LegalMonetaryTotal PayableAlternativeAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:UUID)">
          <attribute name="id">UBL-CR-515</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-515]-A UBL invoice should not include the InvoiceLine UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:TaxPointDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:TaxPointDate)">
          <attribute name="id">UBL-CR-516</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-516]-A UBL invoice should not include the InvoiceLine TaxPointDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:AccountingCostCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:AccountingCostCode)">
          <attribute name="id">UBL-CR-517</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-517]-A UBL invoice should not include the InvoiceLine AccountingCostCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:PaymentPurposeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:PaymentPurposeCode)">
          <attribute name="id">UBL-CR-518</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-518]-A UBL invoice should not include the InvoiceLine PaymentPurposeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:FreeOfChargeIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:FreeOfChargeIndicator)">
          <attribute name="id">UBL-CR-519</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-519]-A UBL invoice should not include the InvoiceLine FreeOfChargeIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:StartTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:StartTime)">
          <attribute name="id">UBL-CR-520</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-520]-A UBL invoice should not include the InvoiceLine InvoicePeriod StartTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:EndTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:EndTime)">
          <attribute name="id">UBL-CR-521</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-521]-A UBL invoice should not include the InvoiceLine InvoicePeriod EndTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:DurationMeasure)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:DurationMeasure)">
          <attribute name="id">UBL-CR-522</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-522]-A UBL invoice should not include the InvoiceLine InvoicePeriod DurationMeasure</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:DescriptionCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:DescriptionCode)">
          <attribute name="id">UBL-CR-523</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-523]-A UBL invoice should not include the InvoiceLine InvoicePeriod DescriptionCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:Description)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:Description)">
          <attribute name="id">UBL-CR-524</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-524]-A UBL invoice should not include the InvoiceLine InvoicePeriod Description</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:SalesOrderLineID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:SalesOrderLineID)">
          <attribute name="id">UBL-CR-525</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-525]-A UBL invoice should not include the InvoiceLine OrderLineReference SalesOrderLineID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:UUID)">
          <attribute name="id">UBL-CR-526</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-526]-A UBL invoice should not include the InvoiceLine OrderLineReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:LineStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:LineStatusCode)">
          <attribute name="id">UBL-CR-527</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-527]-A UBL invoice should not include the InvoiceLine OrderLineReference LineStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cac:OrderReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cac:OrderReference)">
          <attribute name="id">UBL-CR-528</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-528]-A UBL invoice should not include the InvoiceLine OrderLineReference OrderReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DespatchLineReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DespatchLineReference)">
          <attribute name="id">UBL-CR-529</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-529]-A UBL invoice should not include the InvoiceLine DespatchLineReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:ReceiptLineReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:ReceiptLineReference)">
          <attribute name="id">UBL-CR-530</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-530]-A UBL invoice should not include the InvoiceLine ReceiptLineReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:BillingReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:BillingReference)">
          <attribute name="id">UBL-CR-531</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-531]-A UBL invoice should not include the InvoiceLine BillingReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:CopyIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:CopyIndicator)">
          <attribute name="id">UBL-CR-532</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-532]-A UBL invoice should not include the InvoiceLine DocumentReference CopyIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:UUID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:UUID)">
          <attribute name="id">UBL-CR-533</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-533]-A UBL invoice should not include the InvoiceLine DocumentReference UUID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:IssueDate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:IssueDate)">
          <attribute name="id">UBL-CR-534</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-534]-A UBL invoice should not include the InvoiceLine DocumentReference IssueDate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:IssueTime)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:IssueTime)">
          <attribute name="id">UBL-CR-535</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-535]-A UBL invoice should not include the InvoiceLine DocumentReference IssueTime</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentType)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentType)">
          <attribute name="id">UBL-CR-537</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-537]-A UBL invoice should not include the InvoiceLine DocumentReference DocumentType</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:XPath)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:XPath)">
          <attribute name="id">UBL-CR-538</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-538]-A UBL invoice should not include the InvoiceLine DocumentReference Xpath</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:LanguageID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:LanguageID)">
          <attribute name="id">UBL-CR-539</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-539]-A UBL invoice should not include the InvoiceLine DocumentReference LanguageID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:LocaleCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:LocaleCode)">
          <attribute name="id">UBL-CR-540</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-540]-A UBL invoice should not include the InvoiceLine DocumentReference LocaleCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:VersionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:VersionID)">
          <attribute name="id">UBL-CR-541</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-541]-A UBL invoice should not include the InvoiceLine DocumentReference VersionID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentStatusCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentStatusCode)">
          <attribute name="id">UBL-CR-542</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-542]-A UBL invoice should not include the InvoiceLine DocumentReference DocumentStatusCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentDescription)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentDescription)">
          <attribute name="id">UBL-CR-543</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-543]-A UBL invoice should not include the InvoiceLine DocumentReference DocumentDescription</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:Attachment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:Attachment)">
          <attribute name="id">UBL-CR-544</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-544]-A UBL invoice should not include the InvoiceLine DocumentReference Attachment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:ValidityPeriod)">
          <attribute name="id">UBL-CR-545</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-545]-A UBL invoice should not include the InvoiceLine DocumentReference ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:IssuerParty)">
          <attribute name="id">UBL-CR-546</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-546]-A UBL invoice should not include the InvoiceLine DocumentReference IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:ResultOfVerification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:ResultOfVerification)">
          <attribute name="id">UBL-CR-547</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-547]-A UBL invoice should not include the InvoiceLine DocumentReference ResultOfVerification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:PricingReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:PricingReference)">
          <attribute name="id">UBL-CR-548</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-548]-A UBL invoice should not include the InvoiceLine PricingReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OriginatorParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OriginatorParty)">
          <attribute name="id">UBL-CR-549</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-549]-A UBL invoice should not include the InvoiceLine OriginatorParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Delivery)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Delivery)">
          <attribute name="id">UBL-CR-550</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-550]-A UBL invoice should not include the InvoiceLine Delivery</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:PaymentTerms)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:PaymentTerms)">
          <attribute name="id">UBL-CR-551</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-551]-A UBL invoice should not include the InvoiceLine PaymentTerms</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:ID)">
          <attribute name="id">UBL-CR-552</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-552]-A UBL invoice should not include the InvoiceLine AllowanceCharge ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:PrepaidIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:PrepaidIndicator)">
          <attribute name="id">UBL-CR-553</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-553]-A UBL invoice should not include the InvoiceLine AllowanceCharge PrepaidIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:SequenceNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:SequenceNumeric)">
          <attribute name="id">UBL-CR-554</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-554]-A UBL invoice should not include the InvoiceLine AllowanceCharge SequenceNumeric</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:AccountingCostCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:AccountingCostCode)">
          <attribute name="id">UBL-CR-555</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-555]-A UBL invoice should not include the InvoiceLine AllowanceCharge AccountingCostCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:AccountingCost)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:AccountingCost)">
          <attribute name="id">UBL-CR-556</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-556]-A UBL invoice should not include the InvoiceLine AllowanceCharge AccountingCost</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:PerUnitAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:PerUnitAmount)">
          <attribute name="id">UBL-CR-557</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-557]-A UBL invoice should not include the InvoiceLine AllowanceCharge PerUnitAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:TaxCategory)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:TaxCategory)">
          <attribute name="id">UBL-CR-558</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-558]-A UBL invoice should not include the InvoiceLine AllowanceCharge TaxCategory</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:TaxTotal)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:TaxTotal)">
          <attribute name="id">UBL-CR-559</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-559]-A UBL invoice should not include the InvoiceLine AllowanceCharge TaxTotal</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:PaymentMeans)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:PaymentMeans)">
          <attribute name="id">UBL-CR-560</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-560]-A UBL invoice should not include the InvoiceLine AllowanceCharge PaymentMeans</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:TaxTotal)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:TaxTotal)">
          <attribute name="id">UBL-CR-561</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-561]-A UBL invoice should not include the InvoiceLine TaxTotal</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:WithholdingTaxTotal)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:WithholdingTaxTotal)">
          <attribute name="id">UBL-CR-562</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-562]-A UBL invoice should not include the InvoiceLine WithholdingTaxTotal</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:PackQuantity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:PackQuantity)">
          <attribute name="id">UBL-CR-563</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-563]-A UBL invoice should not include the InvoiceLine Item PackQuantity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:PackSizeNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:PackSizeNumeric)">
          <attribute name="id">UBL-CR-564</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-564]-A UBL invoice should not include the InvoiceLine Item PackSizeNumeric</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:CatalogueIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:CatalogueIndicator)">
          <attribute name="id">UBL-CR-565</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-565]-A UBL invoice should not include the InvoiceLine Item CatalogueIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:HazardousRiskIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:HazardousRiskIndicator)">
          <attribute name="id">UBL-CR-566</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-566]-A UBL invoice should not include the InvoiceLine Item HazardousRiskIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:AdditionalInformation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:AdditionalInformation)">
          <attribute name="id">UBL-CR-567</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-567]-A UBL invoice should not include the InvoiceLine Item AdditionalInformation</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:Keyword)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:Keyword)">
          <attribute name="id">UBL-CR-568</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-568]-A UBL invoice should not include the InvoiceLine Item Keyword</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:BrandName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:BrandName)">
          <attribute name="id">UBL-CR-569</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-569]-A UBL invoice should not include the InvoiceLine Item BrandName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:ModelName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:ModelName)">
          <attribute name="id">UBL-CR-570</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-570]-A UBL invoice should not include the InvoiceLine Item ModelName</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:ExtendedID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:ExtendedID)">
          <attribute name="id">UBL-CR-571</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-571]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification ExtendedID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:BarecodeSymbologyID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:BarecodeSymbologyID)">
          <attribute name="id">UBL-CR-572</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-572]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification BareCodeSymbologyID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:PhysicalAttribute)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:PhysicalAttribute)">
          <attribute name="id">UBL-CR-573</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-573]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification PhysicalAttribute</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:MeasurementDimension)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:MeasurementDimension)">
          <attribute name="id">UBL-CR-574</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-574]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification MeasurementDimension</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:IssuerParty)">
          <attribute name="id">UBL-CR-575</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-575]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID)">
          <attribute name="id">UBL-CR-576</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-576]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification ExtendedID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:BarecodeSymbologyID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:BarecodeSymbologyID)">
          <attribute name="id">UBL-CR-577</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-577]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification BareCodeSymbologyID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:PhysicalAttribute)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:PhysicalAttribute)">
          <attribute name="id">UBL-CR-578</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-578]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification PhysicalAttribute</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:MeasurementDimension)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:MeasurementDimension)">
          <attribute name="id">UBL-CR-579</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-579]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification MeasurementDimension</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:IssuerParty)">
          <attribute name="id">UBL-CR-580</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-580]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ManufacturersItemIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ManufacturersItemIdentification)">
          <attribute name="id">UBL-CR-581</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-581]-A UBL invoice should not include the InvoiceLine Item ManufacturersItemIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID)">
          <attribute name="id">UBL-CR-582</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-582]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification ExtendedID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:BarecodeSymbologyID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:BarecodeSymbologyID)">
          <attribute name="id">UBL-CR-583</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-583]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification BareCodeSymbologyID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:PhysicalAttribute)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:PhysicalAttribute)">
          <attribute name="id">UBL-CR-584</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-584]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification PhysicalAttribute</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:MeasurementDimension)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:MeasurementDimension)">
          <attribute name="id">UBL-CR-585</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-585]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification MeasurementDimension</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:IssuerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:IssuerParty)">
          <attribute name="id">UBL-CR-586</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-586]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification IssuerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CatalogueItemIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CatalogueItemIdentification)">
          <attribute name="id">UBL-CR-587</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-587]-A UBL invoice should not include the InvoiceLine Item CatalogueItemIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemIdentification)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemIdentification)">
          <attribute name="id">UBL-CR-588</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-588]-A UBL invoice should not include the InvoiceLine Item AdditionalItemIdentification</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CatalogueDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CatalogueDocumentReference)">
          <attribute name="id">UBL-CR-589</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-589]-A UBL invoice should not include the InvoiceLine Item CatalogueDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ItemSpecificationDocumentReference)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ItemSpecificationDocumentReference)">
          <attribute name="id">UBL-CR-590</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-590]-A UBL invoice should not include the InvoiceLine Item ItemSpecificationDocumentReference</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:OriginCountry/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:OriginCountry/cbc:Name)">
          <attribute name="id">UBL-CR-591</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-591]-A UBL invoice should not include the InvoiceLine Item OriginCountry Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:NatureCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:NatureCode)">
          <attribute name="id">UBL-CR-592</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-592]-A UBL invoice should not include the InvoiceLine Item CommodityClassification NatureCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode)">
          <attribute name="id">UBL-CR-593</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-593]-A UBL invoice should not include the InvoiceLine Item CommodityClassification CargoTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:CommodityCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:CommodityCode)">
          <attribute name="id">UBL-CR-594</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-594]-A UBL invoice should not include the InvoiceLine Item CommodityClassification CommodityCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:TransactionConditions)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:TransactionConditions)">
          <attribute name="id">UBL-CR-595</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-595]-A UBL invoice should not include the InvoiceLine Item TransactionConditions</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:HazardousItem)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:HazardousItem)">
          <attribute name="id">UBL-CR-596</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-596]-A UBL invoice should not include the InvoiceLine Item HazardousItem</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:Name)">
          <attribute name="id">UBL-CR-597</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-597]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:BaseUnitMeasure)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:BaseUnitMeasure)">
          <attribute name="id">UBL-CR-598</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-598]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory BaseUnitMeasure</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:PerUnitAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:PerUnitAmount)">
          <attribute name="id">UBL-CR-599</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-599]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory PerUnitAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode)">
          <attribute name="id">UBL-CR-600</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-600]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxExemptionReasonCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReason)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReason)">
          <attribute name="id">UBL-CR-601</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-601]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxExemptionReason</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TierRange)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TierRange)">
          <attribute name="id">UBL-CR-602</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-602]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TierRange</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TierRatePercent)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TierRatePercent)">
          <attribute name="id">UBL-CR-603</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-603]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TierRatePercent</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:Name)">
          <attribute name="id">UBL-CR-604</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-604]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme Name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:TaxTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">
          <attribute name="id">UBL-CR-605</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-605]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme TaxTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:CurrencyCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:CurrencyCode)">
          <attribute name="id">UBL-CR-606</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-606]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme CurrencyCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)">
          <attribute name="id">UBL-CR-607</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-607]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme JurisdiccionRegionAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ID)">
          <attribute name="id">UBL-CR-608</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-608]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:NameCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:NameCode)">
          <attribute name="id">UBL-CR-609</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-609]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty NameCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:TestMethod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:TestMethod)">
          <attribute name="id">UBL-CR-610</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-610]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty TestMethod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity)">
          <attribute name="id">UBL-CR-611</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-611]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ValueQuantity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier)">
          <attribute name="id">UBL-CR-612</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-612]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ValueQualifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ImportanceCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ImportanceCode)">
          <attribute name="id">UBL-CR-613</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-613]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ImportanceCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ListValue)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ListValue)">
          <attribute name="id">UBL-CR-614</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-614]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ListValue</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:UsabilityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:UsabilityPeriod)">
          <attribute name="id">UBL-CR-615</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-615]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty UsabilityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyGroup)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyGroup)">
          <attribute name="id">UBL-CR-616</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-616]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ItemPropertyGroup</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:RangeDimension)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:RangeDimension)">
          <attribute name="id">UBL-CR-617</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-617]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty RangeDimension</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyRange)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyRange)">
          <attribute name="id">UBL-CR-618</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-618]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ItemPropertyRange</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ManufacturerParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ManufacturerParty)">
          <attribute name="id">UBL-CR-619</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-619]-A UBL invoice should not include the InvoiceLine Item ManufacturerParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:InformationContentProviderParty)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:InformationContentProviderParty)">
          <attribute name="id">UBL-CR-620</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-620]-A UBL invoice should not include the InvoiceLine Item InformationContentProviderParty</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:OriginAddress)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:OriginAddress)">
          <attribute name="id">UBL-CR-621</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-621]-A UBL invoice should not include the InvoiceLine Item OriginAddress</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ItemInstance)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ItemInstance)">
          <attribute name="id">UBL-CR-622</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-622]-A UBL invoice should not include the InvoiceLine Item ItemInstance</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Certificate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Certificate)">
          <attribute name="id">UBL-CR-623</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-623]-A UBL invoice should not include the InvoiceLine Item Certificate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Dimension)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Dimension)">
          <attribute name="id">UBL-CR-624</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-624]-A UBL invoice should not include the InvoiceLine Item Dimension</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceChangeReason)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceChangeReason)">
          <attribute name="id">UBL-CR-625</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-625]-A UBL invoice should not include the InvoiceLine Item Price PriceChangeReason</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceTypeCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceTypeCode)">
          <attribute name="id">UBL-CR-626</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-626]-A UBL invoice should not include the InvoiceLine Item Price PriceTypeCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceType)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceType)">
          <attribute name="id">UBL-CR-627</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-627]-A UBL invoice should not include the InvoiceLine Item Price PriceType</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:OrderableUnitFactorRate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:OrderableUnitFactorRate)">
          <attribute name="id">UBL-CR-628</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-628]-A UBL invoice should not include the InvoiceLine Item Price OrderableUnitFactorRate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:ValidityPeriod)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:ValidityPeriod)">
          <attribute name="id">UBL-CR-629</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-629]-A UBL invoice should not include the InvoiceLine Item Price ValidityPeriod</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceList)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceList)">
          <attribute name="id">UBL-CR-630</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-630]-A UBL invoice should not include the InvoiceLine Item Price PriceList</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:OrderableUnitFactorRate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:OrderableUnitFactorRate)">
          <attribute name="id">UBL-CR-631</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-631]-A UBL invoice should not include the InvoiceLine Item Price OrderableUnitFactorRate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:ID)">
          <attribute name="id">UBL-CR-632</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-632]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge ID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)">
          <attribute name="id">UBL-CR-633</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-633]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AllowanceChargeReasonCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)">
          <attribute name="id">UBL-CR-634</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-634]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AllowanceChargeReason</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)">
          <attribute name="id">UBL-CR-635</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-635]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge MultiplierFactorNumeric</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator)">
          <attribute name="id">UBL-CR-636</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-636]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PrepaidIndicator</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric)">
          <attribute name="id">UBL-CR-637</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-637]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge SequenceNumeric</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode)">
          <attribute name="id">UBL-CR-638</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-638]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AccountingCostCode</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AccountingCost)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AccountingCost)">
          <attribute name="id">UBL-CR-639</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-639]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AccountingCost</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:PerUnitAmount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:PerUnitAmount)">
          <attribute name="id">UBL-CR-640</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-640]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PerUnitAmount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:TaxCategory)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:TaxCategory)">
          <attribute name="id">UBL-CR-641</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-641]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge TaxCategory</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:TaxTotal)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:TaxTotal)">
          <attribute name="id">UBL-CR-642</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-642]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge TaxTotal</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:PaymentMeans)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:PaymentMeans)">
          <attribute name="id">UBL-CR-643</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-643]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PaymentMeans</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:PricingExchangeRate)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:PricingExchangeRate)">
          <attribute name="id">UBL-CR-644</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-644]-A UBL invoice should not include the InvoiceLine Item Price PricingExchangeRate</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DeliveryTerms)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DeliveryTerms)">
          <attribute name="id">UBL-CR-645</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-645]-A UBL invoice should not include the InvoiceLine DeliveryTerms</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:SubInvoiceLine)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:SubInvoiceLine)">
          <attribute name="id">UBL-CR-646</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-646]-A UBL invoice should not include the InvoiceLine SubInvoiceLine</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:ItemPriceExtension)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:ItemPriceExtension)">
          <attribute name="id">UBL-CR-647</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-647]-A UBL invoice should not include the InvoiceLine ItemPriceExtension</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:CustomizationID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:CustomizationID/@schemeID)">
          <attribute name="id">UBL-CR-648</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-648]-A UBL invoice should not include the CustomizationID scheme identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:ProfileID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:ProfileID/@schemeID)">
          <attribute name="id">UBL-CR-649</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-649]-A UBL invoice should not include the ProfileID scheme identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-650</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-650]-A UBL invoice shall not include the Invoice ID scheme identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:SalesOrderID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:SalesOrderID/@schemeID)">
          <attribute name="id">UBL-CR-651</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-651]-A UBL invoice should not include the SalesOrderID scheme identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:PartyTaxScheme/cbc:CompanyID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:PartyTaxScheme/cbc:CompanyID/@schemeID)">
          <attribute name="id">UBL-CR-652</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-652]-A UBL invoice should not include the PartyTaxScheme CompanyID scheme identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cbc:PaymentID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:PaymentID/@schemeID)">
          <attribute name="id">UBL-CR-653</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-653]-A UBL invoice should not include the PaymentID scheme identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-654</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-654]-A UBL invoice should not include the PayeeFinancialAccount scheme identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-655</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-655]-A UBL invoice shall not include the FinancialInstitutionBranch ID scheme identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:InvoiceTypeCode/@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:InvoiceTypeCode/@listID)">
          <attribute name="id">UBL-CR-656</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-656]-A UBL invoice should not include the InvoiceTypeCode listID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:DocumentCurrencyCode/@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:DocumentCurrencyCode/@listID)">
          <attribute name="id">UBL-CR-657</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-657]-A UBL invoice should not include the DocumentCurrencyCode listID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:TaxCurrencyCode/@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:TaxCurrencyCode/@listID)">
          <attribute name="id">UBL-CR-658</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-658]-A UBL invoice should not include the TaxCurrencyCode listID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode/@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode/@listID)">
          <attribute name="id">UBL-CR-659</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-659]-A UBL invoice shall not include the AdditionalDocumentReference DocumentTypeCode listID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:Country/cbc:IdentificationCode/@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:Country/cbc:IdentificationCode/@listID)">
          <attribute name="id">UBL-CR-660</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-660]-A UBL invoice should not include the Country Identification code listID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cac:PaymentMeans/cbc:PaymentMeansCode/@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:PaymentMeansCode/@listID)">
          <attribute name="id">UBL-CR-661</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-661]-A UBL invoice should not include the PaymentMeansCode listID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cbc:AllowanceChargeReasonCode/@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cbc:AllowanceChargeReasonCode/@listID)">
          <attribute name="id">UBL-CR-662</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-662]-A UBL invoice should not include the AllowanceChargeReasonCode listID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@unitCodeListID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@unitCodeListID)">
          <attribute name="id">UBL-CR-663</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-663]-A UBL invoice should not include the unitCodeListID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:FinancialInstitution)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:FinancialInstitution)">
          <attribute name="id">UBL-CR-664</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-664]-A UBL invoice should not include the FinancialInstitutionBranch FinancialInstitution</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  != '130' or not(cbc:DocumentTypeCode)]/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode != '130' or not(cbc:DocumentTypeCode)]/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-665</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-665]-A UBL invoice should not include the AdditionalDocumentReference ID schemeID unless the ID equals '130'</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  = '130']/cac:Attachment)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '130']/cac:Attachment)">
          <attribute name="id">UBL-CR-666</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-666]-A UBL invoice shall not include an AdditionalDocumentReference simultaneously referring an Invoice Object Identifier and an Attachment</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:BuyersItemIdentification/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:BuyersItemIdentification/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-667</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-667]-A UBL invoice should not include a Buyer Item Identification schemeID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:SellersItemIdentification/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:SellersItemIdentification/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-668</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-668]-A UBL invoice should not include a Sellers Item Identification schemeID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)">
          <attribute name="id">UBL-CR-669</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-669]-A UBL invoice should not include a Price Allowance Reason Code</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)">
          <attribute name="id">UBL-CR-670</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-670]-A UBL invoice should not include a Price Allowance Reason</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)">
          <attribute name="id">UBL-CR-671</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-671]-A UBL invoice should not include a Price Allowance Multiplier Factor</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(cbc:CreditNoteTypeCode/@listID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(cbc:CreditNoteTypeCode/@listID)">
          <attribute name="id">UBL-CR-672</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-672]-A UBL credit note should not include the CreditNoteTypeCode listID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  = '130']/cbc:DocumentDescription)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '130']/cbc:DocumentDescription)">
          <attribute name="id">UBL-CR-673</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-673]-A UBL invoice shall not include an AdditionalDocumentReference simultaneously referring an Invoice Object Identifier and an Document Description</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cbc:PrimaryAccountNumber/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cbc:PrimaryAccountNumber/@schemeID)">
          <attribute name="id">UBL-CR-674</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-674]-A UBL invoice should not include the PrimaryAccountNumber schemeID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:CardAccount/cbc:NetworkID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:CardAccount/cbc:NetworkID/@schemeID)">
          <attribute name="id">UBL-CR-675</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-675]-A UBL invoice should not include the NetworkID schemeID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:PaymentMandate/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:PaymentMandate/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-676</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-676]-A UBL invoice should not include the PaymentMandate/ID schemeID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-677</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-677]-A UBL invoice should not include the PayerFinancialAccount/ID schemeID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:TaxCategory/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:TaxCategory/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-678</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-678]-A UBL invoice should not include the TaxCategory/ID schemeID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:ClassifiedTaxCategory/cbc:ID/@schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:ClassifiedTaxCategory/cbc:ID/@schemeID)">
          <attribute name="id">UBL-CR-679</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-679]-A UBL invoice should not include the ClassifiedTaxCategory/ID schemeID</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//cac:PaymentMeans/cac:PayerFinancialAccount)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//cac:PaymentMeans/cac:PayerFinancialAccount)">
          <attribute name="id">UBL-CR-680</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-CR-680]-A UBL invoice should not include the PaymentMeans/PayerFinancialAccount</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@schemeName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@schemeName)">
          <attribute name="id">UBL-DT-08</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-08]-Scheme name attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@schemeAgencyName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@schemeAgencyName)">
          <attribute name="id">UBL-DT-09</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-09]-Scheme agency name attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@schemeDataURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@schemeDataURI)">
          <attribute name="id">UBL-DT-10</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-10]-Scheme data uri attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@schemeURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@schemeURI)">
          <attribute name="id">UBL-DT-11</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-11]-Scheme uri attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@format)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@format)">
          <attribute name="id">UBL-DT-12</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-12]-Format attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@unitCodeListIdentifier)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@unitCodeListIdentifier)">
          <attribute name="id">UBL-DT-13</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-13]-Unit code list identifier attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@unitCodeListAgencyIdentifier)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@unitCodeListAgencyIdentifier)">
          <attribute name="id">UBL-DT-14</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-14]-Unit code list agency identifier attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@unitCodeListAgencyName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@unitCodeListAgencyName)">
          <attribute name="id">UBL-DT-15</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-15]-Unit code list agency name attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@listAgencyName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@listAgencyName)">
          <attribute name="id">UBL-DT-16</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-16]-List agency name attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@listName)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@listName)">
          <attribute name="id">UBL-DT-17</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-17]-List name attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="count(//@name) - count(//cbc:PaymentMeansCode/@name) &lt;= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count(//@name) - count(//cbc:PaymentMeansCode/@name) &lt;= 0">
          <attribute name="id">UBL-DT-18</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-18]-Name attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@languageID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@languageID)">
          <attribute name="id">UBL-DT-19</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-19]-Language identifier attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@listURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@listURI)">
          <attribute name="id">UBL-DT-20</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-20]-List uri attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@listSchemeURI)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@listSchemeURI)">
          <attribute name="id">UBL-DT-21</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-21]-List scheme uri attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@languageLocaleID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@languageLocaleID)">
          <attribute name="id">UBL-DT-22</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-22]-Language local identifier attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@uri)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@uri)">
          <attribute name="id">UBL-DT-23</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-23]-Uri attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@currencyCodeListVersionID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@currencyCodeListVersionID)">
          <attribute name="id">UBL-DT-24</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-24]-Currency code list version id should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@characterSetCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@characterSetCode)">
          <attribute name="id">UBL-DT-25</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-25]-CharacterSetCode attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@encodingCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@encodingCode)">
          <attribute name="id">UBL-DT-26</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-26]-EncodingCode attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@schemeAgencyID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@schemeAgencyID)">
          <attribute name="id">UBL-DT-27</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-27]-Scheme Agency ID attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(//@listAgencyID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(//@listAgencyID)">
          <attribute name="id">UBL-DT-28</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-DT-28]-List Agency ID attribute should not be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:ContractDocumentReference/cbc:ID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:ContractDocumentReference/cbc:ID) &lt;= 1)">
          <attribute name="id">UBL-SR-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-01]-Contract identifier shall occur maximum once.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:ReceiptDocumentReference/cbc:ID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:ReceiptDocumentReference/cbc:ID) &lt;= 1)">
          <attribute name="id">UBL-SR-02</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-02]-Receive advice identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:DespatchDocumentReference/cbc:ID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:DespatchDocumentReference/cbc:ID) &lt;= 1)">
          <attribute name="id">UBL-SR-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-03]-Despatch advice identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='130']/cbc:ID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='130']/cbc:ID) &lt;= 1)">
          <attribute name="id">UBL-SR-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-04]-Invoice object identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:PaymentTerms/cbc:Note) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:PaymentTerms/cbc:Note) &lt;= 1)">
          <attribute name="id">UBL-SR-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-05]-Payment terms shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:InvoicePeriod) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:InvoicePeriod) &lt;= 1)">
          <attribute name="id">UBL-SR-08</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-08]-Invoice period shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &lt;= 1)">
          <attribute name="id">UBL-SR-09</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-09]-Seller name shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name) &lt;= 1)">
          <attribute name="id">UBL-SR-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-10]-Seller trader name shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1)">
          <attribute name="id">UBL-SR-11</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-11]-Seller legal registration identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)">
          <attribute name="id">UBL-SR-12</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-12]-Seller VAT identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)!='VAT']/cbc:CompanyID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)!='VAT']/cbc:CompanyID) &lt;= 1)">
          <attribute name="id">UBL-SR-13</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-13]-Seller tax registration shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm) &lt;= 1)">
          <attribute name="id">UBL-SR-14</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-14]-Seller additional legal information shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &lt;= 1)">
          <attribute name="id">UBL-SR-15</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-15]-Buyer name shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) &lt;= 1)">
          <attribute name="id">UBL-SR-16</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-16]-Buyer identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1)">
          <attribute name="id">UBL-SR-17</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-17]-Buyer legal registration identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)">
          <attribute name="id">UBL-SR-18</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-18]-Buyer VAT identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:Delivery) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:Delivery) &lt;= 1)">
          <attribute name="id">UBL-SR-24</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-24]-Deliver to information shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(//cac:PartyIdentification/cbc:ID[upper-case(@schemeID) = 'SEPA']) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(//cac:PartyIdentification/cbc:ID[upper-case(@schemeID) = 'SEPA']) &lt;= 1)">
          <attribute name="id">UBL-SR-29</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-29]-Bank creditor reference shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:ProjectReference/cbc:ID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:ProjectReference/cbc:ID) &lt;= 1)">
          <attribute name="id">UBL-SR-39</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-39]-Project reference shall occur maximum once.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name) &lt;= 1)">
          <attribute name="id">UBL-SR-40</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-40]-Buyer trade name shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="count(//cbc:PaymentID[not(preceding::cbc:PaymentID/. = .)]) &lt;= 1" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count(//cbc:PaymentID[not(preceding::cbc:PaymentID/. = .)]) &lt;= 1">
          <attribute name="id">UBL-SR-44</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-44]-Payment ID shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:PaymentMeans/cbc:PaymentDueDate) &lt;=1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:PaymentMeans/cbc:PaymentDueDate) &lt;=1)">
          <attribute name="id">UBL-SR-45</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-45]-Due Date shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:PaymentMeans/cbc:PaymentMeansCode/@name) &lt;=1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:PaymentMeans/cbc:PaymentMeansCode/@name) &lt;=1)">
          <attribute name="id">UBL-SR-46</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-46]-Payment means text shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="count(//cbc:PaymentMeansCode[not(preceding::cbc:PaymentMeansCode/. = .)]) &lt;= 1" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count(//cbc:PaymentMeansCode[not(preceding::cbc:PaymentMeansCode/. = .)]) &lt;= 1">
          <attribute name="id">UBL-SR-47</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-47]-When there are more than one payment means code, they shall be equal</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:InvoicePeriod/cbc:DescriptionCode) &lt;=1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:InvoicePeriod/cbc:DescriptionCode) &lt;=1)">
          <attribute name="id">UBL-SR-49</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-49]-Value tax point date shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M11" priority="1005">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<choose>
      <when test="(count(cbc:Note) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cbc:Note) &lt;= 1)">
          <attribute name="id">UBL-SR-34</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-34]-Invoice line note shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:OrderLineReference/cbc:LineID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:OrderLineReference/cbc:LineID) &lt;= 1)">
          <attribute name="id">UBL-SR-35</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-35]-Referenced purchase order line identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:InvoicePeriod) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:InvoicePeriod) &lt;= 1)">
          <attribute name="id">UBL-SR-36</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-36]-Invoice line period shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:Price/cac:AllowanceCharge/cbc:Amount) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:Price/cac:AllowanceCharge/cbc:Amount) &lt;= 1)">
          <attribute name="id">UBL-SR-37</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-37]-Item price discount shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="count(cac:Item/cac:ClassifiedTaxCategory) = 1" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count(cac:Item/cac:ClassifiedTaxCategory) = 1">
          <attribute name="id">UBL-SR-48</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-48]-Invoice lines shall have one and only one classified tax category.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="count(cac:Item/cbc:Description) &lt;= 1" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count(cac:Item/cbc:Description) &lt;= 1">
          <attribute name="id">UBL-SR-50</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-50]-Item description shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PayeeParty" mode="M11" priority="1004">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PayeeParty" />

		<!--ASSERT -->
<choose>
      <when test="(count(cac:PartyName/cbc:Name) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:PartyName/cbc:Name) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))">
          <attribute name="id">UBL-SR-19</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-19]-Payee name shall occur maximum once, if the Payee is different from the Seller</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:PartyIdentification/cbc:ID[upper-case(@schemeID) != 'SEPA']) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:PartyIdentification/cbc:ID[upper-case(@schemeID) != 'SEPA']) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))">
          <attribute name="id">UBL-SR-20</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-20]-Payee identifier shall occur maximum once, if the Payee is different from the Seller</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))">
          <attribute name="id">UBL-SR-21</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-21]-Payee legal registration identifier shall occur maximum once, if the Payee is different from the Seller</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PaymentMeans" mode="M11" priority="1003">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PaymentMeans" />

		<!--ASSERT -->
<choose>
      <when test="(count(cbc:PaymentID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cbc:PaymentID) &lt;= 1)">
          <attribute name="id">UBL-SR-26</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-26]-Payment reference shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cbc:PaymentMeansCode) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cbc:PaymentMeansCode) &lt;= 1)">
          <attribute name="id">UBL-SR-27</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-27]-Payment means text shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:PaymentMandate/cbc:ID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:PaymentMandate/cbc:ID) &lt;= 1)">
          <attribute name="id">UBL-SR-28</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-28]-Mandate reference identifier shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:BillingReference" mode="M11" priority="1002">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:BillingReference" />

		<!--ASSERT -->
<choose>
      <when test="(count(cac:InvoiceDocumentReference) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:InvoiceDocumentReference) &lt;= 1)">
          <attribute name="id">UBL-SR-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-06]-Preceding invoice reference shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cac:InvoiceDocumentReference/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:InvoiceDocumentReference/cbc:ID)">
          <attribute name="id">UBL-SR-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-07]-If there is a preceding invoice reference, the preceding invoice number shall be present</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:TaxRepresentativeParty" mode="M11" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<choose>
      <when test="(count(cac:Party/cac:PartyName/cbc:Name) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:Party/cac:PartyName/cbc:Name) &lt;= 1)">
          <attribute name="id">UBL-SR-22</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-22]-Seller tax representative name shall occur maximum once, if the Seller has a tax representative</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)">
          <attribute name="id">UBL-SR-23</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-23]-Seller tax representative VAT identifier shall occur maximum once, if the Seller has a tax representative</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:TaxSubtotal" mode="M11" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:TaxSubtotal" />

		<!--ASSERT -->
<choose>
      <when test="(count(cac:TaxCategory/cbc:TaxExemptionReason) &lt;= 1)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cac:TaxCategory/cbc:TaxExemptionReason) &lt;= 1)">
          <attribute name="id">UBL-SR-32</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[UBL-SR-32]-VAT exemption reason text shall occur maximum once</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>
  <template match="text()" mode="M11" priority="-1" />
  <template match="@*|node()" mode="M11" priority="-2">
    <apply-templates mode="M11" select="@*|*" />
  </template>

<!--PATTERN Codesmodel-->


	<!--RULE -->
<template match="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" mode="M12" priority="1021">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" />

		<!--ASSERT -->
<choose>
      <when test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 381 396 420 458 532 ', concat(' ', normalize-space(.), ' ')))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 381 396 420 458 532 ', concat(' ', normalize-space(.), ' ')))))">
          <attribute name="id">BR-CL-01</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-01]-The document type code MUST be coded by the invoice and credit note related code lists of UNTDID 1001.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" mode="M12" priority="1020">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' '))))">
          <attribute name="id">BR-CL-03</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-03]-currencyID MUST be coded using ISO code list 4217 alpha-3</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:DocumentCurrencyCode" mode="M12" priority="1019">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:DocumentCurrencyCode" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))">
          <attribute name="id">BR-CL-04</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-04]-Invoice currency code MUST be coded using ISO code list 4217 alpha-3</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:TaxCurrencyCode" mode="M12" priority="1018">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:TaxCurrencyCode" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))">
          <attribute name="id">BR-CL-05</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-05]-Tax currency code MUST be coded using ISO code list 4217 alpha-3</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:InvoicePeriod/cbc:DescriptionCode" mode="M12" priority="1017">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:InvoicePeriod/cbc:DescriptionCode" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))">
          <attribute name="id">BR-CL-06</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-06]-Value added tax point date code MUST be coded using a restriction of UNTDID 2005.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID] | cac:DocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID]" mode="M12" priority="1016">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID] | cac:DocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID]" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABY ABZ AC ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACN ACO ACP ACQ ACR ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADT ADU ADV ADW ADX ADY ADZ AE AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB AJC AJD AJE AJF AJG AJH AJI AJJ AJK AJL AJM AJN AJO AJP AJQ AJR AJS AJT AJU AJV AJW AJX AJY AJZ AKA AKB AKC AKD AKE AKF AKG AKH AKI AKJ AKK AKL AKM AKN AKO AKP AKQ AKR AKS AKT AKU AKV AKW AKX AKY AKZ ALA ALB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ALR ALS ALT ALU ALV ALW ALX ALY ALZ AMA AMB AMC AMD AME AMF AMG AMH AMI AMJ AMK AML AMM AMN AMO AMP AMQ AMR AMS AMT AMU AMV AMW AMX AMY AMZ ANA ANB ANC AND ANE ANF ANG ANH ANI ANJ ANK ANL ANM ANN ANO ANP ANQ ANR ANS ANT ANU ANV ANW ANX ANY AOA AOD AOE AOF AOG AOH AOI AOJ AOK AOL AOM AON AOO AOP AOQ AOR AOS AOT AOU AOV AOW AOX AOY AOZ AP APA APB APC APD APE APF APG APH API APJ APK APL APM APN APO APP APQ APR APS APT APU APV APW APX APY APZ AQA AQB AQC AQD AQE AQF AQG AQH AQI AQJ AQK AQL AQM AQN AQO AQP AQQ AQR AQS AQT AQU AQV AQW AQX AQY AQZ ARA ARB ARC ARD ARE ARF ARG ARH ARI ARJ ARK ARL ARM ARN ARO ARP ARQ ARR ARS ART ARU ARV ARW ARX ARY ARZ ASA ASB ASC ASD ASE ASF ASG ASH ASI ASJ ASK ASL ASM ASN ASO ASP ASQ ASR ASS AST ASU ASV ASW ASX ASY ASZ ATA ATB ATC ATD ATE ATF ATG ATH ATI ATJ ATK ATL ATM ATN ATO ATP ATQ ATR ATS ATT ATU ATV ATW ATX ATY ATZ AU AUA AUB AUC AUD AUE AUF AUG AUH AUI AUJ AUK AUL AUM AUN AUO AUP AUQ AUR AUS AUT AUU AUV AUW AUX AUY AUZ AV AVA AVB AVC AVD AVE AVF AVG AVH AVI AVJ AVK AVL AVM AVN AVO AVP AVQ AVR AVS AVT AVU AVV AVW AVX AVY AVZ AWA AWB AWC AWD AWE AWF AWG AWH AWI AWJ AWK AWL AWM AWN AWO AWP AWQ AWR AWS AWT AWU AWV AWW AWX AWY AWZ AXA AXB AXC AXD AXE AXF AXG AXH AXI AXJ AXK AXL AXM AXN AXO AXP AXQ AXR AXS BA BC BD BE BH BM BN BO BR BT BTP BW CAS CAT CAU CAV CAW CAX CAY CAZ CBA CBB CD CEC CED CFE CFF CFO CG CH CK CKN CM CMR CN CNO COF CP CR CRN CS CST CT CU CV CW CZ DA DAN DB DI DL DM DQ DR EA EB ED EE EEP EI EN EQ ER ERN ET EX FC FF FI FLW FN FO FS FT FV FX GA GC GD GDN GN HS HWB IA IB ICA ICE ICO II IL INB INN INO IP IS IT IV JB JE LA LAN LAR LB LC LI LO LRC LS MA MB MF MG MH MR MRN MS MSS MWB NA NF OH OI ON OP OR PB PC PD PE PF PI PK PL POR PP PQ PR PS PW PY RA RC RCN RE REN RF RR RT SA SB SD SE SEA SF SH SI SM SN SP SQ SRN SS STA SW SZ TB TCR TE TF TI TIN TL TN TP UAR UC UCN UN UO URI VA VC VGR VM VN VON VOR VP VR VS VT VV WE WM WN WR WS WY XA XC XP ZZZ ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABY ABZ AC ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACN ACO ACP ACQ ACR ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADT ADU ADV ADW ADX ADY ADZ AE AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB AJC AJD AJE AJF AJG AJH AJI AJJ AJK AJL AJM AJN AJO AJP AJQ AJR AJS AJT AJU AJV AJW AJX AJY AJZ AKA AKB AKC AKD AKE AKF AKG AKH AKI AKJ AKK AKL AKM AKN AKO AKP AKQ AKR AKS AKT AKU AKV AKW AKX AKY AKZ ALA ALB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ALR ALS ALT ALU ALV ALW ALX ALY ALZ AMA AMB AMC AMD AME AMF AMG AMH AMI AMJ AMK AML AMM AMN AMO AMP AMQ AMR AMS AMT AMU AMV AMW AMX AMY AMZ ANA ANB ANC AND ANE ANF ANG ANH ANI ANJ ANK ANL ANM ANN ANO ANP ANQ ANR ANS ANT ANU ANV ANW ANX ANY AOA AOD AOE AOF AOG AOH AOI AOJ AOK AOL AOM AON AOO AOP AOQ AOR AOS AOT AOU AOV AOW AOX AOY AOZ AP APA APB APC APD APE APF APG APH API APJ APK APL APM APN APO APP APQ APR APS APT APU APV APW APX APY APZ AQA AQB AQC AQD AQE AQF AQG AQH AQI AQJ AQK AQL AQM AQN AQO AQP AQQ AQR AQS AQT AQU AQV AQW AQX AQY AQZ ARA ARB ARC ARD ARE ARF ARG ARH ARI ARJ ARK ARL ARM ARN ARO ARP ARQ ARR ARS ART ARU ARV ARW ARX ARY ARZ ASA ASB ASC ASD ASE ASF ASG ASH ASI ASJ ASK ASL ASM ASN ASO ASP ASQ ASR ASS AST ASU ASV ASW ASX ASY ASZ ATA ATB ATC ATD ATE ATF ATG ATH ATI ATJ ATK ATL ATM ATN ATO ATP ATQ ATR ATS ATT ATU ATV ATW ATX ATY ATZ AU AUA AUB AUC AUD AUE AUF AUG AUH AUI AUJ AUK AUL AUM AUN AUO AUP AUQ AUR AUS AUT AUU AUV AUW AUX AUY AUZ AV AVA AVB AVC AVD AVE AVF AVG AVH AVI AVJ AVK AVL AVM AVN AVO AVP AVQ AVR AVS AVT AVU AVV AVW AVX AVY AVZ AWA AWB AWC AWD AWE AWF AWG AWH AWI AWJ AWK AWL AWM AWN AWO AWP AWQ AWR AWS AWT AWU AWV AWW AWX AWY AWZ AXA AXB AXC AXD AXE AXF AXG AXH AXI AXJ AXK AXL AXM AXN AXO AXP AXQ AXR AXS BA BC BD BE BH BM BN BO BR BT BTP BW CAS CAT CAU CAV CAW CAX CAY CAZ CBA CBB CD CEC CED CFE CFF CFO CG CH CK CKN CM CMR CN CNO COF CP CR CRN CS CST CT CU CV CW CZ DA DAN DB DI DL DM DQ DR EA EB ED EE EEP EI EN EQ ER ERN ET EX FC FF FI FLW FN FO FS FT FV FX GA GC GD GDN GN HS HWB IA IB ICA ICE ICO II IL INB INN INO IP IS IT IV JB JE LA LAN LAR LB LC LI LO LRC LS MA MB MF MG MH MR MRN MS MSS MWB NA NF OH OI ON OP OR PB PC PD PE PF PI PK PL POR PP PQ PR PS PW PY RA RC RCN RE REN RF RR RT SA SB SD SE SEA SF SH SI SM SN SP SQ SRN SS STA SW SZ TB TCR TE TF TI TIN TL TN TP UAR UC UCN UN UO URI VA VC VGR VM VN VON VOR VP VR VS VT VV WE WM WN WR WS WY XA XC XP ZZZ ', concat(' ', normalize-space(@schemeID), ' '))))">
          <attribute name="id">BR-CL-07</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-07]-Object identifier identification scheme identifier MUST be coded using a restriction of UNTDID 1153.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PartyIdentification/cbc:ID[@schemeID]" mode="M12" priority="1015">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PartyIdentification/cbc:ID[@schemeID]" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))  or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty)))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' ')))) or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty)))">
          <attribute name="id">BR-CL-10</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-10]-Any identifier identification scheme identifier MUST be coded using one of the ISO 6523 ICD list.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PartyLegalEntity/cbc:CompanyID[@schemeID]" mode="M12" priority="1014">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PartyLegalEntity/cbc:CompanyID[@schemeID]" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))">
          <attribute name="id">BR-CL-11</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-11]-Any registration identifier identification scheme identifier MUST be coded using one of the ISO 6523 ICD list.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:CommodityClassification/cbc:ItemClassificationCode[@listID]" mode="M12" priority="1013">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:CommodityClassification/cbc:ItemClassificationCode[@listID]" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@listID), ' ')) and contains(' AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ ', concat(' ', normalize-space(@listID), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@listID), ' ')) and contains(' AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ ', concat(' ', normalize-space(@listID), ' '))))">
          <attribute name="id">BR-CL-13</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-13]-Item classification identifier identification scheme identifier MUST be
      coded using one of the UNTDID 7143 list.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:Country/cbc:IdentificationCode" mode="M12" priority="1012">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))">
          <attribute name="id">BR-CL-14</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-14]-Country codes in an invoice MUST be coded using ISO code list 3166-1</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:OriginCountry/cbc:IdentificationCode" mode="M12" priority="1011">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:OriginCountry/cbc:IdentificationCode" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))">
          <attribute name="id">BR-CL-15</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-15]-Country codes in an invoice MUST be coded using ISO code list 3166-1</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:PaymentMeans/cbc:PaymentMeansCode" mode="M12" priority="1010">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:PaymentMeans/cbc:PaymentMeansCode" />

		<!--ASSERT -->
<choose>
      <when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) )">
          <attribute name="id">BR-CL-16</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-16]-Payment means in an invoice MUST be coded using UNCL4461 code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:TaxCategory/cbc:ID" mode="M12" priority="1009">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) )">
          <attribute name="id">BR-CL-17</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-17]-Invoice tax categories MUST be coded using UNCL5305 code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:ClassifiedTaxCategory/cbc:ID" mode="M12" priority="1008">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) )">
          <attribute name="id">BR-CL-18</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-18]-Invoice tax categories MUST be coded using UNCL5305 code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:AllowanceChargeReasonCode" mode="M12" priority="1007">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' '))))">
          <attribute name="id">BR-CL-19</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-19]-Coded allowance reasons MUST belong to the UNCL 5189 code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:AllowanceChargeReasonCode" mode="M12" priority="1006">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' '))))">
          <attribute name="id">BR-CL-20</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-20]-Coded charge reasons MUST belong to the UNCL 7161 code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:StandardItemIdentification/cbc:ID[@schemeID]" mode="M12" priority="1005">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:StandardItemIdentification/cbc:ID[@schemeID]" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))">
          <attribute name="id">BR-CL-21</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-21]-Item standard identifier scheme identifier MUST belong to the ISO 6523 ICD code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:TaxExemptionReasonCode" mode="M12" priority="1004">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:TaxExemptionReasonCode" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(.), ' ')) and contains(' VATEX-EU-79-C VATEX-EU-132 VATEX-EU-132-1A VATEX-EU-132-1B VATEX-EU-132-1C VATEX-EU-132-1D VATEX-EU-132-1E VATEX-EU-132-1F VATEX-EU-132-1G VATEX-EU-132-1H VATEX-EU-132-1I VATEX-EU-132-1J VATEX-EU-132-1K VATEX-EU-132-1L VATEX-EU-132-1M VATEX-EU-132-1N VATEX-EU-132-1O VATEX-EU-132-1P VATEX-EU-132-1Q VATEX-EU-143 VATEX-EU-143-1A VATEX-EU-143-1B VATEX-EU-143-1C VATEX-EU-143-1D VATEX-EU-143-1E VATEX-EU-143-1F VATEX-EU-143-1FA VATEX-EU-143-1G VATEX-EU-143-1H VATEX-EU-143-1I VATEX-EU-143-1J VATEX-EU-143-1K VATEX-EU-143-1L VATEX-EU-309 VATEX-EU-148 VATEX-EU-148-A VATEX-EU-148-B VATEX-EU-148-C VATEX-EU-148-D VATEX-EU-148-E VATEX-EU-148-F VATEX-EU-148-G VATEX-EU-151 VATEX-EU-151-1A VATEX-EU-151-1AA VATEX-EU-151-1B VATEX-EU-151-1C VATEX-EU-151-1D VATEX-EU-151-1E VATEX-EU-G VATEX-EU-O VATEX-EU-IC VATEX-EU-AE VATEX-EU-D VATEX-EU-F VATEX-EU-I VATEX-EU-J ', concat(' ', normalize-space(upper-case(.)), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(.), ' ')) and contains(' VATEX-EU-79-C VATEX-EU-132 VATEX-EU-132-1A VATEX-EU-132-1B VATEX-EU-132-1C VATEX-EU-132-1D VATEX-EU-132-1E VATEX-EU-132-1F VATEX-EU-132-1G VATEX-EU-132-1H VATEX-EU-132-1I VATEX-EU-132-1J VATEX-EU-132-1K VATEX-EU-132-1L VATEX-EU-132-1M VATEX-EU-132-1N VATEX-EU-132-1O VATEX-EU-132-1P VATEX-EU-132-1Q VATEX-EU-143 VATEX-EU-143-1A VATEX-EU-143-1B VATEX-EU-143-1C VATEX-EU-143-1D VATEX-EU-143-1E VATEX-EU-143-1F VATEX-EU-143-1FA VATEX-EU-143-1G VATEX-EU-143-1H VATEX-EU-143-1I VATEX-EU-143-1J VATEX-EU-143-1K VATEX-EU-143-1L VATEX-EU-309 VATEX-EU-148 VATEX-EU-148-A VATEX-EU-148-B VATEX-EU-148-C VATEX-EU-148-D VATEX-EU-148-E VATEX-EU-148-F VATEX-EU-148-G VATEX-EU-151 VATEX-EU-151-1A VATEX-EU-151-1AA VATEX-EU-151-1B VATEX-EU-151-1C VATEX-EU-151-1D VATEX-EU-151-1E VATEX-EU-G VATEX-EU-O VATEX-EU-IC VATEX-EU-AE VATEX-EU-D VATEX-EU-F VATEX-EU-I VATEX-EU-J ', concat(' ', normalize-space(upper-case(.)), ' '))))">
          <attribute name="id">BR-CL-22</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-22]-Tax exemption reason code identifier scheme identifier MUST belong to the CEF VATEX code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:InvoicedQuantity[@unitCode] | cbc:BaseQuantity[@unitCode] | cbc:CreditedQuantity[@unitCode]" mode="M12" priority="1003">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:InvoicedQuantity[@unitCode] | cbc:BaseQuantity[@unitCode] | cbc:CreditedQuantity[@unitCode]" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@unitCode), ' ')) and contains(' 10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR HWE IA IE INH INK INQ ISD IU IUG IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWN KWO KWS KWT KWY KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE ODG ODK ODM OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q3 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q41 Q42 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 Z9 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOJ XOK XOL XOM XON XOP XOQ XOR XOS XOT XOU XOV XOW XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVN XVO XVP XVQ XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ ', concat(' ', normalize-space(@unitCode), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@unitCode), ' ')) and contains(' 10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR HWE IA IE INH INK INQ ISD IU IUG IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWN KWO KWS KWT KWY KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE ODG ODK ODM OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q3 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q41 Q42 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 Z9 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOJ XOK XOL XOM XON XOP XOQ XOR XOS XOT XOU XOV XOW XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVN XVO XVP XVQ XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ ', concat(' ', normalize-space(@unitCode), ' '))))">
          <attribute name="id">BR-CL-23</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-23]-Unit code MUST be coded according to the UN/ECE Recommendation 20 with
      Rec 21 extension</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:EmbeddedDocumentBinaryObject[@mimeCode]" mode="M12" priority="1002">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]" />

		<!--ASSERT -->
<choose>
      <when test="((@mimeCode = 'application/pdf' or @mimeCode = 'image/png' or @mimeCode = 'image/jpeg' or @mimeCode = 'text/csv' or @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet'))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((@mimeCode = 'application/pdf' or @mimeCode = 'image/png' or @mimeCode = 'image/jpeg' or @mimeCode = 'text/csv' or @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet'))">
          <attribute name="id">BR-CL-24</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-24]-For Mime code in attribute use MIMEMediaType.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:EndpointID[@schemeID]" mode="M12" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID]" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0208 0209 0210 0211 0212 0213 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957 AN AQ AS AU EM ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0208 0209 0210 0211 0212 0213 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957 AN AQ AS AU EM ', concat(' ', normalize-space(@schemeID), ' '))))">
          <attribute name="id">BR-CL-25</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-25]-Endpoint identifier scheme identifier MUST belong to the CEF EAS code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:DeliveryLocation/cbc:ID[@schemeID]" mode="M12" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:DeliveryLocation/cbc:ID[@schemeID]" />

		<!--ASSERT -->
<choose>
      <when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))">
          <attribute name="id">BR-CL-26</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[BR-CL-26]-Delivery location identifier scheme identifier MUST belong to the ISO 6523 ICD code list</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>
  <template match="text()" mode="M12" priority="-1" />
  <template match="@*|node()" mode="M12" priority="-2">
    <apply-templates mode="M12" select="@*|*" />
  </template>
</stylesheet>
