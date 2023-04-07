<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>EUGEN T10 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="EUGEN_T10_phase">
    <active pattern="UBL-T10" />
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codes-T10" />
  </phase>
  
  <pattern id="Codes-T10">
  <rule context="cac:FinancialInstitution/cbc:ID//@schemeID">
    <assert flag="warning" test="contains('�BIC�',concat('�',.,'�'))">[PCL-010-002]-If FinancialAccountID is IBAN then Financial InstitutionID SHOULD be BIC code.</assert>
  </rule>
  <rule context="cac:PostalAddress/cbc:ID//@schemeID">
    <assert flag="warning" test="contains('�GLN�',concat('�',.,'�'))">[PCL-010-003]-Postal address identifiers SHOULD be GLN.</assert>
  </rule>
  <rule context="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID">
    <assert flag="warning" test="contains('�GLN�',concat('�',.,'�'))">[PCL-010-004]-Location identifiers SHOULD be GLN</assert>
  </rule>
  <rule context="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID">
    <assert flag="warning" test="contains('�GTIN�',concat('�',.,'�'))">[PCL-010-005]-Standard item identifiers SHOULD be GTIN.</assert>
  </rule>
  <rule context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID">
    <assert flag="warning" test="contains('�CPV�UNSPSC�eCLASS�',concat('�',.,'�'))">[PCL-010-006]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</assert>
  </rule>
  <rule context="cbc:TaxExemptionReasonCode">
    <assert flag="fatal" test="contains('�AAA Exempt�AAB Exempt�AAC Exempt�AAE Reverse Charge�AAF Exempt�AAG Exempt�AAH Margin Scheme�AAI Margin Scheme�AAJ Reverse Charge�AAK Reverse Charge�AAL Reverse Charge Exempt�AAM Exempt New Means of Transport�AAN Exempt Triangulation�AAO Reverse Charge�',concat('�',.,'�'))">[PCL-010-007]-Tax exemption reasons MUST be coded using Use CWA 15577 tax exemption code list. Version 2006</assert>
  </rule>
  <rule context="cac:PartyIdentification/cbc:ID//@schemeID">
    <assert flag="fatal" test="contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�'))">[PCL-010-008]-Party Identifiers MUST use the PEPPOL PartyID list</assert>
  </rule>
  <rule context="cbc:EndpointID//@schemeID">
    <assert flag="fatal" test="contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�'))">[PCL-010-009]-Endpoint Identifiers MUST use the PEPPOL PartyID list.</assert>
  </rule>
</pattern>
  <pattern id="UBL-T10">
  <rule context="//cac:TaxCategory">
    <assert flag="fatal" test="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')">[EUGEN-T10-R008]-For each tax subcategory the category ID and the applicable tax percentage MUST be provided.</assert>
  </rule>
  <rule context="//cac:AllowanceCharge">
    <assert flag="fatal" test="(((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())=&quot;Invoice&quot;)) or not(local-name(parent:: node())=&quot;Invoice&quot;)">[EUGEN-T10-R006]-If the VAT total amount in an invoice exists then an Allowances Charges amount on document level MUST have Tax category for VAT.</assert>
    <assert flag="fatal" test="number(cbc:Amount)>=0">[EUGEN-T10-R022]-An allowance or charge amount MUST NOT be negative.</assert>
    <assert flag="warning" test="(cbc:AllowanceChargeReason)">[EUGEN-T10-R023]-AllowanceChargeReason text SHOULD be specified for all allowances and charges</assert>
    <assert flag="fatal" test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) >=0">[EUGEN-T10-R012]-An allowance percentage MUST NOT be negative.</assert>
    <assert flag="warning" test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)) ">[EUGEN-T10-R013]-In allowances, both or none of percentage and base amount SHOULD be provided</assert>
  </rule>
  <rule context="//cac:AccountingCustomerParty/cac:Party">
    <assert flag="warning" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">[EUGEN-T10-R002]-A customer postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</assert>
  </rule>
  <rule context="//cac:LegalMonetaryTotal">
    <assert flag="fatal" test="number(cbc:PayableAmount) >= 0">[EUGEN-T10-R019]-Total payable amount in an invoice MUST NOT be negative</assert>
  </rule>
  <rule context="//cac:Delivery/cac:DeliveryLocation/cac:Address">
    <assert flag="warning" test="(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)">[EUGEN-T10-R005]-A Delivery address in an invoice SHOULD contain at least, city, zip code and country code.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty/cac:Party">
    <assert flag="warning" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">[EUGEN-T10-R001]-A supplier postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</assert>
  </rule>
  <rule context="/ubl:Invoice">
    <assert flag="fatal" test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))">[EUGEN-T10-R007]-If the VAT total amount in an invoice exists it MUST contain the suppliers VAT number.</assert>
    <assert flag="fatal" test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)">[EUGEN-T10-R010]-If payee information is provided then the payee name MUST be specified.</assert>
    <assert flag="fatal" test="starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')">[EUGEN-T10-R015]-IF VAT = "AE" (reverse charge) THEN it MUST contain Supplier VAT id and Customer VAT</assert>
    <assert flag="fatal" test="(((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)">[EUGEN-T10-R016]-IF VAT = "AE" (reverse charge) THEN VAT MAY NOT contain other VAT categories.</assert>
    <assert flag="fatal" test="(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')">[EUGEN-T10-R017]-IF VAT = "AE" (reverse charge) THEN The taxable amount MUST equal the invoice total without VAT amount.</assert>
    <assert flag="fatal" test="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')">[EUGEN-T10-R018]-IF VAT = "AE" (reverse charge) THEN VAT tax amount MUST be zero.</assert>
    <assert flag="fatal" test="not(//@currencyID != //cbc:DocumentCurrencyCode)">[EUGEN-T10-R024]-Currency Identifier MUST be in stated in the currency stated on header level.</assert>
  </rule>
  <rule context="//cac:InvoicePeriod">
    <assert flag="fatal" test="(cbc:StartDate)">[EUGEN-T10-R020]-If the invoice refers to a period, the period MUST have an start date.</assert>
    <assert flag="fatal" test="(cbc:EndDate)">[EUGEN-T10-R021]-If the invoice refers to a period, the period MUST have an end date.</assert>
  </rule>
  <rule context="//cac:PaymentMeans">
    <assert flag="warning" test="((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))">[EUGEN-T10-R004]-If the payment means are international account transfer and the account id is IBAN then the financial institution should be identified by using the BIC id.</assert>
  </rule>
  <rule context="//cac:Item/cac:ClassifiedTaxCategory">
    <assert flag="fatal" test="(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))">[EUGEN-T10-R011]-If the VAT total amount in an invoice exists then each invoice line item MUST have a VAT category ID.</assert>
  </rule>
  <rule context="//cac:InvoiceLine">
    <assert flag="warning" test="(cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode)">[EUGEN-T10-R003]-Each invoice line SHOULD contain the quantity and unit of measure</assert>
  </rule>
  <rule context="//cac:TaxSubtotal">
    <assert flag="warning" test="((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or  (cac:TaxCategory/cbc:ID != 'E')">[EUGEN-T10-R009]-If the category for VAT is exempt (E) then an exemption reason SHOULD be provided.</assert>
  </rule>
</pattern>
</schema>
