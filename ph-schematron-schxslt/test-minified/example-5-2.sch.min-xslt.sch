<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="Rev 1.6">
  <title>Test ISO schematron file. Introduction mode </title>

  <ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />

<pattern id="doc.checks">
  <title>checking an XXX document</title>
  <rule context="doc">
    <report test="chapter">Report date.<value-of select="fn:current-dateTime()" />
</report>
  </rule>
</pattern>

  <pattern id="chapter.checks">
    <title>Basic Chapter checks</title>
    <p>All chapter level checks. </p>
    <rule context="chapter">
      <assert test="title">Chapter should have  a title</assert>
      <assert test="count(para) >= 1">Chapters must have more than 1 paragraph</assert>
      <assert test="*[1][self::title]">Title must be first child of chapter</assert>
      <assert test="@id">All chapters must have an ID attribute</assert>
      <assert diagnostics="desc.diag" test="desc">Descriptor</assert>    
    </rule>
  </pattern>


<diagnostics>
  <diagnostic id="desc.diag">Descriptor missing from 
   chapter <value-of select="@id" />
</diagnostic>    
</diagnostics>
</schema>
