<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2014-2024 Philip Helger (www.helger.com)
    philip[at]helger[dot]com

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:u="utils"
               version="2.0">
  <xsl:output method="text" />

  <xsl:function as="xs:decimal" name="u:decimal">
    <xsl:param name="element" />
    <xsl:value-of select="if (boolean($element)) then xs:decimal($element) else 0" />
    <!-- 
    <xsl:choose>
      <xsl:when test="$element"><xsl:value-of select="xs:decimal($element)" /></xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
     -->
  </xsl:function>

  <xsl:template match="/">
    <!-- all sub elements -->
    <xsl:apply-templates select="*" />
  </xsl:template> 

  <xsl:template match="e1">
    <xsl:text>e1[</xsl:text>
    <xsl:value-of select="non-existing-element" />
    <xsl:text>][</xsl:text>
    <xsl:value-of select="xs:decimal(non-existing-element)" />
    <xsl:text>][</xsl:text>
    <xsl:value-of select="5 + xs:decimal(non-existing-element)" />
    <xsl:text>]
</xsl:text>
  </xsl:template>

  <xsl:template match="e2">
    <xsl:text>e2[</xsl:text>
    <xsl:value-of select="existing-element" />
    <xsl:text>][</xsl:text>
    <xsl:value-of select="xs:decimal(existing-element)" />
    <xsl:text>][</xsl:text>
    <xsl:value-of select="5 + xs:decimal(existing-element)" />
    <xsl:text>]
</xsl:text>
  </xsl:template>

  <xsl:template match="e3">
    <xsl:text>e3[</xsl:text>
    <xsl:value-of select="existing-element" />
    <xsl:text>][</xsl:text>
    <xsl:value-of select="xs:decimal(existing-element)" />
    <xsl:text>] -- [</xsl:text>
    <xsl:value-of select="xs:decimal(../e1/non-existing-element) + xs:decimal(existing-element)" />
    <xsl:text>][</xsl:text>
    <xsl:value-of select="xs:decimal(../e2/existing-element) + xs:decimal(existing-element)" />
    <xsl:text>] -- [</xsl:text>
    <xsl:value-of select="u:decimal(../e1/non-existing-element) + u:decimal(existing-element)" />
    <xsl:text>][</xsl:text>
    <xsl:value-of select="u:decimal(../e2/existing-element) + u:decimal(existing-element)" />
    <xsl:text>]
</xsl:text>
  </xsl:template>
</xsl:transform>
