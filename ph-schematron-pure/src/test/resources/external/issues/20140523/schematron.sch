<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  queryBinding="xpath2" schemaVersion="ISO19757-3">
  <sch:ns prefix="v3" uri="urn:hl7-org:v3"/>
  <sch:pattern name="473">
    <sch:rule id="a473" context="//v3:subject">
      <sch:assert test="//*[@contextConductionInd='true']">Assert Issue 473: contextConductionInd is false, should be true</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 