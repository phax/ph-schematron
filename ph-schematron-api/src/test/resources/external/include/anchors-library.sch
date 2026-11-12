<?xml version="1.0" encoding="UTF-8"?>
<library xmlns="http://purl.oclc.org/dsdl/schematron">
  <pattern id="p1">
    <rule context="a">
      <assert test="@x">a misses x</assert>
    </rule>
  </pattern>
  <pattern id="p2">
    <rule context="b">
      <assert test="@y">b misses y</assert>
    </rule>
  </pattern>
</library>
