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
<!--Schematron tests for binding UBL and transaction T14-->
<pattern is-a="T14" id="UBL-T14" xmlns="http://purl.oclc.org/dsdl/schematron">
  <param name="BIIRULE-T14-R001" value="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,&#39;-&#39;,&#39;&#39;)) &lt;= number(translate(cbc:EndDate,&#39;-&#39;,&#39;&#39;)))" />
  <param name="BIIRULE-T14-R002" value="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)" />
  <param name="BIIRULE-T14-R003" value="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID=&#39;VAT&#39; and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))" />
  <param name="BIIRULE-T14-R004" value="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)" />
  <param name="BIIRULE-T14-R005" value="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID=&#39;VAT&#39; and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))" />
  <param name="BIIRULE-T14-R009" value="count(cac:TaxSubtotal/*/*/cbc:ID) = count(cac:TaxSubtotal/*/*/cbc:ID[. = &#39;VAT&#39;]) or count(cac:TaxSubtotal/*/*/cbc:ID[. = &#39;VAT&#39;]) = 0" />
  <param name="BIIRULE-T14-R010" value="number(cbc:TaxAmount) = number(round(sum(cac:TaxSubtotal/cbc:TaxAmount) * 10 * 10) div 100)" />
  <param name="BIIRULE-T14-R011" value="number(cbc:LineExtensionAmount) = number(round(sum(//cac:CreditNoteLine/cbc:LineExtensionAmount) * 10 * 10) div 100)" />
  <param name="BIIRULE-T14-R012" value="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = number(cbc:LineExtensionAmount)))" />
  <param name="BIIRULE-T14-R013" value="((cbc:PayableRoundingAmount) and (number(cbc:TaxInclusiveAmount) = (round((number(cbc:TaxExclusiveAmount) + number(sum(/ubl:CreditNote/cac:TaxTotal/cbc:TaxAmount)) + number(cbc:PayableRoundingAmount)) *10 * 10) div 100))) or (number(cbc:TaxInclusiveAmount) = round(( number(cbc:TaxExclusiveAmount) + number(sum(/ubl:CreditNote/cac:TaxTotal/cbc:TaxAmount))) * 10 * 10) div 100)" />
  <param name="BIIRULE-T14-R014" value="number(cbc:TaxInclusiveAmount) &gt;= 0" />
  <param name="BIIRULE-T14-R015" value="(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(preceding::cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)" />
  <param name="BIIRULE-T14-R016" value="(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(preceding::cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount) * 10  *10) div 100) or not(cbc:ChargeTotalAmount)" />
  <param name="BIIRULE-T14-R017" value="(cbc:PrepaidAmount) and (number(cbc:PayableAmount) = (round((cbc:TaxInclusiveAmount - cbc:PrepaidAmount) * 10 * 10) div 100)) or number(cbc:PayableAmount) = number(cbc:TaxInclusiveAmount)" />
  <param name="BIIRULE-T14-R018" value="not(cbc:CreditedQuantity) or not(cac:Price/cbc:PriceAmount) or  number(cbc:LineExtensionAmount) = (round(number(cac:Price/cbc:PriceAmount) *number(cbc:CreditedQuantity) * 10 * 10) div 100) + ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator=&#39;true&#39;]/cbc:Amount) *10 * 10) div 100 ) - ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator=&#39;false&#39;]/cbc:Amount) *10 * 10) div 100 )" />
  <param name="BIIRULE-T14-R019" value="string-length(string(cbc:Name)) &lt;= 50" />
  <param name="BIIRULE-T14-R020" value="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)" />
  <param name="BIIRULE-T14-R021" value="not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)" />
  <param name="BIIRULE-T14-R022" value="number(.) &gt;=0" />
  <param name="BIIRULE-T14-R023" value="number(.) &gt;=0" />
  <param name="BIIRULE-T14-R024" value="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount))" />
  <param name="BIIRULE-T14-R025" value="(cbc:IssueDate)" />
  <param name="BIIRULE-T14-R026" value="(cbc:ID)" />
  <param name="BIIRULE-T14-R027" value="(cac:Item/cbc:Name)" />
  <param name="BIIRULE-T14-R028" value="(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)" />
  <param name="BIIRULE-T14-R029" value="(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)" />
  <param name="BIIRULE-T14-R030" value="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxAmount) and (number(round(sum(cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount) *10 *10  ) div 100 ) = number(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]))" />
  <param name="BIIRULE-T14-R031" value="(cbc:UBLVersionID)" />
  <param name="BIIRULE-T14-R032" value="(cbc:CustomizationID)" />
  <param name="BIIRULE-T14-R033" value="(cbc:ProfileID)" />
  <param name="BIIRULE-T14-R034" value="cbc:ID" />
  <param name="BIIRULE-T14-R035" value="(cac:CreditNoteLine)" />
  <param name="BIIRULE-T14-R036" value="(cbc:DocumentCurrencyCode)" />
  <param name="BIIRULE-T14-R037" value="(cac:LegalMonetaryTotal/cbc:PayableAmount)" />
  <param name="BIIRULE-T14-R038" value="(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount)" />
  <param name="BIIRULE-T14-R039" value="(cbc:CompanyID)" />
  <param name="BIIRULE-T14-R040" value="(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount)" />
  <param name="BIIRULE-T14-R041" value="(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)" />
  <param name="BIIRULE-T14-R042" value="(cbc:IdentificationCode)" />
  <param name="BIIRULE-T14-R043" value="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxableAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != &#39;VAT&#39;)" />
  <param name="BIIRULE-T14-R044" value="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != &#39;VAT&#39;)" />
  <param name="BIIRULE-T14-R045" value="cbc:ID" />
  <param name="BIIRULE-T14-R046" value="cbc:ID" />
  <param name="BIIRULE-T14-R047" value="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != &#39;VAT&#39;)" />
  <param name="BIIRULE-T14-R050" value="cbc:LineExtensionAmount" />
  <param name="BIIRULE-T14-R051" value="cac:Price/cbc:PriceAmount" />
  <param name="BIIRULE-T14-R052" value="cac:TaxTotal" />
  <param name="Credit_Note_Line" value="//cac:CreditNoteLine" />
  <param name="Party_Legal_Entity" value="//cac:PartyLegalEntity" />
  <param name="Tax_Category" value="//cac:TaxCategory" />
  <param name="Tax_Scheme" value="//cac:TaxScheme" />
  <param name="Tax_Total" value="/ubl:CreditNote/cac:TaxTotal" />
  <param name="Credit_Note" value="/ubl:CreditNote" />
  <param name="Customer" value="//cac:AccountingCustomerParty" />
  <param name="Invoice_Period" value="//cac:InvoicePeriod" />
  <param name="Item_Price" value="//cac:Price/cbc:PriceAmount" />
  <param name="Item" value="//cac:Item" />
  <param name="Supplier" value="//cac:AccountingSupplierParty" />
  <param name="Total_Amounts" value="//cac:LegalMonetaryTotal" />
  <param name="Allowance_Percentage" value="//cac:AllowanceCharge[cbc:ChargeIndicator=&#39;false&#39;]/cbc:MultiplierFactorNumeric" />
  <param name="Allowance" value="//cac:AllowanceCharge[cbc:ChargeIndicator=&#39;false&#39;]" />
  <param name="Tax_Subtotal" value="/ubl:CreditNote/cac:TaxTotal/cac:TaxSubtotal" />
  <param name="Country" value="//cac:Country" />
</pattern>
