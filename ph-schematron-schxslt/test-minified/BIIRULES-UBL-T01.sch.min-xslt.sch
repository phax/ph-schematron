<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>BIIRULES T01 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2" />
  <phase id="BIIRULES_T01_phase">
    <active pattern="UBL-T01" />
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codes-T01" />
  </phase>
  
  <pattern id="Codes-T01">
  <rule context="cbc:DocumentCurrencyCode">
    <assert flag="fatal" test="contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))">[CL-001-001]-DocumentCurrencyCode MUST be coded using ISO code list 4217</assert>
  </rule>
  <rule context="@currencyID">
    <assert flag="fatal" test="contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))">[CL-001-002]-currencyID MUST be coded using ISO code list 4217</assert>
  </rule>
  <rule context="cac:Country//cbc:IdentificationCode">
    <assert flag="fatal" test="contains('�AD�AE�AF�AG�AI�AL�AM�AN�AO�AQ�AR�AS�AT�AU�AW�AX�AZ�BA�BB�BD�BE�BF�BG�BH�BI�BJ�BL�BM�BN�BO�BR�BS�BT�BV�BW�BY�BZ�CA�CC�CD�CF�CG�CH�CI�CK�CL�CM�CN�CO�CR�CU�CV�CX�CY�CZ�DE�DJ�DK�DM�DO�DZ�EC�EE�EG�EH�ER�ES�ET�FI�FJ�FK�FM�FO�FR�GA�GB�GD�GE�GF�GG�GH�GI�GL�GM�GN�GP�GQ�GR�GS�GT�GU�GW�GY�HK�HM�HN�HR�HT�HU�ID�IE�IL�IM�IN�IO�IQ�IR�IS�IT�JE�JM�JO�JP�KE�KG�KH�KI�KM�KN�KP�KR�KW�KY�KZ�LA�LB�LC�LI�LK�LR�LS�LT�LU�LV�LY�MA�MC�MD�ME�MF�MG�MH�MK�ML�MM�MN�MO�MP�MQ�MR�MS�MT�MU�MV�MW�MX�MY�MZ�NA�NC�NE�NF�NG�NI�NL�NO�NP�NR�NU�NZ�OM�PA�PE�PF�PG�PH�PK�PL�PM�PN�PR�PS�PT�PW�PY�QA�RO�RS�RU�RW�SA�SB�SC�SD�SE�SG�SH�SI�SJ�SK�SL�SM�SN�SO�SR�ST�SV�SY�SZ�TC�TD�TF�TG�TH�TJ�TK�TL�TM�TN�TO�TR�TT�TV�TW�TZ�UA�UG�UM�US�UY�UZ�VA�VC�VE�VG�VI�VN�VU�WF�WS�YE�YT�ZA�ZM�ZW�',concat('�',.,'�'))">[CL-001-003]-Country codes MUST be coded using ISO code list 3166-1</assert>
  </rule>
  <rule context="cac:TaxScheme//cbc:ID">
    <assert flag="warning" test="contains('�AAA�AAB�AAC�AAD�AAE�AAF�AAG�AAH�AAI�AAJ�AAK�AAL�ADD�BOL�CAP�CAR�COC�CST�CUD�CVD�ENV�EXC�EXP�FET�FRE�GCN�GST�ILL�IMP�IND�LAC�LCN�LDP�LOC�LST�MCA�MCD�OTH�PDB�PDC�PRF�SCN�SSS�STT�SUP�SUR�SWT�TAC�TOT�TOX�TTA�VAD�VAT�',concat('�',.,'�'))">[CL-001-004]-Tax schemes MUST be coded using UN/ECE 5153 code list</assert>
  </rule>
  <rule context="cac:DeliveryTerms//cbc:ID">
    <assert flag="warning" test="contains('�CFR�CIF�CIP�CPT�DAF�DDP�DDU�DEQ�DES�EXW�FAS�FCA�FOB�',concat('�',.,'�'))">[CL-001-005]-Delivery termsID SHOULD be coded using Incoterms 2000 code list</assert>
  </rule>
