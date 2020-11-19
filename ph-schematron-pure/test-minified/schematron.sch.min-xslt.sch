<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <pattern id="requiredAttribute">
    <rule context="th[@data-role = 'interval'] | td[@data-role = ('interval', 'task')]">
      <assert test="false()">
        Fails always
      </assert>
    </rule>
  </pattern>
</schema>
