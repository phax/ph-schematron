<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:pattern id="p1000101">
    <sch:title>Rule title</sch:title>
    <sch:rule id="r1000101" fpi="BR-123" context="/doc/h1">
      <sch:assert fpi="BR123-1" flag="error" see="#/rules/1000101" test="@a='b'">Some error message here</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
