<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron" 
         xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
         xmlns:xlink="http://www.w3.org/1999/xlink"         
         xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
         queryBinding='xslt2'
         schemaVersion="ISO19757-3">
  <iso:title>Test ISO schematron file. Introduction mode </iso:title>
  <iso:ns prefix='xlink' uri="http://www.w3.org/1999/xlink"/>  

<!-- Define the key, anything in the xsl ns is copied through -->
<xsl:key name="href" match="a" use="@xlink:href"/>             


<iso:pattern id="name.checks">
  <iso:title>Check for id names and linked names which are the same, excluding extension</iso:title>
  <iso:rule context="chapter[@xml:id]">
    <iso:assert test="true()">Warning.   
    if chapter id value is used as html filename, there
    will be a conflict with <iso:value-of select="@xml:id"/>.html
    </iso:assert>
  </iso:rule>
</iso:pattern>
</iso:schema>
