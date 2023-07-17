<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="de" >
  <ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>

   <pattern id="isoNormDate">
      <rule context="tei:surrogates/tei:bibl/tei:date">
         <assert test="@when[matches(.,'^[1,2]\d{3}-[0,1]\d{1}-\d{2}$')]" diagnostics="d_date_en d_date_de"> @when
                      requires a date in the standard form: yyyy-mm-dd. </assert>
      </rule>
   </pattern>

   <pattern id="persNameRole">
      <rule role="error" context="tei:persName/@role">
         <assert test=". = ('commissionedBy', 'author', 'bookbinder', 'mentionedIn', 'scribe', 'previousOwner', 'translator', 'illuminator', 'conservator', 'other', 'complementedBy', 'editedBy')" diagnostics="d_role_en d_role_de">@role requires a label from the controlled vocabulary for person roles. '<value-of select="."/>' is not an entry from the controlled vocabulary.</assert>
      </rule>
   </pattern>

   <pattern id="persNameRef">
      <rule role="error" context="tei:persName/@ref">
         <assert test="matches(., '^https?://d-nb.info/gnd/')" diagnostics="d_ref_en d_ref_de">@ref requires a GND URI. '<value-of select="."/>' is not a valid GND URI.</assert>
         <!--<assert test=". castable as xs:anyURI" diagnostics="d_ref_en d_ref_de">@ref requires a GND URI.</assert>-->
      </rule>
   </pattern>

   <diagnostics>

      <diagnostic id="d_date_en" xml:lang="en">Special diagnostics message says that you should enter date information in standard format!</diagnostic>
      <diagnostic id="d_date_de" xml:lang="de">Spezielle Fehlermeldung (Lösungsvorschlag) besagt, dass Sie das Datum im Standardformat eingeben müssen!</diagnostic>
      
      <diagnostic id="d_role_en" xml:lang="en">If given the role of a person must be an entry from the controlled vocabulary providing the possible roles of persons! -- The role attribute '<value-of select="."/>' in element <value-of select="parent::*/name()"/> is not an entry from the controlled vocabulary.</diagnostic>
      <diagnostic id="d_role_de" xml:lang="de">Wenn angegeben, braucht das role-Attribut einer Person einen Eintrag aus dem kontrollierten Vokabular für die möglichen Rollen von Personen! -- Das role-Attribut im Element <value-of select="parent::*/name()"/> ist mit '<value-of select="."/>' kein Eintrag aus dem kontrollierten Vokabular.</diagnostic>
      
      <diagnostic id="d_ref_en" xml:lang="en">A person's ref attribute must link to a GND URI! -- The entry '<value-of select="."/>' of the ref attribute of the <value-of select="parent::*/name()"/> element is not a valid GND URI.</diagnostic>
      <diagnostic id="d_ref_de" xml:lang="de">Das ref-Attribut einer Person muss eine GND-URI enthalten! -- Im ref-Attribut des Elements <value-of select="parent::*/name()"/> ist mit '<value-of select="."/>' keine gültige GND-URI eingetragen.</diagnostic>

   </diagnostics>

</schema>
