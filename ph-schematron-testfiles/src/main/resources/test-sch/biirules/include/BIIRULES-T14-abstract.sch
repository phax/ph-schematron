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
<!--Abstract Schematron rules for T14-->
<pattern abstract="true" id="T14" xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule context="$Customer">
    <assert flag="warning" test="$BIIRULE-T14-R004">[BIIRULE-T14-R004]-A customer address in a credit note SHOULD contain at least city and zip code or have an address identifier.</assert>
    <assert flag="warning" test="$BIIRULE-T14-R005">[BIIRULE-T14-R005]-In cross border trade the VAT identifier for the customer should be prefixed with country code.</assert>
  </rule>
  <rule context="$Allowance_Percentage">
    <assert flag="fatal" test="$BIIRULE-T14-R023">[BIIRULE-T14-R023]-An allowance percentage MUST NOT be negative.</assert>
  </rule>
  <rule context="$Tax_Category">
    <assert flag="fatal" test="$BIIRULE-T14-R045">[BIIRULE-T14-R045]-Every tax category MUST be defined through an identifier.</assert>
  </rule>
  <rule context="$Credit_Note">
    <assert flag="fatal" test="$BIIRULE-T14-R025">[BIIRULE-T14-R025]-A Credit Note MUST have the date of issue.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R026">[BIIRULE-T14-R026]-A Credit Note MUST have a Credit Note number.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R028">[BIIRULE-T14-R028]-A Credit Note MUST contain the full name of the supplier.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R029">[BIIRULE-T14-R029]-A Credit Note MUST contain the full name of the customer.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R030">[BIIRULE-T14-R030]-If the VAT total amount in a Credit Note exists then the sum of taxable amount in sub categories MUST equal the sum of Credit Note tax exclusive amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R031">[BIIRULE-T14-R031]-A Credit Note MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R032">[BIIRULE-T14-R032]-A Credit Note MUST have a customization identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R033">[BIIRULE-T14-R033]-A Credit Note MUST have a profile identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R035">[BIIRULE-T14-R035]-A Credit Note MUST specify at least one line item.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R036">[BIIRULE-T14-R036]-A Credit Note MUST specify the currency code for the document.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R037">[BIIRULE-T14-R037]-A Credit Note MUST specify the total payable amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R038">[BIIRULE-T14-R038]-A Credit Note MUST specify the total amount with taxes included.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R040">[BIIRULE-T14-R040]-A Credit Note MUST specify the total amount without taxes.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R041">[BIIRULE-T14-R041]-A Credit Note MUST specify the sum of the line amounts.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R052">[BIIRULE-T14-R052]-A Credit Note MUST contain tax information</assert>
  </rule>
  <rule context="$Item_Price">
    <assert flag="fatal" test="$BIIRULE-T14-R022">[BIIRULE-T14-R022]-Prices of items MUST be positive or zero</assert>
  </rule>
  <rule context="$Country">
    <assert flag="fatal" test="$BIIRULE-T14-R042">[BIIRULE-T14-R042]-Country in an address MUST be specified using the country code.</assert>
  </rule>
  <rule context="$Tax_Subtotal">
    <assert flag="fatal" test="$BIIRULE-T14-R043">[BIIRULE-T14-R043]-A Credit Note MUST specify the taxable amount per tax subtotal.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R044">[BIIRULE-T14-R044]-A Credit Note MUST specify the tax amount per tax subtotal.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R047">[BIIRULE-T14-R047]-A credit note MUST specify the tax amount per VAT subtotal.</assert>
  </rule>
  <rule context="$Credit_Note_Line">
    <assert flag="fatal" test="$BIIRULE-T14-R027">[BIIRULE-T14-R027]-Each credit note line MUST contain the product/service name</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R034">[BIIRULE-T14-R034]-Credit note lines MUST have a line identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R050">[BIIRULE-T14-R050]-Credit note lines MUST have a line total amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R018">[BIIRULE-T14-R018]-Credit note line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R051">[BIIRULE-T14-R051]-Credit Note line MUST contain the item price</assert>
  </rule>
  <rule context="$Tax_Total">
    <assert flag="fatal" test="$BIIRULE-T14-R009">[BIIRULE-T14-R009]-A credit note MUST have a tax total refering to a single tax scheme</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R010">[BIIRULE-T14-R010]-Each tax total MUST equal the sum of the subcategory amounts.</assert>
  </rule>
  <rule context="$Party_Legal_Entity">
    <assert flag="fatal" test="$BIIRULE-T14-R039">[BIIRULE-T14-R039]-Company identifier MUST be specified when describing a company legal entity.</assert>
  </rule>
  <rule context="$Supplier">
    <assert flag="warning" test="$BIIRULE-T14-R002">[BIIRULE-T14-R002]-A supplier address in a credit note SHOULD contain at least the city name and a zip code or have an address identifier.</assert>
    <assert flag="warning" test="$BIIRULE-T14-R003">[BIIRULE-T14-R003]-In cross border trade the VAT identifier for the supplier should be prefixed with country code.</assert>
  </rule>
  <rule context="$Item">
    <assert flag="warning" test="$BIIRULE-T14-R019">[BIIRULE-T14-R019]-Product names SHOULD NOT exceed 50 characters long</assert>
    <assert flag="warning" test="$BIIRULE-T14-R020">[BIIRULE-T14-R020]-If standard identifiers are provided within an item description, an Scheme Identifier SHOULD be provided (e.g. GTIN)</assert>
    <assert flag="warning" test="$BIIRULE-T14-R021">[BIIRULE-T14-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</assert>
  </rule>
  <rule context="$Allowance">
    <assert flag="warning" test="$BIIRULE-T14-R024">[BIIRULE-T14-R024]-In allowances, both or none of percentage and base amount SHOULD be provided</assert>
  </rule>
  <rule context="$Total_Amounts">
    <assert flag="fatal" test="$BIIRULE-T14-R011">[BIIRULE-T14-R011]-Credit note total line extension amount MUST equal the sum of the line totals</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R012">[BIIRULE-T14-R012]-A credit note tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R013">[BIIRULE-T14-R013]-A credit note tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R014">[BIIRULE-T14-R014]-Tax inclusive amount in a credit note MUST NOT be negative</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R015">[BIIRULE-T14-R015]-Total allowance it MUST be equal to the sum of allowances at document level</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R016">[BIIRULE-T14-R016]-Total charges it MUST be equal to the sum of document level charges.</assert>
    <assert flag="fatal" test="$BIIRULE-T14-R017">[BIIRULE-T14-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</assert>
  </rule>
  <rule context="$Invoice_Period">
    <assert flag="fatal" test="$BIIRULE-T14-R001">[BIIRULE-T14-R001]-An invoice period end date MUST be later or equal to an invoice period start date</assert>
  </rule>
  <rule context="$Tax_Scheme">
    <assert flag="fatal" test="$BIIRULE-T14-R046">[BIIRULE-T14-R046]-Every tax scheme MUST be defined through an identifier.</assert>
  </rule>
</pattern>
