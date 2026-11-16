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
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import com.helger.diagnostics.error.list.ErrorList;
import com.helger.diagnostics.log.ErrorListLogHandler;
import com.helger.io.file.SimpleFileIO;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.model.PSSchema;

/**
 * Test class for class {@link SchematronFilePreprocessor}.
 *
 * @author Philip Helger
 */
public final class SchematronFilePreprocessorTest
{
  private static final File SCH = new File ("src/test/resources/external/preprocess/abstract.sch");

  @Rule
  public final TemporaryFolder m_aTempFolder = new TemporaryFolder ();

  @Test
  public void testDefaults () throws Exception
  {
    final File aTarget = new File (m_aTempFolder.getRoot (), "out.sch");
    assertTrue (new SchematronFilePreprocessor (new ErrorListLogHandler (new ErrorList ())).setSchHeader ("my header")
                                                                            .preprocessFile (SCH, aTarget));

    final String sContent = SimpleFileIO.getFileAsString (aTarget, StandardCharsets.UTF_8);
    assertTrue (sContent, sContent.contains ("<!--my header-->"));
    assertTrue (sContent, sContent.contains ("<ns prefix=\"ex\" uri=\"urn:example\" />"));

    final PSSchema aSchema = new PSReader (new FileSystemResource (aTarget)).readSchema ();
    // Title removed
    assertNull (aSchema.getTitle ());
    // Abstract pattern resolved, empty pattern removed
    assertEquals (1, aSchema.getPatternCount ());
    assertTrue (aSchema.isPreprocessed ());
  }

  @Test
  public void testKeepEverything () throws Exception
  {
    final File aTarget = new File (m_aTempFolder.getRoot (), "out.sch");
    assertTrue (new SchematronFilePreprocessor (new ErrorListLogHandler (new ErrorList ())).setKeepTitles (true)
                                                                            .setKeepEmptyPatterns (true)
                                                                            .preprocessFile (SCH, aTarget));

    final PSSchema aSchema = new PSReader (new FileSystemResource (aTarget)).readSchema ();
    assertTrue (aSchema.hasTitle ());
    assertEquals (2, aSchema.getPatternCount ());
  }

  @Test
  public void testNoOverwrite () throws Exception
  {
    final File aTarget = m_aTempFolder.newFile ("existing.sch");
    SimpleFileIO.writeFile (aTarget, "unchanged", StandardCharsets.UTF_8);

    final ErrorListLogHandler aLogger = new ErrorListLogHandler (new ErrorList ());
    assertFalse (new SchematronFilePreprocessor (aLogger).setOverwrite (false).preprocessFile (SCH, aTarget));
    assertEquals ("unchanged", SimpleFileIO.getFileAsString (aTarget, StandardCharsets.UTF_8));

    // The default overwrites
    assertTrue (new SchematronFilePreprocessor (aLogger).preprocessFile (SCH, aTarget));
    assertFalse ("unchanged".equals (SimpleFileIO.getFileAsString (aTarget, StandardCharsets.UTF_8)));
  }

  @Test (expected = SchematronToolException.class)
  public void testTargetIsDirectory () throws Exception
  {
    new SchematronFilePreprocessor (new ErrorListLogHandler (new ErrorList ())).preprocessFile (SCH, m_aTempFolder.getRoot ());
  }
}
