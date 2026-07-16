<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron"
	xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	queryBinding="xslt2" 
	schemaVersion="ISO19757-3">
	<sch:title>ISO schematron validation file for descriptive extended
		constraints</sch:title>

	<xsl:key name="keyTitles"
		match="//DataSets/DataSet[@Name='Books']/Property/Property[@Name='Title']"
		use="@Value" />
	<sch:pattern id="CheckBooks_UniqueTitle">
		<sch:rule context="//DataSets/DataSet[@Name='Books']/Property">
			<sch:assert test="count(key('keyTitles',Property/@Value)) = 1"
				role="warning">
				Warning: Titles should be unique.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
</sch:schema> 