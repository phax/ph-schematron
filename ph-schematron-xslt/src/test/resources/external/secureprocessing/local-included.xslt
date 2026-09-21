<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:u="urn:test:utils"
                version="2.0">
  <xsl:function name="u:constant" as="xs:string">
    <xsl:value-of select="'included'" />
  </xsl:function>
</xsl:stylesheet>
