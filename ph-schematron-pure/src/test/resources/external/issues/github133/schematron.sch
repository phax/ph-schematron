<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xml:lang="de">
  <sch:title>Simple</sch:title>
  <sch:pattern>
    <sch:rule context="dog">
      <sch:assert test="bone" subject="any dog">A dog should <sch:span class="whatever">have a bone</sch:span>.</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
