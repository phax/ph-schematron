<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:pattern>
    <sch:rule context="element">
      <sch:assert test="true()"/>
    </sch:rule>
    <sch:rule context="*">
      <sch:assert test="false()"/>
    </sch:rule>
  </sch:pattern>
</sch:schema>
