<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt2">
  <sch:pattern name="Customer">
    <sch:rule context="/file/Customer">
      <sch:assert test="true" role="fatal" id="ab">ab1</sch:assert>
    </sch:rule>
    <sch:rule context="/file/Client">
      <sch:assert test="true" role="fatal" id="ab">ab2</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 
