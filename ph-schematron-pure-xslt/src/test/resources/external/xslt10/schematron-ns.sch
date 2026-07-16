<?xml version="1.0" encoding="UTF-8"?>
<!-- Namespaced variant - exercises the *[local-name()=... and namespace-uri()=...] path branch -->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">
  <ns prefix="m" uri="urn:example:lib"/>
  <pattern>
    <rule context="m:book">
      <assert test="@isbn">A book must have an @isbn attribute.</assert>
    </rule>
  </pattern>
</schema>
