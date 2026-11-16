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
package com.helger.schematron.enginefactory;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.util.Locale;

import javax.xml.catalog.CatalogResolver;

import org.jspecify.annotations.NonNull;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.diagnostics.error.list.ErrorList;
import com.helger.diagnostics.log.ErrorListLogHandler;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.saxon.SaxonXsltProcessor;
import com.helger.schematron.svrl.ISVRLErrorLevelDeterminator;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;

/**
 * Test class for class {@link SchematronValidationRunner}.
 *
 * @author Philip Helger
 */
public final class SchematronValidationRunnerTest
{
  private static final File SCH = new File ("src/test/resources/external/levels/levels.sch");
  private static final File XML_VALID = new File ("src/test/resources/external/levels/valid.xml");
  private static final File XML_ERROR = new File ("src/test/resources/external/levels/error.xml");
  private static final File XML_WARNING_INFO = new File ("src/test/resources/external/levels/warning-info.xml");

  @Rule
  public final TemporaryFolder m_aTempFolder = new TemporaryFolder ();

  @NonNull
  private static ISchematronResource _createSchematron ()
  {
    final SchematronEngineResource aRes = SchematronEngineFactory.createResource (SCH,
                                                                                  new SchematronEngineSettings ().setEngine (ESchematronEngine.ISO_SCHEMATRON)
                                                                                                                 .setXsltProcessor (SchematronEngineFactory.getXsltProcessor (ESchematronEngine.ISO_SCHEMATRON,
                                                                                                                                                                              SaxonXsltProcessor.ID)));
    assertFalse (aRes.hasAnyError ());
    return aRes.resource ();
  }

  private static void _assertLogged (@NonNull final ErrorListLogHandler aLogger,
                                     @NonNull final EErrorLevel eLevel,
                                     @NonNull final String sText)
  {
    assertTrue (aLogger.getErrorList ()
                       .containsAny (x -> x.getErrorLevel ().isEQ (eLevel) &&
                                          x.getErrorText (Locale.US).contains (sText)));
  }

  @Test
  public void testExpectations ()
  {
    final ErrorListLogHandler aLogger = new ErrorListLogHandler (new ErrorList ());
    final SchematronValidationRunner aRunner = new SchematronValidationRunner (_createSchematron (), aLogger);

    SchematronFileValidationResult aResult = aRunner.validateFile (XML_VALID, null, true);
    assertTrue (aResult.isSuccess ());
    assertEquals (0, aResult.errorCount ());
    assertEquals (0, aResult.warningCount ());
    assertEquals (0, aResult.infoCount ());

    aResult = aRunner.validateFile (XML_VALID, null, false);
    assertFalse (aResult.isSuccess ());
    assertTrue (aResult.failureMessage ().startsWith ("No Schematron errors for erroneous XML file"));

    aResult = aRunner.validateFile (XML_ERROR, null, true);
    assertFalse (aResult.isSuccess ());
    assertEquals (1, aResult.errorCount ());
    assertNull (aResult.exception ());

    aResult = aRunner.validateFile (XML_ERROR, null, false);
    assertTrue (aResult.isSuccess ());

    // Warnings and information don't decide
    aResult = aRunner.validateFile (XML_WARNING_INFO, null, true);
    assertTrue (aResult.isSuccess ());
    assertEquals (0, aResult.errorCount ());
    assertEquals (1, aResult.warningCount ());
    assertEquals (1, aResult.infoCount ());

    aResult = aRunner.validateFile (XML_WARNING_INFO, null, false);
    assertFalse (aResult.isSuccess ());

    // Each message is logged with its level
    _assertLogged (aLogger, EErrorLevel.WARN, "The order has no date.");
    _assertLogged (aLogger, EErrorLevel.INFO, "The order has no note.");
    _assertLogged (aLogger, EErrorLevel.ERROR, "The order has no ID.");
  }

  @Test
  public void testFailOnLevels ()
  {
    final ISchematronResource aSch = _createSchematron ();

    SchematronValidationRunner aRunner = new SchematronValidationRunner (aSch, new ErrorListLogHandler (new ErrorList ())).setFailOnValidationWarn (true);
    assertFalse (aRunner.validateFile (XML_WARNING_INFO, null, true).isSuccess ());
    assertTrue (aRunner.validateFile (XML_VALID, null, true).isSuccess ());

    aRunner = new SchematronValidationRunner (aSch, new ErrorListLogHandler (new ErrorList ())).setFailOnValidationInfo (true);
    assertFalse (aRunner.validateFile (XML_WARNING_INFO, null, true).isSuccess ());

    // Also fails if the error is expected
    aRunner = new SchematronValidationRunner (aSch, new ErrorListLogHandler (new ErrorList ())).setFailOnValidationError (true);
    final SchematronFileValidationResult aResult = aRunner.validateFile (XML_ERROR, null, false);
    assertFalse (aResult.isSuccess ());
    assertTrue (aResult.failureMessage ().startsWith ("Validation errors are present"));

    // Ignored warnings don't count
    aRunner = new SchematronValidationRunner (aSch, new ErrorListLogHandler (new ErrorList ())).setIgnoreWarnings (true)
                                                                               .setFailOnValidationWarn (true)
                                                                               .setFailOnValidationInfo (true);
    final SchematronFileValidationResult aIgnored = aRunner.validateFile (XML_WARNING_INFO, null, true);
    assertTrue (aIgnored.isSuccess ());
    assertEquals (0, aIgnored.warningCount ());
    assertEquals (0, aIgnored.infoCount ());
  }

