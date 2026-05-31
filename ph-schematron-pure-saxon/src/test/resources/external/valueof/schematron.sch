<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern>
    <rule context="book">
      <assert test="@isbn">Book <name path="title"/> is missing an ISBN (got '<value-of select="@isbn"/>')</assert>
    </rule>
  </pattern>
</schema>
