<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
    <pattern>
        <rule abstract="true" id="ABSTRACT">
        <let name="roat" value="'roat'"/>
        <let name="root" value="'root'"/>
        <let name="rootRef" value="$root"/>
        <assert role="error" test="matches($roat,@value)">@value must be abstract $roat</assert> <!-- should fail -->
        <assert role="error" test="matches($root,@value)">@value must be abstract $root</assert> <!-- should pass -->
        <assert role="error" test="matches($rootRef,@value)">@value must be abstract $rootRef</assert> <!-- should pass -->
        <assert role="error" test="matches('root',@value)">@value must be abstract root</assert> <!-- should pass -->
        </rule>
        
        <rule context="root" id="CONCRETE">
        <let name="roat" value="'roat'"/>
        <let name="root" value="'root'"/>
        <let name="rootRef" value="$root"/>
        <assert role="error" test="matches($roat,@value)">@value must be concrete $roat</assert> <!-- should fail -->
        <assert role="error" test="matches($root,@value)">@value must be concrete $root</assert> <!-- should pass -->
        <assert role="error" test="matches($rootRef,@value)">@value must be concrete $rootRef</assert> <!-- should pass -->
        <assert role="error" test="matches('root',@value)">@value must be concrete root</assert> <!-- should pass -->
        </rule>

        <rule abstract="true" id="ABSTRACT2">
        <extends rule="ABSTRACT"/>
        </rule>

        <rule context="root">
        <extends rule="ABSTRACT2"/>
        </rule>
    </pattern>
</schema>