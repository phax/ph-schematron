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
  <rule context="$Tax_Category">
    <assert flag="fatal" test="$EUGEN-T15-R008">[EUGEN-T15-R008]-For each tax subcategory the category ID and the applicable tax percentage MUST be provided.</assert>
  </rule>
  <rule context="$Allowance_Charge">
    <assert flag="fatal" test="$EUGEN-T15-R006">[EUGEN-T15-R006]-If the VAT total amount in an invoice exists then an Allowances Charges amount on document level MUST have Tax category for VAT.</assert>
    <assert flag="fatal" test="$EUGEN-T15-R022">[EUGEN-T15-R022]-An allowance or charge amount MUST NOT be negative.</assert>
    <assert flag="warning" test="$EUGEN-T15-R023">[EUGEN-T15-R023]-AllowanceChargeReason text SHOULD be specified for all allowances and charges</assert>
    <assert flag="fatal" test="$EUGEN-T15-R012">[EUGEN-T15-R012]-An allowance percentage MUST NOT be negative.</assert>
    <assert flag="warning" test="$EUGEN-T15-R013">[EUGEN-T15-R013]-In allowances, both or none of percentage and base amount SHOULD be provided</assert>
  </rule>
  <rule context="$Customer_Party">
    <assert flag="warning" test="$EUGEN-T15-R002">[EUGEN-T15-R002]-A customer postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</assert>
  </rule>
  <rule context="$Total_Amounts">
    <assert flag="fatal" test="$EUGEN-T15-R019">[EUGEN-T15-R019]-Total payable amount in an invoice MUST NOT be negative</assert>
  </rule>
  <rule context="$Delivery_Address">
    <assert flag="warning" test="$EUGEN-T15-R005">[EUGEN-T15-R005]-A Delivery address in an SHOULD contain at least, city, zip code and country code.</assert>
  </rule>
  <rule context="$Supplier_Party">
    <assert flag="warning" test="$EUGEN-T15-R001">[EUGEN-T15-R001]-A supplier postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</assert>
  </rule>
  <rule context="$Invoice">
    <assert flag="fatal" test="$EUGEN-T15-R007">[EUGEN-T15-R007]-If the VAT total amount in an invoice exists it MUST contain the suppliers VAT number.</assert>
    <assert flag="fatal" test="$EUGEN-T15-R010">[EUGEN-T15-R010]-If payee information is provided then the payee name MUST be specified.</assert>
    <assert flag="fatal" test="$EUGEN-T15-R015">[EUGEN-T15-R015]-IF VAT = &quot;AE&quot; (reverse charge) THEN it MUST contain Supplier VAT id and Customer VAT</assert>
    <assert flag="fatal" test="$EUGEN-T15-R016">[EUGEN-T15-R016]-IF VAT = &quot;AE&quot; (reverse charge) THEN VAT MAY NOT contain other VAT categories.</assert>
    <assert flag="fatal" test="$EUGEN-T15-R017">[EUGEN-T15-R017]-IF VAT = &quot;AE&quot; (reverse charge) THEN The taxable amount MUST equal the invoice total without VAT amount.</assert>
    <assert flag="fatal" test="$EUGEN-T15-R018">[EUGEN-T15-R018]-IF VAT = &quot;AE&quot; (reverse charge) THEN VAT tax amount MUST be zero.</assert>
    <assert flag="fatal" test="$EUGEN-T15-R024">[EUGEN-T15-R024]-Currency Identifier MUST be in stated in the currency stated on header level.</assert>
  </rule>
  <rule context="$Invoice_Period">
    <assert flag="fatal" test="$EUGEN-T15-R020">[EUGEN-T15-R020]-If the invoice refers to a period, the period MUST have an start date.</assert>
    <assert flag="fatal" test="$EUGEN-T15-R021">[EUGEN-T15-R021]-If the invoice refers to a period, the period MUST have an end date.</assert>
  </rule>
  <rule context="$Payment_Means">
    <assert flag="warning" test="$EUGEN-T15-R004">[EUGEN-T15-R004]-If the payment means are international account transfer and the account id is IBAN then the financial institution should be identified by using the BIC id.</assert>
  </rule>
  <rule context="$Classified_Tax_Category">
    <assert flag="fatal" test="$EUGEN-T15-R011">[EUGEN-T15-R011]-If the VAT total amount in an invoice exists then each invoice line item must have a VAT category ID.</assert>
  </rule>
  <rule context="$Invoice_Line">
    <assert flag="warning" test="$EUGEN-T15-R003">[EUGEN-T15-R003]-Each invoice line SHOULD contain the quantity and unit of measure</assert>
  </rule>
  <rule context="$Tax_Subtotal">
    <assert flag="warning" test="$EUGEN-T15-R009">[EUGEN-T15-R009]-If the category for VAT is exempt (E) then an exemption reason SHOULD be provided.</assert>
  </rule>
</pattern>
