<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>ITNAT T10 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="ITNAT_T10_phase">
    <active pattern="UBL-T10" />
  </phase>
  
  <pattern id="UBL-T10">
  <rule context="//cac:DocumentReference">
    <assert flag="Fatal" test="(cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R032]-If the supplier country code is “IT”, the reference to the transport document at line level in an invoice MUST contain document identifier, issue date, reference law.</assert>
  </rule>
  <rule context="//cac:TaxRepresentativeParty">
    <assert flag="Warning" test="(cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'IT:VAT'] and cac:PartyName/cbc:Name) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R003]-If Tax Representative Party exists and its country code is “IT”, an invoice MUST contain VAT Company Identifier and name of the Tax Representative Party.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty/cac:Party">
    <assert flag="Warning" test="not(cac:PartyLegalEntity/cbc:CompanyID[@schemeID = 'IT:CC']) or (cac:PartyLegalEntity[cbc:CompanyID/@schemeID = 'IT:CC']/cac:CorporateRegistrationScheme/cac:JurisdictionRegionAddress/cbc:CountrySubentity) or (cac:PartyLegalEntity[cbc:CompanyID/@schemeID = 'IT:CC']/cac:CorporateRegistrationScheme/cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R013]-If the supplier country code is “IT” and is registered in the Italian Chamber of Commerce, the information about supplier’s Items Registration Company SHOULD include Country Subentity (as code or text) of Chambers of Commerce of company register.</assert>
  </rule>
  <rule context="//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
    <assert flag="Fatal" test="(cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R008]-A customer postal address in an invoice MUST contain at least, Street name, city name, zip code, country subentity and country code.</assert>
  </rule>
  <rule context="/ubl:Invoice">
    <assert flag="Fatal" test="cbc:InvoiceTypeCode and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R016]-If the supplier country code is “IT”, an invoice MUST contain the invoice type.</assert>
  </rule>
  <rule context="//cac:DespatchDocumentReference">
    <assert flag="Fatal" test="(cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R017]-If the supplier country code is “IT”, the reference to the transport document in an invoice MUST contain document identifier, issue date, reference law.</assert>
  </rule>
  <rule context="//cac:InvoiceLine">
    <assert flag="Fatal" test="(cbc:InvoicedQuantity) and (cbc:InvoicedQuantity/@unitCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R024]-Each invoice line MUST contain the quantity and unit of measure.</assert>
    <assert flag="Fatal" test="(cac:Price/cbc:PriceAmount) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R031]-If the supplier country code is “IT”, each invoice line MUST contain the product/service unit price.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress">
    <assert flag="Fatal" test="(cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">[IT-T10-R005]-A suppliers postal address in an invoice MUST contain at least, Street name, city name, zip code, country subentity and country code.</assert>
  </rule>
</pattern>
</schema>
