<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath">
  <sch:pattern id="sampleValidation">
    <sch:rule context="CCC" role="abc">
      <sch:assert test="A and B">A and B must be present</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
