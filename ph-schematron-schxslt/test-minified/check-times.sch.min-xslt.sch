<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

   <pattern>

      <p>An aircraft's takeoff datetime must be prior to its landing datetime.</p> 

      <rule context="Aircraft">

         <assert test="Takeoff lt Landing">
             An aircraft's takeoff datetime must come before its landing datetime
         </assert>

      </rule>

   </pattern>

</schema>