</pattern>
  <pattern id="UBL-T01">
  <rule context="//cac:BuyerCustomerParty">
    <assert flag="fatal" test="(cac:Party/cac:PartyName/cbc:Name)">[BIIRULE-T01-R009]-An order MUST contain the full name of the customer.</assert>
    <assert flag="warning" test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)">[BIIRULE-T01-R014]-A customer address in an order SHOULD contain at least city and zip code or have an address identifier.</assert>
    <assert flag="warning" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">[BIIRULE-T01-R015]-In cross border trade the VAT identifier for the customer SHOULD be prefixed with country code.</assert>
  </rule>
  <rule context="//cac:RequestedDeliveryPeriod">
    <assert flag="fatal" test="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-','')))">[BIIRULE-T01-R011]-A delivery period end date MUST be later or equal to a delivery period start date</assert>
  </rule>
  <rule context="/ubl:Order">
    <assert flag="fatal" test="(cbc:UBLVersionID)">[BIIRULE-T01-R001]-An order MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="(cbc:CustomizationID)">[BIIRULE-T01-R002]-An order MUST have a customization identifier.</assert>
    <assert flag="fatal" test="(cbc:ProfileID)">[BIIRULE-T01-R003]-An order MUST have a profile identifier.</assert>
    <assert flag="fatal" test="(cbc:IssueDate)">[BIIRULE-T01-R004]-An order MUST contain the date of issue</assert>
    <assert flag="fatal" test="(cbc:ID)">[BIIRULE-T01-R005]-An order MUST contain the order identifier</assert>
    <assert flag="fatal" test="(cac:OrderLine/cac:LineItem)">[BIIRULE-T01-R016]-An order MUST have at least one order line</assert>
    <assert flag="fatal" test="not(//@currencyID != //cbc:DocumentCurrencyCode)">[BIIRULE-T01-R027]-Currency Identifier MUST be stated in currency stated on header level.</assert>
    <assert flag="fatal" test="(cbc:DocumentCurrencyCode)">[BIIRULE-T01-R030]-An order MUST have a currency code for the document.</assert>
    <assert flag="fatal" test="count(//*[substring(name(),string-length(name())-7) = 'Quantity'][@unitCode]) = count(//*[substring(name(),string-length(name())-7) = 'Quantity'])">[BIIRULE-T01-R031]-Quantities MUST have unit of measure</assert>
  </rule>
  <rule context="//cac:AdditionalDocumentReference">
    <assert flag="fatal" test="(cbc:ID)">[BIIRULE-T01-R007]-Any references to Additional documents MUST specify the document identifier.</assert>
  </rule>
  <rule context="//cac:LineItem/cac:Price/cbc:PriceAmount">
    <assert flag="fatal" test="number(.) >= 0">[BIIRULE-T01-R026]-Prices of items MUST not be negative</assert>
  </rule>
  <rule context="//cac:Country">
    <assert flag="fatal" test="(cbc:IdentificationCode)">[BIIRULE-T01-R028]-Country in an address MUST be specified using the country code</assert>
  </rule>
  <rule context="//cac:Contract">
    <assert flag="fatal" test="(cbc:ID) and (cbc:ID != '' )">[BIIRULE-T01-R008]-Any reference to a contract MUST specify the contract identifier.</assert>
  </rule>
  <rule context="/ubl:Order/cac:TaxTotal">
    <assert flag="warning" test="number(cbc:TaxAmount) = number(round(sum(//cac:OrderLine/cac:LineItem/cbc:TotalTaxAmount) * 10 * 10) div 100)">[BIIRULE-T01-R029]-TaxTotal on header SHOULD be the sum of taxes on line level</assert>
  </rule>
  <rule context="//cac:LineItem">
    <assert flag="fatal" test="(cac:Item/cbc:Name) or (cac:Item/cac:StandardItemIdentification/cbc:ID) or (cac:Item/cac:SellersItemIdentification/cbc:ID)">[BIIRULE-T01-R013]-An order line MUST contain ID or Name</assert>
    <assert flag="fatal" test="(cbc:ID)">[BIIRULE-T01-R017]-Order line MUST contain a unique line identifier</assert>
  </rule>
  <rule context="//cac:SellerSupplierParty">
    <assert flag="fatal" test="(cac:Party/cac:PartyName/cbc:Name)">[BIIRULE-T01-R010]-An order MUST contain the full name of the supplier.</assert>
    <assert flag="warning" test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)">[BIIRULE-T01-R012]-A supplier address in an order SHOULD contain at least the city name and a zip code or have an address identifier</assert>
  </rule>
  <rule context="//cac:Item">
    <assert flag="warning" test="string-length(string(cbc:Name)) &lt;= 50">[BIIRULE-T01-R023]-Product names SHOULD NOT exceed 50 characters</assert>
    <assert flag="warning" test="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)">[BIIRULE-T01-R024]-Standard Identifiers SHOULD contain the Schema Identifier (e.g. GTIN)</assert>
    <assert flag="warning" test="not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)">[BIIRULE-T01-R025]-Classification codes SHOULD contain the Classification scheme Identifier (e.g. CPV or UNSPSC)</assert>
  </rule>
  <rule context="//cac:AnticipatedMonetaryTotal">
    <assert flag="warning" test="number(cbc:LineExtensionAmount) = number(round(sum(//cac:LineItem/cbc:LineExtensionAmount) * 10 *10) div 100)">[BIIRULE-T01-R018]-Order monetary total amount SHOULD equal the sum of the line extension amounts</assert>
    <assert flag="warning" test="(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(/ubl:Order/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)">[BIIRULE-T01-R019]-Total allowance it SHOULD be equal to the sum of allowances at document level</assert>
    <assert flag="warning" test="(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(/ubl:Order/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount) * 10 *10) div 100) or not(cbc:ChargeTotalAmount)">[BIIRULE-T01-R020]-Total charges it SHOULD be equal to the sum of document level charges.</assert>
    <assert flag="warning" test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount) + round(sum(preceding::cac:TaxTotal/cbc:TaxAmount) *10 *10) div 100 ) *10 *10) div 100)) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount) + round(sum(preceding::cac:TaxTotal/cbc:TaxAmount) *10 *10) div 100 ) *10*10) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)+ round(sum(preceding::cac:TaxTotal/cbc:TaxAmount) *10 *10) div 100 ) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and not(preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount) ) * 10 * 10) div 100)) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and not(preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount) ) * 10 * 10) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and not(preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) + 10 * 10) div 100)) or(not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round(( number(cbc:LineExtensionAmount) + round(sum(preceding::cac:TaxTotal/cbc:TaxAmount) *10 *10) div 100 ) * 10 * 10) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and not(preceding::cac:TaxTotal/cbc:TaxAmount) and number(cbc:LineExtensionAmount) = number(cbc:PayableAmount))">[BIIRULE-T01-R021]-Payable amount SHOULD be equal to the sum of total line amount minus total  allowances plus total charges and VAT total amount</assert>
  </rule>
  <rule context="//cac:OriginatorDocumentReference">
    <assert flag="fatal" test="(cbc:ID)">[BIIRULE-T01-R006]-Any reference to Originator document MUST specify the document identifier.</assert>
  </rule>
</pattern>
</schema>
