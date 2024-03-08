<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:sqf="urn:anything"
  queryBinding="xslt2" schemaVersion="ISO19757-3">  
  <ns prefix="html" uri="http://www.w3.org/1999/xhtml" />
  <sch:title>Schematron 1</sch:title>
  <sch:pattern>
    <sch:rule context="html:title"> 
          <sch:assert role = "error" test = "matches(.,'^Legal.*')"><html:b>Title should start with Legal</html:b></sch:assert>
    </sch:rule>
    <sch:rule context="html:shortdesc">
        <sch:let name="characters" value="string-length(.)"/>
        <sch:assert role="info" test="$characters &lt; 10"> 
        You have <sch:value-of select="$characters"/> characters. Short Description characters should be less than 10.       
        </sch:assert>  
    </sch:rule>
  </sch:pattern>
</sch:schema>