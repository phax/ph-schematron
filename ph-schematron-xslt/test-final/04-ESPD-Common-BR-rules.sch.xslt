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
        <variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])" />
        <if test="$p_1>1 or following-sibling::*[name()=name(current())]">[<value-of select="$p_1" />]</if>
      </when>
      <otherwise>
        <text>*[local-name()='</text>
        <value-of select="local-name()" />
        <text>']</text>
        <variable name="p_2" select="1+   count(preceding-sibling::*[local-name()=local-name(current())])" />
        <if test="$p_2>1 or following-sibling::*[local-name()=local-name(current())]">[<value-of select="$p_2" />]</if>
      </otherwise>
    </choose>
  </template>
  <template match="@*" mode="schematron-get-full-path">
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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" schemaVersion="" title="Common Business Rules assertions">
      <comment>
        <value-of select="$archiveDirParameter" />   
		 <value-of select="$archiveNameParameter" />  
		 <value-of select="$fileNameParameter" />  
		 <value-of select="$fileDirParameter" />
      </comment>
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ccv-cbc" uri="urn:isa:names:specification:ubl:schema:xsd:CCV-CommonBasicComponents-1" />
      <ns0:ns-prefix-in-attribute-values prefix="cev-cbc" uri="urn:isa:names:specification:ubl:schema:xsd:CEV-CommonBasicComponents-1" />
      <ns0:ns-prefix-in-attribute-values prefix="cev" uri="urn:isa:names:specification:ubl:schema:xsd:CEV-CommonAggregateComponents-1" />
      <ns0:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ccv" uri="urn:isa:names:specification:ubl:schema:xsd:CCV-CommonAggregateComponents-1" />
      <ns0:ns-prefix-in-attribute-values prefix="espd-req" uri="urn:grow:names:specification:ubl:schema:xsd:ESPDRequest-1" />
      <ns0:ns-prefix-in-attribute-values prefix="gc" uri="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <attribute name="id">common-br-rules</attribute>
        <attribute name="name">common-br-rules</attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M10" select="/" />
    </ns0:schematron-output>
  </template>

<!--SCHEMATRON PATTERNS-->
<ns0:text xmlns:ns0="http://purl.oclc.org/dsdl/svrl">Common Business Rules assertions</ns0:text>

<!--PATTERN common-br-rules-->


	<!--RULE -->
<template match="/espd-req:ESPDRequest/cac:ProcurementProjectLot" mode="M10" priority="1009">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/espd-req:ESPDRequest/cac:ProcurementProjectLot" />

		<!--ASSERT -->
<choose>
      <when test="( not(cbc:ID!='0') )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(cbc:ID!='0') )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The current version of the ESPD Service does not allow for the specification of multiple lots. To ensure conformace with the current version of the ESPD Service the ID sub-element inside the element ProcurementProjectLot MUST be 0 (zero).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>
  <variable name="TypeCodeExclusion" select="/espd-req:ESPDRequest/ccv:Criterion/cbc:TypeCode[starts-with(., 'CRITERION.EXCLUSION.')]" />

	<!--RULE -->
<template match="/espd-req:ESPDRequest" mode="M10" priority="1007">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/espd-req:ESPDRequest" />

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:ID))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:ID))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'espd-req:ESPDRequest / cbc:ID' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:IssueDate))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:IssueDate))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'espd-req:ESPDRequest / cbc:IssueDate' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="count( cac:AdditionalDocumentReference ) > 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count( cac:AdditionalDocumentReference ) > 0">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The ESPDRequest MUST always contain one 'AdditionalDocumentReference' element referring to the Contract Notice (CN) published in TeD (Publications Office). </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>

	<!--RULE -->
<template match="/espd-req:ESPDRequest/ccv:Criterion" mode="M10" priority="1006">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/espd-req:ESPDRequest/ccv:Criterion" />

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:ID))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:ID))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'cbc:ID' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:Name))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:Name))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'cbc:Name' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:Description))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:Description))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'cbc:Description' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:TypeCode))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:TypeCode))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'cbc:TypeCode' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not( (count(ccv:LegislationReference) = 0) and (contains(cbc:TypeCode, 'CRITERION.EXCLUSION.'))  )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not( (count(ccv:LegislationReference) = 0) and (contains(cbc:TypeCode, 'CRITERION.EXCLUSION.')) )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>All Exclusion Criteria MUST provide a value for the element LegislationReference </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>

	<!--RULE -->
