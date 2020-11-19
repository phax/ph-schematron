<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern id="requiredAttribute">
    <rule context="Customer">
      <assert test="string-length(@type) > 0">
        The <name /> element should have a
       <value-of select="@type/name()" /> attribute.
      </assert>
    </rule>
  </pattern>
</schema>
