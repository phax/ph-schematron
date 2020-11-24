<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />

   <sch:pattern>

      <sch:rule context="Para">

         <sch:assert test="count(.//node()[contains(., fn:doc('reserved-words-list.xml')/Reserved-Words/li[1])]) = 0">
             The Para element must not contain this reserved word
         </sch:assert>

         <sch:assert test="count(.//node()[contains(., fn:doc('reserved-words-list.xml')/Reserved-Words/li[2])]) = 0">
             The Para element must not contain this reserved word
         </sch:assert>

         <sch:assert test="count(.//node()[contains(., fn:doc('reserved-words-list.xml')/Reserved-Words/li[3])]) = 0">
             The Para element must not contain this reserved word
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>