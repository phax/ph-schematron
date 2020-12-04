<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  queryBinding="xslt2" schemaVersion="ISO19757-3">
  <sch:title>ISO schematron validation file for descriptive extended constraints</sch:title>

  <sch:pattern>
    <sch:rule context="/">
      <sch:report test="true()" diagnostics="d1" />
    </sch:rule>
  </sch:pattern>
  <sch:diagnostics>
    <sch:diagnostic id="d1" xml:lang="de">Foobar</sch:diagnostic>
  </sch:diagnostics>
    
</sch:schema> 