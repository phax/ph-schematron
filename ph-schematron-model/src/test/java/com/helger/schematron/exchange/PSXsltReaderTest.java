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
package com.helger.schematron.exchange;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;

import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.model.PSAssertReport;
import com.helger.schematron.model.PSLet;
import com.helger.schematron.model.PSName;
import com.helger.schematron.model.PSPattern;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSValueOf;

/**
 * Test class for class {@link PSXsltReader}.
 *
 * @author Philip Helger
 */
public final class PSXsltReaderTest
{
  @Test
  public void testSimple () throws SchematronReadException
  {
    final PSSchema aSchema = new PSXsltReader (new ClassPathResource ("external/test-xslt/valid01.xslt")).readSchema ();
    assertNotNull (aSchema);
    assertEquals ("xslt2", aSchema.getQueryBinding ());
    assertEquals (3, aSchema.getPatternCount ());

    final PSPattern aPattern = aSchema.getAllPatterns ().getFirstOrNull ();
    assertEquals (1, aPattern.getRuleCount ());
    final PSRule aRule = aPattern.getAllRules ().getFirstOrNull ();
    assertEquals ("AAA", aRule.getContext ());
    assertEquals (4, aRule.getAllAssertReports ().size ());

    final PSAssertReport aAssert = aRule.getAllAssertReports ().get (0);
    assertTrue (aAssert.isAssert ());
    assertEquals ("BBB", aAssert.getTest ());
    assertEquals (2, aAssert.getAllContentElements ().size ());
    assertTrue (aAssert.getAllContentElements ().get (0) instanceof PSName);

    final PSAssertReport aReport = aRule.getAllAssertReports ().get (1);
    assertTrue (aReport.isReport ());
    assertEquals ("BBB", aReport.getTest ());

    assertTrue (aSchema.isValid (new CollectingPSErrorHandler ()));
  }

  @Test
  public void testFeatures () throws SchematronReadException
  {
    final PSSchema aSchema = new PSXsltReader (new ClassPathResource ("external/test-xslt/reverse-features.xslt")).readSchema ();
    assertNotNull (aSchema);
    assertEquals ("xslt2", aSchema.getQueryBinding ());
    assertEquals ("1.0", aSchema.getSchemaVersion ());
    assertEquals ("Probe schema", aSchema.getTitle ().getAllTexts ().getFirstOrNull ());
    assertEquals (2, aSchema.getAllNSs ().size ());
    assertEquals ("u", aSchema.getAllNSs ().get (0).getPrefix ());
    assertEquals ("urn:test:u", aSchema.getAllNSs ().get (0).getUri ());

    // Global let
    assertEquals (1, aSchema.getAllLets ().size ());
    final PSLet aGlobalLet = aSchema.getAllLets ().getFirstOrNull ();
    assertEquals ("gl", aGlobalLet.getName ());
    assertEquals ("'global'", aGlobalLet.getValue ());

    // Patterns
    assertEquals (2, aSchema.getPatternCount ());
    final PSPattern aPattern1 = aSchema.getAllPatterns ().get (0);
    assertEquals ("pat1", aPattern1.getID ());
    assertEquals ("First pattern", aPattern1.getTitle ().getAllTexts ().getFirstOrNull ());
    assertEquals (1, aPattern1.getAllLets ().size ());
    assertEquals ("pl", aPattern1.getAllLets ().getFirstOrNull ().getName ());
    assertNull (aSchema.getAllPatterns ().get (1).getID ());

    // Rule
    final PSRule aRule = aPattern1.getAllRules ().getFirstOrNull ();
    assertEquals ("/root/item", aRule.getContext ());
    assertEquals ("R1", aRule.getID ());
    assertEquals (1, aRule.getAllLets ().size ());
    assertEquals ("rl", aRule.getAllLets ().getFirstOrNull ().getName ());
    assertEquals ("@a", aRule.getAllLets ().getFirstOrNull ().getValue ());

    // Assert - the test must be the original one
    final PSAssertReport aAssert = aRule.getAllAssertReports ().get (0);
    assertTrue (aAssert.isAssert ());
    assertEquals ("A-1", aAssert.getID ());
    assertEquals ("fatal", aAssert.getFlag ());
    assertEquals ("error", aAssert.getLinkable ().getRole ());
    assertEquals ("@a = $rl and $pl = 1", aAssert.getTest ());
    assertEquals ("d1", aAssert.getAllDiagnostics ().getFirstOrNull ());
    assertEquals ("Item ", aAssert.getAllContentElements ().get (0));
    assertTrue (aAssert.getAllContentElements ().get (1) instanceof PSName);
    assertFalse (((PSName) aAssert.getAllContentElements ().get (1)).hasPath ());
    assertEquals (" / ", aAssert.getAllContentElements ().get (2));
    assertEquals ("@a", ((PSValueOf) aAssert.getAllContentElements ().get (3)).getSelect ());

    // Report
    final PSAssertReport aReport = aRule.getAllAssertReports ().get (1);
    assertTrue (aReport.isReport ());
    assertEquals ("R-1", aReport.getID ());
    assertEquals ("pr1", aReport.getAllProperties ().getFirstOrNull ());
    assertEquals ("@b", ((PSName) aReport.getAllContentElements ().get (1)).getPath ());

    // Diagnostics and properties
    assertEquals (1, aSchema.getDiagnostics ().getAllDiagnostics ().size ());
    assertEquals ("d1", aSchema.getDiagnostics ().getAllDiagnostics ().getFirstOrNull ().getID ());
    assertEquals (1, aSchema.getProperties ().getAllProperties ().size ());
    assertEquals ("pr1", aSchema.getProperties ().getAllProperties ().getFirstOrNull ().getID ());

    // Must be writable and re-readable
    final String sSCH = new PSWriter ().getXMLStringNotNull (aSchema);
    assertTrue (sSCH.contains ("test=\"@a = $rl and $pl = 1\""));
  }

