<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    
    <pattern id="HTML_Table">
        <rule context="table">
            <assert test="tr">
            The element <name /> is a table. Tables contain rows.
            </assert>
        </rule>
        <rule context="tr">
            <assert test="td|th">
            The element <name /> is a table row. Rows contain entries.
            </assert>
        </rule>
    </pattern>
    <pattern id="CALS_Table">
        <rule context="table">
            <assert test="row">
            The element <name /> is a table. Tables contain rows.
            </assert>
        </rule>
        <rule context="row">
            <assert test="cell">
            The element <name /> is a table row. Rows contain entries.
            </assert>
        </rule>
    </pattern>
    <pattern id="calendar">
        <rule context="calendar/year">
            <assert test="week">
            The element <name /> is a table. Tables contain rows.
            </assert>
        </rule>
        <rule context="week">
            <assert test="day">
            The element <name /> is a table row. Rows contain entries.
            </assert>
        </rule>
    </pattern>       
</schema>
