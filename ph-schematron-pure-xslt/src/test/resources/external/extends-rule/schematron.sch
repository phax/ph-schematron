<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern>
    <rule abstract="true" id="hasIdentifier">
      <assert test="@id">Element must have an @id attribute.</assert>
    </rule>
    <rule context="book">
      <extends rule="hasIdentifier"/>
      <assert test="@isbn">Book must have an ISBN.</assert>
    </rule>
  </pattern>
</schema>
