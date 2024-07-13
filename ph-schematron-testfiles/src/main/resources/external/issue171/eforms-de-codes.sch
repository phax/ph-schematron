<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="codelists">

  <!-- 
  Check for the codelists values as definded by eforms-DE in https://projekte.kosit.org/eforms/eforms-de-codelist 
  CL = Codeliste Rule
  -->

  <!-- buyer-contracting-type -->
  <rule
    context="$ROOT-NODE/cac:ContractingParty/cac:ContractingPartyType/cbc:PartyTypeCode[@listName = 'buyer-contracting-type']">
    <!--Codes from urn:xeinkauf:eforms-de:codelist:buyer-contracting-type in version 1.0.2 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/buyer-contracting-type.gc-->
    <assert id="CL-DE-BT-740" test=". = ('cont-ent', 'not-cont-ent')" role="error">[CL-DE-BT-740] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:buyer-contracting-type:v1.0</assert>
  </rule>


  <!-- buyer-legal-type_eforms-buyer-legal-type  -->
  <rule
    context="$ROOT-NODE/cac:ContractingParty/cac:ContractingPartyType/cbc:PartyTypeCode[@listName = 'buyer-legal-type']">

    <!--Codes from urn:xeinkauf:eforms-de:codelist:eforms-buyer-legal-type in version 1.0.0 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/buyer-legal-type_eforms-buyer-legal-type.gc-->
    <assert id="CL-DE-BT-11" test=". = ('koerp-oer-bund', 'anst-oer-bund', 'stift-oer-bund', 'koerp-oer-kommun', 'anst-oer-kommun', 'stift-oer-kommun', 'koerp-oer-land', 'anst-oer-land', 'stift-oer-land', 'oberst-bbeh', 'omu-bbeh-niedrig', 'omu-bbeh', 'def-cont', 'eu-ins-bod-ag', 'grp-p-aut', 'int-org', 'kommun-beh', 'org-sub', 'pub-undert', 'pub-undert-cga', 'pub-undert-la', 'pub-undert-ra', 'oberst-lbeh', 'omu-lbeh', 'spec-rights-entity')" role="error">[CL-DE-BT-11] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:eforms-buyer-legal-type:v1.0</assert>

  </rule>


  <!-- exclusion-ground.gc -->
  <rule
    context="$ROOT-NODE/cac:TenderingTerms/cac:TendererQualificationRequest/cac:SpecificTendererRequirement/cbc:TendererRequirementTypeCode[@listName = 'exclusion-ground']">
    <!--Codes from urn:xeinkauf:eforms-de:codelist:exclusion-ground in version 2.0.0 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/criterion_exclusion-ground.gc-->
    <assert id="CL-DE-BT-67" test=". = ('bankr-nat', 'corruption', 'crime-org', 'distorsion', 'envir-law', 'finan-laund', 'fraud', 'human-traffic', 'insolvency', 'labour-law', 'liq-admin', 'misrepresent', 'nati-ground', 'partic-confl', 'prep-confl', 'prof-misconduct', 'sanction', 'socsec-law', 'socsec-pay', 'susp-act', 'tax-pay', 'terr-offence')" role="error">[CL-DE-BT-67] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:exclusion-ground:v1.0</assert>
  </rule>

  <!-- economic-operator-size.gc -->

  <!-- this xpath can be made more concise by cac:PartyIdentification/cbc:ID/text() = (list of possibilities)  as done in rule CR-DE-BT-165 -->
  <rule
    context="$EXTENSION-ORG-NODE/efac:Company[(cac:PartyIdentification/cbc:ID/text() = //efac:TenderingParty/efac:Tenderer/cbc:ID/text()) or (cac:PartyIdentification/cbc:ID/text() = //efac:TenderingParty/efac:Subcontractor/cbc:ID/text())]/efbc:CompanySizeCode">

    <!--Codes from urn:xeinkauf:eforms-de:codelist:economic-operator-size:v1.0 in version 1.0.0 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/economic-operator-size.gc-->
    <assert id="CL-DE-BT-165" test=". = ('large', 'medium', 'micro', 'small')" role="error">[CL-DE-BT-165] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:economic-operator-size:v1.0</assert>

  </rule>
  <!-- missing-info-submission.gc -->
  <!-- i think we can simplify to just cbc:TendererRequirementTypeCode[@listName='missing-info-submission'] because we do not need to take care of which field is BT-771   -->
  <rule
    context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:TenderingTerms/cac:TendererQualificationRequest[not(cbc:CompanyLegalFormCode)]/cac:SpecificTendererRequirement[not(cbc:TendererRequirementTypeCode[@listName = 'reserved-procurement'])]/cbc:TendererRequirementTypeCode[@listName = 'missing-info-submission']">

    <!--Codes from urn:xeinkauf:eforms-de:codelist:missing-info-submission in version 1.0.0 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/missing-info-submission.gc-->
    <assert id="CL-DE-BT-771" test=". = ('late-all', 'late-some', 'late-none')" role="error">[CL-DE-BT-771] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:missing-info-submission:v1.0</assert>

  </rule>
  <!-- procurement-procedure-type.gc -->
  <rule context="$ROOT-NODE/cac:TenderingProcess/cbc:ProcedureCode">

    <!--Codes from urn:xeinkauf:eforms-de:codelist:procurement-procedure-type in version 1.0.1 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/procurement-procedure-type.gc-->
    <assert id="CL-DE-BT-105" test=". = ('comp-dial', 'innovation', 'neg-w-call', 'us-neg-w-call', 'neg-wo-call', 'us-neg-wo-call', 'open', 'us-open', 'oth-mult', 'oth-single', 'us-free-tw', 'us-free-no-tw', 'us-hhr', 'restricted', 'us-res-tw', 'us-res-no-tw')" role="error">[CL-DE-BT-105] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:procurement-procedure-type:v1.0</assert>
  </rule>

  <!-- gpp-criteria.gc -->
  <!-- simplified context path  -->
  <rule
    context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'gpp-criteria']">

    <!--Codes from urn:xeinkauf:eforms-de:codelist:gpp-criteria in version 1.0.2 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/gpp-criteria.gc-->
    <assert id="CL-DE-BT-805" test=". = ('emas-com', 'ene-ef-com', 'iso-14001-com', 'iso-14024-com', 'reg-834-2007-com', 'kosten-lebenszyklus', 'other')" role="error">[CL-DE-BT-805] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:gpp-criteria:v1.0</assert>

  </rule>

  <!-- eforms-de-specific-legal-basis.gc -->

  <!-- Rule for BT-01(c), added CrossBorderLaw to allow use of BT-09(a), which uses the same xml field. -->
  <rule
    context="$ROOT-NODE/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID">
