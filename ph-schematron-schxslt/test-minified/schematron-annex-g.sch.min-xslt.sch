<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xml:lang="en">
    <title>Example of Multi-Lingual Schema</title>
    <pattern>
        <rule context="dog">
            <assert diagnostics="d1 d2" test="bone">
            A dog should have a bone.
            </assert>
        </rule>
    </pattern>
    <diagnostics>
        <diagnostic id="d1" xml:lang="en">
        A dog should have a bone.
        </diagnostic>
        <diagnostic id="d2" xml:lang="de">
        Ein Hund sollte ein Bein haben.
        </diagnostic>
    </diagnostics>
</schema>
