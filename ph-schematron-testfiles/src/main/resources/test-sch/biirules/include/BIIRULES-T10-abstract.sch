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
  <rule context="$Customer">
    <assert flag="warning" test="$BIIRULE-T10-R004">[BIIRULE-T10-R004]-A customer address in an invoice SHOULD contain at least city and zip code or have an address identifier.</assert>
    <assert flag="warning" test="$BIIRULE-T10-R005">[BIIRULE-T10-R005]-In cross border trade the VAT identifier for the customer SHOULD be prefixed with country code.</assert>
  </rule>
  <rule context="$Tax_Category">
    <assert flag="fatal" test="$BIIRULE-T10-R048">[BIIRULE-T10-R048]-Every tax category MUST be defined through an identifier.</assert>
  </rule>
  <rule context="$Annex">
    <assert flag="fatal" test="$BIIRULE-T10-R037">[BIIRULE-T10-R037]-Any reference to a document MUST specify the document identifier.</assert>
  </rule>
  <rule context="$Item_Price">
    <assert flag="fatal" test="$BIIRULE-T10-R022">[BIIRULE-T10-R022]-Prices of items MUST NOT be negative.</assert>
  </rule>
  <rule context="$Invoice">
    <assert flag="fatal" test="$BIIRULE-T10-R023">[BIIRULE-T10-R023]-An invoice MUST have the date of issue.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R024">[BIIRULE-T10-R024]-An invoice MUST have an invoice number.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R026">[BIIRULE-T10-R026]-An invoice MUST contain the full name of the supplier.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R027">[BIIRULE-T10-R027]-An invoice MUST contain the full name of the customer.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R028">[BIIRULE-T10-R028]-If the VAT total amount in an invoice exists then the sum of taxable amount in sub categories MUST equal the sum of invoice tax exclusive amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R029">[BIIRULE-T10-R029]-An invoice MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R030">[BIIRULE-T10-R030]-An invoice MUST have a customization identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R031">[BIIRULE-T10-R031]-An invoice MUST have a profile identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R033">[BIIRULE-T10-R033]-An invoice MUST specify at least one line item.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R034">[BIIRULE-T10-R034]-An invoice MUST have a currency code for the document.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R035">[BIIRULE-T10-R035]-Any reference to an order MUST specify the order identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R036">[BIIRULE-T10-R036]-Any reference to a contract MUST specify the contract identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R038">[BIIRULE-T10-R038]-An invoice MUST specify the total payable amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R039">[BIIRULE-T10-R039]-An invoice MUST specify the total amount with taxes included.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R042">[BIIRULE-T10-R042]-An invoice MUST specify the total amount without taxes.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R043">[BIIRULE-T10-R043]-An invoice MUST specify the sum of the line amounts.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R052">[BIIRULE-T10-R052]-An invoice MUST contain tax information</assert>
  </rule>
  <rule context="$Country">
    <assert flag="fatal" test="$BIIRULE-T10-R040">[BIIRULE-T10-R040]-Country in an address MUST be specified using the country code.</assert>
  </rule>
  <rule context="$Tax_Subtotal">
    <assert flag="fatal" test="$BIIRULE-T10-R046">[BIIRULE-T10-R046]-An invoice MUST specify the taxable amount per VAT subtotal.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R047">[BIIRULE-T10-R047]-An invoice MUST specify the tax amount per VAT subtotal.</assert>
  </rule>
  <rule context="$Invoice_Line">
    <assert flag="fatal" test="$BIIRULE-T10-R018">[BIIRULE-T10-R018]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R025">[BIIRULE-T10-R025]-Each invoice line MUST contain the product/service name</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R032">[BIIRULE-T10-R032]-Invoice lines MUST have a line identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R050">[BIIRULE-T10-R050]-Invoice lines MUST have a line total amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R051">[BIIRULE-T10-R051]-Invoice lines MUST contain the item price</assert>
  </rule>
  <rule context="$Tax_Total">
    <assert flag="fatal" test="$BIIRULE-T10-R009">[BIIRULE-T10-R009]-An invoice MUST have a tax total refering to a single tax scheme</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R010">[BIIRULE-T10-R010]-Each tax total MUST equal the sum of the tax subcategory amounts.</assert>
  </rule>
  <rule context="$Party_Legal_Entity">
    <assert flag="fatal" test="$BIIRULE-T10-R041">[BIIRULE-T10-R041]-Company identifier MUST be specified when describing a company legal entity.</assert>
  </rule>
  <rule context="$Supplier">
    <assert flag="warning" test="$BIIRULE-T10-R002">[BIIRULE-T10-R002]-A supplier address in an invoice SHOULD contain at least the city name and a zip code or have an address identifier.</assert>
    <assert flag="warning" test="$BIIRULE-T10-R003">[BIIRULE-T10-R003]-In cross border trade the VAT identifier for the supplier SHOULD be prefixed with country code.</assert>
  </rule>
  <rule context="$Item">
    <assert flag="warning" test="$BIIRULE-T10-R019">[BIIRULE-T10-R019]-Product names SHOULD NOT exceed 50 characters long</assert>
    <assert flag="warning" test="$BIIRULE-T10-R020">[BIIRULE-T10-R020]-If standard identifiers are provided within an item description, a Scheme Identifier SHOULD be provided (e.g. GTIN)</assert>
    <assert flag="warning" test="$BIIRULE-T10-R021">[BIIRULE-T10-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</assert>
  </rule>
  <rule context="$Total_Amounts">
    <assert flag="fatal" test="$BIIRULE-T10-R011">[BIIRULE-T10-R011]-Invoice total line extension amount MUST equal the sum of the line totals</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R012">[BIIRULE-T10-R012]-Invoice tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R013">[BIIRULE-T10-R013]-Invoice tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R014">[BIIRULE-T10-R014]-Tax inclusive amount in an invoice MUST NOT be negative</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R015">[BIIRULE-T10-R015]-Total allowance MUST be equal to the sum of allowances at document level</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R016">[BIIRULE-T10-R016]-Total charges MUST be equal to the sum of document level charges.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R017">[BIIRULE-T10-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</assert>
  </rule>
  <rule context="$Invoice_Period">
    <assert flag="fatal" test="$BIIRULE-T10-R001">[BIIRULE-T10-R001]-An invoice period end date MUST be later or equal to an invoice period start date</assert>
  </rule>
  <rule context="$Payment_Means">
    <assert flag="warning" test="$BIIRULE-T10-R006">[BIIRULE-T10-R006]-Payment means due date in an invoice SHOULD be later or equal than issue date.</assert>
    <assert flag="warning" test="$BIIRULE-T10-R007">[BIIRULE-T10-R007]-If payment means is funds transfer, invoice MUST have a financial account</assert>
    <assert flag="warning" test="$BIIRULE-T10-R008">[BIIRULE-T10-R008]-If bank account is IBAN the bank identifier SHOULD also be provided.</assert>
    <assert flag="fatal" test="$BIIRULE-T10-R044">[BIIRULE-T10-R044]-When specifying payment means, the invoice MUST specify the payment means code</assert>
  </rule>
  <rule context="$Tax_Scheme">
    <assert flag="fatal" test="$BIIRULE-T10-R049">[BIIRULE-T10-R049]-Every tax scheme MUST be defined through an identifier.</assert>
  </rule>
</pattern>
