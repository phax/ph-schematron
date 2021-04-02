<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="IT-UBL-T16" xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="//cbc:EndpointID" flag="fatal">
		<assert test="(@schemeID='0201' and matches(.,'^[a-zA-Z0-9]{6,7}$')) or @schemeID!='0201'" flag="fatal" id="IT-T16-R026">[IT-T16-R026] - If the endpoint identifier is based on the IT identifier scheme: IPA (ICD: 0201), this should follow the syntax [A-Z0-9]{6,7}.</assert>
		<assert test="(@schemeID='9906' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='9906'" flag="fatal" id="IT-T16-R027">[IT-T16-R027] - If the endpoint identifier is based on the IT identifier scheme: VAT (ICD: 9906), this should follow the syntax (IT)?[0-9]{11}.</assert>
		<assert test="(@schemeID='9907' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='9907'" flag="fatal" id="IT-T16-R028">[IT-T16-R028] - If the endpoint identifier is based on the IT identifier scheme: CF (ICD: 9907), this should follow the syntax [0-9]{11} for legal entities and syntax [A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1} for natural persons.</assert>
	</rule>

	<rule context="//cac:DespatchLine" flag="fatal"> 
		<assert test="cac:Item/cbc:Name and (cac:Item/cac:SellersItemIdentification/cbc:ID or cac:Item/cac:StandardItemIdentification/cbc:ID) and cbc:DeliveredQuantity" flag="fatal" id="IT-T16-R003">[IT-T16-R003] - The lines of the Despatch Advice MUST contain the minimum information required by Art. 21, paragraph 4 of Presidential Decree no. 633/1972 (Product name, article identifier and quantity delivered).</assert>
	</rule>

	<rule context="//cac:DespatchLine/cac:Item/cac:HazardousItem" flag="fatal"> 
		<assert test="cbc:UNDGCode" flag="fatal" id="IT-T16-R029">[IT-T16-R029] - The element 'cbc:UNDGCode' MUST be provided.</assert>
		<assert test="cbc:HazardClassID" flag="fatal" id="IT-T16-R030">[IT-T16-R030] - The element 'cbc:HazardClassID' MUST be provided.</assert>
	</rule>

	<rule context="/ubl:DespatchAdvice" flag="fatal"> 
		<assert test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1'" flag="fatal" id="IT-T16-R004">[IT-T16-R004] - The Despatch Advice CustomizationID MUST be set with string 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1'.</assert>
		<assert test="cac:DespatchSupplierParty/cac:Party[cac:PartyLegalEntity/cbc:RegistrationName and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity] and cac:DeliveryCustomerParty/cac:Party[cac:PartyLegalEntity/cbc:RegistrationName and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity] and (not(cac:BuyerCustomerParty) or (cac:BuyerCustomerParty/cac:Party[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity])) and (not(cac:SellerSupplierParty) or (cac:SellerSupplierParty/cac:Party[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity])) and cac:Shipment/cbc:GrossWeightMeasure and cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (not(cac:Shipment/cac:Consignment/cac:CarrierParty) or (cac:Shipment/cac:Consignment/cac:CarrierParty[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity]))" flag="fatal" id="IT-T16-R002">[IT-T16-R002] - The Despatch Advice header MUST contain the minimum information required by Art. 21, paragraph 4 of Presidential Decree no. 633/1972 (Identification, name and address of the Consignor / Transferor, name and address of the Consignee / Transferee, gross weight and number of packages of the shipment, details of the Transporter and address, if a third party carries out the physical transport).</assert>
		<assert test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (string(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) castable as xs:integer or cac:Shipment/cbc:TotalTransportHandlingUnitQuantity - floor(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) = 0)" flag="fatal" id="IT-T16-R005">[IT-T16-R005] - The number of packages must be an integer.</assert>
	</rule>

	<rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment">
		<assert test="cac:CarrierParty" flag="fatal" id="IT-T16-R031">[IT-T16-R031] - The element 'cac:CarrierParty' MUST be provided.</assert>
		<assert test="(some $code in $clISO3166 satisfies $code = normalize-space(cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode/text()))" flag="fatal" id="IT-T16-R032">[IT-T16-R032] - L'The element 'cac:CarrierParty' MUST be set based on Country code list (ISO 3166-1:Alpha2).</assert>
	</rule>

</pattern>
