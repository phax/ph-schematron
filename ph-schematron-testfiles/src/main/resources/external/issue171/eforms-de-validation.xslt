<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:brin="http://data.europa.eu/p27/eforms-business-registration-information-notice/1" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:can="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" xmlns:efac="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" xmlns:efbc="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" xmlns:efext="http://data.europa.eu/p27/eforms-ubl-extensions/1" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:pin="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*:</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>[namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1+ $preceding" />
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="" title="eForms-DE Schematron Version @eforms-de-schematron.version.full@ compliant with eForms-DE specification @eforms-de.version.full@">
      <xsl:attribute name="phase">doe-validation-phase</xsl:attribute>
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="can" uri="urn:oasis:names:specification:ubl:schema:xsd:ContractAwardNotice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:ContractNotice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="pin" uri="urn:oasis:names:specification:ubl:schema:xsd:PriorInformationNotice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="brin" uri="http://data.europa.eu/p27/eforms-business-registration-information-notice/1" />
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="efac" uri="http://data.europa.eu/p27/eforms-ubl-extension-aggregate-components/1" />
      <svrl:ns-prefix-in-attribute-values prefix="efext" uri="http://data.europa.eu/p27/eforms-ubl-extensions/1" />
      <svrl:ns-prefix-in-attribute-values prefix="efbc" uri="http://data.europa.eu/p27/eforms-ubl-extension-basic-components/1" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">global-variable-pattern</xsl:attribute>
        <xsl:attribute name="name">global-variable-pattern</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">codelists</xsl:attribute>
        <xsl:attribute name="name">codelists</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">conditional-mandatory</xsl:attribute>
        <xsl:attribute name="name">conditional-mandatory</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">doe-validation-pattern</xsl:attribute>
        <xsl:attribute name="name">doe-validation-pattern</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">technical-sanity-pattern</xsl:attribute>
        <xsl:attribute name="name">technical-sanity-pattern</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M45" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">cardinality-pattern</xsl:attribute>
        <xsl:attribute name="name">cardinality-pattern</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M46" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>eForms-DE Schematron Version @eforms-de-schematron.version.full@ compliant with eForms-DE specification @eforms-de.version.full@</svrl:text>

<!--PATTERN global-variable-pattern-->
<xsl:variable name="EMAIL-REGEX" select="'^[a-zA-Z0-9!#\$%&amp;&quot;*+/=?^_`{|}~-]+(\.[a-zA-Z0-9!#\$%&amp;&quot;*+/=?^_`{|}~-]+)*@([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$'" />
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

<!--PATTERN codelists-->


	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ContractingParty/cac:ContractingPartyType/cbc:PartyTypeCode[@listName = 'buyer-contracting-type']" mode="M15" priority="1009">
    <svrl:fired-rule context="$ROOT-NODE/cac:ContractingParty/cac:ContractingPartyType/cbc:PartyTypeCode[@listName = 'buyer-contracting-type']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('cont-ent','not-cont-ent')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('cont-ent','not-cont-ent')">
          <xsl:attribute name="id">CL-DE-BT-740</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-740] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:buyer-contracting-type.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ContractingParty/cac:ContractingPartyType/cbc:PartyTypeCode[@listName = 'buyer-legal-type']" mode="M15" priority="1008">
    <svrl:fired-rule context="$ROOT-NODE/cac:ContractingParty/cac:ContractingPartyType/cbc:PartyTypeCode[@listName = 'buyer-legal-type']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('koerp-oer-bund','anst-oer-bund','stift-oer-bund','koerp-oer-kommun','anst-oer-kommun','stift-oer-kommun','koerp-oer-land','anst-oer-land','stift-oer-land','oberst-bbeh','omu-bbeh-niedrig','omu-bbeh','def-cont','eu-ins-bod-ag','grp-p-aut','int-org','kommun-beh','org-sub','pub-undert','pub-undert-cga','pub-undert-la','pub-undert-ra','oberst-lbeh','omu-lbeh','spec-rights-entity')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('koerp-oer-bund','anst-oer-bund','stift-oer-bund','koerp-oer-kommun','anst-oer-kommun','stift-oer-kommun','koerp-oer-land','anst-oer-land','stift-oer-land','oberst-bbeh','omu-bbeh-niedrig','omu-bbeh','def-cont','eu-ins-bod-ag','grp-p-aut','int-org','kommun-beh','org-sub','pub-undert','pub-undert-cga','pub-undert-la','pub-undert-ra','oberst-lbeh','omu-lbeh','spec-rights-entity')">
          <xsl:attribute name="id">CL-DE-BT-11</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-11] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:eforms-buyer-legal-type.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:TenderingTerms/cac:TendererQualificationRequest/cac:SpecificTendererRequirement/cbc:TendererRequirementTypeCode[@listName = 'exclusion-ground']" mode="M15" priority="1007">
    <svrl:fired-rule context="$ROOT-NODE/cac:TenderingTerms/cac:TendererQualificationRequest/cac:SpecificTendererRequirement/cbc:TendererRequirementTypeCode[@listName = 'exclusion-ground']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('bankr-nat','bankruptcy','corruption','cred-arran','crime-org','distorsion','envir-law','finan-laund','fraud','human-traffic','insolvency','labour-law','liq-admin','misrepresent','nati-ground','partic-confl','prep-confl','prof-misconduct','sanction','socsec-law','socsec-pay','susp-act','tax-pay','terr-offence')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('bankr-nat','bankruptcy','corruption','cred-arran','crime-org','distorsion','envir-law','finan-laund','fraud','human-traffic','insolvency','labour-law','liq-admin','misrepresent','nati-ground','partic-confl','prep-confl','prof-misconduct','sanction','socsec-law','socsec-pay','susp-act','tax-pay','terr-offence')">
          <xsl:attribute name="id">CL-DE-BT-67</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-67] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:exclusion-ground.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-ORG-NODE/efac:Company[(cac:PartyIdentification/cbc:ID/text() = //efac:TenderingParty/efac:Tenderer/cbc:ID/text()) or (cac:PartyIdentification/cbc:ID/text() = //efac:TenderingParty/efac:Subcontractor/cbc:ID/text())]/efbc:CompanySizeCode" mode="M15" priority="1006">
    <svrl:fired-rule context="$EXTENSION-ORG-NODE/efac:Company[(cac:PartyIdentification/cbc:ID/text() = //efac:TenderingParty/efac:Tenderer/cbc:ID/text()) or (cac:PartyIdentification/cbc:ID/text() = //efac:TenderingParty/efac:Subcontractor/cbc:ID/text())]/efbc:CompanySizeCode" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('large','medium','micro','small')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('large','medium','micro','small')">
          <xsl:attribute name="id">CL-DE-BT-165</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-165] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:economic-operator-size:v1.0.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:TenderingTerms/cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)]/cac:SpecificTendererRequirement[not(cbc:TendererRequirementTypeCode[@listName = 'reserved-procurement'])]/cbc:TendererRequirementTypeCode[@listName = 'missing-info-submission']" mode="M15" priority="1005">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:TenderingTerms/cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)]/cac:SpecificTendererRequirement[not(cbc:TendererRequirementTypeCode[@listName = 'reserved-procurement'])]/cbc:TendererRequirementTypeCode[@listName = 'missing-info-submission']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('late-all','late-some','late-none')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('late-all','late-some','late-none')">
          <xsl:attribute name="id">CL-DE-BT-771</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-771] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:missing-info-submission.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:TenderingProcess/cbc:ProcedureCode" mode="M15" priority="1004">
    <svrl:fired-rule context="$ROOT-NODE/cac:TenderingProcess/cbc:ProcedureCode" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('comp-dial','innovation','neg-w-call','us-neg-w-call','neg-wo-call','us-neg-wo-call','open','us-open','oth-mult','oth-single','us-free-tw','us-free-no-tw','us-hhr','restricted','us-res-tw','us-res-no-tw')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('comp-dial','innovation','neg-w-call','us-neg-w-call','neg-wo-call','us-neg-wo-call','open','us-open','oth-mult','oth-single','us-free-tw','us-free-no-tw','us-hhr','restricted','us-res-tw','us-res-no-tw')">
          <xsl:attribute name="id">CL-DE-BT-105</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-105] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:procurement-procedure-type.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'gpp-criteria']" mode="M15" priority="1003">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'gpp-criteria']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('emas-com','ene-ef-com','iso-14001-com','iso-14024-com','reg-834-2007-com','kosten-lebenszyklus','other')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('emas-com','ene-ef-com','iso-14001-com','iso-14024-com','reg-834-2007-com','kosten-lebenszyklus','other')">
          <xsl:attribute name="id">CL-DE-BT-805</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-805] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:gpp-criteria.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID" mode="M15" priority="1002">
    <svrl:fired-rule context="$ROOT-NODE/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('vsvgv','vob-a-vs','konzvgv','vgv','vob-a-eu','sektvo','other','sgb-vi','vob-a','uvgo','vol-a','sl-other','svhv','CrossBorderLaw')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('vsvgv','vob-a-vs','konzvgv','vgv','vob-a-eu','sektvo','other','sgb-vi','vob-a','uvgo','vol-a','sl-other','svhv','CrossBorderLaw')">
          <xsl:attribute name="id">CL-DE-BT-01</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-01] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:eforms-de-specific-legal-basis.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics/efbc:StatisticsCode" mode="M15" priority="1001">
    <svrl:fired-rule context="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics/efbc:StatisticsCode" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('part-req','t-esubm','t-med','t-micro','t-no-eea','t-no-verif','t-oth-eea','t-small','t-sme','t-verif-inad','t-verif-inad-low','tenders')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('part-req','t-esubm','t-med','t-micro','t-no-eea','t-no-verif','t-oth-eea','t-small','t-sme','t-verif-inad','t-verif-inad-low','tenders')">
          <xsl:attribute name="id">CL-DE-BT-760</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-760] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:received-submission-type:v1.0.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'social-objective']" mode="M15" priority="1000">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'social-objective']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test=". = ('acc-all','et-eq','gen-eq','hum-right','opp','other','iao-core','work-cond')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('acc-all','et-eq','gen-eq','hum-right','opp','other','iao-core','work-cond')">
          <xsl:attribute name="id">CL-DE-BT-775</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CL-DE-BT-775] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:social-objective.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

