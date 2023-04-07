<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>NONAT T14 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
  <phase id="NONAT_T14_phase">
    <active pattern="UBL-T14" />
  </phase>
  
  <pattern id="UBL-T14">
  <rule context="//cac:AccountingCustomerParty/cac:Party">
    <assert flag="fatal" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T14-R004]-A customer postal address in an invoice MUST contain at least, Street name, city name, zip code and country code.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty/cac:Party">
    <assert flag="fatal" test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T14-R001]-PartyLegalEntity for AccountingSupplierParty MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</assert>
    <assert flag="fatal" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T14-R003]-A supplier postal address in an invoice MUST contain at least, Street name, city name, zip code and country code.</assert>
  </rule>
  <rule context="//cac:CreditNoteLine">
    <assert flag="fatal" test="cbc:CreditedQuantity and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T14-R002]-Each credit note line MUST contain a quantity according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 3" </assert>
  </rule>
</pattern>
</schema>
