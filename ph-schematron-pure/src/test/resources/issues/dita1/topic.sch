<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

    <sch:let name="id" value="//*[1]/@id"/>

    <sch:pattern>
        
        <sch:rule context="title" role="warning">
            <sch:report test="b">
                [<sch:value-of select="$id"/>] Bold formatting in &lt;title> is not allowed.
            </sch:report>
        </sch:rule>
        
        <sch:rule context="title" role="warning">
            <sch:report test="image">
                [<sch:value-of select="$id"/>] &lt;image> in &lt;title> is not allowed.
            </sch:report>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>