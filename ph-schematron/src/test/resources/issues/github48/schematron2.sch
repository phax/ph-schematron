<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  queryBinding="xslt2"
  xmlns:sqf="http://example.org/sqf">
  
  <sch:ns prefix="sqf" uri="http://example.org/sqf" />
  
  <sch:pattern name="Customer">
    <sch:rule context="/file/Customer">
      <sch:assert test="base-uri()" role="fatal">
        base-uri is '<sch:value-of select="base-uri()" />'
        <sqf:fix id="a12"/>
      </sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 
