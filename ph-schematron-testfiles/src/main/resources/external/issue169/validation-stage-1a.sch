<?xml version="1.0" encoding="UTF-8"?>
<pattern id="EFORMS-validation-stage-1a" xmlns="http://purl.oclc.org/dsdl/schematron">
	<rule context="/*">
		<assert id="P-0001" role="ERROR" test="count(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode) &gt; 0">
			rule|text|P-0001
		</assert>
		<assert id="P-0002" role="ERROR" test="(cbc:NoticeTypeCode/text() = ('pin-buyer', 'brin-eeig', 'brin-ecs') and count(cac:ProcurementProjectLot) = 0) or (not(cbc:NoticeTypeCode/text() = ('pin-buyer', 'brin-eeig', 'brin-ecs')) and count(cac:ProcurementProjectLot) > 0)">
			rule|text|P-0002
		</assert>
	</rule>
	<rule context="cac:ProcurementProjectLot/cbc:ID">
		<assert id="P-0004" role="ERROR" test="@schemeName">
			rule|text|P-0004
		</assert>
	</rule>
	<rule context="cac:ProcurementProjectLot/cbc:ID/@schemeName">
		<assert id="P-0005" role="ERROR" test="normalize-space(.) = ('Part', 'Lot', 'LotsGroup')">
			rule|text|P-0005
		</assert>
	</rule>
	<rule context="cbc:ActivityTypeCode">
		<assert id="P-0006" role="ERROR" test="@listName">
			rule|text|P-0006
		</assert>
	</rule>
	<rule context="cbc:AwardingCriterionTypeCode">
		<assert id="P-0007" role="ERROR" test="@listName">
			rule|text|P-0007
		</assert>
	</rule>
	<rule context="cbc:CalculationExpressionCode">
		<assert id="P-0008" role="ERROR" test="@listName">
			rule|text|P-0008
		</assert>
	</rule>
	<rule context="cbc:Code">
		<assert id="P-0009" role="ERROR" test="@listName">
			rule|text|P-0009
		</assert>
	</rule>
	<rule context="cbc:ContractingSystemTypeCode">
		<assert id="P-0010" role="ERROR" test="@listName">
			rule|text|P-0010
		</assert>
	</rule>
	<rule context="cbc:CountrySubentityCode">
		<assert id="P-0011" role="ERROR" test="@listName">
			rule|text|P-0011
		</assert>
	</rule>
	<rule context="cbc:CriterionTypeCode">
		<assert id="P-0012" role="ERROR" test="@listName">
			rule|text|P-0012
		</assert>
	</rule>
	<rule context="cbc:DescriptionCode">
		<assert id="P-0013" role="ERROR" test="@listName">
			rule|text|P-0013
		</assert>
	</rule>
	<rule context="cbc:DocumentTypeCode">
		<assert id="P-0014" role="ERROR" test="@listName">
			rule|text|P-0014
		</assert>
	</rule>
	<rule context="cbc:ExecutionRequirementCode">
		<assert id="P-0015" role="ERROR" test="@listName">
			rule|text|P-0015
		</assert>
	</rule>
	<rule context="cbc:FundingProgramCode">
		<assert id="P-0016" role="ERROR" test="@listName">
			rule|text|P-0016
		</assert>
	</rule>
	<rule context="cbc:GuaranteeTypeCode">
		<assert id="P-0017" role="ERROR" test="@listName">
			rule|text|P-0017
		</assert>
	</rule>
	<rule context="cbc:IndustryClassificationCode">
		<assert id="P-0018" role="ERROR" test="@listName">
			rule|text|P-0018
		</assert>
	</rule>
	<rule context="cbc:ItemClassificationCode">
		<assert id="P-0019" role="ERROR" test="@listName">
			rule|text|P-0019
		</assert>
	</rule>
	<rule context="cbc:NoticeTypeCode">
		<assert id="P-0020" role="ERROR" test="@listName">
			rule|text|P-0020
		</assert>
	</rule>
	<rule context="cbc:PartPresentationCode">
		<assert id="P-0021" role="ERROR" test="@listName">
			rule|text|P-0021
		</assert>
	</rule>
	<rule context="cbc:PartyTypeCode">
		<assert id="P-0022" role="ERROR" test="@listName">
			rule|text|P-0022
		</assert>
	</rule>
	<rule context="cbc:ProcedureCode">
		<assert id="P-0023" role="ERROR" test="@listName">
			rule|text|P-0023
		</assert>
	</rule>
	<rule context="cbc:ProcessReasonCode">
		<assert id="P-0024" role="ERROR" test="@listName">
			rule|text|P-0024
		</assert>
	</rule>
	<rule context="cbc:ProcurementTypeCode">
		<assert id="P-0025" role="ERROR" test="@listName">
			rule|text|P-0025
		</assert>
	</rule>
	<rule context="cbc:RequiredCurriculaCode">
		<assert id="P-0026" role="ERROR" test="@listName">
			rule|text|P-0026
		</assert>
	</rule>
	<rule context="cbc:SubcontractingConditionsCode">
		<assert id="P-0027" role="ERROR" test="@listName">
			rule|text|P-0027
		</assert>
	</rule>
	<rule context="cbc:SubmissionMethodCode">
		<assert id="P-0028" role="ERROR" test="@listName">
			rule|text|P-0028
		</assert>
	</rule>
	<rule context="cbc:TendererRequirementTypeCode">
		<assert id="P-0029" role="ERROR" test="@listName">
			rule|text|P-0029
		</assert>
	</rule>
	<rule context="cbc:TenderResultCode">
		<assert id="P-0030" role="ERROR" test="@listName">
			rule|text|P-0030
		</assert>
	</rule>
	<rule context="cbc:VariantConstraintCode">
		<assert id="P-0031" role="ERROR" test="@listName">
			rule|text|P-0031
		</assert>
	</rule>
	<rule context="cbc:ReasonCode">
		<assert id="P-0032" role="ERROR" test="@listName">
			rule|text|P-0032
		</assert>
	</rule>
	<rule context="efbc:StatisticsCode">
		<assert id="P-0033" role="ERROR" test="@listName">
			rule|text|P-0033
		</assert>
	</rule>
</pattern>
