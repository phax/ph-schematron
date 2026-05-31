/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.puresaxon;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.base.state.EValidity;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.svrl.jaxb.DiagnosticReference;
import com.helger.schematron.svrl.jaxb.SuccessfulReport;
import com.helger.schematron.svrl.jaxb.Text;

/**
 * Phase 1 smoke tests for {@link SchematronResourceSaxon}.
 *
 * @author Philip Helger
 */
public final class SchematronResourceSaxonTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceSaxonTest.class);

  private static int _countFailedAsserts (final SchematronOutputType aSVRL)
  {
    int n = 0;
    for (final Object aObj : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof FailedAssert)
        n++;
    return n;
  }

  private static int _countSuccessfulReports (final SchematronOutputType aSVRL)
  {
    int n = 0;
    for (final Object aObj : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof SuccessfulReport)
        n++;
    return n;
  }

  @NonNull
  private static String _firstFailedAssertText (final SchematronOutputType aSVRL)
  {
    for (final Object aObj : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof final FailedAssert aFA)
      {
        final StringBuilder aSB = new StringBuilder ();
        for (final Object aChild : aFA.getDiagnosticReferenceOrPropertyReferenceOrText ())
          if (aChild instanceof final Text aText)
            for (final Object aPart : aText.getContent ())
              aSB.append (aPart == null ? "" : aPart.toString ());
        return aSB.toString ();
      }
    throw new AssertionError ("No FailedAssert in SVRL");
  }

  @Test
  public void testInvalidXmlProducesFailedAssert () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/issues/github137/schematron.sch");
    final File aXML = new File ("src/test/resources/external/issues/github137/test.xml");
    final SchematronResourceSaxon aRes = SchematronResourceSaxon.fromFile (aSch);
    assertTrue ("Schematron should be readable", aRes.isValidSchematron ());

    final SchematronOutputType aSVRL = aRes.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    LOGGER.info ("SVRL (invalid):\n" + new SVRLMarshaller ().getAsString (aSVRL));
    assertEquals ("expected exactly one failed-assert for the invalid input", 1, _countFailedAsserts (aSVRL));
  }

  @Test
  public void testValidXmlProducesNoFailedAssert () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/issues/valid-simple/schematron.sch");
    final File aXML = new File ("src/test/resources/external/issues/valid-simple/test.xml");
    final SchematronResourceSaxon aRes = SchematronResourceSaxon.fromFile (aSch);
    assertTrue ("Schematron should be readable", aRes.isValidSchematron ());

    final SchematronOutputType aSVRL = aRes.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    LOGGER.info ("SVRL (valid):\n" + new SVRLMarshaller ().getAsString (aSVRL));
    assertEquals ("expected no failed-assert for the valid input", 0, _countFailedAsserts (aSVRL));
  }

  @Test
  public void testMultiPatternMultiRule () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/multi-pattern/schematron.sch");
    final File aValidXml = new File ("src/test/resources/external/multi-pattern/valid.xml");
    final File aInvalidXml = new File ("src/test/resources/external/multi-pattern/invalid.xml");

    // valid.xml: ISBN present, author has name, library has one book -> no failures
    final SchematronOutputType aValidSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aValidXml));
    assertEquals ("multi-pattern valid: expected no failed-assert", 0, _countFailedAsserts (aValidSVRL));

    // invalid.xml: ISBN missing AND empty author name -> at least 2 failures (could be more
    // depending on whether nested context matches fire under the catch-all)
    final SchematronOutputType aInvalidSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aInvalidXml));
    LOGGER.info ("SVRL (multi-pattern invalid):\n" + new SVRLMarshaller (false).getAsString (aInvalidSVRL));
    final int nFailures = _countFailedAsserts (aInvalidSVRL);
    assertTrue ("multi-pattern invalid: expected at least 2 failed-asserts, got " + nFailures, nFailures >= 2);
  }

  @Test
  public void testReportFiresOnTrueTest () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/report/schematron.sch");
    final File aFires = new File ("src/test/resources/external/report/fires.xml");
    final File aSilent = new File ("src/test/resources/external/report/silent.xml");

    final SchematronOutputType aFiresSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aFires));
    LOGGER.info ("SVRL (report fires):\n" + new SVRLMarshaller (false).getAsString (aFiresSVRL));
    assertEquals ("report should fire when @deprecated='true'", 1, _countSuccessfulReports (aFiresSVRL));
    assertEquals (0, _countFailedAsserts (aFiresSVRL));

    final SchematronOutputType aSilentSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aSilent));
    assertEquals ("report should NOT fire when @deprecated is missing", 0, _countSuccessfulReports (aSilentSVRL));
  }

  @Test
  public void testValueOfAndNameInterpolation () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/valueof/schematron.sch");
    final File aXML = new File ("src/test/resources/external/valueof/test.xml");
    final SchematronOutputType aSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    LOGGER.info ("SVRL (valueof):\n" + new SVRLMarshaller (false).getAsString (aSVRL));
    assertEquals (1, _countFailedAsserts (aSVRL));
    final String sMsg = _firstFailedAssertText (aSVRL);
    // <sch:name path="title"/> resolves to "title" (the element name, not its content) per sch spec
    assertTrue ("expected message to include the resolved <sch:name> element name 'title', got: " + sMsg,
                sMsg.contains ("title"));
    // <sch:value-of select="@isbn"/> on a book without @isbn produces an empty string, which is
    // exactly the failure context we want to verify is reported. Confirm by string shape.
    assertTrue ("expected message shape 'Book ... is missing an ISBN (got '')', got: " + sMsg,
                sMsg.contains ("is missing an ISBN") && sMsg.contains ("got ''"));
  }

  @Test
  public void testPhaseSelectionLenientVsStrict () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/phases/schematron.sch");
    final File aXML = new File ("src/test/resources/external/phases/test.xml");

    // Lenient phase: only p-isbn active -> 1 failure (missing ISBN)
    final SchematronOutputType aLenient = SchematronResourceSaxon.fromFile (aSch)
        .setPhase ("lenient")
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertEquals ("lenient phase should report only the ISBN failure", 1, _countFailedAsserts (aLenient));

    // Strict phase: both patterns active -> 2 failures
    final SchematronOutputType aStrict = SchematronResourceSaxon.fromFile (aSch)
        .setPhase ("strict")
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertEquals ("strict phase should report both failures", 2, _countFailedAsserts (aStrict));

    // #DEFAULT resolves to strict (declared on the schema)
    final SchematronOutputType aDefault = SchematronResourceSaxon.fromFile (aSch)
        .setPhase ("#DEFAULT")
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertEquals ("#DEFAULT should match declared defaultPhase='strict'", 2, _countFailedAsserts (aDefault));

    // #ALL processes every concrete pattern
    final SchematronOutputType aAll = SchematronResourceSaxon.fromFile (aSch)
        .setPhase ("#ALL")
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertEquals ("#ALL should process both patterns", 2, _countFailedAsserts (aAll));
  }

  @Test
  public void testLetsAtAllScopes () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/lets/schematron.sch");
    final File aXML = new File ("src/test/resources/external/lets/test.xml");
    final SchematronOutputType aSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    LOGGER.info ("SVRL (lets):\n" + new SVRLMarshaller (false).getAsString (aSVRL));
    // valid library: 1 book >= bookCountThreshold (1) -> no failure on library rule
    // invalid book: 1 author < minAuthors (2)         -> 1 failure on book rule
    assertEquals ("expected 1 failure (book rule using schema-level $minAuthors)", 1, _countFailedAsserts (aSVRL));
    final String sMsg = _firstFailedAssertText (aSVRL);
    // The interpolated message should embed the schema-level let value "2" and the rule-level
    // let value "1"; this proves both scope levels resolved.
    assertTrue ("expected message to include '2' (schema let) and '1' (rule let), got: " + sMsg,
                sMsg.contains ("2") && sMsg.contains ("1"));
  }

  @Test
  public void testDiagnosticReferences () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/diagnostics/schematron.sch");
    final File aXML = new File ("src/test/resources/external/diagnostics/test.xml");
    final SchematronOutputType aSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    LOGGER.info ("SVRL (diagnostics):\n" + new SVRLMarshaller (false).getAsString (aSVRL));
    assertEquals (1, _countFailedAsserts (aSVRL));

    boolean bFoundRef = false;
    String sRefText = "";
    for (final Object aObj : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof final FailedAssert aFA)
        for (final Object aChild : aFA.getDiagnosticReferenceOrPropertyReferenceOrText ())
          if (aChild instanceof final DiagnosticReference aRef)
          {
            bFoundRef = true;
            assertEquals ("d-isbn", aRef.getDiagnostic ());
            final StringBuilder aSB = new StringBuilder ();
            for (final Object aPart : aRef.getContent ())
              aSB.append (aPart == null ? "" : aPart.toString ());
            sRefText = aSB.toString ();
          }
    assertTrue ("expected svrl:diagnostic-reference with diagnostic='d-isbn'", bFoundRef);
    assertTrue ("expected diagnostic text to mention ISBN, got: " + sRefText, sRefText.contains ("ISBN"));
    assertTrue ("expected diagnostic value-of to resolve title 'Old Book', got: " + sRefText,
                sRefText.contains ("Old Book"));
  }

  @Test
  public void testAbstractPatternWithIsA () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/abstract-pattern/schematron.sch");
    final File aXML = new File ("src/test/resources/external/abstract-pattern/test.xml");
    final SchematronOutputType aSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    LOGGER.info ("SVRL (abstract):\n" + new SVRLMarshaller (false).getAsString (aSVRL));
    // Two concrete patterns derived from the abstract one. Book has no @isbn, author has no @name
    // -> 2 failures total.
    assertEquals ("expected 2 failed-asserts from the two expanded patterns", 2, _countFailedAsserts (aSVRL));
  }

  @Test
  public void testExtendsRule () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/extends-rule/schematron.sch");
    final File aXML = new File ("src/test/resources/external/extends-rule/test.xml");
    final SchematronOutputType aSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aXML));
    LOGGER.info ("SVRL (extends):\n" + new SVRLMarshaller (false).getAsString (aSVRL));
    // The book is missing both @id (inherited assert) and @isbn (own assert) -> 2 failures
    assertEquals ("expected the inherited assert AND the own assert to both fire", 2, _countFailedAsserts (aSVRL));
  }

  @Test
  public void testXsltFunctionPassThrough () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/xsl-function/schematron.sch");
    final File aValid = new File ("src/test/resources/external/xsl-function/valid.xml");
    final File aInvalid = new File ("src/test/resources/external/xsl-function/invalid.xml");

    // valid: single book with non-empty title -> my:isNonEmpty returns true -> no failure
    final SchematronOutputType aValidSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aValid));
    assertEquals ("expected no failures for non-empty title", 0, _countFailedAsserts (aValidSVRL));

    // invalid: one book with empty title, one with no @title -> 2 failures
    final SchematronOutputType aInvalidSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aInvalid));
    LOGGER.info ("SVRL (xsl-function):\n" + new SVRLMarshaller (false).getAsString (aInvalidSVRL));
    assertEquals ("expected my:isNonEmpty to fire failures for empty/missing @title", 2, _countFailedAsserts (aInvalidSVRL));
  }

  @Test
  public void testLetBodyXsltChoose () throws Exception
  {
    final File aSch = new File ("src/test/resources/external/let-body/schematron.sch");
    final File aLarge = new File ("src/test/resources/external/let-body/large.xml");
    final File aSmall = new File ("src/test/resources/external/let-body/small.xml");

    // 11 chapters -> $sizeBucket = "large" -> assert passes
    final SchematronOutputType aLargeSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aLarge));
    assertEquals ("large book should pass", 0, _countFailedAsserts (aLargeSVRL));

    // 1 chapter -> $sizeBucket = "small" -> assert fires
    final SchematronOutputType aSmallSVRL = SchematronResourceSaxon.fromFile (aSch)
        .applySchematronValidationToSVRL (new FileSystemResource (aSmall));
    LOGGER.info ("SVRL (let-body small):\n" + new SVRLMarshaller (false).getAsString (aSmallSVRL));
    assertEquals ("small book should fail", 1, _countFailedAsserts (aSmallSVRL));
    final String sMsg = _firstFailedAssertText (aSmallSVRL);
    assertTrue ("expected interpolated 'small' from $sizeBucket, got: " + sMsg, sMsg.contains ("small"));
  }

  @Test
  public void testGetSchematronValidity () throws Exception
  {
    final File aSchBad = new File ("src/test/resources/external/issues/github137/schematron.sch");
    final File aXMLBad = new File ("src/test/resources/external/issues/github137/test.xml");
    assertEquals (EValidity.INVALID,
                  SchematronResourceSaxon.fromFile (aSchBad).getSchematronValidity (new FileSystemResource (aXMLBad)));

    final File aSchGood = new File ("src/test/resources/external/issues/valid-simple/schematron.sch");
    final File aXMLGood = new File ("src/test/resources/external/issues/valid-simple/test.xml");
    assertEquals (EValidity.VALID,
                  SchematronResourceSaxon.fromFile (aSchGood).getSchematronValidity (new FileSystemResource (aXMLGood)));
  }
}
