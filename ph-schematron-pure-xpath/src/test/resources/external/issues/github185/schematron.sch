<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
        queryBinding="xslt2">
    <title>EN16931 model bound to UBL</title>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>

    <pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="Check-Country">
        <let name="ISO-3166-RO-CODES" value="('AA','BB','BT','RO-CT','RO-BC')"/>
        <rule context="/ubl:Invoice">
            <report test="not(normalize-space(cbc:Country) = ('AA','BB','BT','RO-CT','RO-BC'))"
                    flag="fatal"
                    id="REG1">
                Error Entity1
            </report>
            <report test="not(normalize-space(cbc:Country) = $ISO-3166-RO-CODES)"
                    flag="fatal"
                    id="REG2">
                Error entity2
            </report>
        </rule>
    </pattern>
</schema>