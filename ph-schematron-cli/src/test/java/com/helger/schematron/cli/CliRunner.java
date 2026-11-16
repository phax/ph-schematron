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

import java.io.PrintWriter;
import java.io.StringWriter;

import org.jspecify.annotations.NonNull;

import picocli.CommandLine;

/**
 * Runs the command line client in-process and captures its output.
 *
 * @author Philip Helger
 */
final class CliRunner
{
  /**
   * The result of a run.
   *
   * @param exitCode
   *        The exit code.
   * @param out
   *        The standard output.
   * @param err
   *        The error output.
   */
  record CliResult (int exitCode, @NonNull String out, @NonNull String err)
  {}

  private CliRunner ()
  {}

  @NonNull
  static CliResult run (@NonNull final String... aArgs)
  {
    final StringWriter aOut = new StringWriter ();
    final StringWriter aErr = new StringWriter ();
    final CommandLine aCmd = SchematronCli.createCommandLine ();
    aCmd.setOut (new PrintWriter (aOut));
    aCmd.setErr (new PrintWriter (aErr));
    final int nExitCode = aCmd.execute (aArgs);
    return new CliResult (nExitCode, aOut.toString (), aErr.toString ());
  }
}
