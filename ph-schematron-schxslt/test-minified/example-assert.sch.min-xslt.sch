<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <title>Test ISO schematron file. Introduction mode</title>
  <!-- Not used in first run -->
  <ns prefix="dp" uri="http://www.dpawson.co.uk/ns#" />

 <pattern>
    <rule context="chapter">
      <assert diagnostics="a b" flag="any" fpi="fpi1" icon="abc" id="id1" see="see1" test="title" xml:lang="en" xml:space="preserve">
        Chapter should have  a title
      </assert>
    </rule>
  </pattern>

  <diagnostics>
    <diagnostic id="a">Descriptor A <value-of select="@id" />
</diagnostic>    
    <diagnostic id="b">Descriptor B <value-of select="@id" />
</diagnostic>    
  </diagnostics>
</schema>
