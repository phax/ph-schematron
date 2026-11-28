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
package com.helger.schematron.enginefactory;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.File;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.w3c.dom.Document;

import com.helger.diagnostics.error.list.IErrorList;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.phoxtrot.PhoxtrotXsltProcessor;
import com.helger.schematron.saxon.SaxonXsltProcessor;

/**
 * Test class for class {@link SchematronEngineFactory}.
 *
 * @author Philip Helger
 */
public final class SchematronEngineFactoryTest
{
  private static final File SCH = new File ("src/test/resources/external/levels/levels.sch");
  private static final File XML_VALID = new File ("src/test/resources/external/levels/valid.xml");
  private static final File XML_ERROR = new File ("src/test/resources/external/levels/error.xml");

  @Rule
  public final TemporaryFolder m_aTempFolder = new TemporaryFolder ();

  private static void _assertValidatesCorrectly (final SchematronEngineResource aRes) throws Exception
  {
    assertNotNull (aRes);
    final IErrorList aErrors = aRes.errors ();
    assertFalse (aErrors.toString (), aRes.hasAnyError ());
    assertTrue (aRes.resource ().getSchematronValidity (new FileSystemResource (XML_VALID)).isValid ());
    assertTrue (aRes.resource ().getSchematronValidity (new FileSystemResource (XML_ERROR)).isInvalid ());
  }

  @Test
  public void testIsXsltCreating ()
  {
    assertFalse (SchematronEngineFactory.isXsltCreating (ESchematronEngine.PURE_XPATH));
    assertTrue (SchematronEngineFactory.isXsltCreating (ESchematronEngine.PURE_XSLT));
    assertTrue (SchematronEngineFactory.isXsltCreating (ESchematronEngine.ISO_SCHEMATRON));
    assertTrue (SchematronEngineFactory.isXsltCreating (ESchematronEngine.SCHXSLT1));
    assertTrue (SchematronEngineFactory.isXsltCreating (ESchematronEngine.SCHXSLT2));
    assertFalse (SchematronEngineFactory.isXsltCreating (ESchematronEngine.XSLT_PREBUILT));

    assertEquals ("'pure-xslt', 'iso-schematron', 'schxslt', 'schxslt2'",
                  SchematronEngineFactory.getEngineIDsAsString (SchematronEngineFactory::isXsltCreating));
  }

  @Test
  public void testGetXsltProcessor ()
  {
    assertNull (SchematronEngineFactory.getXsltProcessor (ESchematronEngine.PURE_XPATH, SaxonXsltProcessor.ID));
    assertEquals (PhoxtrotXsltProcessor.ID,
                  SchematronEngineFactory.getXsltProcessor (ESchematronEngine.PURE_XSLT, PhoxtrotXsltProcessor.ID)
                                         .getID ());
    assertEquals (SaxonXsltProcessor.ID,
                  SchematronEngineFactory.getXsltProcessor (ESchematronEngine.ISO_SCHEMATRON, SaxonXsltProcessor.ID)
                                         .getID ());
    assertEquals (PhoxtrotXsltProcessor.ID,
                  SchematronEngineFactory.getXsltProcessor (ESchematronEngine.XSLT_PREBUILT, PhoxtrotXsltProcessor.ID)
                                         .getID ());

    // Both processors are on the test class path
    try
    {
      SchematronEngineFactory.getXsltProcessor (ESchematronEngine.SCHXSLT2, null);
      fail ();
    }
    catch (final IllegalStateException ex)
    {
      // expected
    }
    try
    {
      SchematronEngineFactory.getXsltProcessor (ESchematronEngine.SCHXSLT2, "unknown");
      fail ();
    }
    catch (final IllegalArgumentException ex)
    {
      // expected
    }
  }

  @Test
  public void testCreateResourceAllEngines () throws Exception
  {
    for (final ISchematronXsltProcessor aProcessor : SchematronXsltProcessorRegistry.getAllProcessors ())
      for (final ESchematronEngine eEngine : ESchematronEngine.values ())
        if (eEngine != ESchematronEngine.XSLT_PREBUILT)
        {
          final SchematronEngineSettings aSettings = new SchematronEngineSettings ().setEngine (eEngine)
                                                                                    .setXsltProcessor (aProcessor);
          _assertValidatesCorrectly (SchematronEngineFactory.createResource (SCH, aSettings));
        }
  }

  @Test
  public void testCreateXsltAndUsePrebuilt () throws Exception
  {
    for (final ISchematronXsltProcessor aProcessor : SchematronXsltProcessorRegistry.getAllProcessors ())
      for (final ESchematronEngine eEngine : ESchematronEngine.values ())
        if (SchematronEngineFactory.isXsltCreating (eEngine))
        {
          final SchematronEngineSettings aSettings = new SchematronEngineSettings ().setEngine (eEngine)
                                                                                    .setXsltProcessor (aProcessor);
          final Document aXslt = SchematronEngineFactory.createXsltDocument (new FileSystemResource (SCH),
                                                                             aSettings,
                                                                             null);
          assertNotNull (eEngine + " / " + aProcessor.getID (), aXslt);

          final File aXsltFile = new File (m_aTempFolder.getRoot (), eEngine.getID () + ".xslt");
          SchematronXsltCreator.writeXsltDocument (aXslt, null, aXsltFile);

          _assertValidatesCorrectly (SchematronEngineFactory.createResource (aXsltFile,
                                                                             new SchematronEngineSettings ().setEngine (ESchematronEngine.XSLT_PREBUILT)
                                                                                                            .setXsltProcessor (aProcessor)));
        }
  }

  @Test
  public void testCreateXsltUnsupportedEngine () throws Exception
  {
    for (final ESchematronEngine eEngine : new ESchematronEngine [] { ESchematronEngine.PURE_XPATH,
                                                                      ESchematronEngine.XSLT_PREBUILT })
      try
      {
        SchematronEngineFactory.createXsltDocument (new FileSystemResource (SCH),
                                                    new SchematronEngineSettings ().setEngine (eEngine),
                                                    null);
        fail ();
      }
      catch (final SchematronToolException ex)
      {
        assertTrue (ex.getMessage ().contains (eEngine.getID ()));
      }
  }

  @Test
  public void testInvalidSchematron ()
  {
    final SchematronEngineResource aRes = SchematronEngineFactory.createResource (new File ("src/test/resources/external/catalog/catalog.xml"),
                                                                                  new SchematronEngineSettings ().setEngine (ESchematronEngine.PURE_XPATH));
    assertTrue (aRes.hasAnyError ());
  }
}
