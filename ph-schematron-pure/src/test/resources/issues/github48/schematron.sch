<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  queryBinding="xslt2">
  
  <sch:pattern is-a="requiredAttribute">
    <sch:param name="context" value="Customer"/>
    <sch:param name="attribute" value="@type"/>
  </sch:pattern>
  
  <sch:pattern abstract="true" id="requiredAttribute">
    <sch:title>Required Attributes</sch:title>
    <sch:rule context="$context">
      <sch:assert test="string-length($attribute) &gt; 0">
        The <sch:name/> element should have a
       <sch:value-of select="$attribute/name()"/> attribute.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 