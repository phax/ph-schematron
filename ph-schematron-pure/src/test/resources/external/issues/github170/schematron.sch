<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">
  <pattern>
    <rule context="/xml/owner">
      <let name="stringVar" value="'foo'"/>
      <let name="booleanVar" value="1 eq 1"/>
      <let name="booleanVar2" value="true()"/>
      <let name="numVar" value="123"/>
      <let name="doubleVar" value="12.345"/>
      <let name="listVar" value="(1,2,3)"/>
      <let name="nodeVar" value="."/>
      <let name="nodeSetVar" value="//owner"/>
      <assert role="ERROR" test="$stringVar = 'bar'">error message</assert>
      <assert role="ERROR" test="$booleanVar = false()">error message</assert>
      <assert role="ERROR" test="$booleanVar2 = false()">error message</assert>
      <assert role="ERROR" test="$numVar = 17">error message</assert>
      <assert role="ERROR" test="$doubleVar = 3.14">error message</assert>
      <assert role="ERROR" test="$listVar = (1, 2)">error message</assert>
      <assert role="ERROR" test="$nodeVar = ..">error message</assert>
      <assert role="ERROR" test="$nodeSetVar = ../owner">error message</assert>
    </rule>
  </pattern>
</schema>
