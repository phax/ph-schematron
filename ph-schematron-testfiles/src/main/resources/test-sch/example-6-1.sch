<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron" 
         xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
         xmlns:sch="http://www.ascc.net/xml/schematron"
         queryBinding='xslt2'
         schemaVersion="ISO19757-3"
         >
  <iso:title>Test ISO schematron file. Introduction mode </iso:title>

  <iso:ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />

<phase id="docs" >               
<active pattern="doc.checks"/>
</phase>

<phase id="chaps">               
  <active pattern="chap.checks"/>
</phase>
<iso:pattern id="doc.checks" >   
  <iso:title>checking an XXX document</iso:title>
  <iso:rule context="doc">
    <iso:report test="chapter">Report date.<iso:value-of 
                      select="fn:current-dateTime()"/></iso:report>
    <iso:report  test="title and isbn"
            >Report for book with ISBN <iso:value-of select="isbn"/></iso:report>
  </iso:rule>
</iso:pattern>

<iso:pattern   id="chap.checks">   
  <iso:title>Basic Chapter checks</iso:title>
  <iso:p>All chapter level checks. </iso:p>
  <iso:rule context="chapter">
    <iso:assert test="title">Chapter should have  a title</iso:assert>
    <iso:assert test="count(para) >= 1">A chapter must have one or more paragraphs</iso:assert>
    <iso:assert test="*[1][self::title]"><iso:name/>  must be have title as first child </iso:assert>
    <iso:assert test="@id">All chapters must have an ID attribute</iso:assert>
  </iso:rule>
</iso:pattern>
</iso:schema>