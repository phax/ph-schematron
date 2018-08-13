<schema xmlns="http://purl.oclc.org/dsdl/schematron" xml:lang="de">
  <title>Example of a custom error role</title>
  <pattern>
    <rule context="dog">
      <report test="not(xyz)" role="info">Information only that xyz should be present.</report>
      <report test="not(bone)" role="bar"> A dog should have a bone.</report>
    </rule>
  </pattern>
</schema>
