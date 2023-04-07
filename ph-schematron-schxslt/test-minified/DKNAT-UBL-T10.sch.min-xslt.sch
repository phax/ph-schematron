<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>DKNAT T10 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="DKNAT_T10_phase">
    <active pattern="UBL-T10" />
  </phase>
  
  <pattern id="UBL-T10">
  <rule context="//cac:AccountingCustomerParty/cac:Party">
    <assert flag="fatal" test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'DK') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'DK'))">[DKNAT-T10-R002]-The buyer’s Danish legal registration ID MUST be provided.</assert>
    <assert flag="fatal" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'DK') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'DK'))">[DKNAT-T10-R003]-A customer postal address in an invoice MUST contain at least, Street name and number, city name, zip code and country code.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty/cac:Party">
    <assert flag="fatal" test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'DK') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'DK'))">[DKNAT-T10-R001]-The Danish legal registration ID for the supplier MUST be provided</assert>
  </rule>
</pattern>
</schema>
