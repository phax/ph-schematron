<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

   <pattern>

      <p>These reserved words are not allowed anywhere in the
             document: SCRIPT, FUNCTION.</p> 

      <rule context="Document">

         <assert test="count(//node()[contains(.,'SCRIPT')]) = 0">
             The document must not contain the word SCRIPT
         </assert>

         <assert test="count(//node()[contains(.,'FUNCTION')]) = 0">
             The document must not contain the word FUNCTION
         </assert>

      </rule>

   </pattern>

</schema>
