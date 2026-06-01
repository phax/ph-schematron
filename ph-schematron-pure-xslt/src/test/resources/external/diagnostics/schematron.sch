<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern>
    <rule context="book">
      <assert test="@isbn" diagnostics="d-isbn">Book is missing an ISBN.</assert>
    </rule>
  </pattern>
  <diagnostics>
    <diagnostic id="d-isbn">An ISBN attribute is required on every book element. Found title: '<value-of select="title"/>'</diagnostic>
  </diagnostics>
</schema>
