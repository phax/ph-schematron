<?xml version="1.0" encoding="iso-8859-1"?>
<!-- The main Schematron file -->

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
    <iso:report 
test="chapter">Report date.<iso:value-of select="fn:current-dateTime()"/></iso:report>
  </iso:rule>
</iso:pattern>

  <iso:pattern id="chapter.checks">
    <iso:title>Basic Chapter checks</iso:title>
    <iso:p>All chapter level checks. </iso:p>

 <iso:include href='example-8-5.incl'/>                                   

  </iso:pattern>
</iso:schema>