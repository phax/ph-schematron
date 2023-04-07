<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

   <phase id="classificationValidation">

      <p>Validate that the document's security classification policy is valid.</p>

       <active pattern="SCP" />

   </phase>

   <phase id="reservedWordValidation">

      <p>Validate that the document doesn't contain any reserved words.</p>

       <active pattern="RWF" />

   </phase>

   <pattern id="SCP">

      <p>A Para's classification value cannot be more sensitive 
         than the Document's classification value.</p> 

      <rule context="Para[@classification='top-secret']">

         <assert test="/Document/@classification='top-secret'">
             If there is a Para is labeled "top-secret" then the Document  
             should be labeled top-secret
         </assert>

      </rule>

      <rule context="Para[@classification='secret']">

         <assert test="(/Document/@classification='top-secret') or                            (/Document/@classification='secret')">
             If there is a Para is labeled "secret" then the Document  
             should be labeled either secret or top-secret
         </assert>

      </rule>

      <rule context="Para[@classification='confidential']">

         <assert test="(/Document/@classification='top-secret') or                            (/Document/@classification='secret') or                             (/Document/@classification='confidential')">
             If there is a Para is labeled "confidential" then the Document  
             should be labeled either confidential, secret or top-secret
         </assert>

      </rule>

   </pattern>

   <pattern id="RWF">

      <p>These reserved words are not allowed anywhere in the
         document: SCRIPT, FUNCTION.</p> 

      <rule context="Document">

         <assert test="count(//node()[contains(.,'SCRIPT')]) = 0                            and                            count(//node()[contains(.,'FUNCTION')]) = 0">
             The document must not contain the words SCRIPT or FUNCTION
         </assert>

      </rule>

   </pattern>

</schema>
