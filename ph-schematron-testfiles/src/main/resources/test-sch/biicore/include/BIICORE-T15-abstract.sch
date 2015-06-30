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
    <assert flag="warning" test="$BIICORE-T15-R398">[BIICORE-T15-R398]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R399">[BIICORE-T15-R399]-Element &#39;PartyName&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R400">[BIICORE-T15-R400]-Element &#39;PartyTaxScheme&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Payee">
    <assert flag="warning" test="$BIICORE-T15-R413">[BIICORE-T15-R413]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R414">[BIICORE-T15-R414]-Element &#39;PartyName&#39; may occur at maximum 1 times</assert>
  </rule>
  <rule context="$Financial_Account">
    <assert flag="warning" test="$BIICORE-T15-R415">[BIICORE-T15-R415]-Element &#39;ID&#39; must occur exactly 1 times.</assert>
  </rule>
  <rule context="$InvoiceLine">
    <assert flag="warning" test="$BIICORE-T15-R405">[BIICORE-T15-R405]-Element &#39;TaxTotal&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R406">[BIICORE-T15-R406]-Element &#39;Price&#39; must occur exactly 1 times.</assert>
  </rule>
  <rule context="$Supplier">
    <assert flag="warning" test="$BIICORE-T15-R401">[BIICORE-T15-R401]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R402">[BIICORE-T15-R402]-Element &#39;PartyName&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R403">[BIICORE-T15-R403]-Element &#39;PostalAddress&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R404">[BIICORE-T15-R404]-Element &#39;PartyTaxScheme&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Item">
    <assert flag="warning" test="$BIICORE-T15-R407">[BIICORE-T15-R407]-Element &#39;Description&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R408">[BIICORE-T15-R408]-Element &#39;Name&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R409">[BIICORE-T15-R409]-Element &#39;ClassifiedTaxCategory&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Price">
    <assert flag="warning" test="$BIICORE-T15-R410">[BIICORE-T15-R410]-Element &#39;AllowanceCharge&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Invoice">
    <assert flag="warning" test="$BIICORE-T15-R000">[BIICORE-T15-R000]-This XML instance is NOT a BiiTrdm015 transaction</assert>
    <assert flag="warning" test="$BIICORE-T15-R001">[BIICORE-T15-R001]-An invoice SHOULD not contain empty elements.</assert>
    <assert flag="warning" test="$BIICORE-T15-R002">[BIICORE-T15-R002]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R003">[BIICORE-T15-R003]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R004">[BIICORE-T15-R004]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R005">[BIICORE-T15-R005]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R006">[BIICORE-T15-R006]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R007">[BIICORE-T15-R007]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R008">[BIICORE-T15-R008]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R009">[BIICORE-T15-R009]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R010">[BIICORE-T15-R010]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R011">[BIICORE-T15-R011]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R012">[BIICORE-T15-R012]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R013">[BIICORE-T15-R013]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R014">[BIICORE-T15-R014]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R015">[BIICORE-T15-R015]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R016">[BIICORE-T15-R016]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R017">[BIICORE-T15-R017]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R018">[BIICORE-T15-R018]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R019">[BIICORE-T15-R019]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R020">[BIICORE-T15-R020]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R021">[BIICORE-T15-R021]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R022">[BIICORE-T15-R022]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R023">[BIICORE-T15-R023]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R024">[BIICORE-T15-R024]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R025">[BIICORE-T15-R025]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R026">[BIICORE-T15-R026]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R027">[BIICORE-T15-R027]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R028">[BIICORE-T15-R028]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R029">[BIICORE-T15-R029]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R030">[BIICORE-T15-R030]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R031">[BIICORE-T15-R031]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R032">[BIICORE-T15-R032]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R033">[BIICORE-T15-R033]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R034">[BIICORE-T15-R034]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R035">[BIICORE-T15-R035]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R036">[BIICORE-T15-R036]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R037">[BIICORE-T15-R037]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R038">[BIICORE-T15-R038]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R039">[BIICORE-T15-R039]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R040">[BIICORE-T15-R040]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R041">[BIICORE-T15-R041]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R042">[BIICORE-T15-R042]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R043">[BIICORE-T15-R043]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R044">[BIICORE-T15-R044]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R045">[BIICORE-T15-R045]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R046">[BIICORE-T15-R046]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R047">[BIICORE-T15-R047]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R048">[BIICORE-T15-R048]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R049">[BIICORE-T15-R049]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R050">[BIICORE-T15-R050]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R051">[BIICORE-T15-R051]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R052">[BIICORE-T15-R052]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R053">[BIICORE-T15-R053]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R054">[BIICORE-T15-R054]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R055">[BIICORE-T15-R055]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R056">[BIICORE-T15-R056]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R057">[BIICORE-T15-R057]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R058">[BIICORE-T15-R058]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R059">[BIICORE-T15-R059]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R060">[BIICORE-T15-R060]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R061">[BIICORE-T15-R061]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R062">[BIICORE-T15-R062]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R063">[BIICORE-T15-R063]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R064">[BIICORE-T15-R064]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R065">[BIICORE-T15-R065]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R066">[BIICORE-T15-R066]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R067">[BIICORE-T15-R067]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R068">[BIICORE-T15-R068]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R069">[BIICORE-T15-R069]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R070">[BIICORE-T15-R070]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R071">[BIICORE-T15-R071]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R072">[BIICORE-T15-R072]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R073">[BIICORE-T15-R073]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R074">[BIICORE-T15-R074]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R075">[BIICORE-T15-R075]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R076">[BIICORE-T15-R076]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R077">[BIICORE-T15-R077]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R078">[BIICORE-T15-R078]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R079">[BIICORE-T15-R079]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R080">[BIICORE-T15-R080]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R081">[BIICORE-T15-R081]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R082">[BIICORE-T15-R082]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R083">[BIICORE-T15-R083]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R084">[BIICORE-T15-R084]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R085">[BIICORE-T15-R085]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R086">[BIICORE-T15-R086]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R087">[BIICORE-T15-R087]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R088">[BIICORE-T15-R088]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R089">[BIICORE-T15-R089]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R090">[BIICORE-T15-R090]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R091">[BIICORE-T15-R091]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R092">[BIICORE-T15-R092]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R093">[BIICORE-T15-R093]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R094">[BIICORE-T15-R094]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R095">[BIICORE-T15-R095]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R096">[BIICORE-T15-R096]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R097">[BIICORE-T15-R097]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R098">[BIICORE-T15-R098]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R099">[BIICORE-T15-R099]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R100">[BIICORE-T15-R100]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R101">[BIICORE-T15-R101]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R102">[BIICORE-T15-R102]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R103">[BIICORE-T15-R103]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R104">[BIICORE-T15-R104]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R105">[BIICORE-T15-R105]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R106">[BIICORE-T15-R106]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R107">[BIICORE-T15-R107]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R108">[BIICORE-T15-R108]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R109">[BIICORE-T15-R109]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R110">[BIICORE-T15-R110]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R111">[BIICORE-T15-R111]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R112">[BIICORE-T15-R112]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R113">[BIICORE-T15-R113]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R114">[BIICORE-T15-R114]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R115">[BIICORE-T15-R115]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R116">[BIICORE-T15-R116]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R117">[BIICORE-T15-R117]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R118">[BIICORE-T15-R118]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R119">[BIICORE-T15-R119]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R120">[BIICORE-T15-R120]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R121">[BIICORE-T15-R121]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R122">[BIICORE-T15-R122]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R123">[BIICORE-T15-R123]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R124">[BIICORE-T15-R124]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R125">[BIICORE-T15-R125]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R126">[BIICORE-T15-R126]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R127">[BIICORE-T15-R127]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R128">[BIICORE-T15-R128]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R129">[BIICORE-T15-R129]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R130">[BIICORE-T15-R130]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R131">[BIICORE-T15-R131]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R132">[BIICORE-T15-R132]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R133">[BIICORE-T15-R133]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R134">[BIICORE-T15-R134]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R135">[BIICORE-T15-R135]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R136">[BIICORE-T15-R136]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R137">[BIICORE-T15-R137]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R138">[BIICORE-T15-R138]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R139">[BIICORE-T15-R139]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R140">[BIICORE-T15-R140]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R141">[BIICORE-T15-R141]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R142">[BIICORE-T15-R142]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R143">[BIICORE-T15-R143]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R144">[BIICORE-T15-R144]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R145">[BIICORE-T15-R145]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R146">[BIICORE-T15-R146]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R147">[BIICORE-T15-R147]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R148">[BIICORE-T15-R148]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R149">[BIICORE-T15-R149]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R150">[BIICORE-T15-R150]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R151">[BIICORE-T15-R151]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R152">[BIICORE-T15-R152]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R153">[BIICORE-T15-R153]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R154">[BIICORE-T15-R154]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R155">[BIICORE-T15-R155]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R156">[BIICORE-T15-R156]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R157">[BIICORE-T15-R157]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R158">[BIICORE-T15-R158]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R159">[BIICORE-T15-R159]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R160">[BIICORE-T15-R160]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R161">[BIICORE-T15-R161]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R162">[BIICORE-T15-R162]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R163">[BIICORE-T15-R163]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R164">[BIICORE-T15-R164]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R165">[BIICORE-T15-R165]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R166">[BIICORE-T15-R166]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R167">[BIICORE-T15-R167]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R168">[BIICORE-T15-R168]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R169">[BIICORE-T15-R169]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R170">[BIICORE-T15-R170]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R171">[BIICORE-T15-R171]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R172">[BIICORE-T15-R172]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R173">[BIICORE-T15-R173]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R174">[BIICORE-T15-R174]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R175">[BIICORE-T15-R175]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R176">[BIICORE-T15-R176]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R177">[BIICORE-T15-R177]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R178">[BIICORE-T15-R178]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R179">[BIICORE-T15-R179]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R180">[BIICORE-T15-R180]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R181">[BIICORE-T15-R181]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R182">[BIICORE-T15-R182]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R183">[BIICORE-T15-R183]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R184">[BIICORE-T15-R184]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R185">[BIICORE-T15-R185]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R186">[BIICORE-T15-R186]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R187">[BIICORE-T15-R187]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R188">[BIICORE-T15-R188]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R189">[BIICORE-T15-R189]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R190">[BIICORE-T15-R190]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R191">[BIICORE-T15-R191]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R192">[BIICORE-T15-R192]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R193">[BIICORE-T15-R193]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R194">[BIICORE-T15-R194]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R195">[BIICORE-T15-R195]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R196">[BIICORE-T15-R196]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R197">[BIICORE-T15-R197]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R198">[BIICORE-T15-R198]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R199">[BIICORE-T15-R199]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R200">[BIICORE-T15-R200]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R201">[BIICORE-T15-R201]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R202">[BIICORE-T15-R202]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R203">[BIICORE-T15-R203]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R204">[BIICORE-T15-R204]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R205">[BIICORE-T15-R205]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R206">[BIICORE-T15-R206]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R207">[BIICORE-T15-R207]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R208">[BIICORE-T15-R208]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R209">[BIICORE-T15-R209]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R210">[BIICORE-T15-R210]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R211">[BIICORE-T15-R211]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R212">[BIICORE-T15-R212]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R213">[BIICORE-T15-R213]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R214">[BIICORE-T15-R214]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R215">[BIICORE-T15-R215]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R216">[BIICORE-T15-R216]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R217">[BIICORE-T15-R217]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R218">[BIICORE-T15-R218]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R219">[BIICORE-T15-R219]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R220">[BIICORE-T15-R220]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R221">[BIICORE-T15-R221]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R222">[BIICORE-T15-R222]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R223">[BIICORE-T15-R223]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R224">[BIICORE-T15-R224]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R225">[BIICORE-T15-R225]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R226">[BIICORE-T15-R226]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R227">[BIICORE-T15-R227]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R228">[BIICORE-T15-R228]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R229">[BIICORE-T15-R229]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R230">[BIICORE-T15-R230]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R231">[BIICORE-T15-R231]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R232">[BIICORE-T15-R232]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R233">[BIICORE-T15-R233]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R234">[BIICORE-T15-R234]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R235">[BIICORE-T15-R235]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R236">[BIICORE-T15-R236]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R237">[BIICORE-T15-R237]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R238">[BIICORE-T15-R238]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R239">[BIICORE-T15-R239]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R240">[BIICORE-T15-R240]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R241">[BIICORE-T15-R241]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R242">[BIICORE-T15-R242]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R243">[BIICORE-T15-R243]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R244">[BIICORE-T15-R244]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R245">[BIICORE-T15-R245]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R246">[BIICORE-T15-R246]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R247">[BIICORE-T15-R247]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R248">[BIICORE-T15-R248]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R249">[BIICORE-T15-R249]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R250">[BIICORE-T15-R250]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R251">[BIICORE-T15-R251]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R252">[BIICORE-T15-R252]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R253">[BIICORE-T15-R253]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R254">[BIICORE-T15-R254]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R255">[BIICORE-T15-R255]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R256">[BIICORE-T15-R256]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R257">[BIICORE-T15-R257]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R258">[BIICORE-T15-R258]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R259">[BIICORE-T15-R259]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R260">[BIICORE-T15-R260]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R261">[BIICORE-T15-R261]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R262">[BIICORE-T15-R262]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R263">[BIICORE-T15-R263]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R264">[BIICORE-T15-R264]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R265">[BIICORE-T15-R265]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R266">[BIICORE-T15-R266]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R267">[BIICORE-T15-R267]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R268">[BIICORE-T15-R268]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R269">[BIICORE-T15-R269]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R270">[BIICORE-T15-R270]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R271">[BIICORE-T15-R271]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R272">[BIICORE-T15-R272]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R273">[BIICORE-T15-R273]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R274">[BIICORE-T15-R274]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R275">[BIICORE-T15-R275]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R276">[BIICORE-T15-R276]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R277">[BIICORE-T15-R277]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R278">[BIICORE-T15-R278]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R279">[BIICORE-T15-R279]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R280">[BIICORE-T15-R280]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R281">[BIICORE-T15-R281]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R282">[BIICORE-T15-R282]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R283">[BIICORE-T15-R283]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R284">[BIICORE-T15-R284]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R285">[BIICORE-T15-R285]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R286">[BIICORE-T15-R286]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R287">[BIICORE-T15-R287]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R288">[BIICORE-T15-R288]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R289">[BIICORE-T15-R289]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R290">[BIICORE-T15-R290]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R291">[BIICORE-T15-R291]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R292">[BIICORE-T15-R292]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R293">[BIICORE-T15-R293]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R294">[BIICORE-T15-R294]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R295">[BIICORE-T15-R295]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R296">[BIICORE-T15-R296]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R297">[BIICORE-T15-R297]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R298">[BIICORE-T15-R298]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R299">[BIICORE-T15-R299]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R300">[BIICORE-T15-R300]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R301">[BIICORE-T15-R301]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R302">[BIICORE-T15-R302]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R303">[BIICORE-T15-R303]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R304">[BIICORE-T15-R304]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R305">[BIICORE-T15-R305]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R306">[BIICORE-T15-R306]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R307">[BIICORE-T15-R307]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R308">[BIICORE-T15-R308]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R309">[BIICORE-T15-R309]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R310">[BIICORE-T15-R310]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R311">[BIICORE-T15-R311]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R312">[BIICORE-T15-R312]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R313">[BIICORE-T15-R313]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R314">[BIICORE-T15-R314]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R315">[BIICORE-T15-R315]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R316">[BIICORE-T15-R316]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R317">[BIICORE-T15-R317]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R318">[BIICORE-T15-R318]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R319">[BIICORE-T15-R319]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R320">[BIICORE-T15-R320]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R321">[BIICORE-T15-R321]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R322">[BIICORE-T15-R322]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R323">[BIICORE-T15-R323]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R324">[BIICORE-T15-R324]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R325">[BIICORE-T15-R325]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R326">[BIICORE-T15-R326]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R327">[BIICORE-T15-R327]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R328">[BIICORE-T15-R328]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R329">[BIICORE-T15-R329]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R330">[BIICORE-T15-R330]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R331">[BIICORE-T15-R331]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R332">[BIICORE-T15-R332]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R333">[BIICORE-T15-R333]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R334">[BIICORE-T15-R334]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R335">[BIICORE-T15-R335]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R336">[BIICORE-T15-R336]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R337">[BIICORE-T15-R337]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R338">[BIICORE-T15-R338]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R339">[BIICORE-T15-R339]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R340">[BIICORE-T15-R340]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R341">[BIICORE-T15-R341]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R342">[BIICORE-T15-R342]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R343">[BIICORE-T15-R343]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R344">[BIICORE-T15-R344]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R345">[BIICORE-T15-R345]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R346">[BIICORE-T15-R346]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R347">[BIICORE-T15-R347]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R348">[BIICORE-T15-R348]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R349">[BIICORE-T15-R349]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R350">[BIICORE-T15-R350]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R351">[BIICORE-T15-R351]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R352">[BIICORE-T15-R352]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R353">[BIICORE-T15-R353]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R354">[BIICORE-T15-R354]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R355">[BIICORE-T15-R355]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R356">[BIICORE-T15-R356]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R357">[BIICORE-T15-R357]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R358">[BIICORE-T15-R358]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R359">[BIICORE-T15-R359]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R360">[BIICORE-T15-R360]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R361">[BIICORE-T15-R361]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R362">[BIICORE-T15-R362]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R363">[BIICORE-T15-R363]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R364">[BIICORE-T15-R364]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R365">[BIICORE-T15-R365]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R366">[BIICORE-T15-R366]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R367">[BIICORE-T15-R367]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R368">[BIICORE-T15-R368]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R369">[BIICORE-T15-R369]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R370">[BIICORE-T15-R370]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R371">[BIICORE-T15-R371]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R372">[BIICORE-T15-R372]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R373">[BIICORE-T15-R373]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R374">[BIICORE-T15-R374]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R375">[BIICORE-T15-R375]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R376">[BIICORE-T15-R376]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R377">[BIICORE-T15-R377]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R378">[BIICORE-T15-R378]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R379">[BIICORE-T15-R379]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R380">[BIICORE-T15-R380]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R381">[BIICORE-T15-R381]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R382">[BIICORE-T15-R382]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R383">[BIICORE-T15-R383]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R384">[BIICORE-T15-R384]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R385">[BIICORE-T15-R385]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R386">[BIICORE-T15-R386]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R387">[BIICORE-T15-R387]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R388">[BIICORE-T15-R388]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R389">[BIICORE-T15-R389]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R390">[BIICORE-T15-R390]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R391">[BIICORE-T15-R391]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R392">[BIICORE-T15-R392]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R393">[BIICORE-T15-R393]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R394">[BIICORE-T15-R394]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R395">[BIICORE-T15-R395]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R396">[BIICORE-T15-R396]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T15-R397">[BIICORE-T15-R397]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
  </rule>
  <rule context="$Monetary_Total">
    <assert flag="warning" test="$BIICORE-T15-R411">[BIICORE-T15-R411]-Element &#39;TaxExclusiveAmount&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T15-R412">[BIICORE-T15-R412]-Element &#39;TaxInclusiveAmount&#39; must occur exactly 1 times.</assert>
  </rule>
</pattern>
