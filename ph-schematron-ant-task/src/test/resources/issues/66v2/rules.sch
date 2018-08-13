<schema xmlns="http://purl.oclc.org/dsdl/schematron" xml:lang="de">
  <title>Example of a custom error role</title>
  <pattern>
    <rule context="dog">
      <report test="not(bone)" role="bar"> A dog should have a bone.</report>
      <report test="not(xyz)" role="info">Information only that xyz should be present.</report>
    </rule>
  </pattern>
</schema>