<!--PATTERN conditional-mandatory-->
<xsl:variable name="SUBTYPES-BT-5071-BT-5141-Lot" select="('E2', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', 'E4', '33', '34', '35', '36', '37', '38', '39', '40')" />
  <xsl:variable name="SUBTYPES-BT-5071-BT-5141-Part" select="('4', '5', '6')" />
  <xsl:variable name="COUNTRIES-WITH-NUTS" select="('BEL', 'BGR', 'CZE', 'DNK', 'DEU', 'EST', 'IRL', 'GRC', 'ESP', 'FRA', 'HRV', 'ITA', 'CYP', 'LVA', 'LTU', 'LUX', 'HUN', 'MLT', 'NLD', 'AUT', 'POL', 'PRT', 'ROU', 'SVN', 'SVK', 'FIN', 'SWE', 'GBR', 'ISL', 'LIE', 'NOR', 'CHE', 'MNE', 'MKD', 'ALB', 'SRB', 'TUR')" />

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType" mode="M16" priority="1011">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="         if (($SUBTYPE = $SUBTYPES-BT-06) and (cbc:ProcurementTypeCode[@listName = 'strategic-procurement']/text() != 'none'))         then           boolean(../cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'environmental-impact'])           or boolean(../cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'social-objective'])           or boolean(../cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'innovative-acquisition'])         else           true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if (($SUBTYPE = $SUBTYPES-BT-06) and (cbc:ProcurementTypeCode[@listName = 'strategic-procurement']/text() != 'none')) then boolean(../cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'environmental-impact']) or boolean(../cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'social-objective']) or boolean(../cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'innovative-acquisition']) else true()">
          <xsl:attribute name="id">BR-DE-20</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-20] If a strategic-procurement value other then 'none' exists, the /cac:ProcurementAdditionalType/cbc:ProcurementTypeCode with corresponding listName must exist.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = ('Lot', 'Part')]/cac:ProcurementProject/cac:RealizedLocation/cac:Address" mode="M16" priority="1010">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = ('Lot', 'Part')]/cac:ProcurementProject/cac:RealizedLocation/cac:Address" />

		<!--ASSERT warning-->
<xsl:choose>
      <xsl:when test="         if ((normalize-space(cac:Country/cbc:IdentificationCode/text()) = $COUNTRIES-WITH-NUTS) and ($SUBTYPE = $SUBTYPES-BT-5071-BT-5141-Lot)) then           boolean(normalize-space(cbc:CountrySubentityCode))         else           true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ((normalize-space(cac:Country/cbc:IdentificationCode/text()) = $COUNTRIES-WITH-NUTS) and ($SUBTYPE = $SUBTYPES-BT-5071-BT-5141-Lot)) then boolean(normalize-space(cbc:CountrySubentityCode)) else true()">
          <xsl:attribute name="id">BR-DE-27-Lot</xsl:attribute>
          <xsl:attribute name="role">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-27-Lot] In Countries where NUTS-Codes exist, cbc:CountrySubentityCode (BT-5071) is mandatory.
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT warning-->
<xsl:choose>
      <xsl:when test="         if ((normalize-space(cac:Country/cbc:IdentificationCode/text()) = $COUNTRIES-WITH-NUTS and ($SUBTYPE = $SUBTYPES-BT-5071-BT-5141-Part))) then           boolean(normalize-space(cbc:CountrySubentityCode))         else           true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ((normalize-space(cac:Country/cbc:IdentificationCode/text()) = $COUNTRIES-WITH-NUTS and ($SUBTYPE = $SUBTYPES-BT-5071-BT-5141-Part))) then boolean(normalize-space(cbc:CountrySubentityCode)) else true()">
          <xsl:attribute name="id">BR-DE-27-Part</xsl:attribute>
          <xsl:attribute name="role">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-27-Part] In Countries where NUTS-Codes exist, cbc:CountrySubentityCode (BT-5071) is mandatory.
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProject/cac:RealizedLocation/cac:Address" mode="M16" priority="1009">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProject/cac:RealizedLocation/cac:Address" />

		<!--ASSERT warning-->
