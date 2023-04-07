<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>BIIRULES T10 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <phase id="BIIRULES_T10_phase">
    <active pattern="UBL-T10" />
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codes-T10" />
  </phase>
  
  <pattern id="Codes-T10">
  <rule context="cbc:DocumentCurrencyCode">
    <assert flag="fatal" test="contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))">[CL-010-002]-DocumentCurrencyCode MUST be coded using ISO code list 4217</assert>
  </rule>
  <rule context="@currencyID">
    <assert flag="fatal" test="contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))">[CL-010-003]-currencyID MUST be coded using ISO code list 4217</assert>
  </rule>
  <rule context="cac:Country//cbc:IdentificationCode">
    <assert flag="fatal" test="contains('�AD�AE�AF�AG�AI�AL�AM�AN�AO�AQ�AR�AS�AT�AU�AW�AX�AZ�BA�BB�BD�BE�BF�BG�BH�BI�BJ�BL�BM�BN�BO�BR�BS�BT�BV�BW�BY�BZ�CA�CC�CD�CF�CG�CH�CI�CK�CL�CM�CN�CO�CR�CU�CV�CX�CY�CZ�DE�DJ�DK�DM�DO�DZ�EC�EE�EG�EH�ER�ES�ET�FI�FJ�FK�FM�FO�FR�GA�GB�GD�GE�GF�GG�GH�GI�GL�GM�GN�GP�GQ�GR�GS�GT�GU�GW�GY�HK�HM�HN�HR�HT�HU�ID�IE�IL�IM�IN�IO�IQ�IR�IS�IT�JE�JM�JO�JP�KE�KG�KH�KI�KM�KN�KP�KR�KW�KY�KZ�LA�LB�LC�LI�LK�LR�LS�LT�LU�LV�LY�MA�MC�MD�ME�MF�MG�MH�MK�ML�MM�MN�MO�MP�MQ�MR�MS�MT�MU�MV�MW�MX�MY�MZ�NA�NC�NE�NF�NG�NI�NL�NO�NP�NR�NU�NZ�OM�PA�PE�PF�PG�PH�PK�PL�PM�PN�PR�PS�PT�PW�PY�QA�RO�RS�RU�RW�SA�SB�SC�SD�SE�SG�SH�SI�SJ�SK�SL�SM�SN�SO�SR�ST�SV�SY�SZ�TC�TD�TF�TG�TH�TJ�TK�TL�TM�TN�TO�TR�TT�TV�TW�TZ�UA�UG�UM�US�UY�UZ�VA�VC�VE�VG�VI�VN�VU�WF�WS�YE�YT�ZA�ZM�ZW�',concat('�',.,'�'))">[CL-010-004]-Country codes in an invoice MUST be coded using ISO code list 3166-1</assert>
  </rule>
  <rule context="cac:TaxScheme//cbc:ID">
    <assert flag="warning" test="contains('�AAA�AAB�AAC�AAD�AAE�AAF�AAG�AAH�AAI�AAJ�AAK�AAL�ADD�BOL�CAP�CAR�COC�CST�CUD�CVD�ENV�EXC�EXP�FET�FRE�GCN�GST�ILL�IMP�IND�LAC�LCN�LDP�LOC�LST�MCA�MCD�OTH�PDB�PDC�PRF�SCN�SSS�STT�SUP�SUR�SWT�TAC�TOT�TOX�TTA�VAD�VAT�',concat('�',.,'�'))">[CL-010-005]-Invoice tax schemes MUST be coded using UN/ECE 5153 code list</assert>
  </rule>
  <rule context="cac:PaymentMeans//cbc:PaymentMeansCode">
    <assert flag="warning" test="contains('�1�10�11�12�13�14�15�16�17�18�19�2�20�21�22�23�24�25�26�27�28�29�3�30�31�32�33�34�35�36�37�38�39�4�40�41�42�43�44�45�46�47�48�49�5�50�51�52�53�6�60�61�62�63�64�65�66�67�7�70�74�75�76�77�78�8�9�91�92�93�94�95�96�97�',concat('�',.,'�'))">[CL-010-006]-Payment means in an invoice MUST be coded using CEFACT code list 4461</assert>
  </rule>
  <rule context="cac:TaxCategory//cbc:ID">
    <assert flag="warning" test="contains('�A�AA�AB�AC�AD�AE�B�C�E�G�H�O�S�Z�',concat('�',.,'�'))">[CL-010-007]-Invoice tax categories MUST be coded using UN/ECE 5305 code list</assert>
  </rule>
