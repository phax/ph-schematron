<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:UBL="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" queryBinding="xslt2">
    <title>urn_feap.gov.pt_CIUS-PT_1.0.6</title>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
    <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
    <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
    <include href="abstract/urn_feap.gov.pt_CIUS-PT_1.0.6-syntax.sch"/>
    <include href="abstract/urn_feap.gov.pt_CIUS-PT_1.0.6-model.sch"/>
    <include href="UBL/urn_feap.gov.pt_CIUS-PT_1.0.6-UBL-syntax.sch"/>
    <include href="UBL/urn_feap.gov.pt_CIUS-PT_1.0.6-UBL-model.sch"/>
    <phase id="syntax-model_phase">
        <active pattern="UBL-syntax"/>
        <active pattern="UBL-model"/>
    </phase>
    <include href="datatype/urn_feap.gov.pt_CIUS-PT_1.0.6-UBL-datatype.sch"/>
	<phase id="datatype_phase">
		<active pattern="UBL-datatype"/>
    </phase>
    <include href="abstract/urn_feap.gov.pt_CIUS-PT_1.0.6-condition.sch"/>
    <include href="UBL/urn_feap.gov.pt_CIUS-PT_1.0.6-UBL-condition.sch"/>
    <phase id="condition_phase">
        <active pattern="UBL-condition"/>
    </phase>
	<phase id="all_phase">
        <active pattern="UBL-syntax"/>
        <active pattern="UBL-model"/>
		<active pattern="UBL-datatype"/>
        <active pattern="UBL-condition"/>
    </phase>
</schema>
