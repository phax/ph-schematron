<?xml version="1.0" encoding="UTF-8"?>
<!--

    This work is protected under copyrights held by the members of the
    TOOP Project Consortium as indicated at
    http://wiki.ds.unipi.gr/display/TOOP/Contributors
    (c) 2018-2021. All rights reserved.

    This work is dual licensed under Apache License, Version 2.0
    and the EUPL 1.2.

     = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

     = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

    Licensed under the EUPL, Version 1.2 or – as soon they will be approved
    by the European Commission - subsequent versions of the EUPL
    (the "Licence");
    You may not use this work except in compliance with the Licence.
    You may obtain a copy of the Licence at:

            https://joinup.ec.europa.eu/software/page/eupl

-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    queryBinding="xslt2" 
    >
    <ns prefix="query"  uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0"/>
    <ns prefix="rim"    uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0"/>
    <ns prefix="cva"    uri="http://www.w3.org/ns/corevocabulary/AggregateComponents"/>
    <ns prefix="cvb"    uri="http://www.w3.org/ns/corevocabulary/BasicComponents"/>
    <ns prefix="cbd"    uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="rs"     uri="urn:oasis:names:tc:ebxml-regrep:xsd:rs:4.0"/>
    <ns prefix="cpov"   uri="http://www.w3.org/ns/corevocabulary/po"/>
    <ns prefix="cagv"   uri="https://semic.org/sa/cv/cagv/agent-2.0.0#"/>
    <ns prefix="cbc"    uri="https://data.europe.eu/semanticassets/ns/cv/common/cbc_v2.0.0#"/> 
    <ns prefix="locn"   uri="http://www.w3.org/ns/locn#"/>
    <ns prefix="cccev"  uri="https://data.europe.eu/semanticassets/ns/cv/cccev_v2.0.0#"/>
    <ns prefix="dcat"   uri="http://data.europa.eu/r5r/"/>
    <ns prefix="dct"    uri="http://purl.org/dc/terms/"/>
    <ns prefix="xsi"    uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0"/>    
    <ns prefix="gc"     uri="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"/>
    
    <title>TOOP EDM Business Rules (specs Version 2.1.0)</title>
    
    
    <!--Check the format of the UUID's-->
    <pattern>
        <rule context="query:QueryRequest/@id | query:QueryResponse/@requestId | query:QueryResponse/rim:ObjectRefList/rim:ObjectRef/@id | query:QueryRequest/query:Query/rim:Slot[@name = 'id']/rim:SlotValue/rim:Value">
            <assert test="matches(normalize-space((.)),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" 
                flag='ERROR' id="br_wrong_uuid_format">
                Rule: The UUID MUST be created following the UUID Version 4 specification. 
                Please check <value-of select="name(.)"/>, found: <value-of select="normalize-space((.))"/> .
            </assert>
        </rule>
    </pattern>
    
    <!--Check the Specification Identifier-->
    <pattern>
        <rule context="query:QueryRequest | query:QueryResponse">
            <assert test="matches(rim:Slot[@name = 'SpecificationIdentifier']/rim:SlotValue/rim:Value/text(),'toop-edm:v2.1')" 
                flag='ERROR' id="br_mandatory_res_specs_id">
                Rule: The message MUST have the specification identifier "toop-edm:v2.1".
            </assert>
        </rule>
    </pattern>
    
       
    <!--Check if an identifier is valid according to the eIDAS specifications-->
    <!--pattern>
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityID[@schemeID='EIDAS']">
            <assert test="matches(normalize-space(text()),'^[a-z]{2}/[a-z]{2}/(.*?)','i')"  
                flag='warning' id="br_wrong_id_format">
                Rule: The uniqueness identifier consists of:
                1. The first part is the Nationality Code of the identifier. This is one of the ISO 3166-1 alpha-2 codes, followed by a slash ("/"))
                2. The second part is the Nationality Code of the destination country or international organization. This is one of the ISO 3166-1 alpha-2 codes, followed by a slash ("/")
                3. The third part a combination of readable characters. This uniquely identifies the identity asserted in the country of origin but does not necessarily reveal any discernible correspondence with the subject's actual identifier (for example, username, fiscal number etc).
                Please check <value-of select="name(.)"/>.
            </assert>
        </rule>
    </pattern-->
    
    
    <!--Check for unique ID's in concepts-->
    <pattern>
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'ConceptRequestList']/rim:SlotValue/rim:Element/cccev:concept">
            <assert test="count(//cbc:id) = count(distinct-values(//cbc:id))"
                flag='ERROR' id="br_request_concept_id_not_unique">
                In a QueryRequest,  two or more concepts can not share the same ID.
            </assert>
        </rule>
    </pattern>
    
    
    <!--Check for unique QNames in same level concepts-->
    <pattern>
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'ConceptRequestList']/rim:SlotValue/rim:Element/cccev:concept">
            <assert test="count(cccev:concept/cbc:qName) = count(distinct-values(cccev:concept/cbc:qName))"
                flag='ERROR' id="br_request_concept_qname_not_unique">
                In a QueryRequest,  two or more concepts at the same level (with a common parent) can not share the same Qname. 
            </assert>
        </rule>
    </pattern>
    
    
    <!--Check if the languageID of an ErrorText is unique in the context of one Error-->  
    <pattern> 
        <rule context="query:QueryResponse/rs:Exception/rim:Slot[@name = 'ErrorText']/rim:SlotValue/rim:Value 
            | query:QueryRequest/rim:Slot[@name = 'Procedure']/rim:SlotValue/rim:Value" 
            flag='ERROR' id='br_check_localizedstring_unique_lang'> 
            <assert test="count(rim:LocalizedString) = count(distinct-values(rim:LocalizedString/@xml:lang))">
                When there are several LocalizedStrings, they all need to have a different language ID. 
            </assert>        
        </rule> 
    </pattern> 
    
    
    <!--Check the uniqueness of alternative Legal Person IDs-->
    <pattern>
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness">
            <assert test="(count(cvb:LegalEntityID/@schemeID) = count (distinct-values(cvb:LegalEntityID/@schemeID)) )" 
                flag='ERROR' id='br_legal_person_scheme_id_not_unique'>
                Each alternative LegaEntityID must have a different schemeID.
            </assert>  
        </rule>
    </pattern>
    
    
    <!--Check the uniqueness of alternative Natural Person IDs-->
    <pattern>
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'NaturalPerson']/rim:SlotValue/cva:CorePerson 
            | query:QueryRequest/query:Query/rim:Slot[@name = 'AuthorizedRepresentative']/rim:SlotValue/cva:CorePerson">
            <assert test="(count(cvb:PersonID/@schemeID) = count (distinct-values(cvb:PersonID/@schemeID)) )" 
                flag='ERROR' id='br_natural_person_scheme_id_not_unique'>
                Each alternative PersonID must have a different schemeID.
            </assert>  
        </rule>
    </pattern>
    
    
    <!--Check the length of the LEI code.-->
    <pattern>
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityID
                     | query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityLegalID">
            <assert test="( (@schemeID = 'LEI') and ( string-length(normalize-space(.)) = 20) or (@schemeID != 'LEI')   )" 
                flag='warning' id='br_invalid_lei_length'>
                The LEI code length should be 20.
            </assert>  
        </rule>
    </pattern>
    
    
    
    <!--***********************-->
    <!--*RULES USING CODELISTS*-->
    <!--***********************-->  
    
    <!--Check codelist for gender-->
    <pattern> 
        <let name="gendertypecodes" value="document('..\codelist\toop\Gender-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'NaturalPerson']/rim:SlotValue/cva:CorePerson/cvb:PersonGenderCode 
            | query:QueryRequest/query:Query/rim:Slot[@name = 'AuthorizedRepresentative']/rim:SlotValue/cva:CorePerson/cvb:PersonGenderCode">
            <assert test="$gendertypecodes/SimpleValue[normalize-space(.) = normalize-space(current()/.)]"
                flag='ERROR' id="br_check_gender_code">
                A gender code must always be specified using the correct code list. 
            </assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for country-->
    <pattern> 
        <let name="countrycodes" value="document('..\codelist\external\CountryIdentificationCode-2.2.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="cva:PersonCoreAddress/cvb:AddressAdminUnitLocationOne 
            | cva:LegalEntityCoreAddress/cvb:AddressAdminUnitLocationOne 
            | query:QueryRequest/rim:Slot[@name = 'DataConsumer']/rim:SlotValue/cagv:Agent/cagv:location/locn:address/locn:adminUnitLevel1"            
            flag='ERROR' id='br_check_country_countrycode'> 
            <assert test="$countrycodes/SimpleValue[normalize-space(.) = normalize-space(current()/.)]">
                The country code must always be specified using the correct code list. Please check <value-of select="name(.)"/>.</assert> 
        </rule> 
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'NaturalPerson']/rim:SlotValue/cva:CorePerson/cvb:PersonID[@schemeID='EIDAS'] 
            | query:QueryRequest/query:Query/rim:Slot[@name = 'AuthorizedRepresentative']/rim:SlotValue/cva:CorePerson/cvb:PersonID[@schemeID='EIDAS']
            | query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityID[@schemeID='EIDAS']
            | query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityLegalID[@schemeID='EIDAS']" 
            flag='warning' id='br_check_id_countrycode'>
            <let name="hasEidasFormat" value="matches(normalize-space(current()/.),'^[a-z]{2}/[a-z]{2}/(.*?)','i')"/> 
            <assert test="( ($countrycodes/SimpleValue[normalize-space(.) = (tokenize(normalize-space(current()/.),'/')[1])]) or ($hasEidasFormat=false()) )">
                If the EIDAS code has the format "XX/YY/12345", the country code in the first part of the identifier must always be specified using the correct code list (found:<value-of select="(tokenize(normalize-space(current()/.),'/')[1])"/>).</assert> 
            <assert test="( ($countrycodes/SimpleValue[normalize-space(.) = (tokenize(normalize-space(current()/.),'/')[2])]) or ($hasEidasFormat=false()) )">
                If the EIDAS code has the format "XX/YY/12345", the country code in the second part of the identifier must always be specified using the correct code list (found:<value-of select="(tokenize(normalize-space(current()/.),'/')[2])"/>).</assert> 
        </rule>
    </pattern> 
    
    <!--Check codelist for mimetype code-->
    <pattern> 
        <let name="mimetypecodes" value="document('..\codelist\external\BinaryObjectMimeCode-2.2.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'DistributionRequestList']/rim:SlotValue/rim:Element/dcat:distribution/dcat:mediaType
            | query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot/rim:SlotValue/dcat:dataset/dcat:distribution/dcat:mediaType" 
            flag='warning' id='br_check_doc_media_type'> 
            <assert test="$mimetypecodes/SimpleValue[normalize-space(.) = normalize-space(current()/.)]">
                A mimetype code SHOULD always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for the attributes of a QueryResponse returning exceptions-->
    <pattern> 
        <let name="errorseveritycodes" value="document('..\codelist\toop\ErrorSeverity-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <let name="errorcodecodes" value="document('..\codelist\toop\ErrorCode-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryResponse/rs:Exception" 
            flag='ERROR'> 
            <assert  id='br_check_error_severity' test="$errorseveritycodes/SimpleValue[normalize-space(.) = normalize-space(current()/@severity)]">
                An error severity code must always be specified using the correct code list.</assert> 
            <assert  id='br_check_error_code' test="$errorcodecodes/SimpleValue[normalize-space(.) = normalize-space(current()/@code)]">
                An error code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for error origin in a QueryResponse returning exceptions-->
    <pattern> 
        <let name="errororigincodes" value="document('..\codelist\toop\ErrorOrigin-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryResponse/rs:Exception/rim:Slot[@name = 'ErrorOrigin']/rim:SlotValue/rim:Value" 
            flag='ERROR' id='br_check_error_origin'> 
            <assert test="$errororigincodes/SimpleValue[normalize-space(.) = normalize-space(current()/.)]">
                An error origin code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for distribution format-->
    <pattern> 
        <let name="distributionformatcodes" value="document('..\codelist\toop\DistributionFormat-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'DistributionRequestList']/rim:SlotValue/rim:Element/dcat:distribution/dct:format"
            flag='ERROR' id='br_check_distribution_format'> 
            <assert test="$distributionformatcodes/SimpleValue[normalize-space(.) = normalize-space(current()/.)]">
                A distribution format code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for query definition-->
    <pattern> 
        <let name="querydefinitions" value="document('..\codelist\toop\QueryDefinition-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryRequest/query:Query" 
            flag='ERROR' id='br_check_query_definition' > 
            <assert test="$querydefinitions/SimpleValue[normalize-space(.) = normalize-space(current()/@queryDefinition)]">A query definition code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for currency-->
    <pattern> 
        <let name="currencytypecodes" value="document('..\codelist\external\CurrencyCode-2.2.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name = 'ConceptValues']/rim:SlotValue/rim:Element//cccev:concept/cccev:value/cccev:amountValue" 
            flag='ERROR' id='br_check_currency_code'> 
            <assert test="$currencytypecodes/SimpleValue[normalize-space(.) = normalize-space(current()/@currencyID)]">
                A currency type code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for language-->
    <pattern> 
        <let name="languagecodes" value="document('..\codelist\external\LanguageCode-2.2.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='DocumentMetadata']/rim:SlotValue/dcat:dataset/dct:language
                     | query:QueryRequest/rim:Slot[@name='Procedure']/rim:SlotValue/rim:Value/rim:LocalizedString/@xml:lang
                     | query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot/rim:SlotValue/dcat:dataset/dcat:distribution/dcat:description/@languageID
                     "
            flag='ERROR' id='br_check_language_code'> 
            <assert test="$languagecodes/SimpleValue[normalize-space(.) = normalize-space(current()/.)]">A language code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 


    <!--Check codelist for data element response error code-->
    <pattern> 
        <let name="dataelementresponseerrorcodes" value="document('..\codelist\toop\DataElementResponseErrorCode-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name = 'ConceptValues']/rim:SlotValue/rim:Element//cccev:concept/cccev:value/cccev:error"> 
            <assert test="$dataelementresponseerrorcodes/SimpleValue[normalize-space(.) = normalize-space(current()/.)]"
                flag='warning' id='br_check_error_data_element_response'>
                An error code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for standard industrial class code-->
    <pattern> 
        <let name="industrialtypecodes" value="document('..\codelist\toop\StandardIndustrialClassCode-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityID
                     | query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityLegalID">
            <assert test="( (@schemeID = 'SIC') and ($industrialtypecodes/SimpleValue[normalize-space(.) = normalize-space(current()/.)]) or (@schemeID != 'SIC') )"
                flag='warning' id='br_check_sic_code'>
                A standard industrial classification code should always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for protocol exceptions-->
    <pattern> 
        <let name="procotolexceptioncodes" value="document('..\codelist\toop\ProcotolException-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryResponse/rs:Exception"> 
            <let name="datatype" value="@*[ends-with(name(.), ':type') and . != '']"/>
            <assert test="$procotolexceptioncodes/SimpleValue[normalize-space(.) = normalize-space(substring-after($datatype,':'))]"
                flag='ERROR' id='br_check_error_protocol_exception'>
                A protocol exception code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    
    <!--Check codelist for identifier type-->
    <pattern> 
        <let name="identifiertypecodes" value="document('..\codelist\toop\IdentifierType-CodeList.gc')/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code']" />
        <rule context="query:QueryRequest/query:Query/rim:Slot[@name = 'NaturalPerson']/rim:SlotValue/cva:CorePerson/cvb:PersonID 
            | query:QueryRequest/query:Query/rim:Slot[@name = 'AuthorizedRepresentative']/rim:SlotValue/cva:CorePerson/cvb:PersonID
            | query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityID
            | query:QueryRequest/query:Query/rim:Slot[@name = 'LegalPerson']/rim:SlotValue/cva:CoreBusiness/cvb:LegalEntityLegalID" 
            > 
            <assert test="$identifiertypecodes/SimpleValue[normalize-space(.) = normalize-space(current()/@schemeID)]"
                flag='warning' id='br_check_identifier_code'>
                An identifier type code SHOULD always be specified using the correct code list. 
            </assert> 
            <!--TODO: check the final business rule for preferred VAT/EIDAS id's -->            
            <!--assert test="normalize-space(current()/@schemeID) = 'VATRegistration'"
                flag='warning' id='br_suggested_vat_id'>
                The preferred identifier SHOULD be the national VAT Number (schemeid 'VATRegistration'). 
            </assert--> 
        </rule> 
    </pattern> 

    
</schema>