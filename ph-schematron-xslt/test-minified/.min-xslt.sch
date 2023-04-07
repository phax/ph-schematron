<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="m" uri="http://www.ociweb.com/movies" />
  <pattern name="all">
    <rule context="m:actor">
      <report diagnostics="duplicateActorRole" test="@role=preceding-sibling::m:actor/@role">
        Duplicate role!
      </report>
    </rule>
  </pattern>
  <diagnostics>
    <diagnostic id="duplicateActorRole">
      More than one actor plays the role<value-of select="@role" />.
      A duplicate is named<value-of select="@name" />.
    </diagnostic>
  </diagnostics>
</schema>
