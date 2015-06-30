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
  <rule context="$Supplier">
    <assert flag="fatal" test="$ATGOV-T10-R001">[ATGOV-T10-R001]-The email address of the biller is mandatory</assert>
  </rule>
  <rule context="$Invoice">
    <assert flag="fatal" test="$ATGOV-T10-R002">[ATGOV-T10-R002]-A maximum number of 999 invoice lines must be present</assert>
    <assert flag="fatal" test="$ATGOV-T10-R003">[ATGOV-T10-R003]-The order number must be present</assert>
    <assert flag="warning" test="$ATGOV-T10-R004">[ATGOV-T10-R004]-An invoice should not specify textual payment terms</assert>
    <assert flag="warning" test="$ATGOV-T10-R005">[ATGOV-T10-R005]-Exactly 1 beneficiary account may be present</assert>
    <assert flag="fatal" test="$ATGOV-T10-R006">[ATGOV-T10-R006]-The &quot;Buchungskreis&quot; (accounting area code) must be present</assert>
  </rule>
  <rule context="$Payment_Means">
    <assert flag="fatal" test="$ATGOV-T10-R007">[ATGOV-T10-R007]-Only BIC and IBAN are allowed as beneficiary account information</assert>
  </rule>
  <rule context="$Invoice_Line">
    <assert flag="fatal" test="$ATGOV-T10-R008">[ATGOV-T10-R008]-The order position number (per line item) must be present</assert>
  </rule>
</pattern>
