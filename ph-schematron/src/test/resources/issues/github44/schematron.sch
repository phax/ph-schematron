<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:pattern id="requiredAttribute">
    <sch:rule context="th[@data-role = 'interval'] | td[@data-role = ('interval', 'task')]">
      <sch:assert test="false()">
        Fails always
      </sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema> 