<?xml version="1.0" encoding="UTF-8" ?>
<!--File generated from metadata database version 1.0.0 created on the 2022-08-05T10:24:40.-->
<pattern id="EFORMS-validation-stage-2b" xmlns="http://purl.oclc.org/dsdl/schematron">
	<rule context="/*">
		<assert id="BT-01-notice_R" role="ERROR" diagnostics="BT-01-notice" test="count(cbc:RegulatoryDomain) &lt; 2">rule|text|BT-01-notice_R</assert>
		<assert id="BT-02-notice_R" role="ERROR" diagnostics="BT-02-notice" test="count(cbc:NoticeTypeCode) &lt; 2">rule|text|BT-02-notice_R</assert>
		<assert id="BT-03-notice_R" role="ERROR" diagnostics="BT-03-notice" test="count(cbc:NoticeTypeCode/@listName) &lt; 2">rule|text|BT-03-notice_R</assert>
		<assert id="BT-04-notice_R" role="ERROR" diagnostics="BT-04-notice" test="count(cbc:ContractFolderID) &lt; 2">rule|text|BT-04-notice_R</assert>
		<assert id="BT-05_a_-notice_R" role="ERROR" diagnostics="BT-05_a_-notice" test="count(cbc:IssueDate) &lt; 2">rule|text|BT-05_a_-notice_R</assert>
		<assert id="BT-05_b_-notice_R" role="ERROR" diagnostics="BT-05_b_-notice" test="count(cbc:IssueTime) &lt; 2">rule|text|BT-05_b_-notice_R</assert>
		<assert id="BT-127-notice_R" role="ERROR" diagnostics="BT-127-notice" test="count(cbc:PlannedDate) &lt; 2">rule|text|BT-127-notice_R</assert>
		<assert id="BT-701-notice_R" role="ERROR" diagnostics="BT-701-notice" test="count(cbc:ID[@schemeName='notice-id']) &lt; 2">rule|text|BT-701-notice_R</assert>
		<assert id="BT-702_a_-notice_R" role="ERROR" diagnostics="BT-702_a_-notice" test="count(cbc:NoticeLanguageCode) &lt; 2">rule|text|BT-702_a_-notice_R</assert>
		<assert id="BT-738-notice_R" role="ERROR" diagnostics="BT-738-notice" test="count(cbc:RequestedPublicationDate) &lt; 2">rule|text|BT-738-notice_R</assert>
		<assert id="BT-757-notice_R" role="ERROR" diagnostics="BT-757-notice" test="count(cbc:VersionID) &lt; 2">rule|text|BT-757-notice_R</assert>
		<assert id="OPP-130-Business_A" role="ERROR" diagnostics="OPP-130-Business" test="count(cbc:Note[@languageID = preceding-sibling::cbc:Note/@languageID]) = 0">rule|text|OPP-130-Business_A</assert>
		<assert id="OPP-130-Business_B" role="ERROR" diagnostics="OPP-130-Business" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Note/@languageID = $lg) or count(cbc:Note) = 0">rule|text|OPP-130-Business_B</assert>
		<assert id="OPP-130-Business_C" role="ERROR" diagnostics="OPP-130-Business" test="(every $lg in (cbc:Note/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Note) = 0">rule|text|OPP-130-Business_C</assert>
		<assert id="OPT-001-notice_R" role="ERROR" diagnostics="OPT-001-notice" test="count(cbc:UBLVersionID) &lt; 2">rule|text|OPT-001-notice_R</assert>
		<assert id="OPT-002-notice_R" role="ERROR" diagnostics="OPT-002-notice" test="count(cbc:CustomizationID) &lt; 2">rule|text|OPT-002-notice_R</assert>
		<assert id="OPT-999_R" role="ERROR" diagnostics="OPT-999" test="count(cac:TenderResult/cbc:AwardDate) &lt; 2">rule|text|OPT-999_R</assert>
	</rule>
	<rule context="/*/cac:AdditionalDocumentReference">
		<assert id="OPP-120-Business_R" role="ERROR" diagnostics="OPP-120-Business" test="count(cbc:DocumentDescription) &lt; 2">rule|text|OPP-120-Business_R</assert>
		<assert id="OPP-121-Business_R" role="ERROR" diagnostics="OPP-121-Business" test="count(cbc:ReferencedDocumentInternalAddress) &lt; 2">rule|text|OPP-121-Business_R</assert>
		<assert id="OPP-122-Business_R" role="ERROR" diagnostics="OPP-122-Business" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|OPP-122-Business_R</assert>
		<assert id="OPP-123-Business_R" role="ERROR" diagnostics="OPP-123-Business" test="count(cbc:IssueDate) &lt; 2">rule|text|OPP-123-Business_R</assert>
	</rule>
	<rule context="/*/cac:BusinessParty">
		<assert id="BT-501-Business-European_R" role="ERROR" diagnostics="BT-501-Business-European" test="count(cac:PartyLegalEntity/cbc:CompanyID[@schemeName = 'EU']) &lt; 2">rule|text|BT-501-Business-European_R</assert>
		<assert id="BT-501-Business-National_R" role="ERROR" diagnostics="BT-501-Business-National" test="count(cac:PartyLegalEntity/cbc:CompanyID[not(@schemeName = 'EU')]) &lt; 2">rule|text|BT-501-Business-National_R</assert>
		<assert id="BT-505-Business_R" role="ERROR" diagnostics="BT-505-Business" test="count(cbc:WebsiteURI) &lt; 2">rule|text|BT-505-Business_R</assert>
	</rule>
	<rule context="/*/cac:BusinessParty/cac:Contact">
		<assert id="BT-502-Business_R" role="ERROR" diagnostics="BT-502-Business" test="count(cbc:Name) &lt; 2">rule|text|BT-502-Business_R</assert>
		<assert id="BT-503-Business_R" role="ERROR" diagnostics="BT-503-Business" test="count(cbc:Telephone) &lt; 2">rule|text|BT-503-Business_R</assert>
		<assert id="BT-506-Business_R" role="ERROR" diagnostics="BT-506-Business" test="count(cbc:ElectronicMail) &lt; 2">rule|text|BT-506-Business_R</assert>
		<assert id="BT-739-Business_R" role="ERROR" diagnostics="BT-739-Business" test="count(cbc:Telefax) &lt; 2">rule|text|BT-739-Business_R</assert>
	</rule>
	<rule context="/*/cac:BusinessParty/cac:PartyLegalEntity[cbc:CompanyID/@schemeName = 'EU']">
		<assert id="OPP-113-Business-European_R" role="ERROR" diagnostics="OPP-113-Business-European" test="count(cbc:RegistrationDate) &lt; 2">rule|text|OPP-113-Business-European_R</assert>
	</rule>
	<rule context="/*/cac:BusinessParty/cac:PartyLegalEntity[cbc:CompanyID/@schemeName = 'EU']/cac:CorporateRegistrationScheme/cac:JurisdictionRegionAddress">
		<assert id="OPP-110-Business_R" role="ERROR" diagnostics="OPP-110-Business" test="count(cbc:CityName) &lt; 2">rule|text|OPP-110-Business_R</assert>
		<assert id="OPP-111-Business_R" role="ERROR" diagnostics="OPP-111-Business" test="count(cbc:PostalZone) &lt; 2">rule|text|OPP-111-Business_R</assert>
		<assert id="OPP-112-Business_R" role="ERROR" diagnostics="OPP-112-Business" test="count(cac:Country/cbc:IdentificationCode) &lt; 2">rule|text|OPP-112-Business_R</assert>
	</rule>
	<rule context="/*/cac:BusinessParty/cac:PartyLegalEntity[not(cbc:CompanyID/@schemeName = 'EU')]">
		<assert id="BT-500-Business_R" role="ERROR" diagnostics="BT-500-Business" test="count(cbc:RegistrationName) &lt; 2">rule|text|BT-500-Business_R</assert>
	</rule>
	<rule context="/*/cac:BusinessParty/cac:PostalAddress">
		<assert id="BT-507-Business_R" role="ERROR" diagnostics="BT-507-Business" test="count(cbc:CountrySubentityCode) &lt; 2">rule|text|BT-507-Business_R</assert>
		<assert id="BT-510_a_-Business_R" role="ERROR" diagnostics="BT-510_a_-Business" test="count(cbc:StreetName) &lt; 2">rule|text|BT-510_a_-Business_R</assert>
		<assert id="BT-510_b_-Business_R" role="ERROR" diagnostics="BT-510_b_-Business" test="count(cbc:AdditionalStreetName) &lt; 2">rule|text|BT-510_b_-Business_R</assert>
		<assert id="BT-510_c_-Business_R" role="ERROR" diagnostics="BT-510_c_-Business" test="count(cac:AddressLine/cbc:Line) &lt; 2">rule|text|BT-510_c_-Business_R</assert>
		<assert id="BT-512-Business_R" role="ERROR" diagnostics="BT-512-Business" test="count(cbc:PostalZone) &lt; 2">rule|text|BT-512-Business_R</assert>
		<assert id="BT-513-Business_R" role="ERROR" diagnostics="BT-513-Business" test="count(cbc:CityName) &lt; 2">rule|text|BT-513-Business_R</assert>
		<assert id="BT-514-Business_R" role="ERROR" diagnostics="BT-514-Business" test="count(cac:Country/cbc:IdentificationCode) &lt; 2">rule|text|BT-514-Business_R</assert>
	</rule>
	<rule context="/*/cac:ContractingParty">
		<assert id="BT-10-Procedure-Buyer_R" role="ERROR" diagnostics="BT-10-Procedure-Buyer" test="count(cac:ContractingActivity/cbc:ActivityTypeCode[@listName='authority-activity']) &lt; 2">rule|text|BT-10-Procedure-Buyer_R</assert>
		<assert id="BT-11-Procedure-Buyer_R" role="ERROR" diagnostics="BT-11-Procedure-Buyer" test="count(cac:ContractingPartyType/cbc:PartyTypeCode[@listName='buyer-legal-type']) &lt; 2">rule|text|BT-11-Procedure-Buyer_R</assert>
		<assert id="BT-508-Procedure-Buyer_R" role="ERROR" diagnostics="BT-508-Procedure-Buyer" test="count(cbc:BuyerProfileURI) &lt; 2">rule|text|BT-508-Procedure-Buyer_R</assert>
		<assert id="BT-610-Procedure-Buyer_R" role="ERROR" diagnostics="BT-610-Procedure-Buyer" test="count(cac:ContractingActivity/cbc:ActivityTypeCode[@listName='entity-activity']) &lt; 2">rule|text|BT-610-Procedure-Buyer_R</assert>
		<assert id="BT-740-Procedure-Buyer_R" role="ERROR" diagnostics="BT-740-Procedure-Buyer" test="count(cac:ContractingPartyType/cbc:PartyTypeCode[@listName='buyer-contracting-type']) &lt; 2">rule|text|BT-740-Procedure-Buyer_R</assert>
	</rule>
	<rule context="/*/cac:ContractingParty/cac:Party/cac:ServiceProviderParty">
		<assert id="OPT-030-Procedure-SProvider_R" role="ERROR" diagnostics="OPT-030-Procedure-SProvider" test="count(cbc:ServiceTypeCode) &lt; 2">rule|text|OPT-030-Procedure-SProvider_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject">
		<assert id="BT-21-Procedure_A" role="ERROR" diagnostics="BT-21-Procedure" test="count(cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-21-Procedure_A</assert>
		<assert id="BT-21-Procedure_B" role="ERROR" diagnostics="BT-21-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Name/@languageID = $lg) or count(cbc:Name) = 0">rule|text|BT-21-Procedure_B</assert>
		<assert id="BT-21-Procedure_C" role="ERROR" diagnostics="BT-21-Procedure" test="(every $lg in (cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Name) = 0">rule|text|BT-21-Procedure_C</assert>
		<assert id="BT-22-Procedure_R" role="ERROR" diagnostics="BT-22-Procedure" test="count(cbc:ID) &lt; 2">rule|text|BT-22-Procedure_R</assert>
		<assert id="BT-23-Procedure_R" role="ERROR" diagnostics="BT-23-Procedure" test="count(cbc:ProcurementTypeCode) &lt; 2">rule|text|BT-23-Procedure_R</assert>
		<assert id="BT-24-Procedure_A" role="ERROR" diagnostics="BT-24-Procedure" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-24-Procedure_A</assert>
		<assert id="BT-24-Procedure_B" role="ERROR" diagnostics="BT-24-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-24-Procedure_B</assert>
		<assert id="BT-24-Procedure_C" role="ERROR" diagnostics="BT-24-Procedure" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-24-Procedure_C</assert>
		<assert id="BT-262-Procedure_R" role="ERROR" diagnostics="BT-262-Procedure" test="count(cac:MainCommodityClassification/cbc:ItemClassificationCode) &lt; 2">rule|text|BT-262-Procedure_R</assert>
		<assert id="BT-27-Procedure_R" role="ERROR" diagnostics="BT-27-Procedure" test="count(cac:RequestedTenderTotal/cbc:EstimatedOverallContractAmount) &lt; 2">rule|text|BT-27-Procedure_R</assert>
		<assert id="BT-300-Procedure_A" role="ERROR" diagnostics="BT-300-Procedure" test="count(cbc:Note[@languageID = preceding-sibling::cbc:Note/@languageID]) = 0">rule|text|BT-300-Procedure_A</assert>
		<assert id="BT-300-Procedure_B" role="ERROR" diagnostics="BT-300-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Note/@languageID = $lg) or count(cbc:Note) = 0">rule|text|BT-300-Procedure_B</assert>
		<assert id="BT-300-Procedure_C" role="ERROR" diagnostics="BT-300-Procedure" test="(every $lg in (cbc:Note/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Note) = 0">rule|text|BT-300-Procedure_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject/cac:AdditionalCommodityClassification">
		<assert id="BT-26_a_-Procedure_R" role="ERROR" diagnostics="BT-26_a_-Procedure" test="count(cbc:ItemClassificationCode/@listName) &lt; 2">rule|text|BT-26_a_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject/cac:MainCommodityClassification/cbc:ItemClassificationCode">
		<assert id="BT-26_m_-Procedure_R" role="ERROR" diagnostics="BT-26_m_-Procedure" test="count(@listName) &lt; 2">rule|text|BT-26_m_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject/cac:RealizedLocation">
		<assert id="BT-728-Procedure_A" role="ERROR" diagnostics="BT-728-Procedure" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-728-Procedure_A</assert>
		<assert id="BT-728-Procedure_B" role="ERROR" diagnostics="BT-728-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-728-Procedure_B</assert>
		<assert id="BT-728-Procedure_C" role="ERROR" diagnostics="BT-728-Procedure" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-728-Procedure_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject/cac:RealizedLocation/cac:Address">
		<assert id="BT-5071-Procedure_R" role="ERROR" diagnostics="BT-5071-Procedure" test="count(cbc:CountrySubentityCode) &lt; 2">rule|text|BT-5071-Procedure_R</assert>
		<assert id="BT-5101_a_-Procedure_R" role="ERROR" diagnostics="BT-5101_a_-Procedure" test="count(cbc:StreetName) &lt; 2">rule|text|BT-5101_a_-Procedure_R</assert>
		<assert id="BT-5101_b_-Procedure_R" role="ERROR" diagnostics="BT-5101_b_-Procedure" test="count(cbc:AdditionalStreetName) &lt; 2">rule|text|BT-5101_b_-Procedure_R</assert>
		<assert id="BT-5101_c_-Procedure_R" role="ERROR" diagnostics="BT-5101_c_-Procedure" test="count(cac:AddressLine/cbc:Line) &lt; 2">rule|text|BT-5101_c_-Procedure_R</assert>
		<assert id="BT-5121-Procedure_R" role="ERROR" diagnostics="BT-5121-Procedure" test="count(cbc:PostalZone) &lt; 2">rule|text|BT-5121-Procedure_R</assert>
		<assert id="BT-5131-Procedure_R" role="ERROR" diagnostics="BT-5131-Procedure" test="count(cbc:CityName) &lt; 2">rule|text|BT-5131-Procedure_R</assert>
		<assert id="BT-5141-Procedure_R" role="ERROR" diagnostics="BT-5141-Procedure" test="count(cac:Country/cbc:IdentificationCode) &lt; 2">rule|text|BT-5141-Procedure_R</assert>
		<assert id="BT-727-Procedure_R" role="ERROR" diagnostics="BT-727-Procedure" test="count(cbc:Region) &lt; 2">rule|text|BT-727-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']">
		<assert id="BT-137-Lot_R" role="ERROR" diagnostics="BT-137-Lot" test="count(cbc:ID) &lt; 2">rule|text|BT-137-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject">
		<assert id="BT-21-Lot_A" role="ERROR" diagnostics="BT-21-Lot" test="count(cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-21-Lot_A</assert>
		<assert id="BT-21-Lot_B" role="ERROR" diagnostics="BT-21-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Name/@languageID = $lg) or count(cbc:Name) = 0">rule|text|BT-21-Lot_B</assert>
		<assert id="BT-21-Lot_C" role="ERROR" diagnostics="BT-21-Lot" test="(every $lg in (cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Name) = 0">rule|text|BT-21-Lot_C</assert>
		<assert id="BT-22-Lot_R" role="ERROR" diagnostics="BT-22-Lot" test="count(cbc:ID) &lt; 2">rule|text|BT-22-Lot_R</assert>
		<assert id="BT-23-Lot_R" role="ERROR" diagnostics="BT-23-Lot" test="count(cbc:ProcurementTypeCode[@listName='contract-nature']) &lt; 2">rule|text|BT-23-Lot_R</assert>
		<assert id="BT-24-Lot_A" role="ERROR" diagnostics="BT-24-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-24-Lot_A</assert>
		<assert id="BT-24-Lot_B" role="ERROR" diagnostics="BT-24-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-24-Lot_B</assert>
		<assert id="BT-24-Lot_C" role="ERROR" diagnostics="BT-24-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-24-Lot_C</assert>
		<assert id="BT-25-Lot_R" role="ERROR" diagnostics="BT-25-Lot" test="count(cbc:EstimatedOverallContractQuantity) &lt; 2">rule|text|BT-25-Lot_R</assert>
		<assert id="BT-262-Lot_R" role="ERROR" diagnostics="BT-262-Lot" test="count(cac:MainCommodityClassification/cbc:ItemClassificationCode) &lt; 2">rule|text|BT-262-Lot_R</assert>
		<assert id="BT-300-Lot_A" role="ERROR" diagnostics="BT-300-Lot" test="count(cbc:Note[@languageID = preceding-sibling::cbc:Note/@languageID]) = 0">rule|text|BT-300-Lot_A</assert>
		<assert id="BT-300-Lot_B" role="ERROR" diagnostics="BT-300-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Note/@languageID = $lg) or count(cbc:Note) = 0">rule|text|BT-300-Lot_B</assert>
		<assert id="BT-300-Lot_C" role="ERROR" diagnostics="BT-300-Lot" test="(every $lg in (cbc:Note/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Note) = 0">rule|text|BT-300-Lot_C</assert>
		<assert id="BT-625-Lot_R" role="ERROR" diagnostics="BT-625-Lot" test="count(cbc:EstimatedOverallContractQuantity/@unitCode) &lt; 2">rule|text|BT-625-Lot_R</assert>
		<assert id="BT-726-Lot_R" role="ERROR" diagnostics="BT-726-Lot" test="count(cbc:SMESuitableIndicator) &lt; 2">rule|text|BT-726-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:AdditionalCommodityClassification">
		<assert id="BT-26_a_-Lot_R" role="ERROR" diagnostics="BT-26_a_-Lot" test="count(cbc:ItemClassificationCode/@listName) &lt; 2">rule|text|BT-26_a_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:ContractExtension">
		<assert id="BT-54-Lot_A" role="ERROR" diagnostics="BT-54-Lot" test="count(cbc:OptionsDescription[@languageID = preceding-sibling::cbc:OptionsDescription/@languageID]) = 0">rule|text|BT-54-Lot_A</assert>
		<assert id="BT-54-Lot_B" role="ERROR" diagnostics="BT-54-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:OptionsDescription/@languageID = $lg) or count(cbc:OptionsDescription) = 0">rule|text|BT-54-Lot_B</assert>
		<assert id="BT-54-Lot_C" role="ERROR" diagnostics="BT-54-Lot" test="(every $lg in (cbc:OptionsDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:OptionsDescription) = 0">rule|text|BT-54-Lot_C</assert>
		<assert id="BT-57-Lot_A" role="ERROR" diagnostics="BT-57-Lot" test="count(cac:Renewal/cac:Period/cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-57-Lot_A</assert>
		<assert id="BT-57-Lot_B" role="ERROR" diagnostics="BT-57-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cac:Renewal/cac:Period/cbc:Description/@languageID = $lg) or count(cac:Renewal/cac:Period/cbc:Description) = 0">rule|text|BT-57-Lot_B</assert>
		<assert id="BT-57-Lot_C" role="ERROR" diagnostics="BT-57-Lot" test="(every $lg in (cac:Renewal/cac:Period/cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cac:Renewal/cac:Period/cbc:Description) = 0">rule|text|BT-57-Lot_C</assert>
		<assert id="BT-58-Lot_R" role="ERROR" diagnostics="BT-58-Lot" test="count(cbc:MaximumNumberNumeric) &lt; 2">rule|text|BT-58-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:MainCommodityClassification/cbc:ItemClassificationCode">
		<assert id="BT-26_m_-Lot_R" role="ERROR" diagnostics="BT-26_m_-Lot" test="count(@listName) &lt; 2">rule|text|BT-26_m_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:PlannedPeriod">
		<assert id="BT-36-Lot_R" role="ERROR" diagnostics="BT-36-Lot" test="count(cbc:DurationMeasure) &lt; 2">rule|text|BT-36-Lot_R</assert>
		<assert id="BT-536-Lot_R" role="ERROR" diagnostics="BT-536-Lot" test="count(cbc:StartDate) &lt; 2">rule|text|BT-536-Lot_R</assert>
		<assert id="BT-537-Lot_R" role="ERROR" diagnostics="BT-537-Lot" test="count(cbc:EndDate) &lt; 2">rule|text|BT-537-Lot_R</assert>
		<assert id="BT-538-Lot_R" role="ERROR" diagnostics="BT-538-Lot" test="count(cbc:DescriptionCode) &lt; 2">rule|text|BT-538-Lot_R</assert>
		<assert id="BT-781-Lot_A" role="ERROR" diagnostics="BT-781-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-781-Lot_A</assert>
		<assert id="BT-781-Lot_B" role="ERROR" diagnostics="BT-781-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-781-Lot_B</assert>
		<assert id="BT-781-Lot_C" role="ERROR" diagnostics="BT-781-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-781-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType[cbc:ProcurementTypeCode/@listName='accessibility']">
		<assert id="BT-755-Lot_A" role="ERROR" diagnostics="BT-755-Lot" test="count(cbc:ProcurementType[@languageID = preceding-sibling::cbc:ProcurementType/@languageID]) = 0">rule|text|BT-755-Lot_A</assert>
		<assert id="BT-755-Lot_B" role="ERROR" diagnostics="BT-755-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:ProcurementType/@languageID = $lg) or count(cbc:ProcurementType) = 0">rule|text|BT-755-Lot_B</assert>
		<assert id="BT-755-Lot_C" role="ERROR" diagnostics="BT-755-Lot" test="(every $lg in (cbc:ProcurementType/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:ProcurementType) = 0">rule|text|BT-755-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType[cbc:ProcurementTypeCode/@listName='strategic-procurement']">
		<assert id="BT-777-Lot_A" role="ERROR" diagnostics="BT-777-Lot" test="count(cbc:ProcurementType[@languageID = preceding-sibling::cbc:ProcurementType/@languageID]) = 0">rule|text|BT-777-Lot_A</assert>
		<assert id="BT-777-Lot_B" role="ERROR" diagnostics="BT-777-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:ProcurementType/@languageID = $lg) or count(cbc:ProcurementType) = 0">rule|text|BT-777-Lot_B</assert>
		<assert id="BT-777-Lot_C" role="ERROR" diagnostics="BT-777-Lot" test="(every $lg in (cbc:ProcurementType/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:ProcurementType) = 0">rule|text|BT-777-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:RealizedLocation">
		<assert id="BT-5071-Lot_R" role="ERROR" diagnostics="BT-5071-Lot" test="count(cac:Address/cbc:CountrySubentityCode) &lt; 2">rule|text|BT-5071-Lot_R</assert>
		<assert id="BT-5101_a_-Lot_R" role="ERROR" diagnostics="BT-5101_a_-Lot" test="count(cac:Address/cbc:StreetName) &lt; 2">rule|text|BT-5101_a_-Lot_R</assert>
		<assert id="BT-5101_b_-Lot_R" role="ERROR" diagnostics="BT-5101_b_-Lot" test="count(cac:Address/cbc:AdditionalStreetName) &lt; 2">rule|text|BT-5101_b_-Lot_R</assert>
		<assert id="BT-5101_c_-Lot_R" role="ERROR" diagnostics="BT-5101_c_-Lot" test="count(cac:Address/cac:AddressLine/cbc:Line) &lt; 2">rule|text|BT-5101_c_-Lot_R</assert>
		<assert id="BT-5121-Lot_R" role="ERROR" diagnostics="BT-5121-Lot" test="count(cac:Address/cbc:PostalZone) &lt; 2">rule|text|BT-5121-Lot_R</assert>
		<assert id="BT-5131-Lot_R" role="ERROR" diagnostics="BT-5131-Lot" test="count(cac:Address/cbc:CityName) &lt; 2">rule|text|BT-5131-Lot_R</assert>
		<assert id="BT-5141-Lot_R" role="ERROR" diagnostics="BT-5141-Lot" test="count(cac:Address/cac:Country/cbc:IdentificationCode) &lt; 2">rule|text|BT-5141-Lot_R</assert>
		<assert id="BT-727-Lot_R" role="ERROR" diagnostics="BT-727-Lot" test="count(cac:Address/cbc:Region) &lt; 2">rule|text|BT-727-Lot_R</assert>
		<assert id="BT-728-Lot_A" role="ERROR" diagnostics="BT-728-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-728-Lot_A</assert>
		<assert id="BT-728-Lot_B" role="ERROR" diagnostics="BT-728-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-728-Lot_B</assert>
		<assert id="BT-728-Lot_C" role="ERROR" diagnostics="BT-728-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-728-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:RequestedTenderTotal">
		<assert id="BT-27-Lot_R" role="ERROR" diagnostics="BT-27-Lot" test="count(cbc:EstimatedOverallContractAmount) &lt; 2">rule|text|BT-27-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess">
		<assert id="BT-115-Lot_R" role="ERROR" diagnostics="BT-115-Lot" test="count(cbc:GovernmentAgreementConstraintIndicator) &lt; 2">rule|text|BT-115-Lot_R</assert>
		<assert id="BT-130-Lot_R" role="ERROR" diagnostics="BT-130-Lot" test="count(cac:InvitationSubmissionPeriod/cbc:StartDate) &lt; 2">rule|text|BT-130-Lot_R</assert>
		<assert id="BT-1311_d_-Lot_R" role="ERROR" diagnostics="BT-1311_d_-Lot" test="count(cac:ParticipationRequestReceptionPeriod/cbc:EndDate) &lt; 2">rule|text|BT-1311_d_-Lot_R</assert>
		<assert id="BT-1311_t_-Lot_R" role="ERROR" diagnostics="BT-1311_t_-Lot" test="count(cac:ParticipationRequestReceptionPeriod/cbc:EndTime) &lt; 2">rule|text|BT-1311_t_-Lot_R</assert>
		<assert id="BT-131_d_-Lot_R" role="ERROR" diagnostics="BT-131_d_-Lot" test="count(cac:TenderSubmissionDeadlinePeriod/cbc:EndDate) &lt; 2">rule|text|BT-131_d_-Lot_R</assert>
		<assert id="BT-131_t_-Lot_R" role="ERROR" diagnostics="BT-131_t_-Lot" test="count(cac:TenderSubmissionDeadlinePeriod/cbc:EndTime) &lt; 2">rule|text|BT-131_t_-Lot_R</assert>
		<assert id="BT-13_d_-Lot_R" role="ERROR" diagnostics="BT-13_d_-Lot" test="count(cac:AdditionalInformationRequestPeriod/cbc:EndDate) &lt; 2">rule|text|BT-13_d_-Lot_R</assert>
		<assert id="BT-13_t_-Lot_R" role="ERROR" diagnostics="BT-13_t_-Lot" test="count(cac:AdditionalInformationRequestPeriod/cbc:EndTime) &lt; 2">rule|text|BT-13_t_-Lot_R</assert>
		<assert id="BT-17-Lot_R" role="ERROR" diagnostics="BT-17-Lot" test="count(cbc:SubmissionMethodCode[@listName='esubmission']) &lt; 2">rule|text|BT-17-Lot_R</assert>
		<assert id="BT-52-Lot_R" role="ERROR" diagnostics="BT-52-Lot" test="count(cbc:CandidateReductionConstraintIndicator) &lt; 2">rule|text|BT-52-Lot_R</assert>
		<assert id="BT-631-Lot_R" role="ERROR" diagnostics="BT-631-Lot" test="count(cac:ParticipationInvitationPeriod/cbc:StartDate) &lt; 2">rule|text|BT-631-Lot_R</assert>
		<assert id="BT-765-Lot_R" role="ERROR" diagnostics="BT-765-Lot" test="count(cac:ContractingSystem/cbc:ContractingSystemTypeCode[@listName='framework-agreement']) &lt; 2">rule|text|BT-765-Lot_R</assert>
		<assert id="BT-766-Lot_R" role="ERROR" diagnostics="BT-766-Lot" test="count(cac:ContractingSystem/cbc:ContractingSystemTypeCode[@listName='dps-usage']) &lt; 2">rule|text|BT-766-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:AuctionTerms">
		<assert id="BT-122-Lot_A" role="ERROR" diagnostics="BT-122-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-122-Lot_A</assert>
		<assert id="BT-122-Lot_B" role="ERROR" diagnostics="BT-122-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-122-Lot_B</assert>
		<assert id="BT-122-Lot_C" role="ERROR" diagnostics="BT-122-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-122-Lot_C</assert>
		<assert id="BT-123-Lot_R" role="ERROR" diagnostics="BT-123-Lot" test="count(cbc:AuctionURI) &lt; 2">rule|text|BT-123-Lot_R</assert>
		<assert id="BT-767-Lot_R" role="ERROR" diagnostics="BT-767-Lot" test="count(cbc:AuctionConstraintIndicator) &lt; 2">rule|text|BT-767-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:EconomicOperatorShortList">
		<assert id="BT-50-Lot_R" role="ERROR" diagnostics="BT-50-Lot" test="count(cbc:MinimumQuantity) &lt; 2">rule|text|BT-50-Lot_R</assert>
		<assert id="BT-51-Lot_R" role="ERROR" diagnostics="BT-51-Lot" test="count(cbc:MaximumQuantity) &lt; 2">rule|text|BT-51-Lot_R</assert>
		<assert id="BT-661-Lot_R" role="ERROR" diagnostics="BT-661-Lot" test="count(cbc:LimitationDescription) &lt; 2">rule|text|BT-661-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:FrameworkAgreement">
		<assert id="BT-109-Lot_A" role="ERROR" diagnostics="BT-109-Lot" test="count(cbc:Justification[@languageID = preceding-sibling::cbc:Justification/@languageID]) = 0">rule|text|BT-109-Lot_A</assert>
		<assert id="BT-109-Lot_B" role="ERROR" diagnostics="BT-109-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Justification/@languageID = $lg) or count(cbc:Justification) = 0">rule|text|BT-109-Lot_B</assert>
		<assert id="BT-109-Lot_C" role="ERROR" diagnostics="BT-109-Lot" test="(every $lg in (cbc:Justification/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Justification) = 0">rule|text|BT-109-Lot_C</assert>
		<assert id="BT-113-Lot_R" role="ERROR" diagnostics="BT-113-Lot" test="count(cbc:MaximumOperatorQuantity) &lt; 2">rule|text|BT-113-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:FrameworkAgreement/cac:SubsequentProcessTenderRequirement">
		<assert id="OPT-090-Lot_R" role="ERROR" diagnostics="OPT-090-Lot" test="count(cbc:Name) &lt; 2">rule|text|OPT-090-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:FrameworkAgreement/cac:SubsequentProcessTenderRequirement[cbc:Name/text()='buyer-categories']">
		<assert id="BT-111-Lot_A" role="ERROR" diagnostics="BT-111-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-111-Lot_A</assert>
		<assert id="BT-111-Lot_B" role="ERROR" diagnostics="BT-111-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-111-Lot_B</assert>
		<assert id="BT-111-Lot_C" role="ERROR" diagnostics="BT-111-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-111-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:NoticeDocumentReference">
		<assert id="BT-125_i_-Lot_R" role="ERROR" diagnostics="BT-125_i_-Lot" test="count(cbc:ID) &lt; 2">rule|text|BT-125_i_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:OpenTenderEvent">
		<assert id="BT-132_d_-Lot_R" role="ERROR" diagnostics="BT-132_d_-Lot" test="count(cbc:OccurrenceDate) &lt; 2">rule|text|BT-132_d_-Lot_R</assert>
		<assert id="BT-132_t_-Lot_R" role="ERROR" diagnostics="BT-132_t_-Lot" test="count(cbc:OccurrenceTime) &lt; 2">rule|text|BT-132_t_-Lot_R</assert>
		<assert id="BT-133-Lot_A" role="ERROR" diagnostics="BT-133-Lot" test="count(cac:OccurenceLocation/cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-133-Lot_A</assert>
		<assert id="BT-133-Lot_B" role="ERROR" diagnostics="BT-133-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cac:OccurenceLocation/cbc:Description/@languageID = $lg) or count(cac:OccurenceLocation/cbc:Description) = 0">rule|text|BT-133-Lot_B</assert>
		<assert id="BT-133-Lot_C" role="ERROR" diagnostics="BT-133-Lot" test="(every $lg in (cac:OccurenceLocation/cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cac:OccurenceLocation/cbc:Description) = 0">rule|text|BT-133-Lot_C</assert>
		<assert id="BT-134-Lot_A" role="ERROR" diagnostics="BT-134-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-134-Lot_A</assert>
		<assert id="BT-134-Lot_B" role="ERROR" diagnostics="BT-134-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-134-Lot_B</assert>
		<assert id="BT-134-Lot_C" role="ERROR" diagnostics="BT-134-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-134-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:ProcessJustification">
		<assert id="BT-19-Lot_R" role="ERROR" diagnostics="BT-19-Lot" test="count(cbc:ProcessReasonCode[@listName='no-esubmission-justification']) &lt; 2">rule|text|BT-19-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='no-esubmission-justification']">
		<assert id="BT-745-Lot_A" role="ERROR" diagnostics="BT-745-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-745-Lot_A</assert>
		<assert id="BT-745-Lot_B" role="ERROR" diagnostics="BT-745-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-745-Lot_B</assert>
		<assert id="BT-745-Lot_C" role="ERROR" diagnostics="BT-745-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-745-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension">
		<assert id="BT-632-Lot_R" role="ERROR" diagnostics="BT-632-Lot" test="count(efbc:AccessToolName) &lt; 2">rule|text|BT-632-Lot_R</assert>
		<assert id="BT-634-Lot_R" role="ERROR" diagnostics="BT-634-Lot" test="count(efbc:ProcedureRelaunchIndicator) &lt; 2">rule|text|BT-634-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AnswerReceptionPeriod">
		<assert id="BT-800_d_-Lot_R" role="ERROR" diagnostics="BT-800_d_-Lot" test="count(cbc:EndDate) &lt; 2">rule|text|BT-800_d_-Lot_R</assert>
		<assert id="BT-800_t_-Lot_R" role="ERROR" diagnostics="BT-800_t_-Lot" test="count(cbc:EndTime) &lt; 2">rule|text|BT-800_t_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:InterestExpressionReceptionPeriod">
		<assert id="BT-630_d_-Lot_R" role="ERROR" diagnostics="BT-630_d_-Lot" test="count(cbc:EndDate) &lt; 2">rule|text|BT-630_d_-Lot_R</assert>
		<assert id="BT-630_t_-Lot_R" role="ERROR" diagnostics="BT-630_t_-Lot" test="count(cbc:EndTime) &lt; 2">rule|text|BT-630_t_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms">
		<assert id="BT-18-Lot_R" role="ERROR" diagnostics="BT-18-Lot" test="count(cac:TenderRecipientParty/cbc:EndpointID) &lt; 2">rule|text|BT-18-Lot_R</assert>
		<assert id="BT-60-Lot_R" role="ERROR" diagnostics="BT-60-Lot" test="count(cbc:FundingProgramCode[@listName='eu-funded']) &lt; 2">rule|text|BT-60-Lot_R</assert>
		<assert id="BT-63-Lot_R" role="ERROR" diagnostics="BT-63-Lot" test="count(cbc:VariantConstraintCode) &lt; 2">rule|text|BT-63-Lot_R</assert>
		<assert id="BT-736-Lot_R" role="ERROR" diagnostics="BT-736-Lot" test="count(cac:ContractExecutionRequirement/cbc:ExecutionRequirementCode[@listName='reserved-execution']) &lt; 2">rule|text|BT-736-Lot_R</assert>
		<assert id="BT-743-Lot_R" role="ERROR" diagnostics="BT-743-Lot" test="count(cac:ContractExecutionRequirement/cbc:ExecutionRequirementCode[@listName='einvoicing']) &lt; 2">rule|text|BT-743-Lot_R</assert>
		<assert id="BT-744-Lot_R" role="ERROR" diagnostics="BT-744-Lot" test="count(cac:ContractExecutionRequirement/cbc:ExecutionRequirementCode[@listName='esignature-submission']) &lt; 2">rule|text|BT-744-Lot_R</assert>
		<assert id="BT-75-Lot_A" role="ERROR" diagnostics="BT-75-Lot" test="count(cac:RequiredFinancialGuarantee[cbc:GuaranteeTypeCode/text()='true']/cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-75-Lot_A</assert>
		<assert id="BT-75-Lot_B" role="ERROR" diagnostics="BT-75-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cac:RequiredFinancialGuarantee[cbc:GuaranteeTypeCode/text()='true']/cbc:Description/@languageID = $lg) or count(cac:RequiredFinancialGuarantee[cbc:GuaranteeTypeCode/text()='true']/cbc:Description) = 0">rule|text|BT-75-Lot_B</assert>
		<assert id="BT-75-Lot_C" role="ERROR" diagnostics="BT-75-Lot" test="(every $lg in (cac:RequiredFinancialGuarantee[cbc:GuaranteeTypeCode/text()='true']/cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cac:RequiredFinancialGuarantee[cbc:GuaranteeTypeCode/text()='true']/cbc:Description) = 0">rule|text|BT-75-Lot_C</assert>
		<assert id="BT-751-Lot_R" role="ERROR" diagnostics="BT-751-Lot" test="count(cac:RequiredFinancialGuarantee/cbc:GuaranteeTypeCode[@listName='tender-guarantee-required']) &lt; 2">rule|text|BT-751-Lot_R</assert>
		<assert id="BT-76-Lot_A" role="ERROR" diagnostics="BT-76-Lot" test="count(cac:TendererQualificationRequest[not(cac:SpecificTendererRequirement)]/cbc:CompanyLegalForm[@languageID = preceding-sibling::cbc:CompanyLegalForm/@languageID]) = 0">rule|text|BT-76-Lot_A</assert>
		<assert id="BT-76-Lot_B" role="ERROR" diagnostics="BT-76-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cac:TendererQualificationRequest[not(cac:SpecificTendererRequirement)]/cbc:CompanyLegalForm/@languageID = $lg) or count(cac:TendererQualificationRequest[not(cac:SpecificTendererRequirement)]/cbc:CompanyLegalForm) = 0">rule|text|BT-76-Lot_B</assert>
		<assert id="BT-76-Lot_C" role="ERROR" diagnostics="BT-76-Lot" test="(every $lg in (cac:TendererQualificationRequest[not(cac:SpecificTendererRequirement)]/cbc:CompanyLegalForm/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cac:TendererQualificationRequest[not(cac:SpecificTendererRequirement)]/cbc:CompanyLegalForm) = 0">rule|text|BT-76-Lot_C</assert>
		<assert id="BT-761-Lot_R" role="ERROR" diagnostics="BT-761-Lot" test="count(cac:TendererQualificationRequest[not(cac:SpecificTendererRequirement)]/cbc:CompanyLegalFormCode) &lt; 2">rule|text|BT-761-Lot_R</assert>
		<assert id="BT-764-Lot_R" role="ERROR" diagnostics="BT-764-Lot" test="count(cac:ContractExecutionRequirement/cbc:ExecutionRequirementCode[@listName='ecatalog-submission']) &lt; 2">rule|text|BT-764-Lot_R</assert>
		<assert id="BT-769-Lot_R" role="ERROR" diagnostics="BT-769-Lot" test="count(cbc:MultipleTendersCode) &lt; 2">rule|text|BT-769-Lot_R</assert>
		<assert id="BT-78-Lot_R" role="ERROR" diagnostics="BT-78-Lot" test="count(cbc:LatestSecurityClearanceDate) &lt; 2">rule|text|BT-78-Lot_R</assert>
		<assert id="BT-79-Lot_R" role="ERROR" diagnostics="BT-79-Lot" test="count(cbc:RequiredCurriculaCode) &lt; 2">rule|text|BT-79-Lot_R</assert>
		<assert id="BT-94-Lot_R" role="ERROR" diagnostics="BT-94-Lot" test="count(cbc:RecurringProcurementIndicator) &lt; 2">rule|text|BT-94-Lot_R</assert>
		<assert id="BT-95-Lot_A" role="ERROR" diagnostics="BT-95-Lot" test="count(cbc:RecurringProcurementDescription[@languageID = preceding-sibling::cbc:RecurringProcurementDescription/@languageID]) = 0">rule|text|BT-95-Lot_A</assert>
		<assert id="BT-95-Lot_B" role="ERROR" diagnostics="BT-95-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:RecurringProcurementDescription/@languageID = $lg) or count(cbc:RecurringProcurementDescription) = 0">rule|text|BT-95-Lot_B</assert>
		<assert id="BT-95-Lot_C" role="ERROR" diagnostics="BT-95-Lot" test="(every $lg in (cbc:RecurringProcurementDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:RecurringProcurementDescription) = 0">rule|text|BT-95-Lot_C</assert>
		<assert id="BT-98-Lot_R" role="ERROR" diagnostics="BT-98-Lot" test="count(cac:TenderValidityPeriod/cbc:DurationMeasure) &lt; 2">rule|text|BT-98-Lot_R</assert>
		<assert id="OPT-301-Lot-AddInfo_R" role="ERROR" diagnostics="OPT-301-Lot-AddInfo" test="count(cac:AdditionalInformationParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-AddInfo_R</assert>
		<assert id="OPT-301-Lot-DocProvider_R" role="ERROR" diagnostics="OPT-301-Lot-DocProvider" test="count(cac:DocumentProviderParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-DocProvider_R</assert>
		<assert id="OPT-301-Lot-TenderEval_R" role="ERROR" diagnostics="OPT-301-Lot-TenderEval" test="count(cac:TenderEvaluationParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-TenderEval_R</assert>
		<assert id="OPT-301-Lot-TenderReceipt_R" role="ERROR" diagnostics="OPT-301-Lot-TenderReceipt" test="count(cac:TenderRecipientParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-TenderReceipt_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AllowedSubcontractTerms">
		<assert id="BT-64-Lot_R" role="ERROR" diagnostics="BT-64-Lot" test="count(cbc:MinimumPercent) &lt; 2">rule|text|BT-64-Lot_R</assert>
		<assert id="BT-729-Lot_R" role="ERROR" diagnostics="BT-729-Lot" test="count(cbc:MaximumPercent) &lt; 2">rule|text|BT-729-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AllowedSubcontractTerms[cbc:SubcontractingConditionsCode/@listName='subcontracting-allowed']">
		<assert id="OPT-150-Lot_R" role="ERROR" diagnostics="OPT-150-Lot" test="count(cbc:SubcontractingConditionsCode) &lt; 2">rule|text|OPT-150-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AppealTerms">
		<assert id="BT-99-Lot_A" role="ERROR" diagnostics="BT-99-Lot" test="count(cac:PresentationPeriod/cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-99-Lot_A</assert>
		<assert id="BT-99-Lot_B" role="ERROR" diagnostics="BT-99-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cac:PresentationPeriod/cbc:Description/@languageID = $lg) or count(cac:PresentationPeriod/cbc:Description) = 0">rule|text|BT-99-Lot_B</assert>
		<assert id="BT-99-Lot_C" role="ERROR" diagnostics="BT-99-Lot" test="(every $lg in (cac:PresentationPeriod/cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cac:PresentationPeriod/cbc:Description) = 0">rule|text|BT-99-Lot_C</assert>
		<assert id="OPT-301-Lot-Mediator_R" role="ERROR" diagnostics="OPT-301-Lot-Mediator" test="count(cac:MediationParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-Mediator_R</assert>
		<assert id="OPT-301-Lot-ReviewInfo_R" role="ERROR" diagnostics="OPT-301-Lot-ReviewInfo" test="count(cac:AppealInformationParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-ReviewInfo_R</assert>
		<assert id="OPT-301-Lot-ReviewOrg_R" role="ERROR" diagnostics="OPT-301-Lot-ReviewOrg" test="count(cac:AppealReceiverParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-ReviewOrg_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms">
		<assert id="BT-120-Lot_R" role="ERROR" diagnostics="BT-120-Lot" test="count(cbc:NoFurtherNegotiationIndicator) &lt; 2">rule|text|BT-120-Lot_R</assert>
		<assert id="BT-41-Lot_R" role="ERROR" diagnostics="BT-41-Lot" test="count(cbc:FollowupContractIndicator) &lt; 2">rule|text|BT-41-Lot_R</assert>
		<assert id="BT-42-Lot_R" role="ERROR" diagnostics="BT-42-Lot" test="count(cbc:BindingOnBuyerIndicator) &lt; 2">rule|text|BT-42-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion">
		<assert id="BT-543-Lot_A" role="ERROR" diagnostics="BT-543-Lot" test="count(cbc:CalculationExpression[@languageID = preceding-sibling::cbc:CalculationExpression/@languageID]) = 0">rule|text|BT-543-Lot_A</assert>
		<assert id="BT-543-Lot_B" role="ERROR" diagnostics="BT-543-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:CalculationExpression/@languageID = $lg) or count(cbc:CalculationExpression) = 0">rule|text|BT-543-Lot_B</assert>
		<assert id="BT-543-Lot_C" role="ERROR" diagnostics="BT-543-Lot" test="(every $lg in (cbc:CalculationExpression/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:CalculationExpression) = 0">rule|text|BT-543-Lot_C</assert>
		<assert id="BT-733-Lot_A" role="ERROR" diagnostics="BT-733-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-733-Lot_A</assert>
		<assert id="BT-733-Lot_B" role="ERROR" diagnostics="BT-733-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-733-Lot_B</assert>
		<assert id="BT-733-Lot_C" role="ERROR" diagnostics="BT-733-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-733-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion">
		<assert id="BT-540-Lot_A" role="ERROR" diagnostics="BT-540-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-540-Lot_A</assert>
		<assert id="BT-540-Lot_B" role="ERROR" diagnostics="BT-540-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-540-Lot_B</assert>
		<assert id="BT-540-Lot_C" role="ERROR" diagnostics="BT-540-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-540-Lot_C</assert>
		<assert id="BT-734-Lot_A" role="ERROR" diagnostics="BT-734-Lot" test="count(cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-734-Lot_A</assert>
		<assert id="BT-734-Lot_B" role="ERROR" diagnostics="BT-734-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Name/@languageID = $lg) or count(cbc:Name) = 0">rule|text|BT-734-Lot_B</assert>
		<assert id="BT-734-Lot_C" role="ERROR" diagnostics="BT-734-Lot" test="(every $lg in (cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Name) = 0">rule|text|BT-734-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter">
		<assert id="BT-5421-Lot_R" role="ERROR" diagnostics="BT-5421-Lot" test="count(efbc:ParameterCode[@listName='number-weight']) &lt; 2">rule|text|BT-5421-Lot_R</assert>
		<assert id="BT-5422-Lot_R" role="ERROR" diagnostics="BT-5422-Lot" test="count(efbc:ParameterCode[@listName='number-fixed']) &lt; 2">rule|text|BT-5422-Lot_R</assert>
		<assert id="BT-5423-Lot_R" role="ERROR" diagnostics="BT-5423-Lot" test="count(efbc:ParameterCode[@listName='number-threshold']) &lt; 2">rule|text|BT-5423-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-num']">
		<assert id="BT-195_BT-541_-Lot_R" role="ERROR" diagnostics="BT-195_BT-541_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-541_-Lot_R</assert>
		<assert id="BT-196_BT-541_-Lot_A" role="ERROR" diagnostics="BT-196_BT-541_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-541_-Lot_A</assert>
		<assert id="BT-196_BT-541_-Lot_B" role="ERROR" diagnostics="BT-196_BT-541_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-541_-Lot_B</assert>
		<assert id="BT-196_BT-541_-Lot_C" role="ERROR" diagnostics="BT-196_BT-541_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-541_-Lot_C</assert>
		<assert id="BT-197_BT-541_-Lot_R" role="ERROR" diagnostics="BT-197_BT-541_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-541_-Lot_R</assert>
		<assert id="BT-198_BT-541_-Lot_R" role="ERROR" diagnostics="BT-198_BT-541_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-541_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-fixed']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-fix']">
		<assert id="BT-195_BT-5422_-Lot_R" role="ERROR" diagnostics="BT-195_BT-5422_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-5422_-Lot_R</assert>
		<assert id="BT-196_BT-5422_-Lot_A" role="ERROR" diagnostics="BT-196_BT-5422_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-5422_-Lot_A</assert>
		<assert id="BT-196_BT-5422_-Lot_B" role="ERROR" diagnostics="BT-196_BT-5422_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5422_-Lot_B</assert>
		<assert id="BT-196_BT-5422_-Lot_C" role="ERROR" diagnostics="BT-196_BT-5422_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5422_-Lot_C</assert>
		<assert id="BT-197_BT-5422_-Lot_R" role="ERROR" diagnostics="BT-197_BT-5422_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-5422_-Lot_R</assert>
		<assert id="BT-198_BT-5422_-Lot_R" role="ERROR" diagnostics="BT-198_BT-5422_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-5422_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-threshold']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-thr']">
		<assert id="BT-195_BT-5423_-Lot_R" role="ERROR" diagnostics="BT-195_BT-5423_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-5423_-Lot_R</assert>
		<assert id="BT-196_BT-5423_-Lot_A" role="ERROR" diagnostics="BT-196_BT-5423_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-5423_-Lot_A</assert>
		<assert id="BT-196_BT-5423_-Lot_B" role="ERROR" diagnostics="BT-196_BT-5423_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5423_-Lot_B</assert>
		<assert id="BT-196_BT-5423_-Lot_C" role="ERROR" diagnostics="BT-196_BT-5423_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5423_-Lot_C</assert>
		<assert id="BT-197_BT-5423_-Lot_R" role="ERROR" diagnostics="BT-197_BT-5423_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-5423_-Lot_R</assert>
		<assert id="BT-198_BT-5423_-Lot_R" role="ERROR" diagnostics="BT-198_BT-5423_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-5423_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-weight']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-wei']">
		<assert id="BT-195_BT-5421_-Lot_R" role="ERROR" diagnostics="BT-195_BT-5421_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-5421_-Lot_R</assert>
		<assert id="BT-196_BT-5421_-Lot_A" role="ERROR" diagnostics="BT-196_BT-5421_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-5421_-Lot_A</assert>
		<assert id="BT-196_BT-5421_-Lot_B" role="ERROR" diagnostics="BT-196_BT-5421_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5421_-Lot_B</assert>
		<assert id="BT-196_BT-5421_-Lot_C" role="ERROR" diagnostics="BT-196_BT-5421_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5421_-Lot_C</assert>
		<assert id="BT-197_BT-5421_-Lot_R" role="ERROR" diagnostics="BT-197_BT-5421_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-5421_-Lot_R</assert>
		<assert id="BT-198_BT-5421_-Lot_R" role="ERROR" diagnostics="BT-198_BT-5421_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-5421_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-des']">
		<assert id="BT-195_BT-540_-Lot_R" role="ERROR" diagnostics="BT-195_BT-540_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-540_-Lot_R</assert>
		<assert id="BT-196_BT-540_-Lot_A" role="ERROR" diagnostics="BT-196_BT-540_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-540_-Lot_A</assert>
		<assert id="BT-196_BT-540_-Lot_B" role="ERROR" diagnostics="BT-196_BT-540_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-540_-Lot_B</assert>
		<assert id="BT-196_BT-540_-Lot_C" role="ERROR" diagnostics="BT-196_BT-540_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-540_-Lot_C</assert>
		<assert id="BT-197_BT-540_-Lot_R" role="ERROR" diagnostics="BT-197_BT-540_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-540_-Lot_R</assert>
		<assert id="BT-198_BT-540_-Lot_R" role="ERROR" diagnostics="BT-198_BT-540_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-540_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-nam']">
		<assert id="BT-195_BT-734_-Lot_R" role="ERROR" diagnostics="BT-195_BT-734_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-734_-Lot_R</assert>
		<assert id="BT-196_BT-734_-Lot_A" role="ERROR" diagnostics="BT-196_BT-734_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-734_-Lot_A</assert>
		<assert id="BT-196_BT-734_-Lot_B" role="ERROR" diagnostics="BT-196_BT-734_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-734_-Lot_B</assert>
		<assert id="BT-196_BT-734_-Lot_C" role="ERROR" diagnostics="BT-196_BT-734_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-734_-Lot_C</assert>
		<assert id="BT-197_BT-734_-Lot_R" role="ERROR" diagnostics="BT-197_BT-734_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-734_-Lot_R</assert>
		<assert id="BT-198_BT-734_-Lot_R" role="ERROR" diagnostics="BT-198_BT-734_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-734_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-typ']">
		<assert id="BT-195_BT-539_-Lot_R" role="ERROR" diagnostics="BT-195_BT-539_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-539_-Lot_R</assert>
		<assert id="BT-196_BT-539_-Lot_A" role="ERROR" diagnostics="BT-196_BT-539_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-539_-Lot_A</assert>
		<assert id="BT-196_BT-539_-Lot_B" role="ERROR" diagnostics="BT-196_BT-539_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-539_-Lot_B</assert>
		<assert id="BT-196_BT-539_-Lot_C" role="ERROR" diagnostics="BT-196_BT-539_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-539_-Lot_C</assert>
		<assert id="BT-197_BT-539_-Lot_R" role="ERROR" diagnostics="BT-197_BT-539_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-539_-Lot_R</assert>
		<assert id="BT-198_BT-539_-Lot_R" role="ERROR" diagnostics="BT-198_BT-539_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-539_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-com']">
		<assert id="BT-195_BT-543_-Lot_R" role="ERROR" diagnostics="BT-195_BT-543_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-543_-Lot_R</assert>
		<assert id="BT-196_BT-543_-Lot_A" role="ERROR" diagnostics="BT-196_BT-543_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-543_-Lot_A</assert>
		<assert id="BT-196_BT-543_-Lot_B" role="ERROR" diagnostics="BT-196_BT-543_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-543_-Lot_B</assert>
		<assert id="BT-196_BT-543_-Lot_C" role="ERROR" diagnostics="BT-196_BT-543_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-543_-Lot_C</assert>
		<assert id="BT-197_BT-543_-Lot_R" role="ERROR" diagnostics="BT-197_BT-543_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-543_-Lot_R</assert>
		<assert id="BT-198_BT-543_-Lot_R" role="ERROR" diagnostics="BT-198_BT-543_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-543_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-ord']">
		<assert id="BT-195_BT-733_-Lot_R" role="ERROR" diagnostics="BT-195_BT-733_-Lot" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-733_-Lot_R</assert>
		<assert id="BT-196_BT-733_-Lot_A" role="ERROR" diagnostics="BT-196_BT-733_-Lot" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-733_-Lot_A</assert>
		<assert id="BT-196_BT-733_-Lot_B" role="ERROR" diagnostics="BT-196_BT-733_-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-733_-Lot_B</assert>
		<assert id="BT-196_BT-733_-Lot_C" role="ERROR" diagnostics="BT-196_BT-733_-Lot" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-733_-Lot_C</assert>
		<assert id="BT-197_BT-733_-Lot_R" role="ERROR" diagnostics="BT-197_BT-733_-Lot" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-733_-Lot_R</assert>
		<assert id="BT-198_BT-733_-Lot_R" role="ERROR" diagnostics="BT-198_BT-733_-Lot" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-733_-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:Prize">
		<assert id="BT-44-Lot_R" role="ERROR" diagnostics="BT-44-Lot" test="count(cbc:RankCode) &lt; 2">rule|text|BT-44-Lot_R</assert>
		<assert id="BT-45-Lot_A" role="ERROR" diagnostics="BT-45-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-45-Lot_A</assert>
		<assert id="BT-45-Lot_B" role="ERROR" diagnostics="BT-45-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-45-Lot_B</assert>
		<assert id="BT-45-Lot_C" role="ERROR" diagnostics="BT-45-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-45-Lot_C</assert>
		<assert id="BT-644-Lot_R" role="ERROR" diagnostics="BT-644-Lot" test="count(cbc:ValueAmount) &lt; 2">rule|text|BT-644-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:CallForTendersDocumentReference">
		<assert id="BT-14-Lot_R" role="ERROR" diagnostics="BT-14-Lot" test="count(cbc:DocumentType) &lt; 2">rule|text|BT-14-Lot_R</assert>
		<assert id="OPT-050-Lot_R" role="ERROR" diagnostics="OPT-050-Lot" test="count(cbc:DocumentStatusCode) &lt; 2">rule|text|OPT-050-Lot_R</assert>
		<assert id="OPT-140-Lot_R" role="ERROR" diagnostics="OPT-140-Lot" test="count(cbc:ID) &lt; 2">rule|text|OPT-140-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:CallForTendersDocumentReference[cbc:DocumentType/text()='restricted-document']">
		<assert id="BT-615-Lot_R" role="ERROR" diagnostics="BT-615-Lot" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|BT-615-Lot_R</assert>
		<assert id="BT-707-Lot_R" role="ERROR" diagnostics="BT-707-Lot" test="count(cbc:DocumentTypeCode) &lt; 2">rule|text|BT-707-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:CallForTendersDocumentReference[not(cbc:DocumentType/text()='restricted-document')]">
		<assert id="BT-15-Lot_R" role="ERROR" diagnostics="BT-15-Lot" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|BT-15-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:ContractExecutionRequirement[cbc:ExecutionRequirementCode/@listName='conditions']">
		<assert id="BT-70-Lot_A" role="ERROR" diagnostics="BT-70-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-70-Lot_A</assert>
		<assert id="BT-70-Lot_B" role="ERROR" diagnostics="BT-70-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-70-Lot_B</assert>
		<assert id="BT-70-Lot_C" role="ERROR" diagnostics="BT-70-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-70-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:ContractExecutionRequirement[cbc:ExecutionRequirementCode/@listName='customer-service']">
		<assert id="OPT-072-Lot_A" role="ERROR" diagnostics="OPT-072-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|OPT-072-Lot_A</assert>
		<assert id="OPT-072-Lot_B" role="ERROR" diagnostics="OPT-072-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|OPT-072-Lot_B</assert>
		<assert id="OPT-072-Lot_C" role="ERROR" diagnostics="OPT-072-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|OPT-072-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:ContractExecutionRequirement[cbc:ExecutionRequirementCode/@listName='reserved-execution']">
		<assert id="OPT-070-Lot_A" role="ERROR" diagnostics="OPT-070-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|OPT-070-Lot_A</assert>
		<assert id="OPT-070-Lot_B" role="ERROR" diagnostics="OPT-070-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|OPT-070-Lot_B</assert>
		<assert id="OPT-070-Lot_C" role="ERROR" diagnostics="OPT-070-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|OPT-070-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:EmploymentLegislationDocumentReference">
		<assert id="OPT-113-Lot-EmployLegis_R" role="ERROR" diagnostics="OPT-113-Lot-EmployLegis" test="count(cbc:ID) &lt; 2">rule|text|OPT-113-Lot-EmployLegis_R</assert>
		<assert id="OPT-130-Lot-EmployLegis_R" role="ERROR" diagnostics="OPT-130-Lot-EmployLegis" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|OPT-130-Lot-EmployLegis_R</assert>
		<assert id="OPT-301-Lot-EmployLegis_R" role="ERROR" diagnostics="OPT-301-Lot-EmployLegis" test="count(cac:IssuerParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-EmployLegis_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:EnvironmentalLegislationDocumentReference">
		<assert id="OPT-112-Lot-EnvironLegis_R" role="ERROR" diagnostics="OPT-112-Lot-EnvironLegis" test="count(cbc:ID) &lt; 2">rule|text|OPT-112-Lot-EnvironLegis_R</assert>
		<assert id="OPT-120-Lot-EnvironLegis_R" role="ERROR" diagnostics="OPT-120-Lot-EnvironLegis" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|OPT-120-Lot-EnvironLegis_R</assert>
		<assert id="OPT-301-Lot-EnvironLegis_R" role="ERROR" diagnostics="OPT-301-Lot-EnvironLegis" test="count(cac:IssuerParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-EnvironLegis_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:FiscalLegislationDocumentReference">
		<assert id="OPT-110-Lot-FiscalLegis_R" role="ERROR" diagnostics="OPT-110-Lot-FiscalLegis" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|OPT-110-Lot-FiscalLegis_R</assert>
		<assert id="OPT-111-Lot-FiscalLegis_R" role="ERROR" diagnostics="OPT-111-Lot-FiscalLegis" test="count(cbc:ID) &lt; 2">rule|text|OPT-111-Lot-FiscalLegis_R</assert>
		<assert id="OPT-301-Lot-FiscalLegis_R" role="ERROR" diagnostics="OPT-301-Lot-FiscalLegis" test="count(cac:IssuerParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Lot-FiscalLegis_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:PaymentTerms">
		<assert id="BT-77-Lot_A" role="ERROR" diagnostics="BT-77-Lot" test="count(cbc:Note[@languageID = preceding-sibling::cbc:Note/@languageID]) = 0">rule|text|BT-77-Lot_A</assert>
		<assert id="BT-77-Lot_B" role="ERROR" diagnostics="BT-77-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Note/@languageID = $lg) or count(cbc:Note) = 0">rule|text|BT-77-Lot_B</assert>
		<assert id="BT-77-Lot_C" role="ERROR" diagnostics="BT-77-Lot" test="(every $lg in (cbc:Note/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Note) = 0">rule|text|BT-77-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:PostAwardProcess">
		<assert id="BT-92-Lot_R" role="ERROR" diagnostics="BT-92-Lot" test="count(cbc:ElectronicOrderUsageIndicator) &lt; 2">rule|text|BT-92-Lot_R</assert>
		<assert id="BT-93-Lot_R" role="ERROR" diagnostics="BT-93-Lot" test="count(cbc:ElectronicPaymentUsageIndicator) &lt; 2">rule|text|BT-93-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:SecurityClearanceTerm">
		<assert id="BT-578-Lot_R" role="ERROR" diagnostics="BT-578-Lot" test="count(cbc:Code) &lt; 2">rule|text|BT-578-Lot_R</assert>
		<assert id="BT-732-Lot_A" role="ERROR" diagnostics="BT-732-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-732-Lot_A</assert>
		<assert id="BT-732-Lot_B" role="ERROR" diagnostics="BT-732-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-732-Lot_B</assert>
		<assert id="BT-732-Lot_C" role="ERROR" diagnostics="BT-732-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-732-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)][not(cac:SpecificTendererRequirement/cbc:TendererRequirementTypeCode[@listName='reserved-procurement'])]">
		<assert id="BT-771-Lot_R" role="ERROR" diagnostics="BT-771-Lot" test="count(cac:SpecificTendererRequirement/cbc:TendererRequirementTypeCode[@listName='missing-info-submission']) &lt; 2">rule|text|BT-771-Lot_R</assert>
		<assert id="BT-772-Lot_A" role="ERROR" diagnostics="BT-772-Lot" test="count(cac:SpecificTendererRequirement[./cbc:TendererRequirementTypeCode/@listName='missing-info-submission']/cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-772-Lot_A</assert>
		<assert id="BT-772-Lot_B" role="ERROR" diagnostics="BT-772-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cac:SpecificTendererRequirement[./cbc:TendererRequirementTypeCode/@listName='missing-info-submission']/cbc:Description/@languageID = $lg) or count(cac:SpecificTendererRequirement[./cbc:TendererRequirementTypeCode/@listName='missing-info-submission']/cbc:Description) = 0">rule|text|BT-772-Lot_B</assert>
		<assert id="BT-772-Lot_C" role="ERROR" diagnostics="BT-772-Lot" test="(every $lg in (cac:SpecificTendererRequirement[./cbc:TendererRequirementTypeCode/@listName='missing-info-submission']/cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cac:SpecificTendererRequirement[./cbc:TendererRequirementTypeCode/@listName='missing-info-submission']/cbc:Description) = 0">rule|text|BT-772-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:SelectionCriteria">
		<assert id="BT-40-Lot_R" role="ERROR" diagnostics="BT-40-Lot" test="count(efbc:SecondStageIndicator) &lt; 2">rule|text|BT-40-Lot_R</assert>
		<assert id="BT-748-Lot_R" role="ERROR" diagnostics="BT-748-Lot" test="count(cbc:CalculationExpressionCode[@listName='usage']) &lt; 2">rule|text|BT-748-Lot_R</assert>
		<assert id="BT-749-Lot_A" role="ERROR" diagnostics="BT-749-Lot" test="count(cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-749-Lot_A</assert>
		<assert id="BT-749-Lot_B" role="ERROR" diagnostics="BT-749-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Name/@languageID = $lg) or count(cbc:Name) = 0">rule|text|BT-749-Lot_B</assert>
		<assert id="BT-749-Lot_C" role="ERROR" diagnostics="BT-749-Lot" test="(every $lg in (cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Name) = 0">rule|text|BT-749-Lot_C</assert>
		<assert id="BT-750-Lot_A" role="ERROR" diagnostics="BT-750-Lot" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-750-Lot_A</assert>
		<assert id="BT-750-Lot_B" role="ERROR" diagnostics="BT-750-Lot" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-750-Lot_B</assert>
		<assert id="BT-750-Lot_C" role="ERROR" diagnostics="BT-750-Lot" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-750-Lot_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:SelectionCriteria/efac:CriterionParameter">
		<assert id="BT-7531-Lot_R" role="ERROR" diagnostics="BT-7531-Lot" test="count(efbc:ParameterCode[@listName='number-weight']) &lt; 2">rule|text|BT-7531-Lot_R</assert>
		<assert id="BT-7532-Lot_R" role="ERROR" diagnostics="BT-7532-Lot" test="count(efbc:ParameterCode[@listName='number-threshold']) &lt; 2">rule|text|BT-7532-Lot_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']">
		<assert id="BT-137-LotsGroup_R" role="ERROR" diagnostics="BT-137-LotsGroup" test="count(cbc:ID) &lt; 2">rule|text|BT-137-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:ProcurementProject">
		<assert id="BT-21-LotsGroup_A" role="ERROR" diagnostics="BT-21-LotsGroup" test="count(cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-21-LotsGroup_A</assert>
		<assert id="BT-21-LotsGroup_B" role="ERROR" diagnostics="BT-21-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Name/@languageID = $lg) or count(cbc:Name) = 0">rule|text|BT-21-LotsGroup_B</assert>
		<assert id="BT-21-LotsGroup_C" role="ERROR" diagnostics="BT-21-LotsGroup" test="(every $lg in (cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Name) = 0">rule|text|BT-21-LotsGroup_C</assert>
		<assert id="BT-22-LotsGroup_R" role="ERROR" diagnostics="BT-22-LotsGroup" test="count(cbc:ID) &lt; 2">rule|text|BT-22-LotsGroup_R</assert>
		<assert id="BT-24-LotsGroup_A" role="ERROR" diagnostics="BT-24-LotsGroup" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-24-LotsGroup_A</assert>
		<assert id="BT-24-LotsGroup_B" role="ERROR" diagnostics="BT-24-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-24-LotsGroup_B</assert>
		<assert id="BT-24-LotsGroup_C" role="ERROR" diagnostics="BT-24-LotsGroup" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-24-LotsGroup_C</assert>
		<assert id="BT-300-LotsGroup_A" role="ERROR" diagnostics="BT-300-LotsGroup" test="count(cbc:Note[@languageID = preceding-sibling::cbc:Note/@languageID]) = 0">rule|text|BT-300-LotsGroup_A</assert>
		<assert id="BT-300-LotsGroup_B" role="ERROR" diagnostics="BT-300-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Note/@languageID = $lg) or count(cbc:Note) = 0">rule|text|BT-300-LotsGroup_B</assert>
		<assert id="BT-300-LotsGroup_C" role="ERROR" diagnostics="BT-300-LotsGroup" test="(every $lg in (cbc:Note/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Note) = 0">rule|text|BT-300-LotsGroup_C</assert>
		<assert id="BT-726-LotsGroup_R" role="ERROR" diagnostics="BT-726-LotsGroup" test="count(cbc:SMESuitableIndicator) &lt; 2">rule|text|BT-726-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:ProcurementProject/cac:RequestedTenderTotal">
		<assert id="BT-27-LotsGroup_R" role="ERROR" diagnostics="BT-27-LotsGroup" test="count(cbc:EstimatedOverallContractAmount) &lt; 2">rule|text|BT-27-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingProcess/cac:FrameworkAgreement">
		<assert id="BT-157-LotsGroup_R" role="ERROR" diagnostics="BT-157-LotsGroup" test="count(cbc:EstimatedMaximumValueAmount) &lt; 2">rule|text|BT-157-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingProcess/cac:FrameworkAgreement/cac:SubsequentProcessTenderRequirement">
		<assert id="OPT-090-LotsGroup_R" role="ERROR" diagnostics="OPT-090-LotsGroup" test="count(cbc:Name) &lt; 2">rule|text|OPT-090-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion">
		<assert id="BT-543-LotsGroup_A" role="ERROR" diagnostics="BT-543-LotsGroup" test="count(cbc:CalculationExpression[@languageID = preceding-sibling::cbc:CalculationExpression/@languageID]) = 0">rule|text|BT-543-LotsGroup_A</assert>
		<assert id="BT-543-LotsGroup_B" role="ERROR" diagnostics="BT-543-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:CalculationExpression/@languageID = $lg) or count(cbc:CalculationExpression) = 0">rule|text|BT-543-LotsGroup_B</assert>
		<assert id="BT-543-LotsGroup_C" role="ERROR" diagnostics="BT-543-LotsGroup" test="(every $lg in (cbc:CalculationExpression/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:CalculationExpression) = 0">rule|text|BT-543-LotsGroup_C</assert>
		<assert id="BT-733-LotsGroup_A" role="ERROR" diagnostics="BT-733-LotsGroup" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-733-LotsGroup_A</assert>
		<assert id="BT-733-LotsGroup_B" role="ERROR" diagnostics="BT-733-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-733-LotsGroup_B</assert>
		<assert id="BT-733-LotsGroup_C" role="ERROR" diagnostics="BT-733-LotsGroup" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-733-LotsGroup_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion">
		<assert id="BT-540-LotsGroup_A" role="ERROR" diagnostics="BT-540-LotsGroup" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-540-LotsGroup_A</assert>
		<assert id="BT-540-LotsGroup_B" role="ERROR" diagnostics="BT-540-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-540-LotsGroup_B</assert>
		<assert id="BT-540-LotsGroup_C" role="ERROR" diagnostics="BT-540-LotsGroup" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-540-LotsGroup_C</assert>
		<assert id="BT-734-LotsGroup_A" role="ERROR" diagnostics="BT-734-LotsGroup" test="count(cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-734-LotsGroup_A</assert>
		<assert id="BT-734-LotsGroup_B" role="ERROR" diagnostics="BT-734-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Name/@languageID = $lg) or count(cbc:Name) = 0">rule|text|BT-734-LotsGroup_B</assert>
		<assert id="BT-734-LotsGroup_C" role="ERROR" diagnostics="BT-734-LotsGroup" test="(every $lg in (cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Name) = 0">rule|text|BT-734-LotsGroup_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter">
		<assert id="BT-5421-LotsGroup_R" role="ERROR" diagnostics="BT-5421-LotsGroup" test="count(efbc:ParameterCode[@listName='number-weight']) &lt; 2">rule|text|BT-5421-LotsGroup_R</assert>
		<assert id="BT-5422-LotsGroup_R" role="ERROR" diagnostics="BT-5422-LotsGroup" test="count(efbc:ParameterCode[@listName='number-fixed']) &lt; 2">rule|text|BT-5422-LotsGroup_R</assert>
		<assert id="BT-5423-LotsGroup_R" role="ERROR" diagnostics="BT-5423-LotsGroup" test="count(efbc:ParameterCode[@listName='number-threshold']) &lt; 2">rule|text|BT-5423-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-num']">
		<assert id="BT-195_BT-541_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-541_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-541_-LotsGroup_R</assert>
		<assert id="BT-196_BT-541_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-541_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-541_-LotsGroup_A</assert>
		<assert id="BT-196_BT-541_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-541_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-541_-LotsGroup_B</assert>
		<assert id="BT-196_BT-541_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-541_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-541_-LotsGroup_C</assert>
		<assert id="BT-197_BT-541_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-541_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-541_-LotsGroup_R</assert>
		<assert id="BT-198_BT-541_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-541_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-541_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-fixed']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-fix']">
		<assert id="BT-195_BT-5422_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-5422_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-5422_-LotsGroup_R</assert>
		<assert id="BT-196_BT-5422_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-5422_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-5422_-LotsGroup_A</assert>
		<assert id="BT-196_BT-5422_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-5422_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5422_-LotsGroup_B</assert>
		<assert id="BT-196_BT-5422_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-5422_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5422_-LotsGroup_C</assert>
		<assert id="BT-197_BT-5422_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-5422_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-5422_-LotsGroup_R</assert>
		<assert id="BT-198_BT-5422_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-5422_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-5422_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-threshold']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-thr']">
		<assert id="BT-195_BT-5423_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-5423_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-5423_-LotsGroup_R</assert>
		<assert id="BT-196_BT-5423_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-5423_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-5423_-LotsGroup_A</assert>
		<assert id="BT-196_BT-5423_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-5423_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5423_-LotsGroup_B</assert>
		<assert id="BT-196_BT-5423_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-5423_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5423_-LotsGroup_C</assert>
		<assert id="BT-197_BT-5423_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-5423_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-5423_-LotsGroup_R</assert>
		<assert id="BT-198_BT-5423_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-5423_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-5423_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-weight']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-wei']">
		<assert id="BT-195_BT-5421_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-5421_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-5421_-LotsGroup_R</assert>
		<assert id="BT-196_BT-5421_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-5421_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-5421_-LotsGroup_A</assert>
		<assert id="BT-196_BT-5421_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-5421_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5421_-LotsGroup_B</assert>
		<assert id="BT-196_BT-5421_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-5421_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-5421_-LotsGroup_C</assert>
		<assert id="BT-197_BT-5421_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-5421_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-5421_-LotsGroup_R</assert>
		<assert id="BT-198_BT-5421_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-5421_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-5421_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-des']">
		<assert id="BT-195_BT-540_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-540_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-540_-LotsGroup_R</assert>
		<assert id="BT-196_BT-540_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-540_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-540_-LotsGroup_A</assert>
		<assert id="BT-196_BT-540_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-540_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-540_-LotsGroup_B</assert>
		<assert id="BT-196_BT-540_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-540_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-540_-LotsGroup_C</assert>
		<assert id="BT-197_BT-540_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-540_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-540_-LotsGroup_R</assert>
		<assert id="BT-198_BT-540_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-540_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-540_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-nam']">
		<assert id="BT-195_BT-734_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-734_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-734_-LotsGroup_R</assert>
		<assert id="BT-196_BT-734_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-734_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-734_-LotsGroup_A</assert>
		<assert id="BT-196_BT-734_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-734_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-734_-LotsGroup_B</assert>
		<assert id="BT-196_BT-734_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-734_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-734_-LotsGroup_C</assert>
		<assert id="BT-197_BT-734_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-734_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-734_-LotsGroup_R</assert>
		<assert id="BT-198_BT-734_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-734_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-734_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-typ']">
		<assert id="BT-195_BT-539_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-539_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-539_-LotsGroup_R</assert>
		<assert id="BT-196_BT-539_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-539_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-539_-LotsGroup_A</assert>
		<assert id="BT-196_BT-539_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-539_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-539_-LotsGroup_B</assert>
		<assert id="BT-196_BT-539_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-539_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-539_-LotsGroup_C</assert>
		<assert id="BT-197_BT-539_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-539_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-539_-LotsGroup_R</assert>
		<assert id="BT-198_BT-539_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-539_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-539_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-com']">
		<assert id="BT-195_BT-543_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-543_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-543_-LotsGroup_R</assert>
		<assert id="BT-196_BT-543_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-543_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-543_-LotsGroup_A</assert>
		<assert id="BT-196_BT-543_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-543_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-543_-LotsGroup_B</assert>
		<assert id="BT-196_BT-543_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-543_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-543_-LotsGroup_C</assert>
		<assert id="BT-197_BT-543_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-543_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-543_-LotsGroup_R</assert>
		<assert id="BT-198_BT-543_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-543_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-543_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-ord']">
		<assert id="BT-195_BT-733_-LotsGroup_R" role="ERROR" diagnostics="BT-195_BT-733_-LotsGroup" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-733_-LotsGroup_R</assert>
		<assert id="BT-196_BT-733_-LotsGroup_A" role="ERROR" diagnostics="BT-196_BT-733_-LotsGroup" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-733_-LotsGroup_A</assert>
		<assert id="BT-196_BT-733_-LotsGroup_B" role="ERROR" diagnostics="BT-196_BT-733_-LotsGroup" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-733_-LotsGroup_B</assert>
		<assert id="BT-196_BT-733_-LotsGroup_C" role="ERROR" diagnostics="BT-196_BT-733_-LotsGroup" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-733_-LotsGroup_C</assert>
		<assert id="BT-197_BT-733_-LotsGroup_R" role="ERROR" diagnostics="BT-197_BT-733_-LotsGroup" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-733_-LotsGroup_R</assert>
		<assert id="BT-198_BT-733_-LotsGroup_R" role="ERROR" diagnostics="BT-198_BT-733_-LotsGroup" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-733_-LotsGroup_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']">
		<assert id="BT-137-Part_R" role="ERROR" diagnostics="BT-137-Part" test="count(cbc:ID) &lt; 2">rule|text|BT-137-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject">
		<assert id="BT-21-Part_A" role="ERROR" diagnostics="BT-21-Part" test="count(cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-21-Part_A</assert>
		<assert id="BT-21-Part_B" role="ERROR" diagnostics="BT-21-Part" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Name/@languageID = $lg) or count(cbc:Name) = 0">rule|text|BT-21-Part_B</assert>
		<assert id="BT-21-Part_C" role="ERROR" diagnostics="BT-21-Part" test="(every $lg in (cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Name) = 0">rule|text|BT-21-Part_C</assert>
		<assert id="BT-22-Part_R" role="ERROR" diagnostics="BT-22-Part" test="count(cbc:ID) &lt; 2">rule|text|BT-22-Part_R</assert>
		<assert id="BT-23-Part_R" role="ERROR" diagnostics="BT-23-Part" test="count(cbc:ProcurementTypeCode[@listName='contract-nature']) &lt; 2">rule|text|BT-23-Part_R</assert>
		<assert id="BT-24-Part_A" role="ERROR" diagnostics="BT-24-Part" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-24-Part_A</assert>
		<assert id="BT-24-Part_B" role="ERROR" diagnostics="BT-24-Part" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-24-Part_B</assert>
		<assert id="BT-24-Part_C" role="ERROR" diagnostics="BT-24-Part" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-24-Part_C</assert>
		<assert id="BT-262-Part_R" role="ERROR" diagnostics="BT-262-Part" test="count(cac:MainCommodityClassification/cbc:ItemClassificationCode) &lt; 2">rule|text|BT-262-Part_R</assert>
		<assert id="BT-300-Part_A" role="ERROR" diagnostics="BT-300-Part" test="count(cbc:Note[@languageID = preceding-sibling::cbc:Note/@languageID]) = 0">rule|text|BT-300-Part_A</assert>
		<assert id="BT-300-Part_B" role="ERROR" diagnostics="BT-300-Part" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Note/@languageID = $lg) or count(cbc:Note) = 0">rule|text|BT-300-Part_B</assert>
		<assert id="BT-300-Part_C" role="ERROR" diagnostics="BT-300-Part" test="(every $lg in (cbc:Note/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Note) = 0">rule|text|BT-300-Part_C</assert>
		<assert id="BT-726-Part_R" role="ERROR" diagnostics="BT-726-Part" test="count(cbc:SMESuitableIndicator) &lt; 2">rule|text|BT-726-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cac:AdditionalCommodityClassification">
		<assert id="BT-26_a_-Part_R" role="ERROR" diagnostics="BT-26_a_-Part" test="count(cbc:ItemClassificationCode/@listName) &lt; 2">rule|text|BT-26_a_-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cac:MainCommodityClassification/cbc:ItemClassificationCode">
		<assert id="BT-26_m_-Part_R" role="ERROR" diagnostics="BT-26_m_-Part" test="count(@listName) &lt; 2">rule|text|BT-26_m_-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cac:PlannedPeriod">
		<assert id="BT-36-Part_R" role="ERROR" diagnostics="BT-36-Part" test="count(cbc:DurationMeasure) &lt; 2">rule|text|BT-36-Part_R</assert>
		<assert id="BT-536-Part_R" role="ERROR" diagnostics="BT-536-Part" test="count(cbc:StartDate) &lt; 2">rule|text|BT-536-Part_R</assert>
		<assert id="BT-537-Part_R" role="ERROR" diagnostics="BT-537-Part" test="count(cbc:EndDate) &lt; 2">rule|text|BT-537-Part_R</assert>
		<assert id="BT-538-Part_R" role="ERROR" diagnostics="BT-538-Part" test="count(cbc:DescriptionCode) &lt; 2">rule|text|BT-538-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cac:RealizedLocation">
		<assert id="BT-5071-Part_R" role="ERROR" diagnostics="BT-5071-Part" test="count(cac:Address/cbc:CountrySubentityCode) &lt; 2">rule|text|BT-5071-Part_R</assert>
		<assert id="BT-5101_a_-Part_R" role="ERROR" diagnostics="BT-5101_a_-Part" test="count(cac:Address/cbc:StreetName) &lt; 2">rule|text|BT-5101_a_-Part_R</assert>
		<assert id="BT-5101_b_-Part_R" role="ERROR" diagnostics="BT-5101_b_-Part" test="count(cac:Address/cbc:AdditionalStreetName) &lt; 2">rule|text|BT-5101_b_-Part_R</assert>
		<assert id="BT-5101_c_-Part_R" role="ERROR" diagnostics="BT-5101_c_-Part" test="count(cac:Address/cac:AddressLine/cbc:Line) &lt; 2">rule|text|BT-5101_c_-Part_R</assert>
		<assert id="BT-5121-Part_R" role="ERROR" diagnostics="BT-5121-Part" test="count(cac:Address/cbc:PostalZone) &lt; 2">rule|text|BT-5121-Part_R</assert>
		<assert id="BT-5131-Part_R" role="ERROR" diagnostics="BT-5131-Part" test="count(cac:Address/cbc:CityName) &lt; 2">rule|text|BT-5131-Part_R</assert>
		<assert id="BT-5141-Part_R" role="ERROR" diagnostics="BT-5141-Part" test="count(cac:Address/cac:Country/cbc:IdentificationCode) &lt; 2">rule|text|BT-5141-Part_R</assert>
		<assert id="BT-727-Part_R" role="ERROR" diagnostics="BT-727-Part" test="count(cac:Address/cbc:Region) &lt; 2">rule|text|BT-727-Part_R</assert>
		<assert id="BT-728-Part_A" role="ERROR" diagnostics="BT-728-Part" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-728-Part_A</assert>
		<assert id="BT-728-Part_B" role="ERROR" diagnostics="BT-728-Part" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-728-Part_B</assert>
		<assert id="BT-728-Part_C" role="ERROR" diagnostics="BT-728-Part" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-728-Part_C</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cac:RequestedTenderTotal">
		<assert id="BT-27-Part_R" role="ERROR" diagnostics="BT-27-Part" test="count(cbc:EstimatedOverallContractAmount) &lt; 2">rule|text|BT-27-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingProcess">
		<assert id="BT-115-Part_R" role="ERROR" diagnostics="BT-115-Part" test="count(cbc:GovernmentAgreementConstraintIndicator) &lt; 2">rule|text|BT-115-Part_R</assert>
		<assert id="BT-13_d_-Part_R" role="ERROR" diagnostics="BT-13_d_-Part" test="count(cac:AdditionalInformationRequestPeriod/cbc:EndDate) &lt; 2">rule|text|BT-13_d_-Part_R</assert>
		<assert id="BT-13_t_-Part_R" role="ERROR" diagnostics="BT-13_t_-Part" test="count(cac:AdditionalInformationRequestPeriod/cbc:EndTime) &lt; 2">rule|text|BT-13_t_-Part_R</assert>
		<assert id="BT-765-Part_R" role="ERROR" diagnostics="BT-765-Part" test="count(cac:ContractingSystem/cbc:ContractingSystemTypeCode[@listName='framework-agreement']) &lt; 2">rule|text|BT-765-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingProcess/cac:NoticeDocumentReference">
		<assert id="BT-125_i_-Part_R" role="ERROR" diagnostics="BT-125_i_-Part" test="count(cbc:ID) &lt; 2">rule|text|BT-125_i_-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingProcess/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension">
		<assert id="BT-632-Part_R" role="ERROR" diagnostics="BT-632-Part" test="count(efbc:AccessToolName) &lt; 2">rule|text|BT-632-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingTerms">
		<assert id="BT-736-Part_R" role="ERROR" diagnostics="BT-736-Part" test="count(cac:ContractExecutionRequirement/cbc:ExecutionRequirementCode[@listName='reserved-execution']) &lt; 2">rule|text|BT-736-Part_R</assert>
		<assert id="OPT-301-Part-AddInfo_R" role="ERROR" diagnostics="OPT-301-Part-AddInfo" test="count(cac:AdditionalInformationParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-AddInfo_R</assert>
		<assert id="OPT-301-Part-DocProvider_R" role="ERROR" diagnostics="OPT-301-Part-DocProvider" test="count(cac:DocumentProviderParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-DocProvider_R</assert>
		<assert id="OPT-301-Part-TenderEval_R" role="ERROR" diagnostics="OPT-301-Part-TenderEval" test="count(cac:TenderEvaluationParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-TenderEval_R</assert>
		<assert id="OPT-301-Part-TenderReceipt_R" role="ERROR" diagnostics="OPT-301-Part-TenderReceipt" test="count(cac:TenderRecipientParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-TenderReceipt_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingTerms/cac:AppealTerms">
		<assert id="OPT-301-Part-Mediator_R" role="ERROR" diagnostics="OPT-301-Part-Mediator" test="count(cac:MediationParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-Mediator_R</assert>
		<assert id="OPT-301-Part-ReviewInfo_R" role="ERROR" diagnostics="OPT-301-Part-ReviewInfo" test="count(cac:AppealInformationParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-ReviewInfo_R</assert>
		<assert id="OPT-301-Part-ReviewOrg_R" role="ERROR" diagnostics="OPT-301-Part-ReviewOrg" test="count(cac:AppealReceiverParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-ReviewOrg_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingTerms/cac:CallForTendersDocumentReference">
		<assert id="BT-14-Part_R" role="ERROR" diagnostics="BT-14-Part" test="count(cbc:DocumentType) &lt; 2">rule|text|BT-14-Part_R</assert>
		<assert id="OPT-050-Part_R" role="ERROR" diagnostics="OPT-050-Part" test="count(cbc:DocumentStatusCode) &lt; 2">rule|text|OPT-050-Part_R</assert>
		<assert id="OPT-140-Part_R" role="ERROR" diagnostics="OPT-140-Part" test="count(cbc:ID) &lt; 2">rule|text|OPT-140-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingTerms/cac:CallForTendersDocumentReference[cbc:DocumentType/text()='restricted-document']">
		<assert id="BT-615-Part_R" role="ERROR" diagnostics="BT-615-Part" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|BT-615-Part_R</assert>
		<assert id="BT-707-Part_R" role="ERROR" diagnostics="BT-707-Part" test="count(cbc:DocumentTypeCode) &lt; 2">rule|text|BT-707-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingTerms/cac:CallForTendersDocumentReference[not(cbc:DocumentType/text()='restricted-document')]">
		<assert id="BT-15-Part_R" role="ERROR" diagnostics="BT-15-Part" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|BT-15-Part_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingTerms/cac:EmploymentLegislationDocumentReference">
		<assert id="OPT-113-Part-EmployLegis_R" role="ERROR" diagnostics="OPT-113-Part-EmployLegis" test="count(cbc:ID) &lt; 2">rule|text|OPT-113-Part-EmployLegis_R</assert>
		<assert id="OPT-130-Part-EmployLegis_R" role="ERROR" diagnostics="OPT-130-Part-EmployLegis" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|OPT-130-Part-EmployLegis_R</assert>
		<assert id="OPT-301-Part-EmployLegis_R" role="ERROR" diagnostics="OPT-301-Part-EmployLegis" test="count(cac:IssuerParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-EmployLegis_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingTerms/cac:EnvironmentalLegislationDocumentReference">
		<assert id="OPT-112-Part-EnvironLegis_R" role="ERROR" diagnostics="OPT-112-Part-EnvironLegis" test="count(cbc:ID) &lt; 2">rule|text|OPT-112-Part-EnvironLegis_R</assert>
		<assert id="OPT-120-Part-EnvironLegis_R" role="ERROR" diagnostics="OPT-120-Part-EnvironLegis" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|OPT-120-Part-EnvironLegis_R</assert>
		<assert id="OPT-301-Part-EnvironLegis_R" role="ERROR" diagnostics="OPT-301-Part-EnvironLegis" test="count(cac:IssuerParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-EnvironLegis_R</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:TenderingTerms/cac:FiscalLegislationDocumentReference">
		<assert id="OPT-110-Part-FiscalLegis_R" role="ERROR" diagnostics="OPT-110-Part-FiscalLegis" test="count(cac:Attachment/cac:ExternalReference/cbc:URI) &lt; 2">rule|text|OPT-110-Part-FiscalLegis_R</assert>
		<assert id="OPT-111-Part-FiscalLegis_R" role="ERROR" diagnostics="OPT-111-Part-FiscalLegis" test="count(cbc:ID) &lt; 2">rule|text|OPT-111-Part-FiscalLegis_R</assert>
		<assert id="OPT-301-Part-FiscalLegis_R" role="ERROR" diagnostics="OPT-301-Part-FiscalLegis" test="count(cac:IssuerParty/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-Part-FiscalLegis_R</assert>
	</rule>
	<rule context="/*/cac:SenderParty/cac:Contact">
		<assert id="OPP-131-Business_R" role="ERROR" diagnostics="OPP-131-Business" test="count(cbc:ElectronicMail) &lt; 2">rule|text|OPP-131-Business_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess">
		<assert id="BT-105-Procedure_R" role="ERROR" diagnostics="BT-105-Procedure" test="count(cbc:ProcedureCode) &lt; 2">rule|text|BT-105-Procedure_R</assert>
		<assert id="BT-634-Procedure_R" role="ERROR" diagnostics="BT-634-Procedure" test="count(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efbc:ProcedureRelaunchIndicator) &lt; 2">rule|text|BT-634-Procedure_R</assert>
		<assert id="BT-756-Procedure_R" role="ERROR" diagnostics="BT-756-Procedure" test="count(cbc:TerminatedIndicator) &lt; 2">rule|text|BT-756-Procedure_R</assert>
		<assert id="BT-763-Procedure_R" role="ERROR" diagnostics="BT-763-Procedure" test="count(cbc:PartPresentationCode) &lt; 2">rule|text|BT-763-Procedure_R</assert>
		<assert id="BT-88-Procedure_A" role="ERROR" diagnostics="BT-88-Procedure" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-88-Procedure_A</assert>
		<assert id="BT-88-Procedure_B" role="ERROR" diagnostics="BT-88-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-88-Procedure_B</assert>
		<assert id="BT-88-Procedure_C" role="ERROR" diagnostics="BT-88-Procedure" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-88-Procedure_C</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification">
		<assert id="BT-106-Procedure_R" role="ERROR" diagnostics="BT-106-Procedure" test="count(cbc:ProcessReasonCode[@listName='accelerated-procedure']) &lt; 2">rule|text|BT-106-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='accelerated-procedure']">
		<assert id="BT-1351-Procedure_A" role="ERROR" diagnostics="BT-1351-Procedure" test="count(cbc:ProcessReason[@languageID = preceding-sibling::cbc:ProcessReason/@languageID]) = 0">rule|text|BT-1351-Procedure_A</assert>
		<assert id="BT-1351-Procedure_B" role="ERROR" diagnostics="BT-1351-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:ProcessReason/@languageID = $lg) or count(cbc:ProcessReason) = 0">rule|text|BT-1351-Procedure_B</assert>
		<assert id="BT-1351-Procedure_C" role="ERROR" diagnostics="BT-1351-Procedure" test="(every $lg in (cbc:ProcessReason/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:ProcessReason) = 0">rule|text|BT-1351-Procedure_C</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='accelerated-procedure']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='pro-acc']">
		<assert id="BT-195_BT-106_-Procedure_R" role="ERROR" diagnostics="BT-195_BT-106_-Procedure" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-106_-Procedure_R</assert>
		<assert id="BT-196_BT-106_-Procedure_A" role="ERROR" diagnostics="BT-196_BT-106_-Procedure" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-106_-Procedure_A</assert>
		<assert id="BT-196_BT-106_-Procedure_B" role="ERROR" diagnostics="BT-196_BT-106_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-106_-Procedure_B</assert>
		<assert id="BT-196_BT-106_-Procedure_C" role="ERROR" diagnostics="BT-196_BT-106_-Procedure" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-106_-Procedure_C</assert>
		<assert id="BT-197_BT-106_-Procedure_R" role="ERROR" diagnostics="BT-197_BT-106_-Procedure" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-106_-Procedure_R</assert>
		<assert id="BT-198_BT-106_-Procedure_R" role="ERROR" diagnostics="BT-198_BT-106_-Procedure" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-106_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='accelerated-procedure']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='pro-acc-jus']">
		<assert id="BT-195_BT-1351_-Procedure_R" role="ERROR" diagnostics="BT-195_BT-1351_-Procedure" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-1351_-Procedure_R</assert>
		<assert id="BT-196_BT-1351_-Procedure_A" role="ERROR" diagnostics="BT-196_BT-1351_-Procedure" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-1351_-Procedure_A</assert>
		<assert id="BT-196_BT-1351_-Procedure_B" role="ERROR" diagnostics="BT-196_BT-1351_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-1351_-Procedure_B</assert>
		<assert id="BT-196_BT-1351_-Procedure_C" role="ERROR" diagnostics="BT-196_BT-1351_-Procedure" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-1351_-Procedure_C</assert>
		<assert id="BT-197_BT-1351_-Procedure_R" role="ERROR" diagnostics="BT-197_BT-1351_-Procedure" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-1351_-Procedure_R</assert>
		<assert id="BT-198_BT-1351_-Procedure_R" role="ERROR" diagnostics="BT-198_BT-1351_-Procedure" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-1351_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='direct-award-justification']">
		<assert id="BT-1252-Procedure_R" role="ERROR" diagnostics="BT-1252-Procedure" test="count(cbc:Description) &lt; 2">rule|text|BT-1252-Procedure_R</assert>
		<assert id="BT-135-Procedure_A" role="ERROR" diagnostics="BT-135-Procedure" test="count(cbc:ProcessReason[@languageID = preceding-sibling::cbc:ProcessReason/@languageID]) = 0">rule|text|BT-135-Procedure_A</assert>
		<assert id="BT-135-Procedure_B" role="ERROR" diagnostics="BT-135-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:ProcessReason/@languageID = $lg) or count(cbc:ProcessReason) = 0">rule|text|BT-135-Procedure_B</assert>
		<assert id="BT-135-Procedure_C" role="ERROR" diagnostics="BT-135-Procedure" test="(every $lg in (cbc:ProcessReason/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:ProcessReason) = 0">rule|text|BT-135-Procedure_C</assert>
		<assert id="BT-136-Procedure_R" role="ERROR" diagnostics="BT-136-Procedure" test="count(cbc:ProcessReasonCode) &lt; 2">rule|text|BT-136-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='direct-award-justification']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='dir-awa-jus']">
		<assert id="BT-195_BT-136_-Procedure_R" role="ERROR" diagnostics="BT-195_BT-136_-Procedure" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-136_-Procedure_R</assert>
		<assert id="BT-196_BT-136_-Procedure_A" role="ERROR" diagnostics="BT-196_BT-136_-Procedure" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-136_-Procedure_A</assert>
		<assert id="BT-196_BT-136_-Procedure_B" role="ERROR" diagnostics="BT-196_BT-136_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-136_-Procedure_B</assert>
		<assert id="BT-196_BT-136_-Procedure_C" role="ERROR" diagnostics="BT-196_BT-136_-Procedure" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-136_-Procedure_C</assert>
		<assert id="BT-197_BT-136_-Procedure_R" role="ERROR" diagnostics="BT-197_BT-136_-Procedure" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-136_-Procedure_R</assert>
		<assert id="BT-198_BT-136_-Procedure_R" role="ERROR" diagnostics="BT-198_BT-136_-Procedure" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-136_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='direct-award-justification']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='dir-awa-pre']">
		<assert id="BT-195_BT-1252_-Procedure_R" role="ERROR" diagnostics="BT-195_BT-1252_-Procedure" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-1252_-Procedure_R</assert>
		<assert id="BT-196_BT-1252_-Procedure_A" role="ERROR" diagnostics="BT-196_BT-1252_-Procedure" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-1252_-Procedure_A</assert>
		<assert id="BT-196_BT-1252_-Procedure_B" role="ERROR" diagnostics="BT-196_BT-1252_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-1252_-Procedure_B</assert>
		<assert id="BT-196_BT-1252_-Procedure_C" role="ERROR" diagnostics="BT-196_BT-1252_-Procedure" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-1252_-Procedure_C</assert>
		<assert id="BT-197_BT-1252_-Procedure_R" role="ERROR" diagnostics="BT-197_BT-1252_-Procedure" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-1252_-Procedure_R</assert>
		<assert id="BT-198_BT-1252_-Procedure_R" role="ERROR" diagnostics="BT-198_BT-1252_-Procedure" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-1252_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='direct-award-justification']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='dir-awa-tex']">
		<assert id="BT-195_BT-135_-Procedure_R" role="ERROR" diagnostics="BT-195_BT-135_-Procedure" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-135_-Procedure_R</assert>
		<assert id="BT-196_BT-135_-Procedure_A" role="ERROR" diagnostics="BT-196_BT-135_-Procedure" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-135_-Procedure_A</assert>
		<assert id="BT-196_BT-135_-Procedure_B" role="ERROR" diagnostics="BT-196_BT-135_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-135_-Procedure_B</assert>
		<assert id="BT-196_BT-135_-Procedure_C" role="ERROR" diagnostics="BT-196_BT-135_-Procedure" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-135_-Procedure_C</assert>
		<assert id="BT-197_BT-135_-Procedure_R" role="ERROR" diagnostics="BT-197_BT-135_-Procedure" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-135_-Procedure_R</assert>
		<assert id="BT-198_BT-135_-Procedure_R" role="ERROR" diagnostics="BT-198_BT-135_-Procedure" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-135_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='pro-fea']">
		<assert id="BT-195_BT-88_-Procedure_R" role="ERROR" diagnostics="BT-195_BT-88_-Procedure" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-88_-Procedure_R</assert>
		<assert id="BT-196_BT-88_-Procedure_A" role="ERROR" diagnostics="BT-196_BT-88_-Procedure" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-88_-Procedure_A</assert>
		<assert id="BT-196_BT-88_-Procedure_B" role="ERROR" diagnostics="BT-196_BT-88_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-88_-Procedure_B</assert>
		<assert id="BT-196_BT-88_-Procedure_C" role="ERROR" diagnostics="BT-196_BT-88_-Procedure" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-88_-Procedure_C</assert>
		<assert id="BT-197_BT-88_-Procedure_R" role="ERROR" diagnostics="BT-197_BT-88_-Procedure" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-88_-Procedure_R</assert>
		<assert id="BT-198_BT-88_-Procedure_R" role="ERROR" diagnostics="BT-198_BT-88_-Procedure" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-88_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='pro-typ']">
		<assert id="BT-195_BT-105_-Procedure_R" role="ERROR" diagnostics="BT-195_BT-105_-Procedure" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-105_-Procedure_R</assert>
		<assert id="BT-196_BT-105_-Procedure_A" role="ERROR" diagnostics="BT-196_BT-105_-Procedure" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-105_-Procedure_A</assert>
		<assert id="BT-196_BT-105_-Procedure_B" role="ERROR" diagnostics="BT-196_BT-105_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-105_-Procedure_B</assert>
		<assert id="BT-196_BT-105_-Procedure_C" role="ERROR" diagnostics="BT-196_BT-105_-Procedure" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-105_-Procedure_C</assert>
		<assert id="BT-197_BT-105_-Procedure_R" role="ERROR" diagnostics="BT-197_BT-105_-Procedure" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-105_-Procedure_R</assert>
		<assert id="BT-198_BT-105_-Procedure_R" role="ERROR" diagnostics="BT-198_BT-105_-Procedure" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-105_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms">
		<assert id="BT-09_a_-Procedure_R" role="ERROR" diagnostics="BT-09_a_-Procedure" test="count(cac:ProcurementLegislationDocumentReference/cbc:ID[text()='CrossBorderLaw']) &lt; 2">rule|text|BT-09_a_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:LotDistribution">
		<assert id="BT-31-Procedure_R" role="ERROR" diagnostics="BT-31-Procedure" test="count(cbc:MaximumLotsSubmittedNumeric) &lt; 2">rule|text|BT-31-Procedure_R</assert>
		<assert id="BT-33-Procedure_R" role="ERROR" diagnostics="BT-33-Procedure" test="count(cbc:MaximumLotsAwardedNumeric) &lt; 2">rule|text|BT-33-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='cro-bor-law']">
		<assert id="BT-195_BT-09_-Procedure_R" role="ERROR" diagnostics="BT-195_BT-09_-Procedure" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-09_-Procedure_R</assert>
		<assert id="BT-196_BT-09_-Procedure_A" role="ERROR" diagnostics="BT-196_BT-09_-Procedure" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-09_-Procedure_A</assert>
		<assert id="BT-196_BT-09_-Procedure_B" role="ERROR" diagnostics="BT-196_BT-09_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-09_-Procedure_B</assert>
		<assert id="BT-196_BT-09_-Procedure_C" role="ERROR" diagnostics="BT-196_BT-09_-Procedure" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-09_-Procedure_C</assert>
		<assert id="BT-197_BT-09_-Procedure_R" role="ERROR" diagnostics="BT-197_BT-09_-Procedure" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-09_-Procedure_R</assert>
		<assert id="BT-198_BT-09_-Procedure_R" role="ERROR" diagnostics="BT-198_BT-09_-Procedure" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-09_-Procedure_R</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference[cbc:ID/text()='CrossBorderLaw']">
		<assert id="BT-09_b_-Procedure_A" role="ERROR" diagnostics="BT-09_b_-Procedure" test="count(cbc:DocumentDescription[@languageID = preceding-sibling::cbc:DocumentDescription/@languageID]) = 0">rule|text|BT-09_b_-Procedure_A</assert>
		<assert id="BT-09_b_-Procedure_B" role="ERROR" diagnostics="BT-09_b_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:DocumentDescription/@languageID = $lg) or count(cbc:DocumentDescription) = 0">rule|text|BT-09_b_-Procedure_B</assert>
		<assert id="BT-09_b_-Procedure_C" role="ERROR" diagnostics="BT-09_b_-Procedure" test="(every $lg in (cbc:DocumentDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:DocumentDescription) = 0">rule|text|BT-09_b_-Procedure_C</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference[cbc:ID/text()='LocalLegalBasis']">
		<assert id="BT-01_f_-Procedure_A" role="ERROR" diagnostics="BT-01_f_-Procedure" test="count(cbc:DocumentDescription[@languageID = preceding-sibling::cbc:DocumentDescription/@languageID]) = 0">rule|text|BT-01_f_-Procedure_A</assert>
		<assert id="BT-01_f_-Procedure_B" role="ERROR" diagnostics="BT-01_f_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:DocumentDescription/@languageID = $lg) or count(cbc:DocumentDescription) = 0">rule|text|BT-01_f_-Procedure_B</assert>
		<assert id="BT-01_f_-Procedure_C" role="ERROR" diagnostics="BT-01_f_-Procedure" test="(every $lg in (cbc:DocumentDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:DocumentDescription) = 0">rule|text|BT-01_f_-Procedure_C</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference[not(cbc:ID/text()=('CrossBorderLaw','LocalLegalBasis'))]">
		<assert id="BT-01_d_-Procedure_A" role="ERROR" diagnostics="BT-01_d_-Procedure" test="count(cbc:DocumentDescription[@languageID = preceding-sibling::cbc:DocumentDescription/@languageID]) = 0">rule|text|BT-01_d_-Procedure_A</assert>
		<assert id="BT-01_d_-Procedure_B" role="ERROR" diagnostics="BT-01_d_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:DocumentDescription/@languageID = $lg) or count(cbc:DocumentDescription) = 0">rule|text|BT-01_d_-Procedure_B</assert>
		<assert id="BT-01_d_-Procedure_C" role="ERROR" diagnostics="BT-01_d_-Procedure" test="(every $lg in (cbc:DocumentDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:DocumentDescription) = 0">rule|text|BT-01_d_-Procedure_C</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:TendererQualificationRequest/cac:SpecificTendererRequirement">
		<assert id="BT-67_a_-Procedure_R" role="ERROR" diagnostics="BT-67_a_-Procedure" test="count(cbc:TendererRequirementTypeCode[@listName='exclusion-ground']) &lt; 2">rule|text|BT-67_a_-Procedure_R</assert>
		<assert id="BT-67_b_-Procedure_A" role="ERROR" diagnostics="BT-67_b_-Procedure" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-67_b_-Procedure_A</assert>
		<assert id="BT-67_b_-Procedure_B" role="ERROR" diagnostics="BT-67_b_-Procedure" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-67_b_-Procedure_B</assert>
		<assert id="BT-67_b_-Procedure_C" role="ERROR" diagnostics="BT-67_b_-Procedure" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-67_b_-Procedure_C</assert>
	</rule>
	<rule context="/*/efac:NoticePurpose">
		<assert id="OPP-100-Business_R" role="ERROR" diagnostics="OPP-100-Business" test="count(cbc:PurposeCode) &lt; 2">rule|text|OPP-100-Business_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension">
		<assert id="OPP-010-notice_R" role="ERROR" diagnostics="OPP-010-notice" test="count(efac:Publication/efbc:NoticePublicationID[@schemeName='ojs-notice-id']) &lt; 2">rule|text|OPP-010-notice_R</assert>
		<assert id="OPP-011-notice_R" role="ERROR" diagnostics="OPP-011-notice" test="count(efac:Publication/efbc:GazetteID[@schemeName='ojs-id']) &lt; 2">rule|text|OPP-011-notice_R</assert>
		<assert id="OPP-012-notice_R" role="ERROR" diagnostics="OPP-012-notice" test="count(efac:Publication/efbc:PublicationDate) &lt; 2">rule|text|OPP-012-notice_R</assert>
		<assert id="OPP-070-notice_R" role="ERROR" diagnostics="OPP-070-notice" test="count(efac:NoticeSubType/cbc:SubTypeCode) &lt; 2">rule|text|OPP-070-notice_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AppealsInformation/efac:AppealStatus">
		<assert id="BT-783-Review_R" role="ERROR" diagnostics="BT-783-Review" test="count(efbc:AppealStageCode) &lt; 2">rule|text|BT-783-Review_R</assert>
		<assert id="BT-784-Review_R" role="ERROR" diagnostics="BT-784-Review" test="count(efbc:AppealStageID) &lt; 2">rule|text|BT-784-Review_R</assert>
		<assert id="BT-785-Review_R" role="ERROR" diagnostics="BT-785-Review" test="count(efbc:AppealPreviousStageID) &lt; 2">rule|text|BT-785-Review_R</assert>
		<assert id="BT-787-Review_R" role="ERROR" diagnostics="BT-787-Review" test="count(cbc:Date) &lt; 2">rule|text|BT-787-Review_R</assert>
		<assert id="BT-788-Review_A" role="ERROR" diagnostics="BT-788-Review" test="count(cbc:Title[@languageID = preceding-sibling::cbc:Title/@languageID]) = 0">rule|text|BT-788-Review_A</assert>
		<assert id="BT-788-Review_B" role="ERROR" diagnostics="BT-788-Review" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Title/@languageID = $lg) or count(cbc:Title) = 0">rule|text|BT-788-Review_B</assert>
		<assert id="BT-788-Review_C" role="ERROR" diagnostics="BT-788-Review" test="(every $lg in (cbc:Title/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Title) = 0">rule|text|BT-788-Review_C</assert>
		<assert id="BT-789-Review_A" role="ERROR" diagnostics="BT-789-Review" test="count(cbc:Description[@languageID = preceding-sibling::cbc:Description/@languageID]) = 0">rule|text|BT-789-Review_A</assert>
		<assert id="BT-789-Review_B" role="ERROR" diagnostics="BT-789-Review" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Description/@languageID = $lg) or count(cbc:Description) = 0">rule|text|BT-789-Review_B</assert>
		<assert id="BT-789-Review_C" role="ERROR" diagnostics="BT-789-Review" test="(every $lg in (cbc:Description/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Description) = 0">rule|text|BT-789-Review_C</assert>
		<assert id="BT-793-Review_R" role="ERROR" diagnostics="BT-793-Review" test="count(efbc:RemedyAmount) &lt; 2">rule|text|BT-793-Review_R</assert>
		<assert id="BT-794-Review_R" role="ERROR" diagnostics="BT-794-Review" test="count(cbc:URI) &lt; 2">rule|text|BT-794-Review_R</assert>
		<assert id="BT-795-Review_R" role="ERROR" diagnostics="BT-795-Review" test="count(cbc:FeeAmount) &lt; 2">rule|text|BT-795-Review_R</assert>
		<assert id="BT-796-Review_R" role="ERROR" diagnostics="BT-796-Review" test="count(efbc:WithdrawnAppealIndicator) &lt; 2">rule|text|BT-796-Review_R</assert>
		<assert id="BT-797-Review_R" role="ERROR" diagnostics="BT-797-Review" test="count(efbc:WithdrawnAppealDate) &lt; 2">rule|text|BT-797-Review_R</assert>
		<assert id="BT-798-Review_A" role="ERROR" diagnostics="BT-798-Review" test="count(efbc:WithdrawnAppealReasons[@languageID = preceding-sibling::efbc:WithdrawnAppealReasons/@languageID]) = 0">rule|text|BT-798-Review_A</assert>
		<assert id="BT-798-Review_B" role="ERROR" diagnostics="BT-798-Review" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:WithdrawnAppealReasons/@languageID = $lg) or count(efbc:WithdrawnAppealReasons) = 0">rule|text|BT-798-Review_B</assert>
		<assert id="BT-798-Review_C" role="ERROR" diagnostics="BT-798-Review" test="(every $lg in (efbc:WithdrawnAppealReasons/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:WithdrawnAppealReasons) = 0">rule|text|BT-798-Review_C</assert>
		<assert id="BT-799-ReviewBody_R" role="ERROR" diagnostics="BT-799-ReviewBody" test="count(efac:AppealProcessingParty/efbc:AppealProcessingPartyTypeCode) &lt; 2">rule|text|BT-799-ReviewBody_R</assert>
		<assert id="OPT-092-ReviewBody_A" role="ERROR" diagnostics="OPT-092-ReviewBody" test="count(efac:AppealProcessingParty/efbc:AppealProcessingPartyTypeDescription[@languageID = preceding-sibling::efbc:AppealProcessingPartyTypeDescription/@languageID]) = 0">rule|text|OPT-092-ReviewBody_A</assert>
		<assert id="OPT-092-ReviewBody_B" role="ERROR" diagnostics="OPT-092-ReviewBody" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efac:AppealProcessingParty/efbc:AppealProcessingPartyTypeDescription/@languageID = $lg) or count(efac:AppealProcessingParty/efbc:AppealProcessingPartyTypeDescription) = 0">rule|text|OPT-092-ReviewBody_B</assert>
		<assert id="OPT-092-ReviewBody_C" role="ERROR" diagnostics="OPT-092-ReviewBody" test="(every $lg in (efac:AppealProcessingParty/efbc:AppealProcessingPartyTypeDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efac:AppealProcessingParty/efbc:AppealProcessingPartyTypeDescription) = 0">rule|text|OPT-092-ReviewBody_C</assert>
		<assert id="OPT-301-ReviewBody_R" role="ERROR" diagnostics="OPT-301-ReviewBody" test="count(efac:AppealProcessingParty/cac:Party/cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-301-ReviewBody_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AppealsInformation/efac:AppealStatus/efac:AppealingParty">
		<assert id="OPT-092-ReviewReq_A" role="ERROR" diagnostics="OPT-092-ReviewReq" test="count(efbc:AppealingPartyTypeDescription[@languageID = preceding-sibling::efbc:AppealingPartyTypeDescription/@languageID]) = 0">rule|text|OPT-092-ReviewReq_A</assert>
		<assert id="OPT-092-ReviewReq_B" role="ERROR" diagnostics="OPT-092-ReviewReq" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:AppealingPartyTypeDescription/@languageID = $lg) or count(efbc:AppealingPartyTypeDescription) = 0">rule|text|OPT-092-ReviewReq_B</assert>
		<assert id="OPT-092-ReviewReq_C" role="ERROR" diagnostics="OPT-092-ReviewReq" test="(every $lg in (efbc:AppealingPartyTypeDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:AppealingPartyTypeDescription) = 0">rule|text|OPT-092-ReviewReq_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Changes">
		<assert id="BT-758-notice_R" role="ERROR" diagnostics="BT-758-notice" test="count(efbc:ChangedNoticeIdentifier) &lt; 2">rule|text|BT-758-notice_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Changes/efac:Change">
		<assert id="BT-141_a_-notice_A" role="ERROR" diagnostics="BT-141_a_-notice" test="count(efbc:ChangeDescription[@languageID = preceding-sibling::efbc:ChangeDescription/@languageID]) = 0">rule|text|BT-141_a_-notice_A</assert>
		<assert id="BT-141_a_-notice_B" role="ERROR" diagnostics="BT-141_a_-notice" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ChangeDescription/@languageID = $lg) or count(efbc:ChangeDescription) = 0">rule|text|BT-141_a_-notice_B</assert>
		<assert id="BT-141_a_-notice_C" role="ERROR" diagnostics="BT-141_a_-notice" test="(every $lg in (efbc:ChangeDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ChangeDescription) = 0">rule|text|BT-141_a_-notice_C</assert>
		<assert id="BT-718-notice_R" role="ERROR" diagnostics="BT-718-notice" test="count(efbc:ProcurementDocumentsChangeIndicator) &lt; 2">rule|text|BT-718-notice_R</assert>
		<assert id="BT-719-notice_R" role="ERROR" diagnostics="BT-719-notice" test="count(efbc:ProcurementDocumentsChangeDate) &lt; 2">rule|text|BT-719-notice_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Changes/efac:ChangeReason">
		<assert id="BT-140-notice_R" role="ERROR" diagnostics="BT-140-notice" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-140-notice_R</assert>
		<assert id="BT-762-notice_A" role="ERROR" diagnostics="BT-762-notice" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-762-notice_A</assert>
		<assert id="BT-762-notice_B" role="ERROR" diagnostics="BT-762-notice" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-762-notice_B</assert>
		<assert id="BT-762-notice_C" role="ERROR" diagnostics="BT-762-notice" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-762-notice_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:ContractModification">
		<assert id="BT-1501_n_-Contract_R" role="ERROR" diagnostics="BT-1501_n_-Contract" test="count(efbc:ChangedNoticeIdentifier) &lt; 2">rule|text|BT-1501_n_-Contract_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:ContractModification/efac:Change">
		<assert id="BT-202-Contract_A" role="ERROR" diagnostics="BT-202-Contract" test="count(efbc:ChangeDescription[@languageID = preceding-sibling::efbc:ChangeDescription/@languageID]) = 0">rule|text|BT-202-Contract_A</assert>
		<assert id="BT-202-Contract_B" role="ERROR" diagnostics="BT-202-Contract" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ChangeDescription/@languageID = $lg) or count(efbc:ChangeDescription) = 0">rule|text|BT-202-Contract_B</assert>
		<assert id="BT-202-Contract_C" role="ERROR" diagnostics="BT-202-Contract" test="(every $lg in (efbc:ChangeDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ChangeDescription) = 0">rule|text|BT-202-Contract_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:ContractModification/efac:ChangeReason">
		<assert id="BT-200-Contract_R" role="ERROR" diagnostics="BT-200-Contract" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-200-Contract_R</assert>
		<assert id="BT-201-Contract_A" role="ERROR" diagnostics="BT-201-Contract" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-201-Contract_A</assert>
		<assert id="BT-201-Contract_B" role="ERROR" diagnostics="BT-201-Contract" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-201-Contract_B</assert>
		<assert id="BT-201-Contract_C" role="ERROR" diagnostics="BT-201-Contract" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-201-Contract_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult">
		<assert id="BT-118-NoticeResult_R" role="ERROR" diagnostics="BT-118-NoticeResult" test="count(cbc:EstimatedOverallFrameworkContractsAmount) &lt; 2">rule|text|BT-118-NoticeResult_R</assert>
		<assert id="BT-161-NoticeResult_R" role="ERROR" diagnostics="BT-161-NoticeResult" test="count(cbc:TotalAmount) &lt; 2">rule|text|BT-161-NoticeResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='not-max-val']">
		<assert id="BT-195_BT-118_-NoticeResult_R" role="ERROR" diagnostics="BT-195_BT-118_-NoticeResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-118_-NoticeResult_R</assert>
		<assert id="BT-196_BT-118_-NoticeResult_A" role="ERROR" diagnostics="BT-196_BT-118_-NoticeResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-118_-NoticeResult_A</assert>
		<assert id="BT-196_BT-118_-NoticeResult_B" role="ERROR" diagnostics="BT-196_BT-118_-NoticeResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-118_-NoticeResult_B</assert>
		<assert id="BT-196_BT-118_-NoticeResult_C" role="ERROR" diagnostics="BT-196_BT-118_-NoticeResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-118_-NoticeResult_C</assert>
		<assert id="BT-197_BT-118_-NoticeResult_R" role="ERROR" diagnostics="BT-197_BT-118_-NoticeResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-118_-NoticeResult_R</assert>
		<assert id="BT-198_BT-118_-NoticeResult_R" role="ERROR" diagnostics="BT-198_BT-118_-NoticeResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-118_-NoticeResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='not-val']">
		<assert id="BT-195_BT-161_-NoticeResult_R" role="ERROR" diagnostics="BT-195_BT-161_-NoticeResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-161_-NoticeResult_R</assert>
		<assert id="BT-196_BT-161_-NoticeResult_A" role="ERROR" diagnostics="BT-196_BT-161_-NoticeResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-161_-NoticeResult_A</assert>
		<assert id="BT-196_BT-161_-NoticeResult_B" role="ERROR" diagnostics="BT-196_BT-161_-NoticeResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-161_-NoticeResult_B</assert>
		<assert id="BT-196_BT-161_-NoticeResult_C" role="ERROR" diagnostics="BT-196_BT-161_-NoticeResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-161_-NoticeResult_C</assert>
		<assert id="BT-197_BT-161_-NoticeResult_R" role="ERROR" diagnostics="BT-197_BT-161_-NoticeResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-161_-NoticeResult_R</assert>
		<assert id="BT-198_BT-161_-NoticeResult_R" role="ERROR" diagnostics="BT-198_BT-161_-NoticeResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-161_-NoticeResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:GroupFramework">
		<assert id="BT-156-NoticeResult_R" role="ERROR" diagnostics="BT-156-NoticeResult" test="count(efbc:GroupFrameworkValueAmount) &lt; 2">rule|text|BT-156-NoticeResult_R</assert>
		<assert id="BT-556-NoticeResult_R" role="ERROR" diagnostics="BT-556-NoticeResult" test="count(efac:TenderLot/cbc:ID) &lt; 2">rule|text|BT-556-NoticeResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:GroupFramework/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='gro-max-ide']">
		<assert id="BT-195_BT-556_-NoticeResult_R" role="ERROR" diagnostics="BT-195_BT-556_-NoticeResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-556_-NoticeResult_R</assert>
		<assert id="BT-196_BT-556_-NoticeResult_A" role="ERROR" diagnostics="BT-196_BT-556_-NoticeResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-556_-NoticeResult_A</assert>
		<assert id="BT-196_BT-556_-NoticeResult_B" role="ERROR" diagnostics="BT-196_BT-556_-NoticeResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-556_-NoticeResult_B</assert>
		<assert id="BT-196_BT-556_-NoticeResult_C" role="ERROR" diagnostics="BT-196_BT-556_-NoticeResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-556_-NoticeResult_C</assert>
		<assert id="BT-197_BT-556_-NoticeResult_R" role="ERROR" diagnostics="BT-197_BT-556_-NoticeResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-556_-NoticeResult_R</assert>
		<assert id="BT-198_BT-556_-NoticeResult_R" role="ERROR" diagnostics="BT-198_BT-556_-NoticeResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-556_-NoticeResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:GroupFramework/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='gro-max-val']">
		<assert id="BT-195_BT-156_-NoticeResult_R" role="ERROR" diagnostics="BT-195_BT-156_-NoticeResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-156_-NoticeResult_R</assert>
		<assert id="BT-196_BT-156_-NoticeResult_A" role="ERROR" diagnostics="BT-196_BT-156_-NoticeResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-156_-NoticeResult_A</assert>
		<assert id="BT-196_BT-156_-NoticeResult_B" role="ERROR" diagnostics="BT-196_BT-156_-NoticeResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-156_-NoticeResult_B</assert>
		<assert id="BT-196_BT-156_-NoticeResult_C" role="ERROR" diagnostics="BT-196_BT-156_-NoticeResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-156_-NoticeResult_C</assert>
		<assert id="BT-197_BT-156_-NoticeResult_R" role="ERROR" diagnostics="BT-197_BT-156_-NoticeResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-156_-NoticeResult_R</assert>
		<assert id="BT-198_BT-156_-NoticeResult_R" role="ERROR" diagnostics="BT-198_BT-156_-NoticeResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-156_-NoticeResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult">
		<assert id="BT-119-LotResult_R" role="ERROR" diagnostics="BT-119-LotResult" test="count(efbc:DPSTerminationIndicator) &lt; 2">rule|text|BT-119-LotResult_R</assert>
		<assert id="BT-13713-LotResult_R" role="ERROR" diagnostics="BT-13713-LotResult" test="count(efac:TenderLot/cbc:ID) &lt; 2">rule|text|BT-13713-LotResult_R</assert>
		<assert id="BT-142-LotResult_R" role="ERROR" diagnostics="BT-142-LotResult" test="count(cbc:TenderResultCode) &lt; 2">rule|text|BT-142-LotResult_R</assert>
		<assert id="BT-144-LotResult_R" role="ERROR" diagnostics="BT-144-LotResult" test="count(efac:DecisionReason/efbc:DecisionReasonCode) &lt; 2">rule|text|BT-144-LotResult_R</assert>
		<assert id="BT-710-LotResult_R" role="ERROR" diagnostics="BT-710-LotResult" test="count(cbc:LowerTenderAmount) &lt; 2">rule|text|BT-710-LotResult_R</assert>
		<assert id="BT-711-LotResult_R" role="ERROR" diagnostics="BT-711-LotResult" test="count(cbc:HigherTenderAmount) &lt; 2">rule|text|BT-711-LotResult_R</assert>
		<assert id="BT-712_a_-LotResult_R" role="ERROR" diagnostics="BT-712_a_-LotResult" test="count(efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='review-type']/efbc:StatisticsCode) &lt; 2">rule|text|BT-712_a_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='irregularity-type']">
		<assert id="BT-635-LotResult_R" role="ERROR" diagnostics="BT-635-LotResult" test="count(efbc:StatisticsNumeric) &lt; 2">rule|text|BT-635-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='irregularity-type']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='buy-rev-cou']">
		<assert id="BT-195_BT-635_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-635_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-635_-LotResult_R</assert>
		<assert id="BT-196_BT-635_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-635_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-635_-LotResult_A</assert>
		<assert id="BT-196_BT-635_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-635_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-635_-LotResult_B</assert>
		<assert id="BT-196_BT-635_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-635_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-635_-LotResult_C</assert>
		<assert id="BT-197_BT-635_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-635_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-635_-LotResult_R</assert>
		<assert id="BT-198_BT-635_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-635_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-635_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='irregularity-type']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='buy-rev-typ']">
		<assert id="BT-195_BT-636_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-636_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-636_-LotResult_R</assert>
		<assert id="BT-196_BT-636_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-636_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-636_-LotResult_A</assert>
		<assert id="BT-196_BT-636_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-636_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-636_-LotResult_B</assert>
		<assert id="BT-196_BT-636_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-636_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-636_-LotResult_C</assert>
		<assert id="BT-197_BT-636_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-636_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-636_-LotResult_R</assert>
		<assert id="BT-198_BT-636_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-636_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-636_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='review-type']">
		<assert id="BT-712_b_-LotResult_R" role="ERROR" diagnostics="BT-712_b_-LotResult" test="count(efbc:StatisticsNumeric) &lt; 2">rule|text|BT-712_b_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='review-type']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='rev-req']">
		<assert id="BT-195_BT-712_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-712_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-712_-LotResult_R</assert>
		<assert id="BT-196_BT-712_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-712_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-712_-LotResult_A</assert>
		<assert id="BT-196_BT-712_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-712_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-712_-LotResult_B</assert>
		<assert id="BT-196_BT-712_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-712_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-712_-LotResult_C</assert>
		<assert id="BT-197_BT-712_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-712_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-712_-LotResult_R</assert>
		<assert id="BT-198_BT-712_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-712_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-712_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:DecisionReason/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='no-awa-rea']">
		<assert id="BT-195_BT-144_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-144_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-144_-LotResult_R</assert>
		<assert id="BT-196_BT-144_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-144_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-144_-LotResult_A</assert>
		<assert id="BT-196_BT-144_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-144_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-144_-LotResult_B</assert>
		<assert id="BT-196_BT-144_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-144_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-144_-LotResult_C</assert>
		<assert id="BT-197_BT-144_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-144_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-144_-LotResult_R</assert>
		<assert id="BT-198_BT-144_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-144_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-144_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='ten-val-hig']">
		<assert id="BT-195_BT-711_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-711_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-711_-LotResult_R</assert>
		<assert id="BT-196_BT-711_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-711_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-711_-LotResult_A</assert>
		<assert id="BT-196_BT-711_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-711_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-711_-LotResult_B</assert>
		<assert id="BT-196_BT-711_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-711_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-711_-LotResult_C</assert>
		<assert id="BT-197_BT-711_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-711_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-711_-LotResult_R</assert>
		<assert id="BT-198_BT-711_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-711_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-711_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='ten-val-low']">
		<assert id="BT-195_BT-710_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-710_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-710_-LotResult_R</assert>
		<assert id="BT-196_BT-710_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-710_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-710_-LotResult_A</assert>
		<assert id="BT-196_BT-710_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-710_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-710_-LotResult_B</assert>
		<assert id="BT-196_BT-710_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-710_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-710_-LotResult_C</assert>
		<assert id="BT-197_BT-710_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-710_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-710_-LotResult_R</assert>
		<assert id="BT-198_BT-710_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-710_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-710_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='win-cho']">
		<assert id="BT-195_BT-142_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-142_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-142_-LotResult_R</assert>
		<assert id="BT-196_BT-142_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-142_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-142_-LotResult_A</assert>
		<assert id="BT-196_BT-142_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-142_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-142_-LotResult_B</assert>
		<assert id="BT-196_BT-142_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-142_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-142_-LotResult_C</assert>
		<assert id="BT-197_BT-142_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-142_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-142_-LotResult_R</assert>
		<assert id="BT-198_BT-142_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-142_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-142_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FrameworkAgreementValues">
		<assert id="BT-660-LotResult_R" role="ERROR" diagnostics="BT-660-LotResult" test="count(cbc:EstimatedMaximumValueAmount) &lt; 2">rule|text|BT-660-LotResult_R</assert>
		<assert id="BT-709-LotResult_R" role="ERROR" diagnostics="BT-709-LotResult" test="count(cbc:MaximumValueAmount) &lt; 2">rule|text|BT-709-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FrameworkAgreementValues/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='max-val']">
		<assert id="BT-195_BT-709_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-709_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-709_-LotResult_R</assert>
		<assert id="BT-196_BT-709_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-709_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-709_-LotResult_A</assert>
		<assert id="BT-196_BT-709_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-709_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-709_-LotResult_B</assert>
		<assert id="BT-196_BT-709_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-709_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-709_-LotResult_C</assert>
		<assert id="BT-197_BT-709_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-709_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-709_-LotResult_R</assert>
		<assert id="BT-198_BT-709_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-709_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-709_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='rec-sub-cou']">
		<assert id="BT-195_BT-759_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-759_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-759_-LotResult_R</assert>
		<assert id="BT-196_BT-759_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-759_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-759_-LotResult_A</assert>
		<assert id="BT-196_BT-759_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-759_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-759_-LotResult_B</assert>
		<assert id="BT-196_BT-759_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-759_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-759_-LotResult_C</assert>
		<assert id="BT-197_BT-759_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-759_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-759_-LotResult_R</assert>
		<assert id="BT-198_BT-759_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-759_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-759_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='rec-sub-typ']">
		<assert id="BT-195_BT-760_-LotResult_R" role="ERROR" diagnostics="BT-195_BT-760_-LotResult" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-760_-LotResult_R</assert>
		<assert id="BT-196_BT-760_-LotResult_A" role="ERROR" diagnostics="BT-196_BT-760_-LotResult" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-760_-LotResult_A</assert>
		<assert id="BT-196_BT-760_-LotResult_B" role="ERROR" diagnostics="BT-196_BT-760_-LotResult" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-760_-LotResult_B</assert>
		<assert id="BT-196_BT-760_-LotResult_C" role="ERROR" diagnostics="BT-196_BT-760_-LotResult" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-760_-LotResult_C</assert>
		<assert id="BT-197_BT-760_-LotResult_R" role="ERROR" diagnostics="BT-197_BT-760_-LotResult" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-760_-LotResult_R</assert>
		<assert id="BT-198_BT-760_-LotResult_R" role="ERROR" diagnostics="BT-198_BT-760_-LotResult" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-760_-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:StrategicProcurementStatistics">
		<assert id="OPT-155-LotResult_R" role="ERROR" diagnostics="OPT-155-LotResult" test="count(efbc:StatisticsCode) &lt; 2">rule|text|OPT-155-LotResult_R</assert>
		<assert id="OPT-156-LotResult_R" role="ERROR" diagnostics="OPT-156-LotResult" test="count(efbc:StatisticsNumeric) &lt; 2">rule|text|OPT-156-LotResult_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender">
		<assert id="BT-13714-Tender_R" role="ERROR" diagnostics="BT-13714-Tender" test="count(efac:TenderLot/cbc:ID) &lt; 2">rule|text|BT-13714-Tender_R</assert>
		<assert id="BT-171-Tender_R" role="ERROR" diagnostics="BT-171-Tender" test="count(cbc:RankCode) &lt; 2">rule|text|BT-171-Tender_R</assert>
		<assert id="BT-193-Tender_R" role="ERROR" diagnostics="BT-193-Tender" test="count(efbc:TenderVariantIndicator) &lt; 2">rule|text|BT-193-Tender_R</assert>
		<assert id="BT-3201-Tender_R" role="ERROR" diagnostics="BT-3201-Tender" test="count(efac:TenderReference/cbc:ID) &lt; 2">rule|text|BT-3201-Tender_R</assert>
		<assert id="BT-720-Tender_R" role="ERROR" diagnostics="BT-720-Tender" test="count(cac:LegalMonetaryTotal/cbc:PayableAmount) &lt; 2">rule|text|BT-720-Tender_R</assert>
		<assert id="BT-779-Tender_R" role="ERROR" diagnostics="BT-779-Tender" test="count(efac:AggregatedAmounts/cbc:PaidAmount) &lt; 2">rule|text|BT-779-Tender_R</assert>
		<assert id="BT-780-Tender_A" role="ERROR" diagnostics="BT-780-Tender" test="count(efac:AggregatedAmounts/efbc:PaidAmountDescription[@languageID = preceding-sibling::efbc:PaidAmountDescription/@languageID]) = 0">rule|text|BT-780-Tender_A</assert>
		<assert id="BT-780-Tender_B" role="ERROR" diagnostics="BT-780-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efac:AggregatedAmounts/efbc:PaidAmountDescription/@languageID = $lg) or count(efac:AggregatedAmounts/efbc:PaidAmountDescription) = 0">rule|text|BT-780-Tender_B</assert>
		<assert id="BT-780-Tender_C" role="ERROR" diagnostics="BT-780-Tender" test="(every $lg in (efac:AggregatedAmounts/efbc:PaidAmountDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efac:AggregatedAmounts/efbc:PaidAmountDescription) = 0">rule|text|BT-780-Tender_C</assert>
		<assert id="BT-782-Tender_R" role="ERROR" diagnostics="BT-782-Tender" test="count(efac:AggregatedAmounts/efbc:PenaltiesAmount) &lt; 2">rule|text|BT-782-Tender_R</assert>
		<assert id="OPP-033-Tender_R" role="ERROR" diagnostics="OPP-033-Tender" test="count(efac:ContractTerm[efbc:TermCode/@listName='rewards-penalties']/efbc:TermCode) &lt; 2">rule|text|OPP-033-Tender_R</assert>
		<assert id="OPP-080-Tender_R" role="ERROR" diagnostics="OPP-080-Tender" test="count(efbc:PublicTransportationCumulatedDistance) &lt; 2">rule|text|OPP-080-Tender_R</assert>
		<assert id="OPT-310-Tender_R" role="ERROR" diagnostics="OPT-310-Tender" test="count(efac:TenderingParty/cbc:ID) &lt; 2">rule|text|OPT-310-Tender_R</assert>
		<assert id="OPT-321-Tender_R" role="ERROR" diagnostics="OPT-321-Tender" test="count(cbc:ID) &lt; 2">rule|text|OPT-321-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ConcessionRevenue">
		<assert id="BT-160-Tender_R" role="ERROR" diagnostics="BT-160-Tender" test="count(efbc:RevenueBuyerAmount) &lt; 2">rule|text|BT-160-Tender_R</assert>
		<assert id="BT-162-Tender_R" role="ERROR" diagnostics="BT-162-Tender" test="count(efbc:RevenueUserAmount) &lt; 2">rule|text|BT-162-Tender_R</assert>
		<assert id="BT-163-Tender_A" role="ERROR" diagnostics="BT-163-Tender" test="count(efbc:ValueDescription[@languageID = preceding-sibling::efbc:ValueDescription/@languageID]) = 0">rule|text|BT-163-Tender_A</assert>
		<assert id="BT-163-Tender_B" role="ERROR" diagnostics="BT-163-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ValueDescription/@languageID = $lg) or count(efbc:ValueDescription) = 0">rule|text|BT-163-Tender_B</assert>
		<assert id="BT-163-Tender_C" role="ERROR" diagnostics="BT-163-Tender" test="(every $lg in (efbc:ValueDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ValueDescription) = 0">rule|text|BT-163-Tender_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ConcessionRevenue/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='con-rev-buy']">
		<assert id="BT-195_BT-160_-Tender_R" role="ERROR" diagnostics="BT-195_BT-160_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-160_-Tender_R</assert>
		<assert id="BT-196_BT-160_-Tender_A" role="ERROR" diagnostics="BT-196_BT-160_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-160_-Tender_A</assert>
		<assert id="BT-196_BT-160_-Tender_B" role="ERROR" diagnostics="BT-196_BT-160_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-160_-Tender_B</assert>
		<assert id="BT-196_BT-160_-Tender_C" role="ERROR" diagnostics="BT-196_BT-160_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-160_-Tender_C</assert>
		<assert id="BT-197_BT-160_-Tender_R" role="ERROR" diagnostics="BT-197_BT-160_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-160_-Tender_R</assert>
		<assert id="BT-198_BT-160_-Tender_R" role="ERROR" diagnostics="BT-198_BT-160_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-160_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ConcessionRevenue/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='con-rev-use']">
		<assert id="BT-195_BT-162_-Tender_R" role="ERROR" diagnostics="BT-195_BT-162_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-162_-Tender_R</assert>
		<assert id="BT-196_BT-162_-Tender_A" role="ERROR" diagnostics="BT-196_BT-162_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-162_-Tender_A</assert>
		<assert id="BT-196_BT-162_-Tender_B" role="ERROR" diagnostics="BT-196_BT-162_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-162_-Tender_B</assert>
		<assert id="BT-196_BT-162_-Tender_C" role="ERROR" diagnostics="BT-196_BT-162_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-162_-Tender_C</assert>
		<assert id="BT-197_BT-162_-Tender_R" role="ERROR" diagnostics="BT-197_BT-162_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-162_-Tender_R</assert>
		<assert id="BT-198_BT-162_-Tender_R" role="ERROR" diagnostics="BT-198_BT-162_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-162_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ConcessionRevenue/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='val-con-des']">
		<assert id="BT-195_BT-163_-Tender_R" role="ERROR" diagnostics="BT-195_BT-163_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-163_-Tender_R</assert>
		<assert id="BT-196_BT-163_-Tender_A" role="ERROR" diagnostics="BT-196_BT-163_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-163_-Tender_A</assert>
		<assert id="BT-196_BT-163_-Tender_B" role="ERROR" diagnostics="BT-196_BT-163_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-163_-Tender_B</assert>
		<assert id="BT-196_BT-163_-Tender_C" role="ERROR" diagnostics="BT-196_BT-163_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-163_-Tender_C</assert>
		<assert id="BT-197_BT-163_-Tender_R" role="ERROR" diagnostics="BT-197_BT-163_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-163_-Tender_R</assert>
		<assert id="BT-198_BT-163_-Tender_R" role="ERROR" diagnostics="BT-198_BT-163_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-163_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ContractTerm[efbc:TermCode/@listName='rewards-penalties']">
		<assert id="OPP-034-Tender_A" role="ERROR" diagnostics="OPP-034-Tender" test="count(efbc:TermDescription[@languageID = preceding-sibling::efbc:TermDescription/@languageID]) = 0">rule|text|OPP-034-Tender_A</assert>
		<assert id="OPP-034-Tender_B" role="ERROR" diagnostics="OPP-034-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:TermDescription/@languageID = $lg) or count(efbc:TermDescription) = 0">rule|text|OPP-034-Tender_B</assert>
		<assert id="OPP-034-Tender_C" role="ERROR" diagnostics="OPP-034-Tender" test="(every $lg in (efbc:TermDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:TermDescription) = 0">rule|text|OPP-034-Tender_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ContractTerm[efbc:TermCode/text()='all-rev-tic']">
		<assert id="OPP-032-Tender_R" role="ERROR" diagnostics="OPP-032-Tender" test="count(efbc:TermPercent) &lt; 2">rule|text|OPP-032-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ContractTerm[not(efbc:TermCode/text()='all-rev-tic')][efbc:TermCode/@listName='contract-detail']">
		<assert id="OPP-031-Tender_A" role="ERROR" diagnostics="OPP-031-Tender" test="count(efbc:TermDescription[@languageID = preceding-sibling::efbc:TermDescription/@languageID]) = 0">rule|text|OPP-031-Tender_A</assert>
		<assert id="OPP-031-Tender_B" role="ERROR" diagnostics="OPP-031-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:TermDescription/@languageID = $lg) or count(efbc:TermDescription) = 0">rule|text|OPP-031-Tender_B</assert>
		<assert id="OPP-031-Tender_C" role="ERROR" diagnostics="OPP-031-Tender" test="(every $lg in (efbc:TermDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:TermDescription) = 0">rule|text|OPP-031-Tender_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='ten-ran']">
		<assert id="BT-195_BT-171_-Tender_R" role="ERROR" diagnostics="BT-195_BT-171_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-171_-Tender_R</assert>
		<assert id="BT-196_BT-171_-Tender_A" role="ERROR" diagnostics="BT-196_BT-171_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-171_-Tender_A</assert>
		<assert id="BT-196_BT-171_-Tender_B" role="ERROR" diagnostics="BT-196_BT-171_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-171_-Tender_B</assert>
		<assert id="BT-196_BT-171_-Tender_C" role="ERROR" diagnostics="BT-196_BT-171_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-171_-Tender_C</assert>
		<assert id="BT-197_BT-171_-Tender_R" role="ERROR" diagnostics="BT-197_BT-171_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-171_-Tender_R</assert>
		<assert id="BT-198_BT-171_-Tender_R" role="ERROR" diagnostics="BT-198_BT-171_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-171_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='win-ten-val']">
		<assert id="BT-195_BT-720_-Tender_R" role="ERROR" diagnostics="BT-195_BT-720_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-720_-Tender_R</assert>
		<assert id="BT-196_BT-720_-Tender_A" role="ERROR" diagnostics="BT-196_BT-720_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-720_-Tender_A</assert>
		<assert id="BT-196_BT-720_-Tender_B" role="ERROR" diagnostics="BT-196_BT-720_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-720_-Tender_B</assert>
		<assert id="BT-196_BT-720_-Tender_C" role="ERROR" diagnostics="BT-196_BT-720_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-720_-Tender_C</assert>
		<assert id="BT-197_BT-720_-Tender_R" role="ERROR" diagnostics="BT-197_BT-720_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-720_-Tender_R</assert>
		<assert id="BT-198_BT-720_-Tender_R" role="ERROR" diagnostics="BT-198_BT-720_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-720_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='win-ten-var']">
		<assert id="BT-195_BT-193_-Tender_R" role="ERROR" diagnostics="BT-195_BT-193_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-193_-Tender_R</assert>
		<assert id="BT-196_BT-193_-Tender_A" role="ERROR" diagnostics="BT-196_BT-193_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-193_-Tender_A</assert>
		<assert id="BT-196_BT-193_-Tender_B" role="ERROR" diagnostics="BT-196_BT-193_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-193_-Tender_B</assert>
		<assert id="BT-196_BT-193_-Tender_C" role="ERROR" diagnostics="BT-196_BT-193_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-193_-Tender_C</assert>
		<assert id="BT-197_BT-193_-Tender_R" role="ERROR" diagnostics="BT-197_BT-193_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-193_-Tender_R</assert>
		<assert id="BT-198_BT-193_-Tender_R" role="ERROR" diagnostics="BT-198_BT-193_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-193_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:Origin/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='cou-ori']">
		<assert id="BT-195_BT-191_-Tender_R" role="ERROR" diagnostics="BT-195_BT-191_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-191_-Tender_R</assert>
		<assert id="BT-196_BT-191_-Tender_A" role="ERROR" diagnostics="BT-196_BT-191_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-191_-Tender_A</assert>
		<assert id="BT-196_BT-191_-Tender_B" role="ERROR" diagnostics="BT-196_BT-191_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-191_-Tender_B</assert>
		<assert id="BT-196_BT-191_-Tender_C" role="ERROR" diagnostics="BT-196_BT-191_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-191_-Tender_C</assert>
		<assert id="BT-197_BT-191_-Tender_R" role="ERROR" diagnostics="BT-197_BT-191_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-191_-Tender_R</assert>
		<assert id="BT-198_BT-191_-Tender_R" role="ERROR" diagnostics="BT-198_BT-191_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-191_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm">
		<assert id="BT-553-Tender_R" role="ERROR" diagnostics="BT-553-Tender" test="count(efbc:TermAmount) &lt; 2">rule|text|BT-553-Tender_R</assert>
		<assert id="BT-554-Tender_A" role="ERROR" diagnostics="BT-554-Tender" test="count(efbc:TermDescription[@languageID = preceding-sibling::efbc:TermDescription/@languageID]) = 0">rule|text|BT-554-Tender_A</assert>
		<assert id="BT-554-Tender_B" role="ERROR" diagnostics="BT-554-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:TermDescription/@languageID = $lg) or count(efbc:TermDescription) = 0">rule|text|BT-554-Tender_B</assert>
		<assert id="BT-554-Tender_C" role="ERROR" diagnostics="BT-554-Tender" test="(every $lg in (efbc:TermDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:TermDescription) = 0">rule|text|BT-554-Tender_C</assert>
		<assert id="BT-555-Tender_R" role="ERROR" diagnostics="BT-555-Tender" test="count(efbc:TermPercent) &lt; 2">rule|text|BT-555-Tender_R</assert>
		<assert id="BT-730-Tender_R" role="ERROR" diagnostics="BT-730-Tender" test="count(efbc:ValueKnownIndicator) &lt; 2">rule|text|BT-730-Tender_R</assert>
		<assert id="BT-731-Tender_R" role="ERROR" diagnostics="BT-731-Tender" test="count(efbc:PercentageKnownIndicator) &lt; 2">rule|text|BT-731-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-con']">
		<assert id="BT-195_BT-773_-Tender_R" role="ERROR" diagnostics="BT-195_BT-773_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-773_-Tender_R</assert>
		<assert id="BT-196_BT-773_-Tender_A" role="ERROR" diagnostics="BT-196_BT-773_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-773_-Tender_A</assert>
		<assert id="BT-196_BT-773_-Tender_B" role="ERROR" diagnostics="BT-196_BT-773_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-773_-Tender_B</assert>
		<assert id="BT-196_BT-773_-Tender_C" role="ERROR" diagnostics="BT-196_BT-773_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-773_-Tender_C</assert>
		<assert id="BT-197_BT-773_-Tender_R" role="ERROR" diagnostics="BT-197_BT-773_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-773_-Tender_R</assert>
		<assert id="BT-198_BT-773_-Tender_R" role="ERROR" diagnostics="BT-198_BT-773_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-773_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-des']">
		<assert id="BT-195_BT-554_-Tender_R" role="ERROR" diagnostics="BT-195_BT-554_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-554_-Tender_R</assert>
		<assert id="BT-196_BT-554_-Tender_A" role="ERROR" diagnostics="BT-196_BT-554_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-554_-Tender_A</assert>
		<assert id="BT-196_BT-554_-Tender_B" role="ERROR" diagnostics="BT-196_BT-554_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-554_-Tender_B</assert>
		<assert id="BT-196_BT-554_-Tender_C" role="ERROR" diagnostics="BT-196_BT-554_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-554_-Tender_C</assert>
		<assert id="BT-197_BT-554_-Tender_R" role="ERROR" diagnostics="BT-197_BT-554_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-554_-Tender_R</assert>
		<assert id="BT-198_BT-554_-Tender_R" role="ERROR" diagnostics="BT-198_BT-554_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-554_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-per']">
		<assert id="BT-195_BT-555_-Tender_R" role="ERROR" diagnostics="BT-195_BT-555_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-555_-Tender_R</assert>
		<assert id="BT-196_BT-555_-Tender_A" role="ERROR" diagnostics="BT-196_BT-555_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-555_-Tender_A</assert>
		<assert id="BT-196_BT-555_-Tender_B" role="ERROR" diagnostics="BT-196_BT-555_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-555_-Tender_B</assert>
		<assert id="BT-196_BT-555_-Tender_C" role="ERROR" diagnostics="BT-196_BT-555_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-555_-Tender_C</assert>
		<assert id="BT-197_BT-555_-Tender_R" role="ERROR" diagnostics="BT-197_BT-555_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-555_-Tender_R</assert>
		<assert id="BT-198_BT-555_-Tender_R" role="ERROR" diagnostics="BT-198_BT-555_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-555_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-per-kno']">
		<assert id="BT-195_BT-731_-Tender_R" role="ERROR" diagnostics="BT-195_BT-731_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-731_-Tender_R</assert>
		<assert id="BT-196_BT-731_-Tender_A" role="ERROR" diagnostics="BT-196_BT-731_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-731_-Tender_A</assert>
		<assert id="BT-196_BT-731_-Tender_B" role="ERROR" diagnostics="BT-196_BT-731_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-731_-Tender_B</assert>
		<assert id="BT-196_BT-731_-Tender_C" role="ERROR" diagnostics="BT-196_BT-731_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-731_-Tender_C</assert>
		<assert id="BT-197_BT-731_-Tender_R" role="ERROR" diagnostics="BT-197_BT-731_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-731_-Tender_R</assert>
		<assert id="BT-198_BT-731_-Tender_R" role="ERROR" diagnostics="BT-198_BT-731_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-731_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-val']">
		<assert id="BT-195_BT-553_-Tender_R" role="ERROR" diagnostics="BT-195_BT-553_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-553_-Tender_R</assert>
		<assert id="BT-196_BT-553_-Tender_A" role="ERROR" diagnostics="BT-196_BT-553_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-553_-Tender_A</assert>
		<assert id="BT-196_BT-553_-Tender_B" role="ERROR" diagnostics="BT-196_BT-553_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-553_-Tender_B</assert>
		<assert id="BT-196_BT-553_-Tender_C" role="ERROR" diagnostics="BT-196_BT-553_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-553_-Tender_C</assert>
		<assert id="BT-197_BT-553_-Tender_R" role="ERROR" diagnostics="BT-197_BT-553_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-553_-Tender_R</assert>
		<assert id="BT-198_BT-553_-Tender_R" role="ERROR" diagnostics="BT-198_BT-553_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-553_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-val-kno']">
		<assert id="BT-195_BT-730_-Tender_R" role="ERROR" diagnostics="BT-195_BT-730_-Tender" test="count(efbc:FieldIdentifierCode) &lt; 2">rule|text|BT-195_BT-730_-Tender_R</assert>
		<assert id="BT-196_BT-730_-Tender_A" role="ERROR" diagnostics="BT-196_BT-730_-Tender" test="count(efbc:ReasonDescription[@languageID = preceding-sibling::efbc:ReasonDescription/@languageID]) = 0">rule|text|BT-196_BT-730_-Tender_A</assert>
		<assert id="BT-196_BT-730_-Tender_B" role="ERROR" diagnostics="BT-196_BT-730_-Tender" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:ReasonDescription/@languageID = $lg) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-730_-Tender_B</assert>
		<assert id="BT-196_BT-730_-Tender_C" role="ERROR" diagnostics="BT-196_BT-730_-Tender" test="(every $lg in (efbc:ReasonDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:ReasonDescription) = 0">rule|text|BT-196_BT-730_-Tender_C</assert>
		<assert id="BT-197_BT-730_-Tender_R" role="ERROR" diagnostics="BT-197_BT-730_-Tender" test="count(cbc:ReasonCode) &lt; 2">rule|text|BT-197_BT-730_-Tender_R</assert>
		<assert id="BT-198_BT-730_-Tender_R" role="ERROR" diagnostics="BT-198_BT-730_-Tender" test="count(efbc:PublicationDate) &lt; 2">rule|text|BT-198_BT-730_-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm[efbc:TermCode/@listName='applicability']">
		<assert id="BT-773-Tender_R" role="ERROR" diagnostics="BT-773-Tender" test="count(efbc:TermCode) &lt; 2">rule|text|BT-773-Tender_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract">
		<assert id="BT-145-Contract_R" role="ERROR" diagnostics="BT-145-Contract" test="count(cbc:IssueDate) &lt; 2">rule|text|BT-145-Contract_R</assert>
		<assert id="BT-1451-Contract_R" role="ERROR" diagnostics="BT-1451-Contract" test="count(cbc:AwardDate) &lt; 2">rule|text|BT-1451-Contract_R</assert>
		<assert id="BT-150-Contract_R" role="ERROR" diagnostics="BT-150-Contract" test="count(efac:ContractReference/cbc:ID) &lt; 2">rule|text|BT-150-Contract_R</assert>
		<assert id="BT-151-Contract_R" role="ERROR" diagnostics="BT-151-Contract" test="count(cbc:URI) &lt; 2">rule|text|BT-151-Contract_R</assert>
		<assert id="BT-721-Contract_A" role="ERROR" diagnostics="BT-721-Contract" test="count(cbc:Title[@languageID = preceding-sibling::cbc:Title/@languageID]) = 0">rule|text|BT-721-Contract_A</assert>
		<assert id="BT-721-Contract_B" role="ERROR" diagnostics="BT-721-Contract" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:Title/@languageID = $lg) or count(cbc:Title) = 0">rule|text|BT-721-Contract_B</assert>
		<assert id="BT-721-Contract_C" role="ERROR" diagnostics="BT-721-Contract" test="(every $lg in (cbc:Title/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:Title) = 0">rule|text|BT-721-Contract_C</assert>
		<assert id="BT-768-Contract_R" role="ERROR" diagnostics="BT-768-Contract" test="count(efbc:ContractFrameworkIndicator) &lt; 2">rule|text|BT-768-Contract_R</assert>
		<assert id="OPT-100-Contract_R" role="ERROR" diagnostics="OPT-100-Contract" test="count(cac:NoticeDocumentReference/cbc:ID) &lt; 2">rule|text|OPT-100-Contract_R</assert>
		<assert id="OPT-316-Contract_R" role="ERROR" diagnostics="OPT-316-Contract" test="count(cbc:ID) &lt; 2">rule|text|OPT-316-Contract_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract/efac:DurationJustification">
		<assert id="OPP-020-Contract_R" role="ERROR" diagnostics="OPP-020-Contract" test="count(efbc:ExtendedDurationIndicator) &lt; 2">rule|text|OPP-020-Contract_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract/efac:DurationJustification/efac:AssetsList/efac:Asset">
		<assert id="OPP-021-Contract_A" role="ERROR" diagnostics="OPP-021-Contract" test="count(efbc:AssetDescription[@languageID = preceding-sibling::efbc:AssetDescription/@languageID]) = 0">rule|text|OPP-021-Contract_A</assert>
		<assert id="OPP-021-Contract_B" role="ERROR" diagnostics="OPP-021-Contract" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:AssetDescription/@languageID = $lg) or count(efbc:AssetDescription) = 0">rule|text|OPP-021-Contract_B</assert>
		<assert id="OPP-021-Contract_C" role="ERROR" diagnostics="OPP-021-Contract" test="(every $lg in (efbc:AssetDescription/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:AssetDescription) = 0">rule|text|OPP-021-Contract_C</assert>
		<assert id="OPP-022-Contract_A" role="ERROR" diagnostics="OPP-022-Contract" test="count(efbc:AssetSignificance[@languageID = preceding-sibling::efbc:AssetSignificance/@languageID]) = 0">rule|text|OPP-022-Contract_A</assert>
		<assert id="OPP-022-Contract_B" role="ERROR" diagnostics="OPP-022-Contract" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:AssetSignificance/@languageID = $lg) or count(efbc:AssetSignificance) = 0">rule|text|OPP-022-Contract_B</assert>
		<assert id="OPP-022-Contract_C" role="ERROR" diagnostics="OPP-022-Contract" test="(every $lg in (efbc:AssetSignificance/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:AssetSignificance) = 0">rule|text|OPP-022-Contract_C</assert>
		<assert id="OPP-023-Contract_A" role="ERROR" diagnostics="OPP-023-Contract" test="count(efbc:AssetPredominance[@languageID = preceding-sibling::efbc:AssetPredominance/@languageID]) = 0">rule|text|OPP-023-Contract_A</assert>
		<assert id="OPP-023-Contract_B" role="ERROR" diagnostics="OPP-023-Contract" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies efbc:AssetPredominance/@languageID = $lg) or count(efbc:AssetPredominance) = 0">rule|text|OPP-023-Contract_B</assert>
		<assert id="OPP-023-Contract_C" role="ERROR" diagnostics="OPP-023-Contract" test="(every $lg in (efbc:AssetPredominance/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(efbc:AssetPredominance) = 0">rule|text|OPP-023-Contract_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract/efac:Funding">
		<assert id="BT-5011-Contract_R" role="ERROR" diagnostics="BT-5011-Contract" test="count(cbc:FundingProgramCode) &lt; 2">rule|text|BT-5011-Contract_R</assert>
		<assert id="BT-722-Contract_A" role="ERROR" diagnostics="BT-722-Contract" test="count(cbc:FundingProgram[@languageID = preceding-sibling::cbc:FundingProgram/@languageID]) = 0">rule|text|BT-722-Contract_A</assert>
		<assert id="BT-722-Contract_B" role="ERROR" diagnostics="BT-722-Contract" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cbc:FundingProgram/@languageID = $lg) or count(cbc:FundingProgram) = 0">rule|text|BT-722-Contract_B</assert>
		<assert id="BT-722-Contract_C" role="ERROR" diagnostics="BT-722-Contract" test="(every $lg in (cbc:FundingProgram/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cbc:FundingProgram) = 0">rule|text|BT-722-Contract_C</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:TenderingParty">
		<assert id="OPT-210-Tenderer_R" role="ERROR" diagnostics="OPT-210-Tenderer" test="count(cbc:ID) &lt; 2">rule|text|OPT-210-Tenderer_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:TenderingParty/efac:Tenderer">
		<assert id="OPT-170-Tenderer_R" role="ERROR" diagnostics="OPT-170-Tenderer" test="count(efbc:GroupLeadIndicator) &lt; 2">rule|text|OPT-170-Tenderer_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Organizations/efac:Organization">
		<assert id="BT-633-Organization_R" role="ERROR" diagnostics="BT-633-Organization" test="count(efbc:NaturalPersonIndicator) &lt; 2">rule|text|BT-633-Organization_R</assert>
		<assert id="BT-746-Organization_R" role="ERROR" diagnostics="BT-746-Organization" test="count(efbc:ListedOnRegulatedMarketIndicator) &lt; 2">rule|text|BT-746-Organization_R</assert>
		<assert id="OPP-050-Organization_R" role="ERROR" diagnostics="OPP-050-Organization" test="count(efbc:GroupLeadIndicator) &lt; 2">rule|text|OPP-050-Organization_R</assert>
		<assert id="OPP-051-Organization_R" role="ERROR" diagnostics="OPP-051-Organization" test="count(efbc:AwardingCPBIndicator) &lt; 2">rule|text|OPP-051-Organization_R</assert>
		<assert id="OPP-052-Organization_R" role="ERROR" diagnostics="OPP-052-Organization" test="count(efbc:AcquiringCPBIndicator) &lt; 2">rule|text|OPP-052-Organization_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Organizations/efac:Organization/efac:Company">
		<assert id="BT-16-Organization-Company_R" role="ERROR" diagnostics="BT-16-Organization-Company" test="count(cac:PostalAddress/cbc:Department) &lt; 2">rule|text|BT-16-Organization-Company_R</assert>
		<assert id="BT-500-Organization-Company_A" role="ERROR" diagnostics="BT-500-Organization-Company" test="count(cac:PartyName/cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-500-Organization-Company_A</assert>
		<assert id="BT-500-Organization-Company_B" role="ERROR" diagnostics="BT-500-Organization-Company" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cac:PartyName/cbc:Name/@languageID = $lg) or count(cac:PartyName/cbc:Name) = 0">rule|text|BT-500-Organization-Company_B</assert>
		<assert id="BT-500-Organization-Company_C" role="ERROR" diagnostics="BT-500-Organization-Company" test="(every $lg in (cac:PartyName/cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cac:PartyName/cbc:Name) = 0">rule|text|BT-500-Organization-Company_C</assert>
		<assert id="BT-502-Organization-Company_R" role="ERROR" diagnostics="BT-502-Organization-Company" test="count(cac:Contact/cbc:Name) &lt; 2">rule|text|BT-502-Organization-Company_R</assert>
		<assert id="BT-503-Organization-Company_R" role="ERROR" diagnostics="BT-503-Organization-Company" test="count(cac:Contact/cbc:Telephone) &lt; 2">rule|text|BT-503-Organization-Company_R</assert>
		<assert id="BT-505-Organization-Company_R" role="ERROR" diagnostics="BT-505-Organization-Company" test="count(cbc:WebsiteURI) &lt; 2">rule|text|BT-505-Organization-Company_R</assert>
		<assert id="BT-506-Organization-Company_R" role="ERROR" diagnostics="BT-506-Organization-Company" test="count(cac:Contact/cbc:ElectronicMail) &lt; 2">rule|text|BT-506-Organization-Company_R</assert>
		<assert id="BT-507-Organization-Company_R" role="ERROR" diagnostics="BT-507-Organization-Company" test="count(cac:PostalAddress/cbc:CountrySubentityCode) &lt; 2">rule|text|BT-507-Organization-Company_R</assert>
		<assert id="BT-509-Organization-Company_R" role="ERROR" diagnostics="BT-509-Organization-Company" test="count(cbc:EndpointID) &lt; 2">rule|text|BT-509-Organization-Company_R</assert>
		<assert id="BT-510_a_-Organization-Company_R" role="ERROR" diagnostics="BT-510_a_-Organization-Company" test="count(cac:PostalAddress/cbc:StreetName) &lt; 2">rule|text|BT-510_a_-Organization-Company_R</assert>
		<assert id="BT-510_b_-Organization-Company_R" role="ERROR" diagnostics="BT-510_b_-Organization-Company" test="count(cac:PostalAddress/cbc:AdditionalStreetName) &lt; 2">rule|text|BT-510_b_-Organization-Company_R</assert>
		<assert id="BT-510_c_-Organization-Company_R" role="ERROR" diagnostics="BT-510_c_-Organization-Company" test="count(cac:PostalAddress/cac:AddressLine/cbc:Line) &lt; 2">rule|text|BT-510_c_-Organization-Company_R</assert>
		<assert id="BT-512-Organization-Company_R" role="ERROR" diagnostics="BT-512-Organization-Company" test="count(cac:PostalAddress/cbc:PostalZone) &lt; 2">rule|text|BT-512-Organization-Company_R</assert>
		<assert id="BT-513-Organization-Company_R" role="ERROR" diagnostics="BT-513-Organization-Company" test="count(cac:PostalAddress/cbc:CityName) &lt; 2">rule|text|BT-513-Organization-Company_R</assert>
		<assert id="BT-514-Organization-Company_R" role="ERROR" diagnostics="BT-514-Organization-Company" test="count(cac:PostalAddress/cac:Country/cbc:IdentificationCode) &lt; 2">rule|text|BT-514-Organization-Company_R</assert>
		<assert id="BT-739-Organization-Company_R" role="ERROR" diagnostics="BT-739-Organization-Company" test="count(cac:Contact/cbc:Telefax) &lt; 2">rule|text|BT-739-Organization-Company_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Organizations/efac:Organization/efac:Company[(cac:PartyIdentification/cbc:ID/text() = //efac:TenderingParty/efac:Tenderer/cbc:ID/text()) or (cac:PartyIdentification/cbc:ID/text() = //efac:TenderingParty/efac:Subcontractor/cbc:ID/text())]">
		<assert id="BT-165-Organization-Company_R" role="ERROR" diagnostics="BT-165-Organization-Company" test="count(efbc:CompanySizeCode) &lt; 2">rule|text|BT-165-Organization-Company_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Organizations/efac:Organization/efac:TouchPoint">
		<assert id="BT-16-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-16-Organization-TouchPoint" test="count(cac:PostalAddress/cbc:Department) &lt; 2">rule|text|BT-16-Organization-TouchPoint_R</assert>
		<assert id="BT-500-Organization-TouchPoint_A" role="ERROR" diagnostics="BT-500-Organization-TouchPoint" test="count(cac:PartyName/cbc:Name[@languageID = preceding-sibling::cbc:Name/@languageID]) = 0">rule|text|BT-500-Organization-TouchPoint_A</assert>
		<assert id="BT-500-Organization-TouchPoint_B" role="ERROR" diagnostics="BT-500-Organization-TouchPoint" test="(every $lg in (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID) satisfies cac:PartyName/cbc:Name/@languageID = $lg) or count(cac:PartyName/cbc:Name) = 0">rule|text|BT-500-Organization-TouchPoint_B</assert>
		<assert id="BT-500-Organization-TouchPoint_C" role="ERROR" diagnostics="BT-500-Organization-TouchPoint" test="(every $lg in (cac:PartyName/cbc:Name/@languageID) satisfies $lg = (/*/cbc:NoticeLanguageCode, /*/cac:AdditionalNoticeLanguage/cbc:ID)) or count(cac:PartyName/cbc:Name) = 0">rule|text|BT-500-Organization-TouchPoint_C</assert>
		<assert id="BT-502-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-502-Organization-TouchPoint" test="count(cac:Contact/cbc:Name) &lt; 2">rule|text|BT-502-Organization-TouchPoint_R</assert>
		<assert id="BT-503-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-503-Organization-TouchPoint" test="count(cac:Contact/cbc:Telephone) &lt; 2">rule|text|BT-503-Organization-TouchPoint_R</assert>
		<assert id="BT-505-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-505-Organization-TouchPoint" test="count(cbc:WebsiteURI) &lt; 2">rule|text|BT-505-Organization-TouchPoint_R</assert>
		<assert id="BT-506-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-506-Organization-TouchPoint" test="count(cac:Contact/cbc:ElectronicMail) &lt; 2">rule|text|BT-506-Organization-TouchPoint_R</assert>
		<assert id="BT-507-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-507-Organization-TouchPoint" test="count(cac:PostalAddress/cbc:CountrySubentityCode) &lt; 2">rule|text|BT-507-Organization-TouchPoint_R</assert>
		<assert id="BT-509-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-509-Organization-TouchPoint" test="count(cbc:EndpointID) &lt; 2">rule|text|BT-509-Organization-TouchPoint_R</assert>
		<assert id="BT-510_a_-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-510_a_-Organization-TouchPoint" test="count(cac:PostalAddress/cbc:StreetName) &lt; 2">rule|text|BT-510_a_-Organization-TouchPoint_R</assert>
		<assert id="BT-510_b_-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-510_b_-Organization-TouchPoint" test="count(cac:PostalAddress/cbc:AdditionalStreetName) &lt; 2">rule|text|BT-510_b_-Organization-TouchPoint_R</assert>
		<assert id="BT-510_c_-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-510_c_-Organization-TouchPoint" test="count(cac:PostalAddress/cac:AddressLine/cbc:Line) &lt; 2">rule|text|BT-510_c_-Organization-TouchPoint_R</assert>
		<assert id="BT-512-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-512-Organization-TouchPoint" test="count(cac:PostalAddress/cbc:PostalZone) &lt; 2">rule|text|BT-512-Organization-TouchPoint_R</assert>
		<assert id="BT-513-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-513-Organization-TouchPoint" test="count(cac:PostalAddress/cbc:CityName) &lt; 2">rule|text|BT-513-Organization-TouchPoint_R</assert>
		<assert id="BT-514-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-514-Organization-TouchPoint" test="count(cac:PostalAddress/cac:Country/cbc:IdentificationCode) &lt; 2">rule|text|BT-514-Organization-TouchPoint_R</assert>
		<assert id="BT-739-Organization-TouchPoint_R" role="ERROR" diagnostics="BT-739-Organization-TouchPoint" test="count(cac:Contact/cbc:Telefax) &lt; 2">rule|text|BT-739-Organization-TouchPoint_R</assert>
		<assert id="OPT-201-Organization-TouchPoint_R" role="ERROR" diagnostics="OPT-201-Organization-TouchPoint" test="count(cac:PartyIdentification/cbc:ID) &lt; 2">rule|text|OPT-201-Organization-TouchPoint_R</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Organizations/efac:UltimateBeneficialOwner">
		<assert id="BT-500-UBO_R" role="ERROR" diagnostics="BT-500-UBO" test="count(cbc:FamilyName) &lt; 2">rule|text|BT-500-UBO_R</assert>
		<assert id="BT-503-UBO_R" role="ERROR" diagnostics="BT-503-UBO" test="count(cac:Contact/cbc:Telephone) &lt; 2">rule|text|BT-503-UBO_R</assert>
		<assert id="BT-506-UBO_R" role="ERROR" diagnostics="BT-506-UBO" test="count(cac:Contact/cbc:ElectronicMail) &lt; 2">rule|text|BT-506-UBO_R</assert>
		<assert id="BT-507-UBO_R" role="ERROR" diagnostics="BT-507-UBO" test="count(cac:ResidenceAddress/cbc:CountrySubentityCode) &lt; 2">rule|text|BT-507-UBO_R</assert>
		<assert id="BT-510_a_-UBO_R" role="ERROR" diagnostics="BT-510_a_-UBO" test="count(cac:ResidenceAddress/cbc:StreetName) &lt; 2">rule|text|BT-510_a_-UBO_R</assert>
		<assert id="BT-510_b_-UBO_R" role="ERROR" diagnostics="BT-510_b_-UBO" test="count(cac:ResidenceAddress/cbc:AdditionalStreetName) &lt; 2">rule|text|BT-510_b_-UBO_R</assert>
		<assert id="BT-510_c_-UBO_R" role="ERROR" diagnostics="BT-510_c_-UBO" test="count(cac:ResidenceAddress/cac:AddressLine/cbc:Line) &lt; 2">rule|text|BT-510_c_-UBO_R</assert>
		<assert id="BT-512-UBO_R" role="ERROR" diagnostics="BT-512-UBO" test="count(cac:ResidenceAddress/cbc:PostalZone) &lt; 2">rule|text|BT-512-UBO_R</assert>
		<assert id="BT-513-UBO_R" role="ERROR" diagnostics="BT-513-UBO" test="count(cac:ResidenceAddress/cbc:CityName) &lt; 2">rule|text|BT-513-UBO_R</assert>
		<assert id="BT-514-UBO_R" role="ERROR" diagnostics="BT-514-UBO" test="count(cac:ResidenceAddress/cac:Country/cbc:IdentificationCode) &lt; 2">rule|text|BT-514-UBO_R</assert>
		<assert id="BT-739-UBO_R" role="ERROR" diagnostics="BT-739-UBO" test="count(cac:Contact/cbc:Telefax) &lt; 2">rule|text|BT-739-UBO_R</assert>
		<assert id="OPT-160-UBO_R" role="ERROR" diagnostics="OPT-160-UBO" test="count(cbc:FirstName) &lt; 2">rule|text|OPT-160-UBO_R</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference[not(cbc:ID/text()=('CrossBorderLaw','LocalLegalBasis'))]/cbc:DocumentDescription">
		<assert id="BT-01_d_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-01_d_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference[cbc:ID/text()='LocalLegalBasis']/cbc:DocumentDescription">
		<assert id="BT-01_f_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-01_f_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference[cbc:ID/text()='CrossBorderLaw']/cbc:DocumentDescription">
		<assert id="BT-09_b_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-09_b_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:FrameworkAgreement/cbc:Justification">
		<assert id="BT-109-Lot_D" role="ERROR" test="@languageID">rule|text|BT-109-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:FrameworkAgreement/cac:SubsequentProcessTenderRequirement[cbc:Name/text()='buyer-categories']/cbc:Description">
		<assert id="BT-111-Lot_D" role="ERROR" test="@languageID">rule|text|BT-111-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:AuctionTerms/cbc:Description">
		<assert id="BT-122-Lot_D" role="ERROR" test="@languageID">rule|text|BT-122-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:OpenTenderEvent/cac:OccurenceLocation/cbc:Description">
		<assert id="BT-133-Lot_D" role="ERROR" test="@languageID">rule|text|BT-133-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:OpenTenderEvent/cbc:Description">
		<assert id="BT-134-Lot_D" role="ERROR" test="@languageID">rule|text|BT-134-Lot_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='direct-award-justification']/cbc:ProcessReason">
		<assert id="BT-135-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-135-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='accelerated-procedure']/cbc:ProcessReason">
		<assert id="BT-1351-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-1351-Procedure_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Changes/efac:Change/efbc:ChangeDescription">
		<assert id="BT-141_a_-notice_D" role="ERROR" test="@languageID">rule|text|BT-141_a_-notice_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ConcessionRevenue/efbc:ValueDescription">
		<assert id="BT-163-Tender_D" role="ERROR" test="@languageID">rule|text|BT-163-Tender_D</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='cro-bor-law']/efbc:ReasonDescription">
		<assert id="BT-196_BT-09_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-09_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='pro-typ']/efbc:ReasonDescription">
		<assert id="BT-196_BT-105_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-105_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='accelerated-procedure']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='pro-acc']/efbc:ReasonDescription">
		<assert id="BT-196_BT-106_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-106_-Procedure_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='not-max-val']/efbc:ReasonDescription">
		<assert id="BT-196_BT-118_-NoticeResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-118_-NoticeResult_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='direct-award-justification']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='dir-awa-pre']/efbc:ReasonDescription">
		<assert id="BT-196_BT-1252_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-1252_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='accelerated-procedure']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='pro-acc-jus']/efbc:ReasonDescription">
		<assert id="BT-196_BT-1351_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-1351_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='direct-award-justification']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='dir-awa-tex']/efbc:ReasonDescription">
		<assert id="BT-196_BT-135_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-135_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='direct-award-justification']/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='dir-awa-jus']/efbc:ReasonDescription">
		<assert id="BT-196_BT-136_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-136_-Procedure_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='win-cho']/efbc:ReasonDescription">
		<assert id="BT-196_BT-142_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-142_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:DecisionReason/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='no-awa-rea']/efbc:ReasonDescription">
		<assert id="BT-196_BT-144_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-144_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:GroupFramework/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='gro-max-val']/efbc:ReasonDescription">
		<assert id="BT-196_BT-156_-NoticeResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-156_-NoticeResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ConcessionRevenue/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='con-rev-buy']/efbc:ReasonDescription">
		<assert id="BT-196_BT-160_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-160_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='not-val']/efbc:ReasonDescription">
		<assert id="BT-196_BT-161_-NoticeResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-161_-NoticeResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ConcessionRevenue/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='con-rev-use']/efbc:ReasonDescription">
		<assert id="BT-196_BT-162_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-162_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ConcessionRevenue/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='val-con-des']/efbc:ReasonDescription">
		<assert id="BT-196_BT-163_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-163_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='ten-ran']/efbc:ReasonDescription">
		<assert id="BT-196_BT-171_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-171_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:Origin/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='cou-ori']/efbc:ReasonDescription">
		<assert id="BT-196_BT-191_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-191_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='win-ten-var']/efbc:ReasonDescription">
		<assert id="BT-196_BT-193_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-193_-Tender_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-typ']/efbc:ReasonDescription">
		<assert id="BT-196_BT-539_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-539_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-typ']/efbc:ReasonDescription">
		<assert id="BT-196_BT-539_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-539_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-des']/efbc:ReasonDescription">
		<assert id="BT-196_BT-540_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-540_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-des']/efbc:ReasonDescription">
		<assert id="BT-196_BT-540_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-540_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-num']/efbc:ReasonDescription">
		<assert id="BT-196_BT-541_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-541_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-num']/efbc:ReasonDescription">
		<assert id="BT-196_BT-541_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-541_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-weight']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-wei']/efbc:ReasonDescription">
		<assert id="BT-196_BT-5421_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-5421_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-weight']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-wei']/efbc:ReasonDescription">
		<assert id="BT-196_BT-5421_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-5421_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-fixed']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-fix']/efbc:ReasonDescription">
		<assert id="BT-196_BT-5422_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-5422_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-fixed']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-fix']/efbc:ReasonDescription">
		<assert id="BT-196_BT-5422_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-5422_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-threshold']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-thr']/efbc:ReasonDescription">
		<assert id="BT-196_BT-5423_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-5423_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AwardCriterionParameter[efbc:ParameterCode/@listName='number-threshold']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-thr']/efbc:ReasonDescription">
		<assert id="BT-196_BT-5423_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-5423_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-com']/efbc:ReasonDescription">
		<assert id="BT-196_BT-543_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-543_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-com']/efbc:ReasonDescription">
		<assert id="BT-196_BT-543_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-543_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-val']/efbc:ReasonDescription">
		<assert id="BT-196_BT-553_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-553_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-des']/efbc:ReasonDescription">
		<assert id="BT-196_BT-554_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-554_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-per']/efbc:ReasonDescription">
		<assert id="BT-196_BT-555_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-555_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:GroupFramework/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='gro-max-ide']/efbc:ReasonDescription">
		<assert id="BT-196_BT-556_-NoticeResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-556_-NoticeResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='irregularity-type']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='buy-rev-cou']/efbc:ReasonDescription">
		<assert id="BT-196_BT-635_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-635_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='irregularity-type']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='buy-rev-typ']/efbc:ReasonDescription">
		<assert id="BT-196_BT-636_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-636_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FrameworkAgreementValues/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='max-val']/efbc:ReasonDescription">
		<assert id="BT-196_BT-709_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-709_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='ten-val-low']/efbc:ReasonDescription">
		<assert id="BT-196_BT-710_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-710_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='ten-val-hig']/efbc:ReasonDescription">
		<assert id="BT-196_BT-711_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-711_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:AppealRequestsStatistics[efbc:StatisticsCode/@listName='review-type']/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='rev-req']/efbc:ReasonDescription">
		<assert id="BT-196_BT-712_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-712_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='win-ten-val']/efbc:ReasonDescription">
		<assert id="BT-196_BT-720_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-720_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-val-kno']/efbc:ReasonDescription">
		<assert id="BT-196_BT-730_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-730_-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-per-kno']/efbc:ReasonDescription">
		<assert id="BT-196_BT-731_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-731_-Tender_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-ord']/efbc:ReasonDescription">
		<assert id="BT-196_BT-733_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-733_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-ord']/efbc:ReasonDescription">
		<assert id="BT-196_BT-733_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-733_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-nam']/efbc:ReasonDescription">
		<assert id="BT-196_BT-734_-Lot_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-734_-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='awa-cri-nam']/efbc:ReasonDescription">
		<assert id="BT-196_BT-734_-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-734_-LotsGroup_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='rec-sub-cou']/efbc:ReasonDescription">
		<assert id="BT-196_BT-759_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-759_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='rec-sub-typ']/efbc:ReasonDescription">
		<assert id="BT-196_BT-760_-LotResult_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-760_-LotResult_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='sub-con']/efbc:ReasonDescription">
		<assert id="BT-196_BT-773_-Tender_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-773_-Tender_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:FieldsPrivacy[efbc:FieldIdentifierCode/text()='pro-fea']/efbc:ReasonDescription">
		<assert id="BT-196_BT-88_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-196_BT-88_-Procedure_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:ContractModification/efac:ChangeReason/efbc:ReasonDescription">
		<assert id="BT-201-Contract_D" role="ERROR" test="@languageID">rule|text|BT-201-Contract_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:ContractModification/efac:Change/efbc:ChangeDescription">
		<assert id="BT-202-Contract_D" role="ERROR" test="@languageID">rule|text|BT-202-Contract_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cbc:Name">
		<assert id="BT-21-Lot_D" role="ERROR" test="@languageID">rule|text|BT-21-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:ProcurementProject/cbc:Name">
		<assert id="BT-21-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-21-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cbc:Name">
		<assert id="BT-21-Part_D" role="ERROR" test="@languageID">rule|text|BT-21-Part_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject/cbc:Name">
		<assert id="BT-21-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-21-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cbc:Description">
		<assert id="BT-24-Lot_D" role="ERROR" test="@languageID">rule|text|BT-24-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:ProcurementProject/cbc:Description">
		<assert id="BT-24-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-24-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cbc:Description">
		<assert id="BT-24-Part_D" role="ERROR" test="@languageID">rule|text|BT-24-Part_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject/cbc:Description">
		<assert id="BT-24-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-24-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cbc:Note">
		<assert id="BT-300-Lot_D" role="ERROR" test="@languageID">rule|text|BT-300-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:ProcurementProject/cbc:Note">
		<assert id="BT-300-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-300-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cbc:Note">
		<assert id="BT-300-Part_D" role="ERROR" test="@languageID">rule|text|BT-300-Part_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject/cbc:Note">
		<assert id="BT-300-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-300-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:Prize/cbc:Description">
		<assert id="BT-45-Lot_D" role="ERROR" test="@languageID">rule|text|BT-45-Lot_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Organizations/efac:Organization/efac:Company/cac:PartyName/cbc:Name">
		<assert id="BT-500-Organization-Company_D" role="ERROR" test="@languageID">rule|text|BT-500-Organization-Company_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Organizations/efac:Organization/efac:TouchPoint/cac:PartyName/cbc:Name">
		<assert id="BT-500-Organization-TouchPoint_D" role="ERROR" test="@languageID">rule|text|BT-500-Organization-TouchPoint_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:ContractExtension/cbc:OptionsDescription">
		<assert id="BT-54-Lot_D" role="ERROR" test="@languageID">rule|text|BT-54-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/cbc:Description">
		<assert id="BT-540-Lot_D" role="ERROR" test="@languageID">rule|text|BT-540-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/cbc:Description">
		<assert id="BT-540-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-540-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cbc:CalculationExpression">
		<assert id="BT-543-Lot_D" role="ERROR" test="@languageID">rule|text|BT-543-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cbc:CalculationExpression">
		<assert id="BT-543-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-543-LotsGroup_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:SubcontractingTerm/efbc:TermDescription">
		<assert id="BT-554-Tender_D" role="ERROR" test="@languageID">rule|text|BT-554-Tender_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:ContractExtension/cac:Renewal/cac:Period/cbc:Description">
		<assert id="BT-57-Lot_D" role="ERROR" test="@languageID">rule|text|BT-57-Lot_D</assert>
	</rule>
	<rule context="/*/cac:TenderingTerms/cac:TendererQualificationRequest/cac:SpecificTendererRequirement/cbc:Description">
		<assert id="BT-67_b_-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-67_b_-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:ContractExecutionRequirement[cbc:ExecutionRequirementCode/@listName='conditions']/cbc:Description">
		<assert id="BT-70-Lot_D" role="ERROR" test="@languageID">rule|text|BT-70-Lot_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract/cbc:Title">
		<assert id="BT-721-Contract_D" role="ERROR" test="@languageID">rule|text|BT-721-Contract_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract/efac:Funding/cbc:FundingProgram">
		<assert id="BT-722-Contract_D" role="ERROR" test="@languageID">rule|text|BT-722-Contract_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:RealizedLocation/cbc:Description">
		<assert id="BT-728-Lot_D" role="ERROR" test="@languageID">rule|text|BT-728-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Part']/cac:ProcurementProject/cac:RealizedLocation/cbc:Description">
		<assert id="BT-728-Part_D" role="ERROR" test="@languageID">rule|text|BT-728-Part_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProject/cac:RealizedLocation/cbc:Description">
		<assert id="BT-728-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-728-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:SecurityClearanceTerm/cbc:Description">
		<assert id="BT-732-Lot_D" role="ERROR" test="@languageID">rule|text|BT-732-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cbc:Description">
		<assert id="BT-733-Lot_D" role="ERROR" test="@languageID">rule|text|BT-733-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cbc:Description">
		<assert id="BT-733-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-733-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/cbc:Name">
		<assert id="BT-734-Lot_D" role="ERROR" test="@languageID">rule|text|BT-734-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='LotsGroup']/cac:TenderingTerms/cac:AwardingTerms/cac:AwardingCriterion/cac:SubordinateAwardingCriterion/cbc:Name">
		<assert id="BT-734-LotsGroup_D" role="ERROR" test="@languageID">rule|text|BT-734-LotsGroup_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingProcess/cac:ProcessJustification[cbc:ProcessReasonCode/@listName='no-esubmission-justification']/cbc:Description">
		<assert id="BT-745-Lot_D" role="ERROR" test="@languageID">rule|text|BT-745-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:SelectionCriteria/cbc:Name">
		<assert id="BT-749-Lot_D" role="ERROR" test="@languageID">rule|text|BT-749-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:RequiredFinancialGuarantee[cbc:GuaranteeTypeCode/text()='true']/cbc:Description">
		<assert id="BT-75-Lot_D" role="ERROR" test="@languageID">rule|text|BT-75-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:SelectionCriteria/cbc:Description">
		<assert id="BT-750-Lot_D" role="ERROR" test="@languageID">rule|text|BT-750-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType[cbc:ProcurementTypeCode/@listName='accessibility']/cbc:ProcurementType">
		<assert id="BT-755-Lot_D" role="ERROR" test="@languageID">rule|text|BT-755-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:TendererQualificationRequest[not(cac:SpecificTendererRequirement)]/cbc:CompanyLegalForm">
		<assert id="BT-76-Lot_D" role="ERROR" test="@languageID">rule|text|BT-76-Lot_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:Changes/efac:ChangeReason/efbc:ReasonDescription">
		<assert id="BT-762-notice_D" role="ERROR" test="@languageID">rule|text|BT-762-notice_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:PaymentTerms/cbc:Note">
		<assert id="BT-77-Lot_D" role="ERROR" test="@languageID">rule|text|BT-77-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)][not(cac:SpecificTendererRequirement/cbc:TendererRequirementTypeCode[@listName='reserved-procurement'])]/cac:SpecificTendererRequirement[./cbc:TendererRequirementTypeCode/@listName='missing-info-submission']/cbc:Description">
		<assert id="BT-772-Lot_D" role="ERROR" test="@languageID">rule|text|BT-772-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType[cbc:ProcurementTypeCode/@listName='strategic-procurement']/cbc:ProcurementType">
		<assert id="BT-777-Lot_D" role="ERROR" test="@languageID">rule|text|BT-777-Lot_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:AggregatedAmounts/efbc:PaidAmountDescription">
		<assert id="BT-780-Tender_D" role="ERROR" test="@languageID">rule|text|BT-780-Tender_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:ProcurementProject/cac:PlannedPeriod/cbc:Description">
		<assert id="BT-781-Lot_D" role="ERROR" test="@languageID">rule|text|BT-781-Lot_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AppealsInformation/efac:AppealStatus/cbc:Title">
		<assert id="BT-788-Review_D" role="ERROR" test="@languageID">rule|text|BT-788-Review_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AppealsInformation/efac:AppealStatus/cbc:Description">
		<assert id="BT-789-Review_D" role="ERROR" test="@languageID">rule|text|BT-789-Review_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AppealsInformation/efac:AppealStatus/efbc:WithdrawnAppealReasons">
		<assert id="BT-798-Review_D" role="ERROR" test="@languageID">rule|text|BT-798-Review_D</assert>
	</rule>
	<rule context="/*/cac:TenderingProcess/cbc:Description">
		<assert id="BT-88-Procedure_D" role="ERROR" test="@languageID">rule|text|BT-88-Procedure_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cbc:RecurringProcurementDescription">
		<assert id="BT-95-Lot_D" role="ERROR" test="@languageID">rule|text|BT-95-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:AppealTerms/cac:PresentationPeriod/cbc:Description">
		<assert id="BT-99-Lot_D" role="ERROR" test="@languageID">rule|text|BT-99-Lot_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract/efac:DurationJustification/efac:AssetsList/efac:Asset/efbc:AssetDescription">
		<assert id="OPP-021-Contract_D" role="ERROR" test="@languageID">rule|text|OPP-021-Contract_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract/efac:DurationJustification/efac:AssetsList/efac:Asset/efbc:AssetSignificance">
		<assert id="OPP-022-Contract_D" role="ERROR" test="@languageID">rule|text|OPP-022-Contract_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:SettledContract/efac:DurationJustification/efac:AssetsList/efac:Asset/efbc:AssetPredominance">
		<assert id="OPP-023-Contract_D" role="ERROR" test="@languageID">rule|text|OPP-023-Contract_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ContractTerm[not(efbc:TermCode/text()='all-rev-tic')][efbc:TermCode/@listName='contract-detail']/efbc:TermDescription">
		<assert id="OPP-031-Tender_D" role="ERROR" test="@languageID">rule|text|OPP-031-Tender_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeResult/efac:LotTender/efac:ContractTerm[efbc:TermCode/@listName='rewards-penalties']/efbc:TermDescription">
		<assert id="OPP-034-Tender_D" role="ERROR" test="@languageID">rule|text|OPP-034-Tender_D</assert>
	</rule>
	<rule context="/*/cbc:Note">
		<assert id="OPP-130-Business_D" role="ERROR" test="@languageID">rule|text|OPP-130-Business_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:ContractExecutionRequirement[cbc:ExecutionRequirementCode/@listName='reserved-execution']/cbc:Description">
		<assert id="OPT-070-Lot_D" role="ERROR" test="@languageID">rule|text|OPT-070-Lot_D</assert>
	</rule>
	<rule context="/*/cac:ProcurementProjectLot[cbc:ID/@schemeName='Lot']/cac:TenderingTerms/cac:ContractExecutionRequirement[cbc:ExecutionRequirementCode/@listName='customer-service']/cbc:Description">
		<assert id="OPT-072-Lot_D" role="ERROR" test="@languageID">rule|text|OPT-072-Lot_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AppealsInformation/efac:AppealStatus/efac:AppealProcessingParty/efbc:AppealProcessingPartyTypeDescription">
		<assert id="OPT-092-ReviewBody_D" role="ERROR" test="@languageID">rule|text|OPT-092-ReviewBody_D</assert>
	</rule>
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:AppealsInformation/efac:AppealStatus/efac:AppealingParty/efbc:AppealingPartyTypeDescription">
		<assert id="OPT-092-ReviewReq_D" role="ERROR" test="@languageID">rule|text|OPT-092-ReviewReq_D</assert>
	</rule>
</pattern>
