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

import java.io.File;
import java.util.concurrent.Callable;

import com.helger.base.log.ILogHandler;
import com.helger.schematron.SchematronException;
import com.helger.schematron.enginefactory.SchematronFilePreprocessor;
import com.helger.schematron.model.PSSchema;
import com.helger.xml.microdom.serialize.MicroWriter;

import picocli.CommandLine.Command;
import picocli.CommandLine.Mixin;
import picocli.CommandLine.Model.CommandSpec;
import picocli.CommandLine.Option;
import picocli.CommandLine.ParameterException;
import picocli.CommandLine.Spec;

/**
 * The command <code>preprocess</code>: write a preprocessed Schematron, like the Maven goal
 * <code>preprocess</code> and the Ant task <code>schematron-preprocess</code>.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Command (name = "preprocess",
          mixinStandardHelpOptions = true,
          description = "Write a preprocessed Schematron: includes, abstract patterns and abstract rules are resolved, with the query binding of the Schematron.")
public final class PreprocessCommand implements Callable <Integer>
{
  /** The model of this command, for the output streams and usage errors. Injected by picocli. */
  @Spec
  CommandSpec m_aSpec;

  /** The logging options <code>-v</code> and <code>-q</code>. */
  @Mixin
  CliLogOptions m_aLogOptions;

  /** The Schematron file to preprocess. */
  @Option (names = { "-s", "--schematron" }, required = true, paramLabel = "FILE", description = "The Schematron file to preprocess.")
  File m_aSourceFile;

  /** The file to write. <code>null</code> to write to the standard output. */
  @Option (names = { "-o", "--out" },
           paramLabel = "FILE",
           description = "The file to write. Default: the standard output.")
  File m_aTargetFile;

  /** <code>true</code> to keep the <code>title</code> elements. */
  @Option (names = "--keep-titles", description = "Keep the title elements.")
  boolean m_bKeepTitles;

  /** <code>true</code> to keep the <code>diagnostic</code> elements. */
  @Option (names = "--keep-diagnostics", description = "Keep the diagnostic elements.")
  boolean m_bKeepDiagnostics;

  /**
   * <code>true</code> to keep the <code>report</code> elements instead of converting them to
   * <code>assert</code> elements.
   */
  @Option (names = "--keep-reports", description = "Keep the report elements instead of converting them to assert elements.")
  boolean m_bKeepReports;

  /** <code>true</code> to keep <code>pattern</code> elements without a rule. */
  @Option (names = "--keep-empty-patterns", description = "Keep pattern elements without a rule.")
  boolean m_bKeepEmptyPatterns;

  /** A text added as XML comment. May be <code>null</code>. */
  @Option (names = "--sch-header", paramLabel = "TEXT", description = "A text added as XML comment.")
  String m_sSchHeader;

  /** <code>true</code> to leave an existing output file untouched. */
  @Option (names = "--no-overwrite", description = "Leave an existing output file untouched.")
  boolean m_bNoOverwrite;

  /** Constructor. Called by picocli. */
  public PreprocessCommand ()
  {}

  /**
   * Preprocess the Schematron and write it to the output file or the standard output.
   *
   * @return {@link SchematronCli#EXIT_OK} on success (also if an existing output file was left
   *         untouched), {@link SchematronCli#EXIT_ERROR} if the Schematron cannot be read or
   *         preprocessed.
   */
  public Integer call ()
  {
    final boolean bToStdOut = m_aTargetFile == null;
    // With the Schematron on the standard output, info messages must go to the error output
    final ILogHandler aLog = m_aLogOptions.createLogHandler (m_aSpec, bToStdOut);
    if (!m_aSourceFile.isFile ())
      throw new ParameterException (m_aSpec.commandLine (),
                                    "The Schematron file '" + m_aSourceFile.getPath () + "' does not exist");

    final SchematronFilePreprocessor aPreprocessor = new SchematronFilePreprocessor (aLog).setKeepTitles (m_bKeepTitles)
                                                                                         .setKeepDiagnostics (m_bKeepDiagnostics)
                                                                                         .setKeepReports (m_bKeepReports)
                                                                                         .setKeepEmptyPatterns (m_bKeepEmptyPatterns)
                                                                                         .setSchHeader (m_sSchHeader)
                                                                                         .setOverwrite (!m_bNoOverwrite);
    try
    {
      if (bToStdOut)
      {
        final PSSchema aSchema = aPreprocessor.getPreprocessedSchema (m_aSourceFile);
        m_aSpec.commandLine ()
               .getOut ()
               .print (MicroWriter.getNodeAsString (aPreprocessor.getAsDocument (aSchema),
                                                    SchematronFilePreprocessor.createXMLWriterSettings (aSchema)));
        m_aSpec.commandLine ().getOut ().flush ();
      }
      else
        aPreprocessor.preprocessFile (m_aSourceFile, m_aTargetFile);
      return Integer.valueOf (SchematronCli.EXIT_OK);
    }
    catch (final SchematronException ex)
    {
      aLog.error ("Failed to preprocess '" + m_aSourceFile.getPath () + "'", ex);
      return Integer.valueOf (SchematronCli.EXIT_ERROR);
    }
  }
}
