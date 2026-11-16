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

import org.junit.Test;

import com.helger.schematron.cli.CliRunner.CliResult;

/**
 * Test class for class {@link CheckCommand}.
 *
 * @author Philip Helger
 */
public final class CheckCommandTest
{
  @Test
  public void testCheck ()
  {
    CliResult aResult = CliRunner.run ("check", "src/test/resources/external/levels/levels.sch");
    assertEquals (aResult.err (), SchematronCli.EXIT_OK, aResult.exitCode ());
    assertTrue (aResult.out ().contains ("is valid"));

    aResult = CliRunner.run ("check", "src/test/resources/external/catalog/catalog.xml");
    assertEquals (SchematronCli.EXIT_FAILURE, aResult.exitCode ());
    assertTrue (aResult.err ().contains ("is not valid"));

    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("check", "does-not-exist.sch").exitCode ());
  }
}
