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

import java.util.concurrent.Callable;

import org.jspecify.annotations.NonNull;

import com.helger.schematron.CSchematronVersion;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.HelpCommand;
import picocli.CommandLine.Model.CommandSpec;
import picocli.CommandLine.Spec;

/**
 * Command line client of ph-schematron. Each function is a sub command.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Command (name = "ph-schematron",
          mixinStandardHelpOptions = true,
          versionProvider = SchematronCli.VersionProvider.class,
          description = "Validate XML with Schematron, convert Schematron to XSLT, preprocess Schematron and analyse its streamability.",
          subcommands = { ValidateCommand.class,
                          ConvertCommand.class,
                          PreprocessCommand.class,
                          StreamabilityCommand.class,
                          CheckCommand.class,
                          HelpCommand.class })
public final class SchematronCli implements Callable <Integer>
{
  /** Exit code: success */
  public static final int EXIT_OK = 0;
  /** Exit code: an expectation was not met (validation, streamability, Schematron check) */
  public static final int EXIT_FAILURE = 1;
  /** Exit code: invalid command line */
  public static final int EXIT_USAGE = CommandLine.ExitCode.USAGE;
  /** Exit code: invalid Schematron or a technical error (I/O, transformation) */
  public static final int EXIT_ERROR = 3;

  /**
   * Provides the version for <code>--version</code>.
   */
  public static final class VersionProvider implements CommandLine.IVersionProvider
  {
    /** Create a new version provider. Called by picocli. */
    public VersionProvider ()
    {}

    @NonNull
    public String [] getVersion ()
    {
      return new String [] { "ph-schematron " + CSchematronVersion.BUILD_VERSION };
    }
  }

  /** The model of the top level command, for the usage message. Injected by picocli. */
  @Spec
  CommandSpec m_aSpec;

  /** Constructor. Called by {@link #createCommandLine()}. */
  public SchematronCli ()
  {}

  /**
   * Called when no command is given: print the usage.
   *
   * @return Always {@link #EXIT_USAGE}.
   */
  public Integer call ()
  {
    // No sub command given
    m_aSpec.commandLine ().usage (m_aSpec.commandLine ().getErr ());
    return Integer.valueOf (EXIT_USAGE);
  }

  /**
   * Create the picocli command line of this client. Used by {@link #main(String[])} and by tests
   * that run the client in-process.
   *
   * @return A new command line for this client, with technical errors mapped to
   *         {@link #EXIT_ERROR}. Never <code>null</code>.
   */
  @NonNull
  public static CommandLine createCommandLine ()
  {
    final CommandLine ret = new CommandLine (new SchematronCli ());
    ret.setExecutionExceptionHandler ( (ex, aCmd, aParseResult) -> {
      aCmd.getErr ().println ("[error] " + ex.getClass ().getSimpleName () + ": " + ex.getMessage ());
      aCmd.getErr ().flush ();
      return EXIT_ERROR;
    });
    return ret;
  }

  /**
   * Entry point of the executable JAR. Exits the JVM with the exit code of the command.
   *
   * @param aArgs
   *        The command line arguments. May not be <code>null</code>.
   */
  public static void main (final String [] aArgs)
  {
    System.exit (createCommandLine ().execute (aArgs));
  }
}
