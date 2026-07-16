<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" defaultPhase="strict">
  <phase id="lenient">
    <active pattern="p-isbn"/>
  </phase>
  <phase id="strict">
    <active pattern="p-isbn"/>
    <active pattern="p-author"/>
  </phase>
  <pattern id="p-isbn">
    <rule context="book">
      <assert test="@isbn">Book must have an ISBN.</assert>
    </rule>
  </pattern>
  <pattern id="p-author">
    <rule context="book">
      <assert test="author">Book must have an author.</assert>
    </rule>
  </pattern>
</schema>
