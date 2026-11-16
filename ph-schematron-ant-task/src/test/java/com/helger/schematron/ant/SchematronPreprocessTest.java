/*
 * Copyright (C) 2017-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.ant;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;

import org.apache.tools.ant.BuildFileRule;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import com.helger.io.file.SimpleFileIO;

/**
 * Test class for class {@link SchematronPreprocess}.
 *
 * @author Philip Helger
 */
public final class SchematronPreprocessTest
{
  @Rule
  public final BuildFileRule m_aBuildRule = new BuildFileRule ();

  @Rule
  public final TemporaryFolder m_aTempFolder = new TemporaryFolder ();

  @Before
  public void init ()
  {
    m_aBuildRule.configureProject ("src/test/resources/external/tools/build.xml");
    m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/external/tools"));
    m_aBuildRule.getProject ().setProperty ("outdir", m_aTempFolder.getRoot ().getAbsolutePath ());
    m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
  }

  @Test
  public void testPreprocess ()
  {
    m_aBuildRule.executeTarget ("preprocess");

    final String sContent = SimpleFileIO.getFileAsString (new File (m_aTempFolder.getRoot (), "preprocessed.sch"),
                                                          StandardCharsets.UTF_8);
    assertTrue (sContent.contains ("<!--my header-->"));
    assertTrue (sContent.contains ("<rule context=\"ex:order\">"));
    // Empty pattern removed by default
    assertFalse (sContent.contains ("id=\"empty\""));
  }

  @Test
  public void testNoOverwrite () throws Exception
  {
    final File aExisting = m_aTempFolder.newFile ("existing.sch");
    SimpleFileIO.writeFile (aExisting, "unchanged", StandardCharsets.UTF_8);

    m_aBuildRule.executeTarget ("preprocess-no-overwrite");
    assertEquals ("unchanged", SimpleFileIO.getFileAsString (aExisting, StandardCharsets.UTF_8));
  }
}
