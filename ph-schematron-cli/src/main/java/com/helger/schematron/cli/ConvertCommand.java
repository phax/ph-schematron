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
import java.util.List;
import java.util.Locale;
import java.util.concurrent.Callable;

import org.jspecify.annotations.NonNull;
import org.w3c.dom.Document;

import com.helger.base.log.ILogHandler;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.IError;
import com.helger.io.file.FilenameHelper;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.cli.CliFileCollector.CliInputFile;
import com.helger.schematron.enginefactory.SchematronEngineFactory;
import com.helger.schematron.enginefactory.SchematronEngineSettings;
import com.helger.schematron.enginefactory.SchematronToolException;
import com.helger.schematron.enginefactory.SchematronToolLogHelper;
import com.helger.schematron.enginefactory.SchematronXsltCreator;
import com.helger.xml.transform.CollectingTransformErrorListener;

import picocli.CommandLine.Command;
import picocli.CommandLine.Mixin;
import picocli.CommandLine.Model.CommandSpec;
import picocli.CommandLine.Option;
import picocli.CommandLine.ParameterException;
import picocli.CommandLine.Parameters;
import picocli.CommandLine.Spec;

/**
 * The command <code>convert</code>: convert Schematron files to XSLT files, like the Maven goal
 * <code>convert</code> and the Ant task <code>schematron-convert</code>.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Command (name = "convert",
          mixinStandardHelpOptions = true,
          description = "Convert Schematron files to XSLT files. The engine must be iso-schematron, schxslt, schxslt2 or pure-xslt.")
public final class ConvertCommand implements Callable <Integer>
{
  /** The output value for the standard output */
  public static final String OUT_STDOUT = "-";

  @Spec
  CommandSpec m_aSpec;

  @Mixin
  CliLogOptions m_aLogOptions;

  @Mixin
  SchematronEngineOptions m_aEngineOptions;

  @Option (names = { "-o", "--out" },
           required = true,
           paramLabel = "DIR",
           description = "The directory for the XSLT files, or " + OUT_STDOUT + " to write the XSLT of a single Schematron file to the standard output.")
  String m_sOut;

  @Option (names = "--pattern",
           paramLabel = "GLOB",
           defaultValue = "**/*.sch",
           description = "The Schematron files to convert in a directory argument. Default: ${DEFAULT-VALUE}.")
  String m_sPattern;

  @Option (names = "--xslt-extension",
           paramLabel = "EXT",
           defaultValue = ".xslt",
           description = "The file extension of the XSLT files. Default: ${DEFAULT-VALUE}.")
  String m_sXsltExtension;

  @Option (names = "--no-overwrite", description = "Leave existing XSLT files untouched.")
  boolean m_bNoOverwrite;

  @Option (names = "--xslt-header", paramLabel = "TEXT", description = "A text added as XML comment to each XSLT file.")
  String m_sXsltHeader;

  @Option (names = "--show-progress", description = "Log a message every 5 seconds while a conversion takes longer.")
  boolean m_bShowProgress;

  @Option (names = "--continue-on-error", description = "Continue with the next Schematron file after an error.")
  boolean m_bContinueOnError;

  @Parameters (paramLabel = "PATH", arity = "1..*", description = "The Schematron files or directories.")
  List <File> m_aInputs;

  public ConvertCommand ()
  {}

  private static void _logErrors (@NonNull final ILogHandler aLog, @NonNull final CollectingTransformErrorListener aErrorListener)
  {
    for (final IError aError : aErrorListener.getErrorList ())
      SchematronToolLogHelper.log (aLog, aError.getErrorLevel (), aError.getAsString (Locale.US));
  }

  @NonNull
  private Integer _convertToStdOut (@NonNull final SchematronEngineSettings aSettings, @NonNull final ILogHandler aLog)
  {
    if (m_aInputs.size () != 1 || !m_aInputs.get (0).isFile ())
      throw new ParameterException (m_aSpec.commandLine (),
                                    "Writing to the standard output requires exactly one Schematron file");

    final File aFile = m_aInputs.get (0);
    final CollectingTransformErrorListener aErrorListener = new CollectingTransformErrorListener ();
    try
    {
      final Document aXsltDoc = SchematronEngineFactory.createXsltDocument (new FileSystemResource (aFile),
                                                                            aSettings,
                                                                            aErrorListener);
      _logErrors (aLog, aErrorListener);
      if (aXsltDoc == null)
      {
        aLog.error ("Failed to convert '" + aFile.getPath () + "': the Schematron is invalid");
        return Integer.valueOf (SchematronCli.EXIT_ERROR);
      }
      m_aSpec.commandLine ().getOut ().print (SchematronXsltCreator.getXsltDocumentAsString (aXsltDoc, m_sXsltHeader));
      m_aSpec.commandLine ().getOut ().flush ();
      return Integer.valueOf (SchematronCli.EXIT_OK);
    }
    catch (final Exception ex)
    {
      _logErrors (aLog, aErrorListener);
      aLog.error ("Failed to convert '" + aFile.getPath () + "'", ex);
      return Integer.valueOf (SchematronCli.EXIT_ERROR);
    }
  }

  public Integer call ()
  {
    final boolean bToStdOut = OUT_STDOUT.equals (m_sOut);
    final ILogHandler aLog = m_aLogOptions.createLogHandler (m_aSpec, bToStdOut);
    final SchematronEngineSettings aSettings = m_aEngineOptions.createSettings (m_aSpec,
                                                                                SchematronEngineFactory::isXsltCreating);
    if (bToStdOut)
      return _convertToStdOut (aSettings, aLog);

    if (StringHelper.isEmpty (m_sXsltExtension) || !m_sXsltExtension.startsWith ("."))
      throw new ParameterException (m_aSpec.commandLine (), "The XSLT extension '" + m_sXsltExtension + "' is invalid");
    final File aOutDir = new File (m_sOut);
    if (aOutDir.exists () && !aOutDir.isDirectory ())
      throw new ParameterException (m_aSpec.commandLine (), "The output '" + m_sOut + "' is not a directory");

    final ICommonsList <CliInputFile> aFiles;
    try
    {
      aFiles = CliFileCollector.collect (m_aInputs, new CommonsArrayList <> (m_sPattern), null);
    }
    catch (final IllegalArgumentException ex)
    {
      throw new ParameterException (m_aSpec.commandLine (), ex.getMessage ());
    }
    if (aFiles.isEmpty ())
      throw new ParameterException (m_aSpec.commandLine (), "No Schematron file to convert was found");

    final SchematronXsltCreator aCreator = new SchematronXsltCreator (aSettings, aLog).setXsltHeader (m_sXsltHeader)
                                                                                     .setShowProgress (m_bShowProgress);
    int nFailed = 0;
    for (final CliInputFile aInput : aFiles)
    {
      final File aXsltFile = new File (aOutDir,
                                       FilenameHelper.getWithoutExtension (aInput.relativePath ()) + m_sXsltExtension);
      if (m_bNoOverwrite && aXsltFile.exists ())
      {
        aLog.info ("Skipping existing XSLT file '" + aXsltFile.getPath () + "'");
        continue;
      }

      final CollectingTransformErrorListener aErrorListener = new CollectingTransformErrorListener ();
      try
      {
        aCreator.convertFile (aInput.file (), aXsltFile, aErrorListener);
        _logErrors (aLog, aErrorListener);
        aLog.info ("Converted '" + aInput.file ().getPath () + "' to '" + aXsltFile.getPath () + "'");
      }
      catch (final SchematronToolException ex)
      {
        _logErrors (aLog, aErrorListener);
        aLog.error (ex.getMessage (), ex.getCause ());
        nFailed++;
        if (!m_bContinueOnError)
          break;
      }
    }
    return Integer.valueOf (nFailed > 0 ? SchematronCli.EXIT_ERROR : SchematronCli.EXIT_OK);
  }
}
