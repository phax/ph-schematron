<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <let name="topLevel" value="foo"/>
  <pattern id="a1">
    <let name="inPattern" value="foo"/>
    <rule context="/*[$topLevel = 'foo']">
      <assert role="ERROR" test="$topLevel = $inPattern">message</assert>
    </rule>
    <rule context="/*[$inPattern = 'foo']">
      <assert role="ERROR" test="$topLevel = $inPattern">message</assert>
    </rule>
  </pattern>
</schema>