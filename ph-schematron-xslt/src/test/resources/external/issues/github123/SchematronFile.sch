<?xml version="1.0" encoding="utf-8"?>
<iso:schema queryBinding="xslt" xmlns:iso="http://purl.oclc.org/dsdl/schematron">
  <iso:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi" />
  <iso:ns uri="msg:ns" prefix="message" />
  <iso:pattern>
    <iso:rule context="//*[resolve-QName(@xsi:type,.)=QName('msg:line','Type')]/@id">
      <iso:assert test="matches(.,'^1')" diagnostics="R1-en">Rule on id attribute value must start with 1</iso:assert>
    </iso:rule>
    <iso:rule context="//*[resolve-QName(@xsi:type,.)=QName('msg:line','Type')]/idType">
      <iso:assert test="matches(.,'^1')" diagnostics="R2-en">Rule on node idType value must start with 1</iso:assert>
    </iso:rule>
  </iso:pattern>
  <iso:diagnostics>
    <iso:diagnostic xml:lang="en" id="R1-en">Rule on id attribute value must start with 1</iso:diagnostic>
    <iso:diagnostic xml:lang="en" id="R2-en">Rule on node idType value must start with 1</iso:diagnostic>
  </iso:diagnostics>
</iso:schema>
