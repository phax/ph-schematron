<?xml version="1.0" encoding="UTF-8"?>
<!-- The "xsl:include" must not trigger an outbound network request.
     Port 1 is used, so that a regression fails fast instead of hanging. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                version="2.0">
  <xsl:include href="http://localhost:1/blocked.xsl" />

  <xsl:template match="/">
    <svrl:schematron-output />
  </xsl:template>
</xsl:stylesheet>
