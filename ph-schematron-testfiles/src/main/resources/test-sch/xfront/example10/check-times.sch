<?xml version="1.0"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

   <sch:pattern>

      <sch:p>An aircraft's takeoff datetime must be prior to its landing datetime.</sch:p> 

      <sch:rule context="Aircraft">

         <sch:assert test="Takeoff lt Landing">
             An aircraft's takeoff datetime must come before its landing datetime
         </sch:assert>

      </sch:rule>

   </sch:pattern>

</sch:schema>