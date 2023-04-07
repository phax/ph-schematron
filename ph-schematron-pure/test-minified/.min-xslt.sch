<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="sqf" uri="http://example.org/sqf" />
  <pattern name="Customer">
    <rule context="/file/Customer">
      <assert role="fatal" test="base-uri()">
        base-uri is '<value-of select="base-uri()" />'
        <ns0:fix xmlns:ns0="http://example.org/sqf" id="a12" />
      </assert>
    </rule>
  </pattern>
</schema>
