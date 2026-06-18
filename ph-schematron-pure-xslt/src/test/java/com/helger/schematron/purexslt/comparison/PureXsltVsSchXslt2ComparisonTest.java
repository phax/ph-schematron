/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
 * philip[at]helger[dot]com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.helger.schematron.purexslt.comparison;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.purexslt.SchematronResourcePureXslt;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Side-by-side comparison between the pure-xslt and SchXslt2 engines on the same input. The point
 * is to surface gaps in the pure-xslt SVRL output rather than enforce exact byte equality (SchXslt2
 * emits additional metadata such as <code>active-pattern documents=""</code>, namespace
 * declarations, and SchXslt-specific extensions).
 *
 * @author Philip Helger
 */
public final class PureXsltVsSchXslt2ComparisonTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PureXsltVsSchXslt2ComparisonTest.class);

  private static final XMLWriterSettings PRETTY = new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN);

  private static void _runAndDump (@NonNull final String sLabel,
                                   @NonNull final String sSchematron,
                                   @NonNull final String sXML) throws Exception
  {
    _runAndDump (sLabel, ReadableResourceString.utf8 (sSchematron), ReadableResourceString.utf8 (sXML), true);
  }

  private static void _runAndDumpCountsOnly (@NonNull final String sLabel,
                                             @NonNull final String sSchematron,
                                             @NonNull final String sXML) throws Exception
  {
    _runAndDump (sLabel, ReadableResourceString.utf8 (sSchematron), ReadableResourceString.utf8 (sXML), false);
  }

  private static void _runAndDumpCountsOnly (@NonNull final String sLabel,
                                             @NonNull final IReadableResource aSchRes,
                                             @NonNull final IReadableResource aXMLRes) throws Exception
  {
    _runAndDump (sLabel, aSchRes, aXMLRes, false);
  }

  private static void _runAndDump (@NonNull final String sLabel,
                                   @NonNull final IReadableResource aSchRes,
                                   @NonNull final IReadableResource aXMLRes,
                                   final boolean bAssertStructuralEquality) throws Exception
  {
    LOGGER.info ("\n========================= " + sLabel + " =========================");

    // SchXslt2 emits the non-standard <code>patternId</code> attribute on
    // <code>failed-assert</code>
    // when the source pattern has an id; disable strict SVRL schema validation so the result still
    // unmarshals.
    final SchematronResourceSchXslt2 aSchXslt2 = SchematronResourceSchXslt2.builder (aSchRes)
                                                                           .useCache (false)
                                                                           .validateSVRL (false)
                                                                           .build ();
    final SchematronOutputType aSchXslt2SVRL = aSchXslt2.applySchematronValidationToSVRL (aXMLRes);
    assertNotNull ("SchXslt2 produced no SVRL", aSchXslt2SVRL);

    // Use a separate Resource for pure-xslt - it caches m_aSchema and would race
    final SchematronResourcePureXslt aPure = SchematronResourcePureXslt.builder (aSchRes).useCache (false).build ();
    final SchematronOutputType aPureSVRL = aPure.applySchematronValidationToSVRL (aXMLRes);
    assertNotNull ("PureXslt produced no SVRL", aPureSVRL);

    final Document aSchXslt2Doc = new SVRLMarshaller ().setUseSchema (false).getAsDocument (aSchXslt2SVRL);
    final Document aPureDoc = new SVRLMarshaller ().setUseSchema (false).getAsDocument (aPureSVRL);

    final String sSchXslt2 = XMLWriter.getNodeAsString (aSchXslt2Doc, PRETTY);
    LOGGER.info ("--- SchXslt2 SVRL ---\n" + sSchXslt2);
    final String sPure = XMLWriter.getNodeAsString (aPureDoc, PRETTY);
    LOGGER.info ("--- PureXslt SVRL ---\n" + sPure);
    if (bAssertStructuralEquality)
      assertEquals (sSchXslt2.replaceAll (" document=\"[^\"]+\"", ""), sPure);

    final int nSchXslt2Failed = SVRLHelper.getAllFailedAssertions (aSchXslt2SVRL).size ();
    final int nPureFailed = SVRLHelper.getAllFailedAssertions (aPureSVRL).size ();
    final int nSchXslt2Reports = SVRLHelper.getAllSuccessfulReports (aSchXslt2SVRL).size ();
    final int nPureReports = SVRLHelper.getAllSuccessfulReports (aPureSVRL).size ();
    LOGGER.info ("Failed-assert counts: SchXslt2=" + nSchXslt2Failed + " | PureXslt=" + nPureFailed);
    LOGGER.info ("Successful-report counts: SchXslt2=" + nSchXslt2Reports + " | PureXslt=" + nPureReports);
    // Behavioral assertions always hold regardless of layout / metadata differences.
    assertEquals ("failed-assert counts diverge", nSchXslt2Failed, nPureFailed);
    assertEquals ("successful-report counts diverge", nSchXslt2Reports, nPureReports);
  }

  @Test
  public void testRichTextSpans () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern>\n" +
                               "    <sch:rule context='AAA'>\n" +
                               "      <sch:assert test='BBB'><sch:name/> element is <sch:dir value='ltr'>missing</sch:dir>.</sch:assert>\n" +
                               "      <sch:report test='BBB'><sch:name/> element is <sch:emph>present</sch:emph>.</sch:report>\n" +
                               "      <sch:assert test='@name'><sch:name/> misses attribute <sch:span class='hl'>name</sch:span>.</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    final String sXML = "<AAA><BBB/></AAA>";
    _runAndDump ("Rich text spans (emph/dir/span)", sSchematron, sXML);
  }

  @Test
  public void testRoleSeeIconFpi () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern>\n" +
                               "    <sch:rule context='chapter' role='structural' see='https://example.com/rule' icon='rule.png' fpi='rule-fpi'>\n" +
                               "      <sch:assert test='title' role='ERROR' see='https://example.com/asserts/title' icon='title.png' fpi='title-fpi' flag='strict' id='a1'>\n" +
                               "        Chapter should have a title.\n" +
                               "      </sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    final String sXML = "<chapter/>";
    _runAndDump ("role / see / icon / fpi attributes", sSchematron, sXML);
  }

  @Test
  public void testDiagnosticReferences () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern>\n" +
                               "    <sch:rule context='chapter'>\n" +
                               "      <sch:assert test='title' diagnostics='d1 d2'>Chapter should have a title</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "  <sch:diagnostics>\n" +
                               "    <sch:diagnostic id='d1'>Diagnostic 1 with <sch:emph>emphasis</sch:emph> and <sch:value-of select='@id'/></sch:diagnostic>\n" +
                               "    <sch:diagnostic id='d2'>Diagnostic 2</sch:diagnostic>\n" +
                               "  </sch:diagnostics>\n" +
                               "</sch:schema>";
    final String sXML = "<chapter id='c1'/>";
    _runAndDump ("Diagnostic references with rich content", sSchematron, sXML);
  }

  @Test
  public void testPropertyReferences () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern>\n" +
                               "    <sch:rule context='chapter'>\n" +
                               "      <sch:assert test='title' properties='p1 p2'>Chapter should have a title</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "  <sch:properties>\n" +
                               "    <sch:property id='p1' role='aux' scheme='myscheme'>Property 1 value: <sch:value-of select='@id'/></sch:property>\n" +
                               "    <sch:property id='p2'>Property 2</sch:property>\n" +
                               "  </sch:properties>\n" +
                               "</sch:schema>";
    final String sXML = "<chapter id='c1'/>";
    _runAndDump ("Property references", sSchematron, sXML);
  }

  @Test
  public void testLetVariablesAndPhase () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:phase id='lenient'>\n" +
                               "    <sch:active pattern='p1'/>\n" +
                               "  </sch:phase>\n" +
                               "  <sch:let name='globalLimit' value='3'/>\n" +
                               "  <sch:pattern id='p1'>\n" +
                               "    <sch:let name='patternLimit' value='2'/>\n" +
                               "    <sch:rule context='item'>\n" +
                               "      <sch:let name='localValue' value='@count'/>\n" +
                               "      <sch:assert test='$localValue &lt;= $patternLimit'>Item count <sch:value-of select='$localValue'/> exceeds pattern limit <sch:value-of select='$patternLimit'/></sch:assert>\n" +
                               "      <sch:assert test='$localValue &lt;= $globalLimit'>Item count exceeds global limit</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    final String sXML = "<root><item count='5'/></root>";
    _runAndDump ("Let variables at schema/pattern/rule scope", sSchematron, sXML);
  }

  @Test
  public void testEqualNumberOfFailuresAcrossEngines () throws Exception
  {
    // A strict equivalence check: both engines should agree on how many failed-asserts and
    // successful-reports fire on the same input, regardless of metadata differences.
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern>\n" +
                               "    <sch:rule context='book'>\n" +
                               "      <sch:assert test='@isbn'>Book must have an ISBN</sch:assert>\n" +
                               "      <sch:assert test='title'>Book must have a title</sch:assert>\n" +
                               "      <sch:report test='@deprecated'>Book is deprecated</sch:report>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    final String sXML = "<library><book deprecated='true'><title>X</title></book><book><title>Y</title></book></library>";

    final ReadableResourceByteArray aSchRes = new ReadableResourceByteArray (sSchematron.getBytes (StandardCharsets.UTF_8));
    final ReadableResourceByteArray aXMLRes = new ReadableResourceByteArray (sXML.getBytes (StandardCharsets.UTF_8));

    final SchematronOutputType aSchXslt2SVRL = SchematronResourceSchXslt2.builder (aSchRes)
                                                                         .useCache (false)
                                                                         .build ()
                                                                         .applySchematronValidationToSVRL (aXMLRes);
    final SchematronOutputType aPureSVRL = SchematronResourcePureXslt.builder (aSchRes)
                                                                     .useCache (false)
                                                                     .build ()
                                                                     .applySchematronValidationToSVRL (aXMLRes);

    assertEquals ("failed-assert counts differ",
                  SVRLHelper.getAllFailedAssertions (aSchXslt2SVRL).size (),
                  SVRLHelper.getAllFailedAssertions (aPureSVRL).size ());
    assertEquals ("successful-report counts differ",
                  SVRLHelper.getAllSuccessfulReports (aSchXslt2SVRL).size (),
                  SVRLHelper.getAllSuccessfulReports (aPureSVRL).size ());
  }

  // ===== Schematron 2020 / common-feature tests =====

  /*
   * Abstract pattern with parameter substitution via {@code <sch:param>} (ISO/IEC 19757-3 5.4.6 /
   * 5.4.10). The preprocessor expands the {@code is-a} reference and substitutes the parameter
   * names. Both engines should produce structurally identical SVRL.
   */
  @Test
  public void testAbstractPatternWithParam () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern abstract='true' id='table'>\n" +
                               "    <sch:rule context='$table'>\n" +
                               "      <sch:assert test='$row'>The element <sch:name/> is a table; tables contain rows.</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "    <sch:rule context='$row'>\n" +
                               "      <sch:assert test='$entry'>The element <sch:name/> is a row; rows contain entries.</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "  <sch:pattern is-a='table' id='html-table'>\n" +
                               "    <sch:param name='table' value='table'/>\n" +
                               "    <sch:param name='row' value='tr'/>\n" +
                               "    <sch:param name='entry' value='td'/>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    // An html-style table whose row has no entries and whose root is malformed
    // (table contains a stray <div/> instead of <tr/>).
    final String sXML = "<doc><table><div/></table><table><tr/></table></doc>";
    _runAndDump ("Abstract pattern + is-a + param substitution", sSchematron, sXML);
  }

  /*
   * Abstract rule referenced via {@code <sch:extends rule="..."/>} (ISO/IEC 19757-3 5.4.4 /
   * 5.4.13). Each concrete rule pulls in the abstract rule's assertions as if inlined. Both engines
   * must materialize that expansion identically.
   */
  @Test
  public void testAbstractRuleWithExtends () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern>\n" +
                               "    <sch:rule abstract='true' id='must-have-id'>\n" +
                               "      <sch:assert test='@id'>Element <sch:name/> must have an @id</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "    <sch:rule context='chapter'>\n" +
                               "      <sch:extends rule='must-have-id'/>\n" +
                               "      <sch:assert test='title'>Chapter must have a title</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "    <sch:rule context='section'>\n" +
                               "      <sch:extends rule='must-have-id'/>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    // chapter[1] is missing both @id and title (2 failures);
    // chapter[2] has @id and title (0 failures);
    // section[1] is missing @id (1 failure).
    final String sXML = "<doc><chapter/><chapter id='c2'><title>OK</title></chapter><section/></doc>";
    _runAndDump ("Abstract rule + <sch:extends>", sSchematron, sXML);
  }

  /*
   * {@code <sch:include>} pulling in an external abstract pattern, combined with {@code is-a} +
   * {@code <sch:param>}. Uses the canonical Schematron specification example
   * <code>pattern-example-with-includes.sch</code> bundled in {@code ph-schematron-testfiles}.
   * Verifies that both engines resolve the include + expand the abstract pattern identically.
   */
  @Test
  public void testIncludeWithAbstractPattern () throws Exception
  {
    final IReadableResource aSchRes = new ClassPathResource ("external/test-sch/pattern-example-with-includes.sch",
                                                             SchematronTestHelper.getCL ());
    // Document with one HTML table where a row has no entry (-> 1 failure on the row rule),
    // and a CALS table whose row is empty too.
    final String sXML = "<doc>" +
                        "<table><tr/></table>" +
                        "<table><row/></table>" +
                        "<calendar><year><week/></year></calendar>" +
                        "</doc>";
    // SchXslt2 lists every active-pattern up front and then all fired-rules; pure-xslt interleaves
    // active-pattern with its own fired-rules (the 2016 model). Both are spec-legal for different
    // editions of D.2 / D.3, so we only assert the counts here.
    _runAndDumpCountsOnly ("Include + abstract pattern (spec example)", aSchRes, ReadableResourceString.utf8 (sXML));
  }

  /*
   * Default-phase resolution: schema declares {@code defaultPhase="strict"}, the validator is
   * called with no phase override; both engines should restrict pattern activation to the strict
   * phase (covered count-wise — exact layout differs because SchXslt2 batches all active-patterns
   * at the front of the output, while pure-xslt interleaves them per the 2016 D.2 content model).
   */
  @Test
  public void testDefaultPhaseResolution () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'\n" +
                               "            defaultPhase='strict'>\n" +
                               "  <sch:phase id='lenient'>\n" +
                               "    <sch:active pattern='p-isbn'/>\n" +
                               "  </sch:phase>\n" +
                               "  <sch:phase id='strict'>\n" +
                               "    <sch:active pattern='p-isbn'/>\n" +
                               "    <sch:active pattern='p-title'/>\n" +
                               "  </sch:phase>\n" +
                               "  <sch:pattern id='p-isbn'>\n" +
                               "    <sch:rule context='book'>\n" +
                               "      <sch:assert test='@isbn'>Book must have an ISBN</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "  <sch:pattern id='p-title'>\n" +
                               "    <sch:rule context='book'>\n" +
                               "      <sch:assert test='title'>Book must have a title</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    final String sXML = "<library><book/></library>";
    _runAndDumpCountsOnly ("Default-phase = strict (both patterns active)", sSchematron, sXML);
  }

  /*
   * Multiple rules in one pattern with priority and a catch-all (last matching rule wins per the
   * XSLT model). Pure-xslt emits a per-pattern mode and one template per rule with descending
   * priority; SchXslt2's transpile produces the same dispatch but additionally emits its {@code
   * <svrl:suppressed-rule>} extension for rules that did not fire at a given context. Behavioral
   * assertion is on the failed-assert / successful-report counts.
   */
  @Test
  public void testMultipleRuleContexts () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern>\n" +
                               "    <sch:rule context='book[@type=&quot;ebook&quot;]'>\n" +
                               "      <sch:assert test='@url'>Ebooks must have a @url</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "    <sch:rule context='book'>\n" +
                               "      <sch:assert test='@isbn'>Books must have an @isbn</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    // 1st book is an ebook with no @url -> fires the ebook rule (1 fail).
    // 2nd book is plain, no @isbn -> fires the generic book rule (1 fail).
    final String sXML = "<library><book type='ebook'/><book/></library>";
    _runAndDumpCountsOnly ("Multiple rule contexts with priority dispatch", sSchematron, sXML);
  }

  /*
   * {@code xml:lang} and {@code xml:space} attributes on assert / report mixed-content text. Per
   * ISO/IEC 19757-3 Annex D ({@code human-text}), these attributes belong on {@code <svrl:text>}
   * (where both engines emit them). SchXslt2 additionally duplicates {@code xml:lang} onto the
   * {@code <svrl:failed-assert>} parent (a non-spec extension allowed by ph-schematron's local
   * svrl.xsd), so we only compare counts.
   */
  @Test
  public void testXmlLangOnAssertText () throws Exception
  {
    final String sSchematron = "<?xml version='1.0'?>\n" +
                               "<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>\n" +
                               "  <sch:pattern>\n" +
                               "    <sch:rule context='chapter'>\n" +
                               "      <sch:assert test='title' xml:lang='en' xml:space='preserve'>Chapter requires a title.</sch:assert>\n" +
                               "    </sch:rule>\n" +
                               "  </sch:pattern>\n" +
                               "</sch:schema>";
    final String sXML = "<chapter/>";
    _runAndDumpCountsOnly ("xml:lang / xml:space on assert text", sSchematron, sXML);
  }
}
