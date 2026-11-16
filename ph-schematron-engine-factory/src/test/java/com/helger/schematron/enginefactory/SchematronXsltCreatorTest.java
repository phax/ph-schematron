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

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.w3c.dom.Document;

import com.helger.diagnostics.error.list.ErrorList;
import com.helger.diagnostics.log.ErrorListLogHandler;
import com.helger.io.file.SimpleFileIO;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.saxon.SaxonXsltProcessor;

/**
 * Test class for class {@link SchematronXsltCreator}.
 *
 * @author Philip Helger
 */
public final class SchematronXsltCreatorTest
{
  private static final File SCH = new File ("src/test/resources/external/levels/levels.sch");

  @Rule
  public final TemporaryFolder m_aTempFolder = new TemporaryFolder ();

  private static SchematronEngineSettings _createSettings (final ESchematronEngine eEngine)
  {
    return new SchematronEngineSettings ().setEngine (eEngine)
                                          .setXsltProcessor (SchematronEngineFactory.getXsltProcessor (eEngine,
                                                                                                       SaxonXsltProcessor.ID));
  }

  @Test
  public void testConvert () throws Exception
  {
    for (final boolean bShowProgress : new boolean [] { false, true })
    {
      final File aXslt = new File (m_aTempFolder.getRoot (), "sub/dir/levels-" + bShowProgress + ".xslt");
      new SchematronXsltCreator (_createSettings (ESchematronEngine.ISO_SCHEMATRON),
                                 new ErrorListLogHandler (new ErrorList ())).setXsltHeader ("Version 1.2.3")
                                                             .setShowProgress (bShowProgress)
                                                             .convertFile (SCH, aXslt, null);
      assertTrue (aXslt.isFile ());
      final String sContent = SimpleFileIO.getFileAsString (aXslt, StandardCharsets.UTF_8);
      assertTrue (sContent.contains ("<!--Version 1.2.3-->"));
      assertTrue (sContent.contains ("xmlns:svrl="));

      // The created XSLT can be used for validation
      assertFalse (SchematronEngineFactory.createResource (aXslt, _createSettings (ESchematronEngine.XSLT_PREBUILT))
                                          .hasAnyError ());
    }
  }

  @Test
  public void testConvertError () throws Exception
  {
    for (final boolean bShowProgress : new boolean [] { false, true })
      try
      {
        new SchematronXsltCreator (_createSettings (ESchematronEngine.XSLT_PREBUILT),
                                   new ErrorListLogHandler (new ErrorList ())).setShowProgress (bShowProgress)
                                                               .convertFile (SCH,
                                                                             new File (m_aTempFolder.getRoot (), "x.xslt"),
                                                                             null);
        throw new IllegalStateException ("Expected an exception");
      }
      catch (final SchematronToolException ex)
      {
        assertTrue (ex.getMessage ().contains ("cannot create an XSLT"));
      }
  }

  @Test
  public void testGetXsltDocumentAsString () throws Exception
  {
    final Document aXslt = SchematronEngineFactory.createXsltDocument (new FileSystemResource (SCH),
                                                                       _createSettings (ESchematronEngine.ISO_SCHEMATRON),
                                                                       null);
    final String sXslt = SchematronXsltCreator.getXsltDocumentAsString (aXslt, "Version 1.2.3");
    assertTrue (sXslt.contains ("<!--Version 1.2.3-->"));
    assertTrue (sXslt.contains ("xmlns:svrl="));
  }
}
