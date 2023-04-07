<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>EUGEN T19 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" />
  <phase id="EUGEN_T19_phase">
    <active pattern="UBL-T19" />
  </phase>
  
  <pattern id="UBL-T19">
  <rule context="//cac:ContractorCustomerParty/cac:Party">
    <assert flag="warning" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">[EUGEN-T19-R025]-In cross border trade the VAT identifier for the customer should be prefixed with country code.</assert>
    <assert flag="fatal" test="(not(cac:PartyIdentification/cbc:ID) and (cac:PartyName/cbc:Name)) or (cac:PartyIdentification/cbc:ID)">[EUGEN-T19-R024]-If buyer customer party ID is not specified, buyer party name is mandatory</assert>
  </rule>
  <rule context="/ubl:Catalogue">
    <assert flag="warning" test="count(cac:ReferencedContract) &lt;=1">[EUGEN-T19-R028]-Contract reference SHOULD be only one</assert>
    <assert flag="fatal" test="(cbc:ProfileID)">[EUGEN-T19-R003]-The profile ID is dependent on the profile in which the transaction is being used.</assert>
    <assert flag="fatal" test="(cbc:CustomizationID)">[EUGEN-T19-R002]-CustomizationID MUST  comply with CEN/BII transactions definitions</assert>
    <assert flag="fatal" test="(cbc:UBLVersionID)">[EUGEN-T19-R001]-UBL VersionID MUST define a supported syntaxbinding</assert>
  </rule>
  <rule context="//cac:ProviderParty">
    <assert flag="fatal" test="(cbc:EndpointID)">[EUGEN-T19-R031]-Provider party endpoint identifier MUST be filled in </assert>
  </rule>
  <rule context="//cac:RequiredItemLocationQuantity">
    <assert flag="warning" test="((cbc:MaximumQuantity) and (cbc:MinimumQuantity) and (number(cbc:MaximumQuantity) >= number(cbc:MinimumQuantity))) or not(cbc:MaximumQuantity) or not(cbc:MinimumQuantity)">[EUGEN-T19-R034]-Catalogue line Maximum_quantity SHOULD be greater than the Minimum quantity (it is applied to the section Item location.quantity.maximum_quantity) </assert>
    <assert flag="warning" test="((//cac:ValidityPeriod) and (/ubl:Catalogue/cac:ValidityPeriod) and (//cac:ValidityPeriod/cbc:StartDate)>(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate) and (//cac:ValidityPeriod/cbc:EndDate)&lt;(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate)) or not(//cac:ValidityPeriod) or not(/ubl:Catalogue/cac:ValidityPeriod)">[EUGEN-T19-R016]-Line validity period SHOULD be within the range of the whole catalogue validity period</assert>
  </rule>
  <rule context="//cac:Party">
    <assert flag="warning" test="(cac:PartyLegalEntity/cbc:CompanyID)">[EUGEN-T19-R005]-Party.Party Tax Scheme. Company Identifier SHOULD be present</assert>
  </rule>
  <rule context="//cac:ReceiverParty">
    <assert flag="fatal" test="(cbc:EndpointID)">[EUGEN-T19-R030]-Receiver party endpoint identifier MUST be filled in </assert>
  </rule>
  <rule context="//cac:RequiredItemLocationQuantity/cac:Price">
    <assert flag="fatal" test="(cbc:PriceAmount) >=0">[EUGEN-T19-R013]-Prices of items MUST be positive or equal to zero NOT negative amounts</assert>
  </rule>
  <rule context="//cac:ReferencedContract">
    <assert flag="fatal" test="(not(cbc:ID) and (cbc:ContractType)) or (cbc:ID)">[EUGEN-T19-R027]-If Contract Identifier is not specified SHOULD Contract Type text be used for Contract Reference </assert>
  </rule>
  <rule context="//cac:SellerSupplierParty/cac:Party/cac:PostalAddress">
    <assert flag="warning" test="(cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)">[EUGEN-T19-R010]-A seller party address in an catalogue SHOULD contain at least Street Name, City name and Zip code and Country code </assert>
  </rule>
  <rule context="//cac:SellerSupplierParty/cac:Party">
    <assert flag="warning" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">[EUGEN-T19-R009]-In cross border trade the VAT identifier for the supplier MUST be prefixed with country code.</assert>
    <assert flag="fatal" test="(not(cac:PartyIdentification/cbc:ID) and (cac:PartyName/cbc:Name)) or (cac:PartyIdentification/cbc:ID)">[EUGEN-T19-R007]-If seller supplier party ID is not specified, seller supplier party name is mandatory</assert>
  </rule>
  <rule context="//cac:ValidityPeriod">
    <assert flag="warning" test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:StartDate,'-','')) > number(translate(cbc:EndDate,'-',''))) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-',''))">[EUGEN-T19-R029]-A validity period end date SHOULD be later or equal to a validity period start date</assert>
  </rule>
  <rule context="//cac:Item">
    <assert flag="warning" test="(cac:SellersItemIdentification/cbc:ID)">[EUGEN-T19-R041]-Sellers_ Item Identification. Item Identification section SHOULD be present</assert>
    <assert flag="warning" test="(cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID)">[EUGEN-T19-R019]-Item Tax Scheme SHOULD be present</assert>
    <assert flag="warning" test="(cac:ClassifiedTaxCategory/cbc:ID)">[EUGEN-T19-R018]-Item Tax Category SHOULD be present</assert>
    <assert flag="warning" test="(cbc:Description)">[EUGEN-T19-R017]-Item should have a Description – Invoice is the NAME!!</assert>
    <assert flag="fatal" test="((cac:CommodityClassification/cbc:CommodityCode) and (cac:CommodityClassification/cbc:ItemClassificationCode)) or not(cac:CommodityClassification)">[EUGEN-T19-R015]-Item Commodity Classification: both Classification Commodity codes and Item classification code MUST be filled</assert>
    <assert flag="warning" test="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)">[EUGEN-T19-R012]-If standard identifiers are provided within an item description, an Schema Identifier SHOULD be provided (e.g. GTIN)</assert>
  </rule>
  <rule context="//cac:SellerSupplierParty/cac:Party/cac:Contact">
    <assert flag="warning" test="(cbc:Telephone)">[EUGEN-T19-R006]-A party contact telephone text SHOULD be filled in</assert>
  </rule>
  <rule context="//cac:CatalogueLine">
    <assert flag="warning" test="((cbc:PriceAmount) and (cbc:BaseQuantity)) or not (cbc:PriceAmount)">[EUGEN-T19-R042]-If Price amount is used than Price Base Quantity SHOUL be higher than zero</assert>
    <assert flag="fatal" test="(cbc:ID)">[EUGEN-T19-R040]-Contract reference SHOULD always present</assert>
    <assert flag="warning" test="((cbc:MaximumOrderQuantity) and (cbc:MaximumOrderQuantity) >=0) or not(cbc:MaximumOrderQuantity)">[EUGEN-T19-R039]-Catalogue line Maximum_quantity SHOULD NOT be negative</assert>
    <assert flag="warning" test="(cbc:MinimumOrderQuantity)">[EUGEN-T19-R038]-Catalogue line Mimimum_quantity SHOULD be present</assert>
    <assert flag="warning" test="(cbc:MaximumOrderQuantity)">[EUGEN-T19-R037]-Catalogue line Maximum_quantity SHOULD be present</assert>
    <assert flag="warning" test="((cbc:MinimumOrderQuantity) and (cbc:MinimumOrderQuantity) >=0) or not(cbc:MinimumOrderQuantity)">[EUGEN-T19-R036]-Catalogue line Mimimum_quantity SHOULD NOT be negative</assert>
    <assert flag="warning" test="((cbc:MaximumOrderQuantity) and (cbc:MinimumOrderQuantity) and (number(cbc:MaximumOrderQuantity) >= number(cbc:MinimumOrderQuantity))) or not(cbc:MaximumOrderQuantity) or not(cbc:MinimumOrderQuantity)">[EUGEN-T19-R033]-Catalogue line Maximum_quantity SHOULD be greater or equal to the Minimum quantity: it is applied in all the section in  a Catalogue line where are included Maximum and minimum quantity (it is applied at section Max order quantity)</assert>
    <assert flag="fatal" test="((cbc:OrderableIndicator=true()) and cbc:OrderableUnit) or (cbc:OrderableIndicator=false()) or not(cbc:OrderableIndicator)">[EUGEN-T19-R032]-If Orderable Indicator is se to Yes than Orderable Unit (text) MUST not be blank</assert>
  </rule>
  <rule context="//cac:ContractorCustomerParty/cac:Party/cac:PostalAddress">
    <assert flag="warning" test="(cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)">[EUGEN-T19-R023]-A Customer party address in an catalogue SHOULD contain at least Street Name, City name and Zip code and Country code.</assert>
  </rule>
  <rule context="//cac:DocumentReference">
    <assert flag="warning" test="(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode)">[EUGEN-T19-R020]-Mime code Should be given for embedded binary object accordingly to codelist</assert>
  </rule>
</pattern>
</schema>
