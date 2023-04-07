<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>ATGOV T10 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="ATGOV_T10_phase">
    <active pattern="UBL-T10" />
  </phase>
  
  <pattern id="UBL-T10">
  <rule context="//cac:AccountingSupplierParty/cac:Party">
    <assert flag="fatal" test="(cac:Contact/cbc:ElectronicMail) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATGOV-T10-R001]-The email address of the biller is mandatory</assert>
  </rule>
  <rule context="/ubl:Invoice">
    <assert flag="fatal" test="count(//cac:InvoiceLine) &lt; 999 and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATGOV-T10-R002]-A maximum number of 999 invoice lines must be present</assert>
    <assert flag="fatal" test="(cac:OrderReference/cbc:ID) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATGOV-T10-R003]-The order number must be present</assert>
    <assert flag="warning" test="count(/ubl:Invoice/cac:AllowanceCharge) &lt; 2 and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATGOV-T10-R004]-An invoice should not specify textual payment terms</assert>
    <assert flag="warning" test="count(//cac:PayeeFinancialAccount/cbc:ID) = 1 and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATGOV-T10-R005]-Exactly 1 beneficiary account may be present</assert>
    <assert flag="fatal" test="(//cbc:AccountingCost) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATGOV-T10-R006]-The "Buchungskreis" (accounting area code) must be present</assert>
  </rule>
  <rule context="//cac:PaymentMeans">
    <assert flag="fatal" test="cbc:PaymentMeansCode = '31' and  (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and  (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC') and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATGOV-T10-R007]-Only BIC and IBAN are allowed as beneficiary account information</assert>
  </rule>
  <rule context="//cac:InvoiceLine">
    <assert flag="fatal" test="(cac:OrderReferenceLine/cbc:LineID) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATGOV-T10-R008]-The order position number (per line item) must be present</assert>
  </rule>
</pattern>
</schema>
