<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>NONAT T10 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="NONAT_T10_phase">
    <active pattern="UBL-T10" />
  </phase>
  
  <pattern id="UBL-T10">
  <rule context="//cac:AccountingCustomerParty/cac:Party">
    <assert flag="fatal" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T10-R007]-A customer postal address in an invoice MUST contain at least, Street name, city name, zip code and country code.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty/cac:Party">
    <assert flag="fatal" test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T10-R001]-The Norwegian legal registration ID for the supplier MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</assert>
    <assert flag="fatal" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T10-R006]-A supplier postal address in an invoice MUST contain at least, Street name, city name, zip code and country code.</assert>
  </rule>
  <rule context="/ubl:Invoice">
    <assert flag="fatal" test="//cac:PaymentMeans/cbc:PaymentDueDate and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T10-R002]-Payment due date MUST be provided in the invoice according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 5" </assert>
    <assert flag="fatal" test="//cac:Delivery/cbc:ActualDeliveryDate and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T10-R003]-The actual delivery date  MUST be provided in the invoice according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 4" </assert>
    <assert flag="fatal" test="//cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and //cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone and //cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T10-R004]-A Delivery address in an invoice MUST contain at least, city, zip code and country code according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 4"</assert>
  </rule>
  <rule context="//cac:InvoiceLine">
    <assert flag="fatal" test="cbc:InvoicedQuantity and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NONAT-T10-R005]-Each invoice line MUST contain a quantity according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 3" </assert>
  </rule>
</pattern>
</schema>
