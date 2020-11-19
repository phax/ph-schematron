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
<!--Schematron tests for binding UBL and transaction T10-->
<pattern is-a="T10" id="UBL-T10" xmlns="http://purl.oclc.org/dsdl/schematron">
  <param name="ATGOV-T10-R001" value="(cac:Contact/cbc:ElectronicMail) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;) or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;))" />
  <param name="ATGOV-T10-R002" value="count(//cac:InvoiceLine) &lt; 999 and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;) or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;))" />
  <param name="ATGOV-T10-R003" value="(cac:OrderReference/cbc:ID) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;) or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;))" />
  <param name="ATGOV-T10-R004" value="count(/ubl:Invoice/cac:AllowanceCharge) &lt; 2 and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;) or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;))" />
  <param name="ATGOV-T10-R005" value="count(//cac:PayeeFinancialAccount/cbc:ID) = 1 and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;) or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;))" />
  <param name="ATGOV-T10-R006" value="(//cbc:AccountingCost) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;) or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;))" />
  <param name="ATGOV-T10-R007" value="cbc:PaymentMeansCode = &#39;31&#39; and  (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = &#39;IBAN&#39;) and  (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = &#39;BIC&#39;) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;) or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;))" />
  <param name="ATGOV-T10-R008" value="(cac:OrderReferenceLine/cbc:LineID) and (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;) or not ((//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;AT&#39;))" />
  <param name="Invoice" value="/ubl:Invoice" />
  <param name="Payment_Means" value="//cac:PaymentMeans" />
  <param name="Supplier" value="//cac:AccountingSupplierParty/cac:Party" />
  <param name="Invoice_Line" value="//cac:InvoiceLine" />
</pattern>
