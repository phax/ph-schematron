<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:pattern name="Every file is referenced to one doc">
    <sch:rule context="//file">
      <sch:assert test="count(@Id = //reference/@Id) = 1">
        file <sch:value-of select="@Id" /> is not referenced once but <sch:value-of select="count(@Id = //reference/@Id)" />
      </sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>