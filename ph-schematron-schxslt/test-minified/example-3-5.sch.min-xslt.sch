<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <title>Test ISO schematron file. Introduction mode</title>
  <!-- Not used in first run -->
  <ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />

 <pattern>
    <title>A very simple pattern with a title</title>
    <rule context="chapter">
      <assert test="title">Chapter should have a title</assert>
      <report test="count(para)">
      <value-of select="count(para)" /> paragraphs</report>
    </rule>
  </pattern>

</schema>
