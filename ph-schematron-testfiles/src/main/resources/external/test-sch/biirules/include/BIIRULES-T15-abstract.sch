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
<!--Abstract Schematron rules for T15-->
<pattern abstract="true" id="T15" xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule context="$Customer">
    <assert flag="warning" test="$BIIRULE-T15-R004">[BIIRULE-T15-R004]-A customer address in an invoice SHOULD contain at least city and zip code or have an address identifier.</assert>
    <assert flag="warning" test="$BIIRULE-T15-R005">[BIIRULE-T15-R005]-In cross border trade the VAT identifier for the customer should be prefixed with country code.</assert>
  </rule>
  <rule context="$Tax_Category">
    <assert flag="fatal" test="$BIIRULE-T15-R049">[BIIRULE-T15-R049]-Every tax category MUST be defined through an identifier.</assert>
  </rule>
  <rule context="$Annex">
    <assert flag="fatal" test="$BIIRULE-T15-R038">[BIIRULE-T15-R038]-For any document referred in an invoice, A corrective invoice MUST specify the document identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R046">[BIIRULE-T15-R046]-Any reference to a document MUST specify the document identifier.</assert>
  </rule>
  <rule context="$Item_Price">
    <assert flag="fatal" test="$BIIRULE-T15-R022">[BIIRULE-T15-R022]-Prices of items MUST NOT be negative.</assert>
  </rule>
  <rule context="$Invoice">
    <assert flag="fatal" test="$BIIRULE-T15-R023">[BIIRULE-T15-R023]-A corrective invoice MUST have a reference to an invoice. </assert>
    <assert flag="fatal" test="$BIIRULE-T15-R024">[BIIRULE-T15-R024]-A corrective invoice MUST have the date of issue.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R025">[BIIRULE-T15-R025]-A corrective invoice MUST have an invoice number.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R027">[BIIRULE-T15-R027]-A corrective invoice MUST contain the full name of the supplier.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R028">[BIIRULE-T15-R028]-A corrective invoice MUST contain the full name of the customer.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R029">[BIIRULE-T15-R029]-If the VAT total amount in an invoice exists then the sum of taxable amount in sub categories MUST equal the sum of invoice tax exclusive amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R030">[BIIRULE-T15-R030]-A corrective invoice MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R031">[BIIRULE-T15-R031]-A corrective invoice MUST have a customization identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R032">[BIIRULE-T15-R032]-A corrective invoice MUST have a profile identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R034">[BIIRULE-T15-R034]-A corrective invoice MUST specify at least one line item.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R035">[BIIRULE-T15-R035]-A corrective invoice MUST have a currency code for the document.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R036">[BIIRULE-T15-R036]-Any reference to an order MUST specify the order identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R037">[BIIRULE-T15-R037]-Any reference to a contract MUST specify the contract identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R039">[BIIRULE-T15-R039]-A corrective invoice MUST specify the total payable amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R040">[BIIRULE-T15-R040]-A corrective invoice MUST specify the total amount with taxes included.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R043">[BIIRULE-T15-R043]-A corrective invoice MUST specify the total amount without taxes.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R044">[BIIRULE-T15-R044]-A corrective invoice MUST specify the sum of the line amounts.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R053">[BIIRULE-T15-R053]-A corrective invoice MUST contain tax information</assert>
  </rule>
  <rule context="$Country">
    <assert flag="fatal" test="$BIIRULE-T15-R041">[BIIRULE-T15-R041]-Country in an address MUST be specified using the country code.</assert>
  </rule>
  <rule context="$Tax_Subtotal">
    <assert flag="fatal" test="$BIIRULE-T15-R047">[BIIRULE-T15-R047]-A corrective invoice MUST specify the taxable amount per tax subtotal.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R048">[BIIRULE-T15-R048]-A corrective invoice MUST specify the tax amount per tax subtotal.</assert>
  </rule>
  <rule context="$Invoice_Line">
    <assert flag="fatal" test="$BIIRULE-T15-R018">[BIIRULE-T15-R018]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R026">[BIIRULE-T15-R026]-Each corrective invoice line MUST contain the product/service name</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R033">[BIIRULE-T15-R033]-Corrective Invoice lines MUST have a line identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R051">[BIIRULE-T15-R051]-Corrective Invoice lines MUST have a line total amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R052">[BIIRULE-T15-R052]-Corrective Invoice lines MUST contain the item price</assert>
  </rule>
  <rule context="$Tax_Total">
    <assert flag="fatal" test="$BIIRULE-T15-R009">[BIIRULE-T15-R009]-An invoice MUST have a tax total refering to a single tax scheme</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R010">[BIIRULE-T15-R010]-Each tax total MUST equal the sum of the subcategory amounts.</assert>
  </rule>
  <rule context="$Party_Legal_Entity">
    <assert flag="fatal" test="$BIIRULE-T15-R042">[BIIRULE-T15-R042]-Company identifier MUST be specified when describing a company legal entity.</assert>
  </rule>
  <rule context="$Supplier">
    <assert flag="warning" test="$BIIRULE-T15-R002">[BIIRULE-T15-R002]-A supplier address in an invoice SHOULD contain at least the city name and a zip code or have an address identifier.</assert>
    <assert flag="warning" test="$BIIRULE-T15-R003">[BIIRULE-T15-R003]-In cross border trade the VAT identifier for the supplier should be prefixed with country code.</assert>
  </rule>
  <rule context="$Item">
    <assert flag="warning" test="$BIIRULE-T15-R019">[BIIRULE-T15-R019]-Product names SHOULD NOT exceed 50 characters long</assert>
    <assert flag="warning" test="$BIIRULE-T15-R020">[BIIRULE-T15-R020]-If standard identifiers are provided within an item description, an Scheme Identifier SHOULD be provided (e.g. GTIN)</assert>
    <assert flag="warning" test="$BIIRULE-T15-R021">[BIIRULE-T15-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</assert>
  </rule>
  <rule context="$Total_Amounts">
    <assert flag="fatal" test="$BIIRULE-T15-R011">[BIIRULE-T15-R011]-Invoice total line extension amount MUST equal the sum of the line totals</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R012">[BIIRULE-T15-R012]-An invoice tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R013">[BIIRULE-T15-R013]-An invoice tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R014">[BIIRULE-T15-R014]-Tax inclusive amount in an invoice MUST NOT be negative</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R015">[BIIRULE-T15-R015]-Total allowance it MUST be equal to the sum of allowances at document level</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R016">[BIIRULE-T15-R016]-Total charges it MUST be equal to the sum of document level charges.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R017">[BIIRULE-T15-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</assert>
  </rule>
  <rule context="$Invoice_Period">
    <assert flag="fatal" test="$BIIRULE-T15-R001">[BIIRULE-T15-R001]-A corrective invoice period end date MUST be later or equal to an invoice period start date</assert>
  </rule>
  <rule context="$Payment_Means">
    <assert flag="warning" test="$BIIRULE-T15-R006">[BIIRULE-T15-R006]-Payment means due date in an invoice SHOULD be later or equal than issue date.</assert>
    <assert flag="warning" test="$BIIRULE-T15-R007">[BIIRULE-T15-R007]-If payment means is funds transfer, invoice MUST have a financial account</assert>
    <assert flag="warning" test="$BIIRULE-T15-R008">[BIIRULE-T15-R008]-If bank account is IBAN the BIC code SHOULD also be provided.</assert>
    <assert flag="fatal" test="$BIIRULE-T15-R045">[BIIRULE-T15-R045]-When specifying payment means, A corrective invoice MUST specify the payment coded.</assert>
  </rule>
  <rule context="$Tax_Scheme">
    <assert flag="fatal" test="$BIIRULE-T15-R050">[BIIRULE-T15-R050]-Every tax scheme MUST be defined through an identifier.</assert>
  </rule>
</pattern>
