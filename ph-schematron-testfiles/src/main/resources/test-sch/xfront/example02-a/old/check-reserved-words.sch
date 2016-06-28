<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

   <sch:pattern name="Reserved Word Filter">

      <sch:p>These reserved words are not allowed anywhere in the
             document: SCRIPT, FUNCTION.</sch:p> 

      <sch:rule context="node()[contains(.,'SCRIPT')][not(child::node())]">

         <sch:assert test="not(contains(.,'SCRIPT'))">
             The document must not contain the word SCRIPT
         </sch:assert>

      </sch:rule>

      <sch:rule context="node()[contains(.,'FUNCTION')][not(child::node())]">

         <sch:assert test="not(contains(.,'FUNCTION'))">
             The document must not contain the word FUNCTION
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>