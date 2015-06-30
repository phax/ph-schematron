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
<!--Abstract Schematron rules for T03-->
<pattern abstract="true" id="T03" xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule context="$Customer">
    <assert flag="fatal" test="$BIIRULE-T03-R006">[BIIRULE-T03-R006]-An order response  MUST contain the full name of the customer.</assert>
  </rule>
  <rule context="$Order_Response_Note">
    <assert flag="warning" test="$BIIRULE-T03-R005">[BIIRULE-T03-R005]-Language SHOULD be defined for note field</assert>
  </rule>
  <rule context="$Supplier">
    <assert flag="fatal" test="$BIIRULE-T03-R007">[BIIRULE-T03-R007]-An order response  MUST contain the full name of the supplier.</assert>
  </rule>
  <rule context="$Order_Response">
    <assert flag="fatal" test="$BIIRULE-T03-R001">[BIIRULE-T03-R001]-A conformant CEN BII order response core data model MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T03-R002">[BIIRULE-T03-R002]-A conformant CEN BII order response  core data model MUST have a syntax identifier.</assert>
    <assert flag="fatal" test="$BIIRULE-T03-R003">[BIIRULE-T03-R003]-A conformant CEN BII order response  core data model MUST have a profile identifier.</assert>
    <assert flag="warning" test="$BIIRULE-T03-R004">[BIIRULE-T03-R004]-Only one note field must be specified </assert>
  </rule>
</pattern>