</pattern>
  <pattern id="UBL-T10">
  <rule context="//cac:AccountingCustomerParty">
    <assert flag="warning" test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)">[BIIRULE-T10-R004]-A customer address in an invoice SHOULD contain at least city and zip code or have an address identifier.</assert>
    <assert flag="warning" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">[BIIRULE-T10-R005]-In cross border trade the VAT identifier for the customer SHOULD be prefixed with country code.</assert>
  </rule>
  <rule context="//cac:TaxCategory">
    <assert flag="fatal" test="cbc:ID">[BIIRULE-T10-R048]-Every tax category MUST be defined through an identifier.</assert>
  </rule>
  <rule context="//cac:AdditionalDocumentReference">
    <assert flag="fatal" test="cbc:ID">[BIIRULE-T10-R037]-Any reference to a document MUST specify the document identifier.</assert>
  </rule>
  <rule context="//cac:InvoiceLine/cac:Price/cbc:PriceAmount">
    <assert flag="fatal" test="number(.) >=0">[BIIRULE-T10-R022]-Prices of items MUST NOT be negative.</assert>
  </rule>
  <rule context="/ubl:Invoice">
    <assert flag="fatal" test="(cbc:IssueDate)">[BIIRULE-T10-R023]-An invoice MUST have the date of issue.</assert>
    <assert flag="fatal" test="(cbc:ID)">[BIIRULE-T10-R024]-An invoice MUST have an invoice number.</assert>
    <assert flag="fatal" test="(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)">[BIIRULE-T10-R026]-An invoice MUST contain the full name of the supplier.</assert>
    <assert flag="fatal" test="(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)">[BIIRULE-T10-R027]-An invoice MUST contain the full name of the customer.</assert>
    <assert flag="fatal" test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (round(sum(cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount) *10 * 10) div 100 = number(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))) or  not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))">[BIIRULE-T10-R028]-If the VAT total amount in an invoice exists then the sum of taxable amount in sub categories MUST equal the sum of invoice tax exclusive amount.</assert>
    <assert flag="fatal" test="(cbc:UBLVersionID)">[BIIRULE-T10-R029]-An invoice MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="(cbc:CustomizationID)">[BIIRULE-T10-R030]-An invoice MUST have a customization identifier.</assert>
    <assert flag="fatal" test="(cbc:ProfileID)">[BIIRULE-T10-R031]-An invoice MUST have a profile identifier.</assert>
    <assert flag="fatal" test="(cac:InvoiceLine)">[BIIRULE-T10-R033]-An invoice MUST specify at least one line item.</assert>
    <assert flag="fatal" test="(cbc:DocumentCurrencyCode)">[BIIRULE-T10-R034]-An invoice MUST have a currency code for the document.</assert>
    <assert flag="fatal" test="(cac:OrderReference/cbc:ID) or not(cac:OrderReference)">[BIIRULE-T10-R035]-Any reference to an order MUST specify the order identifier.</assert>
    <assert flag="fatal" test="(cac:ContractDocumentReference/cbc:ID) or not(cac:ContractDocumentReference)">[BIIRULE-T10-R036]-Any reference to a contract MUST specify the contract identifier.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:PayableAmount)">[BIIRULE-T10-R038]-An invoice MUST specify the total payable amount.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount)">[BIIRULE-T10-R039]-An invoice MUST specify the total amount with taxes included.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount)">[BIIRULE-T10-R042]-An invoice MUST specify the total amount without taxes.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)">[BIIRULE-T10-R043]-An invoice MUST specify the sum of the line amounts.</assert>
    <assert flag="fatal" test="cac:TaxTotal">[BIIRULE-T10-R052]-An invoice MUST contain tax information</assert>
  </rule>
  <rule context="//cac:Country">
    <assert flag="fatal" test="(cbc:IdentificationCode)">[BIIRULE-T10-R040]-Country in an address MUST be specified using the country code.</assert>
  </rule>
  <rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal">
    <assert flag="fatal" test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxableAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')">[BIIRULE-T10-R046]-An invoice MUST specify the taxable amount per VAT subtotal.</assert>
    <assert flag="fatal" test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')">[BIIRULE-T10-R047]-An invoice MUST specify the tax amount per VAT subtotal.</assert>
  </rule>
  <rule context="//cac:InvoiceLine">
    <assert flag="fatal" test="not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or (not(cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round(number(cac:Price/cbc:PriceAmount) *number(cbc:InvoicedQuantity) * 10 * 10) div 100) + ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) or ((cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round((number(cac:Price/cbc:PriceAmount) div number(cac:Price/cbc:BaseQuantity) * number(cbc:InvoicedQuantity)) * 10 * 10) div 100)+ (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100))">[BIIRULE-T10-R018]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
    <assert flag="fatal" test="(cac:Item/cbc:Name)">[BIIRULE-T10-R025]-Each invoice line MUST contain the product/service name</assert>
    <assert flag="fatal" test="cbc:ID">[BIIRULE-T10-R032]-Invoice lines MUST have a line identifier.</assert>
    <assert flag="fatal" test="cbc:LineExtensionAmount">[BIIRULE-T10-R050]-Invoice lines MUST have a line total amount.</assert>
    <assert flag="fatal" test="cac:Price/cbc:PriceAmount">[BIIRULE-T10-R051]-Invoice lines MUST contain the item price</assert>
  </rule>
  <rule context="/ubl:Invoice/cac:TaxTotal">
    <assert flag="fatal" test="count(cac:TaxSubtotal/*/*/cbc:ID) = count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) or count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) = 0">[BIIRULE-T10-R009]-An invoice MUST have a tax total refering to a single tax scheme</assert>
    <assert flag="fatal" test="number(cbc:TaxAmount) = number(round(sum(cac:TaxSubtotal/cbc:TaxAmount) * 10 * 10) div 100)">[BIIRULE-T10-R010]-Each tax total MUST equal the sum of the tax subcategory amounts.</assert>
  </rule>
  <rule context="//cac:PartyLegalEntity">
    <assert flag="fatal" test="(cbc:CompanyID)">[BIIRULE-T10-R041]-Company identifier MUST be specified when describing a company legal entity.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty">
    <assert flag="warning" test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)">[BIIRULE-T10-R002]-A supplier address in an invoice SHOULD contain at least the city name and a zip code or have an address identifier.</assert>
    <assert flag="warning" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">[BIIRULE-T10-R003]-In cross border trade the VAT identifier for the supplier SHOULD be prefixed with country code.</assert>
  </rule>
  <rule context="//cac:Item">
    <assert flag="warning" test="string-length(string(cbc:Name)) &lt;= 50">[BIIRULE-T10-R019]-Product names SHOULD NOT exceed 50 characters long</assert>
    <assert flag="warning" test="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)">[BIIRULE-T10-R020]-If standard identifiers are provided within an item description, a Scheme Identifier SHOULD be provided (e.g. GTIN)</assert>
    <assert flag="warning" test="not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)">[BIIRULE-T10-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</assert>
  </rule>
  <rule context="//cac:LegalMonetaryTotal">
    <assert flag="fatal" test="number(cbc:LineExtensionAmount) = number(round(sum(//cac:InvoiceLine/cbc:LineExtensionAmount) * 10 * 10) div 100)">[BIIRULE-T10-R011]-Invoice total line extension amount MUST equal the sum of the line totals</assert>
    <assert flag="fatal" test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = number(cbc:LineExtensionAmount)))">[BIIRULE-T10-R012]-Invoice tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</assert>
    <assert flag="fatal" test="((cbc:PayableRoundingAmount) and (number(cbc:TaxInclusiveAmount) = (round((number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount)) + number(cbc:PayableRoundingAmount)) *10 * 10) div 100))) or (number(cbc:TaxInclusiveAmount) = round(( number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount))) * 10 * 10) div 100)">[BIIRULE-T10-R013]-Invoice tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</assert>
    <assert flag="fatal" test="number(cbc:TaxInclusiveAmount) >= 0">[BIIRULE-T10-R014]-Tax inclusive amount in an invoice MUST NOT be negative</assert>
    <assert flag="fatal" test="(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)">[BIIRULE-T10-R015]-Total allowance MUST be equal to the sum of allowances at document level</assert>
    <assert flag="fatal" test="(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:ChargeTotalAmount)">[BIIRULE-T10-R016]-Total charges MUST be equal to the sum of document level charges.</assert>
    <assert flag="fatal" test="(cbc:PrepaidAmount) and (number(cbc:PayableAmount) = (round((cbc:TaxInclusiveAmount - cbc:PrepaidAmount) * 10 * 10) div 100)) or number(cbc:PayableAmount) = number(cbc:TaxInclusiveAmount)">[BIIRULE-T10-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</assert>
  </rule>
  <rule context="//cac:InvoicePeriod">
    <assert flag="fatal" test="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-','')))">[BIIRULE-T10-R001]-An invoice period end date MUST be later or equal to an invoice period start date</assert>
  </rule>
  <rule context="//cac:PaymentMeans">
    <assert flag="warning" test="(cbc:PaymentDueDate and /ubl:Invoice/cbc:IssueDate) and (number(translate(cbc:PaymentDueDate,'-','')) >= number(translate(/ubl:Invoice/cbc:IssueDate,'-',''))) or (not(cbc:PaymentDueDate))">[BIIRULE-T10-R006]-Payment means due date in an invoice SHOULD be later or equal than issue date.</assert>
    <assert flag="warning" test="(cbc:PaymentMeansCode = '31') and //cac:PayeeFinancialAccount/cbc:ID or (cbc:PaymentMeansCode != '31')">[BIIRULE-T10-R007]-If payment means is funds transfer, invoice MUST have a financial account</assert>
    <assert flag="warning" test="(cac:PayeeFinancialAccount/cbc:ID/@schemeID and (cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN') or (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID))">[BIIRULE-T10-R008]-If bank account is IBAN the bank identifier SHOULD also be provided.</assert>
    <assert flag="fatal" test="not(cac:PaymentMeans) or (cac:PaymentMeans/cbc:PaymentMeansCode)">[BIIRULE-T10-R044]-When specifying payment means, the invoice MUST specify the payment means code</assert>
  </rule>
  <rule context="//cac:TaxScheme">
    <assert flag="fatal" test="cbc:ID">[BIIRULE-T10-R049]-Every tax scheme MUST be defined through an identifier.</assert>
  </rule>
</pattern>
</schema>