<!--  must always ne in addition to tailored codelist  values -->
<let name="CROSSBORDERLAW" value="'CrossBorderLaw'" />
    <!--Codes from urn:xeinkauf:eforms-de:codelist:eforms-de-specific-legal-basis in version 1.1.0 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.7.0/codelists/legal-basis_eforms-legal-basis.gc-->
    <assert id="CL-DE-BT-01" test=". = ('vsvgv', 'vob-a-vs', 'konzvgv', 'vgv', 'vob-a-eu', 'sektvo', 'other', 'sgb-vi', 'vob-a', 'uvgo', 'vol-a', 'sl-other', 'svhv', $CROSSBORDERLAW)" role="error">[CL-DE-BT-01] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:eforms-de-specific-legal-basis:v1.1</assert>
  </rule>

  <!-- received-submission-type.gc -->
  <rule
    context="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult/efac:ReceivedSubmissionsStatistics/efbc:StatisticsCode">
    <!--Codes from urn:xeinkauf:eforms-de:codelist:received-submission-type:v1.0 in version 1.0.0 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/received-submission-type.gc-->
    <assert id="CL-DE-BT-760" test=". = ('part-req', 't-esubm', 't-med', 't-micro', 't-no-eea', 't-no-verif', 't-oth-eea', 't-small', 't-sme', 't-verif-inad', 't-verif-inad-low', 'tenders')" role="error">[CL-DE-BT-760] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:received-submission-type:v1.0</assert>
  </rule>

<!--  social-objective.gc-->
  <rule
    context="$ROOT-NODE/cac:ProcurementProjectLot[cbc:ID/@schemeName = 'Lot']/cac:ProcurementProject/cac:ProcurementAdditionalType/cbc:ProcurementTypeCode[@listName = 'social-objective']">
<!--Codes from urn:xeinkauf:eforms-de:codelist:social-objective in version 1.0.0 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/social-objective.gc--><assert id="CL-DE-BT-775"
        test=". = ('acc-all','et-eq','gen-eq','hum-right','opp','other','iao-core','work-cond')"
        role="error">[CL-DE-BT-775] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:social-objective:v1.0</assert>

  </rule>

<!-- suitable business type is checked by rule: -->


<!-- vehicle-category.gc yesy file is src/test/conditional-mandatory/eforms_CAN_29_max-DE_BR-DE-24.xml-->

<rule context="$EXTENSION-NODE/efac:NoticeResult/efac:LotResult/efac:StrategicProcurement/efac:StrategicProcurementInformation/efac:ProcurementDetails/efbc:AssetCategoryCode[@listName = 'vehicle-category']">
<!--Codes from urn:xeinkauf:eforms-de:codelist:vehicle-category in version 1.0.0 derived from  https://github.com/OP-TED/eForms-SDK/blob/1.10.1/codelists/vehicle-category.gc--><assert id="CL-DE-BT-723"
        test=". = ('m1','m2','m3','n1','n2','n3')"
        role="error">[CL-DE-BT-723] Value must be one from codelist urn:xeinkauf:eforms-de:codelist:vehicle-category:v1.0</assert>
</rule>

</pattern>