<xsl:choose>
      <xsl:when test="         if (normalize-space(cac:Country/cbc:IdentificationCode/text()) = $COUNTRIES-WITH-NUTS) then           boolean(normalize-space(cbc:CountrySubentityCode))         else           true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if (normalize-space(cac:Country/cbc:IdentificationCode/text()) = $COUNTRIES-WITH-NUTS) then boolean(normalize-space(cbc:CountrySubentityCode)) else true()">
          <xsl:attribute name="id">BR-DE-27-Procedure</xsl:attribute>
          <xsl:attribute name="role">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-27-Procedure] In Countries where NUTS-Codes exist, cbc:CountrySubentityCode (BT-5071) is mandatory.
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="($EXTENSION-ORG-NODE/efac:TouchPoint union $EXTENSION-ORG-NODE/efac:Company)/cac:PostalAddress" mode="M16" priority="1008">
    <svrl:fired-rule context="($EXTENSION-ORG-NODE/efac:TouchPoint union $EXTENSION-ORG-NODE/efac:Company)/cac:PostalAddress" />

		<!--ASSERT warning-->
<xsl:choose>
      <xsl:when test="         if (normalize-space(cac:Country/cbc:IdentificationCode/text()) = $COUNTRIES-WITH-NUTS) then           boolean(normalize-space(cbc:CountrySubentityCode))         else           true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if (normalize-space(cac:Country/cbc:IdentificationCode/text()) = $COUNTRIES-WITH-NUTS) then boolean(normalize-space(cbc:CountrySubentityCode)) else true()">
          <xsl:attribute name="id">BR-DE-28-Company-Touchpoint</xsl:attribute>
          <xsl:attribute name="role">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-28-Company-Touchpoint] In Countries where NUTS-Codes exist, cbc:CountrySubentityCode (BT-507) is mandatory.
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = ('Part', 'Lot', 'LotsGroup')]/cac:ProcurementProject" mode="M16" priority="1007">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = ('Part', 'Lot', 'LotsGroup')]/cac:ProcurementProject" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="                  if (cbc:SMESuitableIndicator/text() = 'true' or cbc:SMESuitableIndicator/text() = '1')         then           (starts-with(cbc:Note[./@languageID = 'DEU']/text()/normalize-space(.), '#Besonders geeignet für:freelance#') or           starts-with(cbc:Note[./@languageID = 'DEU']/text()/normalize-space(.), '#Besonders geeignet für:startup#') or           starts-with(cbc:Note[./@languageID = 'DEU']/text()/normalize-space(.), '#Besonders geeignet für:selbst#')           )         else           true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if (cbc:SMESuitableIndicator/text() = 'true' or cbc:SMESuitableIndicator/text() = '1') then (starts-with(cbc:Note[./@languageID = 'DEU']/text()/normalize-space(.), '#Besonders geeignet für:freelance#') or starts-with(cbc:Note[./@languageID = 'DEU']/text()/normalize-space(.), '#Besonders geeignet für:startup#') or starts-with(cbc:Note[./@languageID = 'DEU']/text()/normalize-space(.), '#Besonders geeignet für:selbst#') ) else true()">
          <xsl:attribute name="id">BR-DE-26</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-26-Part] If SMESuitableIndicator is true or 1, BT-300 /cac:ProcurementProject/cbd:Note needs to start with #Besonders geeignet für:(freelance|startup|selbst)#, free-text can follow.

      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
  <xsl:variable name="LOT-STRATEGIC-PROCURMENT" select="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:TenderingTerms/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:StrategicProcurement" />
  <xsl:variable name="LOT-RESULT" select="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult" />

	<!--RULE BR-DE-24-CM-BT-735-->
<xsl:template match="$LOT-STRATEGIC-PROCURMENT[efbc:ApplicableLegalBasis[@listName = 'cvd-scope']/text() = 'true']" mode="M16" priority="1004">
    <svrl:fired-rule context="$LOT-STRATEGIC-PROCURMENT[efbc:ApplicableLegalBasis[@listName = 'cvd-scope']/text() = 'true']" id="BR-DE-24-CM-BT-735" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(efac:StrategicProcurementInformation/efbc:ProcurementCategoryCode[@listName = 'cvd-contract-type']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(efac:StrategicProcurementInformation/efbc:ProcurementCategoryCode[@listName = 'cvd-contract-type']))">
          <xsl:attribute name="id">BT-735-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BT-735-Lot] BT-735 must exist if BT-717=true</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
  <xsl:variable name="BT-717-MATCH-ID" select="$ROOT-NODE/cac:ProcurementProjectLot[cac:TenderingTerms/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:StrategicProcurement/efbc:ApplicableLegalBasis[@listName = 'cvd-scope']/text() = 'true']/cbc:ID" />

	<!--RULE BR-DE-24-stats-->
<xsl:template match="       $LOT-RESULT[       efac:TenderLot/cbc:ID = $BT-717-MATCH-ID       ]/efac:StrategicProcurement/efac:StrategicProcurementInformation" mode="M16" priority="1002">
    <svrl:fired-rule context="       $LOT-RESULT[       efac:TenderLot/cbc:ID = $BT-717-MATCH-ID       ]/efac:StrategicProcurement/efac:StrategicProcurementInformation" id="BR-DE-24-stats" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(efbc:ProcurementCategoryCode[@listName = 'cvd-contract-type']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(efbc:ProcurementCategoryCode[@listName = 'cvd-contract-type']))">
          <xsl:attribute name="id">BT-735-LotResult</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BT-735-LotResult] BT-735-LotResult must exist if BT-717=true</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="BT-723" select="efac:ProcurementDetails/efbc:AssetCategoryCode[@listName = 'vehicle-category']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="exists($BT-723)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists($BT-723)">
          <xsl:attribute name="id">BR-DE-24-BT-723</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-24-BT-723] Statistics on at least one vehicle-category must exist here and in LotResult.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($BT-723) = count(distinct-values($BT-723))" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($BT-723) = count(distinct-values($BT-723))">
          <xsl:attribute name="id">BR-DE-24-distinct</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-24-distinct] Each vehicle category must be reported only once. But <xsl:text />
            <xsl:value-of select="           for $vcat in distinct-values($BT-723)           return             concat($vcat, ' appears ', count($BT-723[. = $vcat]))" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="       $LOT-RESULT[       efac:TenderLot/cbc:ID = $BT-717-MATCH-ID       ]/efac:StrategicProcurement/efac:StrategicProcurementInformation/efac:ProcurementDetails" mode="M16" priority="1001">
    <svrl:fired-rule context="       $LOT-RESULT[       efac:TenderLot/cbc:ID = $BT-717-MATCH-ID       ]/efac:StrategicProcurement/efac:StrategicProcurementInformation/efac:ProcurementDetails" />
    <xsl:variable name="STATS" select="efac:StrategicProcurementStatistics" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="$STATS[efbc:StatisticsCode[. = 'vehicles']]/efbc:StatisticsNumeric[xs:integer(.) ge 0]" />
      <xsl:otherwise>
        <svrl:failed-assert test="$STATS[efbc:StatisticsCode[. = 'vehicles']]/efbc:StatisticsNumeric[xs:integer(.) ge 0]">
          <xsl:attribute name="id">BR-DE-24-BT-715</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-24-BT-715] Statistics on BT-715: vehicles must exist and values must be &gt;= 0</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="$STATS[efbc:StatisticsCode[. = 'vehicles-zero-emission']]/efbc:StatisticsNumeric[xs:integer(.) ge 0]" />
      <xsl:otherwise>
        <svrl:failed-assert test="$STATS[efbc:StatisticsCode[. = 'vehicles-zero-emission']]/efbc:StatisticsNumeric[xs:integer(.) ge 0]">
          <xsl:attribute name="id">BR-DE-24-BT-725</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-24-BT-725] Statistics on BT-725: vehicles-zero-submission must exist and values must be &gt;= 0</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="$STATS[efbc:StatisticsCode[. = 'vehicles-clean']]/efbc:StatisticsNumeric[xs:integer(.) ge 0]" />
      <xsl:otherwise>
        <svrl:failed-assert test="$STATS[efbc:StatisticsCode[. = 'vehicles-clean']]/efbc:StatisticsNumeric[xs:integer(.) ge 0]">
          <xsl:attribute name="id">BR-DE-24-BT-716</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-24-BT-716] Statistics on BT-725: vehicles-zero-submission must exist and values must be &gt;= 0</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = ('Lot', 'Part')]/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion" mode="M16" priority="1000">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = ('Lot', 'Part')]/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion" />
    <xsl:variable name="AwardCriterionParameter" select="ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="         if         (normalize-space($AwardCriterionParameter/efbc:ParameterCode/text()) = 'per-exa' and         number(normalize-space($AwardCriterionParameter/efbc:ParameterNumeric/text())) ge 10         )         then           (boolean(normalize-space(cbc:AwardingCriterionTypeCode)) and           boolean(normalize-space(cbc:Name[./@languageID = $MAIN-LANG]))           )         else           true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if (normalize-space($AwardCriterionParameter/efbc:ParameterCode/text()) = 'per-exa' and number(normalize-space($AwardCriterionParameter/efbc:ParameterNumeric/text())) ge 10 ) then (boolean(normalize-space(cbc:AwardingCriterionTypeCode)) and boolean(normalize-space(cbc:Name[./@languageID = $MAIN-LANG])) ) else true()">
          <xsl:attribute name="id">BR-DE-23</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-23] When a percentage value (ParameterCode per-exa) in ParameterNumeric has a value &gt;= 10 then cbc:AwardingCriterionTypeCode and cbc:Name with attribute languageID="<xsl:text />
            <xsl:value-of select=" $MAIN-LANG" />
            <xsl:text />" are mandatory.
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

