<?xml version="1.0" encoding="UTF-8"?>
<!-- The "document()" call must not trigger an outbound network request.
     Port 1 is used, so that a regression fails fast instead of hanging. -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:title>Remote document() access</sch:title>
  <sch:pattern id="remote-document">
    <sch:rule context="/root">
      <sch:assert test="count(document('http://localhost:1/blocked.xml')//*) &gt; 0">The remote document was resolved</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
