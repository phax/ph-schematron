<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <title>Test ISO schematron file. Introduction mode </title>

  <ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />  
  <ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />


<pattern id="doc.checks">
  <title>checking an XXX document</title>
  <rule context="dp:doc">
                                                                  
    <report test="dp:chapter">Report date.<value-of select="fn:current-dateTime()" />
</report>
    <assert test="count(dp:chapter) = 3">There should be 3 chapters only</assert>
  </rule>
</pattern>

  <pattern id="chapter.checks">
    <rule context="dp:chapter">
      <assert test="dp:title">Chapter should have  a title</assert>
      <assert test="count(dp:para) >= 1">A chapter must have one or more paragraphs</assert>
      <assert test="*[1][self::dp:title]">Title must be first child of chapter</assert>
      <assert test="@id">All chapters must have an ID attribute</assert>
    </rule>
  </pattern>
</schema>
