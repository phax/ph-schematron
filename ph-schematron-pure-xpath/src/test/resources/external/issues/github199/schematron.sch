<?xml version="1.0" encoding="UTF-8"?>
<!--
  Reduced test case for https://github.com/phax/ph-schematron/issues/199
  A <let> variable holding a sequence of atomic values must stay a sequence when it is
  referenced from another <let> or from a test. From v8.0.0 to v9.1.1 such a sequence was
  collapsed into a single value, so count() always returned 1.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">
  <pattern>
    <rule context="/root">
      <let name="index" value="a/@index"/>
      <let name="distinctIndex" value="distinct-values($index)"/>
      <let name="tokenized" value="tokenize(@list, ',')"/>
      <let name="doubled" value="for $i in $index return xs:integer($i) * 2"/>

      <assert test="count($distinctIndex) = 2">Expected $distinctIndex to have size 2 but was <value-of select="string-join($distinctIndex, ',')"/></assert>
      <assert test="count($tokenized) = 3">Expected $tokenized to have size 3 but was <value-of select="string-join($tokenized, ',')"/></assert>
      <assert test="count($doubled) = 3">Expected $doubled to have size 3 but was <value-of select="string-join(for $i in $doubled return string($i), ',')"/></assert>
    </rule>
  </pattern>
</schema>
