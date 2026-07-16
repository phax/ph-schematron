<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
    xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
    queryBinding="xslt2"
    xmlns="http://purl.oclc.org/dsdl/schematron" >   
   <sch:pattern id="sampleValidation">   
        <sch:title>PatternTitle</sch:title>
        <sch:p>A paragraph</sch:p>
        <sch:rule context="CCC">
            <assert test="normalize-space(.) and *">Source contains an empty element</assert>
        </sch:rule>  
   </sch:pattern>
</sch:schema>