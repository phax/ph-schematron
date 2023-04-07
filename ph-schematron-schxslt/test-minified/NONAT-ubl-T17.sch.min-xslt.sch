<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>NONAT T17 bound to ubl</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Reminder-2" />
  <phase id="NONAT_T17_phase">
    <active pattern="UBL-T17" />
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codes-T17" />
  </phase>
  
  <pattern id="Codes-T17">
  <rule context="@currencyID">
    <assert flag="fatal" test="contains('�AED�AFN�ALL�AMD�ANG�AOA�ARS�AUD�AWG�AZN�BAM�BBD�BDT�BGN�BHD�BIF�BMD�BND�BOB�BOV�BRL�BSD�BTN�BWP�BYR�BZD�CAD�CDF�CHE�CHF�CHW�CLF�CLP�CNY�COP�COU�CRC�CUP�CVE�CZK�DJF�DKK�DOP�DZD�EEK�EGP�ERN�ETB�EUR�FJD�FKP�GBP�GEL�GHS�GIP�GMD�GNF�GTQ�GWP�GYD�HKD�HNL�HRK�HTG�HUF�IDR�ILS�INR�IQD�IRR�ISK�JMD�JOD�JPY�KES�KGS�KHR�KMF�KPW�KRW�KWD�KYD�KZT�LAK�LBP�LKR�LRD�LSL�LTL�LVL�LYD�MAD�MDL�MGA�MKD�MMK�MNT�MOP�MRO�MUR�MVR�MWK�MXN�MXV�MYR�MZN�NAD�NGN�NIO�NOK�NPR�NZD�OMR�PAB�PEN�PGK�PHP�PKR�PLN�PYG�QAR�RON�RSD�RUB�RWF�SAR�SBD�SCR�SDG�SEK�SGD�SHP�SKK�SLL�SOS�SRD�STD�SVC�SYP�SZL�THB�TJS�TMM�TND�TOP�TRY�TTD�TWD�TZS�UAH�UGX�USD�USN�USS�UYI�UYU�UZS�VEF�VND�VUV�WST�XAF�XAG�XAU�XBA�XBB�XBC�XBD�XCD�XDR�XFU�XOF�XPD�XPF�XTS�XXX�YER�ZAR�ZMK�ZWD�ZWR�',concat('�',.,'�'))">[CL-017-002]-Currencies in an reminder MUST be coded using ISO currency code</assert>
  </rule>
  <rule context="cac:Country//cbc:IdentificationCode">
    <assert flag="fatal" test="contains('�AD�AE�AF�AG�AI�AL�AM�AN�AO�AQ�AR�AS�AT�AU�AW�AX�AZ�BA�BB�BD�BE�BF�BG�BH�BI�BJ�BL�BM�BN�BO�BR�BS�BT�BV�BW�BY�BZ�CA�CC�CD�CF�CG�CH�CI�CK�CL�CM�CN�CO�CR�CU�CV�CX�CY�CZ�DE�DJ�DK�DM�DO�DZ�EC�EE�EG�EH�ER�ES�ET�FI�FJ�FK�FM�FO�FR�GA�GB�GD�GE�GF�GG�GH�GI�GL�GM�GN�GP�GQ�GR�GS�GT�GU�GW�GY�HK�HM�HN�HR�HT�HU�ID�IE�IL�IM�IN�IO�IQ�IR�IS�IT�JE�JM�JO�JP�KE�KG�KH�KI�KM�KN�KP�KR�KW�KY�KZ�LA�LB�LC�LI�LK�LR�LS�LT�LU�LV�LY�MA�MC�MD�ME�MF�MG�MH�MK�ML�MM�MN�MO�MP�MQ�MR�MS�MT�MU�MV�MW�MX�MY�MZ�NA�NC�NE�NF�NG�NI�NL�NO�NP�NR�NU�NZ�OM�PA�PE�PF�PG�PH�PK�PL�PM�PN�PR�PS�PT�PW�PY�QA�RO�RS�RU�RW�SA�SB�SC�SD�SE�SG�SH�SI�SJ�SK�SL�SM�SN�SO�SR�ST�SV�SY�SZ�TC�TD�TF�TG�TH�TJ�TK�TL�TM�TN�TO�TR�TT�TV�TW�TZ�UA�UG�UM�US�UY�UZ�VA�VC�VE�VG�VI�VN�VU�WF�WS�YE�YT�ZA�ZM�ZW�',concat('�',.,'�'))">[CL-017-003]-Country codes in an reminder MUST be coded using ISO code list 3166-1</assert>
  </rule>
  <rule context="cac:TaxScheme//cbc:ID">
    <assert flag="warning" test="contains('�AAA�AAB�AAC�AAD�AAE�AAF�AAG�AAH�AAI�AAJ�AAK�AAL�ADD�BOL�CAP�CAR�COC�CST�CUD�CVD�ENV�EXC�EXP�FET�FRE�GCN�GST�ILL�IMP�IND�LAC�LCN�LDP�LOC�LST�MCA�MCD�OTH�PDB�PDC�PRF�SCN�SSS�STT�SUP�SUR�SWT�TAC�TOT�TOX�TTA�VAD�VAT�',concat('�',.,'�'))">[CL-017-004]-Reminder tax schemes MUST be coded using UN/ECE 5153 code list</assert>
  </rule>
  <rule context="cac:TaxCategory//cbc:ID">
    <assert flag="warning" test="contains('�A�AA�AB�AC�AD�AE�B�C�E�G�H�O�S�Z�',concat('�',.,'�'))">[CL-017-005]-Reminder tax categories MUST be coded using UN/ECE 5305 code list</assert>
  </rule>
  <rule context="cac:PostalAddress/cbc:ID//@schemeID">
    <assert flag="warning" test="contains('�GLN�',concat('�',.,'�'))">[CL-017-006]-Postal address identifiers SHOULD ONLY be GLN.</assert>
  </rule>
