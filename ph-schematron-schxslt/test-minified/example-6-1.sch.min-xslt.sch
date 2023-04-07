<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <title>Test ISO schematron file. Introduction mode </title>

  <ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />

<phase id="docs">               
<active pattern="doc.checks" />
</phase>

<phase id="chaps">               
  <active pattern="chap.checks" />
</phase>
<pattern id="doc.checks">   
  <title>checking an XXX document</title>
  <rule context="doc">
    <report test="chapter">Report date.<value-of select="fn:current-dateTime()" />
</report>
    <report test="title and isbn">Report for book with ISBN <value-of select="isbn" />
</report>
  </rule>
</pattern>

<pattern id="chap.checks">   
  <title>Basic Chapter checks</title>
  <p>All chapter level checks. </p>
  <rule context="chapter">
    <assert test="title">Chapter should have  a title</assert>
    <assert test="count(para) >= 1">A chapter must have one or more paragraphs</assert>
    <assert test="*[1][self::title]">
        <name />  must be have title as first child       </assert>
    <assert test="@id">All chapters must have an ID attribute</assert>
  </rule>
</pattern>
</schema>
