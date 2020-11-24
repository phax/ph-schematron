<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

   <sch:pattern id="ReservedWordFilter">

      <sch:p>These reserved words are not allowed anywhere in the
             document: SCRIPT, FUNCTION.</sch:p> 

      <sch:rule context="Document">

         <sch:assert test="count(//node()[contains(.,'SCRIPT')]) = 0
                           and
                           count(//node()[contains(.,'FUNCTION')]) = 0">
             The document must not contain the words SCRIPT or FUNCTION
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>