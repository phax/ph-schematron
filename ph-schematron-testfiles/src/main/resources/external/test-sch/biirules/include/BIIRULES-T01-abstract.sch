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
<!--Abstract Schematron rules for T01-->
<pattern abstract="true" id="T01" xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule context="$Customer">
    <assert flag="fatal" test="$BIIRULE-T01-R009">[BIIRULE-T01-R009]-An order MUST contain the full name of the customer.</assert>
    <assert flag="warning" test="$BIIRULE-T01-R014">[BIIRULE-T01-R014]-A customer address in an order SHOULD contain at least city and zip code or have an address identifier.</assert>
    <assert flag="warning" test="$BIIRULE-T01-R015">[BIIRULE-T01-R015]-In cross border trade the VAT identifier for the customer SHOULD be prefixed with country code.</assert>
  </rule>
  <rule context="$Requested_delivery_period">
    <assert flag="fatal" test="$BIIRULE-T01-R011">[BIIRULE-T01-R011]-A delivery period end date MUST be later or equal to a delivery period start date</assert>
  </rule>
  <rule context="$Order">
    <assert flag="fatal" test="$BIIRULE-T01-R001">[BIIRULE-T01-R001]-An order MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R002">[BIIRULE-T01-R002]-An order MUST have a customization identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R003">[BIIRULE-T01-R003]-An order MUST have a profile identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R004">[BIIRULE-T01-R004]-An order MUST contain the date of issue</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R005">[BIIRULE-T01-R005]-An order MUST contain the order identifier</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R016">[BIIRULE-T01-R016]-An order MUST have at least one order line</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R027">[BIIRULE-T01-R027]-Currency Identifier MUST be stated in currency stated on header level.</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R030">[BIIRULE-T01-R030]-An order MUST have a currency code for the document.</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R031">[BIIRULE-T01-R031]-Quantities MUST have unit of measure</assert>
  </rule>
  <rule context="$Annex">
    <assert flag="fatal" test="$BIIRULE-T01-R007">[BIIRULE-T01-R007]-Any references to Additional documents MUST specify the document identifier.</assert>
  </rule>
  <rule context="$Item_Price">
    <assert flag="fatal" test="$BIIRULE-T01-R026">[BIIRULE-T01-R026]-Prices of items MUST not be negative</assert>
  </rule>
  <rule context="$Country">
    <assert flag="fatal" test="$BIIRULE-T01-R028">[BIIRULE-T01-R028]-Country in an address MUST be specified using the country code</assert>
  </rule>
  <rule context="$Contract">
    <assert flag="fatal" test="$BIIRULE-T01-R008">[BIIRULE-T01-R008]-Any reference to a contract MUST specify the contract identifier.</assert>
  </rule>
  <rule context="$Tax_Total">
    <assert flag="warning" test="$BIIRULE-T01-R029">[BIIRULE-T01-R029]-TaxTotal on header SHOULD be the sum of taxes on line level</assert>
  </rule>
  <rule context="$Order_Line">
    <assert flag="fatal" test="$BIIRULE-T01-R013">[BIIRULE-T01-R013]-An order line MUST contain ID or Name</assert>
    <assert flag="fatal" test="$BIIRULE-T01-R017">[BIIRULE-T01-R017]-Order line MUST contain a unique line identifier</assert>
  </rule>
  <rule context="$Supplier">
    <assert flag="fatal" test="$BIIRULE-T01-R010">[BIIRULE-T01-R010]-An order MUST contain the full name of the supplier.</assert>
    <assert flag="warning" test="$BIIRULE-T01-R012">[BIIRULE-T01-R012]-A supplier address in an order SHOULD contain at least the city name and a zip code or have an address identifier</assert>
  </rule>
  <rule context="$Item">
    <assert flag="warning" test="$BIIRULE-T01-R023">[BIIRULE-T01-R023]-Product names SHOULD NOT exceed 50 characters</assert>
    <assert flag="warning" test="$BIIRULE-T01-R024">[BIIRULE-T01-R024]-Standard Identifiers SHOULD contain the Schema Identifier (e.g. GTIN)</assert>
    <assert flag="warning" test="$BIIRULE-T01-R025">[BIIRULE-T01-R025]-Classification codes SHOULD contain the Classification scheme Identifier (e.g. CPV or UNSPSC)</assert>
  </rule>
  <rule context="$Total_Amounts">
    <assert flag="warning" test="$BIIRULE-T01-R018">[BIIRULE-T01-R018]-Order monetary total amount SHOULD equal the sum of the line extension amounts</assert>
    <assert flag="warning" test="$BIIRULE-T01-R019">[BIIRULE-T01-R019]-Total allowance it SHOULD be equal to the sum of allowances at document level</assert>
    <assert flag="warning" test="$BIIRULE-T01-R020">[BIIRULE-T01-R020]-Total charges it SHOULD be equal to the sum of document level charges.</assert>
    <assert flag="warning" test="$BIIRULE-T01-R021">[BIIRULE-T01-R021]-Payable amount SHOULD be equal to the sum of total line amount minus total  allowances plus total charges and VAT total amount</assert>
  </rule>
  <rule context="$Originator_document">
    <assert flag="fatal" test="$BIIRULE-T01-R006">[BIIRULE-T01-R006]-Any reference to Originator document MUST specify the document identifier.</assert>
  </rule>
</pattern>
