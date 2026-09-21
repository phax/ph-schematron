<?xml version="1.0" encoding="UTF-8"?>
<!-- "xsl:result-document" is an extension of the secondary output destinations that
     Saxon disables when secure processing is enabled. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                version="2.0">
  <xsl:template match="/">
    <xsl:result-document href="secondary.xml">
      <secondary />
    </xsl:result-document>
    <svrl:schematron-output />
  </xsl:template>
</xsl:stylesheet>
