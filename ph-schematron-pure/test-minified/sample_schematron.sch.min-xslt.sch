<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">   
   <pattern id="sampleValidation">   
        <title>PatternTitle</title>
        <p>A paragraph</p>
        <rule context="CCC">
            <assert test="normalize-space(.) and *">Source contains an empty element</assert>
        </rule>  
   </pattern>
</schema>
