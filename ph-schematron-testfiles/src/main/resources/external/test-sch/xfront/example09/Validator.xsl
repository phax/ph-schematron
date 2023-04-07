<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://www.ascc.net/xml/schematron" version="1.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. The name or details of 
    this mode may change during 1Q 2007.-->


<!--PHASES-->


<!--PROLOG-->


<!--KEYS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<axsl:template mode="schematron-get-full-path" match="*">
<axsl:apply-templates mode="schematron-get-full-path" select="parent::*"/>
<axsl:text>/</axsl:text>
<axsl:choose>
<axsl:when test="namespace-uri()=''">
<axsl:value-of select="name()"/>
</axsl:when>
<axsl:otherwise>
<axsl:text>*:</axsl:text>
<axsl:value-of select="local-name()"/>
<axsl:text>[namespace-uri()='</axsl:text>
<axsl:value-of select="namespace-uri()"/>
<axsl:text>']</axsl:text>
</axsl:otherwise>
</axsl:choose>
<axsl:variable select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" name="preceding"/>
<axsl:text>[</axsl:text>
<axsl:value-of select="1+ $preceding"/>
<axsl:text>]</axsl:text>
</axsl:template>
<axsl:template mode="schematron-get-full-path" match="@*">
<axsl:apply-templates mode="schematron-get-full-path" select="parent::*"/>
<axsl:text>/</axsl:text>
<axsl:choose>
<axsl:when test="namespace-uri()=''">@sch:schema</axsl:when>
<axsl:otherwise>
<axsl:text>@*[local-name()='</axsl:text>
<axsl:value-of select="local-name()"/>
<axsl:text>' and namespace-uri()='</axsl:text>
<axsl:value-of select="namespace-uri()"/>
<axsl:text>']</axsl:text>
</axsl:otherwise>
</axsl:choose>
</axsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<axsl:template mode="schematron-get-full-path-2" match="node() | @*">
<axsl:for-each select="ancestor-or-self::*">
<axsl:text>/</axsl:text>
<axsl:value-of select="name(.)"/>
<axsl:if test="preceding-sibling::*[name(.)=name(current())]">
<axsl:text>[</axsl:text>
<axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
<axsl:text>]</axsl:text>
</axsl:if>
</axsl:for-each>
<axsl:if test="not(self::*)">
<axsl:text/>/@<axsl:value-of select="name(.)"/>
</axsl:if>
</axsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<axsl:template mode="generate-id-from-path" match="/"/>
<axsl:template mode="generate-id-from-path" match="text()">
<axsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
<axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
</axsl:template>
<axsl:template mode="generate-id-from-path" match="comment()">
<axsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
<axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
</axsl:template>
<axsl:template mode="generate-id-from-path" match="processing-instruction()">
<axsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
<axsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
</axsl:template>
<axsl:template mode="generate-id-from-path" match="@*">
<axsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
<axsl:value-of select="concat('.@', name())"/>
</axsl:template>
<axsl:template priority="-0.5" mode="generate-id-from-path" match="*">
<axsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
<axsl:text>.</axsl:text>
<axsl:choose>
<axsl:when test="count(. | ../namespace::*) = count(../namespace::*)">
<axsl:value-of select="concat('.namespace::-',1+count(namespace::*),'-')"/>
</axsl:when>
<axsl:otherwise>
<axsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
</axsl:otherwise>
</axsl:choose>
</axsl:template>

<!--MODE: GENERATE-ID-2 -->
<axsl:template mode="generate-id-2" match="/">U</axsl:template>
<axsl:template priority="2" mode="generate-id-2" match="*">
<axsl:text>U</axsl:text>
<axsl:number count="*" level="multiple"/>
</axsl:template>
<axsl:template mode="generate-id-2" match="node()">
<axsl:text>U.</axsl:text>
<axsl:number count="*" level="multiple"/>
<axsl:text>n</axsl:text>
<axsl:number count="node()"/>
</axsl:template>
<axsl:template mode="generate-id-2" match="@*">
<axsl:text>U.</axsl:text>
<axsl:number count="*" level="multiple"/>
<axsl:text>_</axsl:text>
<axsl:value-of select="string-length(local-name(.))"/>
<axsl:text>_</axsl:text>
<axsl:value-of select="translate(name(),':','.')"/>
</axsl:template>
<!--Strip characters-->
<axsl:template priority="-1" match="text()"/>

<!--SCHEMA METADATA-->
<axsl:template match="/">
<axsl:apply-templates mode="M0" select="/"/>
</axsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN -->


	<!--RULE -->
<axsl:template mode="M0" priority="3999" match="Para[@classification='top-secret']">

		<!--ASSERT -->
<axsl:choose>
<axsl:when test="/Document/@classification='top-secret'"/>
<axsl:otherwise>
             If there is a Para is labeled "top-secret" then the Document  
             should be labeled top-secret
         <axsl:value-of select="string('&#10;')"/>
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()"/>
</axsl:template>

	<!--RULE -->
<axsl:template mode="M0" priority="3998" match="Para[@classification='secret']">

		<!--ASSERT -->
<axsl:choose>
<axsl:when test="(/Document/@classification='top-secret') or                            (/Document/@classification='secret')"/>
<axsl:otherwise>
             If there is a Para is labeled "secret" then the Document  
             should be labeled either secret or top-secret
         <axsl:value-of select="string('&#10;')"/>
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()"/>
</axsl:template>

	<!--RULE -->
<axsl:template mode="M0" priority="3997" match="Para[@classification='confidential']">

		<!--ASSERT -->
<axsl:choose>
<axsl:when test="(/Document/@classification='top-secret') or                            (/Document/@classification='secret') or                             (/Document/@classification='confidential')"/>
<axsl:otherwise>
             If there is a Para is labeled "confidential" then the Document  
             should be labeled either confidential, secret or top-secret
         <axsl:value-of select="string('&#10;')"/>
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M0" select="@*|*|comment()|processing-instruction()"/>
</axsl:template>
<axsl:template mode="M0" priority="-1" match="text()"/>
<axsl:template mode="M0" priority="-2" match="@*|node()">
<axsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<axsl:when test="not(@*)">
<axsl:apply-templates mode="M0" select="node()"/>
</axsl:when>
<axsl:otherwise>
<axsl:apply-templates mode="M0" select="@*|node()"/>
</axsl:otherwise>
</axsl:choose>
</axsl:template>
</axsl:stylesheet>
