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
  @Spec
  CommandSpec m_aSpec;

  @Mixin
  CliLogOptions m_aLogOptions;

  @Option (names = { "-s", "--schematron" }, required = true, paramLabel = "FILE", description = "The Schematron file to preprocess.")
  File m_aSourceFile;

  @Option (names = { "-o", "--out" },
           paramLabel = "FILE",
           description = "The file to write. Default: the standard output.")
  File m_aTargetFile;

  @Option (names = "--keep-titles", description = "Keep the title elements.")
  boolean m_bKeepTitles;

  @Option (names = "--keep-diagnostics", description = "Keep the diagnostic elements.")
  boolean m_bKeepDiagnostics;

  @Option (names = "--keep-reports", description = "Keep the report elements instead of converting them to assert elements.")
  boolean m_bKeepReports;

  @Option (names = "--keep-empty-patterns", description = "Keep pattern elements without a rule.")
  boolean m_bKeepEmptyPatterns;

  @Option (names = "--sch-header", paramLabel = "TEXT", description = "A text added as XML comment.")
  String m_sSchHeader;

  @Option (names = "--no-overwrite", description = "Leave an existing output file untouched.")
  boolean m_bNoOverwrite;

  public PreprocessCommand ()
  {}

  public Integer call ()
  {
    final boolean bToStdOut = m_aTargetFile == null;
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
