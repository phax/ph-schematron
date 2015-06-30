<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron" 
         xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
         xmlns:sch="http://www.ascc.net/xml/schematron"
         queryBinding='xslt2'
         schemaVersion="ISO19757-3">
  <iso:title>Test ISO schematron file. Introduction mode</iso:title>
  <!-- Not used in first run -->
  <iso:ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />

 <iso:pattern >
    <iso:title>A very simple pattern with a title</iso:title>
    <iso:rule context="chapter">
      <iso:assert test="title">Chapter should have a title</iso:assert>
      <iso:report test="count(para)">
      <iso:value-of select="count(para)"/> paragraphs</iso:report>
    </iso:rule>
  </iso:pattern>

</iso:schema>