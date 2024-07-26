<?xml version="1.0" encoding="utf-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt2">
 <pattern>
     <rule context="ID">
         <assert test="string-length(.) &gt; 9">Something with chars.</assert>
     </rule>
 </pattern>

</schema>