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

import org.jspecify.annotations.NonNull;

import com.helger.base.log.ILogHandler;

import picocli.CommandLine.Model.CommandSpec;
import picocli.CommandLine.Option;

/**
 * The logging options shared by all commands.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
final class CliLogOptions
{
  /** <code>true</code> to also print debug and trace messages and stack traces. */
  @Option (names = { "-v", "--verbose" }, description = "Also print debug messages and stack traces.")
  boolean m_bVerbose;

  /** <code>true</code> to suppress info messages. */
  @Option (names = { "-q", "--quiet" }, description = "Only print warnings and errors.")
  boolean m_bQuiet;

  /** Constructor. Called by picocli. */
  CliLogOptions ()
  {}

  /**
   * Create the log handler for a command, based on these options.
   *
   * @param aSpec
   *        The command whose output streams are used. May not be <code>null</code>.
   * @param bResultOnStdOut
   *        <code>true</code> if the standard output carries the result (e.g. an XML document), so
   *        that info messages must go to the error output.
   * @return A new log handler. Never <code>null</code>.
   */
  @NonNull
  ILogHandler createLogHandler (@NonNull final CommandSpec aSpec, final boolean bResultOnStdOut)
  {
    return new CliLogHandler (bResultOnStdOut ? aSpec.commandLine ().getErr () : aSpec.commandLine ().getOut (),
                              aSpec.commandLine ().getErr (),
                              m_bVerbose,
                              m_bQuiet);
  }
}
