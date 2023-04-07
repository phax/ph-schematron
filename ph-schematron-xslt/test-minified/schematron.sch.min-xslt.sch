<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
	<title>ISO schematron validation file for descriptive extended
		constraints</title>

	<ns0:key xmlns:ns0="http://www.w3.org/1999/XSL/Transform" match="//DataSets/DataSet[@Name='Books']/Property/Property[@Name='Title']" name="keyTitles" use="@Value" />
	<pattern id="CheckBooks_UniqueTitle">
		<rule context="//DataSets/DataSet[@Name='Books']/Property">
			<assert role="warning" test="count(key('keyTitles',Property/@Value)) = 1">
				Warning: Titles should be unique.
			</assert>
		</rule>
	</pattern>
</schema>
