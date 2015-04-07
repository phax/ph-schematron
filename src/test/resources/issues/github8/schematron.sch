<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  queryBinding="xslt2" schemaVersion="ISO19757-3">
  <sch:title>ISO schematron validation file for descriptive extended constraints</sch:title>
  
  <sch:pattern name="/Customer/ContactDetails">
    <sch:let name="xyz" value="mobile" />
    <sch:let name="expected" value="''" />
    <sch:rule context="//Customer/ContactDetails">
      <sch:assert test="$xyz">Mobile is missing</sch:assert>
    </sch:rule>
    <sch:rule context="//Customer/ContactDetails/mobile">
      <sch:assert test="text()!=$expected">Mobile is missing content</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 