<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>Universal Tests</title>
  <p>This schema gives the most basic tests for checking an ISO Schematron implementation.
  It does not test the XPath implementation in any significant way, just the basics of assertions,
  rules, patterns, and phases. Use it to "validate" any WF XML document. </p>
  
  <p>The result of running this should be four assertion messages:
 U7, U8, U9, and U10 only.</p>
 
  <phase id="positive">
    <active pattern="p1" />
  </phase>
  
  <phase id="negative">
    <active pattern="p2" />
  </phase>
  
  <pattern id="p1">
     <title>Always True</title>
     
     <rule context="/"> 
     	<assert test="true()">U1: This assertion should never fail.</assert>
     	<report test="false()">U2: This report should never succeed.</report>
     </rule>
 
     <rule context="/*">
     	<assert test="true()">U3: This assertion should never fail.</assert>
     	<report test="false()">U4: This report should never succeed.</report>
     </rule> 
     
     <!-- Test rule fallthrough -->
     <rule context="/*">
     	<assert test="false()">U5: This assertion should never succeed because the rule should never fire.</assert>
     	<report test="true()">U6: This report should never succeed because the rule should never fire.</report>
     </rule> 
 
  </pattern>
  
  <pattern id="p2">
     <title>Always False</title>
     
     <rule context="/">
     	<assert test="false()">U7: This assertion should always fail.</assert>
     	<report test="true()">U8: This report should always succeed.</report>
     </rule>
     
     <rule context="/*">
     	<assert test="false()">U9: This assertion should always fail.</assert>
     	<report test="true()">U10: This report should always succeed.</report>
     </rule>
     
     <!-- Test rule fallthrough -->
     <rule context="/*">
     	<assert test="false()">U11: This assertion should never succeed because the rule should never fire.</assert>
     	<report test="true()">U12: This report should never succeed because the rule should never fire.</report>
     </rule> 
  </pattern>
  
</schema>
