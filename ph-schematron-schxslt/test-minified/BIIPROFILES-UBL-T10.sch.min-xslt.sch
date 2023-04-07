<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>BIIPROFILES T10 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="BIIPROFILES_T10_phase">
    <active pattern="UBL-T10" />
  </phase>
  
  <pattern id="UBL-T10">
  <rule context="//cbc:ProfileID">
    <assert flag="fatal" test=". = 'urn:www.cenbii.eu:profile:bii04:ver1.0' or . = 'urn:www.cenbii.eu:profile:bii05:ver1.0' or . = 'urn:www.cenbii.eu:profile:bii06:ver1.0'">[BIIPROFILE-T10-R001]-An invoice transaction T10 must only be used in Profiles 4, 5 or 6.</assert>
  </rule>
  <rule context="/ubl:Invoice">
    <assert flag="fatal" test="local-name(/*) = 'Invoice' and (//cac:OrderReference/cbc:ID) and //cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii06:ver1.0' or not (//cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii06:ver1.0')">[BIIPROFILE-T10-R002]-An invoice transaction T10 in Profile 6 MUST have an order reference identifier.</assert>
  </rule>
</pattern>
</schema>
