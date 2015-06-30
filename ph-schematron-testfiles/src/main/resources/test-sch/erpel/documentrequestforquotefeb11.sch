<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" schemaVersion="iso">
  <title>Schematron for DocumentRequestForQuote</title>
  <ns uri="http://erpel.at/schemas/1p0/documents" prefix="p1"/>
  <ns uri="http://erpel.at/schemas/1p0/documents/ext" prefix="ext"/>
  <ns uri="http://erpel.at/schemas/1p0/documents/extensions/pharmaceuticals" prefix="pharmaceuticals"/>
  <ns uri="http://erpel.at/schemas/1p0/documents/extensions/telecom" prefix="telecom"/>
  <ns uri="http://www.w3.org/2000/09/xmldsig#" prefix="dsig"/>
   <!-- SCHEMATRON REQUEST FOR QUOTE
	-->
	<!-- The element DeliveryDateConfirmed must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:DeliveryDateConfirmed)">
			Regel 1: Element 'p1:DeliveryDateConfirmed' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element ShippingDate must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->
    <pattern>
    <rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:ShippingDate)">
			Regel 2: Element '/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:ShippingDate' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element NameOfDriver must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:NameOfDriver)">
			Regel 3: Element '/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:NameOfDriver' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element NumberOfPackages must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:NumberOfPackages)">
			Regel 4: Element '/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:NumberOfPackages' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element TransportVehicleNumber must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:TransportVehicleLicenseNumber)">
			Regel 5: Element '/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:TransportVehicleLicenseNumber' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element DeliveryDateConfirmed must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails.
	-->
   <pattern>
    <rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:DeliveryDateConfirmed)">
			Regel 6: Element '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:DeliveryDateConfirmed' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element NameOfDriver must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:NameOfDriver)">
			Regel 7: Element '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:NameOfDriver' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element NumberOfPackages must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:NumberOfPackages)">
			Regel 8: Element '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:NumberOfPackages' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element ShippingDate must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:ShippingDate)">
			Regel 9: Element '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:ShippingDate' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element TransportVehicleNumber must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
      <assert test="not(p1:TransportVehicleLicenseNumber)">
			Regel 10: Element '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:TransportVehicleLicenseNumber' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element DiscountFlag must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem.
	-->
 <pattern>
    <rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem">
      <assert test="not(p1:DiscountFlag)">
			Regel 11: Element 'p1:DiscountFlag' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
  </pattern>
  <!-- The element TaxRate must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem">
      <assert test="not(p1:TaxRate)">
			Regel 12: Element '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate' soll in diesem Kontext nicht verwendet werden.</assert>
    </rule>
     </pattern>
     <!-- The attribute TaxCode must be declared within /p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate.
	-->
  <pattern>
    <rule context="/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate">
      <assert test="@p1:TaxCode">
			Regel 13: Das Attribut '/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate/@p1:TaxCode' ist in diesem Kontext erforderlich..</assert>
    </rule>
  </pattern>
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:Supplier/p1:Address.
	-->
	<pattern>
		<rule context="/p1:Document/p1:Supplier/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 14: Straße oder POBox wurde in Document/Supplier/Address nicht angegeben.</assert>
		</rule>
		</pattern>
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:Customer/p1:Address.
	-->
	<pattern>
		<rule context="/p1:Document/p1:Customer/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 15: Straße oder POBox wurde in DocumentCustomer/Address nicht angegeben.</assert>
		</rule>
	</pattern>
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:OrderingParty/p1:Address.
	-->
	<pattern>
		<rule context="/p1:Document/p1:OrderingParty/p1:Address">
			<assert test="p1:Street or p1:POBox">
			  Regel 16: Straße oder POBox wurde in Document/OrderingParty/Address nicht angegeben.</assert>
		</rule>
	</pattern>	
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:Shipper/p1:Address.
	-->
	<pattern>
		<rule context="/p1:Document/p1:Shipper/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 17: Straße oder POBox wurde in Document/:Shipper/Address nicht angegeben.</assert>
		</rule>
	</pattern>
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:Delivery/p1:DeliveryRecipient/p1:Address.
	-->
	<pattern>
		<rule context="/p1:Document/p1:Delivery/p1:DeliveryRecipient/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 18: Straße oder POBox wurde in Document/Delivery/DeliveryRecipient/Address nicht angegeben.</assert>
		</rule>
	</pattern>
		<!-- The elements SuppliersArticleNumber OR CustomersArticleNumber must be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:ArticleNumber.
	-->
	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:ArticleNumber">
			<assert test="p1:SuppliersArticleNumber or p1:CustomersArticleNumber">
			   Regel 19: Eine Artikelnummer wurde in Document/Details/ItemList/ListLineItem/ArticleNumber nicht angegeben.</assert>
		</rule>
	</pattern>
		<!-- The elements Date AND Period must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->
	<pattern>
		<rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails">
			<assert test="not(p1:Date and p1:Period)">
			   Regel 20: Die Angabe von Date UND Period ist in Document/Details/ItemList/ListLineItem/Delivery/DeliveryDetails unzulässig.</assert>
		</rule>
	</pattern>	
	<!-- The attributes FromDate AND ToDate must be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period.
	-->	
		<pattern>
		<rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period">
			<assert test="@p1:FromDate and @p1:ToDate">
			   Regel 21: Die Attribute FromDate und ToDate müssen in 'p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period' angegeben werden.</assert>
		</rule>
	</pattern>	
	
		<!-- The elements Date AND Period must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails.
	-->
	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
			<assert test="not(p1:Date and p1:Period)">
			   Regel 22: Die Angabe von Date UND Period ist in Document/Details/ItemList/ListLineItem/Delivery/DeliveryDetails unzulässig.</assert>
		</rule>
	</pattern>	
	<!-- The attributes FromDate AND ToDate must be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period.
	-->	
		<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period">
			<assert test="@p1:FromDate and @p1:ToDate">
			   Regel 23: Die Attribute FromDate und ToDate müssen in 'p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period' angegeben werden.</assert>
		</rule>
	</pattern>	
		<!-- The element ListLineItenReduction was not declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem AND must contain the elements ReductionAmount OR ReductionRate.
	-->
	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem">
			<assert test="p1:ListLineItemReduction and (p1:ListLineItemReduction/p1:ReductionAmount or p1:ListLineItemReduction/p1:ReductionRate)">
			   Regel 24: Das Element ListLineItemReduction ist in Document/Details/ItemList/ListLineItem nicht vorhanden und muss entweder ein Element ReductionAmount oder ein Element ReductionRate enthalten.</assert>
		</rule>
	</pattern>	
		<!-- The attribute DocumentType must be declared within/p1:Document and named as RequestForQuote.
	-->
	<pattern>
		<rule context="/p1:Document">
			<assert test="@p1:DocumentType='RequestForQuote'">
			  Regel 25: Der DocumentType entspricht nicht einer RequestForQuote</assert>
		</rule>
	</pattern>
</schema>