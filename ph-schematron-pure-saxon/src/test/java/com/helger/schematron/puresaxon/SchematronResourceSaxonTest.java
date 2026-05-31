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

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.base.state.EValidity;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

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
