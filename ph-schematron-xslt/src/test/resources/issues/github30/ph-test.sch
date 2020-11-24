<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!DOCTYPE schema [
<!ENTITY ent-ph-sss SYSTEM 'ph-sss.ent'>
]>
   <schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cda="urn:hl7-org:v3" queryBinding="xslt2">
   <title>PHMR 1.1</title>
   <ns prefix="cda" uri="urn:hl7-org:v3"/>
   <ns prefix="sdtc" uri="urn:hl7-org:sdtc"/>
   <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>

   <phase id='errors'>
      <active pattern='p-ph-sss-errors'/>

   </phase>

   <phase id='warning'>
      <active pattern='p-ph-sss-warnings'/>
   </phase>

   <phase id='note'>
      <active pattern='p-ph-sss-notes'/>
   </phase>
   &ent-ph-sss;
</schema>
