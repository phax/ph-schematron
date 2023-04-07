<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

   <pattern>

      <p>A Para's classification value cannot be more sensitive 
             than the Document's classification value.</p> 

      <rule context="Para[@classification='top-secret']">

         <assert test="/Document/@classification='top-secret'">
             If there is a Para labeled "top-secret" then the Document  
             must be labeled top-secret
         </assert>

      </rule>

      <rule context="Para[@classification='secret']">

         <assert test="(/Document/@classification='top-secret') or                            (/Document/@classification='secret')">
             If there is a Para labeled "secret" then the Document  
             must be labeled either secret or top-secret
         </assert>

      </rule>

      <rule context="Para[@classification='confidential']">

         <assert test="(/Document/@classification='top-secret') or                            (/Document/@classification='secret') or                             (/Document/@classification='confidential')">
             If there is a Para labeled "confidential" then the Document  
             must be labeled either confidential, secret or top-secret
         </assert>

      </rule>

   </pattern>

   <pattern> 

      <rule context="*[@classification]">

         <assert test="@classification='top-secret' or                            @classification='secret' or                            @classification='confidential' or                            @classification='unclassified'">
             The value of a classification must be one of top-secret,
             secret, confidential, or unclassified.
         </assert>

      </rule>

   </pattern>

</schema>
