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
    <assert flag="warning" test="$BIICORE-T01-R435">[BIICORE-T01-R435]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R436">[BIICORE-T01-R436]-Element &#39;PartyName&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R437">[BIICORE-T01-R437]-Element &#39;PartyLegalEntity&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Supplier">
    <assert flag="warning" test="$BIICORE-T01-R438">[BIICORE-T01-R438]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R439">[BIICORE-T01-R439]-Element &#39;PartyName&#39; must occur exactly 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R440">[BIICORE-T01-R440]-Element &#39;PartyLegalEntity&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Item">
    <assert flag="warning" test="$BIICORE-T01-R441">[BIICORE-T01-R441]-Element &#39;Description&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Originator">
    <assert flag="warning" test="$BIICORE-T01-R442">[BIICORE-T01-R442]-Element &#39;PartyIdentification&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R443">[BIICORE-T01-R443]-Element &#39;PartyName&#39; may occur at maximum 1 times</assert>
  </rule>
  <rule context="$Order">
    <assert flag="warning" test="$BIICORE-T01-R000">[BIICORE-T01-R000]-This XML instance is NOT a core BiiTrdm001 transaction</assert>
    <assert flag="warning" test="$BIICORE-T01-R001">[BIICORE-T01-R001]-An Order SHOULD not contain empty elements.</assert>
    <assert flag="warning" test="$BIICORE-T01-R002">[BIICORE-T01-R002]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R003">[BIICORE-T01-R003]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R004">[BIICORE-T01-R004]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R005">[BIICORE-T01-R005]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R006">[BIICORE-T01-R006]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R007">[BIICORE-T01-R007]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R008">[BIICORE-T01-R008]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R009">[BIICORE-T01-R009]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R010">[BIICORE-T01-R010]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R011">[BIICORE-T01-R011]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R012">[BIICORE-T01-R012]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R013">[BIICORE-T01-R013]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R014">[BIICORE-T01-R014]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R015">[BIICORE-T01-R015]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R016">[BIICORE-T01-R016]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R017">[BIICORE-T01-R017]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R018">[BIICORE-T01-R018]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R019">[BIICORE-T01-R019]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R020">[BIICORE-T01-R020]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R021">[BIICORE-T01-R021]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R022">[BIICORE-T01-R022]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R023">[BIICORE-T01-R023]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R024">[BIICORE-T01-R024]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R025">[BIICORE-T01-R025]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R026">[BIICORE-T01-R026]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R027">[BIICORE-T01-R027]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R028">[BIICORE-T01-R028]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R029">[BIICORE-T01-R029]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R030">[BIICORE-T01-R030]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R031">[BIICORE-T01-R031]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R032">[BIICORE-T01-R032]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R033">[BIICORE-T01-R033]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R034">[BIICORE-T01-R034]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R035">[BIICORE-T01-R035]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R036">[BIICORE-T01-R036]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R037">[BIICORE-T01-R037]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R038">[BIICORE-T01-R038]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R039">[BIICORE-T01-R039]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R040">[BIICORE-T01-R040]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R041">[BIICORE-T01-R041]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R042">[BIICORE-T01-R042]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R043">[BIICORE-T01-R043]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R044">[BIICORE-T01-R044]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R045">[BIICORE-T01-R045]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R046">[BIICORE-T01-R046]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R047">[BIICORE-T01-R047]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R048">[BIICORE-T01-R048]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R049">[BIICORE-T01-R049]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R050">[BIICORE-T01-R050]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R051">[BIICORE-T01-R051]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R052">[BIICORE-T01-R052]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R053">[BIICORE-T01-R053]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R054">[BIICORE-T01-R054]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R055">[BIICORE-T01-R055]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R056">[BIICORE-T01-R056]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R057">[BIICORE-T01-R057]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R058">[BIICORE-T01-R058]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R059">[BIICORE-T01-R059]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R060">[BIICORE-T01-R060]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R061">[BIICORE-T01-R061]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R062">[BIICORE-T01-R062]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R063">[BIICORE-T01-R063]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R064">[BIICORE-T01-R064]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R065">[BIICORE-T01-R065]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R066">[BIICORE-T01-R066]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R067">[BIICORE-T01-R067]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R068">[BIICORE-T01-R068]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R069">[BIICORE-T01-R069]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R070">[BIICORE-T01-R070]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R071">[BIICORE-T01-R071]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R072">[BIICORE-T01-R072]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R073">[BIICORE-T01-R073]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R074">[BIICORE-T01-R074]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R075">[BIICORE-T01-R075]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R076">[BIICORE-T01-R076]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R077">[BIICORE-T01-R077]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R078">[BIICORE-T01-R078]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R079">[BIICORE-T01-R079]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R080">[BIICORE-T01-R080]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R081">[BIICORE-T01-R081]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R082">[BIICORE-T01-R082]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R083">[BIICORE-T01-R083]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R084">[BIICORE-T01-R084]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R085">[BIICORE-T01-R085]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R086">[BIICORE-T01-R086]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R087">[BIICORE-T01-R087]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R088">[BIICORE-T01-R088]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R089">[BIICORE-T01-R089]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R090">[BIICORE-T01-R090]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R091">[BIICORE-T01-R091]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R092">[BIICORE-T01-R092]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R093">[BIICORE-T01-R093]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R094">[BIICORE-T01-R094]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R095">[BIICORE-T01-R095]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R096">[BIICORE-T01-R096]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R097">[BIICORE-T01-R097]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R098">[BIICORE-T01-R098]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R099">[BIICORE-T01-R099]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R100">[BIICORE-T01-R100]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R101">[BIICORE-T01-R101]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R102">[BIICORE-T01-R102]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R103">[BIICORE-T01-R103]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R104">[BIICORE-T01-R104]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R105">[BIICORE-T01-R105]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R106">[BIICORE-T01-R106]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R107">[BIICORE-T01-R107]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R108">[BIICORE-T01-R108]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R109">[BIICORE-T01-R109]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R110">[BIICORE-T01-R110]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R111">[BIICORE-T01-R111]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R112">[BIICORE-T01-R112]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R113">[BIICORE-T01-R113]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R114">[BIICORE-T01-R114]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R115">[BIICORE-T01-R115]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R116">[BIICORE-T01-R116]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R117">[BIICORE-T01-R117]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R118">[BIICORE-T01-R118]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R119">[BIICORE-T01-R119]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R120">[BIICORE-T01-R120]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R121">[BIICORE-T01-R121]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R122">[BIICORE-T01-R122]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R123">[BIICORE-T01-R123]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R124">[BIICORE-T01-R124]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R125">[BIICORE-T01-R125]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R126">[BIICORE-T01-R126]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R127">[BIICORE-T01-R127]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R128">[BIICORE-T01-R128]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R129">[BIICORE-T01-R129]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R130">[BIICORE-T01-R130]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R131">[BIICORE-T01-R131]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R132">[BIICORE-T01-R132]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R133">[BIICORE-T01-R133]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R134">[BIICORE-T01-R134]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R135">[BIICORE-T01-R135]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R136">[BIICORE-T01-R136]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R137">[BIICORE-T01-R137]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R138">[BIICORE-T01-R138]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R139">[BIICORE-T01-R139]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R140">[BIICORE-T01-R140]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R141">[BIICORE-T01-R141]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R142">[BIICORE-T01-R142]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R143">[BIICORE-T01-R143]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R144">[BIICORE-T01-R144]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R145">[BIICORE-T01-R145]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R146">[BIICORE-T01-R146]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R147">[BIICORE-T01-R147]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R148">[BIICORE-T01-R148]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R149">[BIICORE-T01-R149]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R150">[BIICORE-T01-R150]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R151">[BIICORE-T01-R151]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R152">[BIICORE-T01-R152]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R153">[BIICORE-T01-R153]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R154">[BIICORE-T01-R154]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R155">[BIICORE-T01-R155]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R156">[BIICORE-T01-R156]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R157">[BIICORE-T01-R157]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R158">[BIICORE-T01-R158]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R159">[BIICORE-T01-R159]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R160">[BIICORE-T01-R160]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R161">[BIICORE-T01-R161]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R162">[BIICORE-T01-R162]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R163">[BIICORE-T01-R163]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R164">[BIICORE-T01-R164]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R165">[BIICORE-T01-R165]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R166">[BIICORE-T01-R166]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R167">[BIICORE-T01-R167]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R168">[BIICORE-T01-R168]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R169">[BIICORE-T01-R169]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R170">[BIICORE-T01-R170]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R171">[BIICORE-T01-R171]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R172">[BIICORE-T01-R172]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R173">[BIICORE-T01-R173]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R174">[BIICORE-T01-R174]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R175">[BIICORE-T01-R175]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R176">[BIICORE-T01-R176]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R177">[BIICORE-T01-R177]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R178">[BIICORE-T01-R178]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R179">[BIICORE-T01-R179]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R180">[BIICORE-T01-R180]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R181">[BIICORE-T01-R181]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R182">[BIICORE-T01-R182]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R183">[BIICORE-T01-R183]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R184">[BIICORE-T01-R184]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R185">[BIICORE-T01-R185]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R186">[BIICORE-T01-R186]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R187">[BIICORE-T01-R187]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R188">[BIICORE-T01-R188]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R189">[BIICORE-T01-R189]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R190">[BIICORE-T01-R190]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R191">[BIICORE-T01-R191]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R192">[BIICORE-T01-R192]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R193">[BIICORE-T01-R193]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R194">[BIICORE-T01-R194]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R195">[BIICORE-T01-R195]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R196">[BIICORE-T01-R196]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R197">[BIICORE-T01-R197]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R198">[BIICORE-T01-R198]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R199">[BIICORE-T01-R199]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R200">[BIICORE-T01-R200]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R201">[BIICORE-T01-R201]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R202">[BIICORE-T01-R202]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R203">[BIICORE-T01-R203]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R204">[BIICORE-T01-R204]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R205">[BIICORE-T01-R205]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R206">[BIICORE-T01-R206]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R207">[BIICORE-T01-R207]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R208">[BIICORE-T01-R208]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R209">[BIICORE-T01-R209]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R210">[BIICORE-T01-R210]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R211">[BIICORE-T01-R211]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R212">[BIICORE-T01-R212]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R213">[BIICORE-T01-R213]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R214">[BIICORE-T01-R214]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R215">[BIICORE-T01-R215]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R216">[BIICORE-T01-R216]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R217">[BIICORE-T01-R217]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R218">[BIICORE-T01-R218]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R219">[BIICORE-T01-R219]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R220">[BIICORE-T01-R220]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R221">[BIICORE-T01-R221]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R222">[BIICORE-T01-R222]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R223">[BIICORE-T01-R223]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R224">[BIICORE-T01-R224]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R225">[BIICORE-T01-R225]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R226">[BIICORE-T01-R226]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R227">[BIICORE-T01-R227]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R228">[BIICORE-T01-R228]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R229">[BIICORE-T01-R229]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R230">[BIICORE-T01-R230]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R231">[BIICORE-T01-R231]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R232">[BIICORE-T01-R232]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R233">[BIICORE-T01-R233]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R234">[BIICORE-T01-R234]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R235">[BIICORE-T01-R235]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R236">[BIICORE-T01-R236]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R237">[BIICORE-T01-R237]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R238">[BIICORE-T01-R238]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R239">[BIICORE-T01-R239]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R240">[BIICORE-T01-R240]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R241">[BIICORE-T01-R241]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R242">[BIICORE-T01-R242]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R243">[BIICORE-T01-R243]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R244">[BIICORE-T01-R244]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R245">[BIICORE-T01-R245]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R246">[BIICORE-T01-R246]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R247">[BIICORE-T01-R247]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R248">[BIICORE-T01-R248]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R249">[BIICORE-T01-R249]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R250">[BIICORE-T01-R250]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R251">[BIICORE-T01-R251]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R252">[BIICORE-T01-R252]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R253">[BIICORE-T01-R253]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R254">[BIICORE-T01-R254]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R255">[BIICORE-T01-R255]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R256">[BIICORE-T01-R256]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R257">[BIICORE-T01-R257]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R258">[BIICORE-T01-R258]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R259">[BIICORE-T01-R259]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R260">[BIICORE-T01-R260]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R261">[BIICORE-T01-R261]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R262">[BIICORE-T01-R262]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R263">[BIICORE-T01-R263]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R264">[BIICORE-T01-R264]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R265">[BIICORE-T01-R265]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R266">[BIICORE-T01-R266]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R267">[BIICORE-T01-R267]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R268">[BIICORE-T01-R268]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R269">[BIICORE-T01-R269]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R270">[BIICORE-T01-R270]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R271">[BIICORE-T01-R271]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R272">[BIICORE-T01-R272]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R273">[BIICORE-T01-R273]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R274">[BIICORE-T01-R274]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R275">[BIICORE-T01-R275]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R276">[BIICORE-T01-R276]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R277">[BIICORE-T01-R277]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R278">[BIICORE-T01-R278]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R279">[BIICORE-T01-R279]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R280">[BIICORE-T01-R280]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R281">[BIICORE-T01-R281]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R282">[BIICORE-T01-R282]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R283">[BIICORE-T01-R283]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R284">[BIICORE-T01-R284]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R285">[BIICORE-T01-R285]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R286">[BIICORE-T01-R286]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R287">[BIICORE-T01-R287]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R288">[BIICORE-T01-R288]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R289">[BIICORE-T01-R289]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R290">[BIICORE-T01-R290]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R291">[BIICORE-T01-R291]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R292">[BIICORE-T01-R292]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R293">[BIICORE-T01-R293]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R294">[BIICORE-T01-R294]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R295">[BIICORE-T01-R295]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R296">[BIICORE-T01-R296]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R297">[BIICORE-T01-R297]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R298">[BIICORE-T01-R298]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R299">[BIICORE-T01-R299]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R300">[BIICORE-T01-R300]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R301">[BIICORE-T01-R301]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R302">[BIICORE-T01-R302]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R303">[BIICORE-T01-R303]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R304">[BIICORE-T01-R304]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R306">[BIICORE-T01-R306]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R307">[BIICORE-T01-R307]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R308">[BIICORE-T01-R308]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R309">[BIICORE-T01-R309]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R310">[BIICORE-T01-R310]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R311">[BIICORE-T01-R311]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R312">[BIICORE-T01-R312]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R313">[BIICORE-T01-R313]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R314">[BIICORE-T01-R314]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R315">[BIICORE-T01-R315]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R316">[BIICORE-T01-R316]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R317">[BIICORE-T01-R317]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R318">[BIICORE-T01-R318]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R319">[BIICORE-T01-R319]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R320">[BIICORE-T01-R320]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R321">[BIICORE-T01-R321]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R322">[BIICORE-T01-R322]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R323">[BIICORE-T01-R323]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R324">[BIICORE-T01-R324]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R325">[BIICORE-T01-R325]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R326">[BIICORE-T01-R326]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R327">[BIICORE-T01-R327]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R328">[BIICORE-T01-R328]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R329">[BIICORE-T01-R329]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R330">[BIICORE-T01-R330]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R331">[BIICORE-T01-R331]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R332">[BIICORE-T01-R332]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R333">[BIICORE-T01-R333]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R334">[BIICORE-T01-R334]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R335">[BIICORE-T01-R335]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R336">[BIICORE-T01-R336]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R337">[BIICORE-T01-R337]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R338">[BIICORE-T01-R338]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R339">[BIICORE-T01-R339]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R340">[BIICORE-T01-R340]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R341">[BIICORE-T01-R341]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R342">[BIICORE-T01-R342]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R343">[BIICORE-T01-R343]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R344">[BIICORE-T01-R344]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R345">[BIICORE-T01-R345]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R346">[BIICORE-T01-R346]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R347">[BIICORE-T01-R347]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R348">[BIICORE-T01-R348]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R349">[BIICORE-T01-R349]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R350">[BIICORE-T01-R350]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R351">[BIICORE-T01-R351]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R352">[BIICORE-T01-R352]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R353">[BIICORE-T01-R353]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R354">[BIICORE-T01-R354]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R355">[BIICORE-T01-R355]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R356">[BIICORE-T01-R356]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R357">[BIICORE-T01-R357]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R358">[BIICORE-T01-R358]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R359">[BIICORE-T01-R359]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R360">[BIICORE-T01-R360]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R361">[BIICORE-T01-R361]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R362">[BIICORE-T01-R362]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R363">[BIICORE-T01-R363]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R364">[BIICORE-T01-R364]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R365">[BIICORE-T01-R365]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R366">[BIICORE-T01-R366]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R367">[BIICORE-T01-R367]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R368">[BIICORE-T01-R368]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R369">[BIICORE-T01-R369]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R370">[BIICORE-T01-R370]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R371">[BIICORE-T01-R371]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R372">[BIICORE-T01-R372]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R373">[BIICORE-T01-R373]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R374">[BIICORE-T01-R374]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R375">[BIICORE-T01-R375]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R376">[BIICORE-T01-R376]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R377">[BIICORE-T01-R377]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R378">[BIICORE-T01-R378]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R379">[BIICORE-T01-R379]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R380">[BIICORE-T01-R380]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R381">[BIICORE-T01-R381]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R382">[BIICORE-T01-R382]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R383">[BIICORE-T01-R383]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R384">[BIICORE-T01-R384]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R385">[BIICORE-T01-R385]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R386">[BIICORE-T01-R386]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R387">[BIICORE-T01-R387]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R388">[BIICORE-T01-R388]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R389">[BIICORE-T01-R389]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R390">[BIICORE-T01-R390]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R391">[BIICORE-T01-R391]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R392">[BIICORE-T01-R392]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R393">[BIICORE-T01-R393]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R394">[BIICORE-T01-R394]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R395">[BIICORE-T01-R395]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R396">[BIICORE-T01-R396]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R397">[BIICORE-T01-R397]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R398">[BIICORE-T01-R398]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R399">[BIICORE-T01-R399]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R400">[BIICORE-T01-R400]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R401">[BIICORE-T01-R401]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R402">[BIICORE-T01-R402]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R403">[BIICORE-T01-R403]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R404">[BIICORE-T01-R404]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R405">[BIICORE-T01-R405]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R406">[BIICORE-T01-R406]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R407">[BIICORE-T01-R407]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R408">[BIICORE-T01-R408]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R409">[BIICORE-T01-R409]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R410">[BIICORE-T01-R410]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R411">[BIICORE-T01-R411]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R412">[BIICORE-T01-R412]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R413">[BIICORE-T01-R413]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R414">[BIICORE-T01-R414]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R415">[BIICORE-T01-R415]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R416">[BIICORE-T01-R416]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R417">[BIICORE-T01-R417]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R418">[BIICORE-T01-R418]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R419">[BIICORE-T01-R419]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R420">[BIICORE-T01-R420]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R421">[BIICORE-T01-R421]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R422">[BIICORE-T01-R422]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R423">[BIICORE-T01-R423]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R424">[BIICORE-T01-R424]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R425">[BIICORE-T01-R425]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R425">[BIICORE-T01-R425]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R427">[BIICORE-T01-R427]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R428">[BIICORE-T01-R428]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R429">[BIICORE-T01-R429]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R430">[BIICORE-T01-R430]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R431">[BIICORE-T01-R431]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R432">[BIICORE-T01-R432]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R433">[BIICORE-T01-R433]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R434">[BIICORE-T01-R434]-A conformant CEN BII Order core data model SHOULD not have data elements not in the core.</assert>
    <assert flag="warning" test="$BIICORE-T01-R444">[BIICORE-T01-R444]-Element &#39;Note&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R445">[BIICORE-T01-R445]-Element &#39;Validity Period&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R446">[BIICORE-T01-R446]-Element &#39;Order Document Reference&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R447">[BIICORE-T01-R447]-Element &#39;Contract&#39; may occur at maximum 1 times.</assert>
    <assert flag="warning" test="$BIICORE-T01-R448">[BIICORE-T01-R448]-Element &#39;Delivery&#39; may occur at maximum 1 times.</assert>
  </rule>
  <rule context="$Delivery_Party">
    <assert flag="warning" test="$BIICORE-T01-R449">[BIICORE-T01-R449]-Element &#39;PartyName&#39; may occur at maximum 1 times</assert>
  </rule>
</pattern>
