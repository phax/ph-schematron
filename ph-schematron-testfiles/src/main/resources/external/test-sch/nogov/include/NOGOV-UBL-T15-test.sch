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
<!--Schematron tests for binding ubl and transaction T15-->
<pattern is-a="T15" id="UBL-T15" xmlns="http://purl.oclc.org/dsdl/schematron">
  <param name="NOGOV-T15-R005" value="(cac:ContractDocumentReference/cbc:ID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R007" value="(cac:Contact/cbc:ID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R006" value="(cac:PartyIdentification/cbc:ID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R001" value="(cac:Contact/cbc:ID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R002" value="(cac:SellersItemIdentification/cbc:ID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R003" value="(cbc:AccountingCost) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R004" value="(cac:OrderLineReference/cbc:LineID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R008" value="(number(cac:ClassifiedTaxCategory/cbc:Percent) &gt;=0) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R009" value="(cac:PartyLegalEntity/cbc:CompanyID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R010" value="(child::cbc:InvoicedQuantity/@unitCode != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R011" value="(cac:PayeeFinancialAccount/cbc:ID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R012" value="(cbc:PaymentID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R013" value="(child::cbc:ID != &#39;&#39;) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;) or not ((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = &#39;NO&#39;))" />
  <param name="NOGOV-T15-R014" value="(cac:PostalAddress/cac:Country/cbc:IdentificationCode != &#39;&#39;)" />
  <param name="Customer_Party" value="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" />
  <param name="Invoice_Line" value="//cac:InvoiceLine" />
  <param name="Invoice" value="/ubl:Invoice" />
  <param name="Item" value="//cac:Item" />
  <param name="Supplier_Party" value="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" />
  <param name="Order_Reference" value="//cac:OrderReference" />
  <param name="Payment_Means" value="//cac:PaymentMeans" />
</pattern>
