<?xml version="1.0" encoding="UTF-8"?>

<pattern xmlns="http://purl.oclc.org/dsdl/schematron"
  id="ted-compatibility-pattern">

  <!-- This pattern solely serves for rules which check for compatibility with conditional ted rules -->

  <!--
     Adding rules because of conditional rules in eu schematron for legal basis

    32014L0023 , konzvgv              ,  BR-BT-00002-0100, BR-BT-00002-0101
    32014L0024 , vgv  /  vob-a-eu    , BR-BT-00002-0102, BR-BT-00105-0110 
    32014L0025 , sektvo             , BR-BT-00105-0112
    32009L0081 , vsvgv   / vob-a-vs   ,     BR-BT-00105-0111
     -->

  <rule context="/*">
    <!--  32014L0023 - 1 / replaced with konzvgv-->
    <assert id="DE-BR-BT-00002-0100" role="ERROR"
      test="((cbc:RegulatoryDomain/normalize-space(text()) = 'konzvgv') and (cbc:NoticeTypeCode/normalize-space(text()) = ('pin-cfc-social', 'cn-standard', 'veat', 'can-standard', 'can-social', 'can-modif'))) or not(cbc:RegulatoryDomain/normalize-space(text()) = 'konzvgv')"
      >If 'Legal basis' (BT-01) is 'konzvgv', then 'Notice type' (BT-02) must be 'Prior information notice or a periodic indicative notice used as a call for competition – light regime' or 'Contract or concession notice – standard regime' or 'Voluntary ex-ante transparency notice' or 'Contract or concession award notice – standard regime' or 'Contract or concession award notice – light regime'</assert>

    <!-- 32014L0023 - 2 / replace with konzvgv-->
    <assert id="DE-BR-BT-00002-0101" role="ERROR"
      test="( (ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = ('14', '19', '28', '32', '35', '40')  
                or (ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = 'E5' and cbc:RegulatoryDomain/normalize-space(text()) = 'konzvgv')
              )
              and not(cac:ProcurementProject/cac:ProcurementAdditionalType[cbc:ProcurementTypeCode/@listName = 'contract-nature']/cbc:ProcurementTypeCode/normalize-space(text()) = 'supplies') 
              and not(cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType[cbc:ProcurementTypeCode/@listName = 'contract-nature']/cbc:ProcurementTypeCode/normalize-space(text()) = 'supplies')
              and not(cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Part']/cac:ProcurementProject/cac:ProcurementAdditionalType[cbc:ProcurementTypeCode/@listName = 'contract-nature']/cbc:ProcurementTypeCode/normalize-space(text()) = 'supplies')
            )
            or not(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = ('14', '19', '28', '32', '35', '40') 
                    or (ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = 'E5' and cbc:RegulatoryDomain/normalize-space(text()) = 'konzvgv')
                  )"
      >If 'Legal basis' (BT-01) is 'konzvgv', then 'Additional nature of the contract' (BT-531) must be different from 'Supplies'</assert>

    <!-- 32014L0024 - 1 / replace with vgv and vob-a-eu , replaced = comparison with 'matches()' instead of 'or' to reduce length of check -->
    <assert id="DE-BR-BT-00002-0102" role="ERROR" 
      test="( (ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = ('1', '4', '7', '10', '12', '16', '20', '23', '25', '29', '33', '36', '38') 
              or (ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = 'E5' and  matches( cbc:RegulatoryDomain/normalize-space(text()) , '^(vgv|vob-a-eu)$' ) )
              )
              and not(cbc:NoticeTypeCode/normalize-space(text()) = 'subco')
            )
            or not(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = ('1', '4', '7', '10', '12', '16', '20', '23', '25', '29', '33', '36', '38') 
                    or (ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = 'E5' and matches( cbc:RegulatoryDomain/normalize-space(text()) , '^(vgv|vob-a-eu)$' ) )
                  )"
      >If 'Legal basis' (BT-01) is 'vgv' or 'vob-a-eu', then 'Notice type' (BT-02) cannot be 'Subcontracting notice'</assert>
  </rule>

  <rule context="/*/cac:TenderingProcess">
    <!-- 32014L0024 - 2 / replace with vgv and vob-a-eu, replaced = comparison with 'matches()' instead of 'or' to reduce length of check -->
    <assert id="DE-BR-BT-00105-0110" role="ERROR"
      test="(cbc:ProcedureCode/normalize-space(text()) = ('open', 'restricted', 'neg-w-call'))
            or not( (cac:ProcessJustification[cbc:ProcessReasonCode/@listName = 'accelerated-procedure']/cbc:ProcessReasonCode/normalize-space(text()) = 'true') 
                    and (../ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = ('16', '29', 'E5'))
                    and (cbc:ProcedureCode) 
                    and ( matches(../cbc:RegulatoryDomain/normalize-space(text()),'^(vgv|vob-a-eu)$') ))"
      >If 'Legal basis' (BT-01) is 'vgv' or 'vob-a-eu', 'The procedure is accelerated' (BT-106) can be 'Yes' only if 'Type of procedure' (BT-105) is 'Open', 'Restricted' or 'Negotiated with prior publication of a call for competition / competitive with negotiation'</assert>

    <!-- 32014L0025 / replace with sektvo -->
    <assert id="DE-BR-BT-00105-0112" role="ERROR"
      test="(cbc:ProcedureCode/normalize-space(text()) = ('open', 'restricted', 'neg-w-call', 'comp-dial'))
            or not( (cac:ProcessJustification[cbc:ProcessReasonCode/@listName = 'accelerated-procedure']/cbc:ProcessReasonCode/normalize-space(text()) = 'true') 
                    and (../ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = ('17', '30', 'E5')) 
                    and (cbc:ProcedureCode) 
                    and (../cbc:RegulatoryDomain/normalize-space(text()) = 'sektvo'))"
      >If 'Legal basis' (BT-01) is 'sektvo', 'The procedure is accelerated' (BT-106) can be 'Yes' only if 'Type of procedure' (BT-105) is 'Open', 'Restricted', 'Negotiated with prior publication of a call for competition / competitive with negotiation' or 'Competitive dialogue'</assert>

    <!-- 32009L0081 / replace with vsvgv and vob-a-vs, replaced = comparison with 'matches()' instead of 'or' to reduce length of check -->
    <assert id="DE-BR-BT-00105-0111" role="ERROR"
      test="(cbc:ProcedureCode/normalize-space(text()) = ('restricted', 'neg-w-call'))
            or not( (cac:ProcessJustification[cbc:ProcessReasonCode/@listName = 'accelerated-procedure']/cbc:ProcessReasonCode/normalize-space(text()) = 'true') 
                    and (../ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/efext:EformsExtension/efac:NoticeSubType/cbc:SubTypeCode/normalize-space(text()) = ('18', '31', 'E5')) 
                    and (cbc:ProcedureCode) 
                    and ( matches(../cbc:RegulatoryDomain/normalize-space(text()),'^(vsvgv|vob-a-vs)$') ))"
      >If 'Legal basis' (BT-01) is 'vsvgv' or 'vob-a-vs', 'The procedure is accelerated' (BT-106) can be 'Yes' only if 'Type of procedure' (BT-105) is 'Restricted' or 'Negotiated with prior publication of a call for competition / competitive with negotiation'</assert>
  </rule>

  <rule context="$ROOT-NODE/cac:ContractingParty">
    <!-- ('body-pl','body-pl-cga','body-pl-la','body-pl-ra','cga','def-cont','eu-ins-bod-ag',
    'grp-p-aut','int-org','la','org-sub','org-sub-cga','org-sub-la','org-sub-ra','ra') -->
    <!-- List of codes used in blacklisted rules from eforms-sdk, it is just a subset that is
    mapped to the corresponding values from the eforms-de codelist from urn:xeinkauf:eforms-de:codelist:eforms-buyer-legal-type -->
    <let name="BUYER-LEGAL-TYPES-BT-10"
      value="('koerp-oer-bund','anst-oer-bund','stift-oer-bund','koerp-oer-kommun','anst-oer-kommun','stift-oer-kommun','koerp-oer-land','anst-oer-land','stift-oer-land','oberst-bbeh','omu-bbeh-niedrig','omu-bbeh','def-cont','eu-ins-bod-ag','grp-p-aut','int-org','kommun-beh','org-sub','oberst-lbeh','omu-lbeh')" />

    <assert id="DE-BR-BT-00010-A" role="ERROR" test="
        if ($SUBTYPE = $SUBTYPES-BT-10-A) then
          if (not(cac:ContractingPartyType/cbc:PartyTypeCode[@listName='buyer-legal-type']/normalize-space(text()) = $BUYER-LEGAL-TYPES-BT-10)) then
            (count(cac:ContractingActivity/cbc:ActivityTypeCode[@listName='authority-activity']) = 0)
          else
            true()
        else
          true()">[DE-BR-BT-00010-A] 'Activity of the contracting authority' (BT-10-Procedure-Buyer) is not allowed in notice subtypes <value-of select="$SUBTYPES-BT-10-A" /> under following condition: 'Legal type of the buyer' (BT-11-Procedure-Buyer) is not one of the following: <value-of select="$BUYER-LEGAL-TYPES-BT-10" />.</assert>
    <assert id="DE-BR-BT-00010-B" role="ERROR" test="
        if ($SUBTYPE = $SUBTYPES-BT-10-B)
        then
          if (cac:ContractingPartyType/cbc:PartyTypeCode[@listName='buyer-legal-type']/normalize-space(text()) = $BUYER-LEGAL-TYPES-BT-10) then
            (count(cac:ContractingActivity/cbc:ActivityTypeCode[@listName='authority-activity']) &gt; 0)
          else
            true()
        else
        true()">[DE-BR-BT-00010-B] 'Activity of the contracting authority' (BT-10-Procedure-Buyer) is mandatory in notice subtypes <value-of select="$SUBTYPES-BT-10-B" /> under following condition: 'Legal type of the buyer' (BT-11-Procedure-Buyer) is one of the following: <value-of select="$BUYER-LEGAL-TYPES-BT-10" />.</assert>
  </rule>

  <rule context="$ROOT-NODE/cac:ContractingParty">
    <!-- in ted ('org-sub','org-sub-cga','org-sub-ra','org-sub-la','eu-ins-bod-ag','def-cont','int-org') -->
    <!-- List of codes used in blacklisted rules from eforms-sdk, it is just a subset that is
   mapped to the corresponding values from the eforms-de codelist from urn:xeinkauf:eforms-de:codelist:eforms-buyer-legal-type -->
    <let name="BUYER-LEGAL-TYPES-BT-00740-0101"
      value="('org-sub','eu-ins-bod-ag','def-cont','int-org')" />

    <assert id="DE-BR-BT-00740-0101" role="ERROR"
      test="(cac:ContractingPartyType/cbc:PartyTypeCode[@listName='buyer-contracting-type']/normalize-space(text()) = 'not-cont-ent')
    or not(($SUBTYPE = $SUBTYPES-BT-740)
    and (cac:ContractingPartyType/cbc:PartyTypeCode[@listName='buyer-legal-type']/normalize-space(text()) = $BUYER-LEGAL-TYPES-BT-00740-0101)
    and not(../cbc:NoticeTypeCode/normalize-space(text()) = 'can-modif')
    and (cac:ContractingPartyType/cbc:PartyTypeCode[@listName='buyer-contracting-type']))">[DE-BR-BT-00740-0101] If 'Legal basis' (BT-01) is 'Directive 2014/23/EU' or 'Directive 2009/81/EC' and 'Legal type of the buyer' (BT-11) is one of the following: <value-of select="$BUYER-LEGAL-TYPES-BT-00740-0101" />, then 'The buyer is a contracting entity' (BT-740) must be 'No'</assert>
  </rule>

</pattern>
