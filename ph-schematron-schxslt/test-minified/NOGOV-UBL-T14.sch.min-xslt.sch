<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>NOGOV T14 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
  <phase id="NOGOV_T14_phase">
    <active pattern="UBL-T14" />
  </phase>
  
  <pattern id="UBL-T14">
  <rule context="//cac:CreditNoteLine">
    <assert flag="warning" test="(cbc:CreditedQuantity/@unitCode != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T14-R003]-The unit qualifier of the CreditNote quantity SHOULD be provided according to EHF.</assert>
  </rule>
  <rule context="//cac:AccountingCustomerParty/cac:Party">
    <assert flag="fatal" test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T14-R004]-PartyLegalEntity for AccountingCustomerParty MUST be provided according to EHF.</assert>
    <assert flag="warning" test="(cac:PartyIdentification/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T14-R006]-A customer number for AccountingCustomerParty SHOULD be provided according to EHF.</assert>
    <assert flag="fatal" test="(cac:Contact/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T14-R007]-A contact reference identifier MUST be provided for AccountingCustomerParty according to EHF.</assert>
  </rule>
  <rule context="//cac:Item">
    <assert flag="warning" test="(cac:SellersItemIdentification/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T14-R002]-The sellers ID for the item SHOULD be provided according to EHF.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty/cac:Party">
    <assert flag="warning" test="(cac:Contact/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T14-R001]-A contact reference identifier SHOULD be provided for AccountingSupplierParty according to EHF.</assert>
    <assert flag="fatal" test="(cac:PostalAddress/cac:Country/cbc:IdentificationCode != '')">[NOGOV-T14-R008]-Country code for the supplier address MUST be provided according to EHF.</assert>
  </rule>
</pattern>
</schema>
