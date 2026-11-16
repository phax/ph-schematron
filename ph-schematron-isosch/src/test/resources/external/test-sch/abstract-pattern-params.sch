<?xml version="1.0" encoding="UTF-8"?>
<!-- Abstract pattern with parameters in @context, @test and text, expanded by iso_abstract_expand.xsl -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:pattern abstract="true" id="limit">
    <sch:rule context="$parent/$child">
      <sch:assert id="limit-max" test="number(.) le $max">$child in $parent must not exceed $max ($child)</sch:assert>
      <sch:assert id="limit-static" test="string-length(.) gt 0">Static text</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern is-a="limit" id="price">
    <sch:param name="parent" value="order"/>
    <sch:param name="child" value="price"/>
    <sch:param name="max" value="100"/>
  </sch:pattern>

  <sch:pattern is-a="limit" id="qty">
    <sch:param name="parent" value="order"/>
    <sch:param name="child" value="qty"/>
    <sch:param name="max" value="5"/>
  </sch:pattern>
</sch:schema>
