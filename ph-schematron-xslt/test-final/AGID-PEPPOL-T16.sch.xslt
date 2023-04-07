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
<function as="xs:boolean" name="u:gln">
      <param name="val" />
      <variable name="length" select="string-length($val) - 1" />
      <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
      <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))" />
      <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))" />
   </function>
  <function as="xs:boolean" name="u:mod11">
      <param name="val" />
      <variable name="length" select="string-length($val) - 1" />
      <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
      <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))" />
      <value-of select="number($val) > 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))" />
   </function>

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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" schemaVersion="iso" title="Rules for the transaction of the PEPPOL Despatch Advice, version 3.1">
      <comment>
        <value-of select="$archiveDirParameter" />   
		 <value-of select="$archiveNameParameter" />  
		 <value-of select="$fileNameParameter" />  
		 <value-of select="$fileDirParameter" />
      </comment>
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" />
      <ns0:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <ns0:ns-prefix-in-attribute-values prefix="u" uri="utils" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M8" select="/" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M9" select="/" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M10" select="/" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M11" select="/" />
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <attribute name="id">IT-UBL-T16</attribute>
        <attribute name="name">IT-UBL-T16</attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M12" select="/" />
    </ns0:schematron-output>
  </template>

<!--SCHEMATRON PATTERNS-->
<ns0:text xmlns:ns0="http://purl.oclc.org/dsdl/svrl">Rules for the transaction of the PEPPOL Despatch Advice, version 3.1</ns0:text>

<!--PATTERN -->


	<!--RULE -->
<template match="//*[not(*) and not(normalize-space())]" mode="M8" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//*[not(*) and not(normalize-space())]" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-COMMON-R001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST not contain empty elements.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M8" select="@*|*" />
  </template>
  <template match="text()" mode="M8" priority="-1" />
  <template match="@*|node()" mode="M8" priority="-2">
    <apply-templates mode="M8" select="@*|*" />
  </template>

<!--PATTERN -->


	<!--RULE -->
