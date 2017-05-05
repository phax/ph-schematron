<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
            xmlns="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt2">
  <sch:pattern id="sampleValidation">
    <sch:rule context="/">
      <assert test="note">root element must be 'note'</assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
