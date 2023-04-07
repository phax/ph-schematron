<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">
    <sch:pattern>
        <sch:rule context="//title">
            <sch:report test="count(*)>0" flag="error">
                Do not use inline formatting in &lt;title&gt;
            </sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>