<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron" 
         xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
         xmlns:sch="http://purl.oclc.org/dsdl/schematron"
         queryBinding='xslt2'
         schemaVersion="ISO19757-3">
  <iso:title>Test ISO schematron file. Introduction mode </iso:title> 
  <!-- Not used in first run -->
  <iso:ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />
  <iso:ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />

  <iso:pattern id="doc.checks">
   <iso:title>checking an XXX document</iso:title> 
   <iso:rule context="doc">
    <iso:report test="chapter">Report date.
    <iso:value-of select="fn:current-dateTime()"/></iso:report>   
   </iso:rule>
  </iso:pattern>

  <iso:pattern id="chapter.checks">
    <iso:title>Basic Chapter checks</iso:title>            
    <iso:p>All chapter level checks. </iso:p>             
    <iso:rule context="chapter">
      <iso:assert test="title">Chapter should have  a title</iso:assert>
      <iso:report test="count(para)"><iso:value-of select="count(para)"/> paragraphs</iso:report>
      <iso:assert test="count(para) >= 1">A chapter must have one or more paragraphs</iso:assert>
      <iso:assert test="*[1][self::title]">Title must be first child of chapter</iso:assert>
      <iso:assert test="@id">All chapters must have an ID attribute</iso:assert>
    </iso:rule>
  </iso:pattern>
</iso:schema>