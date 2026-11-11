<?xml version="1.0" encoding="UTF-8"?>
<!-- A local "xsl:include" is resolved by the URI resolver and therefore keeps working. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:u="urn:test:utils"
                version="2.0">
  <xsl:include href="local-included.xslt" />

  <xsl:template match="/">
    <svrl:schematron-output>
      <svrl:active-pattern>
        <xsl:attribute name="id">
          <xsl:value-of select="u:constant()" />
        </xsl:attribute>
      </svrl:active-pattern>
    </svrl:schematron-output>
  </xsl:template>
</xsl:stylesheet>
