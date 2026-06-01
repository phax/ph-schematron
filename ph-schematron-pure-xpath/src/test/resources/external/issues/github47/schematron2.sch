<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  queryBinding="xpath" schemaVersion="ISO19757-3">
  
  <sch:pattern name="Customer">
    <sch:rule context="/file/Customer">
      <sch:assert test="base-uri()" role="fatal">base-uri is '<sch:value-of select="base-uri()" />'</sch:assert>
      <sch:assert test="base-uri() = ''" role="fatal">!base-uri is '<sch:value-of select="base-uri()" />'</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 