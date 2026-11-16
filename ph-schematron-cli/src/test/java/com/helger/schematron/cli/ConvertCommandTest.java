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
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import com.helger.io.file.SimpleFileIO;
import com.helger.schematron.cli.CliRunner.CliResult;

/**
 * Test class for class {@link ConvertCommand}.
 *
 * @author Philip Helger
 */
public final class ConvertCommandTest
{
  private static final String DIR = "src/test/resources/external/levels/";

  @Rule
  public final TemporaryFolder m_aTempFolder = new TemporaryFolder ();

  @Test
  public void testConvertDirectoryAndValidate ()
  {
    final File aOutDir = m_aTempFolder.getRoot ();
    CliResult aResult = CliRunner.run ("convert", "-o", aOutDir.getPath (), "--xslt-header", "Version 1.2.3", DIR);
    assertEquals (aResult.err (), SchematronCli.EXIT_OK, aResult.exitCode ());
    final File aXslt = new File (aOutDir, "levels.xslt");
    assertTrue (aXslt.isFile ());
    assertTrue (SimpleFileIO.getFileAsString (aXslt, StandardCharsets.UTF_8).contains ("<!--Version 1.2.3-->"));

    // Use the created XSLT
    aResult = CliRunner.run ("validate", "-e", "xslt", "-s", aXslt.getPath (), DIR + "valid.xml", "--expect-invalid", DIR + "error.xml");
    assertEquals (aResult.err (), SchematronCli.EXIT_OK, aResult.exitCode ());
  }

  @Test
  public void testNoOverwrite () throws Exception
  {
    final File aXslt = m_aTempFolder.newFile ("levels.xslt");
    SimpleFileIO.writeFile (aXslt, "unchanged", StandardCharsets.UTF_8);
    assertEquals (SchematronCli.EXIT_OK,
                  CliRunner.run ("convert", "-o", m_aTempFolder.getRoot ().getPath (), "--no-overwrite", DIR).exitCode ());
    assertEquals ("unchanged", SimpleFileIO.getFileAsString (aXslt, StandardCharsets.UTF_8));
  }

  @Test
  public void testToStdOut ()
  {
    for (final String sEngine : new String [] { "iso-schematron", "schxslt", "schxslt2", "pure-xslt" })
    {
      final CliResult aResult = CliRunner.run ("convert", "-e", sEngine, "-o", "-", DIR + "levels.sch");
      assertEquals (sEngine + ": " + aResult.err (), SchematronCli.EXIT_OK, aResult.exitCode ());
      // The engines differ in the root element name and prefix
      assertTrue (aResult.out ().contains ("\"http://www.w3.org/1999/XSL/Transform\""));
    }
  }

  @Test
  public void testUsageErrors ()
  {
    // Engine that cannot create an XSLT
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("convert", "-e", "pure-xpath", "-o", "-", DIR + "levels.sch").exitCode ());
    // Standard output needs exactly one file
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("convert", "-o", "-", DIR).exitCode ());
    // Invalid extension
    assertEquals (SchematronCli.EXIT_USAGE,
                  CliRunner.run ("convert", "-o", m_aTempFolder.getRoot ().getPath (), "--xslt-extension", "xslt", DIR)
                           .exitCode ());
  }
}
