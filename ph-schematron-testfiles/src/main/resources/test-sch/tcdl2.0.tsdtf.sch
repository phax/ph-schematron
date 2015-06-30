<?xml version="1.0" encoding="UTF-8"?>
<iso:schema xmlns="http://purl.oclc.org/dsdl/schematron" 
  xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:tcd="http://bentoweb.org/refs/TCDL2.0/"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:earl="http://www.w3.org/WAI/ER/EARL/nmg-strawman#"
  xmlns:http="http://www.w3.org/2006/http#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  queryBinding="xslt2"
  schemaVersion="ISO19757-3"
><!-- This version: $Date: 2009/04/30 09:17:05 $ -->
  <!-- Use defaultPhase attribute or command line parameter to choose the phase that needs to run. -->
  <iso:title>ISO Schematron Validator for Additional Constraints on TCDL 2.0 as Used by the Test Samples Development Task Force</iso:title>
  <!-- ISO Schematron for Test Sample Metadata (http://www.w3.org/WAI/ER/tests/usingTCDL) 
    This file complements the W3C XML Schema at http://bentoweb.org/refs/schemas/tcdl2.0.xsd.
    TCDL 2.0 RDDL file available at http://bentoweb.org/refs/TCDL2.0/.
    Editor: Christophe Strobbe: Christophe (dot) Strobbe (at) esat (dot) kuleuven (dot) be.
  -->
  <!-- If the input document is namespaced, the namespace declarations need to be in two places:
    as a declaration in the document element, and as an ns element (see below).
  -->
  <iso:ns prefix='dc' uri='http://purl.org/dc/elements/1.1/'/>
  <iso:ns prefix='html' uri='http://www.w3.org/1999/xhtml'/>
  <iso:ns prefix='tcd' uri='http://bentoweb.org/refs/TCDL2.0/'/>
  <iso:ns prefix='xlink' uri='http://www.w3.org/1999/xlink'/>
  <iso:ns prefix='earl' uri='http://www.w3.org/WAI/ER/EARL/nmg-strawman#'/>
  <iso:ns prefix='http' uri='http://www.w3.org/2006/http#'/>
  <iso:ns prefix='rdf' uri='http://www.w3.org/1999/02/22-rdf-syntax-ns#'/>
  <iso:ns prefix='xs' uri='http://www.w3.org/2001/XMLSchema'/>

  <!-- structure review -->
  <iso:phase id="unconfirmed">
    <iso:active pattern="root">Check for correct root element.</iso:active>
    <!--iso:active pattern="formalMetadataCreator">Check for correct dc:creator.</iso:active-->
    <iso:active pattern="formalMetadataLanguage">Check for correct dc:language.</iso:active>
    <!--iso:active pattern="formalMetadataRights">Check for correct dc:rights (copyright).</iso:active-->
    <iso:active pattern="formalMetadataDate">Check for correct dc:date (CVS date).</iso:active>
    <iso:active pattern="formalMetadataStatus_1">Check for status 'unconfirmed'.</iso:active>
    <iso:active pattern="formalMetadataVersion">Check for correct version indication (CVS Revision command).</iso:active>
    <iso:active pattern="formalMetadataSource">Check that source is not used.</iso:active>
    <iso:active pattern="technologiesSpec">Check technical spec.</iso:active>
    <iso:active pattern="technologiesMediatype">Check that technical spec has media type (if applicable).</iso:active>
    <iso:active pattern="technologiesHandle">Check that technical spec has handle.</iso:active>
    <iso:active pattern="testCasePreconditions">Check test case preconditions.</iso:active>
    <iso:active pattern="testCaseRequiredTests">Check required tests.</iso:active>
    <iso:active pattern="testCasePurposeWideClaim">Check that purpose relates to WCAG 2.0 only.</iso:active>
    <iso:active pattern="testCaseHTTPRequest">Check that file contains HTTP request.</iso:active>
    <iso:active pattern="testCaseObsoleteHTTPRequest">Check for obsolete httpRequest.</iso:active>
    <iso:active pattern="rulesPrimaryOnly">Check that only primary rules are used.</iso:active>
    <iso:active pattern="rulesLocationXPathMappings">Check that XPath expressions in location have a namespace mapping.</iso:active>
    <iso:active pattern="emptyNameSpacePrefix">Check that the namespace prefix for XPath expressions is not empty.</iso:active>
    <!--iso:active pattern="rulesMostRecentGuidelines">Check that references to success criteria point to the most recent version of the guidelines.</iso:active-->
    <iso:active pattern="rulesMostRecentTechniques">Check that references to techniques/failures point to the most recent version of Techniques and Failures.</iso:active>
    <iso:active pattern="rulesOnlyOneTechnique">Check that there is only one techniques or failure.</iso:active>
    <iso:active pattern="rulesNoFunctionalOutcome">Check that functionalOutcome element is not used.</iso:active>
  </iso:phase>
  <!-- initial evaluation -->
  <iso:phase id="new">
   <iso:active pattern="formalMetadataStatus_2">Check for valid status.</iso:active>
  </iso:phase>


  <!--iso:pattern name="abstracts">
    <iso:rule abstract="true" id="childLess">
      <iso:assert test="count(*) = 0"><name /> must not have any child elements.</iso:assert>
    </iso:rule>
  </iso:pattern-->


  <iso:pattern id="root">
    <iso:title>Top Level Test Case Description element</iso:title>
    <iso:rule context="/*">
      <iso:assert test="self::tcd:testCaseDescription">The root element must be a "testCaseDescription" element.</iso:assert>
    </iso:rule>
  </iso:pattern>


  <iso:pattern id="formalMetadataCreator">
    <iso:title>Formal metadata: dc:creator</iso:title>
    <!--iso:rule context="tcd:formalMetadata/dc:creator">
      <iso:assert test="starts-with(normalize-space(.),'Developed by W3C/WAI')">Value of <iso:name /> must start with 'Developed by W3C/WAI'.</iso:assert>
      <iso:assert test="substring(normalize-space(.),22) = 's Evaluation and Repair Tools Working Group (ERT WG). We invite comments and discussion. Please address your feedback to public-wai-ert-tests@w3.org, a mailing list with a public archive.'">Value of dc:creator must end with "Evaluation and Repair Tools Working Group (ERT WG). We invite comments and discussion. Please address your feedback to public-wai-ert-tests@w3.org, a mailing list with a public archive." Found: "<iso:value-of select="substring(normalize-space(.),21)"/>"</iso:assert>
    </iso:rule--><!--@@ fix above assertions -->
    <!-- &amp;#x0027; is a double-escape hack to check attribute values that contain an apostrophe but does not work;
      need XSLT 2.0 character maps (see http://www-128.ibm.com/developerworks/xml/library/x-xslt20pt1.html#serial)
    -->
    <!--iso:rule context="dc:creator">
      <iso:assert test="string(normalize-space(.)) = 'Developed by W3C/WAI&amp;#x0027;s Evaluation and Repair Tools Working Group (ERT WG). We invite comments and discussion. Please address your feedback to public-wai-ert-tests@w3.org, a mailing list with a public archive.'">Value of dc:creator must contain the text 'Developed by W3C/WAI's Evaluation and Repair Tools Working Group (ERT WG). We invite comments and discussion. Please address your feedback to public-wai-ert-tests@w3.org, a mailing list with a public archive.'.</iso:assert>
    </iso:rule-->
    <!-- @@ rules to check markup within dc:creator -->
  </iso:pattern>

  <iso:pattern id="formalMetadataLanguage">
    <iso:title>Formal metadata: language</iso:title>
    <iso:rule context="tcd:formalMetadata/dc:language">
      <iso:assert test="normalize-space(.) = 'en'">Why is language in <iso:name /> not English (en)?</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="formalMetadataRights">
    <!--iso:rule context="tcd:formalMetadata/dc:rights">
      <iso:assert test="string(normalize-space(.)) = 'Copyright © 1994-2009 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document use and software licensing rules apply. Your interactions with this site are in accordance with our public and Member privacy statements.'">Value of <iso:name /> (with markup removed) must be 'Copyright © 1994-2009 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document use and software licensing rules apply. Your interactions with this site are in accordance with our public and Member privacy statements.'</iso:assert>
    </iso:rule--><!-- @@fix above rule -->
    <!-- @@ rules to check markup within dc:rights -->
  </iso:pattern>

  <iso:pattern id="formalMetadataDate">
    <iso:rule context="tcd:formalMetadata/dc:date">
      <!-- Really need XPath 2.0 regex here 
        (as in XML Schema: <xs:pattern value="$&#x20;?Date(:&#x20;\d{4}/\d{2}/\d{2}&#x20;[0-2]{1}[0-9]{1}:[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}&#x20;)?$"/>)
      -->
      <iso:assert test="(normalize-space(.) = '&#36;Date&#36;') or starts-with(normalize-space(.), '&#36;Date: ')"><iso:name /> must use CVS date command.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="formalMetadataStatus_1">
    <iso:rule context="tcd:formalMetadata/tcd:status">
      <iso:assert test="(normalize-space(.) = 'unconfirmed')"><iso:name /> can only be 'unconfirmed' during structure review.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="formalMetadataStatus_2">
    <iso:rule context="tcd:formalMetadata/tcd:status">
      <iso:assert test="(normalize-space(.) = 'unconfirmed') or (normalize-space(.) = 'new') or (normalize-space(.) = 'ballot') or (normalize-space(.) = 'pending') or (normalize-space(.) = 'holding') or (normalize-space(.) = 'rejected') or (normalize-space(.) = 'accepted') or (normalize-space(.) = 'deprecated')"><iso:name /> must be one of: 'unconfirmed', 'new', 'ballot', 'pending', 'edits', 'fixes', 'holding', 'accepted', 'rejected', 'deprecated'.<!-- @@update when http://www.w3.org/WAI/ER/2006/tests/process is updated. --></iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="formalMetadataVersion">
    <iso:rule context="tcd:formalMetadata/tcd:version">
      <!-- Really need XPath 2.0 regex here -->
      <iso:assert test="(normalize-space(.) = '&#36;Revision&#36;') or starts-with(normalize-space(.), '&#36;Revision: ')"><iso:name /> must use CVS Revision command.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="formalMetadataSource">
    <iso:rule context="tcd:formalMetadata/tcd:source">
      <iso:report test="."><iso:name/> must not be used.</iso:report>
    </iso:rule>
  </iso:pattern>

  <!-- @@note: depends on baseline concept. -->
  <iso:pattern id="technologies">
    <!--iso:rule context="/tcd:testCaseDescription">
      <iso:assert test="count(tcd:technologies) = 1"><iso:name/> must contain exactly one tcd:technologies element.</iso:assert>
    </iso:rule--><!-- Duplicates XSD. -->
  </iso:pattern>

  <iso:pattern id="technologiesSpec">
    <iso:rule context="tcd:technologies">
      <iso:assert test="tcd:technicalSpec"><iso:name/> must contain at least one tcd:technicalSpec element.</iso:assert>
    </iso:rule>
    <iso:rule context="tcd:technologies/tcd:technicalSpec">
      <iso:assert test="tcd:specName">tcd:specName in <iso:name/> is required.</iso:assert>
    </iso:rule>
    <!-- Add rule to check that element listed is actually used in the document referenced by testCase/files/file/@xlink:href? 
      No, the element may not be in every file; file may not be XML. 
    -->
  </iso:pattern>


  <iso:pattern id="technologiesMediatype">
    <iso:rule context="tcd:technicalSpec">
      <iso:assert test="@mediatype">Each tcd:technicalSpec element that identifies a file format must have a mediatype attribute.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="technologiesHandle">
    <iso:rule context="tcd:technicalSpec">
      <iso:assert test="@handle">Each tcd:technicalSpec element must have a handle attribute.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="testCasePreconditions">
    <iso:rule context="tcd:testCase/tcd:preconditions">
      <iso:report test="."><iso:name/> are currently not defined.</iso:report>
    </iso:rule><!-- @@ check when TSD TF metadata change to take precondtions into account. -->
  </iso:pattern>

  <iso:pattern id="testCasePurposeWideClaim">
    <iso:rule context="tcd:testCase/tcd:purpose/tcd:p">
      <iso:assert test="not(contains(normalize-space(.),'in all available accessibility guidelines documents'))">No claims should be made regarding documents other than WCAG 2.0.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="testCaseRequiredTests">
    <iso:rule context="tcd:testCase/tcd:requiredTests">
      <iso:assert test="."><iso:name/> must not be used.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="testCaseHTTPRequest">
    <iso:rule context="tcd:testCase/tcd:files/tcd:file">
      <iso:assert test="(count(http:GetRequest) = 1) or (count(http:PostRequest) = 1) or (count(http:PutRequest) = 1) or (count(http:HeadRequest) = 1)"><iso:name/> must contain one request element.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="testCaseObsoleteHTTPRequest">
    <iso:rule context="tcd:testCase/tcd:files/tcd:file/tcd:httpRequest">
      <iso:assert test="."><iso:name/> is obsolete.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="rulesPrimaryOnly">
    <iso:rule context="tcd:rules/tcd:rule">
      <!--iso:assert test="@primary='yes'">Only primary rules (i.e. with primary="yes") are allowed.</iso:assert-->
      <iso:assert test="not(@primary)">The primary attribute is not used in the Task Force Metadata.</iso:assert>
    </iso:rule>
  </iso:pattern>


  <iso:pattern id="rulesLocationXPathMappings">
    <!--iso:rule context="tcd:rule/tcd:locations/tcd:location[@xpath]">
      <iso:assert test="not(@xpath)"><iso:name/>/@xpath is deprecated in favour of EARL pointers.</iso:assert>
    </iso:rule-->
    <!-- The rule below selects nothing when previous rule is active?! So iso:assert from above was copied below. -->
    <iso:rule context="tcd:rule/tcd:locations/tcd:location[@xpath][string-length(substring-before(@xpath, ':')) &gt; 0]">
      <iso:assert test="not(@xpath)"><iso:name/>/@xpath is deprecated in favour of EARL pointers.</iso:assert>
      <!-- If locations contains XPath, check that each namespace prefix is mapped to a URI (e.g. html:blah/svg:svg). --> <!-- @@ for each namespace!! @@ test with real files! -->
      <iso:assert test="count(/tcd:testCaseDescription/tcd:namespaceMappings/tcd:namespace[@nsPrefix = substring-before(./@xpath, ':')]) &gt; 0">Namespace prefix <iso:value-of select="substring-before(@xpath, ':')"/> is not mapped to a URI.</iso:assert>
      <!-- iso:assert above uses substring-before(./@xpath instead of substring-before(@xpath... cf. http://www.biglist.com/lists/xsl-list/archives/200002/msg00481.html : Compare attribute values (16 Feb 2000) -->
    </iso:rule>
    <!--iso:rule context="tcd:rule/tcd:locations/tcd:location[@xpath][string-length(@xpath) = 0]">
    </iso:rule-->
    <iso:rule context="tcd:rule/tcd:locations/tcd:location/earl:xPath">
      <iso:assert test="../../../../../tcd:namespaceMappings">Namespace mapping for XPath expression(s) is/are missing.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="rulesLocationEarlPointers">
    <!-- @@synchronize with EARL 1.0 location pointers : http://www.w3.org/TR/EARL10-Schema/#instancelocation -->
  </iso:pattern>

  <iso:pattern id="rulesLocationTechRefsExist">
    <iso:rule context="tcd:rule/tcd:locations/tcd:location">
      <iso:assert test="@techrefs"><iso:name/>/@techrefs is required.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="rulesLocationTechRefsSingle">
    <iso:rule context="tcd:rule/tcd:locations/tcd:location[@techrefs][not(contains(@techrefs, ' '))]">
      <iso:assert test="count(../../tcd:techniques/tcd:technique[@id = ./@techrefs]) = 1">There is no technique element with ID <iso:value-of select="./@techrefs"/>.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="rulesLocationTechRefsMultiple">
    <iso:rule context="tcd:rule/tcd:locations/tcd:location[@techrefs][contains(./@techrefs, ' ')]">
      <!-- @@ How parse @techrefs and check every reference? 
        XPath 2.0 treats xs:IDREFS as sequence of xs:IDREF; see http://www.w3.org/TR/xpath20/#id-typed-value 
        Use for expression (http://www.w3.org/TR/xpath20/#id-for-expressions)?
          "for $a in @techrefs return (/tcd:testCaseDescription/tcd:rules/tcd:rule/tcd:techniques/tcd:technique[@id = $a])" ??
      -->
      <!-- For now, only the first techrefs value is checked. -->
      <iso:assert test="count(../../../tcd:rule/tcd:techniques/tcd:technique[@id = substring-before(./@techrefs, ' ')]) = 1">There is no technique element with ID <iso:value-of select="substring-before(./@techrefs, ' ')"/>. (Other references not checked.)</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="rulesLocationTechniques">
    <!-- Identifiers need to be the same as those used in the WCAG 2.0 Techniques and Failures doc. -->
  </iso:pattern>

  <!-- Pattern only applicable when full URLs are used to identify "rules", not when WCAG 2.0 success criteria are identified by their IDs. -->
  <iso:pattern id="rulesMostRecentGuidelines">
    <iso:rule context="tcd:rule">
      <iso:assert test="starts-with(@xlink:href, 'http://bentoweb.org/refs/rulesets.xml#WCAG2_20081211')">The <iso:name/> element must point to the most recent version of Web Content Accessibility Guidelines 2.0.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="rulesMostRecentTechniques">
    <iso:rule context="tcd:technique">
      <iso:assert test="starts-with(@xlink:href, 'http://www.w3.org/TR/2008/NOTE-WCAG20-TECHS-20081211')">The <iso:name/> element must point to the most recent version of Techniques and Failures for Web Content Accessibility Guidelines 2.0.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="rulesOnlyOneTechnique">
    <iso:rule context="tcd:techniques">
      <iso:assert test="count(tcd:technique) = 1">There must be exactly one technique or failure.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="rulesNoFunctionalOutcome">
    <iso:rule context="tcd:rule/tcd:functionalOutcome">
      <iso:assert test="."><iso:name/> must not be used.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="emptyNameSpacePrefix">
    <iso:rule context="tcd:namespaceMappings/tcd:namespace">
      <iso:assert test="string-length(@nsPrefix) &gt; 0">nsPrefix must not be empty.</iso:assert>
    </iso:rule>
    <iso:rule context="tcd:rule/tcd:locations/tcd:location/earl:xPath/earl:expression">
      <iso:assert test="not(contains(normalize-space(.), '/:'))">XPath expressions in <iso:name/> must not have an empty namespace prefix.</iso:assert>
    </iso:rule>
  </iso:pattern>

  <!--iso:diagnostics>
    <iso:diagnostic id="xyz">Actual xyz was <value-of select="/tcd:testCaseDescription/tcd:rules/tcd:rule/tcd:techniques/tcd:technique/@id" /></iso:diagnostic>
  </iso:diagnostics-->
</iso:schema>