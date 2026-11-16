<?xml version="1.0" encoding="UTF-8"?>
<rule xmlns="http://purl.oclc.org/dsdl/schematron" context="a">
  <assert test="@x">a misses x</assert>
  <include href="cyclic-pattern.sch"/>
</rule>
