<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <pattern name="Every file is referenced to one doc">
    <rule context="//file">
      <assert test="@Id = //reference/@To_File">
        file <value-of select="@Id" /> is not referenced at all
      </assert>
    </rule>
    <rule context="//doc">
      <let name="cur" value="." />
      <assert test="count(//reference[@To_File = $cur/generic/reference/@To_File]) = 1">
        file <value-of select="generic/reference/@To_File" /> referenced from document <value-of select="@Id" /> is referenced <value-of select="count(//reference[@To_File = $cur/generic/reference/@To_File])" /> times overall
      </assert>
    </rule>
  </pattern>
</schema>
