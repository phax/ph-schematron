<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        queryBinding="xslt2">
  <ns prefix="my" uri="urn:my-functions"/>
  <xsl:function name="my:isNonEmpty" xmlns:my="urn:my-functions">
    <xsl:param name="s"/>
    <xsl:sequence select="string-length($s) gt 0"/>
  </xsl:function>
  <pattern>
    <rule context="book">
      <assert test="my:isNonEmpty(@title)">Book must have a non-empty @title attribute.</assert>
    </rule>
  </pattern>
</schema>
