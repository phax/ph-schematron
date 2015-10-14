<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <title>Length check</title>
  <pattern name="AbstractRules" id="abstracts">
    <rule abstract="true" id="lengthCheck">
      <assert test="string-length(A) &lt;=10">
        A exceeds 10 characters
      </assert>
      <assert test="string-length(B) &lt;=5">
        B exceeds 5 characters
      </assert>
    </rule>
  </pattern>

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