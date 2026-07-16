<?xml version="1.0" encoding="UTF-8"?>
<!-- Pure XPath 1.0 Schematron so the generated stylesheet runs on a genuine XSLT 1.0 processor -->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">
  <pattern>
    <rule context="book">
      <assert test="@isbn">A book must have an @isbn attribute.</assert>
    </rule>
  </pattern>
</schema>
