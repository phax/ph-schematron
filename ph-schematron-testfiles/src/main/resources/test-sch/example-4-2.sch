<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron" 
         xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
         xmlns:sch="http://www.ascc.net/xml/schematron"
         xmlns:dp ="http://www.dpawson.co.uk/ns#"
         queryBinding='xslt2'
         schemaVersion="ISO19757-3">
  <iso:title>Test ISO schematron file. Introduction mode </iso:title>

  <iso:ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />  
  <iso:ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />


<iso:pattern id="doc.checks">
  <iso:title>checking an XXX document</iso:title>
  <iso:rule context="dp:doc">
                                                                  
    <iso:report test="dp:chapter">Report date.<iso:value-of 
             select="fn:current-dateTime()"/></iso:report>
    <iso:assert test="count(dp:chapter) = 3"
                 >There should be 3 chapters only</iso:assert>
  </iso:rule>
</iso:pattern>

  <iso:pattern id="chapter.checks">
    <iso:rule context="dp:chapter">
      <iso:assert test="dp:title">Chapter should have  a title</iso:assert>
      <iso:assert test="count(dp:para) >= 1">A chapter must have one or more paragraphs</iso:assert>
      <iso:assert test="*[1][self::dp:title]">Title must be first child of chapter</iso:assert>
      <iso:assert test="@id">All chapters must have an ID attribute</iso:assert>
    </iso:rule>
  </iso:pattern>
</iso:schema>