  @Test
  public void testErrorRoles ()
  {
    final ISVRLErrorLevelDeterminator aGlobal = SVRLHelper.getErrorLevelDeterminator ();
    final SchematronValidationRunner aRunner = new SchematronValidationRunner (_createSchematron (),
                                                                               new ErrorListLogHandler (new ErrorList ())).setErrorRoles (new CommonsArrayList <> ("WARNING"));
    final SchematronFileValidationResult aResult = aRunner.validateFile (XML_WARNING_INFO, null, true);
    assertFalse (aResult.isSuccess ());
    assertEquals (1, aResult.errorCount ());
    assertEquals (0, aResult.warningCount ());
    assertEquals (1, aResult.infoCount ());

    // The global determinator is untouched
    assertSame (aGlobal, SVRLHelper.getErrorLevelDeterminator ());
  }

  @Test
  public void testSVRLFile ()
  {
    final File aSVRLDir = m_aTempFolder.getRoot ();
    final File aSVRLFile = SchematronValidationRunner.getSVRLFile (aSVRLDir, "sub/error.xml");
    assertEquals (new File (aSVRLDir, "sub/error.xml.svrl"), aSVRLFile);
    assertNull (SchematronValidationRunner.getSVRLFile (null, "error.xml"));

    final SchematronValidationRunner aRunner = new SchematronValidationRunner (_createSchematron (),
                                                                               new ErrorListLogHandler (new ErrorList ()));
    assertFalse (aRunner.validateFile (XML_ERROR, aSVRLFile, true).isSuccess ());
    assertTrue (aSVRLFile.isFile ());
    assertNotNull (new SVRLMarshaller ().read (aSVRLFile));
  }

  @Test
  public void testException ()
  {
    final SchematronValidationRunner aRunner = new SchematronValidationRunner (_createSchematron (),
                                                                               new ErrorListLogHandler (new ErrorList ()));
    final SchematronFileValidationResult aResult = aRunner.validateFile (new File ("does-not-exist.xml"), null, true);
    assertFalse (aResult.isSuccess ());
    assertTrue (aResult.failureMessage ().contains ("does-not-exist.xml"));
  }

  @Test
  public void testEntityResolverFromCatalog ()
  {
    final File aSch = new File ("src/test/resources/external/catalog/doc.sch");
    final CatalogResolver aResolver = SchematronCatalogHelper.createCatalogResolver (new CommonsArrayList <> (new File ("src/test/resources/external/catalog/catalog.xml")));

    for (final ESchematronEngine eEngine : ESchematronEngine.values ())
      if (eEngine != ESchematronEngine.XSLT_PREBUILT)
      {
        final SchematronEngineResource aRes = SchematronEngineFactory.createResource (aSch,
                                                                                      new SchematronEngineSettings ().setEngine (eEngine)
                                                                                                                     .setXsltProcessor (SchematronEngineFactory.getXsltProcessor (eEngine,
                                                                                                                                                                                  SaxonXsltProcessor.ID))
                                                                                                                     .setURIResolver (aResolver)
                                                                                                                     .setEntityResolver (aResolver));
        assertFalse (aRes.hasAnyError ());
        final SchematronValidationRunner aRunner = new SchematronValidationRunner (aRes.resource (),
                                                                                   new ErrorListLogHandler (new ErrorList ())).setEntityResolver (aResolver);

        // The DTD comes from the catalog and its entity is expanded
        SchematronFileValidationResult aResult = aRunner.validateFile (new File ("src/test/resources/external/catalog/doc.xml"),
                                                                       null,
                                                                       true);
        assertTrue (eEngine.getID () + ": " + aResult.failureMessage (), aResult.isSuccess ());

        // A DTD that is not in the catalog is not loaded from its system ID
        aResult = aRunner.validateFile (new File ("src/test/resources/external/catalog/doc-unknown-dtd.xml"), null, true);
        assertFalse (aResult.isSuccess ());
        assertNotNull (aResult.exception ());
        assertTrue (aResult.failureMessage (), aResult.failureMessage ().contains ("is not in the XML catalog"));
      }
  }
}
