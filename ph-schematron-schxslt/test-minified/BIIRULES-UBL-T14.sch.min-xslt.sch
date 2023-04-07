<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>BIIRULES T14 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
  <phase id="BIIRULES_T14_phase">
    <active pattern="UBL-T14" />
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codes-T14" />
  </phase>
  
  <pattern id="Codes-T14">
  <rule context="cbc:DocumentCurrencyCode">
    <assert flag="fatal" test="contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))">[CL-014-001]-DocumentCurrencyCode MUST be coded using ISO code list 4217</assert>
  </rule>
  <rule context="@currencyID">
    <assert flag="fatal" test="contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))">[CL-014-002]-currencyID MUST be coded using ISO code list 4217</assert>
  </rule>
  <rule context="cac:Country//cbc:IdentificationCode">
    <assert flag="fatal" test="contains('�AD�AE�AF�AG�AI�AL�AM�AN�AO�AQ�AR�AS�AT�AU�AW�AX�AZ�BA�BB�BD�BE�BF�BG�BH�BI�BJ�BL�BM�BN�BO�BR�BS�BT�BV�BW�BY�BZ�CA�CC�CD�CF�CG�CH�CI�CK�CL�CM�CN�CO�CR�CU�CV�CX�CY�CZ�DE�DJ�DK�DM�DO�DZ�EC�EE�EG�EH�ER�ES�ET�FI�FJ�FK�FM�FO�FR�GA�GB�GD�GE�GF�GG�GH�GI�GL�GM�GN�GP�GQ�GR�GS�GT�GU�GW�GY�HK�HM�HN�HR�HT�HU�ID�IE�IL�IM�IN�IO�IQ�IR�IS�IT�JE�JM�JO�JP�KE�KG�KH�KI�KM�KN�KP�KR�KW�KY�KZ�LA�LB�LC�LI�LK�LR�LS�LT�LU�LV�LY�MA�MC�MD�ME�MF�MG�MH�MK�ML�MM�MN�MO�MP�MQ�MR�MS�MT�MU�MV�MW�MX�MY�MZ�NA�NC�NE�NF�NG�NI�NL�NO�NP�NR�NU�NZ�OM�PA�PE�PF�PG�PH�PK�PL�PM�PN�PR�PS�PT�PW�PY�QA�RO�RS�RU�RW�SA�SB�SC�SD�SE�SG�SH�SI�SJ�SK�SL�SM�SN�SO�SR�ST�SV�SY�SZ�TC�TD�TF�TG�TH�TJ�TK�TL�TM�TN�TO�TR�TT�TV�TW�TZ�UA�UG�UM�US�UY�UZ�VA�VC�VE�VG�VI�VN�VU�WF�WS�YE�YT�ZA�ZM�ZW�',concat('�',.,'�'))">[CL-014-003]-Country codes in a credit note MUST be coded using ISO code list 3166-1</assert>
  </rule>
  <rule context="cac:TaxScheme//cbc:ID">
    <assert flag="warning" test="contains('�AAA�AAB�AAC�AAD�AAE�AAF�AAG�AAH�AAI�AAJ�AAK�AAL�ADD�BOL�CAP�CAR�COC�CST�CUD�CVD�ENV�EXC�EXP�FET�FRE�GCN�GST�ILL�IMP�IND�LAC�LCN�LDP�LOC�LST�MCA�MCD�OTH�PDB�PDC�PRF�SCN�SSS�STT�SUP�SUR�SWT�TAC�TOT�TOX�TTA�VAD�VAT�',concat('�',.,'�'))">[CL-014-004]-Credit Note tax schemes MUST be coded using UN/ECE 5153 code list</assert>
  </rule>
  <rule context="cac:TaxCategory//cbc:ID">
    <assert flag="warning" test="contains('�A�AA�AB�AC�AD�AE�B�C�E�G�H�O�S�Z�',concat('�',.,'�'))">[CL-014-005]-Credit Note tax categories MUST be coded using UN/ECE 5305 code list</assert>
  </rule>
