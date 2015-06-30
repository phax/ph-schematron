<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:include href="pattern-example-with-includes.incl" />
    
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
