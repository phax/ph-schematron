<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>BIIRULES T03 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:OrderResponseSimple-2" />
  <phase id="BIIRULES_T03_phase">
    <active pattern="UBL-T03" />
  </phase>
  
  <pattern id="UBL-T03">
  <rule context="//cac:BuyerCustomerParty">
    <assert flag="fatal" test="(cac:Party/cac:PartyName/cbc:Name)">[BIIRULE-T03-R006]-An order response  MUST contain the full name of the customer.</assert>
  </rule>
  <rule context="//cbc:Note">
    <assert flag="warning" test="(@languageID)">[BIIRULE-T03-R005]-Language SHOULD be defined for note field</assert>
  </rule>
  <rule context="//cac:SellerSupplierParty">
    <assert flag="fatal" test="(cac:Party/cac:PartyName/cbc:Name)">[BIIRULE-T03-R007]-An order response  MUST contain the full name of the supplier.</assert>
  </rule>
  <rule context="/ubl:OrderResponseSimple">
    <assert flag="fatal" test="(cbc:UBLVersionID)">[BIIRULE-T03-R001]-A conformant CEN BII order response core data model MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="(cbc:CustomizationID)">[BIIRULE-T03-R002]-A conformant CEN BII order response  core data model MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="(cbc:ProfileID)">[BIIRULE-T03-R003]-A conformant CEN BII order response  core data model MUST have a profile identifier.</assert>
    <assert flag="warning" test="not(cbc:Note) or count(cbc:Note)=1">[BIIRULE-T03-R004]-Only one note field must be specified </assert>
  </rule>
</pattern>
</schema>
