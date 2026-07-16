<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">
  <pattern>
    <rule context="/xml/owner">
      <let name="id" value="@id"/>
      <report test="count(/xml/car[@owner eq $id]) &gt; 1">Owner <value-of select="$id"/> has more than 1 car</report>
    </rule>
  </pattern>
</schema>
