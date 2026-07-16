<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        queryBinding="xslt2">
  <pattern>
    <rule context="book">
      <let name="sizeBucket">
        <xsl:choose>
          <xsl:when test="count(chapter) ge 10">large</xsl:when>
          <xsl:when test="count(chapter) ge 3">medium</xsl:when>
          <xsl:otherwise>small</xsl:otherwise>
        </xsl:choose>
      </let>
      <assert test="$sizeBucket != 'small'">Book is too small (got <value-of select="$sizeBucket"/>).</assert>
    </rule>
  </pattern>
</schema>
