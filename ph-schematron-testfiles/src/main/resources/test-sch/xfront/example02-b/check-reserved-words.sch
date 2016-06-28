<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

   <sch:pattern name="Reserved Word Filter (words from external document)">

      <sch:rule context="Para">

         <sch:assert test="count(.//node()[contains(., document('reserved-words-list.xml')/Reserved-Words/li[1])]) = 0">
             The Para element must not contain this reserved word
         </sch:assert>

         <sch:assert test="count(.//node()[contains(., document('reserved-words-list.xml')/Reserved-Words/li[2])]) = 0">
             The Para element must not contain this reserved word
         </sch:assert>

         <sch:assert test="count(.//node()[contains(., document('reserved-words-list.xml')/Reserved-Words/li[3])]) = 0">
             The Para element must not contain this reserved word
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>