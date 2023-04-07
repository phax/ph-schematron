<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xml:lang="en">
    <title>Schema for Additional Constraints in Schematron</title>
    <ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron" />
    <p>This schema supplies some constraints in addition to those
    given in the ISO/IEC 19757-2 (RELAX NG Compact Syntax) Schema for Schematron. 
    </p>
    <pattern> 
        <rule context="sch:active">
            <assert test="//sch:pattern[@id=./@pattern]">
            The pattern attribute of the active element shall match the 
            id attribute of a pattern.
            </assert>
        </rule>
        <rule context="sch:pattern[@is-a]">
            <assert test="//sch:pattern[@abstract='true'][@id=./@is-a]">
            The is-a attribute of a pattern element shall match 
            the id attribute of an abstract pattern.
            </assert>
        </rule>
        <rule context="sch:extends">
            <assert test="//sch:rule[@abstract='true'][@id=./@rule]">
            The rule attribute of an extends element shall match 
            the id attribute of an abstract rule.
            </assert>
        </rule>    
        <rule context="sch:let">
            <assert test="not(//sch:pattern                     [@abstract='true']/sch:param[@name=./@name])">
            A variable name and an abstract pattern parameter should not
            use the same name.
            </assert>
        </rule>    
    </pattern>
</schema>
