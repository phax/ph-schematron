<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xml:lang="de" xmlns:cat="urn:mydog:dummy">
  <sch:title>Example of Multi-Lingual Schema</sch:title>
  <sch:ns prefix="cat" uri="urn:mydog:dummy" />
  <sch:pattern>
    <sch:rule context="cat:dog">
      <sch:assert test="cat:bone" diagnostics="d1 d2">A dog should have a bone.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:diagnostics>
    <sch:diagnostic id="d1" xml:lang="en" xml:space="preserve" fpi="17" see="other" foo="bar"> A dog should have a bone.</sch:diagnostic>
    <sch:diagnostic id="d2" xml:lang="de"> Ein Hund muss ein Bein haben.</sch:diagnostic>
  </sch:diagnostics>
</sch:schema>
