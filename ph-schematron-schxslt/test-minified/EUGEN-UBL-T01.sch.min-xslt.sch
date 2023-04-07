<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>EUGEN T01 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2" />
  <phase id="EUGEN_T01_phase">
    <active pattern="UBL-T01" />
  </phase>
  
  <pattern id="UBL-T01">
  <rule context="//cac:OrderLine/cac:LineItem">
    <assert flag="warning" test="(cbc:Quantity) and (cbc:Quantity/@unitCode)">[EUGEN-T01-R005]-Each order line SHOULD contain the quantity</assert>
    <assert flag="fatal" test="number(cbc:LineExtensionAmount) >= 0">[EUGEN-T01-R009]-Line extension amount MUST NOT be negative</assert>
    <assert flag="fatal" test="number(cbc:Quantity) >= 0">[EUGEN-T01-R010]-Quantity ordered MUST not be negative</assert>
  </rule>
  <rule context="//cac:AllowanceCharge">
    <assert flag="warning" test="(cbc:AllowanceChargeReason)">[EUGEN-T01-R004]-Allowance Charge reason text SHOULD be specified for all allowances and charges</assert>
    <assert flag="fatal" test="number(cbc:Amount) >= 0">[EUGEN-T01-R006]-An allowance amount MUST NOT be negative.</assert>
  </rule>
  <rule context="//cac:BuyerCustomerParty/cac:Party">
    <assert flag="warning" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">[EUGEN-T01-R002]-A customer postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</assert>
  </rule>
  <rule context="//cac:Delivery/cac:RequestedDeliveryPeriod">
    <assert flag="fatal" test="(cbc:StartDate) or (cbc:EndDate) or (cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-','')))">[EUGEN-T01-R007]-A delivery period MUST have either the start date or the end date </assert>
  </rule>
  <rule context="//cac:Delivery/cac:DeliveryLocation/cac:Address">
    <assert flag="warning" test="(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)">[EUGEN-T01-R003]-A Delivery address  SHOULD contain at least, city, zip code and country code.</assert>
  </rule>
  <rule context="//cac:SellerSupplierParty/cac:Party">
    <assert flag="warning" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">[EUGEN-T01-R001]-A supplier postal address in an order SHOULD contain at least street name and number, city name, zip code and country code.</assert>
  </rule>
  <rule context="//cac:AnticipatedMonetaryTotal">
    <assert flag="fatal" test="number(cbc:PayableAmount) >= 0">[EUGEN-T01-R008]-Total payable amount MUST NOT be negative</assert>
  </rule>
</pattern>
</schema>
