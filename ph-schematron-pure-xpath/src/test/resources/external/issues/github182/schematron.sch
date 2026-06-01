<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">
  <let name="var" value="/a/var/text()"/>
  <pattern>
    <rule context="/a/b/c[$var = 'A']">
      <assert role="ERROR" test=". = $var">error message 1</assert>
    </rule>
    <rule context="/a/b/c[$var = 'B']">
      <assert role="ERROR" test=". = $var">error message 1</assert>
    </rule>
  </pattern>
</schema>
