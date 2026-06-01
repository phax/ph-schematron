<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern>
    <rule context="tag1">
      <assert test="matches(tag2,'^[0-9]{4}$')">Invalid value</assert>
    </rule>
  </pattern>
</schema>
