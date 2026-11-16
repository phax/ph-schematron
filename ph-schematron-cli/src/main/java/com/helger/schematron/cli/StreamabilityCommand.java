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
import java.util.concurrent.Callable;

import com.helger.base.log.ILogHandler;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.SchematronException;
import com.helger.schematron.streamability.EStreamabilityClass;
import com.helger.schematron.streamability.SchematronStreamabilityAnalyzer;
import com.helger.schematron.streamability.SchematronStreamabilityReport;

import picocli.CommandLine.Command;
import picocli.CommandLine.Mixin;
import picocli.CommandLine.Model.CommandSpec;
import picocli.CommandLine.Option;
import picocli.CommandLine.ParameterException;
import picocli.CommandLine.Parameters;
import picocli.CommandLine.Spec;

/**
 * The command <code>streamability</code>: report whether a Schematron can be validated while
 * streaming, like the Maven goal and the Ant task <code>streamability</code>.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Command (name = "streamability",
          mixinStandardHelpOptions = true,
          description = "Report per rule whether a Schematron can be validated while streaming the instance document: motionless, burst or non-local.")
public final class StreamabilityCommand implements Callable <Integer>
{
  /** The model of this command, for the output streams and usage errors. Injected by picocli. */
  @Spec
  CommandSpec m_aSpec;

  /** The logging options <code>-v</code> and <code>-q</code>. */
  @Mixin
  CliLogOptions m_aLogOptions;

  /** The worst streamability class allowed. <code>null</code> to only report. */
  @Option (names = "--max-class",
           paramLabel = "CLASS",
           description = "The worst streamability class allowed: motionless, burst or non-local. A Schematron that needs more fails.")
  String m_sMaximumClass;

  /** The Schematron files to analyse. */
  @Parameters (paramLabel = "FILE", arity = "1..*", description = "The Schematron files to analyse.")
  List <File> m_aSchematronFiles;

  /** Constructor. Called by picocli. */
  public StreamabilityCommand ()
  {}

  /**
   * Analyse all Schematron files and log their reports.
   *
   * @return {@link SchematronCli#EXIT_OK} if all files are within the maximum class,
   *         {@link SchematronCli#EXIT_FAILURE} if at least one needs more, and
   *         {@link SchematronCli#EXIT_ERROR} if a file could not be analysed.
   */
  public Integer call ()
  {
    final ILogHandler aLog = m_aLogOptions.createLogHandler (m_aSpec, false);
    EStreamabilityClass eMaximumClass = null;
    if (m_sMaximumClass != null)
    {
      eMaximumClass = EStreamabilityClass.getFromIDOrNull (m_sMaximumClass);
      if (eMaximumClass == null)
        throw new ParameterException (m_aSpec.commandLine (),
                                      "The maximum streamability class '" +
                                                              m_sMaximumClass +
                                                              "' is unknown. Use one of 'motionless', 'burst' or 'non-local'.");
    }

    int nFailed = 0;
    boolean bTechnicalError = false;
    for (final File aFile : m_aSchematronFiles)
    {
      if (!aFile.isFile ())
        throw new ParameterException (m_aSpec.commandLine (), "The Schematron file '" + aFile.getPath () + "' does not exist");
      try
      {
        final SchematronStreamabilityReport aReport = SchematronStreamabilityAnalyzer.analyze (new FileSystemResource (aFile));
        aLog.info ("Streamability of Schematron file '" + aFile.getPath () + "': " + aReport.getSummaryText ());
        for (final String sFinding : aReport.getAllFindingTexts ())
          aLog.info ("  " + sFinding);

        if (eMaximumClass != null && aReport.getStreamabilityClass ().isWorseThan (eMaximumClass))
        {
          aLog.error ("The Schematron file '" +
                      aFile.getPath () +
                      "' is " +
                      aReport.getStreamabilityClass ().getID () +
                      ", but at most " +
                      eMaximumClass.getID () +
                      " is allowed");
          nFailed++;
        }
      }
      catch (final SchematronException ex)
      {
        aLog.error ("Error analysing the streamability of Schematron file '" + aFile.getPath () + "'", ex);
        bTechnicalError = true;
      }
    }
    if (bTechnicalError)
      return Integer.valueOf (SchematronCli.EXIT_ERROR);
    return Integer.valueOf (nFailed > 0 ? SchematronCli.EXIT_FAILURE : SchematronCli.EXIT_OK);
  }
}
