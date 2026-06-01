<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern id="p1">
    <rule context="book">
      <assert test="@isbn">A book must have an ISBN attribute.</assert>
    </rule>
    <rule context="author">
      <assert test="string-length(name) ge 1">An author must have a non-empty name.</assert>
    </rule>
  </pattern>
  <pattern id="p2">
    <rule context="library">
      <assert test="count(book) ge 1">A library must have at least one book.</assert>
    </rule>
  </pattern>
</schema>
