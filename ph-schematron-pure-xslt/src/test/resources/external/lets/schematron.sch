<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <let name="minAuthors" value="2"/>
  <pattern>
    <let name="bookCountThreshold" value="1"/>
    <rule context="library">
      <let name="actualBooks" value="count(book)"/>
      <assert test="$actualBooks ge $bookCountThreshold">Library must have at least <value-of select="$bookCountThreshold"/> book(s), has <value-of select="$actualBooks"/>.</assert>
    </rule>
    <rule context="book">
      <let name="actualAuthors" value="count(author)"/>
      <assert test="$actualAuthors ge $minAuthors">Book must list at least <value-of select="$minAuthors"/> authors, has <value-of select="$actualAuthors"/>.</assert>
    </rule>
  </pattern>
</schema>
