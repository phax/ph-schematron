<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <title>Test ISO schematron file. Introduction mode</title>
  <!-- Not used in first run -->
  <ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />

  <pattern id="doc.checks">
    <!-- Abstract rule has no context -->
    

    <rule context="para[@idref]">
      <!-- Effectively inserts all the assertions from the rule/@abs.rule1 -->
      
      <assert test="@idref = id(@idref)"> the idref value [<value-of select="@idref" />] has no matching target</assert>
    
    </rule>
  </pattern>  
</schema>
