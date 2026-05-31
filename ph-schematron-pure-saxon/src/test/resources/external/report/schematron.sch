<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern>
    <rule context="book">
      <report test="@deprecated = 'true'">Book is marked deprecated.</report>
    </rule>
  </pattern>
</schema>
