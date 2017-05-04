<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
            xmlns="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt2">
  <sch:pattern id="sampleValidation">
    <sch:title>PatternTitle</sch:title>
    <sch:p>A paragraph</sch:p>
    <sch:rule context="/">
      <assert test="simple">root element must be 'simple'</assert>
    </sch:rule>
    <sch:rule context="X">
      <assert test="normalize-space(.) and *">Source contains an empty element</assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
