<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <ns prefix="ead" uri="urn:isbn:1-931666-22-9" />
    <ns prefix="mets" uri="http://www.loc.gov/METS/" />
    <!-- ################################################################## -->
    <!-- mets_general_rules-ISO.sch                                         -->
    <!--                                                                    -->
    <!-- ISO Schematron schema to check for general METS usage rules.       -->
    <!-- ################################################################## -->

    <pattern id="Co-OccurrenceConstraints">
        
        
        <rule context="mets:mdWrap">
            
            <assert test="(contains(string(@MDTYPE), 'OTHER')) and (normalize-space(@OTHERMDTYPE))">If the value of a MDTYPE attribute is
                "OTHER', then the OTHERMDTYPE attribute must be used </assert>
        
        </rule>
        <rule context="mets:mdRef">
            
            <assert test="(contains(string(@LOCTYPE), 'OTHER')) and (normalize-space(@OTHERLOCTYPE))">If the value of a LOCTYPE attribute is
                "OTHER", then the OTHERLOCTYPE attribute must be used </assert>
        
            
            <assert test="(contains(string(@MDTYPE), 'OTHER')) and (normalize-space(@OTHERMDTYPE))">If the value of a MDTYPE attribute is
                "OTHER', then the OTHERMDTYPE attribute must be used </assert>
        
        </rule>
    </pattern>
    <pattern id="DMDID-IDIDREF">
        <rule context="mets:*[@DMDID]">
            <!-- see Conal Tuohy posting  to Schematron Love In mailing list Sep 5, 2006 2:45 am -->
            <!-- 
                the count of dmdSec elements with IDs contained in the DMDID attribute
                equals the number of tokens in the DMDID attribute.
             -->

            <assert diagnostics="DMDID-en" test="count(                 ancestor::mets:mets/mets:dmdSec/@ID[                  contains( concat(' ', ./@DMDID, ' '),                            concat(' ', normalize-space(), ' ')                             )                  ] )                 = string-length(normalize-space(@DMDID)) - string-length(translate(normalize-space(@DMDID), ' ','')) + 1" />
        </rule>
    </pattern>
    
    <!-- to provide an example of multi-lingual error messages -->
    <diagnostics>
        <diagnostic id="DMDID-en">An IDREF in a DMDID attribute must be the value of a
            dmdSec/@ID in the same METS document</diagnostic>
        <diagnostic id="DMDID-fr">Un IDREF dans un attribut DMDID doit être la valeur d'un ID
            dmdSec / @ dans le même document METS</diagnostic>
    </diagnostics>
</schema>
