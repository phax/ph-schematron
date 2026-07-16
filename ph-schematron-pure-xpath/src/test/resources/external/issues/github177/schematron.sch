<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">
  <pattern>
    <let name="var" value="1"/>
    <let name="var-plus-one" value="$var + 1"/>

    <rule context="/a">
      <assert role="ERROR" test="$var-plus-one = 2">error message 1</assert>
    </rule>
  </pattern>
  <pattern>
    <let name="var-one" value="1"/>
    <let name="var" value="$var-one + 1"/>

    <rule context="/a">
      <assert role="ERROR" test="$var = 2">error message 2</assert>
    </rule>
  </pattern>
  <pattern>
    <let name="var" value="1"/>
    <let name="var-x" value="2"/>
    <let name="var-x-y" value="$var + $var-x +1"/>

    <rule context="/a">
      <assert role="ERROR" test="$var-x-y = 4">error message 3</assert>
    </rule>
  </pattern>
</schema>
