<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>NOGOV T15 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="NOGOV_T15_phase">
    <active pattern="UBL-T15" />
  </phase>
  
  <pattern id="UBL-T15">
  <rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party">
    <assert flag="warning" test="(cac:PartyIdentification/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R006]-A customer number for AccountingCustomerParty SHOULD be provided according to EHF.</assert>
    <assert flag="fatal" test="(cac:Contact/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R007]-A contact reference identifier MUST be provided for AccountingCustomerParty according to EHF.</assert>
    <assert flag="fatal" test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R009]-PartyLegalEntity for AccountingCustomerParty MUST be provided according to EHF.</assert>
  </rule>
  <rule context="//cac:Item">
    <assert flag="warning" test="(cac:SellersItemIdentification/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R002]-The sellers ID for the item SHOULD be provided according to EHF.</assert>
    <assert flag="fatal" test="(number(cac:ClassifiedTaxCategory/cbc:Percent) >=0) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R008]-The item's tax rate, expressed as a percentage MUST be provided according to EHF.</assert>
  </rule>
  <rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party">
    <assert flag="warning" test="(cac:Contact/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R001]-A contact reference identifier SHOULD be provided for AccountingSupplierParty according to EHF.</assert>
    <assert flag="fatal" test="(cac:PostalAddress/cac:Country/cbc:IdentificationCode != '')">[NOGOV-T15-R014]-Country code for the supplier address MUST be provided according to EHF.</assert>
  </rule>
  <rule context="/ubl:Invoice">
    <assert flag="warning" test="(cac:ContractDocumentReference/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R005]-ContractDocumentReference SHOULD be provided according to EHF.</assert>
  </rule>
  <rule context="//cac:PaymentMeans">
    <assert flag="warning" test="(cac:PayeeFinancialAccount/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R011]-PayeeFinancialAccount SHOULD be provided  according EHF.</assert>
    <assert flag="warning" test="(cbc:PaymentID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R012]-Payment Identifier (KID number) SHOULD be used according to EHF.</assert>
  </rule>
  <rule context="//cac:InvoiceLine">
    <assert flag="warning" test="(cbc:AccountingCost) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R003]-The buyer's accounting code applied to the Invoice Line SHOULD be provided according to EHF.</assert>
    <assert flag="warning" test="(cac:OrderLineReference/cbc:LineID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R004]-An association to Order Line Reference SHOULD be provided according to EHF.</assert>
    <assert flag="warning" test="(child::cbc:InvoicedQuantity/@unitCode != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R010]-The unit qualifier of the invoiced quantity SHOULD be provided according to EHF.</assert>
  </rule>
  <rule context="//cac:OrderReference">
    <assert flag="warning" test="(child::cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">[NOGOV-T15-R013]-An association to Order Reference SHOULD be provided according to EHF.</assert>
  </rule>
</pattern>
</schema>
