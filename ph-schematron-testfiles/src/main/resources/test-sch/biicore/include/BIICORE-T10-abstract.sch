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
    <assert flag="warning" test="$BIICORE-T10-R387">[BIICORE-T10-R387]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R388">[BIICORE-T10-R388]-Element &#39;PartyName&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R389">[BIICORE-T10-R389]-Element &#39;PartyTaxScheme&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Payee">
    <assert flag="warning" test="$BIICORE-T10-R402">[BIICORE-T10-R402]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R403">[BIICORE-T10-R403]-Element &#39;PartyName&#39; may occur at maximum 1 times</assert>
  </rule>
  <rule context="$Financial_Account">
    <assert flag="warning" test="$BIICORE-T10-R404">[BIICORE-T10-R404]-Element &#39;ID&#39; must occur exactly 1 times.</assert>
  </rule>
  <rule context="$InvoiceLine">
    <assert flag="warning" test="$BIICORE-T10-R394">[BIICORE-T10-R394]-Element &#39;TaxTotal&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R395">[BIICORE-T10-R395]-Element &#39;Price&#39; must occur exactly 1 times.</assert>
  </rule>
  <rule context="$Supplier">
    <assert flag="warning" test="$BIICORE-T10-R390">[BIICORE-T10-R390]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R391">[BIICORE-T10-R391]-Element &#39;PartyName&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R392">[BIICORE-T10-R392]-Element &#39;PostalAddress&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R393">[BIICORE-T10-R393]-Element &#39;PartyTaxScheme&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Item">
    <assert flag="warning" test="$BIICORE-T10-R396">[BIICORE-T10-R396]-Element &#39;Description&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R397">[BIICORE-T10-R397]-Element &#39;Name&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R398">[BIICORE-T10-R398]-Element &#39;ClassifiedTaxCategory&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Price">
    <assert flag="warning" test="$BIICORE-T10-R399">[BIICORE-T10-R399]-Element &#39;AllowanceCharge&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Invoice">
    <assert flag="warning" test="$BIICORE-T10-R000">[BIICORE-T10-R000]-This XML instance is NOT a core BiiTrdm010 transaction</assert>
    <assert flag="warning" test="$BIICORE-T10-R001">[BIICORE-T10-R001]-An invoice SHOULD not contain empty elements.</assert>
    <assert flag="warning" test="$BIICORE-T10-R002">[BIICORE-T10-R002]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R003">[BIICORE-T10-R003]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R004">[BIICORE-T10-R004]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R005">[BIICORE-T10-R005]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R006">[BIICORE-T10-R006]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R007">[BIICORE-T10-R007]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R008">[BIICORE-T10-R008]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R009">[BIICORE-T10-R009]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R010">[BIICORE-T10-R010]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R011">[BIICORE-T10-R011]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R012">[BIICORE-T10-R012]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R013">[BIICORE-T10-R013]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R014">[BIICORE-T10-R014]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R015">[BIICORE-T10-R015]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R016">[BIICORE-T10-R016]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R017">[BIICORE-T10-R017]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R018">[BIICORE-T10-R018]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R019">[BIICORE-T10-R019]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R020">[BIICORE-T10-R020]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R021">[BIICORE-T10-R021]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R022">[BIICORE-T10-R022]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R023">[BIICORE-T10-R023]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R024">[BIICORE-T10-R024]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R025">[BIICORE-T10-R025]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R026">[BIICORE-T10-R026]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R027">[BIICORE-T10-R027]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R028">[BIICORE-T10-R028]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R029">[BIICORE-T10-R029]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R030">[BIICORE-T10-R030]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R031">[BIICORE-T10-R031]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R032">[BIICORE-T10-R032]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R033">[BIICORE-T10-R033]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R034">[BIICORE-T10-R034]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R035">[BIICORE-T10-R035]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R036">[BIICORE-T10-R036]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R037">[BIICORE-T10-R037]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R038">[BIICORE-T10-R038]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R039">[BIICORE-T10-R039]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R040">[BIICORE-T10-R040]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R041">[BIICORE-T10-R041]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R042">[BIICORE-T10-R042]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R043">[BIICORE-T10-R043]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R044">[BIICORE-T10-R044]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R045">[BIICORE-T10-R045]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R046">[BIICORE-T10-R046]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R047">[BIICORE-T10-R047]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R048">[BIICORE-T10-R048]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R049">[BIICORE-T10-R049]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R050">[BIICORE-T10-R050]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R051">[BIICORE-T10-R051]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R052">[BIICORE-T10-R052]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R053">[BIICORE-T10-R053]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R054">[BIICORE-T10-R054]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R055">[BIICORE-T10-R055]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R056">[BIICORE-T10-R056]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R057">[BIICORE-T10-R057]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R058">[BIICORE-T10-R058]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R059">[BIICORE-T10-R059]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R060">[BIICORE-T10-R060]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R061">[BIICORE-T10-R061]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R062">[BIICORE-T10-R062]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R063">[BIICORE-T10-R063]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R064">[BIICORE-T10-R064]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R065">[BIICORE-T10-R065]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R066">[BIICORE-T10-R066]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R067">[BIICORE-T10-R067]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R068">[BIICORE-T10-R068]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R069">[BIICORE-T10-R069]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R070">[BIICORE-T10-R070]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R071">[BIICORE-T10-R071]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R072">[BIICORE-T10-R072]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R073">[BIICORE-T10-R073]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R074">[BIICORE-T10-R074]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R075">[BIICORE-T10-R075]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R076">[BIICORE-T10-R076]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R077">[BIICORE-T10-R077]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R078">[BIICORE-T10-R078]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R079">[BIICORE-T10-R079]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R080">[BIICORE-T10-R080]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R081">[BIICORE-T10-R081]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R082">[BIICORE-T10-R082]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R083">[BIICORE-T10-R083]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R084">[BIICORE-T10-R084]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R085">[BIICORE-T10-R085]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R086">[BIICORE-T10-R086]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R087">[BIICORE-T10-R087]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R088">[BIICORE-T10-R088]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R089">[BIICORE-T10-R089]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R090">[BIICORE-T10-R090]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R091">[BIICORE-T10-R091]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R092">[BIICORE-T10-R092]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R093">[BIICORE-T10-R093]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R094">[BIICORE-T10-R094]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R095">[BIICORE-T10-R095]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R096">[BIICORE-T10-R096]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R097">[BIICORE-T10-R097]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R098">[BIICORE-T10-R098]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R099">[BIICORE-T10-R099]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R100">[BIICORE-T10-R100]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R101">[BIICORE-T10-R101]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R102">[BIICORE-T10-R102]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R103">[BIICORE-T10-R103]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R104">[BIICORE-T10-R104]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R105">[BIICORE-T10-R105]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R106">[BIICORE-T10-R106]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R107">[BIICORE-T10-R107]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R108">[BIICORE-T10-R108]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R109">[BIICORE-T10-R109]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R110">[BIICORE-T10-R110]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R111">[BIICORE-T10-R111]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R112">[BIICORE-T10-R112]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R113">[BIICORE-T10-R113]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R114">[BIICORE-T10-R114]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R115">[BIICORE-T10-R115]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R116">[BIICORE-T10-R116]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R117">[BIICORE-T10-R117]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R118">[BIICORE-T10-R118]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R119">[BIICORE-T10-R119]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R120">[BIICORE-T10-R120]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R121">[BIICORE-T10-R121]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R122">[BIICORE-T10-R122]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R123">[BIICORE-T10-R123]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R124">[BIICORE-T10-R124]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R125">[BIICORE-T10-R125]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R126">[BIICORE-T10-R126]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R127">[BIICORE-T10-R127]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R128">[BIICORE-T10-R128]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R129">[BIICORE-T10-R129]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R130">[BIICORE-T10-R130]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R131">[BIICORE-T10-R131]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R132">[BIICORE-T10-R132]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R133">[BIICORE-T10-R133]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R134">[BIICORE-T10-R134]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R135">[BIICORE-T10-R135]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R136">[BIICORE-T10-R136]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R137">[BIICORE-T10-R137]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R138">[BIICORE-T10-R138]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R139">[BIICORE-T10-R139]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R140">[BIICORE-T10-R140]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R141">[BIICORE-T10-R141]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R142">[BIICORE-T10-R142]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R143">[BIICORE-T10-R143]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R144">[BIICORE-T10-R144]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R145">[BIICORE-T10-R145]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R146">[BIICORE-T10-R146]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R147">[BIICORE-T10-R147]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R148">[BIICORE-T10-R148]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R149">[BIICORE-T10-R149]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R150">[BIICORE-T10-R150]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R151">[BIICORE-T10-R151]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R152">[BIICORE-T10-R152]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R153">[BIICORE-T10-R153]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R154">[BIICORE-T10-R154]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R155">[BIICORE-T10-R155]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R156">[BIICORE-T10-R156]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R157">[BIICORE-T10-R157]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R158">[BIICORE-T10-R158]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R159">[BIICORE-T10-R159]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R160">[BIICORE-T10-R160]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R161">[BIICORE-T10-R161]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R162">[BIICORE-T10-R162]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R163">[BIICORE-T10-R163]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R164">[BIICORE-T10-R164]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R165">[BIICORE-T10-R165]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R166">[BIICORE-T10-R166]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R167">[BIICORE-T10-R167]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R168">[BIICORE-T10-R168]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R169">[BIICORE-T10-R169]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R170">[BIICORE-T10-R170]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R171">[BIICORE-T10-R171]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R172">[BIICORE-T10-R172]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R173">[BIICORE-T10-R173]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R174">[BIICORE-T10-R174]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R175">[BIICORE-T10-R175]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R176">[BIICORE-T10-R176]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R177">[BIICORE-T10-R177]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R178">[BIICORE-T10-R178]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R179">[BIICORE-T10-R179]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R180">[BIICORE-T10-R180]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R181">[BIICORE-T10-R181]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R182">[BIICORE-T10-R182]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R183">[BIICORE-T10-R183]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R184">[BIICORE-T10-R184]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R185">[BIICORE-T10-R185]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R186">[BIICORE-T10-R186]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R187">[BIICORE-T10-R187]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R188">[BIICORE-T10-R188]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R189">[BIICORE-T10-R189]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R190">[BIICORE-T10-R190]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R191">[BIICORE-T10-R191]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R192">[BIICORE-T10-R192]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R193">[BIICORE-T10-R193]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R194">[BIICORE-T10-R194]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R195">[BIICORE-T10-R195]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R196">[BIICORE-T10-R196]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R197">[BIICORE-T10-R197]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R198">[BIICORE-T10-R198]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R199">[BIICORE-T10-R199]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R200">[BIICORE-T10-R200]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R201">[BIICORE-T10-R201]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R202">[BIICORE-T10-R202]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R203">[BIICORE-T10-R203]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R204">[BIICORE-T10-R204]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R205">[BIICORE-T10-R205]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R206">[BIICORE-T10-R206]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R207">[BIICORE-T10-R207]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R208">[BIICORE-T10-R208]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R209">[BIICORE-T10-R209]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R210">[BIICORE-T10-R210]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R211">[BIICORE-T10-R211]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R212">[BIICORE-T10-R212]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R213">[BIICORE-T10-R213]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R214">[BIICORE-T10-R214]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R215">[BIICORE-T10-R215]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R216">[BIICORE-T10-R216]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R217">[BIICORE-T10-R217]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R218">[BIICORE-T10-R218]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R219">[BIICORE-T10-R219]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R220">[BIICORE-T10-R220]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R221">[BIICORE-T10-R221]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R222">[BIICORE-T10-R222]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R223">[BIICORE-T10-R223]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R224">[BIICORE-T10-R224]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R225">[BIICORE-T10-R225]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R226">[BIICORE-T10-R226]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R227">[BIICORE-T10-R227]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R228">[BIICORE-T10-R228]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R229">[BIICORE-T10-R229]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R230">[BIICORE-T10-R230]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R231">[BIICORE-T10-R231]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R232">[BIICORE-T10-R232]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R233">[BIICORE-T10-R233]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R234">[BIICORE-T10-R234]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R235">[BIICORE-T10-R235]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R236">[BIICORE-T10-R236]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R237">[BIICORE-T10-R237]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R238">[BIICORE-T10-R238]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R239">[BIICORE-T10-R239]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R240">[BIICORE-T10-R240]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R241">[BIICORE-T10-R241]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R242">[BIICORE-T10-R242]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R243">[BIICORE-T10-R243]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R244">[BIICORE-T10-R244]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R245">[BIICORE-T10-R245]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R246">[BIICORE-T10-R246]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R247">[BIICORE-T10-R247]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R248">[BIICORE-T10-R248]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R249">[BIICORE-T10-R249]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R250">[BIICORE-T10-R250]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R251">[BIICORE-T10-R251]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R252">[BIICORE-T10-R252]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R253">[BIICORE-T10-R253]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R254">[BIICORE-T10-R254]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R255">[BIICORE-T10-R255]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R256">[BIICORE-T10-R256]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R257">[BIICORE-T10-R257]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R258">[BIICORE-T10-R258]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R259">[BIICORE-T10-R259]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R260">[BIICORE-T10-R260]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R261">[BIICORE-T10-R261]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R262">[BIICORE-T10-R262]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R263">[BIICORE-T10-R263]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R264">[BIICORE-T10-R264]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R265">[BIICORE-T10-R265]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R266">[BIICORE-T10-R266]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R267">[BIICORE-T10-R267]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R268">[BIICORE-T10-R268]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R269">[BIICORE-T10-R269]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R270">[BIICORE-T10-R270]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R271">[BIICORE-T10-R271]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R272">[BIICORE-T10-R272]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R273">[BIICORE-T10-R273]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R274">[BIICORE-T10-R274]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R275">[BIICORE-T10-R275]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R276">[BIICORE-T10-R276]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R277">[BIICORE-T10-R277]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R278">[BIICORE-T10-R278]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R279">[BIICORE-T10-R279]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R280">[BIICORE-T10-R280]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R281">[BIICORE-T10-R281]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R282">[BIICORE-T10-R282]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R283">[BIICORE-T10-R283]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R284">[BIICORE-T10-R284]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R285">[BIICORE-T10-R285]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R286">[BIICORE-T10-R286]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R287">[BIICORE-T10-R287]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R288">[BIICORE-T10-R288]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R289">[BIICORE-T10-R289]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R290">[BIICORE-T10-R290]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R291">[BIICORE-T10-R291]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R292">[BIICORE-T10-R292]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R293">[BIICORE-T10-R293]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R294">[BIICORE-T10-R294]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R295">[BIICORE-T10-R295]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R296">[BIICORE-T10-R296]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R297">[BIICORE-T10-R297]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R298">[BIICORE-T10-R298]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R299">[BIICORE-T10-R299]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R300">[BIICORE-T10-R300]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R301">[BIICORE-T10-R301]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R302">[BIICORE-T10-R302]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R303">[BIICORE-T10-R303]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R304">[BIICORE-T10-R304]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R305">[BIICORE-T10-R305]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R306">[BIICORE-T10-R306]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R307">[BIICORE-T10-R307]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R308">[BIICORE-T10-R308]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R309">[BIICORE-T10-R309]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R310">[BIICORE-T10-R310]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R311">[BIICORE-T10-R311]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R312">[BIICORE-T10-R312]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R313">[BIICORE-T10-R313]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R314">[BIICORE-T10-R314]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R315">[BIICORE-T10-R315]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R316">[BIICORE-T10-R316]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R317">[BIICORE-T10-R317]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R318">[BIICORE-T10-R318]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R319">[BIICORE-T10-R319]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R320">[BIICORE-T10-R320]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R321">[BIICORE-T10-R321]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R322">[BIICORE-T10-R322]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R323">[BIICORE-T10-R323]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R324">[BIICORE-T10-R324]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R325">[BIICORE-T10-R325]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R326">[BIICORE-T10-R326]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R327">[BIICORE-T10-R327]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R328">[BIICORE-T10-R328]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R329">[BIICORE-T10-R329]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R330">[BIICORE-T10-R330]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R331">[BIICORE-T10-R331]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R332">[BIICORE-T10-R332]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R333">[BIICORE-T10-R333]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R334">[BIICORE-T10-R334]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R335">[BIICORE-T10-R335]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R336">[BIICORE-T10-R336]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R337">[BIICORE-T10-R337]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R338">[BIICORE-T10-R338]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R339">[BIICORE-T10-R339]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R340">[BIICORE-T10-R340]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R341">[BIICORE-T10-R341]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R342">[BIICORE-T10-R342]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R343">[BIICORE-T10-R343]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R344">[BIICORE-T10-R344]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R345">[BIICORE-T10-R345]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R346">[BIICORE-T10-R346]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R347">[BIICORE-T10-R347]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R348">[BIICORE-T10-R348]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R349">[BIICORE-T10-R349]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R350">[BIICORE-T10-R350]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R351">[BIICORE-T10-R351]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R352">[BIICORE-T10-R352]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R353">[BIICORE-T10-R353]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R354">[BIICORE-T10-R354]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R355">[BIICORE-T10-R355]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R356">[BIICORE-T10-R356]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R357">[BIICORE-T10-R357]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R358">[BIICORE-T10-R358]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R359">[BIICORE-T10-R359]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R360">[BIICORE-T10-R360]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R361">[BIICORE-T10-R361]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R362">[BIICORE-T10-R362]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R363">[BIICORE-T10-R363]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R364">[BIICORE-T10-R364]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R365">[BIICORE-T10-R365]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R366">[BIICORE-T10-R366]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R367">[BIICORE-T10-R367]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R368">[BIICORE-T10-R368]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R369">[BIICORE-T10-R369]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R370">[BIICORE-T10-R370]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R371">[BIICORE-T10-R371]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R372">[BIICORE-T10-R372]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R373">[BIICORE-T10-R373]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R374">[BIICORE-T10-R374]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R375">[BIICORE-T10-R375]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R376">[BIICORE-T10-R376]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R377">[BIICORE-T10-R377]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R378">[BIICORE-T10-R378]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R379">[BIICORE-T10-R379]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R380">[BIICORE-T10-R380]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R381">[BIICORE-T10-R381]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R382">[BIICORE-T10-R382]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R383">[BIICORE-T10-R383]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R384">[BIICORE-T10-R384]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R385">[BIICORE-T10-R385]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T10-R386">[BIICORE-T10-R386]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</assert>
  </rule>
  <rule context="$Monetary_Total">
    <assert flag="warning" test="$BIICORE-T10-R400">[BIICORE-T10-R400]-Element &#39;TaxExclusiveAmount&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T10-R401">[BIICORE-T10-R401]-Element &#39;TaxInclusiveAmount&#39; must occur exactly 1 times.</assert>
  </rule>
</pattern>
