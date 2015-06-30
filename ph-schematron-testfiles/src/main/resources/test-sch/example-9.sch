<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron" 
         xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
         xmlns:sch="http://www.ascc.net/xml/schematron"
         queryBinding='xslt2'
         schemaVersion="ISO19757-3">
  <iso:title>Test ISO schematron file. Introduction mode</iso:title>
  <!-- Not used in first run -->
  <iso:ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />

  <iso:pattern id="doc.checks">
    <!-- Abstract rule has no context -->
    <iso:rule abstract="true" id="abs.rule1" role="abs">
      <iso:assert test="@idref = id(@idref)"
           > the idref value [<iso:value-of 
            select='@idref'/>] has no matching target</iso:assert>
    </iso:rule>

    <iso:rule context='para[@idref]'>
      <!-- Effectively inserts all the assertions from the rule/@abs.rule1 -->
      <iso:extends rule="abs.rule1" />
    </iso:rule>
  </iso:pattern>  
</iso:schema>