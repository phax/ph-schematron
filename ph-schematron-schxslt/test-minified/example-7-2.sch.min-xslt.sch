<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <title>Test ISO schematron file. Introduction mode </title>
  <ns prefix="xlink" uri="http://www.w3.org/1999/xlink" />  

<!-- Define the key, anything in the xsl ns is copied through -->
<ns0:key xmlns:ns0="http://www.w3.org/1999/XSL/Transform" match="a" name="href" use="@xlink:href" />             


<pattern id="name.checks">
  <title>Check for id names and linked names which are the same, excluding extension</title>
  <rule context="chapter[@xml:id]">
    <assert test="true()">Warning.   
    if chapter id value is used as html filename, there
    will be a conflict with <value-of select="@xml:id" />.html
    </assert>
  </rule>
</pattern>
</schema>
