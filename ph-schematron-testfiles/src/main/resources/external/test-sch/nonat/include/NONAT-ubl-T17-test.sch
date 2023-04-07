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
<!--Schematron tests for binding ubl and transaction T17-->
<pattern is-a="T17" id="UBL-T17" xmlns="http://purl.oclc.org/dsdl/schematron">
  <param name="NONAT-T17-R001" value="(cbc:ID)" />
  <param name="NONAT-T17-R002" value="(cbc:IssueDate)" />
  <param name="NONAT-T17-R003" value="(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)" />
  <param name="NONAT-T17-R004" value="(cac:LegalMonetaryTotal/cbc:PayableAmount)" />
  <param name="NONAT-T17-R005" value="(cac:ReminderLine)" />
  <param name="NONAT-T17-R006" value="(cbc:ID)" />
  <param name="NONAT-T17-R007" value="(//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) or (//cac:BillingReference/cac:CreditNoteDocumentReference/cbc:ID)" />
  <param name="NONAT-T17-R008" value="number(child::cbc:LineExtensionAmount) = number(round((sum(//cac:ReminderLine/cbc:DebitLineAmount) - sum(//cac:ReminderLine/cbc:CreditLineAmount)) * 100) div 100)" />
  <param name="NONAT-T17-R009" value="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)" />
  <param name="NONAT-T17-R010" value="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)" />
  <param name="NONAT-T17-R012" value="(number(cac:TaxCategory/cbc:Percent) = 0 and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or  (number(cac:TaxCategory/cbc:Percent) !=0)" />
  <param name="NONAT-T17-R013" value="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)" />
  <param name="NONAT-T17-R014" value="(((//cac:TaxCategory/cbc:ID) = &#39;AE&#39;)  and not((//cac:TaxCategory/cbc:ID) != &#39;AE&#39; )) or not((//cac:TaxCategory/cbc:ID) = &#39;AE&#39;) or not(//cac:TaxCategory)" />
  <param name="NONAT-T17-R015" value="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = &#39;AE&#39;  or not ((//cac:TaxCategory/cbc:ID) = &#39;AE&#39; )" />
  <param name="NONAT-T17-R016" value=". = &#39;urn:www.cenbii.eu:profile:bii08:ver1.0&#39;" />
  <param name="NONAT-T17-R017" value="(cbc:UBLVersionID)" />
  <param name="NONAT-T17-R018" value="(cbc:CustomizationID)" />
  <param name="NONAT-T17-R019" value="(cbc:ProfileID)" />
  <param name="NONAT-T17-R020" value="(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)" />
  <param name="NONAT-T17-R021" value="(cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone) or (cac:PostalAddress/cbc:ID)" />
  <param name="NONAT-T17-R022" value="(cac:PostalAddress/cac:Country/cbc:IdentificationCode != &#39;&#39;)" />
  <param name="NONAT-T17-R023" value="(cac:PartyLegalEntity/cbc:CompanyID != &#39;&#39;)" />
  <param name="NONAT-T17-R024" value="(cac:PartyIdentification/cbc:ID != &#39;&#39;)" />
  <param name="NONAT-T17-R025" value="(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)" />
  <param name="NONAT-T17-R026" value="(cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone) or (cac:PostalAddress/cbc:ID)" />
  <param name="NONAT-T17-R027" value="(cac:PartyLegalEntity/cbc:CompanyID != &#39;&#39;)" />
  <param name="NONAT-T17-R028" value="(cac:Contact/cbc:ID != &#39;&#39;)" />
  <param name="NONAT-T17-R029" value="(cbc:TaxAmount)" />
  <param name="Tax_Total" value="/ubl:Reminder/cac:TaxTotal" />
  <param name="Supplier_Party" value="//cac:AccountingSupplierParty/cac:Party" />
  <param name="Customer_Party" value="//cac:AccountingCustomerParty/cac:Party" />
  <param name="Tax_Subtotal" value="//cac:TaxSubtotal" />
  <param name="Reminder_Profile" value="//cbc:ProfileID" />
  <param name="Reminder_Line" value="//cac:ReminderLine" />
  <param name="Total_Amounts" value="//cac:LegalMonetaryTotal" />
  <param name="Reminder" value="/ubl:Reminder" />
</pattern>