<!--PATTERN doe-validation-pattern-->


	<!--RULE -->
<xsl:template match="$ROOT-NODE" mode="M17" priority="1000">
    <svrl:fired-rule context="$ROOT-NODE" />
    <xsl:variable name="CURRENT-DATE-TIME" select="current-dateTime()" />
    <xsl:variable name="CURRENT-DATE" select="current-date()" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$BT-05-DATE ge $CURRENT-DATE - xs:dayTimeDuration('P1D')" />
      <xsl:otherwise>
        <svrl:failed-assert test="$BT-05-DATE ge $CURRENT-DATE - xs:dayTimeDuration('P1D')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Date of BT-05=<xsl:text />
            <xsl:value-of select="$BT-05-DATE" />
            <xsl:text /> must be less than 1 day in the past. Current date=<xsl:text />
            <xsl:value-of select="$CURRENT-DATE" />
            <xsl:text />. Difference=<xsl:text />
            <xsl:value-of select="$CURRENT-DATE - $BT-05-DATE" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$BT-05-DATE le $CURRENT-DATE + xs:dayTimeDuration('P1D')" />
      <xsl:otherwise>
        <svrl:failed-assert test="$BT-05-DATE le $CURRENT-DATE + xs:dayTimeDuration('P1D')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Date of BT-05=<xsl:text />
            <xsl:value-of select="$BT-05-DATE" />
            <xsl:text /> must be less than 1 day in the future. Current date=<xsl:text />
            <xsl:value-of select="$CURRENT-DATE" />
            <xsl:text />. Difference=<xsl:text />
            <xsl:value-of select="$CURRENT-DATE + xs:dayTimeDuration('P1D')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
  <xsl:param name="EFORMS-DE-MAJOR-MINOR-VERSION" select="'1.1'" />
  <xsl:param name="EFORMS-DE-ID" select="concat('eforms-de-', $EFORMS-DE-MAJOR-MINOR-VERSION)" />
  <xsl:param name="SUBTYPES-ALL" select="('1', '2', '3', '4', '5', '6', 'E2', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', 'E4', '33', '34', '35', '36', '37', '38', '39', '40', 'E5')" />
  <xsl:param name="SUBTYPES-BT-06" select="('7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', 'E4', '33', '34', '35', '36', '37', '38', '39', '40', 'E5')" />
  <xsl:param name="SUBTYPES-BT-760" select="('29', '30', '31', '32', 'E4', '33', '34', '35', '36', '37', 'E5')" />
  <xsl:param name="SUBTYPES-BT-15" select="('10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24')" />
  <xsl:param name="SUBTYPES-BT-708" select="('E1', '1', '2', '3', '4', '5', '6', 'E2', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24')" />
  <xsl:param name="SUBTYPES-BT-97-63-17" select="('7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24')" />
  <xsl:param name="SUBTYPES-BT-769" select="('E1', '7', '8', '9', '10', '11', '12', '13', '14', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24')" />
  <xsl:param name="SUBTYPES-BT-771-772" select="('7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '23', '24')" />
  <xsl:param name="SUBTYPES-BT-726" select="('4', '5', '6', 'E2', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '22')" />
  <xsl:param name="SUBTYPES-BT-17" select="('E1', '10', '11', '15', '16', '17', '23', '24')" />
  <xsl:param name="SUBTYPES-BT-97" select="('E1', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24')" />
  <xsl:param name="SUBTYPES-BT-63" select="('7', '8', '9', '10', '11', '12', '13', '14', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24')" />
  <xsl:param name="SUBTYPES-BT-717" select="('7', '8', '9', '10', '11', '12', '13', '14', '16', '17', '18', '19', 'E3', '20', '21', '22', '29', '30', '31', 'E4', '38', '39', '40')" />
  <xsl:param name="SUBTYPES-BT-105" select="('7', '8', '9', '10', '11', '12', '13', '14', '16', '17', '18', '19', 'E3', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', 'E4', '33', '34', '35', '36', '37')" />
  <xsl:param name="SUBTYPES-BT-165" select="('25', '26', '27', '28', '29', '30', '31', '32', 'E4', '33', '34', '35', '36', '37')" />
  <xsl:param name="ROOT-NODE" select="(/cn:ContractNotice | /pin:PriorInformationNotice | /can:ContractAwardNotice | /brin:BusinessRegistrationInformationNotice)" />
  <xsl:param name="EXTENSION-NODE" select="$ROOT-NODE/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension" />
  <xsl:param name="NOTICE_RESULT" select="$EXTENSION-NODE/efac:NoticeResult" />
  <xsl:param name="SUBTYPE-CODE-NODE" select="$EXTENSION-NODE/efac:NoticeSubType/cbc:SubTypeCode" />
  <xsl:param name="SUBTYPE" select="normalize-space($EXTENSION-NODE/efac:NoticeSubType/cbc:SubTypeCode/text())" />
  <xsl:param name="EXTENSION-ORG-NODE-PARENT" select="$ROOT-NODE/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Organizations" />
  <xsl:param name="EXTENSION-ORG-NODE" select="$EXTENSION-ORG-NODE-PARENT/efac:Organization" />
  <xsl:param name="BT-05-DATE" select="xs:date($ROOT-NODE/cbc:IssueDate)" />
  <xsl:param name="BT-05-TIME" select="xs:time($ROOT-NODE/cbc:IssueTime)" />
  <xsl:param name="MAIN-LANG" select="normalize-space($ROOT-NODE/cbc:NoticeLanguageCode)" />

