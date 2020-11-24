<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

   <sch:pattern id="SecurityClassificationPolicy">

      <sch:p>A Para's classification value cannot be more sensitive 
         than the Document's classification value.</sch:p> 

      <sch:rule context="Para[@classification='top-secret']">

         <sch:assert test="/Document/@classification='top-secret'" diagnostics="invalid-security-label">
             If there is a Para is labeled "top-secret" then the Document  
             should be labeled top-secret
         </sch:assert>

      </sch:rule>

      <sch:rule context="Para[@classification='secret']">

         <sch:assert test="(/Document/@classification='top-secret') or
                           (/Document/@classification='secret')" diagnostics="invalid-security-label">
             If there is a Para is labeled "secret" then the Document  
             should be labeled either secret or top-secret
         </sch:assert>

      </sch:rule>

      <sch:rule context="Para[@classification='confidential']">

         <sch:assert test="(/Document/@classification='top-secret') or
                           (/Document/@classification='secret') or 
                           (/Document/@classification='confidential')" diagnostics="invalid-security-label">
             If there is a Para is labeled "confidential" then the Document  
             should be labeled either confidential, secret or top-secret
         </sch:assert>

      </sch:rule>

   </sch:pattern>

   <sch:diagnostics>

      <sch:diagnostic id="invalid-security-label">
           Your document does not meet the Security Classification Policy. Your Para has a security
           label of <sch:value-of select="./@classification"/>, which has a higher sensitivity than the document's
           sensitivity: <sch:value-of select="/Document/@classification"/>
      </sch:diagnostic>

   </sch:diagnostics>

</sch:schema>