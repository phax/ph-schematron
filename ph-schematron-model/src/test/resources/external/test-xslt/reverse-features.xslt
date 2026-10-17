<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <!-- Created with ph-schematron version of ISO Schematron XSLTs. -->
<!-- Implementers: please note that overriding process-prolog or process-root is 
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
    <variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                       and namespace-uri() = namespace-uri(current())])" />
    <text>[</text>
    <value-of select="1 + $preceding" />
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
  <!--Strip characters-->
  <template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<template match="/">
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" schemaVersion="1.0" title="Probe schema">
      <comment>
        <value-of select="$archiveDirParameter" />   
		 <value-of select="$archiveNameParameter" />  
		 <value-of select="$fileNameParameter" />  
		 <value-of select="$fileDirParameter" />
      </comment>
      <ns0:ns-prefix-in-attribute-values prefix="u" uri="urn:test:u" />
      <ns0:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <ns0:active-pattern>
        <attribute name="documents">
          <value-of select="document-uri(/)" />
        </attribute>
        <attribute name="id">pat1</attribute>
        <attribute name="name">First pattern</attribute>
      </ns0:active-pattern>
      <apply-templates mode="M5" select="/" />
      <ns0:active-pattern>
        <attribute name="documents">
          <value-of select="document-uri(/)" />
        </attribute>
      </ns0:active-pattern>
      <apply-templates mode="M6" select="/" />
    </ns0:schematron-output>
  </template>

<!--SCHEMATRON PATTERNS-->
<ns0:text xmlns:ns0="http://purl.oclc.org/dsdl/svrl">Probe schema</ns0:text>
  <param name="gl" select="'global'" />

<!--PATTERN pat1First pattern-->
<ns0:text xmlns:ns0="http://purl.oclc.org/dsdl/svrl">First pattern</ns0:text>
  <variable name="pl" select="1" />

	<!--RULE R1-->
<template match="/root/item" mode="M5" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/root/item" id="R1" />
    <variable name="rl" select="@a" />

		<!--ASSERT error-->
<choose>
      <when test="@a = $rl and $pl = 1" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@a = $rl and $pl = 1">
          <attribute name="id">A-1</attribute>
          <attribute name="flag">fatal</attribute>
          <attribute name="role">error</attribute>
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute> <ns0:diagnostic-reference diagnostic="d1">
<ns0:text>Diag <text />
              <value-of select="@a" />
              <text />
</ns0:text>
</ns0:diagnostic-reference>
          <ns0:text>Item <text />
            <value-of select="name(.)" />
            <text /> / <text />
            <value-of select="@a" />
            <text /> must <text />match<text /> <text />
            <value-of select="$gl" />
            <text />
</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>

		<!--REPORT warning-->
<if test="@b">
      <ns0:successful-report xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@b">
        <attribute name="id">R-1</attribute>
        <attribute name="role">warning</attribute>
        <attribute name="location">
          <apply-templates mode="schematron-select-full-path" select="." />
        </attribute> <ns0:property id="pr1">Prop <ns1:value-of xmlns:ns1="http://purl.oclc.org/dsdl/schematron" select="@b" />
</ns0:property>
        <ns0:text>Has b: <text />
          <value-of select="name(@b)" />
          <text />
</ns0:text>
      </ns0:successful-report>
    </if>
    <apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </template>
  <template match="text()" mode="M5" priority="-1" />
  <template match="@*|node()" mode="M5" priority="-2">
    <apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </template>

<!--PATTERN -->


	<!--RULE -->
<template match="/root" mode="M6" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="/root" />

		<!--ASSERT -->
<choose>
      <when test="item" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="item">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>needs item</ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M6" select="*|comment()|processing-instruction()" />
  </template>
  <template match="text()" mode="M6" priority="-1" />
  <template match="@*|node()" mode="M6" priority="-2">
    <apply-templates mode="M6" select="*|comment()|processing-instruction()" />
  </template>
</stylesheet>

