<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
    <pattern>
        <rule context="tag1">
            <assert test="matches(tag2,'^[0-9]{4}$')">Invalid value</assert>
        </rule>
    </pattern>
</schema>