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
package com.helger.schematron.cli;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import com.helger.io.file.SimpleFileIO;
import com.helger.schematron.cli.CliRunner.CliResult;

/**
 * Test class for class {@link PreprocessCommand}.
 *
 * @author Philip Helger
 */
public final class PreprocessCommandTest
{
  private static final String SCH = "src/test/resources/external/preprocess/abstract.sch";

  @Rule
  public final TemporaryFolder m_aTempFolder = new TemporaryFolder ();

  @Test
  public void testToStdOut ()
  {
    final CliResult aResult = CliRunner.run ("preprocess", "-s", SCH, "--sch-header", "my header");
    assertEquals (aResult.err (), SchematronCli.EXIT_OK, aResult.exitCode ());
    assertTrue (aResult.out ().contains ("<!--my header-->"));
    assertTrue (aResult.out ().contains ("<rule context=\"ex:order\">"));
    assertFalse (aResult.out ().contains ("id=\"empty\""));
  }

  @Test
  public void testToFile () throws Exception
  {
    final File aTarget = new File (m_aTempFolder.getRoot (), "out.sch");
    assertEquals (SchematronCli.EXIT_OK, CliRunner.run ("preprocess", "-s", SCH, "-o", aTarget.getPath (), "--keep-empty-patterns").exitCode ());
    assertTrue (SimpleFileIO.getFileAsString (aTarget, StandardCharsets.UTF_8).contains ("id=\"empty\""));

    // Not overwritten
    SimpleFileIO.writeFile (aTarget, "unchanged", StandardCharsets.UTF_8);
    assertEquals (SchematronCli.EXIT_OK, CliRunner.run ("preprocess", "-s", SCH, "-o", aTarget.getPath (), "--no-overwrite").exitCode ());
    assertEquals ("unchanged", SimpleFileIO.getFileAsString (aTarget, StandardCharsets.UTF_8));
  }

  @Test
  public void testErrors ()
  {
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("preprocess", "-s", "does-not-exist.sch").exitCode ());
    assertEquals (SchematronCli.EXIT_ERROR,
                  CliRunner.run ("preprocess", "-s", "src/test/resources/external/catalog/catalog.xml").exitCode ());
  }
}
