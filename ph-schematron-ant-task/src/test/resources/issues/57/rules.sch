<schema xmlns="http://purl.oclc.org/dsdl/schematron" xml:lang="de">
  <title>Example of Multi-Lingual Schema</title>
  <pattern>
    <rule context="dog" role="error" flag="wat">
      <assert test="bone" role="info" flag="error" diagnostics="d1" see="http://example.org" fpi="1.2"> A dog should have a bone.</assert>
    </rule>
  </pattern>
  <diagnostics>
    <diagnostic id="d1" xml:lang="en" see="http://example.org" fpi="1.2"> There was no bone.</diagnostic>
    <diagnostic id="d2" xml:lang="de"> Das  Hund muss ein Bein haben.</diagnostic>
  </diagnostics>
</schema>
