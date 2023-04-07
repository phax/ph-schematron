<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>ATNAT T10 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="ATNAT_T10_phase">
    <active pattern="UBL-T10" />
  </phase>
  
  <pattern id="UBL-T10">
  <rule context="//cac:TaxCategory">
    <assert flag="fatal" test="(//cac:TaxScheme/cbc:ID = 'VAT' and number(cbc:Percent)=0 and (cbc:ID = 'E')) or not(//cac:TaxScheme/cbc:ID='VAT') or (number(cbc:Percent) > 0) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATNAT-T10-R002]-If the tax percentage in a tax category is 0% then the tax category identifier MUST be “E” (UN-5305).</assert>
  </rule>
  <rule context="/ubl:Invoice">
    <assert flag="fatal" test="((number(//cbc:TaxInclusiveAmount[@currencyID='EUR']) > 10000 and //cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or (number(//cbc:TaxInclusiveAmount) &lt;= 10000)) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATNAT-T10-R001]-If the invoice total exceeds € 10.000, the VAT number of the customer MUST be provided, if the supplier has a registered office in Austria</assert>
    <assert flag="fatal" test="((//cac:Delivery/cbc:ActualDeliveryDate) or (//cac:InvoicePeriod/cbc:StartDate and //cac:InvoicePeriod/cbc:EndDate)) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATNAT-T10-R003]-The invoice MUST contain either the actual delivery date or the delivery period.</assert>
    <assert flag="fatal" test="(//cac:TaxCategory/cbc:ID = 'AE' and //cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not(//cac:TaxCategory/cbc:ID = 'AE') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT') or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'))">[ATNAT-T10-R004]-If products or services are subject to the Reverse Charge System (customer has to bear the tax, not the supplier - Austria: UStG § 19) the VAT id number of the customer MUST be provided</assert>
  </rule>
</pattern>
</schema>
