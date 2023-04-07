<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="iso">
  <title>Schematron for DocumentOffer</title>
  <ns prefix="p1" uri="http://erpel.at/schemas/1p0/documents" />
  <ns prefix="ext" uri="http://erpel.at/schemas/1p0/documents/ext" />
  <ns prefix="pharmaceuticals" uri="http://erpel.at/schemas/1p0/documents/extensions/pharmaceuticals" />
  <ns prefix="telecom" uri="http://erpel.at/schemas/1p0/documents/extensions/telecom" />
  <ns prefix="dsig" uri="http://www.w3.org/2000/09/xmldsig#" />
   <!-- SCHEMATRON OFFER
	-->

	<!-- The element DeliveryDateConfirmed must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->

  	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
			<assert test="not(p1:DeliveryDateConfirmed)">
	Regel 1: Element '/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:DeliveryDateConfirmed' soll in diesem Kontext nicht verwendet werden.</assert>
		</rule>
	</pattern>
	<!-- The element ShippingDate must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
			<assert test="not(p1:ShippingDate)">
	Regel 2: Element 'p1:ShippingDate' soll in diesem Kontext nicht verwendet werden.</assert>
		</rule>
	</pattern>
	<!-- The element UnitPrice must be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem">
			<assert test="p1:UnitPrice">
	Regel 3: Das Element 'p1:UnitPrice' ist in diesem Kontext erforderlich.</assert>
		</rule>
	</pattern>
	<!-- The attribute TaxCode must be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:TaxRate">
			<assert test="@p1:TaxCode">
	Regel 4: Das Attribut '@p1:TaxCode' ist in diesem Kontext erforderlich.</assert>
		</rule>
	</pattern>
	<!-- The elements PaymentDate AND Percentage must be declared once within /p1:Document/p1:PaymentConditions/p1:Discount.
	-->

	<pattern>
		<rule context="/p1:Document/p1:PaymentConditions/p1:Discount">
			<assert test="count(p1:PaymentDate)=1">
	Regel 5: Das Element 'p1:PaymentDate' muss genau 1 mal auftreten.</assert>
			<assert test="count(p1:Percentage)=1">
	Regel 6: Das Element 'p1:Percentage' muss genau 1 mal auftreten.</assert>
		</rule>
	</pattern>
	<!-- The attribute TaxCode must be declared within /p1:Document/p1:ReductionDetails/p1:Reduction/p1:TaxRate.
	-->

	<pattern>
		<rule context="/p1:Document/p1:ReductionDetails/p1:Reduction/p1:TaxRate">
			<assert test="@p1:TaxCode">
	Regel 7: Das Attribut '@p1:TaxCode' ist in diesem Kontext erforderlich.</assert>
		</rule>
	</pattern>
	<!-- The element TaxRate must be declared within /p1:Document/p1:Tax/p1:VAT/p1:Item.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Tax/p1:VAT/p1:Item/p1:TaxRate">
			<assert test="@p1:TaxCode">
	Regel 8: Das Attribut '@p1:TaxCode' ist in diesem Kontext erforderlich.</assert>
		</rule>
	</pattern>
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:Supplier/p1:Address.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Supplier/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 9: Straße oder POBox wurde in Document/Supplier/Address nicht angegeben.</assert>
		</rule>
		</pattern>
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:Customer/p1:Address.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Customer/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 10: Straße oder POBox wurde in DocumentCustomer/Address nicht angegeben.</assert>
		</rule>
	</pattern>
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:OrderingParty/p1:Address.
	-->

	<pattern>
		<rule context="/p1:Document/p1:OrderingParty/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 11: Straße oder POBox wurde in Document/OrderingParty/Address nicht angegeben.</assert>
		</rule>
	</pattern>	
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:Shipper/p1:Address.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Shipper/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 12: Straße oder POBox wurde in Document/:Shipper/Address nicht angegeben.</assert>
		</rule>
	</pattern>
		<!-- The elements Street OR POBox must be declared within /p1:Document/p1:Delivery/p1:DeliveryRecipient/p1:Address.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Delivery/p1:DeliveryRecipient/p1:Address">
			<assert test="p1:Street or p1:POBox">
			   Regel 13: Straße oder POBox wurde in Document/Delivery/DeliveryRecipient/Address nicht angegeben.</assert>
		</rule>
	</pattern>
		<!-- The elements SuppliersArticleNumber OR CustomersArticleNumber must be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:ArticleNumber.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:ArticleNumber">
			<assert test="p1:SuppliersArticleNumber or p1:CustomersArticleNumber">
			   Regel 14: Eine Artikelnummer wurde in Document/Details/ItemList/ListLineItem/ArticleNumber nicht angegeben.</assert>
		</rule>
	</pattern>
		<!-- The elements Date AND Period must not be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails">
			<assert test="not(p1:Date and p1:Period)">
			   Regel 15: Die Angabe von Date UND Period ist in Document/Details/ItemList/ListLineItem/Delivery/DeliveryDetails unzulässig.</assert>
		</rule>
	</pattern>	
	<!-- The attributes FromDate AND ToDate must be declared within /p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period.
	-->

	
		<pattern>
		<rule context="/p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period">
			<assert test="@p1:FromDate and @p1:ToDate">
			   Regel 16: Die Attribute FromDate und ToDate müssen in 'p1:Document/p1:Delivery/p1:DeliveryDetails/p1:Period' angegeben werden.</assert>
		</rule>
	</pattern>	
	
		<!-- The elements Date AND Period must not be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails">
			<assert test="not(p1:Date and p1:Period)">
			  Regel 17: Die Angabe von Date UND Period ist in Document/Details/ItemList/ListLineItem/Delivery/DeliveryDetails unzulässig.</assert>
		</rule>
	</pattern>	
	<!-- The attributes FromDate AND ToDate must be declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period.
	-->
	
		<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period">
			<assert test="@p1:FromDate and @p1:ToDate">
			   Regel 18: Die Attribute FromDate und ToDate müssen in 'p1:Document/p1:Details/p1:ItemList/p1:ListLineItem/p1:Delivery/p1:DeliveryDetails/p1:Period' angegeben werden.</assert>
		</rule>
	</pattern>	
		<!-- The element ListLineItenReduction was not declared within /p1:Document/p1:Details/p1:ItemList/p1:ListLineItem AND must contain the elements ReductionAmount OR ReductionRate.
	-->

	<pattern>
		<rule context="/p1:Document/p1:Details/p1:ItemList/p1:ListLineItem">
			<assert test="p1:ListLineItemReduction and (p1:ListLineItemReduction/p1:ReductionAmount or p1:ListLineItemReduction/p1:ReductionRate)">
			   Regel 19: Das Element ListLineItemReduction ist in Document/Details/ItemList/ListLineItem nicht vorhanden und muss entweder ein Element ReductionAmount oder ein Element ReductionRate enthalten.</assert>
		</rule>
	</pattern>	
	<!-- The element TotalGrossAmount must be declared within/p1:Document.
	-->

	<pattern>
		<rule context="/p1:Document">
			<assert test="p1:TotalGrossAmount">
			   Regel 20: Ein TotalGrossAmount muß in Document angegeben werden.</assert>
		</rule>
	</pattern>		
		<!-- The attribute DocumentType must be declared within/p1:Document and named as Offer.
	-->

	<pattern>
		<rule context="/p1:Document">
			<assert test="@p1:DocumentType='Offer'">
			  Regel 21: Der DocumentType entspricht nicht einer Offer</assert>
		</rule>
	</pattern>
</schema>