</pattern>
  <pattern id="UBL-T14">
  <rule context="//cac:AccountingCustomerParty">
    <assert flag="warning" test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)">[BIIRULE-T14-R004]-A customer address in a credit note SHOULD contain at least city and zip code or have an address identifier.</assert>
    <assert flag="warning" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">[BIIRULE-T14-R005]-In cross border trade the VAT identifier for the customer should be prefixed with country code.</assert>
  </rule>
  <rule context="//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:MultiplierFactorNumeric">
    <assert flag="fatal" test="number(.) >=0">[BIIRULE-T14-R023]-An allowance percentage MUST NOT be negative.</assert>
  </rule>
  <rule context="//cac:TaxCategory">
    <assert flag="fatal" test="cbc:ID">[BIIRULE-T14-R045]-Every tax category MUST be defined through an identifier.</assert>
  </rule>
  <rule context="/ubl:CreditNote">
    <assert flag="fatal" test="(cbc:IssueDate)">[BIIRULE-T14-R025]-A Credit Note MUST have the date of issue.</assert>
    <assert flag="fatal" test="(cbc:ID)">[BIIRULE-T14-R026]-A Credit Note MUST have a Credit Note number.</assert>
    <assert flag="fatal" test="(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)">[BIIRULE-T14-R028]-A Credit Note MUST contain the full name of the supplier.</assert>
    <assert flag="fatal" test="(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)">[BIIRULE-T14-R029]-A Credit Note MUST contain the full name of the customer.</assert>
    <assert flag="fatal" test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (number(round(sum(cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount) *10 *10  ) div 100 ) = number(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))">[BIIRULE-T14-R030]-If the VAT total amount in a Credit Note exists then the sum of taxable amount in sub categories MUST equal the sum of Credit Note tax exclusive amount.</assert>
    <assert flag="fatal" test="(cbc:UBLVersionID)">[BIIRULE-T14-R031]-A Credit Note MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="(cbc:CustomizationID)">[BIIRULE-T14-R032]-A Credit Note MUST have a customization identifier.</assert>
    <assert flag="fatal" test="(cbc:ProfileID)">[BIIRULE-T14-R033]-A Credit Note MUST have a profile identifier.</assert>
    <assert flag="fatal" test="(cac:CreditNoteLine)">[BIIRULE-T14-R035]-A Credit Note MUST specify at least one line item.</assert>
    <assert flag="fatal" test="(cbc:DocumentCurrencyCode)">[BIIRULE-T14-R036]-A Credit Note MUST specify the currency code for the document.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:PayableAmount)">[BIIRULE-T14-R037]-A Credit Note MUST specify the total payable amount.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount)">[BIIRULE-T14-R038]-A Credit Note MUST specify the total amount with taxes included.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount)">[BIIRULE-T14-R040]-A Credit Note MUST specify the total amount without taxes.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)">[BIIRULE-T14-R041]-A Credit Note MUST specify the sum of the line amounts.</assert>
    <assert flag="fatal" test="cac:TaxTotal">[BIIRULE-T14-R052]-A Credit Note MUST contain tax information</assert>
  </rule>
  <rule context="//cac:Price/cbc:PriceAmount">
    <assert flag="fatal" test="number(.) >=0">[BIIRULE-T14-R022]-Prices of items MUST be positive or zero</assert>
  </rule>
  <rule context="//cac:Country">
    <assert flag="fatal" test="(cbc:IdentificationCode)">[BIIRULE-T14-R042]-Country in an address MUST be specified using the country code.</assert>
  </rule>
  <rule context="/ubl:CreditNote/cac:TaxTotal/cac:TaxSubtotal">
    <assert flag="fatal" test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxableAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')">[BIIRULE-T14-R043]-A Credit Note MUST specify the taxable amount per tax subtotal.</assert>
    <assert flag="fatal" test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')">[BIIRULE-T14-R044]-A Credit Note MUST specify the tax amount per tax subtotal.</assert>
    <assert flag="fatal" test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')">[BIIRULE-T14-R047]-A credit note MUST specify the tax amount per VAT subtotal.</assert>
  </rule>
  <rule context="//cac:CreditNoteLine">
    <assert flag="fatal" test="(cac:Item/cbc:Name)">[BIIRULE-T14-R027]-Each credit note line MUST contain the product/service name</assert>
    <assert flag="fatal" test="cbc:ID">[BIIRULE-T14-R034]-Credit note lines MUST have a line identifier.</assert>
    <assert flag="fatal" test="cbc:LineExtensionAmount">[BIIRULE-T14-R050]-Credit note lines MUST have a line total amount.</assert>
    <assert flag="fatal" test="not(cbc:CreditedQuantity) or not(cac:Price/cbc:PriceAmount) or  number(cbc:LineExtensionAmount) = (round(number(cac:Price/cbc:PriceAmount) *number(cbc:CreditedQuantity) * 10 * 10) div 100) + ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 )">[BIIRULE-T14-R018]-Credit note line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
    <assert flag="fatal" test="cac:Price/cbc:PriceAmount">[BIIRULE-T14-R051]-Credit Note line MUST contain the item price</assert>
  </rule>
  <rule context="/ubl:CreditNote/cac:TaxTotal">
    <assert flag="fatal" test="count(cac:TaxSubtotal/*/*/cbc:ID) = count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) or count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) = 0">[BIIRULE-T14-R009]-A credit note MUST have a tax total refering to a single tax scheme</assert>
    <assert flag="fatal" test="number(cbc:TaxAmount) = number(round(sum(cac:TaxSubtotal/cbc:TaxAmount) * 10 * 10) div 100)">[BIIRULE-T14-R010]-Each tax total MUST equal the sum of the subcategory amounts.</assert>
  </rule>
  <rule context="//cac:PartyLegalEntity">
    <assert flag="fatal" test="(cbc:CompanyID)">[BIIRULE-T14-R039]-Company identifier MUST be specified when describing a company legal entity.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty">
    <assert flag="warning" test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)">[BIIRULE-T14-R002]-A supplier address in a credit note SHOULD contain at least the city name and a zip code or have an address identifier.</assert>
    <assert flag="warning" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">[BIIRULE-T14-R003]-In cross border trade the VAT identifier for the supplier should be prefixed with country code.</assert>
  </rule>
  <rule context="//cac:Item">
    <assert flag="warning" test="string-length(string(cbc:Name)) &lt;= 50">[BIIRULE-T14-R019]-Product names SHOULD NOT exceed 50 characters long</assert>
    <assert flag="warning" test="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)">[BIIRULE-T14-R020]-If standard identifiers are provided within an item description, an Scheme Identifier SHOULD be provided (e.g. GTIN)</assert>
    <assert flag="warning" test="not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)">[BIIRULE-T14-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</assert>
  </rule>
  <rule context="//cac:AllowanceCharge[cbc:ChargeIndicator='false']">
    <assert flag="warning" test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount))">[BIIRULE-T14-R024]-In allowances, both or none of percentage and base amount SHOULD be provided</assert>
  </rule>
  <rule context="//cac:LegalMonetaryTotal">
    <assert flag="fatal" test="number(cbc:LineExtensionAmount) = number(round(sum(//cac:CreditNoteLine/cbc:LineExtensionAmount) * 10 * 10) div 100)">[BIIRULE-T14-R011]-Credit note total line extension amount MUST equal the sum of the line totals</assert>
    <assert flag="fatal" test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = number(cbc:LineExtensionAmount)))">[BIIRULE-T14-R012]-A credit note tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</assert>
    <assert flag="fatal" test="((cbc:PayableRoundingAmount) and (number(cbc:TaxInclusiveAmount) = (round((number(cbc:TaxExclusiveAmount) + number(sum(/ubl:CreditNote/cac:TaxTotal/cbc:TaxAmount)) + number(cbc:PayableRoundingAmount)) *10 * 10) div 100))) or (number(cbc:TaxInclusiveAmount) = round(( number(cbc:TaxExclusiveAmount) + number(sum(/ubl:CreditNote/cac:TaxTotal/cbc:TaxAmount))) * 10 * 10) div 100)">[BIIRULE-T14-R013]-A credit note tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</assert>
    <assert flag="fatal" test="number(cbc:TaxInclusiveAmount) >= 0">[BIIRULE-T14-R014]-Tax inclusive amount in a credit note MUST NOT be negative</assert>
    <assert flag="fatal" test="(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(preceding::cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)">[BIIRULE-T14-R015]-Total allowance it MUST be equal to the sum of allowances at document level</assert>
    <assert flag="fatal" test="(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(preceding::cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount) * 10  *10) div 100) or not(cbc:ChargeTotalAmount)">[BIIRULE-T14-R016]-Total charges it MUST be equal to the sum of document level charges.</assert>
    <assert flag="fatal" test="(cbc:PrepaidAmount) and (number(cbc:PayableAmount) = (round((cbc:TaxInclusiveAmount - cbc:PrepaidAmount) * 10 * 10) div 100)) or number(cbc:PayableAmount) = number(cbc:TaxInclusiveAmount)">[BIIRULE-T14-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</assert>
  </rule>
  <rule context="//cac:InvoicePeriod">
    <assert flag="fatal" test="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-','')))">[BIIRULE-T14-R001]-An invoice period end date MUST be later or equal to an invoice period start date</assert>
  </rule>
  <rule context="//cac:TaxScheme">
    <assert flag="fatal" test="cbc:ID">[BIIRULE-T14-R046]-Every tax scheme MUST be defined through an identifier.</assert>
  </rule>
</pattern>
</schema>
