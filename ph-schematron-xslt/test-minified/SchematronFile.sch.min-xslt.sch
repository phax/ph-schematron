<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">
  <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance" />
  <ns prefix="message" uri="msg:ns" />
  <pattern>
    <rule context="//*[resolve-QName(@xsi:type,.)=QName('msg:line','Type')]/@id">
      <assert diagnostics="R1-en" test="matches(.,'^1')">Rule on id attribute value must start with 1</assert>
    </rule>
    <rule context="//*[resolve-QName(@xsi:type,.)=QName('msg:line','Type')]/idType">
      <assert diagnostics="R2-en" test="matches(.,'^1')">Rule on node idType value must start with 1</assert>
    </rule>
  </pattern>
  <diagnostics>
    <diagnostic id="R1-en" xml:lang="en">Rule on id attribute value must start with 1</diagnostic>
    <diagnostic id="R2-en" xml:lang="en">Rule on node idType value must start with 1</diagnostic>
  </diagnostics>
</schema>
