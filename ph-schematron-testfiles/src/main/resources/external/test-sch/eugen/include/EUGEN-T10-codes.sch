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
<!--Code list Schematron rules for T10-->
<pattern id="Codes-T10" xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule context="cac:FinancialInstitution/cbc:ID//@schemeID">
    <assert flag="warning" test="contains(&#39;�BIC�&#39;,concat(&#39;�&#39;,.,&#39;�&#39;))">[PCL-010-002]-If FinancialAccountID is IBAN then Financial InstitutionID SHOULD be BIC code.</assert>
  </rule>
  <rule context="cac:PostalAddress/cbc:ID//@schemeID">
    <assert flag="warning" test="contains(&#39;�GLN�&#39;,concat(&#39;�&#39;,.,&#39;�&#39;))">[PCL-010-003]-Postal address identifiers SHOULD be GLN.</assert>
  </rule>
  <rule context="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID">
    <assert flag="warning" test="contains(&#39;�GLN�&#39;,concat(&#39;�&#39;,.,&#39;�&#39;))">[PCL-010-004]-Location identifiers SHOULD be GLN</assert>
  </rule>
  <rule context="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID">
    <assert flag="warning" test="contains(&#39;�GTIN�&#39;,concat(&#39;�&#39;,.,&#39;�&#39;))">[PCL-010-005]-Standard item identifiers SHOULD be GTIN.</assert>
  </rule>
  <rule context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID">
    <assert flag="warning" test="contains(&#39;�CPV�UNSPSC�eCLASS�&#39;,concat(&#39;�&#39;,.,&#39;�&#39;))">[PCL-010-006]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</assert>
  </rule>
  <rule context="cbc:TaxExemptionReasonCode">
    <assert flag="fatal" test="contains(&#39;�AAA Exempt�AAB Exempt�AAC Exempt�AAE Reverse Charge�AAF Exempt�AAG Exempt�AAH Margin Scheme�AAI Margin Scheme�AAJ Reverse Charge�AAK Reverse Charge�AAL Reverse Charge Exempt�AAM Exempt New Means of Transport�AAN Exempt Triangulation�AAO Reverse Charge�&#39;,concat(&#39;�&#39;,.,&#39;�&#39;))">[PCL-010-007]-Tax exemption reasons MUST be coded using Use CWA 15577 tax exemption code list. Version 2006</assert>
  </rule>
  <rule context="cac:PartyIdentification/cbc:ID//@schemeID">
    <assert flag="fatal" test="contains(&#39;�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�&#39;,concat(&#39;�&#39;,.,&#39;�&#39;))">[PCL-010-008]-Party Identifiers MUST use the PEPPOL PartyID list</assert>
  </rule>
  <rule context="cbc:EndpointID//@schemeID">
    <assert flag="fatal" test="contains(&#39;�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�&#39;,concat(&#39;�&#39;,.,&#39;�&#39;))">[PCL-010-009]-Endpoint Identifiers MUST use the PEPPOL PartyID list.</assert>
  </rule>
</pattern>