<template match="/espd-req:ESPDRequest/ccv:Criterion/ccv:RequirementGroup" mode="M10" priority="1005">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/espd-req:ESPDRequest/ccv:Criterion/ccv:RequirementGroup" />

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:ID))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:ID))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'cbc:ID' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>

	<!--RULE -->
<template match="/espd-req:ESPDRequest/ccv:Criterion/ccv:RequirementGroup/ccv:Requirement" mode="M10" priority="1004">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/espd-req:ESPDRequest/ccv:Criterion/ccv:RequirementGroup/ccv:Requirement" />

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:Description))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:Description))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'cbc:Description' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:ID))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:ID))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'cbc:ID' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(@responseDataType))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(@responseDataType))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The attribute 'responseDataType' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>

	<!--RULE -->
<template match="/espd-req:ESPDRequest/ccv:Criterion/ccv:LegislationReference" mode="M10" priority="1003">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/espd-req:ESPDRequest/ccv:Criterion/ccv:LegislationReference" />

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:URI))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:URI))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'ccv-cbc:URI' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(ccv-cbc:Article))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(ccv-cbc:Article))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'ccv-cbc:Article' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(ccv-cbc:JurisdictionLevelCode))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(ccv-cbc:JurisdictionLevelCode))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'ccv-cbc:JurisdictionLevelCode' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(ccv-cbc:Title))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(ccv-cbc:Title))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'ccv-cbc:Title' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:Description))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:Description))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The element 'cbc:Description' is mandatory </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>

	<!--RULE -->
<template match="ccv:RequirementGroup/cbc:ID | ccv:RequirementGroup/ccv:Requirement/cbc:ID" mode="M10" priority="1002">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="ccv:RequirementGroup/cbc:ID | ccv:RequirementGroup/ccv:Requirement/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="( not(@schemeAgencyID!='EU-COM-GROW') )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(@schemeAgencyID!='EU-COM-GROW') )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The value of the attribute 'schemeAgencyID' must be 'EU-COM-GROW' </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(@schemeID!='CriterionRelatedIDs') )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(@schemeID!='CriterionRelatedIDs') )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The value of the attribute 'schemeID' must be 'CriterionRelatedIDs' </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="( not(@schemeVersionID!='1.0') )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(@schemeVersionID!='1.0') )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The value of the attribute 'schemeVersionID' must be '1.0' </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>

	<!--RULE -->
<template match="ccv:Criterion/cbc:ID" mode="M10" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="ccv:Criterion/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="( not(@schemeAgencyID!='EU-COM-GROW') )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(@schemeAgencyID!='EU-COM-GROW') )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The value of the attribute 'schemeAgencyID' must be 'EU-COM-GROW' </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>

	<!--RULE -->
<template match="/espd-req:ESPDRequest/cac:AdditionalDocumentReference" mode="M10" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/espd-req:ESPDRequest/cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<choose>
      <when test="( not(string(cbc:ID))=false() )" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="( not(string(cbc:ID))=false() )">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The AdditionalDocumentReference referring to the CN published in TeD MUST use the element ID to identify the CN. </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(count(cbc:ID)=0) or not(cbc:DocumentTypeCode/text() = 'TED_CN') or ((count(cbc:ID))=1 and (string-length(cbc:ID)=17 and substring(cbc:ID,5,3)='/S ' and substring(cbc:ID,11,1)='-'))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(count(cbc:ID)=0) or not(cbc:DocumentTypeCode/text() = 'TED_CN') or ((count(cbc:ID))=1 and (string-length(cbc:ID)=17 and substring(cbc:ID,5,3)='/S ' and substring(cbc:ID,11,1)='-'))">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>The value of the ID MUST follow the pattern YYYY/S DDD-DDDDDD, where 'YYYY' is a year, '/S' is a constant label, and 'D' represent digits. Beware of the existence of a space (a blank) between the 'S' and the first 'D'. </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>
  <template match="text()" mode="M10" priority="-1" />
  <template match="@*|node()" mode="M10" priority="-2">
    <apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </template>
</stylesheet>
