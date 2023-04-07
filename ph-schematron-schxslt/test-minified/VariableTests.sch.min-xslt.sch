<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>Variable Tests</title>
  <let name="var1" value="'1234'" />
  <let name="var2" value="1234" />

  <pattern id="p1">
    <title>Always True</title>
    <let name="var3" value="'ABCD'" />
    <let name="var4" value="ABCD" />

    <rule context="/">
      <let name="var5" value="'XYZ'" />
      <let name="var6" value="XYZ" />
      <assert test="false()">
        Var1: <value-of select="$var1" />
        Var2: <value-of select="$var2" />
        Var3: <value-of select="$var3" />
        Var4: <value-of select="$var4" />
        Var5: <value-of select="$var5" />
        Var6: <value-of select="$var6" />
      </assert>
    </rule>
  </pattern>

</schema>
