<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:pattern name="Every file is referenced to one doc">
    <sch:rule context="//file">
      <sch:assert test="@Id = //reference/@To_File">
        file <sch:value-of select="@Id" /> is not referenced at all
      </sch:assert>
    </sch:rule>
    <sch:rule context="//doc">
      <sch:let name="cur" value="." />
      <sch:assert test="count(//reference[@To_File = $cur/generic/reference/@To_File]) = 1">
        file <sch:value-of select="generic/reference/@To_File" /> referenced from document <sch:value-of select="@Id" /> is referenced <sch:value-of select="count(//reference[@To_File = $cur/generic/reference/@To_File])" /> times overall
      </sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
