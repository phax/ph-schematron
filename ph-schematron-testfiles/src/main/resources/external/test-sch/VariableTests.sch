<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:title>Variable Tests</sch:title>
  <sch:let name="var1" value="'1234'" />
  <sch:let name="var2" value="1234" />

  <sch:pattern id="p1">
    <sch:title>Always True</sch:title>
    <sch:let name="var3" value="'ABCD'" />
    <sch:let name="var4" value="ABCD" />

    <sch:rule context="/">
      <sch:let name="var5" value="'XYZ'" />
      <sch:let name="var6" value="XYZ" />
      <sch:assert test="false()">
        Var1: <sch:value-of select="$var1" />
        Var2: <sch:value-of select="$var2" />
        Var3: <sch:value-of select="$var3" />
        Var4: <sch:value-of select="$var4" />
        Var5: <sch:value-of select="$var5" />
        Var6: <sch:value-of select="$var6" />
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>