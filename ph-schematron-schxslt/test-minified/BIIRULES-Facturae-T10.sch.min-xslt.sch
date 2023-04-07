<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>BIIRULES T10 bound to Facturae</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="facturae" uri="http://www.facturae.es/Facturae/2009/v3.2/Facturae" />
  <phase id="BIIRULES_T10_phase">
    <active pattern="FACTURAE-T10" />
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
  <pattern id="FACTURAE-T10">
  <rule context="//Parties/BuyerParty">
    <assert flag="warning" test="((LegalEntity/AddressInSpain/Town and LegalEntity/AddressInSpain/PostCode) or (LegalEntity/OverseasAddress/PostCodeandTown) or (Individual/AddressInSpain/Town and Individual/AddressInSpain/PostCode) or (Individual/OverseasAddress/PostCodeandTown))">[BIIRULE-T10-R004]-A customer address in an invoice SHOULD contain at least city and zip code or have an address identifier.</assert>
    <assert flag="warning" test="((//CountryCode) and (preceding::SellerParty//CountryCode) and  ((//CountryCode) = (preceding::SellerParty//CountryCode) or ((//CountryCode) != (preceding::SellerParty//CountryCode) and starts-with(TaxIdentification/TaxIdentificationNumber, //CountryCode)))) or not((//CountryCode)) or not((preceding::SellerParty//CountryCode))">[BIIRULE-T10-R005]-In cross border trade the VAT identifier for the customer SHOULD be prefixed with country code.</assert>
  </rule>
  <rule context="//TaxesOutputs">
    <assert flag="fatal" test="./false">[BIIRULE-T10-R048]-Every tax category MUST be defined through an identifier.</assert>
  </rule>
  <rule context="//cac:AdditionalDocumentReference">
    <assert flag="fatal" test="./false">[BIIRULE-T10-R037]-Any reference to a document MUST specify the document identifier.</assert>
  </rule>
  <rule context="//Items/InvoiceLine/UnitPriceWithoutTax">
    <assert flag="fatal" test="number(.) >=0">[BIIRULE-T10-R022]-Prices of items MUST NOT be negative.</assert>
  </rule>
  <rule context="/facturae:Facturae">
    <assert flag="fatal" test="(//InvoiceIssueData/IssueDate)">[BIIRULE-T10-R023]-An invoice MUST have the date of issue.</assert>
    <assert flag="fatal" test="(//InvoiceHeader/InvoiceNumber)">[BIIRULE-T10-R024]-An invoice MUST have an invoice number.</assert>
    <assert flag="fatal" test="(//SellerParty/LegalEntity/CorporateName) or (//SellerParty/Individual/Name)">[BIIRULE-T10-R026]-An invoice MUST contain the full name of the supplier.</assert>
    <assert flag="fatal" test="(//BuyerParty/LegalEntity/CorporateName) or (//BuyerParty/Individual/Name)">[BIIRULE-T10-R027]-An invoice MUST contain the full name of the customer.</assert>
    <assert flag="fatal" test="./false">[BIIRULE-T10-R028]-If the VAT total amount in an invoice exists then the sum of taxable amount in sub categories MUST equal the sum of invoice tax exclusive amount.</assert>
    <assert flag="fatal" test="//SchemaVersion">[BIIRULE-T10-R029]-An invoice MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="./false">[BIIRULE-T10-R030]-An invoice MUST have a customization identifier.</assert>
    <assert flag="fatal" test="./false">[BIIRULE-T10-R031]-An invoice MUST have a profile identifier.</assert>
    <assert flag="fatal" test="(//Items/InvoiceLine)">[BIIRULE-T10-R033]-An invoice MUST specify at least one line item.</assert>
    <assert flag="fatal" test="(//InvoiceIssueData/InvoiceCurrencyCode)">[BIIRULE-T10-R034]-An invoice MUST have a currency code for the document.</assert>
    <assert flag="fatal" test="./false">[BIIRULE-T10-R035]-Any reference to an order MUST specify the order identifier.</assert>
    <assert flag="fatal" test="./false">[BIIRULE-T10-R036]-Any reference to a contract MUST specify the contract identifier.</assert>
    <assert flag="fatal" test="//TotalExecutableAmount">[BIIRULE-T10-R038]-An invoice MUST specify the total payable amount.</assert>
    <assert flag="fatal" test="//InvoiceTotal">[BIIRULE-T10-R039]-An invoice MUST specify the total amount with taxes included.</assert>
    <assert flag="fatal" test="//TotalGrossAmountBeforeTaxes">[BIIRULE-T10-R042]-An invoice MUST specify the total amount without taxes.</assert>
    <assert flag="fatal" test="//TotalGrossAmount">[BIIRULE-T10-R043]-An invoice MUST specify the sum of the line amounts.</assert>
    <assert flag="fatal" test="./false">[BIIRULE-T10-R052]-An invoice MUST contain tax information</assert>
  </rule>
  <rule context="//CountryCode">
    <assert flag="fatal" test=".">[BIIRULE-T10-R040]-Country in an address MUST be specified using the country code.</assert>
  </rule>
  <rule context="//NonExistingDummyNode">
    <assert flag="fatal" test="//Tax/TaxableBase">[BIIRULE-T10-R046]-An invoice MUST specify the taxable amount per VAT subtotal.</assert>
    <assert flag="fatal" test="//Tax/TaxAmount">[BIIRULE-T10-R047]-An invoice MUST specify the tax amount per VAT subtotal.</assert>
  </rule>
  <rule context="//Items/InvoiceLine">
    <assert flag="fatal" test="not(Quantity) or not(UnitPriceWithoutTax) or number(GrossAmount) = (round(number(UnitPriceWithoutTax) * number(Quantity) * 100) div 100)">[BIIRULE-T10-R018]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
    <assert flag="fatal" test="(//ItemDescription)">[BIIRULE-T10-R025]-Each invoice line MUST contain the product/service name</assert>
    <assert flag="fatal" test="//InvoiceHeader/InvoiceNumber">[BIIRULE-T10-R032]-Invoice lines MUST have a line identifier.</assert>
    <assert flag="fatal" test="//TotalCost">[BIIRULE-T10-R050]-Invoice lines MUST have a line total amount.</assert>
    <assert flag="fatal" test="./false">[BIIRULE-T10-R051]-Invoice lines MUST contain the item price</assert>
  </rule>
  <rule context="/facturae:Facturae/Invoices/Invoice/TaxesOutputs">
    <assert flag="fatal" test="count(Tax)>1 or count(Tax) = 1">[BIIRULE-T10-R009]-An invoice MUST have a tax total refering to a single tax scheme</assert>
    <assert flag="fatal" test="number(following::InvoiceTotals/TotalTaxOutputs) = number(round(sum(child::Tax/TaxAmount/TotalAmount) * 100) div 100)">[BIIRULE-T10-R010]-Each tax total MUST equal the sum of the tax subcategory amounts.</assert>
  </rule>
  <rule context="//LegalEntity">
    <assert flag="fatal" test="//RegistrationData">[BIIRULE-T10-R041]-Company identifier MUST be specified when describing a company legal entity.</assert>
  </rule>
  <rule context="//Parties/SellerParty">
    <assert flag="warning" test="((LegalEntity/AddressInSpain/Town and LegalEntity/AddressInSpain/PostCode) or (LegalEntity/OverseasAddress/PostCodeandTown) or (Individual/AddressInSpain/Town and Individual/AddressInSpain/PostCode) or (Individual/OverseasAddress/PostCodeandTown))">[BIIRULE-T10-R002]-A supplier address in an invoice SHOULD contain at least the city name and a zip code or have an address identifier.</assert>
    <assert flag="warning" test="((//CountryCode) and (following::BuyerParty//CountryCode) and ((//CountryCode) = (following::BuyerParty//CountryCode) or ((//CountryCode) != (following::BuyerParty//CountryCode) and starts-with(TaxIdentification/TaxIdentificationNumber, //CountryCode)))) or not(//CountryCode) or not(following::BuyerParty//CountryCode)">[BIIRULE-T10-R003]-In cross border trade the VAT identifier for the supplier SHOULD be prefixed with country code.</assert>
  </rule>
  <rule context="//Items/InvoiceLine">
    <assert flag="warning" test="string-length(string(//ItemDescription)) &lt;= 50">[BIIRULE-T10-R019]-Product names SHOULD NOT exceed 50 characters long</assert>
    <assert flag="warning" test="./true">[BIIRULE-T10-R020]-If standard identifiers are provided within an item description, a Scheme Identifier SHOULD be provided (e.g. GTIN)</assert>
    <assert flag="warning" test="not(//ArticleCode)">[BIIRULE-T10-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</assert>
  </rule>
  <rule context="//InvoiceTotals">
    <assert flag="fatal" test="number(TotalGrossAmount) = number(round(sum(following::Items/InvoiceLine/GrossAmount) * 100) div 100)">[BIIRULE-T10-R011]-Invoice total line extension amount MUST equal the sum of the line totals</assert>
    <assert flag="fatal" test="((TotalGeneralSurcharges) and (TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = (number(TotalGrossAmount) + number(TotalGeneralSurcharges) - number(TotalGeneralDiscounts)))) or (not(TotalGeneralSurcharges) and (TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount) - number(TotalGeneralDiscounts))) or ((TotalGeneralSurcharges) and not(TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount) + number(TotalGeneralSurcharges))) or (not(TotalGeneralSurcharges) and not(TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount)))">[BIIRULE-T10-R012]-Invoice tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</assert>
    <assert flag="fatal" test="number(InvoiceTotal) = number(TotalGrossAmountBeforeTaxes) - number(TotalTaxesWithheld) + number(TotalTaxOutputs)">[BIIRULE-T10-R013]-Invoice tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</assert>
    <assert flag="fatal" test="number(InvoiceTotal) >= 0">[BIIRULE-T10-R014]-Tax inclusive amount in an invoice MUST NOT be negative</assert>
    <assert flag="fatal" test="(TotalGeneralDiscounts) and TotalGeneralDiscounts = (round(sum(//Discount/DiscountAmount) * 100) div 100) or not(TotalGeneralDiscounts)">[BIIRULE-T10-R015]-Total allowance MUST be equal to the sum of allowances at document level</assert>
    <assert flag="fatal" test="(TotalGeneralSurcharges) and TotalGeneralSurcharges = (round(sum(//Charge/ChargeAmount) * 100) div 100) or not(TotalGeneralSurcharges)">[BIIRULE-T10-R016]-Total charges MUST be equal to the sum of document level charges.</assert>
    <assert flag="fatal" test="(TotalPaymentsOnAccount) and (number(TotalExecutableAmount) = number(InvoiceTotal - TotalPaymentsOnAccount)) or TotalExecutableAmount = InvoiceTotal">[BIIRULE-T10-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</assert>
  </rule>
  <rule context="//InvoicingPeriod">
    <assert flag="fatal" test="(EndDate and  StartDate) and not(number(translate(StartDate,'-','')) > number(translate(EndDate,'-',''))) or number(translate(StartDate,'-','')) = number(translate(EndDate,'-',''))">[BIIRULE-T10-R001]-An invoice period end date MUST be later or equal to an invoice period start date</assert>
  </rule>
  <rule context="//PaymentDetails/Installments">
    <assert flag="warning" test="(InstallmentDueDate and preceding::InvoiceIssueData/IssueDate) and not(number(translate(InstallmentDueDate,'-','')) &lt; number(translate(preceding::InvoiceIssueData/IssueDate,'-',''))) or number(translate(InstallmentDueDate,'-','')) = number(translate(preceding::InvoiceIssueData/IssueDate,'-',''))">[BIIRULE-T10-R006]-Payment means due date in an invoice SHOULD be later or equal than issue date.</assert>
    <assert flag="warning" test="((PaymentMeans = '31') and (//AccountToBeCredited/IBAN or //AccountToBeCredited/AccountNumber)) or (PaymentMeans != '31')">[BIIRULE-T10-R007]-If payment means is funds transfer, invoice MUST have a financial account</assert>
    <assert flag="warning" test="(//AccountToBeCredited/IBAN and //AccountToBeCredited/BIC) or not(//AccountToBeCredited/IBAN)">[BIIRULE-T10-R008]-If bank account is IBAN the bank identifier SHOULD also be provided.</assert>
    <assert flag="fatal" test="//PaymentMeans">[BIIRULE-T10-R044]-When specifying payment means, the invoice MUST specify the payment means code</assert>
  </rule>
  <rule context="//TaxesOutputs">
    <assert flag="fatal" test="//TaxTypeCode">[BIIRULE-T10-R049]-Every tax scheme MUST be defined through an identifier.</assert>
  </rule>
</pattern>
</schema>
