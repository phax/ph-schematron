<schema xmlns="http://purl.oclc.org/dsdl/schematron" xml:lang="de">
  <title>Example of a custom error role</title>
  <pattern>
    <rule context="dog">
      <assert test="bone" role="error"> A dog should have a bone.</assert>
      <assert test="xyz" role="info">Information only that xyz should be present.</assert>
    </rule>
  </pattern>
</schema>
