<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  queryBinding="xslt2" schemaVersion="ISO19757-3">
  <sch:title>GitHub issue #6 test case</sch:title>

  <sch:pattern name="/Customer/ContactDetails">
    <sch:rule context="//Customer/ContactDetails">
      <sch:assert test="fn:current()/mobile">Mobile is missing</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 