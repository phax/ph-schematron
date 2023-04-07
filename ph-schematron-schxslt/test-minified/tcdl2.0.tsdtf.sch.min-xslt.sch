<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="ISO19757-3">
<!-- This version: $Date: 2009/04/30 09:17:05 $ -->
  <!-- Use defaultPhase attribute or command line parameter to choose the phase that needs to run. -->
  <title>ISO Schematron Validator for Additional Constraints on TCDL 2.0 as Used by the Test Samples Development Task Force</title>
  <!-- ISO Schematron for Test Sample Metadata (http://www.w3.org/WAI/ER/tests/usingTCDL) 
    This file complements the W3C XML Schema at http://bentoweb.org/refs/schemas/tcdl2.0.xsd.
    TCDL 2.0 RDDL file available at http://bentoweb.org/refs/TCDL2.0/.
    Editor: Christophe Strobbe: Christophe (dot) Strobbe (at) esat (dot) kuleuven (dot) be.
  -->

  <!-- If the input document is namespaced, the namespace declarations need to be in two places:
    as a declaration in the document element, and as an ns element (see below).
  -->

  <ns prefix="dc" uri="http://purl.org/dc/elements/1.1/" />
  <ns prefix="html" uri="http://www.w3.org/1999/xhtml" />
  <ns prefix="tcd" uri="http://bentoweb.org/refs/TCDL2.0/" />
  <ns prefix="xlink" uri="http://www.w3.org/1999/xlink" />
  <ns prefix="earl" uri="http://www.w3.org/WAI/ER/EARL/nmg-strawman#" />
  <ns prefix="http" uri="http://www.w3.org/2006/http#" />
  <ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#" />
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />

  <!-- structure review -->
  <phase id="unconfirmed">
    <active pattern="root">Check for correct root element.</active>
    <!--iso:active pattern="formalMetadataCreator">Check for correct dc:creator.</iso:active-->
    <active pattern="formalMetadataLanguage">Check for correct dc:language.</active>
    <!--iso:active pattern="formalMetadataRights">Check for correct dc:rights (copyright).</iso:active-->
    <active pattern="formalMetadataDate">Check for correct dc:date (CVS date).</active>
    <active pattern="formalMetadataStatus_1">Check for status 'unconfirmed'.</active>
    <active pattern="formalMetadataVersion">Check for correct version indication (CVS Revision command).</active>
    <active pattern="formalMetadataSource">Check that source is not used.</active>
    <active pattern="technologiesSpec">Check technical spec.</active>
    <active pattern="technologiesMediatype">Check that technical spec has media type (if applicable).</active>
    <active pattern="technologiesHandle">Check that technical spec has handle.</active>
    <active pattern="testCasePreconditions">Check test case preconditions.</active>
    <active pattern="testCaseRequiredTests">Check required tests.</active>
    <active pattern="testCasePurposeWideClaim">Check that purpose relates to WCAG 2.0 only.</active>
    <active pattern="testCaseHTTPRequest">Check that file contains HTTP request.</active>
    <active pattern="testCaseObsoleteHTTPRequest">Check for obsolete httpRequest.</active>
    <active pattern="rulesPrimaryOnly">Check that only primary rules are used.</active>
    <active pattern="rulesLocationXPathMappings">Check that XPath expressions in location have a namespace mapping.</active>
    <active pattern="emptyNameSpacePrefix">Check that the namespace prefix for XPath expressions is not empty.</active>
    <!--iso:active pattern="rulesMostRecentGuidelines">Check that references to success criteria point to the most recent version of the guidelines.</iso:active-->
    <active pattern="rulesMostRecentTechniques">Check that references to techniques/failures point to the most recent version of Techniques and Failures.</active>
    <active pattern="rulesOnlyOneTechnique">Check that there is only one techniques or failure.</active>
    <active pattern="rulesNoFunctionalOutcome">Check that functionalOutcome element is not used.</active>
  </phase>
  <!-- initial evaluation -->
  <phase id="new">
   <active pattern="formalMetadataStatus_2">Check for valid status.</active>
  </phase>


  <!--iso:pattern name="abstracts">
    <iso:rule abstract="true" id="childLess">
      <iso:assert test="count(*) = 0"><name /> must not have any child elements.</iso:assert>
    </iso:rule>
  </iso:pattern-->



  <pattern id="root">
    <title>Top Level Test Case Description element</title>
    <rule context="/*">
      <assert test="self::tcd:testCaseDescription">The root element must be a "testCaseDescription" element.</assert>
    </rule>
  </pattern>


  <pattern id="formalMetadataCreator">
    <title>Formal metadata: dc:creator</title>
    <!--iso:rule context="tcd:formalMetadata/dc:creator">
      <iso:assert test="starts-with(normalize-space(.),'Developed by W3C/WAI')">Value of <iso:name /> must start with 'Developed by W3C/WAI'.</iso:assert>
      <iso:assert test="substring(normalize-space(.),22) = 's Evaluation and Repair Tools Working Group (ERT WG). We invite comments and discussion. Please address your feedback to public-wai-ert-tests@w3.org, a mailing list with a public archive.'">Value of dc:creator must end with "Evaluation and Repair Tools Working Group (ERT WG). We invite comments and discussion. Please address your feedback to public-wai-ert-tests@w3.org, a mailing list with a public archive." Found: "<iso:value-of select="substring(normalize-space(.),21)"/>"</iso:assert>
    </iso:rule-->
<!--@@ fix above assertions -->
    <!-- &amp;#x0027; is a double-escape hack to check attribute values that contain an apostrophe but does not work;
      need XSLT 2.0 character maps (see http://www-128.ibm.com/developerworks/xml/library/x-xslt20pt1.html#serial)
    -->

    <!--iso:rule context="dc:creator">
      <iso:assert test="string(normalize-space(.)) = 'Developed by W3C/WAI&amp;#x0027;s Evaluation and Repair Tools Working Group (ERT WG). We invite comments and discussion. Please address your feedback to public-wai-ert-tests@w3.org, a mailing list with a public archive.'">Value of dc:creator must contain the text 'Developed by W3C/WAI's Evaluation and Repair Tools Working Group (ERT WG). We invite comments and discussion. Please address your feedback to public-wai-ert-tests@w3.org, a mailing list with a public archive.'.</iso:assert>
    </iso:rule-->

    <!-- @@ rules to check markup within dc:creator -->
  </pattern>

  <pattern id="formalMetadataLanguage">
    <title>Formal metadata: language</title>
    <rule context="tcd:formalMetadata/dc:language">
      <assert test="normalize-space(.) = 'en'">Why is language in <name /> not English (en)?</assert>
    </rule>
  </pattern>

  <pattern id="formalMetadataRights">
    <!--iso:rule context="tcd:formalMetadata/dc:rights">
      <iso:assert test="string(normalize-space(.)) = 'Copyright © 1994-2009 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document use and software licensing rules apply. Your interactions with this site are in accordance with our public and Member privacy statements.'">Value of <iso:name /> (with markup removed) must be 'Copyright © 1994-2009 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document use and software licensing rules apply. Your interactions with this site are in accordance with our public and Member privacy statements.'</iso:assert>
    </iso:rule-->
<!-- @@fix above rule -->
    <!-- @@ rules to check markup within dc:rights -->
  </pattern>

  <pattern id="formalMetadataDate">
    <rule context="tcd:formalMetadata/dc:date">
      <!-- Really need XPath 2.0 regex here 
        (as in XML Schema: <xs:pattern value="$&#x20;?Date(:&#x20;\d{4}/\d{2}/\d{2}&#x20;[0-2]{1}[0-9]{1}:[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}&#x20;)?$"/>)
      -->

      <assert test="(normalize-space(.) = '$Date$') or starts-with(normalize-space(.), '$Date: ')">
        <name /> must use CVS date command.      </assert>
    </rule>
  </pattern>

  <pattern id="formalMetadataStatus_1">
    <rule context="tcd:formalMetadata/tcd:status">
      <assert test="(normalize-space(.) = 'unconfirmed')">
        <name /> can only be 'unconfirmed' during structure review.      </assert>
    </rule>
  </pattern>

  <pattern id="formalMetadataStatus_2">
    <rule context="tcd:formalMetadata/tcd:status">
      <assert test="(normalize-space(.) = 'unconfirmed') or (normalize-space(.) = 'new') or (normalize-space(.) = 'ballot') or (normalize-space(.) = 'pending') or (normalize-space(.) = 'holding') or (normalize-space(.) = 'rejected') or (normalize-space(.) = 'accepted') or (normalize-space(.) = 'deprecated')">
        <name /> must be one of: 'unconfirmed', 'new', 'ballot', 'pending', 'edits', 'fixes', 'holding', 'accepted', 'rejected', 'deprecated'.<!-- @@update when http://www.w3.org/WAI/ER/2006/tests/process is updated. -->      </assert>
    </rule>
  </pattern>

  <pattern id="formalMetadataVersion">
    <rule context="tcd:formalMetadata/tcd:version">
      <!-- Really need XPath 2.0 regex here -->
      <assert test="(normalize-space(.) = '$Revision$') or starts-with(normalize-space(.), '$Revision: ')">
        <name /> must use CVS Revision command.      </assert>
    </rule>
  </pattern>

  <pattern id="formalMetadataSource">
    <rule context="tcd:formalMetadata/tcd:source">
      <report test=".">
        <name /> must not be used.      </report>
    </rule>
  </pattern>

  <!-- @@note: depends on baseline concept. -->
  <pattern id="technologies">
    <!--iso:rule context="/tcd:testCaseDescription">
      <iso:assert test="count(tcd:technologies) = 1"><iso:name/> must contain exactly one tcd:technologies element.</iso:assert>
    </iso:rule-->
<!-- Duplicates XSD. -->
  </pattern>

  <pattern id="technologiesSpec">
    <rule context="tcd:technologies">
      <assert test="tcd:technicalSpec">
        <name /> must contain at least one tcd:technicalSpec element.      </assert>
    </rule>
    <rule context="tcd:technologies/tcd:technicalSpec">
      <assert test="tcd:specName">tcd:specName in <name /> is required.</assert>
    </rule>
    <!-- Add rule to check that element listed is actually used in the document referenced by testCase/files/file/@xlink:href? 
      No, the element may not be in every file; file may not be XML. 
    -->

  </pattern>


  <pattern id="technologiesMediatype">
    <rule context="tcd:technicalSpec">
      <assert test="@mediatype">Each tcd:technicalSpec element that identifies a file format must have a mediatype attribute.</assert>
    </rule>
  </pattern>

  <pattern id="technologiesHandle">
    <rule context="tcd:technicalSpec">
      <assert test="@handle">Each tcd:technicalSpec element must have a handle attribute.</assert>
    </rule>
  </pattern>

  <pattern id="testCasePreconditions">
    <rule context="tcd:testCase/tcd:preconditions">
      <report test=".">
        <name /> are currently not defined.      </report>
    </rule>
<!-- @@ check when TSD TF metadata change to take precondtions into account. -->
  </pattern>

  <pattern id="testCasePurposeWideClaim">
    <rule context="tcd:testCase/tcd:purpose/tcd:p">
      <assert test="not(contains(normalize-space(.),'in all available accessibility guidelines documents'))">No claims should be made regarding documents other than WCAG 2.0.</assert>
    </rule>
  </pattern>

  <pattern id="testCaseRequiredTests">
    <rule context="tcd:testCase/tcd:requiredTests">
      <assert test=".">
        <name /> must not be used.      </assert>
    </rule>
  </pattern>

  <pattern id="testCaseHTTPRequest">
    <rule context="tcd:testCase/tcd:files/tcd:file">
      <assert test="(count(http:GetRequest) = 1) or (count(http:PostRequest) = 1) or (count(http:PutRequest) = 1) or (count(http:HeadRequest) = 1)">
        <name /> must contain one request element.      </assert>
    </rule>
  </pattern>

  <pattern id="testCaseObsoleteHTTPRequest">
    <rule context="tcd:testCase/tcd:files/tcd:file/tcd:httpRequest">
      <assert test=".">
        <name /> is obsolete.      </assert>
    </rule>
  </pattern>

  <pattern id="rulesPrimaryOnly">
    <rule context="tcd:rules/tcd:rule">
      <!--iso:assert test="@primary='yes'">Only primary rules (i.e. with primary="yes") are allowed.</iso:assert-->
      <assert test="not(@primary)">The primary attribute is not used in the Task Force Metadata.</assert>
    </rule>
  </pattern>


  <pattern id="rulesLocationXPathMappings">
    <!--iso:rule context="tcd:rule/tcd:locations/tcd:location[@xpath]">
      <iso:assert test="not(@xpath)"><iso:name/>/@xpath is deprecated in favour of EARL pointers.</iso:assert>
    </iso:rule-->

    <!-- The rule below selects nothing when previous rule is active?! So iso:assert from above was copied below. -->
    <rule context="tcd:rule/tcd:locations/tcd:location[@xpath][string-length(substring-before(@xpath, ':')) > 0]">
      <assert test="not(@xpath)">
        <name />/@xpath is deprecated in favour of EARL pointers.      </assert>
      <!-- If locations contains XPath, check that each namespace prefix is mapped to a URI (e.g. html:blah/svg:svg). --> <!-- @@ for each namespace!! @@ test with real files! -->
      <assert test="count(/tcd:testCaseDescription/tcd:namespaceMappings/tcd:namespace[@nsPrefix = substring-before(./@xpath, ':')]) > 0">Namespace prefix <value-of select="substring-before(@xpath, ':')" /> is not mapped to a URI.</assert>
      <!-- iso:assert above uses substring-before(./@xpath instead of substring-before(@xpath... cf. http://www.biglist.com/lists/xsl-list/archives/200002/msg00481.html : Compare attribute values (16 Feb 2000) -->
    </rule>
    <!--iso:rule context="tcd:rule/tcd:locations/tcd:location[@xpath][string-length(@xpath) = 0]">
    </iso:rule-->

    <rule context="tcd:rule/tcd:locations/tcd:location/earl:xPath">
      <assert test="../../../../../tcd:namespaceMappings">Namespace mapping for XPath expression(s) is/are missing.</assert>
    </rule>
  </pattern>

  <pattern id="rulesLocationEarlPointers">
    <!-- @@synchronize with EARL 1.0 location pointers : http://www.w3.org/TR/EARL10-Schema/#instancelocation -->
  </pattern>

  <pattern id="rulesLocationTechRefsExist">
    <rule context="tcd:rule/tcd:locations/tcd:location">
      <assert test="@techrefs">
        <name />/@techrefs is required.      </assert>
    </rule>
  </pattern>

  <pattern id="rulesLocationTechRefsSingle">
    <rule context="tcd:rule/tcd:locations/tcd:location[@techrefs][not(contains(@techrefs, ' '))]">
      <assert test="count(../../tcd:techniques/tcd:technique[@id = ./@techrefs]) = 1">There is no technique element with ID <value-of select="./@techrefs" />.</assert>
    </rule>
  </pattern>

  <pattern id="rulesLocationTechRefsMultiple">
    <rule context="tcd:rule/tcd:locations/tcd:location[@techrefs][contains(./@techrefs, ' ')]">
      <!-- @@ How parse @techrefs and check every reference? 
        XPath 2.0 treats xs:IDREFS as sequence of xs:IDREF; see http://www.w3.org/TR/xpath20/#id-typed-value 
        Use for expression (http://www.w3.org/TR/xpath20/#id-for-expressions)?
          "for $a in @techrefs return (/tcd:testCaseDescription/tcd:rules/tcd:rule/tcd:techniques/tcd:technique[@id = $a])" ??
      -->

      <!-- For now, only the first techrefs value is checked. -->
      <assert test="count(../../../tcd:rule/tcd:techniques/tcd:technique[@id = substring-before(./@techrefs, ' ')]) = 1">There is no technique element with ID <value-of select="substring-before(./@techrefs, ' ')" />. (Other references not checked.)</assert>
    </rule>
  </pattern>

  <pattern id="rulesLocationTechniques">
    <!-- Identifiers need to be the same as those used in the WCAG 2.0 Techniques and Failures doc. -->
  </pattern>

  <!-- Pattern only applicable when full URLs are used to identify "rules", not when WCAG 2.0 success criteria are identified by their IDs. -->
  <pattern id="rulesMostRecentGuidelines">
    <rule context="tcd:rule">
      <assert test="starts-with(@xlink:href, 'http://bentoweb.org/refs/rulesets.xml#WCAG2_20081211')">The <name /> element must point to the most recent version of Web Content Accessibility Guidelines 2.0.</assert>
    </rule>
  </pattern>

  <pattern id="rulesMostRecentTechniques">
    <rule context="tcd:technique">
      <assert test="starts-with(@xlink:href, 'http://www.w3.org/TR/2008/NOTE-WCAG20-TECHS-20081211')">The <name /> element must point to the most recent version of Techniques and Failures for Web Content Accessibility Guidelines 2.0.</assert>
    </rule>
  </pattern>

  <pattern id="rulesOnlyOneTechnique">
    <rule context="tcd:techniques">
      <assert test="count(tcd:technique) = 1">There must be exactly one technique or failure.</assert>
    </rule>
  </pattern>

  <pattern id="rulesNoFunctionalOutcome">
    <rule context="tcd:rule/tcd:functionalOutcome">
      <assert test=".">
        <name /> must not be used.      </assert>
    </rule>
  </pattern>

  <pattern id="emptyNameSpacePrefix">
    <rule context="tcd:namespaceMappings/tcd:namespace">
      <assert test="string-length(@nsPrefix) > 0">nsPrefix must not be empty.</assert>
    </rule>
    <rule context="tcd:rule/tcd:locations/tcd:location/earl:xPath/earl:expression">
      <assert test="not(contains(normalize-space(.), '/:'))">XPath expressions in <name /> must not have an empty namespace prefix.</assert>
    </rule>
  </pattern>

  <!--iso:diagnostics>
    <iso:diagnostic id="xyz">Actual xyz was <value-of select="/tcd:testCaseDescription/tcd:rules/tcd:rule/tcd:techniques/tcd:technique/@id" /></iso:diagnostic>
  </iso:diagnostics-->

</schema>
