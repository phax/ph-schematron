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
<!--Schematron tests for binding Facturae and transaction T10-->
<pattern is-a="T10" id="FACTURAE-T10" xmlns="http://purl.oclc.org/dsdl/schematron">
  <param name="BIIRULE-T10-R001" value="(EndDate and  StartDate) and not(number(translate(StartDate,&#39;-&#39;,&#39;&#39;)) &gt; number(translate(EndDate,&#39;-&#39;,&#39;&#39;))) or number(translate(StartDate,&#39;-&#39;,&#39;&#39;)) = number(translate(EndDate,&#39;-&#39;,&#39;&#39;))" />
  <param name="BIIRULE-T10-R002" value="((LegalEntity/AddressInSpain/Town and LegalEntity/AddressInSpain/PostCode) or
(LegalEntity/OverseasAddress/PostCodeandTown) or
(Individual/AddressInSpain/Town and Individual/AddressInSpain/PostCode) or
(Individual/OverseasAddress/PostCodeandTown))" />
  <param name="BIIRULE-T10-R003" value="((//CountryCode) and (following::BuyerParty//CountryCode) and ((//CountryCode) = (following::BuyerParty//CountryCode) or ((//CountryCode) != (following::BuyerParty//CountryCode) and starts-with(TaxIdentification/TaxIdentificationNumber, //CountryCode)))) or not(//CountryCode) or not(following::BuyerParty//CountryCode)" />
  <param name="BIIRULE-T10-R004" value="((LegalEntity/AddressInSpain/Town and LegalEntity/AddressInSpain/PostCode) or
