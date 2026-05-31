<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern abstract="true" id="hasRequiredAttribute">
    <rule context="$ctx">
      <assert test="@$attr">Element '$ctx' must have a '$attr' attribute.</assert>
    </rule>
  </pattern>
  <pattern is-a="hasRequiredAttribute" id="bookIsbn">
    <param name="ctx" value="book"/>
    <param name="attr" value="isbn"/>
  </pattern>
  <pattern is-a="hasRequiredAttribute" id="authorName">
    <param name="ctx" value="author"/>
    <param name="attr" value="name"/>
  </pattern>
</schema>