<!--PATTERN technical-sanity-pattern-->


	<!--RULE -->
<xsl:template match="$ROOT-NODE/cbc:CustomizationID" mode="M45" priority="1002">
    <svrl:fired-rule context="$ROOT-NODE/cbc:CustomizationID" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="text() = $EFORMS-DE-ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="text() = $EFORMS-DE-ID">
          <xsl:attribute name="id">SR-DE-1</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-1 ]The value <xsl:text />
            <xsl:value-of select="." />
            <xsl:text /> of <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must be equal to the current version (<xsl:text />
            <xsl:value-of select="$EFORMS-DE-ID" />
            <xsl:text />) of the eForms-DE Standard. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-NODE" mode="M45" priority="1001">
    <svrl:fired-rule context="$EXTENSION-NODE" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="efac:NoticeSubType/cbc:SubTypeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="efac:NoticeSubType/cbc:SubTypeCode">
          <xsl:attribute name="id">SR-DE-2</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-2] The element efac:NoticeSubType/cbc:SubTypeCode must exist as child of <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$SUBTYPE-CODE-NODE" mode="M45" priority="1000">
    <svrl:fired-rule context="$SUBTYPE-CODE-NODE" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="($SUBTYPE = $SUBTYPES-ALL)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($SUBTYPE = $SUBTYPES-ALL)">
          <xsl:attribute name="id">SR-DE-3</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-3] SubTypeCode <xsl:text />
            <xsl:value-of select="." />
            <xsl:text /> is not valid. It must be a value from this list <xsl:text />
            <xsl:value-of select="$SUBTYPES-ALL" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

<!--PATTERN cardinality-pattern-->


	<!--RULE -->
