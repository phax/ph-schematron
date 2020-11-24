<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xpath2">

    <sch:title>prova max</sch:title>

    <sch:pattern abstract="true" id="notNullPattern">
         <sch:rule context="$p1">
              <sch:assert test="$p2 ='a'">il campo non puo essere uguale ad a</sch:assert>
         </sch:rule>
    </sch:pattern>

    <sch:pattern abstract="false" is-a="notNullPattern">
             <sch:param name="p1" value="esitoRicerca"/>
             <sch:param name="p2" value="dataRegistrazione"/>
    </sch:pattern>
</sch:schema>
