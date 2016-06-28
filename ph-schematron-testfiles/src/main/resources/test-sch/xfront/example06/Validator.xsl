<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" version="1.0">
<axsl:template mode="schematron-get-full-path" match="*|@*">
<axsl:apply-templates mode="schematron-get-full-path" select="parent::*"/>
<axsl:text>/</axsl:text>
<axsl:if test="count(. | ../@*) = count(../@*)">@</axsl:if>
<axsl:value-of select="name()"/>
<axsl:text>[</axsl:text>
<axsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
<axsl:text>]</axsl:text>
</axsl:template>
<axsl:template match="/">
<axsl:apply-templates mode="M0" select="/"/>
</axsl:template>
<axsl:template mode="M0" priority="3999" match="Para[@classification='top-secret']">
<axsl:choose>
<axsl:when test="/Document/@classification='top-secret'"/>
<axsl:otherwise>If there is a Para is labeled "top-secret" then the Document should be labeled top-secret</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M0"/>
</axsl:template>
<axsl:template mode="M0" priority="3998" match="Para[@classification='secret']">
<axsl:choose>
<axsl:when test="(/Document/@classification='top-secret') or                            (/Document/@classification='secret')"/>
<axsl:otherwise>If there is a Para is labeled "secret" then the Document should be labeled either secret or top-secret</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M0"/>
</axsl:template>
<axsl:template mode="M0" priority="3997" match="Para[@classification='confidential']">
<axsl:choose>
<axsl:when test="(/Document/@classification='top-secret') or                            (/Document/@classification='secret') or                             (/Document/@classification='confidential')"/>
<axsl:otherwise>If there is a Para is labeled "confidential" then the Document should be labeled either confidential, secret or top-secret</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M0"/>
</axsl:template>
<axsl:template mode="M0" priority="-1" match="text()"/>
<axsl:template priority="-1" match="text()"/>
</axsl:stylesheet>
