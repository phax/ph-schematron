<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:pattern>
    <sch:rule context="comment()">
      <sch:assert test="false()">Found a comment</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>