<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xml:lang="en">
    <title>Schema for Schematron Validation Report Language</title>
    <ns prefix="svrl" uri="http://purl.oclc.org/dsdl/svrl" />    
    <ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions" />
    <p>The Schematron Validation Report Language is a simple language 
        for implementations to use to compare their conformance. It is 
        basically a list of all the assertions that fail when validating 
        a document, in any order, together with other information such 
    as which rules fire.
    </p>
    <p>This schema can be used to validate SVRL documents, and provides
        examples of the use of abstract rules and abstract patterns.</p>
    <pattern>
        <title>Elements</title>
        <!--Abstract Rules -->
        
        
        
        <!-- Rules-->
        <rule context="svrl:schematron-output">
            <assert test="not(../*)">
                The <name /> element is the root element.
            </assert>
            <assert test="count(svrl:text)+ count(svrl:ns-prefix-in-attribute-values) +   count(svrl:active-pattern)+                     count(svrl:fired-rule) + count(svrl:failed-assert)+                     count(svrl:successful-report) = count(*)">
                <name /> may only contain the following elements: 
                text, ns-prefix-in-attribute-values, active-pattern, fired-rule, failed-assert 
                and successful-report.
            </assert>
            <assert test="svrl:active-pattern">
                <name /> should have at least one active pattern.
            </assert>
        </rule>
        <rule context="svrl:text">
            
            <assert test="count(*)=0"> 
                The <name /> element should not contain any elements.
            </assert>
        
        </rule>
        <rule context="svrl:diagnostic-reference">
            
            <assert test="count(*)=0"> 
                The <name /> element should not contain any elements.
            </assert>
        
            <assert test="string-length(@diagnostic) > 0">
                <name /> should have a diagnostic attribute, 
                giving the id of the diagnostic.
            </assert>
        </rule>
        <rule context="svrl:ns-prefix-in-attribute-values">
            
            <assert test="../svrl:schematron-output">
                The <name /> element is a child of schematron-output.
            </assert>
        
            
            <extends rule="childless" />
            <assert test="string-length(.) = 0">
                The <name /> element should be empty.
            </assert>
        
            <assert test="count(*)=0"> 
                The <name /> element should not contain any elements.
            </assert>
        
            <assert test="following-sibling::svrl:active-pattern                        or following-sibling::svrl:ns-prefix-in-attribute-value"> 
                A <name /> comes before an active-pattern or another 
                ns-prefix-in-attribute-values element.
            </assert>
        </rule>
        <rule context="svrl:active-pattern">
            
            <assert test="../svrl:schematron-output">
                The <name /> element is a child of schematron-output.
            </assert>
        
            
            <extends rule="childless" />
            <assert test="string-length(.) = 0">
                The <name /> element should be empty.
            </assert>
        
            <assert test="count(*)=0"> 
                The <name /> element should not contain any elements.
            </assert>
        
        </rule>
        <rule context="svrl:fired-rule">
            
            <assert test="../svrl:schematron-output">
                The <name /> element is a child of schematron-output.
            </assert>
        
            
            <extends rule="childless" />
            <assert test="string-length(.) = 0">
                The <name /> element should be empty.
            </assert>
        
            <assert test="count(*)=0"> 
                The <name /> element should not contain any elements.
            </assert>
        
            <assert test="preceding-sibling::active-pattern |                     preceding-sibling::svrl:fired-rule |                     preceding-sibling::svrl:failed-assert |                     preceding-sibling::svrl:successful-report">
                A <name /> comes after an active-pattern, an empty 
                fired-rule, a failed-assert or a successful report.
            </assert>
            <assert test="string-length(@context) > 0">
                The <name /> element should have a context attribute 
                giving the current context, in simple XPath format.
            </assert> 
        </rule>
        <rule context="svrl:failed-assert | svrl:successful-report">
            
            <assert test="../svrl:schematron-output">
                The <name /> element is a child of schematron-output.
            </assert>
        
            <assert test="count(svrl:diagnostic-reference) + count(svrl:text) = count(*)"> 
                The <name /> element should only contain a text element 
                and diagnostic reference elements.
            </assert>
            <assert test="count(svrl:text) = 1"> 
                The <name /> element should only contain a text element.
            </assert>
            <assert test="preceding-sibling::svrl:fired-rule |                 preceding-sibling::svrl:failed-assert |                 preceding-sibling::svrl:successful-report"> 
                A <name /> comes after a fired-rule, a failed-assert or a
                successful-report.
            </assert>
        </rule>
        <!-- Catch-all rule-->
        <rule context="*">
            <report test="true()">
                An unknown <name /> element has been used.
            </report>
        </rule>
    </pattern>
    <pattern>
        <title>Unique Ids</title>
        <rule context="*[@id]">
            <assert test="not(preceding::*[@id=./@id][1])"> 
                Id attributes should be unique in a document.
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <title>Required Attributes</title>
        <rule context=" svrl:diagnostic-reference ">
            <assert test="string-length( @diagnostic ) > 0">
                The <name /> element should have a 
                <value-of select="fn:name(@diagnostic)" /> attribute.
            </assert> 
        </rule>
    </pattern>    
    <pattern>
        <title>Required Attributes</title>
        <rule context=" svrl:failed-assert | svrl:successful-report ">
            <assert test="string-length( @location ) > 0">
                The <name /> element should have a 
                <value-of select="fn:name(@location)" /> attribute.
            </assert> 
        </rule>
    </pattern>    
    <pattern>
        <title>Required Attributes</title>
        <rule context=" svrl:failed-assert | svrl:successful-report ">
            <assert test="string-length( @test ) > 0">
                The <name /> element should have a 
                <value-of select="fn:name(@test)" /> attribute.
            </assert> 
        </rule>
    </pattern>    
    <pattern>
        <title>Required Attributes</title>
        <rule context=" svrl:ns-prefix-in-attribute-values ">
            <assert test="string-length( @uri ) > 0">
                The <name /> element should have a 
                <value-of select="fn:name(@uri)" /> attribute.
            </assert> 
        </rule>
    </pattern>    
    <pattern>
        <title>Required Attributes</title>
        <rule context=" svrl:ns-prefix-in-attribute-values ">
            <assert test="string-length( @prefix ) > 0">
                The <name /> element should have a 
                <value-of select="fn:name(@prefix)" /> attribute.
            </assert> 
        </rule>
    </pattern>                
</schema>
