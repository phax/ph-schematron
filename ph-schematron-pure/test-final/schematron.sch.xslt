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
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" schemaVersion="" title="">
      <comment>
        <value-of select="$archiveDirParameter" />   
		 <value-of select="$archiveNameParameter" />  
		 <value-of select="$fileNameParameter" />  
		 <value-of select="$fileDirParameter" />
      </comment>
      <ns0:active-pattern>
        <attribute name="document">
          <value-of select="document-uri(/)" />
        </attribute>
        <apply-templates />
      </ns0:active-pattern>
      <apply-templates mode="M0" select="/" />
    </ns0:schematron-output>
  </template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN -->


	<!--RULE -->
<template match="//file" mode="M0" priority="1001">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//file" />

		<!--ASSERT -->
<choose>
      <when test="@Id = //reference/@To_File" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="@Id = //reference/@To_File">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>
        file <text />
            <value-of select="@Id" />
            <text /> is not referenced at all
      </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M0" select="*|comment()|processing-instruction()" />
  </template>

	<!--RULE -->
<template match="//doc" mode="M0" priority="1000">
    <ns0:fired-rule xmlns:ns0="http://purl.oclc.org/dsdl/svrl" context="//doc" />
    <variable name="cur" select="." />

		<!--ASSERT -->
<choose>
      <when test="count(//reference[@To_File = $cur/generic/reference/@To_File]) = 1" />
      <otherwise>
        <ns0:failed-assert xmlns:ns0="http://purl.oclc.org/dsdl/svrl" test="count(//reference[@To_File = $cur/generic/reference/@To_File]) = 1">
          <attribute name="location">
            <apply-templates mode="schematron-select-full-path" select="." />
          </attribute>
          <ns0:text>
        file <text />
            <value-of select="generic/reference/@To_File" />
            <text /> referenced from document <text />
            <value-of select="@Id" />
            <text /> is referenced <text />
            <value-of select="count(//reference[@To_File = $cur/generic/reference/@To_File])" />
            <text /> times overall
      </ns0:text>
        </ns0:failed-assert>
      </otherwise>
    </choose>
    <apply-templates mode="M0" select="*|comment()|processing-instruction()" />
  </template>
  <template match="text()" mode="M0" priority="-1" />
  <template match="@*|node()" mode="M0" priority="-2">
    <apply-templates mode="M0" select="*|comment()|processing-instruction()" />
  </template>
</stylesheet>
