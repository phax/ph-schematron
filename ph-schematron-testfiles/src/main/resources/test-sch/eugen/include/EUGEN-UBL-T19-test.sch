<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--

    Version: MPL 1.1/EUPL 1.1

    The contents of this file are subject to the Mozilla Public License Version
    1.1 (the "License"); you may not use this file except in compliance with
    the License. You may obtain a copy of the License at:
    http://www.mozilla.org/MPL/

    Software distributed under the License is distributed on an "AS IS" basis,
    WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
    for the specific language governing rights and limitations under the
    License.

    The Original Code is Copyright The PEPPOL project (http://www.peppol.eu)

    Alternatively, the contents of this file may be used under the
    terms of the EUPL, Version 1.1 or - as soon they will be approved
    by the European Commission - subsequent versions of the EUPL
    (the "Licence"); You may not use this work except in compliance
    with the Licence.
    You may obtain a copy of the Licence at:
    http://joinup.ec.europa.eu/software/page/eupl/licence-eupl

    Unless required by applicable law or agreed to in writing, software
    distributed under the Licence is distributed on an "AS IS" basis,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the Licence for the specific language governing permissions and
    limitations under the Licence.

    If you wish to allow use of your version of this file only
    under the terms of the EUPL License and not to allow others to use
    your version of this file under the MPL, indicate your decision by
    deleting the provisions above and replace them with the notice and
    other provisions required by the EUPL License. If you do not delete
    the provisions above, a recipient may use your version of this file
    under either the MPL or the EUPL License.

-->
<!--This file is generated automatically! Do NOT edit!-->
<!--Schematron tests for binding UBL and transaction T19-->
<pattern is-a="T19" id="UBL-T19" xmlns="http://purl.oclc.org/dsdl/schematron">
  <param name="EUGEN-T19-R001" value="(cbc:UBLVersionID)" />
  <param name="EUGEN-T19-R002" value="(cbc:CustomizationID)" />
  <param name="EUGEN-T19-R003" value="(cbc:ProfileID)" />
  <param name="EUGEN-T19-R005" value="(cac:PartyLegalEntity/cbc:CompanyID)" />
  <param name="EUGEN-T19-R006" value="(cbc:Telephone)" />
  <param name="EUGEN-T19-R007" value="(not(cac:PartyIdentification/cbc:ID) and (cac:PartyName/cbc:Name)) or (cac:PartyIdentification/cbc:ID)" />
  <param name="EUGEN-T19-R009" value="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID=&#39;VAT&#39; and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))" />
  <param name="EUGEN-T19-R010" value="(cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)" />
  <param name="EUGEN-T19-R012" value="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)" />
  <param name="EUGEN-T19-R013" value="(cbc:PriceAmount) &gt;=0" />
  <param name="EUGEN-T19-R015" value="((cac:CommodityClassification/cbc:CommodityCode) and (cac:CommodityClassification/cbc:ItemClassificationCode)) or not(cac:CommodityClassification)" />
  <param name="EUGEN-T19-R016" value="((//cac:ValidityPeriod) and (/ubl:Catalogue/cac:ValidityPeriod) and (//cac:ValidityPeriod/cbc:StartDate)&gt;(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate) and (//cac:ValidityPeriod/cbc:EndDate)&lt;(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate)) or not(//cac:ValidityPeriod) or not(/ubl:Catalogue/cac:ValidityPeriod)" />
  <param name="EUGEN-T19-R017" value="(cbc:Description)" />
  <param name="EUGEN-T19-R018" value="(cac:ClassifiedTaxCategory/cbc:ID)" />
  <param name="EUGEN-T19-R019" value="(cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID)" />
  <param name="EUGEN-T19-R020" value="(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode)" />
  <param name="EUGEN-T19-R023" value="(cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)" />
  <param name="EUGEN-T19-R024" value="(not(cac:PartyIdentification/cbc:ID) and (cac:PartyName/cbc:Name)) or (cac:PartyIdentification/cbc:ID)" />
  <param name="EUGEN-T19-R025" value="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID=&#39;VAT&#39; and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))" />
  <param name="EUGEN-T19-R027" value="(not(cbc:ID) and (cbc:ContractType)) or (cbc:ID)" />
  <param name="EUGEN-T19-R028" value="count(cac:ReferencedContract) &lt;=1" />
  <param name="EUGEN-T19-R029" value="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:StartDate,&#39;-&#39;,&#39;&#39;)) &gt; number(translate(cbc:EndDate,&#39;-&#39;,&#39;&#39;))) or number(translate(cbc:EndDate,&#39;-&#39;,&#39;&#39;)) = number(translate(cbc:StartDate,&#39;-&#39;,&#39;&#39;))" />
  <param name="EUGEN-T19-R030" value="(cbc:EndpointID)" />
  <param name="EUGEN-T19-R031" value="(cbc:EndpointID)" />
  <param name="EUGEN-T19-R032" value="((cbc:OrderableIndicator=true()) and cbc:OrderableUnit) or (cbc:OrderableIndicator=false()) or not(cbc:OrderableIndicator)" />
  <param name="EUGEN-T19-R033" value="((cbc:MaximumOrderQuantity) and (cbc:MinimumOrderQuantity) and (number(cbc:MaximumOrderQuantity) &gt;= number(cbc:MinimumOrderQuantity))) or not(cbc:MaximumOrderQuantity) or not(cbc:MinimumOrderQuantity)" />
  <param name="EUGEN-T19-R034" value="((cbc:MaximumQuantity) and (cbc:MinimumQuantity) and (number(cbc:MaximumQuantity) &gt;= number(cbc:MinimumQuantity))) or not(cbc:MaximumQuantity) or not(cbc:MinimumQuantity)" />
  <param name="EUGEN-T19-R036" value="((cbc:MinimumOrderQuantity) and (cbc:MinimumOrderQuantity) &gt;=0) or not(cbc:MinimumOrderQuantity)" />
  <param name="EUGEN-T19-R037" value="(cbc:MaximumOrderQuantity)" />
  <param name="EUGEN-T19-R038" value="(cbc:MinimumOrderQuantity)" />
  <param name="EUGEN-T19-R039" value="((cbc:MaximumOrderQuantity) and (cbc:MaximumOrderQuantity) &gt;=0) or not(cbc:MaximumOrderQuantity)" />
  <param name="EUGEN-T19-R040" value="(cbc:ID)" />
  <param name="EUGEN-T19-R041" value="(cac:SellersItemIdentification/cbc:ID)" />
  <param name="EUGEN-T19-R042" value="((cbc:PriceAmount) and (cbc:BaseQuantity)) or not (cbc:PriceAmount)" />
  <param name="Catalogue_Line" value="//cac:CatalogueLine" />
  <param name="Catalogue_validity_period" value="//cac:ValidityPeriod" />
  <param name="Catalogue_receiver_party" value="//cac:ReceiverParty" />
  <param name="Catalogue_provider_party" value="//cac:ProviderParty" />
  <param name="Catalogue" value="/ubl:Catalogue" />
  <param name="Supplier_Contact" value="//cac:SellerSupplierParty/cac:Party/cac:Contact" />
  <param name="Supplier" value="//cac:SellerSupplierParty/cac:Party" />
  <param name="Seller_Address" value="//cac:SellerSupplierParty/cac:Party/cac:PostalAddress" />
  <param name="Item_Property" value="//cac:AdditionalItemProperty" />
  <param name="Document_Reference" value="//cac:DocumentReference" />
  <param name="Customer_Address" value="//cac:ContractorCustomerParty/cac:Party/cac:PostalAddress" />
  <param name="Customer" value="//cac:ContractorCustomerParty/cac:Party" />
  <param name="Contract" value="//cac:ReferencedContract" />
  <param name="Party" value="//cac:Party" />
  <param name="Item_Price" value="//cac:RequiredItemLocationQuantity/cac:Price" />
  <param name="Item_Location_Price" value="//cac:RequiredItemLocationQuantity" />
  <param name="Item" value="//cac:Item" />
</pattern>
