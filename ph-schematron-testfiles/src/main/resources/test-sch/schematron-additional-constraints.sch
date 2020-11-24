<!--
       (c) International Organization for Standardization 2005. 
       Permission to copy in any form is granted for use with conforming 
       SGML systems and applications as defined in ISO 8879, 
       provided this notice is included in all copies.
 -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
     xml:lang="en" queryBinding="xslt2" >
    <sch:title>Schema for Additional Constraints in Schematron</sch:title>
    <sch:ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron" />
    <sch:p>This schema supplies some constraints in addition to those
    given in the ISO/IEC 19757-2 (RELAX NG Compact Syntax) Schema for Schematron. 
    </sch:p>
    <sch:pattern> 
        <sch:rule context="sch:active">
            <sch:assert 
                test="//sch:pattern[@id=./@pattern]">
            The pattern attribute of the active element shall match the 
            id attribute of a pattern.
            </sch:assert>
        </sch:rule>
        <sch:rule context="sch:pattern[@is-a]">
            <sch:assert 
                test="//sch:pattern[@abstract='true'][@id=./@is-a]">
            The is-a attribute of a pattern element shall match 
            the id attribute of an abstract pattern.
            </sch:assert>
        </sch:rule>
        <sch:rule context="sch:extends">
            <sch:assert 
                test="//sch:rule[@abstract='true'][@id=./@rule]">
            The rule attribute of an extends element shall match 
            the id attribute of an abstract rule.
            </sch:assert>
        </sch:rule>    
        <sch:rule context="sch:let">
            <sch:assert 
                test = "not(//sch:pattern
                    [@abstract='true']/sch:param[@name=./@name])">
            A variable name and an abstract pattern parameter should not
            use the same name.
            </sch:assert>
        </sch:rule>    
    </sch:pattern>
</sch:schema>                