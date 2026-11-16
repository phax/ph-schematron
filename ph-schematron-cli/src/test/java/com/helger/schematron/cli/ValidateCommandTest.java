/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.cli.CliRunner.CliResult;

/**
 * Test class for class {@link ValidateCommand}.
 *
 * @author Philip Helger
 */
public final class ValidateCommandTest
{
  private static final String DIR = "src/test/resources/external/levels/";
  private static final String SCH = DIR + "levels.sch";

  @Rule
  public final TemporaryFolder m_aTempFolder = new TemporaryFolder ();

  @Test
  public void testValid ()
  {
    final CliResult aResult = CliRunner.run ("validate",
                                             "-s",
                                             SCH,
                                             DIR + "valid.xml",
                                             DIR + "warning-info.xml",
                                             "--expect-invalid",
                                             DIR + "error.xml");
    assertEquals (aResult.err (), SchematronCli.EXIT_OK, aResult.exitCode ());
    assertTrue (aResult.out ().contains ("3 XML files validated, 0 failed"));
    // Warnings go to the error output
    assertTrue (aResult.err ().contains ("The order has no date."));
  }

  @Test
  public void testDirectoryWithFailures ()
  {
    final CliResult aResult = CliRunner.run ("validate", "-s", SCH, DIR, "--fail-on-warning");
    assertEquals (SchematronCli.EXIT_FAILURE, aResult.exitCode ());
    // error.xml fails, warning-info.xml fails with --fail-on-warning
    assertTrue (aResult.out ().contains ("3 XML files validated, 2 failed"));

    final CliResult aExcluded = CliRunner.run ("validate", "-s", SCH, DIR, "--exclude", "error.xml");
    assertEquals (SchematronCli.EXIT_OK, aExcluded.exitCode ());
    assertTrue (aExcluded.out ().contains ("2 XML files validated, 0 failed"));
  }

  @Test
  public void testFailFast ()
  {
    final CliResult aResult = CliRunner.run ("validate", "-s", SCH, DIR, "--fail-fast", "--include", "e*.xml", "--include", "v*.xml");
    assertEquals (SchematronCli.EXIT_FAILURE, aResult.exitCode ());
    assertTrue (aResult.out ().contains ("1 XML file validated, 1 failed"));
  }

  @Test
  public void testErrorRole ()
  {
    final CliResult aResult = CliRunner.run ("validate", "-s", SCH, DIR + "warning-info.xml", "--error-role", "warning");
    assertEquals (SchematronCli.EXIT_FAILURE, aResult.exitCode ());
  }

  @Test
  public void testAllEnginesAndProcessors ()
  {
    for (final ESchematronEngine eEngine : ESchematronEngine.values ())
      if (eEngine != ESchematronEngine.XSLT_PREBUILT)
        for (final String sProcessor : new String [] { "saxon", "phoxtrot" })
        {
          final CliResult aResult = CliRunner.run ("validate",
                                                   "-q",
                                                   "-s",
                                                   SCH,
                                                   "-e",
                                                   eEngine.getID (),
                                                   "-x",
                                                   sProcessor,
                                                   DIR + "valid.xml",
                                                   "--expect-invalid",
                                                   DIR + "error.xml");
          assertEquals (eEngine.getID () + "/" + sProcessor + ": " + aResult.err (),
                        SchematronCli.EXIT_OK,
                        aResult.exitCode ());
        }
  }

  @Test
  public void testSvrlDirectory ()
  {
    final File aSvrlDir = m_aTempFolder.getRoot ();
    assertEquals (SchematronCli.EXIT_OK,
                  CliRunner.run ("validate", "-q", "-s", SCH, DIR, "--exclude", "error.xml", "--svrl-dir", aSvrlDir.getPath ())
                           .exitCode ());
    assertTrue (new File (aSvrlDir, "valid.xml.svrl").isFile ());
    assertTrue (new File (aSvrlDir, "warning-info.xml.svrl").isFile ());
  }

  @Test
  public void testCatalog ()
  {
    final String sCatalogDir = "src/test/resources/external/catalog/";
    CliResult aResult = CliRunner.run ("validate",
                                       "-s",
                                       sCatalogDir + "doc.sch",
                                       "--catalog",
                                       sCatalogDir + "catalog.xml",
                                       sCatalogDir + "doc.xml");
    assertEquals (aResult.err (), SchematronCli.EXIT_OK, aResult.exitCode ());

    // DTD not in the catalog
    aResult = CliRunner.run ("validate",
                             "-s",
                             sCatalogDir + "doc.sch",
                             "--catalog",
                             sCatalogDir + "catalog.xml",
                             sCatalogDir + "doc-unknown-dtd.xml");
    assertEquals (SchematronCli.EXIT_ERROR, aResult.exitCode ());
    assertTrue (aResult.err ().contains ("is not in the XML catalog"));
  }

  @Test
  public void testUsageErrors ()
  {
    // Missing Schematron
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("validate", "-s", "does-not-exist.sch", DIR).exitCode ());
    // Missing XML
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("validate", "-s", SCH, "does-not-exist.xml").exitCode ());
    // No XML at all
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("validate", "-s", SCH).exitCode ());
    // Unknown engine
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("validate", "-s", SCH, "-e", "fast", DIR).exitCode ());
    // Unknown XSLT processor
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("validate", "-s", SCH, "-x", "fast", DIR).exitCode ());
  }

  @Test
  public void testInvalidSchematron ()
  {
    final CliResult aResult = CliRunner.run ("validate",
                                             "-s",
                                             "src/test/resources/external/catalog/catalog.xml",
                                             "-e",
                                             "pure-xpath",
                                             DIR + "valid.xml");
    assertEquals (SchematronCli.EXIT_ERROR, aResult.exitCode ());
  }
}
