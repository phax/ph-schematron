<?xml version="1.0" encoding="UTF-8"?>
<!--
  SchXslt2 adds xml:lang to a failed assert or successful report whose
  language differs from the one of the schema. Use together with
  schxslt-svrl-extensions.xml.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt2"
        xml:lang="en">
  <pattern>
    <rule context="/root">
      <assert id="A1" test="b">There must be a b</assert>
      <report id="S1" test="a" xml:lang="de">Es gibt ein a</report>
    </rule>
  </pattern>
</schema>
