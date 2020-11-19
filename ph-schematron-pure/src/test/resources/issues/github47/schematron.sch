<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="urn:anything"
  queryBinding="xslt2" schemaVersion="ISO19757-3">
  
  <sch:pattern name="Customer">
    <sch:rule context="/file/Customer">
      <sch:assert test="if (@xml:lang != 'en') then some $token in tokenize(base-uri(), '/') satisfies $token = @xml:lang else true()" role="fatal">
        The values of @xml:lang and the above language folder are not the same.
      </sch:assert>
      <sch:report test="node()[self::text()][matches(., '^\s')]" role="warning" sqf:fix="remove-leading-whitespace">
         The topic title must not start by a space.
      </sch:report>
    </sch:rule>
  </sch:pattern>
</sch:schema> 