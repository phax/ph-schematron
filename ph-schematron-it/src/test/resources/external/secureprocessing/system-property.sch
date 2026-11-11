<?xml version="1.0" encoding="UTF-8"?>
<!-- A no-namespace "system-property()" call must not expose a JVM system property. -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:title>No namespace system-property()</sch:title>
  <sch:pattern id="system-property">
    <sch:rule context="/root">
      <sch:assert test="string-length(system-property('user.dir')) &gt; 0">The JVM system property was exposed</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
