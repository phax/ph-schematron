<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" 
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:u="utils"
            xmlns:java="http://some.namespace.com"
            queryBinding="xslt2"
            schemaVersion="ISO19757-3">
  <sch:title>ISO schematron validation file for descriptive extended constraints</sch:title>

  <!-- Example for an XSLT function used -->
  <sch:ns uri="utils" prefix="u"/>

  <!-- Example for a Java function used -->
  <sch:ns uri="http://some.namespace.com" prefix="java"/>

  <function xmlns="http://www.w3.org/1999/XSL/Transform"
            name="u:mul2"
            as="xs:integer">
    <param name="val"/>
    <value-of select="number($val) * 2"/>
  </function>
     
  <sch:pattern name="any">
    <sch:rule context="/file/Customer/age">
      <!-- Test inline XSLT function -->
      <sch:assert test="u:mul2(normalize-space()) >= 18">Double the age must be at least be 18 but is <sch:value-of select="u:mul2(normalize-space())" /></sch:assert>
      
      <!-- Test calling of Java function -->
      <sch:assert test="false">This is supposed to fail. Message from Java: <sch:value-of select="java:test()" /></sch:assert>
      <sch:assert test="java:mul3(.) >= 27">Triple the age must be at least be 27 but is <sch:value-of select="java:mul3(.)" /></sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 