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

import org.junit.Test;

import com.helger.schematron.CSchematronVersion;
import com.helger.schematron.cli.CliRunner.CliResult;

/**
 * Test class for class {@link SchematronCli}.
 *
 * @author Philip Helger
 */
public final class SchematronCliTest
{
  @Test
  public void testNoCommand ()
  {
    final CliResult aResult = CliRunner.run ();
    assertEquals (SchematronCli.EXIT_USAGE, aResult.exitCode ());
    assertTrue (aResult.err ().contains ("Usage: ph-schematron"));
  }

  @Test
  public void testVersion ()
  {
    final CliResult aResult = CliRunner.run ("--version");
    assertEquals (SchematronCli.EXIT_OK, aResult.exitCode ());
    assertTrue (aResult.out ().contains ("ph-schematron " + CSchematronVersion.BUILD_VERSION));
  }

  @Test
  public void testHelp ()
  {
    final CliResult aResult = CliRunner.run ("help", "validate");
    assertEquals (SchematronCli.EXIT_OK, aResult.exitCode ());
    assertTrue (aResult.out ().contains ("--expect-invalid"));
  }

  @Test
  public void testUnknownCommand ()
  {
    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("unknown").exitCode ());
  }
}
