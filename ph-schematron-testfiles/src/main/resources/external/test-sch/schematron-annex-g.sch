<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
     xml:lang="en" queryBinding="xslt2" >
    <sch:title>Example of Multi-Lingual Schema</sch:title>
    <sch:pattern>
        <sch:rule context="dog">
            <sch:assert test="bone" diagnostics="d1 d2">
            A dog should have a bone.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:diagnostics>
        <sch:diagnostic id="d1" xml:lang="en">
        A dog should have a bone.
        </sch:diagnostic>
        <sch:diagnostic id="d2" xml:lang="de">
        Ein Hund sollte ein Bein haben.
        </sch:diagnostic>
    </sch:diagnostics>
</sch:schema>       