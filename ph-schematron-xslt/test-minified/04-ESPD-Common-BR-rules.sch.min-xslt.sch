<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <title>Common Business Rules assertions</title>
  
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
	<ns prefix="ccv-cbc" uri="urn:isa:names:specification:ubl:schema:xsd:CCV-CommonBasicComponents-1" />
	<ns prefix="cev-cbc" uri="urn:isa:names:specification:ubl:schema:xsd:CEV-CommonBasicComponents-1" />
	<ns prefix="cev" uri="urn:isa:names:specification:ubl:schema:xsd:CEV-CommonAggregateComponents-1" />
	<ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
	<ns prefix="ccv" uri="urn:isa:names:specification:ubl:schema:xsd:CCV-CommonAggregateComponents-1" />
	<ns prefix="espd-req" uri="urn:grow:names:specification:ubl:schema:xsd:ESPDRequest-1" />
	<ns prefix="gc" uri="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" />
  
  <pattern id="common-br-rules">



	
	<rule context="/espd-req:ESPDRequest/cac:ProcurementProjectLot">
		<assert test="( not(cbc:ID!='0') )">The current version of the ESPD Service does not allow for the specification of multiple lots. To ensure conformace with the current version of the ESPD Service the ID sub-element inside the element ProcurementProjectLot MUST be 0 (zero).</assert>
	</rule>

	
	
	<ns0:variable xmlns:ns0="http://www.w3.org/1999/XSL/Transform" name="TypeCodeExclusion" select="/espd-req:ESPDRequest/ccv:Criterion/cbc:TypeCode[starts-with(., 'CRITERION.EXCLUSION.')]" />
	<rule context="/espd-req:ESPDRequest">
		
		
		<assert test="( not(string(cbc:ID))=false() )">The element 'espd-req:ESPDRequest / cbc:ID' is mandatory </assert>
		
		<assert test="( not(string(cbc:IssueDate))=false() )">The element 'espd-req:ESPDRequest / cbc:IssueDate' is mandatory </assert>
		
		
		
		
		
		<assert test="count( cac:AdditionalDocumentReference ) > 0">The ESPDRequest MUST always contain one 'AdditionalDocumentReference' element referring to the Contract Notice (CN) published in TeD (Publications Office). </assert>
	</rule>
	
	
	<rule context="/espd-req:ESPDRequest/ccv:Criterion">
		
		<assert test="( not(string(cbc:ID))=false() )">The element 'cbc:ID' is mandatory </assert>

		<assert test="( not(string(cbc:Name))=false() )">The element 'cbc:Name' is mandatory </assert>
		
		<assert test="( not(string(cbc:Description))=false() )">The element 'cbc:Description' is mandatory </assert>
		
		<assert test="( not(string(cbc:TypeCode))=false() )">The element 'cbc:TypeCode' is mandatory </assert>
		
		
		<assert test="not( (count(ccv:LegislationReference) = 0) and (contains(cbc:TypeCode, 'CRITERION.EXCLUSION.'))  )">All Exclusion Criteria MUST provide a value for the element LegislationReference </assert>
	</rule>

	
	<rule context="/espd-req:ESPDRequest/ccv:Criterion/ccv:RequirementGroup">
		
		<assert test="( not(string(cbc:ID))=false() )">The element 'cbc:ID' is mandatory </assert>
	</rule>

	
	<rule context="/espd-req:ESPDRequest/ccv:Criterion/ccv:RequirementGroup/ccv:Requirement">
		
		<assert test="( not(string(cbc:Description))=false() )">The element 'cbc:Description' is mandatory </assert>
		
		<assert test="( not(string(cbc:ID))=false() )">The element 'cbc:ID' is mandatory </assert>
		
		
		<assert test="( not(string(@responseDataType))=false() )">The attribute 'responseDataType' is mandatory </assert>
	</rule>

	
	<rule context="/espd-req:ESPDRequest/ccv:Criterion/ccv:LegislationReference">
		
		<assert test="( not(string(cbc:URI))=false() )">The element 'ccv-cbc:URI' is mandatory </assert>
		
		<assert test="( not(string(ccv-cbc:Article))=false() )">The element 'ccv-cbc:Article' is mandatory </assert>
		
		<assert test="( not(string(ccv-cbc:JurisdictionLevelCode))=false() )">The element 'ccv-cbc:JurisdictionLevelCode' is mandatory </assert>
		
		<assert test="( not(string(ccv-cbc:Title))=false() )">The element 'ccv-cbc:Title' is mandatory </assert>
		
		<assert test="( not(string(cbc:Description))=false() )">The element 'cbc:Description' is mandatory </assert>		
	</rule>
	
	
	<rule context="ccv:RequirementGroup/cbc:ID | ccv:RequirementGroup/ccv:Requirement/cbc:ID">
		<assert test="( not(@schemeAgencyID!='EU-COM-GROW') )">The value of the attribute 'schemeAgencyID' must be 'EU-COM-GROW' </assert>
		<assert test="( not(@schemeID!='CriterionRelatedIDs') )">The value of the attribute 'schemeID' must be 'CriterionRelatedIDs' </assert>
		<assert test="( not(@schemeVersionID!='1.0') )">The value of the attribute 'schemeVersionID' must be '1.0' </assert>
	</rule>
	
	
	<rule context="ccv:Criterion/cbc:ID">
		<assert test="( not(@schemeAgencyID!='EU-COM-GROW') )">The value of the attribute 'schemeAgencyID' must be 'EU-COM-GROW' </assert>
	</rule>
	
	
	<rule context="/espd-req:ESPDRequest/cac:AdditionalDocumentReference">
		
		<assert test="( not(string(cbc:ID))=false() )">The AdditionalDocumentReference referring to the CN published in TeD MUST use the element ID to identify the CN. </assert>
		
		
		<assert test="(count(cbc:ID)=0) or not(cbc:DocumentTypeCode/text() = 'TED_CN') or ((count(cbc:ID))=1 and (string-length(cbc:ID)=17 and substring(cbc:ID,5,3)='/S ' and substring(cbc:ID,11,1)='-'))">The value of the ID MUST follow the pattern YYYY/S DDD-DDDDDD, where 'YYYY' is a year, '/S' is a constant label, and 'D' represent digits. Beware of the existence of a space (a blank) between the 'S' and the first 'D'. </assert>
	</rule>
</pattern>
</schema>
