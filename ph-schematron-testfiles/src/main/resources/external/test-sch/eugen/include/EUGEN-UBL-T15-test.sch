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
  <param name="EUGEN-T15-R001" value="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)" />
  <param name="EUGEN-T15-R002" value="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)" />
  <param name="EUGEN-T15-R003" value="(cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode)" />
  <param name="EUGEN-T15-R004" value="((cbc:PaymentMeansCode = &#39;31&#39;) and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = &#39;IBAN&#39;) and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = &#39;BIC&#39;)) or (cbc:PaymentMeansCode != &#39;31&#39;) or ((cbc:PaymentMeansCode = &#39;31&#39;) and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != &#39;IBAN&#39;)))" />
  <param name="EUGEN-T15-R005" value="(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)" />
  <param name="EUGEN-T15-R006" value="(((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;)) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;])) and (local-name(parent:: node())=&quot;Invoice&quot;)) or not(local-name(parent:: node())=&quot;Invoice&quot;)" />
  <param name="EUGEN-T15-R007" value="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;])))" />
  <param name="EUGEN-T15-R008" value="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = &#39;AE&#39;)" />
  <param name="EUGEN-T15-R009" value="((cac:TaxCategory/cbc:ID = &#39;E&#39;) and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or  (cac:TaxCategory/cbc:ID != &#39;E&#39;)" />
  <param name="EUGEN-T15-R010" value="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)" />
  <param name="EUGEN-T15-R011" value="(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = &#39;VAT&#39;]))" />
  <param name="EUGEN-T15-R012" value="number(cbc:MultiplierFactorNumeric) &gt;=0" />
  <param name="EUGEN-T15-R013" value="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount))" />
  <param name="EUGEN-T15-R015" value="starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = &#39;AE&#39; or not ((//cac:TaxCategory/cbc:ID) = &#39;AE&#39;)" />
  <param name="EUGEN-T15-R016" value="(((//cac:TaxCategory/cbc:ID) = &#39;AE&#39;)  and not((//cac:TaxCategory/cbc:ID) != &#39;AE&#39; )) or not((//cac:TaxCategory/cbc:ID) = &#39;AE&#39;) or not(//cac:TaxCategory)" />
  <param name="EUGEN-T15-R017" value="(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID=&#39;AE&#39;]/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = &#39;AE&#39; or not ((//cac:TaxCategory/cbc:ID) = &#39;AE&#39;)" />
  <param name="EUGEN-T15-R018" value="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = &#39;AE&#39; or not ((//cac:TaxCategory/cbc:ID) = &#39;AE&#39;)" />
  <param name="EUGEN-T15-R019" value="number(cbc:PayableAmount) &gt;= 0" />
  <param name="EUGEN-T15-R020" value="(cbc:StartDate)" />
  <param name="EUGEN-T15-R021" value="(cbc:EndDate)" />
  <param name="EUGEN-T15-R022" value="number(cbc:Amount)&gt;=0" />
  <param name="EUGEN-T15-R023" value="(cbc:AllowanceChargeReason)" />
  <param name="EUGEN-T15-R024" value="not(//@currencyID != //cbc:DocumentCurrencyCode)" />
  <param name="Invoice_Line" value="//cac:InvoiceLine" />
  <param name="Payment_Means" value="//cac:PaymentMeans" />
  <param name="Supplier_Party" value="//cac:AccountingSupplierParty/cac:Party" />
  <param name="Tax_Category" value="//cac:TaxCategory" />
  <param name="Customer_Party" value="//cac:AccountingCustomerParty/cac:Party" />
  <param name="Delivery_Address" value="//cac:Delivery/cac:DeliveryLocation/cac:Address" />
  <param name="Invoice_Period" value="//cac:InvoicePeriod" />
  <param name="Invoice" value="/ubl:Invoice" />
  <param name="Tax_Subtotal" value="//cac:TaxSubtotal" />
  <param name="Classified_Tax_Category" value="//cac:Item/cac:ClassifiedTaxCategory" />
  <param name="Allowance_Charge" value="//cac:AllowanceCharge" />
  <param name="Total_Amounts" value="//cac:LegalMonetaryTotal" />
</pattern>
