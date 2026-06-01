<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <title>Length check</title>
  <include href="abstract.sch"/>

  <pattern id="length-checks">
    <rule context="X">
      <extends rule="lengthCheck"/>
    </rule>
    <rule context="Y">
      <extends rule="lengthCheck"/>
    </rule>
  </pattern>

  <pattern id="structure">
    <rule context="simple">
      <assert test="Z" diagnostics="d1">
        Does not contain Z element
      </assert>
    </rule>
  </pattern>

  <diagnostics>
    <diagnostic id="d1">
      Diagnostic d1 <value-of select="title"/>
    </diagnostic>
  </diagnostics>
</schema>