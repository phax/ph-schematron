<?xml version="1.0" encoding="utf-8"?>
<iso:schema xmlns="http://purl.oclc.org/dsdl/schematron" 
    xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
    xmlns:ppn="http://ppn.lspi.uni-bamberg.de" 
    queryBinding="xpath2" schemaVersion="ISO19757-3">
    <iso:title>ISO schematron validation file for descriptive extended constraints</iso:title>
        
    <iso:pattern name="Outgoing">
        <iso:rule context="startEvent | task">
            <iso:assert test="outgoing">Must have a outgoing subelement</iso:assert>
        </iso:rule>
    </iso:pattern>
    
</iso:schema> 