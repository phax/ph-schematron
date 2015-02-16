<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink">
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  
  <sch:pattern name="Every file is referenced to one doc">
    <sch:rule context="file">
      <sch:let name="current" value="."/>
      <sch:assert test="count(//reference[@To_File = $current/@Id]) = 1">file is not referenced once</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>