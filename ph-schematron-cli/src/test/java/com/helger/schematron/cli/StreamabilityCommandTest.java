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

import com.helger.schematron.cli.CliRunner.CliResult;

/**
 * Test class for class {@link StreamabilityCommand}.
 *
 * @author Philip Helger
 */
public final class StreamabilityCommandTest
{
  private static final String BURST = "src/test/resources/external/streamability/streamability-burst.sch";
  private static final String NON_LOCAL = "src/test/resources/external/streamability/streamability-non-local.sch";

  @Test
  public void testReport ()
  {
    final CliResult aResult = CliRunner.run ("streamability", BURST, NON_LOCAL);
    assertEquals (SchematronCli.EXIT_OK, aResult.exitCode ());
    assertTrue (aResult.out ().contains ("burst: 1 pattern, 1 rule"));
  }

  @Test
  public void testMaximumClass ()
  {
    assertEquals (SchematronCli.EXIT_OK, CliRunner.run ("streamability", "--max-class", "burst", BURST).exitCode ());

    final CliResult aResult = CliRunner.run ("streamability", "--max-class", "burst", BURST, NON_LOCAL);
    assertEquals (SchematronCli.EXIT_FAILURE, aResult.exitCode ());
    assertTrue (aResult.err ().contains ("is non-local, but at most burst is allowed"));

    assertEquals (SchematronCli.EXIT_USAGE, CliRunner.run ("streamability", "--max-class", "fast", BURST).exitCode ());
  }
}