<template match="/*" mode="M9" priority="1003">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/*" />

		<!--ASSERT -->
<choose>
      <when test="not(@*:schemaLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@*:schemaLocation)">
          <attribute name="id">PEPPOL-COMMON-R003</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document SHOULD not contain schema location.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M9" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" mode="M9" priority="1002">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" />

		<!--ASSERT -->
<choose>
      <when test="(string(.) castable as xs:date) and (string-length(.) = 10)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(string(.) castable as xs:date) and (string-length(.) = 10)">
          <attribute name="id">PEPPOL-COMMON-R030</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>A date must be formatted YYYY-MM-DD.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M9" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" mode="M9" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" />

		<!--ASSERT -->
<choose>
      <when test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())">
          <attribute name="id">PEPPOL-COMMON-R040</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>GLN must have a valid format according to GS1 rules.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M9" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" mode="M9" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" />

		<!--ASSERT -->
<choose>
      <when test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())">
          <attribute name="id">PEPPOL-COMMON-R041</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Norwegian organization number MUST be stated in the correct format.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M9" select="@*|*" />
  </template>
  <template match="text()" mode="M9" priority="-1" />
  <template match="@*|node()" mode="M9" priority="-2">
    <apply-templates mode="M9" select="@*|*" />
  </template>

<!--PATTERN -->
<variable name="cleas" select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9956 9957', '\s')" />
  <variable name="clUNECERec21" select="tokenize('1A 1B 1D 1F 1G 1W 2C 3A 3H 43 44 4A 4B 4C 4D 4F 4G 4H 5H 5L 5M 6H 6P 7A 7B 8A 8B 8C AA AB AC AD AE AF AG AH AI AJ AL AM AP AT AV B4 BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ CK CL CM CN CO CP CQ CR CS CT CU CV CW CX CY CZ DA DB DC DG DH DI DJ DK DL DM DN DP DR DS DT DU DV DW DX DY EC ED EE EF EG EH EI EN FB FC FD FE FI FL FO FP FR FT FW FX GB GI GL GR GU GY GZ HA HB HC HG HN HR IA IB IC ID IE IF IG IH IK IL IN IZ JB JC JG JR JT JY KG KI LE LG LT LU LV LZ MA MB MC ME MR MS MT MW MX NA NE NF NG NS NT NU NV OA OB OC OD OE OF OK OT OU P2 PA PB PC PD PE PF PG PH PI PJ PK PL PN PO PP PR PT PU PV PX PY PZ QA QB QC QD QF QG QH QJ QK QL QM QN QP QQ QR QS RD RG RJ RK RL RO RT RZ SA SB SC SD SE SH SI SK SL SM SO SP SS ST SU SV SW SY SZ T1 TB TC TD TE TG TI TK TL TN TO TR TS TT TU TV TW TY TZ UC UN VA VG VI VK VL VO VP VQ VN VR VS VY WA WB WC WD WF WG WH WJ WK WL WM WN WP WQ WR WS WT WU WV WW WX WY WZ XA XB XC XD XF XG XH XJ XK YA YB YC YD YF YG YH YJ YK YL YM YN YP YQ YR YS YT YV YW YX YY YZ ZA ZB ZC ZD ZF ZG ZH ZJ ZK ZL ZM ZN ZP ZQ ZR ZS ZT ZU ZV ZW ZX ZY ZZ ', '\s')" />
  <variable name="clUNCL6313-T16" select="tokenize('AAB AAW', '\s')" />
  <variable name="clUNCL8273" select="tokenize('ADR ADS ADT ADU ADV ADW ADX AGS ANR ARD CFR COM GVE GVS ICA IMD RGE RID UI ZZZ', '\s')" />
  <variable name="clUNECERec20" select="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMQ HMT HPA HTZ HUR IA IE INH INK INQ ISD IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MLD MLT MMK MMQ MMT MND MON MPA MQH MQS MSK MTK MTQ MTR MTS MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NU NX OA ODE OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q3 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XOA XOB XOC XOD XOE XOF XOK XOT XOU XP2 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVO XVP XVQ XVN XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY', '\s')" />
  <variable name="clISO3166" select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A', '\s')" />
  <variable name="clICD" select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209', '\s')" />

	<!--RULE -->
<template match="/ubl:DespatchAdvice" mode="M10" priority="1273">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice" />

		<!--ASSERT -->
<choose>
      <when test="cbc:CustomizationID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:CustomizationID">
          <attribute name="id">PEPPOL-T16-B00101</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:CustomizationID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cbc:ProfileID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ProfileID">
          <attribute name="id">PEPPOL-T16-B00102</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ProfileID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B00103</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cbc:IssueDate" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:IssueDate">
          <attribute name="id">PEPPOL-T16-B00104</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:IssueDate' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:DespatchSupplierParty" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:DespatchSupplierParty">
          <attribute name="id">PEPPOL-T16-B00105</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:DespatchSupplierParty' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:DeliveryCustomerParty" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:DeliveryCustomerParty">
          <attribute name="id">PEPPOL-T16-B00106</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:DeliveryCustomerParty' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:DespatchLine" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:DespatchLine">
          <attribute name="id">PEPPOL-T16-B00107</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:DespatchLine' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@*:schemaLocation)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@*:schemaLocation)">
          <attribute name="id">PEPPOL-T16-B00108</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST not contain schema location.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cbc:CustomizationID" mode="M10" priority="1272">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:CustomizationID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cbc:ProfileID" mode="M10" priority="1271">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:ProfileID" />

		<!--ASSERT -->
<choose>
      <when test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:despatch_advice:3'" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:despatch_advice:3'">
          <attribute name="id">PEPPOL-T16-B00301</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:poacc:bis:despatch_advice:3'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cbc:ID" mode="M10" priority="1270">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cbc:IssueDate" mode="M10" priority="1269">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:IssueDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cbc:IssueTime" mode="M10" priority="1268">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:IssueTime" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cbc:Note" mode="M10" priority="1267">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:Note" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OrderReference" mode="M10" priority="1266">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OrderReference" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B00801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OrderReference/cbc:ID" mode="M10" priority="1265">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OrderReference/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OrderReference/cbc:CustomerReference" mode="M10" priority="1264">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OrderReference/cbc:CustomerReference" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OrderReference/*" mode="M10" priority="1263">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OrderReference/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B00802</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:AdditionalDocumentReference" mode="M10" priority="1262">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:AdditionalDocumentReference" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:ID" mode="M10" priority="1261">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:IssueDate" mode="M10" priority="1260">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:IssueDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:DocumentType" mode="M10" priority="1259">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:DocumentType" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty" mode="M10" priority="1258">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty" />

		<!--ASSERT -->
<choose>
      <when test="cac:Party" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
          <attribute name="id">PEPPOL-T16-B01001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Party' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party" mode="M10" priority="1257">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party" />

		<!--ASSERT -->
<choose>
      <when test="cbc:EndpointID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
          <attribute name="id">PEPPOL-T16-B01101</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:EndpointID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:PartyLegalEntity" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:PartyLegalEntity">
          <attribute name="id">PEPPOL-T16-B01102</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:PartyLegalEntity' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cbc:EndpointID" mode="M10" priority="1256">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<choose>
      <when test="@schemeID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
          <attribute name="id">PEPPOL-T16-B01201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'schemeID' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
          <attribute name="id">PEPPOL-T16-B01202</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification" mode="M10" priority="1255">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B01401</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M10" priority="1254">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <attribute name="id">PEPPOL-T16-B01501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'ISO 6523 ICD list'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress" mode="M10" priority="1253">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<choose>
      <when test="cac:Country" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
          <attribute name="id">PEPPOL-T16-B01701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Country' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M10" priority="1252">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M10" priority="1251">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M10" priority="1250">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M10" priority="1249">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M10" priority="1248">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M10" priority="1247">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M10" priority="1246">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country" mode="M10" priority="1245">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<choose>
      <when test="cbc:IdentificationCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
          <attribute name="id">PEPPOL-T16-B02501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:IdentificationCode' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M10" priority="1244">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B02601</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M10" priority="1243">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B02502</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/*" mode="M10" priority="1242">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B01702</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity" mode="M10" priority="1241">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<choose>
      <when test="cbc:RegistrationName" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:RegistrationName">
          <attribute name="id">PEPPOL-T16-B02701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:RegistrationName' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M10" priority="1240">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/*" mode="M10" priority="1239">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B02702</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact" mode="M10" priority="1238">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Name" mode="M10" priority="1237">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Name" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Telephone" mode="M10" priority="1236">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Telephone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M10" priority="1235">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/*" mode="M10" priority="1234">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B02901</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/*" mode="M10" priority="1233">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B01103</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/*" mode="M10" priority="1232">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B01002</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty" mode="M10" priority="1231">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty" />

		<!--ASSERT -->
<choose>
      <when test="cac:Party" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
          <attribute name="id">PEPPOL-T16-B03301</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Party' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party" mode="M10" priority="1230">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party" />

		<!--ASSERT -->
<choose>
      <when test="cbc:EndpointID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
          <attribute name="id">PEPPOL-T16-B03401</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:EndpointID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:PartyLegalEntity" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:PartyLegalEntity">
          <attribute name="id">PEPPOL-T16-B03402</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:PartyLegalEntity' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cbc:EndpointID" mode="M10" priority="1229">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<choose>
      <when test="@schemeID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
          <attribute name="id">PEPPOL-T16-B03501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'schemeID' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
          <attribute name="id">PEPPOL-T16-B03502</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification" mode="M10" priority="1228">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B03701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M10" priority="1227">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <attribute name="id">PEPPOL-T16-B03801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'ISO 6523 ICD list'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress" mode="M10" priority="1226">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<choose>
      <when test="cac:Country" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
          <attribute name="id">PEPPOL-T16-B04001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Country' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M10" priority="1225">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M10" priority="1224">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M10" priority="1223">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M10" priority="1222">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M10" priority="1221">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M10" priority="1220">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M10" priority="1219">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M10" priority="1218">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<choose>
      <when test="cbc:IdentificationCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
          <attribute name="id">PEPPOL-T16-B04801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:IdentificationCode' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M10" priority="1217">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B04901</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M10" priority="1216">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B04802</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/*" mode="M10" priority="1215">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B04002</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity" mode="M10" priority="1214">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<choose>
      <when test="cbc:RegistrationName" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:RegistrationName">
          <attribute name="id">PEPPOL-T16-B05001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:RegistrationName' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M10" priority="1213">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/*" mode="M10" priority="1212">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B05002</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/*" mode="M10" priority="1211">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B03403</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact" mode="M10" priority="1210">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Name" mode="M10" priority="1209">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Name" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Telephone" mode="M10" priority="1208">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Telephone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:ElectronicMail" mode="M10" priority="1207">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:ElectronicMail" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/*" mode="M10" priority="1206">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B05201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/*" mode="M10" priority="1205">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B03302</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty" mode="M10" priority="1204">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty" />

		<!--ASSERT -->
<choose>
      <when test="cac:Party" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
          <attribute name="id">PEPPOL-T16-B05601</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Party' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party" mode="M10" priority="1203">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" mode="M10" priority="1202">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B05801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M10" priority="1201">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <attribute name="id">PEPPOL-T16-B05901</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'ISO 6523 ICD list'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName" mode="M10" priority="1200">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<choose>
      <when test="cbc:Name" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
          <attribute name="id">PEPPOL-T16-B06101</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:Name' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M10" priority="1199">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress" mode="M10" priority="1198">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<choose>
      <when test="cac:Country" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
          <attribute name="id">PEPPOL-T16-B06301</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Country' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M10" priority="1197">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M10" priority="1196">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M10" priority="1195">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M10" priority="1194">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M10" priority="1193">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M10" priority="1192">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M10" priority="1191">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M10" priority="1190">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<choose>
      <when test="cbc:IdentificationCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
          <attribute name="id">PEPPOL-T16-B07101</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:IdentificationCode' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M10" priority="1189">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B07201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M10" priority="1188">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B07102</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*" mode="M10" priority="1187">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B06302</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/*" mode="M10" priority="1186">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B05701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/*" mode="M10" priority="1185">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B05602</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty" mode="M10" priority="1184">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty" />

		<!--ASSERT -->
<choose>
      <when test="cac:Party" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
          <attribute name="id">PEPPOL-T16-B07301</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Party' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party" mode="M10" priority="1183">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" mode="M10" priority="1182">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B07501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M10" priority="1181">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <attribute name="id">PEPPOL-T16-B07601</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'ISO 6523 ICD list'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName" mode="M10" priority="1180">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<choose>
      <when test="cbc:Name" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
          <attribute name="id">PEPPOL-T16-B07801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:Name' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" mode="M10" priority="1179">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" mode="M10" priority="1178">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<choose>
      <when test="cac:Country" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
          <attribute name="id">PEPPOL-T16-B08001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Country' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M10" priority="1177">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M10" priority="1176">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M10" priority="1175">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M10" priority="1174">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M10" priority="1173">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M10" priority="1172">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M10" priority="1171">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" mode="M10" priority="1170">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<choose>
      <when test="cbc:IdentificationCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
          <attribute name="id">PEPPOL-T16-B08801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:IdentificationCode' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M10" priority="1169">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B08901</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M10" priority="1168">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B08802</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" mode="M10" priority="1167">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B08002</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/*" mode="M10" priority="1166">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B07401</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/*" mode="M10" priority="1165">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B07302</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty" mode="M10" priority="1164">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty" />

		<!--ASSERT -->
<choose>
      <when test="cac:Party" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
          <attribute name="id">PEPPOL-T16-B09001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Party' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party" mode="M10" priority="1163">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification" mode="M10" priority="1162">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B09201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M10" priority="1161">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <attribute name="id">PEPPOL-T16-B09301</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'ISO 6523 ICD list'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName" mode="M10" priority="1160">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<choose>
      <when test="cbc:Name" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
          <attribute name="id">PEPPOL-T16-B09501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:Name' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M10" priority="1159">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress" mode="M10" priority="1158">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<choose>
      <when test="cac:Country" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
          <attribute name="id">PEPPOL-T16-B09701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Country' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M10" priority="1157">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M10" priority="1156">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M10" priority="1155">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M10" priority="1154">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M10" priority="1153">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M10" priority="1152">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M10" priority="1151">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M10" priority="1150">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<choose>
      <when test="cbc:IdentificationCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
          <attribute name="id">PEPPOL-T16-B10501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:IdentificationCode' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M10" priority="1149">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B10601</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M10" priority="1148">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B10502</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/*" mode="M10" priority="1147">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B09702</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/*" mode="M10" priority="1146">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B09101</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/*" mode="M10" priority="1145">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B09002</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment" mode="M10" priority="1144">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B10701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cbc:ID" mode="M10" priority="1143">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cbc:Information" mode="M10" priority="1142">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:Information" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure" mode="M10" priority="1141">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure" />

		<!--ASSERT -->
<choose>
      <when test="@unitCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
          <attribute name="id">PEPPOL-T16-B11001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'unitCode' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <attribute name="id">PEPPOL-T16-B11002</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure" mode="M10" priority="1140">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure" />

		<!--ASSERT -->
<choose>
      <when test="@unitCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
          <attribute name="id">PEPPOL-T16-B11201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'unitCode' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <attribute name="id">PEPPOL-T16-B11202</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity" mode="M10" priority="1139">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment" mode="M10" priority="1138">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B11501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:ID" mode="M10" priority="1137">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:Information" mode="M10" priority="1136">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:Information" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty" mode="M10" priority="1135">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification" mode="M10" priority="1134">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID" mode="M10" priority="1133">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName" mode="M10" priority="1132">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName" />

		<!--ASSERT -->
<choose>
      <when test="cbc:Name" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
          <attribute name="id">PEPPOL-T16-B11901</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:Name' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name" mode="M10" priority="1131">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress" mode="M10" priority="1130">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" mode="M10" priority="1129">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M10" priority="1128">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName" mode="M10" priority="1127">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" mode="M10" priority="1126">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" mode="M10" priority="1125">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" mode="M10" priority="1124">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M10" priority="1123">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country" mode="M10" priority="1122">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M10" priority="1121">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person" mode="M10" priority="1120">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person" />

		<!--ASSERT -->
<choose>
      <when test="cac:IdentityDocumentReference" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:IdentityDocumentReference">
          <attribute name="id">PEPPOL-T16-B12101</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:IdentityDocumentReference' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" mode="M10" priority="1119">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B12201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" mode="M10" priority="1118">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" mode="M10" priority="1117">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" mode="M10" priority="1116">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B12202</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/*" mode="M10" priority="1115">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B12102</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/*" mode="M10" priority="1114">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B11801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/*" mode="M10" priority="1113">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B11502</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery" mode="M10" priority="1112">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cbc:TrackingID" mode="M10" priority="1111">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cbc:TrackingID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod" mode="M10" priority="1110">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartDate" mode="M10" priority="1109">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartTime" mode="M10" priority="1108">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartTime" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndDate" mode="M10" priority="1107">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndTime" mode="M10" priority="1106">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndTime" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/*" mode="M10" priority="1105">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B12701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch" mode="M10" priority="1104">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate" mode="M10" priority="1103">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime" mode="M10" priority="1102">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress" mode="M10" priority="1101">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:ID" mode="M10" priority="1100">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:StreetName" mode="M10" priority="1099">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:StreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:AdditionalStreetName" mode="M10" priority="1098">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:AdditionalStreetName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CityName" mode="M10" priority="1097">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CityName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:PostalZone" mode="M10" priority="1096">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:PostalZone" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CountrySubentity" mode="M10" priority="1095">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CountrySubentity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine" mode="M10" priority="1094">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine/cbc:Line" mode="M10" priority="1093">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine/cbc:Line" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country" mode="M10" priority="1092">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country" />

		<!--ASSERT -->
<choose>
      <when test="cbc:IdentificationCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
          <attribute name="id">PEPPOL-T16-B14401</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:IdentificationCode' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/cbc:IdentificationCode" mode="M10" priority="1091">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B14501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/*" mode="M10" priority="1090">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B14402</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/*" mode="M10" priority="1089">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B13501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/*" mode="M10" priority="1088">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B13201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/*" mode="M10" priority="1087">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B12501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/*" mode="M10" priority="1086">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B10702</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine" mode="M10" priority="1085">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B14601</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:OrderLineReference" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:OrderLineReference">
          <attribute name="id">PEPPOL-T16-B14602</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:OrderLineReference' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:Item" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Item">
          <attribute name="id">PEPPOL-T16-B14603</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cac:Item' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:ID" mode="M10" priority="1084">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:Note" mode="M10" priority="1083">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:Note" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:DeliveredQuantity" mode="M10" priority="1082">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:DeliveredQuantity" />

		<!--ASSERT -->
<choose>
      <when test="@unitCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
          <attribute name="id">PEPPOL-T16-B14901</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'unitCode' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <attribute name="id">PEPPOL-T16-B14902</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingQuantity" mode="M10" priority="1081">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingQuantity" />

		<!--ASSERT -->
<choose>
      <when test="@unitCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
          <attribute name="id">PEPPOL-T16-B15101</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'unitCode' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <attribute name="id">PEPPOL-T16-B15102</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingReason" mode="M10" priority="1080">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingReason" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference" mode="M10" priority="1079">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference" />

		<!--ASSERT -->
<choose>
      <when test="cbc:LineID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:LineID">
          <attribute name="id">PEPPOL-T16-B15401</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:LineID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cbc:LineID" mode="M10" priority="1078">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cbc:LineID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference" mode="M10" priority="1077">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B15601</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/cbc:ID" mode="M10" priority="1076">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/*" mode="M10" priority="1075">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B15602</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/*" mode="M10" priority="1074">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B15402</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference" mode="M10" priority="1073">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:ID" mode="M10" priority="1072">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:IssueDate" mode="M10" priority="1071">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:IssueDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:DocumentType" mode="M10" priority="1070">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:DocumentType" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item" mode="M10" priority="1069">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item" />

		<!--ASSERT -->
<choose>
      <when test="cbc:Name" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
          <attribute name="id">PEPPOL-T16-B15801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:Name' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:PackQuantity" mode="M10" priority="1068">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:PackQuantity" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:PackSizeNumeric" mode="M10" priority="1067">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:PackSizeNumeric" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:Name" mode="M10" priority="1066">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:Name" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:AdditionalInformation" mode="M10" priority="1065">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:AdditionalInformation" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification" mode="M10" priority="1064">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B16001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/cbc:ID" mode="M10" priority="1063">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/*" mode="M10" priority="1062">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B16002</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification" mode="M10" priority="1061">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B16201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ID" mode="M10" priority="1060">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID" mode="M10" priority="1059">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/*" mode="M10" priority="1058">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B16202</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification" mode="M10" priority="1057">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B16501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ID" mode="M10" priority="1056">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="@schemeID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
          <attribute name="id">PEPPOL-T16-B16601</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'schemeID' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <attribute name="id">PEPPOL-T16-B16602</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'ISO 6523 ICD list'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID" mode="M10" priority="1055">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/*" mode="M10" priority="1054">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B16502</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem" mode="M10" priority="1053">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:ID" mode="M10" priority="1052">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:UNDGCode" mode="M10" priority="1051">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:UNDGCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B17001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Dangerous goods regulations code (UNCL8273)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:TechnicalName" mode="M10" priority="1050">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:TechnicalName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:CategoryName" mode="M10" priority="1049">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:CategoryName" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:HazardClassID" mode="M10" priority="1048">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:HazardClassID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/*" mode="M10" priority="1047">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B16901</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty" mode="M10" priority="1046">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty" />

		<!--ASSERT -->
<choose>
      <when test="cbc:Name" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
          <attribute name="id">PEPPOL-T16-B17201</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:Name' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cbc:Value" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:Value">
          <attribute name="id">PEPPOL-T16-B17202</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:Value' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Name" mode="M10" priority="1045">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Name" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:NameCode" mode="M10" priority="1044">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:NameCode" />

		<!--ASSERT -->
<choose>
      <when test="@listID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@listID">
          <attribute name="id">PEPPOL-T16-B17401</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'listID' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Value" mode="M10" priority="1043">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Value" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity" mode="M10" priority="1042">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity" />

		<!--ASSERT -->
<choose>
      <when test="@unitCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
          <attribute name="id">PEPPOL-T16-B17701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'unitCode' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <attribute name="id">PEPPOL-T16-B17702</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier" mode="M10" priority="1041">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/*" mode="M10" priority="1040">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B17203</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance" mode="M10" priority="1039">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:ManufactureDate" mode="M10" priority="1038">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:ManufactureDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:BestBeforeDate" mode="M10" priority="1037">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:BestBeforeDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:SerialID" mode="M10" priority="1036">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:SerialID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification" mode="M10" priority="1035">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID" mode="M10" priority="1034">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:ExpiryDate" mode="M10" priority="1033">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:ExpiryDate" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/*" mode="M10" priority="1032">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B18401</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/*" mode="M10" priority="1031">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B18001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/*" mode="M10" priority="1030">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B15802</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment" mode="M10" priority="1029">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B18701</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cbc:ID" mode="M10" priority="1028">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cbc:ID" />

		<!--ASSERT -->
<choose>
      <when test="normalize-space(text()) = 'NA'" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="normalize-space(text()) = 'NA'">
          <attribute name="id">PEPPOL-T16-B18801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST contain value 'NA'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cbc:HandlingCode" mode="M10" priority="1027">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cbc:HandlingCode" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem" mode="M10" priority="1026">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature" mode="M10" priority="1025">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature/cbc:AttributeID" mode="M10" priority="1024">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature/cbc:AttributeID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature/cbc:Measure" mode="M10" priority="1023">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature/cbc:Measure" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature" mode="M10" priority="1022">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature/cbc:AttributeID" mode="M10" priority="1021">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature/cbc:AttributeID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature/cbc:Measure" mode="M10" priority="1020">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature/cbc:Measure" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature" mode="M10" priority="1019">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature/cbc:AttributeID" mode="M10" priority="1018">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature/cbc:AttributeID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature/cbc:Measure" mode="M10" priority="1017">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature/cbc:Measure" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit" mode="M10" priority="1016">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ID" mode="M10" priority="1015">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode" mode="M10" priority="1014">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B19101</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Recommandation 21 (UN/ECE)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:HazardousRiskIndicator" mode="M10" priority="1013">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:HazardousRiskIndicator" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks" mode="M10" priority="1012">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension" mode="M10" priority="1011">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension" />

		<!--ASSERT -->
<choose>
      <when test="cbc:AttributeID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:AttributeID">
          <attribute name="id">PEPPOL-T16-B19401</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:AttributeID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:AttributeID" mode="M10" priority="1010">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:AttributeID" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clUNCL6313-T16 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clUNCL6313-T16 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B19501</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:Measure" mode="M10" priority="1009">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:Measure" />

		<!--ASSERT -->
<choose>
      <when test="@unitCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
          <attribute name="id">PEPPOL-T16-B19601</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Attribute 'unitCode' MUST be present.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <attribute name="id">PEPPOL-T16-B19602</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/*" mode="M10" priority="1008">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B19402</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package" mode="M10" priority="1007">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package" />

		<!--ASSERT -->
<choose>
      <when test="cbc:ID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
          <attribute name="id">PEPPOL-T16-B19801</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Element 'cbc:ID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/cbc:ID" mode="M10" priority="1006">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/cbc:ID" />
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/cbc:PackagingTypeCode" mode="M10" priority="1005">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/cbc:PackagingTypeCode" />

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))">
          <attribute name="id">PEPPOL-T16-B20001</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Value MUST be part of code list 'Recommandation 21 (UN/ECE)'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/*" mode="M10" priority="1004">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B19802</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/*" mode="M10" priority="1003">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B18901</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/*" mode="M10" priority="1002">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B18702</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:DespatchLine/*" mode="M10" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B14604</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/*" mode="M10" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/*" />

		<!--ASSERT -->
<choose>
      <when test="false()" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="false()">
          <attribute name="id">PEPPOL-T16-B00109</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Document MUST NOT contain elements not part of the data model.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M10" select="@*|*" />
  </template>
  <template match="text()" mode="M10" priority="-1" />
  <template match="@*|node()" mode="M10" priority="-2">
    <apply-templates mode="M10" select="@*|*" />
  </template>

<!--PATTERN -->


	<!--RULE -->
<template match="cbc:CustomizationID" mode="M11" priority="1004">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cbc:CustomizationID" />

		<!--ASSERT -->
<choose>
      <when test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3')" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3')">
          <attribute name="id">PEPPOL-T16-R011</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:BuyerCustomerParty" mode="M11" priority="1003">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:BuyerCustomerParty" />

		<!--ASSERT -->
<choose>
      <when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
          <attribute name="id">PEPPOL-T16-R008</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>A despatch advice buyer party SHALL contain the name or an identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:SellerSupplierParty" mode="M11" priority="1002">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:SellerSupplierParty" />

		<!--ASSERT -->
<choose>
      <when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
          <attribute name="id">PEPPOL-T16-R009</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>A despatch advice buyer party SHALL contain the name or an identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:OriginatorCustomerParty" mode="M11" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:OriginatorCustomerParty" />

		<!--ASSERT -->
<choose>
      <when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
          <attribute name="id">PEPPOL-T16-R010</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>A despatch advice buyer party SHALL contain the name or an identifier</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>

	<!--RULE -->
<template match="cac:DespatchLine" mode="M11" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="cac:DespatchLine" />

		<!--ASSERT -->
<choose>
      <when test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or (cac:Item/cac:SellersItemIdentification/cbc:ID)">
          <attribute name="id">PEPPOL-T16-R003</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Each item in a Despatch Advice line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cac:Item/cbc:Name)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cac:Item/cbc:Name)">
          <attribute name="id">PEPPOL-T16-R004</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Each Despatch Advice SHALL contain the item name</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(cbc:DeliveredQuantity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(cbc:DeliveredQuantity)">
          <attribute name="id">PEPPOL-T16-R005</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Each despatch advice line SHOULD have a delivered quantity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="number(cbc:DeliveredQuantity) >= 0" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="number(cbc:DeliveredQuantity) >= 0">
          <attribute name="id">PEPPOL-T16-R006</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>Each despatch advice line delivered quantity SHALL not be negative</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)">
          <attribute name="id">PEPPOL-T16-R007</attribute>
          <attribute name="flag">warning</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>An outstanding quantity reason SHOULD be provided if the despatch line contains an outstanding quantity</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M11" select="@*|*" />
  </template>
  <template match="text()" mode="M11" priority="-1" />
  <template match="@*|node()" mode="M11" priority="-2">
    <apply-templates mode="M11" select="@*|*" />
  </template>

<!--PATTERN IT-UBL-T16-->


	<!--RULE -->
<template match="//cbc:EndpointID" mode="M12" priority="1004">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//cbc:EndpointID" />

		<!--ASSERT -->
<choose>
      <when test="(@schemeID='0201' and matches(.,'^[a-zA-Z0-9]{6,7}$')) or @schemeID!='0201'" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(@schemeID='0201' and matches(.,'^[a-zA-Z0-9]{6,7}$')) or @schemeID!='0201'">
          <attribute name="id">IT-T16-R026</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R026] - If the endpoint identifier is based on the IT identifier scheme: IPA (ICD: 0201), this should follow the syntax [A-Z0-9]{6,7}.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(@schemeID='9906' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='9906'" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(@schemeID='9906' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='9906'">
          <attribute name="id">IT-T16-R027</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R027] - If the endpoint identifier is based on the IT identifier scheme: VAT (ICD: 9906), this should follow the syntax (IT)?[0-9]{11}.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(@schemeID='9907' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='9907'" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(@schemeID='9907' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='9907'">
          <attribute name="id">IT-T16-R028</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R028] - If the endpoint identifier is based on the IT identifier scheme: CF (ICD: 9907), this should follow the syntax [0-9]{11} for legal entities and syntax [A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1} for natural persons.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="//cac:DespatchLine" mode="M12" priority="1003">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//cac:DespatchLine" />

		<!--ASSERT -->
<choose>
      <when test="cac:Item/cbc:Name and (cac:Item/cac:SellersItemIdentification/cbc:ID or cac:Item/cac:StandardItemIdentification/cbc:ID) and cbc:DeliveredQuantity" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Item/cbc:Name and (cac:Item/cac:SellersItemIdentification/cbc:ID or cac:Item/cac:StandardItemIdentification/cbc:ID) and cbc:DeliveredQuantity">
          <attribute name="id">IT-T16-R003</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R003] - The lines of the Despatch Advice MUST contain the minimum information required by Art. 21, paragraph 4 of Presidential Decree no. 633/1972 (Product name, article identifier and quantity delivered).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="//cac:DespatchLine/cac:Item/cac:HazardousItem" mode="M12" priority="1002">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//cac:DespatchLine/cac:Item/cac:HazardousItem" />

		<!--ASSERT -->
<choose>
      <when test="cbc:UNDGCode" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:UNDGCode">
          <attribute name="id">IT-T16-R029</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R029] - The element 'cbc:UNDGCode' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cbc:HazardClassID" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cbc:HazardClassID">
          <attribute name="id">IT-T16-R030</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R030] - The element 'cbc:HazardClassID' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice" mode="M12" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice" />

		<!--ASSERT -->
<choose>
      <when test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1'" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1'">
          <attribute name="id">IT-T16-R004</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R004] - The Despatch Advice CustomizationID MUST be set with string 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1'.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:DespatchSupplierParty/cac:Party[cac:PartyLegalEntity/cbc:RegistrationName and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity] and cac:DeliveryCustomerParty/cac:Party[cac:PartyLegalEntity/cbc:RegistrationName and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity] and (not(cac:BuyerCustomerParty) or (cac:BuyerCustomerParty/cac:Party[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity])) and (not(cac:SellerSupplierParty) or (cac:SellerSupplierParty/cac:Party[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity])) and cac:Shipment/cbc:GrossWeightMeasure and cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (not(cac:Shipment/cac:Consignment/cac:CarrierParty) or (cac:Shipment/cac:Consignment/cac:CarrierParty[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity]))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:DespatchSupplierParty/cac:Party[cac:PartyLegalEntity/cbc:RegistrationName and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity] and cac:DeliveryCustomerParty/cac:Party[cac:PartyLegalEntity/cbc:RegistrationName and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity] and (not(cac:BuyerCustomerParty) or (cac:BuyerCustomerParty/cac:Party[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity])) and (not(cac:SellerSupplierParty) or (cac:SellerSupplierParty/cac:Party[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity])) and cac:Shipment/cbc:GrossWeightMeasure and cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (not(cac:Shipment/cac:Consignment/cac:CarrierParty) or (cac:Shipment/cac:Consignment/cac:CarrierParty[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity]))">
          <attribute name="id">IT-T16-R002</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R002] - The Despatch Advice header MUST contain the minimum information required by Art. 21, paragraph 4 of Presidential Decree no. 633/1972 (Identification, name and address of the Consignor / Transferor, name and address of the Consignee / Transferee, gross weight and number of packages of the shipment, details of the Transporter and address, if a third party carries out the physical transport).</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (string(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) castable as xs:integer or cac:Shipment/cbc:TotalTransportHandlingUnitQuantity - floor(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) = 0)" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (string(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) castable as xs:integer or cac:Shipment/cbc:TotalTransportHandlingUnitQuantity - floor(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) = 0)">
          <attribute name="id">IT-T16-R005</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R005] - The number of packages must be an integer.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M12" select="@*|*" />
  </template>

	<!--RULE -->
<template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment" mode="M12" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment" />

		<!--ASSERT -->
<choose>
      <when test="cac:CarrierParty" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="cac:CarrierParty">
          <attribute name="id">IT-T16-R031</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R031] - The element 'cac:CarrierParty' MUST be provided.</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--ASSERT -->
<choose>
      <when test="(some $code in $clISO3166 satisfies $code = normalize-space(cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode/text()))" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode/text()))">
          <attribute name="id">IT-T16-R032</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>[IT-T16-R032] - L'The element 'cac:CarrierParty' MUST be set based on Country code list (ISO 3166-1:Alpha2).</ns0:text>
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
