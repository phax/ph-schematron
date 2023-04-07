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
<!--Schematron tests for binding UBL and transaction T15-->
<pattern is-a="T15" id="UBL-T15" xmlns="http://purl.oclc.org/dsdl/schematron">
  <param name="BIIRULE-T15-R001" value="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,&#39;-&#39;,&#39;&#39;)) &lt;= number(translate(cbc:EndDate,&#39;-&#39;,&#39;&#39;)))" />
  <param name="BIIRULE-T15-R002" value="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)" />
  <param name="BIIRULE-T15-R003" value="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID=&#39;VAT&#39; and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))" />
  <param name="BIIRULE-T15-R004" value="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)" />
  <param name="BIIRULE-T15-R005" value="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID=&#39;VAT&#39; and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID=&#39;VAT&#39;]/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))" />
  <param name="BIIRULE-T15-R006" value="(cbc:PaymentDueDate and /ubl:Invoice/cbc:IssueDate) and (number(translate(cbc:PaymentDueDate,&#39;-&#39;,&#39;&#39;)) &gt;= number(translate(/ubl:Invoice/cbc:IssueDate,&#39;-&#39;,&#39;&#39;))) or (not(cbc:PaymentDueDate))" />
  <param name="BIIRULE-T15-R007" value="(cbc:PaymentMeansCode = &#39;31&#39;) and //cac:PayeeFinancialAccount/cbc:ID or (cbc:PaymentMeansCode != &#39;31&#39;)" />
  <param name="BIIRULE-T15-R008" value="(cac:PayeeFinancialAccount/cbc:ID/@schemeID and (cac:PayeeFinancialAccount/cbc:ID/@schemeID = &#39;IBAN&#39;) and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != &#39;IBAN&#39;) or (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID))" />
  <param name="BIIRULE-T15-R009" value="count(cac:TaxSubtotal/*/*/cbc:ID) = count(cac:TaxSubtotal/*/*/cbc:ID[. = &#39;VAT&#39;]) or count(cac:TaxSubtotal/*/*/cbc:ID[. = &#39;VAT&#39;]) = 0" />
  <param name="BIIRULE-T15-R010" value="number(cbc:TaxAmount) = number(round(sum(cac:TaxSubtotal/cbc:TaxAmount)  * 10 * 10) div 100)" />
  <param name="BIIRULE-T15-R011" value="number(cbc:LineExtensionAmount) = number(round(sum(//cac:InvoiceLine/cbc:LineExtensionAmount) * 10 * 10) div 100)" />
  <param name="BIIRULE-T15-R012" value="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = number(cbc:LineExtensionAmount)))" />
  <param name="BIIRULE-T15-R013" value="((cbc:PayableRoundingAmount) and (number(cbc:TaxInclusiveAmount) = (round((number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount)) + number(cbc:PayableRoundingAmount)) *10 * 10) div 100))) or (number(cbc:TaxInclusiveAmount) = round(( number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount))) * 10 * 10) div 100)" />
  <param name="BIIRULE-T15-R014" value="number(cbc:TaxInclusiveAmount) &gt;= 0" />
  <param name="BIIRULE-T15-R015" value="(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)" />
  <param name="BIIRULE-T15-R016" value="(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount)  * 10 * 10) div 100) or not(cbc:ChargeTotalAmount)" />
  <param name="BIIRULE-T15-R017" value="(cbc:PrepaidAmount) and (number(cbc:PayableAmount) = (round((cbc:TaxInclusiveAmount - cbc:PrepaidAmount) * 10 * 10) div 100)) or number(cbc:PayableAmount) = number(cbc:TaxInclusiveAmount)" />
  <param name="BIIRULE-T15-R018" value="not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or (not(cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round(number(cac:Price/cbc:PriceAmount) *number(cbc:InvoicedQuantity) * 10 * 10) div 100) + ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator=&#39;true&#39;]/cbc:Amount) *10 * 10) div 100 ) - ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator=&#39;false&#39;]/cbc:Amount) *10 * 10) div 100 ) ) or ((cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round((number(cac:Price/cbc:PriceAmount) div number(cac:Price/cbc:BaseQuantity) * number(cbc:InvoicedQuantity)) * 10 * 10) div 100)+ (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator=&#39;true&#39;]/cbc:Amount) * 10 * 10) div 100 ) -(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator=&#39;false&#39;]/cbc:Amount) *10 * 10) div 100))" />
  <param name="BIIRULE-T15-R019" value="string-length(string(cbc:Name)) &lt;= 50" />
  <param name="BIIRULE-T15-R020" value="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)" />
  <param name="BIIRULE-T15-R021" value="not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)" />
  <param name="BIIRULE-T15-R022" value="number(.) &gt;=0" />
  <param name="BIIRULE-T15-R023" value="(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) or (cac:BillingReference/cac:CreditNoteDocumentReferene/cbc:ID)" />
  <param name="BIIRULE-T15-R024" value="(cbc:IssueDate)" />
  <param name="BIIRULE-T15-R025" value="(cbc:ID)" />
  <param name="BIIRULE-T15-R026" value="(cac:Item/cbc:Name)" />
  <param name="BIIRULE-T15-R027" value="(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)" />
  <param name="BIIRULE-T15-R028" value="(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)" />
  <param name="BIIRULE-T15-R029" value="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxAmount) and (sum(cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount) = number(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]))" />
  <param name="BIIRULE-T15-R030" value="(cbc:UBLVersionID)" />
  <param name="BIIRULE-T15-R031" value="(cbc:CustomizationID)" />
  <param name="BIIRULE-T15-R032" value="(cbc:ProfileID)" />
  <param name="BIIRULE-T15-R033" value="cbc:ID" />
  <param name="BIIRULE-T15-R034" value="(cac:InvoiceLine)" />
  <param name="BIIRULE-T15-R035" value="(cbc:DocumentCurrencyCode)" />
  <param name="BIIRULE-T15-R036" value="(cac:OrderReference/cbc:ID) or not(cac:OrderReference)" />
  <param name="BIIRULE-T15-R037" value="(cac:ContractDocumentReference/cbc:ID) or not(cac:ContractDocumentReference)" />
  <param name="BIIRULE-T15-R038" value="cbc:ID" />
  <param name="BIIRULE-T15-R039" value="(cac:LegalMonetaryTotal/cbc:PayableAmount)" />
  <param name="BIIRULE-T15-R040" value="(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount)" />
  <param name="BIIRULE-T15-R041" value="(cbc:IdentificationCode)" />
  <param name="BIIRULE-T15-R042" value="(cbc:CompanyID)" />
  <param name="BIIRULE-T15-R043" value="(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount)" />
  <param name="BIIRULE-T15-R044" value="(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)" />
  <param name="BIIRULE-T15-R045" value="not(cac:PaymentMeans) or (cac:PaymentMeans/cbc:PaymentMeansCode)" />
  <param name="BIIRULE-T15-R046" value="cbc:ID" />
  <param name="BIIRULE-T15-R047" value="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxableAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != &#39;VAT&#39;)" />
  <param name="BIIRULE-T15-R048" value="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != &#39;VAT&#39;)" />
  <param name="BIIRULE-T15-R049" value="cbc:ID" />
  <param name="BIIRULE-T15-R050" value="cbc:ID" />
  <param name="BIIRULE-T15-R051" value="cbc:LineExtensionAmount" />
  <param name="BIIRULE-T15-R052" value="cac:Price/cbc:PriceAmount" />
  <param name="BIIRULE-T15-R053" value="cac:TaxTotal" />
  <param name="Total_Amounts" value="//cac:LegalMonetaryTotal" />
  <param name="Tax_Total" value="/ubl:Invoice/cac:TaxTotal" />
  <param name="Tax_Scheme" value="//cac:TaxScheme" />
  <param name="Tax_Category" value="//cac:TaxCategory" />
  <param name="Supplier" value="//cac:AccountingSupplierParty" />
  <param name="Payment_Means" value="//cac:PaymentMeans" />
  <param name="Party_Legal_Entity" value="//cac:PartyLegalEntity" />
  <param name="Item_Price" value="//cac:InvoiceLine/cac:Price/cbc:PriceAmount" />
  <param name="Item" value="//cac:Item" />
  <param name="Invoice_Period" value="//cac:InvoicePeriod" />
  <param name="Invoice_Line" value="//cac:InvoiceLine" />
  <param name="Invoice" value="/ubl:Invoice" />
  <param name="Customer" value="//cac:AccountingCustomerParty" />
  <param name="Country" value="//cac:Country" />
  <param name="Annex" value="//cac:AdditionalDocumentReference" />
  <param name="Tax_Subtotal" value="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" />
</pattern>
