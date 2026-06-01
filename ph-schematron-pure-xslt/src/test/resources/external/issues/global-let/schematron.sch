<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron"
	xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
	queryBinding="xslt2" 
	schemaVersion="ISO19757-3">
	<sch:title>bla</sch:title>

	<sch:pattern id="p1">
    <sch:let name="v1" value="('Hugo')" />
    <sch:rule context="/root/element1">
      <sch:assert test="false()">
        Element1 gefunden: <sch:value-of select="$v1" />
      </sch:assert>
      <sch:let name="v1" value="concat ($v1, 'Bla')" />
    </sch:rule>
    <sch:rule context="/root/element2">
      <sch:assert test="false()">
        Element2 gefunden: <sch:value-of select="$v1" />
      </sch:assert>
    </sch:rule>
	</sch:pattern>
</sch:schema> 