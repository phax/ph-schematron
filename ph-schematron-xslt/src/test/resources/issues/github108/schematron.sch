<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

    <sch:pattern>
        <sch:rule context="*[matches(local-name(), '^h\d+$')]">
            <sch:let
                name="level"
                value="number(replace(local-name(.), 'h', ''))"/>
            <sch:let 
                name="preceding-head"
                value="./preceding-sibling::*[matches(local-name(.), '^h\d+$')][1]"></sch:let>
            <sch:let
                name="preceding-level"
                value="if (exists($preceding-head)) then number(replace(local-name($preceding-head), 'h', '')) else 0"/>
            <sch:report
                test="($level - $preceding-level > 1)"
                >Missing headline level: Level <sch:value-of select="$level"/> follows on level <sch:value-of select="$preceding-level"/></sch:report>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>