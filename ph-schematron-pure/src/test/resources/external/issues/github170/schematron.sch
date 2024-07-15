<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">
  <pattern>
    <rule context="/xml">
      <let name="stringVar" value="'foo'"/>
      <rule context="/*">
        <assert role="ERROR" test="$stringVar eq 'bar'">error message</assert>
      </rule>
    </rule>
    <rule context="/xml/owner">
    <let name="booleanVar" value="1 eq 1"/>
      <assert role="ERROR" test="$booleanVar eq true()">error message</assert>
    </rule>
  </pattern>
</schema>