</pattern>
  <pattern id="UBL-T17">
  <rule context="/ubl:Reminder/cac:TaxTotal">
    <assert flag="fatal" test="(cbc:TaxAmount)">[NONAT-T17-R029]-A reminder MUST specify the tax total amount.</assert>
  </rule>
  <rule context="//cac:ReminderLine">
    <assert flag="fatal" test="(cbc:ID)">[NONAT-T17-R006]-Reminder lines MUST have a line identifier.</assert>
    <assert flag="fatal" test="(//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) or (//cac:BillingReference/cac:CreditNoteDocumentReference/cbc:ID)">[NONAT-T17-R007]-A reminder line MUST specify a reference, either to a previous invoice or to a previous credit note.</assert>
  </rule>
  <rule context="//cbc:ProfileID">
    <assert flag="fatal" test=". = 'urn:www.cenbii.eu:profile:bii08:ver1.0'">[NONAT-T17-R016]-An reminder transaction T17 must only be used in Profiles 8.</assert>
  </rule>
  <rule context="//cac:AccountingCustomerParty/cac:Party">
    <assert flag="fatal" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">[NONAT-T17-R010]-A customer postal address in a reminder document MUST contain at least, Street name, city name, zip code and country code.</assert>
    <assert flag="warning" test="(cac:PartyIdentification/cbc:ID != '')">[NONAT-T17-R024]-A customer number for AccountingCustomerParty SHOULD be provided.</assert>
    <assert flag="fatal" test="(cac:PartyLegalEntity/cbc:CompanyID != '')">[NONAT-T17-R027]-The Norwegian legal registration ID for the customer MUST be provided.</assert>
    <assert flag="fatal" test="(cac:Contact/cbc:ID != '')">[NONAT-T17-R028]-A customer contact reference identifier MUST be provided. </assert>
  </rule>
  <rule context="//cac:LegalMonetaryTotal">
    <assert flag="fatal" test="number(child::cbc:LineExtensionAmount) = number(round((sum(//cac:ReminderLine/cbc:DebitLineAmount) - sum(//cac:ReminderLine/cbc:CreditLineAmount)) * 100) div 100)">[NONAT-T17-R008]-Reminder total line extension amount MUST equal the sum of the line totals.</assert>
  </rule>
  <rule context="//cac:AccountingSupplierParty/cac:Party">
    <assert flag="fatal" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">[NONAT-T17-R009]-A supplier postal address in a reminder document MUST contain at least, Street name, city name, zip code and country code.</assert>
    <assert flag="fatal" test="(cac:PostalAddress/cac:Country/cbc:IdentificationCode != '')">[NONAT-T17-R022]-Country code for the supplier address MUST be provided.</assert>
    <assert flag="fatal" test="(cac:PartyLegalEntity/cbc:CompanyID != '')">[NONAT-T17-R023]-The Norwegian legal registration ID for the supplier MUST be provided.</assert>
  </rule>
  <rule context="/ubl:Reminder">
    <assert flag="fatal" test="(cbc:ID)">[NONAT-T17-R001]-A reminder MUST have a reminder number.</assert>
    <assert flag="fatal" test="(cbc:IssueDate)">[NONAT-T17-R002]-A reminder MUST have the date of issue.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)">[NONAT-T17-R003]-A reminder MUST specify the sum of the line amounts.</assert>
    <assert flag="fatal" test="(cac:LegalMonetaryTotal/cbc:PayableAmount)">[NONAT-T17-R004]-A reminder MUST specify the total payable amount.</assert>
    <assert flag="fatal" test="(cac:ReminderLine)">[NONAT-T17-R005]-A reminder MUST specify at least one line item.</assert>
    <assert flag="fatal" test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)">[NONAT-T17-R013]-If payee information is provided then  the payee name MUST be specified.</assert>
    <assert flag="warning" test="(((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)">[NONAT-T17-R014]-A reminder document with reverse charge VAT MAY NOT contain other VAT categories.</assert>
    <assert flag="fatal" test="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE'  or not ((//cac:TaxCategory/cbc:ID) = 'AE' )">[NONAT-T17-R015]-The tax amount for reverse charge VAT MUST be zero. (since there is only one VAT category allowed it follows that the invoice tax total for reverse charge invoices is zero)</assert>
    <assert flag="fatal" test="(cbc:UBLVersionID)">[NONAT-T17-R017]-A reminder MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="(cbc:CustomizationID)">[NONAT-T17-R018]-A reminder MUST have a customization identifier.</assert>
    <assert flag="fatal" test="(cbc:ProfileID)">[NONAT-T17-R019]-A reminder MUST have a profile identifier.</assert>
    <assert flag="fatal" test="(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)">[NONAT-T17-R020]-A reminder MUST contain the full name of the supplier.</assert>
    <assert flag="fatal" test="(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)">[NONAT-T17-R025]-A reminder MUST contain the full name of the customer.</assert>
  </rule>
  <rule context="//cac:TaxSubtotal">
    <assert flag="warning" test="(number(cac:TaxCategory/cbc:Percent) = 0 and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or  (number(cac:TaxCategory/cbc:Percent) !=0)">[NONAT-T17-R012]-If the tax percentage in a tax category is 0% then an exemption reason SHOULD be provided except in reverse charge VAT.</assert>
  </rule>
</pattern>
</schema>
