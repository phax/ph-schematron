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
<!--Schematron tests for binding UBL and transaction T01-->
<pattern is-a="T01" id="UBL-T01" xmlns="http://purl.oclc.org/dsdl/schematron">
  <param name="BIIRULE-T01-R001" value="(cbc:UBLVersionID)" />
  <param name="BIIRULE-T01-R002" value="(cbc:CustomizationID)" />
  <param name="BIIRULE-T01-R003" value="(cbc:ProfileID)" />
  <param name="BIIRULE-T01-R004" value="(cbc:IssueDate)" />
  <param name="BIIRULE-T01-R005" value="(cbc:ID)" />
  <param name="BIIRULE-T01-R006" value="(cbc:ID)" />
  <param name="BIIRULE-T01-R007" value="(cbc:ID)" />
  <param name="BIIRULE-T01-R008" value="(cbc:ID) and (cbc:ID != &#39;&#39; )" />
  <param name="BIIRULE-T01-R009" value="(cac:Party/cac:PartyName/cbc:Name)" />
  <param name="BIIRULE-T01-R010" value="(cac:Party/cac:PartyName/cbc:Name)" />
  <param name="BIIRULE-T01-R011" value="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,&#39;-&#39;,&#39;&#39;)) &lt;= number(translate(cbc:EndDate,&#39;-&#39;,&#39;&#39;)))" />
  <param name="BIIRULE-T01-R012" value="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)" />
  <param name="BIIRULE-T01-R013" value="(cac:Item/cbc:Name) or (cac:Item/cac:StandardItemIdentification/cbc:ID) or (cac:Item/cac:SellersItemIdentification/cbc:ID)" />
  <param name="BIIRULE-T01-R014" value="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)" />
  <param name="BIIRULE-T01-R015" value="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID=&#39;VAT&#39; and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))" />
  <param name="BIIRULE-T01-R016" value="(cac:OrderLine/cac:LineItem)" />
  <param name="BIIRULE-T01-R017" value="(cbc:ID)" />
  <param name="BIIRULE-T01-R018" value="number(cbc:LineExtensionAmount) = number(round(sum(//cac:LineItem/cbc:LineExtensionAmount) * 10 *10) div 100)" />
  <param name="BIIRULE-T01-R019" value="(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(/ubl:Order/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)" />
  <param name="BIIRULE-T01-R020" value="(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(/ubl:Order/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount) * 10 *10) div 100) or not(cbc:ChargeTotalAmount)" />
  <param name="BIIRULE-T01-R021" value="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount) + round(sum(preceding::cac:TaxTotal/cbc:TaxAmount) *10 *10) div 100 ) *10 *10) div 100)) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount) + round(sum(preceding::cac:TaxTotal/cbc:TaxAmount) *10 *10) div 100 ) *10*10) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)+ round(sum(preceding::cac:TaxTotal/cbc:TaxAmount) *10 *10) div 100 ) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and not(preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount) ) * 10 * 10) div 100)) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and not(preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount) ) * 10 * 10) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and not(preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) + 10 * 10) div 100)) or(not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (preceding::cac:TaxTotal/cbc:TaxAmount) and (number(cbc:PayableAmount) = round(( number(cbc:LineExtensionAmount) + round(sum(preceding::cac:TaxTotal/cbc:TaxAmount) *10 *10) div 100 ) * 10 * 10) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and not(preceding::cac:TaxTotal/cbc:TaxAmount) and number(cbc:LineExtensionAmount) = number(cbc:PayableAmount))" />
  <param name="BIIRULE-T01-R023" value="string-length(string(cbc:Name)) &lt;= 50" />
  <param name="BIIRULE-T01-R024" value="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)" />
  <param name="BIIRULE-T01-R025" value="not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)" />
  <param name="BIIRULE-T01-R026" value="number(.) &gt;= 0" />
  <param name="BIIRULE-T01-R027" value="not(//@currencyID != //cbc:DocumentCurrencyCode)" />
  <param name="BIIRULE-T01-R028" value="(cbc:IdentificationCode)" />
  <param name="BIIRULE-T01-R029" value="number(cbc:TaxAmount) = number(round(sum(//cac:OrderLine/cac:LineItem/cbc:TotalTaxAmount) * 10 * 10) div 100)" />
  <param name="BIIRULE-T01-R030" value="(cbc:DocumentCurrencyCode)" />
  <param name="BIIRULE-T01-R031" value="count(//*[substring(name(),string-length(name())-7) = &#39;Quantity&#39;][@unitCode]) = count(//*[substring(name(),string-length(name())-7) = &#39;Quantity&#39;])" />
  <param name="Customer" value="//cac:BuyerCustomerParty" />
  <param name="Order_Line" value="//cac:LineItem" />
  <param name="Requested_delivery_period" value="//cac:RequestedDeliveryPeriod" />
  <param name="Order" value="/ubl:Order" />
  <param name="Item_Price" value="//cac:LineItem/cac:Price/cbc:PriceAmount" />
  <param name="Item" value="//cac:Item" />
  <param name="Supplier" value="//cac:SellerSupplierParty" />
  <param name="Tax_Total" value="/ubl:Order/cac:TaxTotal" />
  <param name="Total_Amounts" value="//cac:AnticipatedMonetaryTotal" />
  <param name="Originator_document" value="//cac:OriginatorDocumentReference" />
  <param name="Annex" value="//cac:AdditionalDocumentReference" />
  <param name="Contract" value="//cac:Contract" />
  <param name="AllowanceCharge" value="//cac:AllowanceCharge" />
  <param name="Country" value="//cac:Country" />
</pattern>
