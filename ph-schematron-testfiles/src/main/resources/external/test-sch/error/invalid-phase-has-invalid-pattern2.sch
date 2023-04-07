<schema xmlns="http://purl.oclc.org/dsdl/schematron" defaultPhase="phase1">
  <phase id="phase1">
    <active pattern="not-existing" />
  </phase>
  <pattern>
    <rule context='para[@idref]'>
      <assert test="count(.) > 0">Bla</assert>
    </rule>
  </pattern>  
</schema>
