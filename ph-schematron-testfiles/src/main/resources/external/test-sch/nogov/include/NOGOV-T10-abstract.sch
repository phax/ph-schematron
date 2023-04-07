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
<!--Abstract Schematron rules for T10-->
<pattern abstract="true" id="T10" xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule context="$Customer_Party">
    <assert flag="warning" test="$NOGOV-T10-R006">[NOGOV-T10-R006]-A customer number for AccountingCustomerParty SHOULD be provided according to EHF.</assert>
    <assert flag="fatal" test="$NOGOV-T10-R007">[NOGOV-T10-R007]-A contact reference identifier MUST be provided for AccountingCustomerParty according to EHF.</assert>
    <assert flag="fatal" test="$NOGOV-T10-R009">[NOGOV-T10-R009]-PartyLegalEntity for AccountingCustomerParty MUST be provided according to EHF.</assert>
  </rule>
  <rule context="$Item">
    <assert flag="warning" test="$NOGOV-T10-R002">[NOGOV-T10-R002]-The sellers ID for the item SHOULD be provided according to EHF.</assert>
    <assert flag="fatal" test="$NOGOV-T10-R008">[NOGOV-T10-R008]-The item&#39;s tax rate, expressed as a percentage MUST be provided according to EHF.</assert>
  </rule>
  <rule context="$Supplier_Party">
    <assert flag="warning" test="$NOGOV-T10-R001">[NOGOV-T10-R001]-A contact reference identifier SHOULD be provided for AccountingSupplierParty according to EHF.</assert>
    <assert flag="fatal" test="$NOGOV-T10-R014">[NOGOV-T10-R014]-Country code for the supplier address MUST be provided according to EHF.</assert>
  </rule>
  <rule context="$Invoice">
    <assert flag="warning" test="$NOGOV-T10-R005">[NOGOV-T10-R005]-ContractDocumentReference SHOULD be provided according to EHF.</assert>
  </rule>
  <rule context="$Payment_Means">
    <assert flag="fatal" test="$NOGOV-T10-R011">[NOGOV-T10-R011]-PayeeFinancialAccount MUST be provided  according EHF.</assert>
    <assert flag="warning" test="$NOGOV-T10-R012">[NOGOV-T10-R012]-Payment Identifier (KID number) SHOULD be used according to EHF.</assert>
  </rule>
  <rule context="$Invoice_Line">
    <assert flag="warning" test="$NOGOV-T10-R003">[NOGOV-T10-R003]-The buyer&#39;s accounting code applied to the Invoice Line SHOULD be provided according to EHF.</assert>
    <assert flag="warning" test="$NOGOV-T10-R004">[NOGOV-T10-R004]-An association to Order Line Reference SHOULD be provided according to EHF.</assert>
    <assert flag="warning" test="$NOGOV-T10-R010">[NOGOV-T10-R010]-The unit qualifier of the invoiced quantity SHOULD be provided according to EHF.</assert>
  </rule>
  <rule context="$Order_Reference">
    <assert flag="warning" test="$NOGOV-T10-R013">[NOGOV-T10-R013]-An association to Order Reference SHOULD be provided according to EHF.</assert>
  </rule>
</pattern>
