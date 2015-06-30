<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron" 
         xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
         xmlns:sch="http://www.ascc.net/xml/schematron"
         queryBinding='xslt2'
         schemaVersion="ISO19757-3">
  <iso:title>Test ISO schematron file. Introduction mode</iso:title>
  <!-- Not used in first run -->
  <iso:ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />

 <iso:pattern >
    <iso:rule context="chapter">
      <iso:assert test="title" 
                  flag="any"
                  id="id1"
                  diagnostics="a b"
                  icon="abc"
                  see="see1"
                  fpi="fpi1"
                  xml:lang="en"
                  xml:space="preserve">
        Chapter should have  a title
      </iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:diagnostics>
    <iso:diagnostic id="a">Descriptor A <iso:value-of select="@id"/></iso:diagnostic>    
    <iso:diagnostic id="b">Descriptor B <iso:value-of select="@id"/></iso:diagnostic>    
  </iso:diagnostics>
</iso:schema>