  private static void _checkSchXslt (final String sPath) throws SchematronReadException
  {
    final PSSchema aSchema = new PSXsltReader (new ClassPathResource (sPath)).readSchema ();
    assertEquals ("xslt2", aSchema.getQueryBinding ());
    assertEquals ("Probe schema", aSchema.getTitle ().getAllTexts ().getFirstOrNull ());
    assertEquals (2, aSchema.getAllNSs ().size ());

    // Pattern lets are global variables and end up as schema lets
    assertEquals (2, aSchema.getAllLets ().size ());
    assertEquals ("gl", aSchema.getAllLets ().get (0).getName ());
    assertEquals ("pl", aSchema.getAllLets ().get (1).getName ());

    assertEquals (2, aSchema.getPatternCount ());
    final PSPattern aPattern1 = aSchema.getAllPatterns ().get (0);
    assertEquals ("pat1", aPattern1.getID ());
    assertEquals ("First pattern", aPattern1.getTitle ().getAllTexts ().getFirstOrNull ());
    assertEquals (1, aPattern1.getRuleCount ());
    assertNull (aSchema.getAllPatterns ().get (1).getID ());
    assertEquals (1, aSchema.getAllPatterns ().get (1).getRuleCount ());
    assertEquals ("/root", aSchema.getAllPatterns ().get (1).getAllRules ().getFirstOrNull ().getContext ());

    final PSRule aRule = aPattern1.getAllRules ().getFirstOrNull ();
    assertEquals ("/root/item", aRule.getContext ());
    assertEquals ("R1", aRule.getID ());
    assertEquals ("rf", aRule.getFlag ());
    assertEquals (1, aRule.getAllLets ().size ());
    assertEquals ("rl", aRule.getAllLets ().getFirstOrNull ().getName ());

    // The test must be the original one and not the negated one
    assertEquals (2, aRule.getAllAssertReports ().size ());
    final PSAssertReport aAssert = aRule.getAllAssertReports ().get (0);
    assertTrue (aAssert.isAssert ());
    assertEquals ("A-1", aAssert.getID ());
    assertEquals ("fatal", aAssert.getFlag ());
    assertEquals ("error", aAssert.getLinkable ().getRole ());
    assertEquals ("http://x", aAssert.getRich ().getSee ());
    assertEquals ("@a = $rl and $pl = 1", aAssert.getTest ());
    assertEquals ("d1", aAssert.getAllDiagnostics ().getFirstOrNull ());
    assertEquals ("Item ", aAssert.getAllContentElements ().get (0));
    assertTrue (aAssert.getAllContentElements ().get (1) instanceof PSName);

    final PSAssertReport aReport = aRule.getAllAssertReports ().get (1);
    assertTrue (aReport.isReport ());
    assertEquals ("@b", aReport.getTest ());
    assertEquals ("pr1", aReport.getAllProperties ().getFirstOrNull ());

    assertEquals ("d1", aSchema.getDiagnostics ().getAllDiagnostics ().getFirstOrNull ().getID ());
    assertEquals ("pr1", aSchema.getProperties ().getAllProperties ().getFirstOrNull ().getID ());
  }

  @Test
  public void testSchXslt1 () throws SchematronReadException
  {
    _checkSchXslt ("external/test-xslt/reverse-features-schxslt1.xslt");
  }

  @Test
  public void testSchXslt2 () throws SchematronReadException
  {
    _checkSchXslt ("external/test-xslt/reverse-features-schxslt2.xslt");
  }

  @Test
  public void testNoIsoSchematronXSLT ()
  {
    try
    {
      // Old Schematron 1.5 XSLT
      new PSXsltReader (new ClassPathResource ("external/test-sch/xfront/example06/Validator.xsl")).readSchema ();
      fail ();
    }
    catch (final SchematronReadException ex)
    {
      // expected
    }
  }
}