(LegalEntity/OverseasAddress/PostCodeandTown) or
(Individual/AddressInSpain/Town and Individual/AddressInSpain/PostCode) or
(Individual/OverseasAddress/PostCodeandTown))" />
  <param name="BIIRULE-T10-R005" value="((//CountryCode) and (preceding::SellerParty//CountryCode) and  ((//CountryCode) = (preceding::SellerParty//CountryCode) or ((//CountryCode) != (preceding::SellerParty//CountryCode) and starts-with(TaxIdentification/TaxIdentificationNumber, //CountryCode)))) or not((//CountryCode)) or not((preceding::SellerParty//CountryCode))" />
  <param name="BIIRULE-T10-R006" value="(InstallmentDueDate and preceding::InvoiceIssueData/IssueDate) and not(number(translate(InstallmentDueDate,&#39;-&#39;,&#39;&#39;)) &lt; number(translate(preceding::InvoiceIssueData/IssueDate,&#39;-&#39;,&#39;&#39;))) or number(translate(InstallmentDueDate,&#39;-&#39;,&#39;&#39;)) = number(translate(preceding::InvoiceIssueData/IssueDate,&#39;-&#39;,&#39;&#39;))" />
  <param name="BIIRULE-T10-R007" value="((PaymentMeans = &#39;31&#39;) and (//AccountToBeCredited/IBAN or //AccountToBeCredited/AccountNumber)) or (PaymentMeans != &#39;31&#39;)" />
  <param name="BIIRULE-T10-R008" value="(//AccountToBeCredited/IBAN and //AccountToBeCredited/BIC) or not(//AccountToBeCredited/IBAN)" />
  <param name="BIIRULE-T10-R009" value="count(Tax)&gt;1 or count(Tax) = 1" />
  <param name="BIIRULE-T10-R010" value="number(following::InvoiceTotals/TotalTaxOutputs) = number(round(sum(child::Tax/TaxAmount/TotalAmount) * 100) div 100)" />
  <param name="BIIRULE-T10-R011" value="number(TotalGrossAmount) = number(round(sum(following::Items/InvoiceLine/GrossAmount) * 100) div 100)" />
  <param name="BIIRULE-T10-R012" value="((TotalGeneralSurcharges) and (TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = (number(TotalGrossAmount) + number(TotalGeneralSurcharges) - number(TotalGeneralDiscounts)))) or (not(TotalGeneralSurcharges) and (TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount) - number(TotalGeneralDiscounts))) or ((TotalGeneralSurcharges) and not(TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount) + number(TotalGeneralSurcharges))) or (not(TotalGeneralSurcharges) and not(TotalGeneralDiscounts) and (number(TotalGrossAmountBeforeTaxes) = number(TotalGrossAmount)))" />
  <param name="BIIRULE-T10-R013" value="number(InvoiceTotal) = number(TotalGrossAmountBeforeTaxes) - number(TotalTaxesWithheld) + number(TotalTaxOutputs)" />
  <param name="BIIRULE-T10-R014" value="number(InvoiceTotal) &gt;= 0" />
  <param name="BIIRULE-T10-R015" value="(TotalGeneralDiscounts) and TotalGeneralDiscounts = (round(sum(//Discount/DiscountAmount) * 100) div 100) or not(TotalGeneralDiscounts)" />
  <param name="BIIRULE-T10-R016" value="(TotalGeneralSurcharges) and TotalGeneralSurcharges = (round(sum(//Charge/ChargeAmount) * 100) div 100) or not(TotalGeneralSurcharges)" />
  <param name="BIIRULE-T10-R017" value="(TotalPaymentsOnAccount) and (number(TotalExecutableAmount) = number(InvoiceTotal - TotalPaymentsOnAccount)) or TotalExecutableAmount = InvoiceTotal" />
  <param name="BIIRULE-T10-R018" value="not(Quantity) or not(UnitPriceWithoutTax) or number(GrossAmount) = (round(number(UnitPriceWithoutTax) * number(Quantity) * 100) div 100)" />
  <param name="BIIRULE-T10-R019" value="string-length(string(//ItemDescription)) &lt;= 50" />
  <param name="BIIRULE-T10-R020" value="./true" />
  <param name="BIIRULE-T10-R021" value="not(//ArticleCode)" />
  <param name="BIIRULE-T10-R022" value="number(.) &gt;=0" />
  <param name="BIIRULE-T10-R023" value="(//InvoiceIssueData/IssueDate)" />
  <param name="BIIRULE-T10-R024" value="(//InvoiceHeader/InvoiceNumber)" />
  <param name="BIIRULE-T10-R025" value="(//ItemDescription)" />
  <param name="BIIRULE-T10-R026" value="(//SellerParty/LegalEntity/CorporateName) or (//SellerParty/Individual/Name)" />
  <param name="BIIRULE-T10-R027" value="(//BuyerParty/LegalEntity/CorporateName) or (//BuyerParty/Individual/Name)" />
  <param name="BIIRULE-T10-R029" value="//SchemaVersion" />
  <param name="BIIRULE-T10-R032" value="//InvoiceHeader/InvoiceNumber" />
  <param name="BIIRULE-T10-R033" value="(//Items/InvoiceLine)" />
  <param name="BIIRULE-T10-R034" value="(//InvoiceIssueData/InvoiceCurrencyCode)" />
  <param name="BIIRULE-T10-R038" value="//TotalExecutableAmount" />
  <param name="BIIRULE-T10-R039" value="//InvoiceTotal" />
  <param name="BIIRULE-T10-R040" value="." />
  <param name="BIIRULE-T10-R041" value="//RegistrationData" />
  <param name="BIIRULE-T10-R042" value="//TotalGrossAmountBeforeTaxes" />
  <param name="BIIRULE-T10-R043" value="//TotalGrossAmount" />
  <param name="BIIRULE-T10-R044" value="//PaymentMeans" />
  <param name="BIIRULE-T10-R045" value="//TotalTaxOutputs" />
  <param name="BIIRULE-T10-R046" value="//Tax/TaxableBase" />
  <param name="BIIRULE-T10-R047" value="//Tax/TaxAmount" />
  <param name="BIIRULE-T10-R049" value="//TaxTypeCode" />
  <param name="BIIRULE-T10-R050" value="//TotalCost" />
  <param name="Customer" value="//Parties/BuyerParty" />
  <param name="Invoice_Line" value="//Items/InvoiceLine" />
  <param name="Invoice_Period" value="//InvoicingPeriod" />
  <param name="Invoice" value="/facturae:Facturae" />
  <param name="Item_Price" value="//Items/InvoiceLine/UnitPriceWithoutTax" />
  <param name="Item" value="//Items/InvoiceLine" />
  <param name="Payment_Means" value="//PaymentDetails/Installments" />
  <param name="Supplier" value="//Parties/SellerParty" />
  <param name="Tax_Total" value="/facturae:Facturae/Invoices/Invoice/TaxesOutputs" />
  <param name="Total_Amounts" value="//InvoiceTotals" />
  <param name="Party_Legal_Entity" value="//LegalEntity" />
  <param name="Tax_Category" value="//TaxesOutputs" />
  <param name="Tax_Scheme" value="//TaxesOutputs" />
  <param name="Annex" value="//cac:AdditionalDocumentReference" />
  <param name="Country" value="//CountryCode" />
  <param name="BIIRULE-T10-R048" value="./false" />
  <param name="BIIRULE-T10-R037" value="./false" />
  <param name="BIIRULE-T10-R028" value="./false" />
  <param name="BIIRULE-T10-R030" value="./false" />
  <param name="BIIRULE-T10-R031" value="./false" />
  <param name="BIIRULE-T10-R035" value="./false" />
  <param name="BIIRULE-T10-R036" value="./false" />
  <param name="BIIRULE-T10-R052" value="./false" />
  <param name="Tax_Subtotal" value="//NonExistingDummyNode" />
  <param name="BIIRULE-T10-R051" value="./false" />
</pattern>
