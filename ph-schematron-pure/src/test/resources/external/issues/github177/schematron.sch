<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">
  <pattern>
    <let name="var" value="1"/>
    <let name="var-plus-one" value="$var + 1"/>

    <rule context="/a">
      <assert role="ERROR" test="$var-plus-one = 2">error message</assert>
    </rule>
  </pattern>
</schema>