<xsl:template match="$ROOT-NODE" mode="M46" priority="1027">
    <svrl:fired-rule context="$ROOT-NODE" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cbc:RequestedPublicationDate))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cbc:RequestedPublicationDate))">
          <xsl:attribute name="id">CR-DE-BT-738</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-738] cbc:RequestedPublicationDate must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="cac:TenderingTerms" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TenderingTerms">
          <xsl:attribute name="id">SR-DE-01</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-01] TenderingTerms must exist in all Notice Types</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="exists(cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID)">
          <xsl:attribute name="id">CR-BT-01-Germany</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-BT-01-Germany] cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-105) then             exists(cac:TenderingProcess/cbc:ProcedureCode)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-105) then exists(cac:TenderingProcess/cbc:ProcedureCode) else true()">
          <xsl:attribute name="id">CR-DE-BT-105</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-BT-105] cac:TenderingProcess/cbc:ProcedureCode must exist in subtype=<xsl:text />
            <xsl:value-of select="$SUBTYPE" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cbc:RequestedPublicationDate" mode="M46" priority="1026">
    <svrl:fired-rule context="$ROOT-NODE/cbc:RequestedPublicationDate" />
    <xsl:variable name="DISPATCH-DATE-NODE" select="../cbc:IssueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$DISPATCH-DATE-NODE castable as xs:date" />
      <xsl:otherwise>
        <svrl:failed-assert test="$DISPATCH-DATE-NODE castable as xs:date">
          <xsl:attribute name="id">SR-BT-738-2</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-BT-738-2] ../cbc:IssueDate=<xsl:text />
            <xsl:value-of select="../cbc:IssueDate" />
            <xsl:text /> is not a valid calendar date.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="xs:date(.) ge xs:date($DISPATCH-DATE-NODE)" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:date(.) ge xs:date($DISPATCH-DATE-NODE)">
          <xsl:attribute name="id">SR-BT-738-1</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-26] Calendar date of <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />=<xsl:text />
            <xsl:value-of select="." />
            <xsl:text /> must be greater or equals that of cbc:IssueDate=<xsl:text />
            <xsl:value-of select="$DISPATCH-DATE-NODE" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:date(.) - xs:date($DISPATCH-DATE-NODE) &lt; xs:dayTimeDuration('P60D')" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:date(.) - xs:date($DISPATCH-DATE-NODE) &lt; xs:dayTimeDuration('P60D')">
          <xsl:attribute name="id">SR-BT-738-P60D</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-BT-738-P60D](<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />) must not be more than 60 days after IssueDate due to TED requirements. <xsl:text />
            <xsl:value-of select="concat('Current IssueDate=', xs:date($DISPATCH-DATE-NODE), ' and RequestedPublicationDate=', xs:date(.), ' have a difference of ', days-from-duration(xs:date(.) - xs:date($DISPATCH-DATE-NODE)), ' days.')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-ORG-NODE/efac:Company" mode="M46" priority="1024">
    <svrl:fired-rule context="$EXTENSION-ORG-NODE/efac:Company" />
    <xsl:variable name="PARTY-LEGAL-ENTITY-NODE" select="cac:PartyLegalEntity" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="exists($PARTY-LEGAL-ENTITY-NODE)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists($PARTY-LEGAL-ENTITY-NODE)">
          <xsl:attribute name="id">SR-DE-10</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-10] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> has to have at least one cac:PartyLegalEntity</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cac:Contact/cbc:ElectronicMail))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cac:Contact/cbc:ElectronicMail))">
          <xsl:attribute name="id">CR-DE-BT-506</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-506] Every Buyer (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />) must have a cac:Contact/cbc:ElectronicMail.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="ADDRESS-NODE" select="cac:PostalAddress" />
    <xsl:variable name="CONTACT-NODE" select="cac:Contact" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($ADDRESS-NODE) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($ADDRESS-NODE) = 1">
          <xsl:attribute name="id">SR-DE-4</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-4] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one cac:PostalAddress</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($ADDRESS-NODE/cac:Country) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($ADDRESS-NODE/cac:Country) = 1">
          <xsl:attribute name="id">SR-DE-7</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-7] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one cac:Country</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($CONTACT-NODE) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($CONTACT-NODE) = 1">
          <xsl:attribute name="id">SR-DE-9</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-9] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one cac:Contact</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cac:PartyName/cbc:Name[./@languageID = $MAIN-LANG]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cac:PartyName/cbc:Name[./@languageID = $MAIN-LANG]))">
          <xsl:attribute name="id">CR-DE-BT-500</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-500] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one Name with attribute languageID="<xsl:text />
            <xsl:value-of select=" $MAIN-LANG" />
            <xsl:text />".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space($ADDRESS-NODE/cbc:CityName))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space($ADDRESS-NODE/cbc:CityName))">
          <xsl:attribute name="id">CR-DE-BT-513</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-513] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have a cbc:CityName.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space($ADDRESS-NODE/cbc:PostalZone))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space($ADDRESS-NODE/cbc:PostalZone))">
          <xsl:attribute name="id">CR-DE-BT-512</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-512] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have a PostalZone.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space($ADDRESS-NODE/cac:Country/cbc:IdentificationCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space($ADDRESS-NODE/cac:Country/cbc:IdentificationCode))">
          <xsl:attribute name="id">CR-DE-BT-514</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-514] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have a cac:Country/cbc:IdentificationCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($CONTACT-NODE/cbc:Telefax) le 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($CONTACT-NODE/cbc:Telefax) le 1">
          <xsl:attribute name="id">CR-DE-BT-739</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-739]In every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> cac:Contact/cbc:Telefax may only occure ones.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-ORG-NODE/efac:TouchPoint" mode="M46" priority="1023">
    <svrl:fired-rule context="$EXTENSION-ORG-NODE/efac:TouchPoint" />
    <xsl:variable name="ADDRESS-NODE" select="cac:PostalAddress" />
    <xsl:variable name="CONTACT-NODE" select="cac:Contact" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($ADDRESS-NODE) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($ADDRESS-NODE) = 1">
          <xsl:attribute name="id">SR-DE-4</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-4] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one cac:PostalAddress</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($ADDRESS-NODE/cac:Country) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($ADDRESS-NODE/cac:Country) = 1">
          <xsl:attribute name="id">SR-DE-7</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-7] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one cac:Country</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($CONTACT-NODE) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($CONTACT-NODE) = 1">
          <xsl:attribute name="id">SR-DE-9</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-9] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one cac:Contact</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cac:PartyName/cbc:Name[./@languageID = $MAIN-LANG]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cac:PartyName/cbc:Name[./@languageID = $MAIN-LANG]))">
          <xsl:attribute name="id">CR-DE-BT-500</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-500] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one Name with attribute languageID="<xsl:text />
            <xsl:value-of select=" $MAIN-LANG" />
            <xsl:text />".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space($ADDRESS-NODE/cbc:CityName))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space($ADDRESS-NODE/cbc:CityName))">
          <xsl:attribute name="id">CR-DE-BT-513</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-513] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have a cbc:CityName.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space($ADDRESS-NODE/cbc:PostalZone))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space($ADDRESS-NODE/cbc:PostalZone))">
          <xsl:attribute name="id">CR-DE-BT-512</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-512] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have a PostalZone.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space($ADDRESS-NODE/cac:Country/cbc:IdentificationCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space($ADDRESS-NODE/cac:Country/cbc:IdentificationCode))">
          <xsl:attribute name="id">CR-DE-BT-514</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-514] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have a cac:Country/cbc:IdentificationCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count($CONTACT-NODE/cbc:Telefax) le 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($CONTACT-NODE/cbc:Telefax) le 1">
          <xsl:attribute name="id">CR-DE-BT-739</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-739]In every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> cac:Contact/cbc:Telefax may only occure ones.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-ORG-NODE/efac:Company/cac:PartyLegalEntity" mode="M46" priority="1022">
    <svrl:fired-rule context="$EXTENSION-ORG-NODE/efac:Company/cac:PartyLegalEntity" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cbc:CompanyID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cbc:CompanyID))">
          <xsl:attribute name="id">CR-DE-BT-501</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-501] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have a cbc:CompanyID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="($EXTENSION-ORG-NODE/efac:TouchPoint union $EXTENSION-ORG-NODE/efac:Company)/cbc:EndpointID" mode="M46" priority="1021">
    <svrl:fired-rule context="($EXTENSION-ORG-NODE/efac:TouchPoint union $EXTENSION-ORG-NODE/efac:Company)/cbc:EndpointID" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">CR-DE-BT-509</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-509] cbc:EndpointID is forbidden in Company and Touchpoint.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-ORG-NODE/efac:Company[cac:PartyIdentification/cbc:ID = (//efac:TenderingParty/efac:Tenderer/cbc:ID, //efac:TenderingParty/efac:Subcontractor/cbc:ID)]/cac:PartyIdentification" mode="M46" priority="1020">
    <svrl:fired-rule context="$EXTENSION-ORG-NODE/efac:Company[cac:PartyIdentification/cbc:ID = (//efac:TenderingParty/efac:Tenderer/cbc:ID, //efac:TenderingParty/efac:Subcontractor/cbc:ID)]/cac:PartyIdentification" role="error" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="not($SUBTYPE = $SUBTYPES-BT-165) or ../efbc:CompanySizeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($SUBTYPE = $SUBTYPES-BT-165) or ../efbc:CompanySizeCode">
          <xsl:attribute name="id">CR-DE-BT-165</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-165](<xsl:text />
            <xsl:value-of select="$SUBTYPE" />
            <xsl:text />) If this company (<xsl:text />
            <xsl:value-of select="cbc:ID" />
            <xsl:text />) is a winner, BT-165 (Winner Size) must exist in subtype <xsl:text />
            <xsl:value-of select="$SUBTYPES-BT-165" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$NOTICE_RESULT/efac:SettledContract" mode="M46" priority="1019">
    <svrl:fired-rule context="$NOTICE_RESULT/efac:SettledContract" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count(cbc:URI) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:URI) = 0">
          <xsl:attribute name="id">CR-DE-BT-151-Contract</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-151-Contract] cbc:URI forbidden in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult" mode="M46" priority="1018">
    <svrl:fired-rule context="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-760) then             (count(efac:ReceivedSubmissionsStatistics) >= 1)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-760) then (count(efac:ReceivedSubmissionsStatistics) >= 1) else true()">
          <xsl:attribute name="id">SR-DE-22</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-DE-22] efac:ReceivedSubmissionsStatistics must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> at least once</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics" mode="M46" priority="1017">
    <svrl:fired-rule context="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-760) then             boolean(normalize-space(efbc:StatisticsCode))           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-760) then boolean(normalize-space(efbc:StatisticsCode)) else true()">
          <xsl:attribute name="id">CR-DE-BT-760-LotResult</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-760-LotResult] efbc:StatisticsCode must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProject" mode="M46" priority="1016">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProject" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="exists(cac:RealizedLocation)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:RealizedLocation)">
          <xsl:attribute name="id">SR-DE-14</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-14] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have cac:RealizedLocation</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cbc:ProcurementTypeCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cbc:ProcurementTypeCode))">
          <xsl:attribute name="id">CR-DE-BT-23</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-23] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have  cbc:ProcurementTypeCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space((cbc:Name[./@languageID = $MAIN-LANG])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space((cbc:Name[./@languageID = $MAIN-LANG])))">
          <xsl:attribute name="id">CR-DE-BT-21</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-21] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have one cbc:Name with attribute languageID="<xsl:text />
            <xsl:value-of select=" $MAIN-LANG" />
            <xsl:text />" .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProject/cac:RealizedLocation" mode="M46" priority="1015">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProject/cac:RealizedLocation" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="exists(cac:Address)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Address)">
          <xsl:attribute name="id">SR-DE-11</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-11] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have cac:Address</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="exists(cac:Address/cac:Country)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Address/cac:Country)">
          <xsl:attribute name="id">SR-DE-11-a</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-14] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> must have cac:Country</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject" mode="M46" priority="1014">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cbc:ProcurementTypeCode[@listName = 'contract-nature']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cbc:ProcurementTypeCode[@listName = 'contract-nature']))">
          <xsl:attribute name="id">CR-DE-BT-23-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-23-Lot] cbc:ProcurementTypeCode must exist as child of <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space((cbc:Name[./@languageID = $MAIN-LANG])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space((cbc:Name[./@languageID = $MAIN-LANG])))">
          <xsl:attribute name="id">CR-DE-BT-21-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-21-Lot] One cbc:Name with attribute languageID="<xsl:text />
            <xsl:value-of select=" $MAIN-LANG" />
            <xsl:text />" must exist as child of <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-06) then             (count(cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'strategic-procurement']) ge 1)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-06) then (count(cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'strategic-procurement']) ge 1) else true()">
          <xsl:attribute name="id">BR-DE-21-A</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-21-A] The 'cac:ProcurementAdditionalType/cbc:ProcurementTypeCode' with listName = 'strategic-procurement' must exist at least once under cac:ProcurementProject.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-06) then             (count(cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'strategic-procurement']) le 3)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-06) then (count(cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'strategic-procurement']) le 3) else true()">
          <xsl:attribute name="id">BR-DE-21-B</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-21-B] The 'cac:ProcurementAdditionalType/cbc:ProcurementTypeCode' with listName = 'strategic-procurement' is allowed at most 3 times under cac:ProcurementProject.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-06) then             (count(cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'strategic-procurement']) = count(distinct-values(cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'strategic-procurement'])))           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-06) then (count(cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'strategic-procurement']) = count(distinct-values(cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'strategic-procurement']))) else true()">
          <xsl:attribute name="id">BR-DE-22</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DE-22] Each code in 'cac:ProcurementAdditionalType/cbc:ProcurementTypeCode' with listName = 'strategic-procurement' is only allowed once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Part']/cac:ProcurementProject" mode="M46" priority="1013">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Part']/cac:ProcurementProject" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cbc:ProcurementTypeCode[@listName = 'contract-nature']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cbc:ProcurementTypeCode[@listName = 'contract-nature']))">
          <xsl:attribute name="id">CR-DE-BT-23-Part</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-23-Part] cbc:ProcurementTypeCode must exist as child of <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cbc:Name[./@languageID = $MAIN-LANG]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cbc:Name[./@languageID = $MAIN-LANG]))">
          <xsl:attribute name="id">CR-DE-BT-21-Part</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-23-Part] One cbc:Name with attribute languageID="<xsl:text />
            <xsl:value-of select=" $MAIN-LANG" />
            <xsl:text />" must exist as child of <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot' or cbc:ID/@schemeName = 'Part']/cac:ProcurementProject/cac:RealizedLocation/cac:Address" mode="M46" priority="1012">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot' or cbc:ID/@schemeName = 'Part']/cac:ProcurementProject/cac:RealizedLocation/cac:Address" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="count(cac:Country) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Country) = 1">
          <xsl:attribute name="id">SR-DE-15</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-15] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> has to have cac:Country</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cac:Country/cbc:IdentificationCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cac:Country/cbc:IdentificationCode))">
          <xsl:attribute name="id">CR-DE-BT-5141</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-5141] cbc:IdentificationCode must exist.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-NODE/efac:NoticeResult/efac:GroupFramework/efbc:GroupFrameworkMaximumValueAmount" mode="M46" priority="1011">
    <svrl:fired-rule context="$EXTENSION-NODE/efac:NoticeResult/efac:GroupFramework/efbc:GroupFrameworkMaximumValueAmount" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">CR-DE-BT-156-NoticeResult</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-156-NoticeResult] efbc:GroupFrameworkMaximumValueAmount forbidden.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'LotsGroup']/cac:TenderingProcess/cac:FrameworkAgreement/cbc:EstimatedMaximumValueAmount" mode="M46" priority="1010">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'LotsGroup']/cac:TenderingProcess/cac:FrameworkAgreement/cbc:EstimatedMaximumValueAmount" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">CR-DE-BT-157</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-157] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> is forbidden.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:TenderingTerms" mode="M46" priority="1009">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:TenderingTerms" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-771-772) then             (count(cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)]/cac:SpecificTendererRequirement[(cbc:TendererRequirementTypeCode[@listName = 'missing-info-submission'])]) = 1)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-771-772) then (count(cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)]/cac:SpecificTendererRequirement[(cbc:TendererRequirementTypeCode[@listName = 'missing-info-submission'])]) = 1) else true()">
          <xsl:attribute name="id">CR-DE-BT-771-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-771-Lot] Exactly one cac:TendererQualificationRequest has to exist with /cac:SpecificTendererRequirement/cbc:TendererRequirementTypeCode listname 'missing-info-submission'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-771-772) then             (count(cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)]/cac:SpecificTendererRequirement[(cbc:TendererRequirementTypeCode[@listName = 'missing-info-submission'])]/cbc:Description[./@languageID = $MAIN-LANG]) = 1)                      else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-771-772) then (count(cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)]/cac:SpecificTendererRequirement[(cbc:TendererRequirementTypeCode[@listName = 'missing-info-submission'])]/cbc:Description[./@languageID = $MAIN-LANG]) = 1) else true()">
          <xsl:attribute name="id">CR-DE-BT-772-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-772-Lot] cbc:Description with attribute languageID="<xsl:text />
            <xsl:value-of select=" $MAIN-LANG" />
            <xsl:text />" for BT-772 must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-771-772) then             (count(cac:TendererQualificationRequest) >= 1)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-771-772) then (count(cac:TendererQualificationRequest) >= 1) else true()">
          <xsl:attribute name="id">SR-DE-21</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-21] Every <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> has to have at least one cac:TendererQualificationRequest</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-97) then             exists(cac:Language/cbc:ID)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-97) then exists(cac:Language/cbc:ID) else true()">
          <xsl:attribute name="id">CR-DE-BT-97-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-97-Lot] /cac:Language/cbc:ID must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> for subtypes <xsl:text />
            <xsl:value-of select="$SUBTYPES-BT-97" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-15) then             (count(cac:CallForTendersDocumentReference) >= 1)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-15) then (count(cac:CallForTendersDocumentReference) >= 1) else true()">
          <xsl:attribute name="id">SR-DE-23</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SR-DE-23] cac:CallForTendersDocumentReference must exist at least once in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:TenderingTerms/cac:CallForTendersDocumentReference" mode="M46" priority="1008">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:TenderingTerms/cac:CallForTendersDocumentReference" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-708) then             (count(cbc:LanguageID) ge 1)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-708) then (count(cbc:LanguageID) ge 1) else true()">
          <xsl:attribute name="id">CR-DE-BT-708-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-708-Lot] cbc:LanguageID must exist.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-15) then             if (cbc:DocumentType/text() = 'non-restricted-document') then               (count(cac:Attachment/cac:ExternalReference/cbc:URI) ge 1)             else               true()           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-15) then if (cbc:DocumentType/text() = 'non-restricted-document') then (count(cac:Attachment/cac:ExternalReference/cbc:URI) ge 1) else true() else true()">
          <xsl:attribute name="id">CR-DE-BT-15-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-15-Lot] /cac:Attachment/cac:ExternalReference/cbc:URI must exist in cac:CallForTendersDocumentReference for DocumentType non-restricted-document.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Part']/cac:TenderingTerms/cac:CallForTendersDocumentReference" mode="M46" priority="1007">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Part']/cac:TenderingTerms/cac:CallForTendersDocumentReference" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-708) then             (count(cbc:LanguageID) ge 1)           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-708) then (count(cbc:LanguageID) ge 1) else true()">
          <xsl:attribute name="id">CR-DE-BT-708-Part</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-708-Part] cbc:LanguageID must exist.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-15) then             if (cbc:DocumentType/text() = 'non-restricted-document') then               (count(cac:Attachment/cac:ExternalReference/cbc:URI) ge 1)             else               true()           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-15) then if (cbc:DocumentType/text() = 'non-restricted-document') then (count(cac:Attachment/cac:ExternalReference/cbc:URI) ge 1) else true() else true()">
          <xsl:attribute name="id">CR-DE-BT-15-Part</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-15-Part] /cac:Attachment/cac:ExternalReference/cbc:URI must exist in cac:CallForTendersDocumentReference for DocumentType non-restricted-document.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Part']" mode="M46" priority="1006">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Part']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE-CODE-NODE = $SUBTYPES-BT-726) then             (boolean(normalize-space(cac:ProcurementProject/cbc:SMESuitableIndicator)))           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE-CODE-NODE = $SUBTYPES-BT-726) then (boolean(normalize-space(cac:ProcurementProject/cbc:SMESuitableIndicator))) else true()">
          <xsl:attribute name="id">CR-DE-BT-726-Part</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-726-Part] cbc:SMESuitableIndicator must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'LotsGroup']" mode="M46" priority="1005">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'LotsGroup']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="boolean(normalize-space(cac:ProcurementProject/cbc:Name[./@languageID = $MAIN-LANG]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(normalize-space(cac:ProcurementProject/cbc:Name[./@languageID = $MAIN-LANG]))">
          <xsl:attribute name="id">CR-DE-BT-21-LotsGroup</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-21-LotsGroup] One /cac:ProcurementProject/cbc:Name with attribute languageID="<xsl:text />
            <xsl:value-of select=" $MAIN-LANG" />
            <xsl:text />" must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE-CODE-NODE = $SUBTYPES-BT-726) then             (boolean(normalize-space(cac:ProcurementProject/cbc:SMESuitableIndicator)))           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE-CODE-NODE = $SUBTYPES-BT-726) then (boolean(normalize-space(cac:ProcurementProject/cbc:SMESuitableIndicator))) else true()">
          <xsl:attribute name="id">CR-DE-BT-726-LotsGroup</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-726-LotsGroup] cbc:SMESuitableIndicator must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']" mode="M46" priority="1004">
    <svrl:fired-rule context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-63) then             boolean(normalize-space(cac:TenderingTerms/cbc:VariantConstraintCode))           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-63) then boolean(normalize-space(cac:TenderingTerms/cbc:VariantConstraintCode)) else true()">
          <xsl:attribute name="id">CR-DE-BT-63-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-63-Lot](<xsl:text />
            <xsl:value-of select="$SUBTYPE" />
            <xsl:text />) /cac:TenderingTerms/cbc:VariantConstraintCode must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> in subtypes <xsl:text />
            <xsl:value-of select="$SUBTYPES-BT-63" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-17) then             boolean(normalize-space(cac:TenderingProcess/cbc:SubmissionMethodCode[@listName = 'esubmission']))           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-17) then boolean(normalize-space(cac:TenderingProcess/cbc:SubmissionMethodCode[@listName = 'esubmission'])) else true()">
          <xsl:attribute name="id">CR-DE-BT-17-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-17-Lot](<xsl:text />
            <xsl:value-of select="$SUBTYPE" />
            <xsl:text />) /cac:TenderingProcess/cbc:SubmissionMethodCode must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> in subtypes <xsl:text />
            <xsl:value-of select="$SUBTYPES-BT-17" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-717) then             exists(cac:TenderingTerms/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:StrategicProcurement/efbc:ApplicableLegalBasis[@listName = 'cvd-scope'])           else             true()           " />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-717) then exists(cac:TenderingTerms/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:StrategicProcurement/efbc:ApplicableLegalBasis[@listName = 'cvd-scope']) else true()">
          <xsl:attribute name="id">CR-DE-BT-717-Lot</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-717-Lot] (<xsl:text />
            <xsl:value-of select="$SUBTYPE" />
            <xsl:text />) efbc:ApplicableLegalBasis must exist in subtypes <xsl:text />
            <xsl:value-of select="$SUBTYPES-BT-717" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE = $SUBTYPES-BT-769) then             boolean(normalize-space(cac:TenderingTerms/cbc:MultipleTendersCode))           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE = $SUBTYPES-BT-769) then boolean(normalize-space(cac:TenderingTerms/cbc:MultipleTendersCode)) else true()">
          <xsl:attribute name="id">CR-DE-BT-769-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-769-Lot] (<xsl:text />
            <xsl:value-of select="$SUBTYPE" />
            <xsl:text />) /cac:TenderingTerms/cbc:MultipleTendrersCode must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> in subtypes <xsl:text />
            <xsl:value-of select="$SUBTYPES-BT-769" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="           if ($SUBTYPE-CODE-NODE = $SUBTYPES-BT-726) then             (boolean(normalize-space(cac:ProcurementProject/cbc:SMESuitableIndicator)))           else             true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($SUBTYPE-CODE-NODE = $SUBTYPES-BT-726) then (boolean(normalize-space(cac:ProcurementProject/cbc:SMESuitableIndicator))) else true()">
          <xsl:attribute name="id">CR-DE-BT-726-Lot</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-726-Lot] cbc:SMESuitableIndicator must exist in <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$NOTICE_RESULT/efac:LotTender/efac:Origin/efbc:AreaCode" mode="M46" priority="1003">
    <svrl:fired-rule context="$NOTICE_RESULT/efac:LotTender/efac:Origin/efbc:AreaCode" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">CR-DE-BT-191</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-191] efbc:AreaCode is forbidden .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:TenderingTerms/cac:LotDistribution/cac:LotsGroup/cbc:LotsGroupID" mode="M46" priority="1002">
    <svrl:fired-rule context="$ROOT-NODE/cac:TenderingTerms/cac:LotDistribution/cac:LotsGroup/cbc:LotsGroupID" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">CR-DE-BT-330-Procedure</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-330-Procedure] cbc:LotsGroupID is forbidden .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$ROOT-NODE/cac:TenderingTerms/cac:LotDistribution/cac:LotsGroup/cac:ProcurementProjectLotReference/cbc:ID[@schemeName = 'Lot']" mode="M46" priority="1001">
    <svrl:fired-rule context="$ROOT-NODE/cac:TenderingTerms/cac:LotDistribution/cac:LotsGroup/cac:ProcurementProjectLotReference/cbc:ID[@schemeName = 'Lot']" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">CR-DE-BT-1375-Procedure</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-1375-Procedure] cbc:ID is forbidden .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="$EXTENSION-NODE/efac:NoticeResult/efac:GroupFramework/efac:TenderLot/cbc:ID" mode="M46" priority="1000">
    <svrl:fired-rule context="$EXTENSION-NODE/efac:NoticeResult/efac:GroupFramework/efac:TenderLot/cbc:ID" />

		<!--ASSERT error-->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">CR-DE-BT-556-NoticeResult</xsl:attribute>
          <xsl:attribute name="role">error</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[CR-DE-BT-556-NoticeResult] cbc:ID is forbidden.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
