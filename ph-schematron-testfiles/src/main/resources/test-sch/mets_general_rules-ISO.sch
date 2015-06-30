<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
    <sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
    <!-- ################################################################## -->
    <!-- mets_general_rules-ISO.sch                                         -->
    <!--                                                                    -->
    <!-- ISO Schematron schema to check for general METS usage rules.       -->
    <!-- ################################################################## -->

    <sch:pattern id="Co-OccurrenceConstraints">
        <sch:rule id="MDTYPE-OTHER" abstract="true">
            <sch:assert test="(contains(string(@MDTYPE), 'OTHER')) and (normalize-space(@OTHERMDTYPE))">If the value of a MDTYPE attribute is
                "OTHER', then the OTHERMDTYPE attribute must be used </sch:assert>
        </sch:rule>
        <sch:rule id="LOCTYPE-OTHER" abstract="true">
            <sch:assert test="(contains(string(@LOCTYPE), 'OTHER')) and (normalize-space(@OTHERLOCTYPE))">If the value of a LOCTYPE attribute is
                "OTHER", then the OTHERLOCTYPE attribute must be used </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="DMDID-IDIDREF">
        <sch:rule context="mets:*[@DMDID]">
            <!-- see Conal Tuohy posting  to Schematron Love In mailing list Sep 5, 2006 2:45 am -->
            <!-- 
                the count of dmdSec elements with IDs contained in the DMDID attribute
                equals the number of tokens in the DMDID attribute.
             -->
            <sch:assert
                test="count(
                ancestor::mets:mets/mets:dmdSec/@ID[
                 contains( concat(' ', ./@DMDID, ' '),
                           concat(' ', normalize-space(), ' ') 
                           ) 
                ] )
                = string-length(normalize-space(@DMDID)) - string-length(translate(normalize-space(@DMDID), ' ','')) + 1"
                diagnostics="DMDID-en"/>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="mdWrap">
        <sch:rule context="mets:mdWrap">
            <sch:extends rule="MDTYPE-OTHER"/>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="mdRef">
    <sch:rule context="mets:mdRef">
            <sch:extends rule="LOCTYPE-OTHER"/>
            <sch:extends rule="MDTYPE-OTHER"/>
        </sch:rule>
    </sch:pattern>
    
    <!-- to provide an example of multi-lingual error messages -->
    <sch:diagnostics>
        <sch:diagnostic id="DMDID-en">An IDREF in a DMDID attribute must be the value of a
            dmdSec/@ID in the same METS document</sch:diagnostic>
        <sch:diagnostic id="DMDID-fr">Un IDREF dans un attribut DMDID doit être la valeur d'un ID
            dmdSec / @ dans le même document METS</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
