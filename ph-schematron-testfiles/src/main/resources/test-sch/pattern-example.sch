<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:pattern abstract="true" id="table">
        <sch:rule context="$table">
            <sch:assert test="$row">
            The element <sch:name/> is a table. Tables contain rows.
            </sch:assert>
        </sch:rule>
        <sch:rule context="$row">
            <sch:assert test="$entry">
            The element <sch:name/> is a table row. Rows contain entries.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern is-a="table" id="HTML_Table">
        <sch:param name="table" value="table"/>
        <sch:param name="row"   value="tr"/>
        <sch:param name="entry" value="td|th"/>
    </sch:pattern>
    <sch:pattern is-a="table" id="CALS_Table">
        <sch:param name="table" value="table"/>
        <sch:param name="row"   value=".//row"/>
        <sch:param name="entry" value="cell"/>
    </sch:pattern>
    <sch:pattern is-a="table" id="calendar">
        <sch:param name="table" value="calendar/year"/>
        <sch:param name="row"   value="week"/>
        <sch:param name="entry" value="day"/>
    </sch:pattern>       
</sch:schema>
