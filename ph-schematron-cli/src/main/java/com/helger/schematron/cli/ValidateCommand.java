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

import javax.xml.catalog.CatalogResolver;

import com.helger.base.log.ILogHandler;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.IError;
import com.helger.schematron.cli.CliFileCollector.CliInputFile;
import com.helger.schematron.enginefactory.SchematronCatalogHelper;
import com.helger.schematron.enginefactory.SchematronEngineFactory;
import com.helger.schematron.enginefactory.SchematronEngineResource;
import com.helger.schematron.enginefactory.SchematronEngineSettings;
import com.helger.schematron.enginefactory.SchematronFileValidationResult;
import com.helger.schematron.enginefactory.SchematronToolLogHelper;
import com.helger.schematron.enginefactory.SchematronValidationRunner;

import picocli.CommandLine.Command;
import picocli.CommandLine.Mixin;
import picocli.CommandLine.Model.CommandSpec;
import picocli.CommandLine.Option;
import picocli.CommandLine.ParameterException;
import picocli.CommandLine.Parameters;
import picocli.CommandLine.Spec;

/**
 * The command <code>validate</code>: validate XML files against a Schematron, like the Maven goal
 * <code>validate</code> and the Ant task <code>schematron</code>.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Command (name = "validate",
          mixinStandardHelpOptions = true,
          description = "Validate XML files against a Schematron. Only failed asserts and successful reports with level error or fatal error decide whether a file is valid.")
public final class ValidateCommand implements Callable <Integer>
{
  public static final String DEFAULT_INCLUDE = "**/*.xml";

  @Spec
  CommandSpec m_aSpec;

  @Mixin
  CliLogOptions m_aLogOptions;

  @Mixin
  SchematronEngineOptions m_aEngineOptions;

  @Option (names = { "-s", "--schematron" },
           required = true,
           paramLabel = "FILE",
           description = "The Schematron file (an XSLT file for the engine xslt).")
  File m_aSchematronFile;

  @Option (names = "--lenient", description = "Accept deprecated Schematron namespace URIs (engine pure-xpath only).")
  boolean m_bLenient;

  @Option (names = "--catalog",
           paramLabel = "FILE",
           description = "An OASIS XML catalog file to resolve entities and URIs. External DTDs and entities of the XML files are only loaded via the catalogs. Repeatable.")
  List <File> m_aCatalogFiles;

  @Option (names = "--include",
           paramLabel = "GLOB",
           description = "The files to validate in a directory argument. Repeatable. Default: " + DEFAULT_INCLUDE)
  List <String> m_aIncludes;

  @Option (names = "--exclude", paramLabel = "GLOB", description = "The files to skip in a directory argument. Repeatable.")
  List <String> m_aExcludes;

  @Option (names = "--expect-invalid",
           paramLabel = "PATH",
           description = "An XML file or directory that must contain at least one Schematron error. Repeatable.")
  List <File> m_aExpectInvalid;

  @Option (names = "--svrl-dir",
           paramLabel = "DIR",
           description = "Write the SVRL of each XML file into this directory (relative path plus .svrl).")
  File m_aSvrlDirectory;

  @Option (names = "--ignore-warnings", description = "Neither log nor count warnings and information.")
  boolean m_bIgnoreWarnings;

  @Option (names = "--error-role",
           paramLabel = "ROLE",
           description = "A value of role, flag or severity that is treated as error. Repeatable.")
  List <String> m_aErrorRoles;

  @Option (names = "--fail-on-error", description = "Fail a file with a Schematron error, also with --expect-invalid.")
  boolean m_bFailOnValidationError;

  @Option (names = "--fail-on-warning", description = "Fail a file with a Schematron warning.")
  boolean m_bFailOnValidationWarn;

  @Option (names = "--fail-on-info", description = "Fail a file with a Schematron information.")
  boolean m_bFailOnValidationInfo;

  @Option (names = "--fail-fast", description = "Stop at the first file that fails.")
  boolean m_bFailFast;

  @Parameters (paramLabel = "PATH", arity = "0..*", description = "The XML files or directories that must be valid.")
  List <File> m_aInputs;

  public ValidateCommand ()
  {}

  public Integer call ()
  {
    final ILogHandler aLog = m_aLogOptions.createLogHandler (m_aSpec, false);
    if (!m_aSchematronFile.isFile ())
      throw new ParameterException (m_aSpec.commandLine (),
                                    "The Schematron file '" + m_aSchematronFile.getPath () + "' does not exist");

    final SchematronEngineSettings aSettings = m_aEngineOptions.createSettings (m_aSpec, x -> true)
                                                               .setLenient (m_bLenient);
    final CatalogResolver aCatalogResolver;
    final ICommonsList <CliInputFile> aValidFiles;
    final ICommonsList <CliInputFile> aInvalidFiles;
    try
    {
      aCatalogResolver = SchematronCatalogHelper.createCatalogResolver (m_aCatalogFiles);
      final List <String> aIncludes = m_aIncludes != null ? m_aIncludes : new CommonsArrayList <> (DEFAULT_INCLUDE);
      aValidFiles = CliFileCollector.collect (m_aInputs, aIncludes, m_aExcludes);
      aInvalidFiles = CliFileCollector.collect (m_aExpectInvalid, aIncludes, m_aExcludes);
    }
    catch (final IllegalArgumentException ex)
    {
      throw new ParameterException (m_aSpec.commandLine (), ex.getMessage ());
    }
    if (aValidFiles.isEmpty () && aInvalidFiles.isEmpty ())
      throw new ParameterException (m_aSpec.commandLine (), "No XML file to validate was found");
    aSettings.setURIResolver (aCatalogResolver).setEntityResolver (aCatalogResolver);

    // Read and check the Schematron
    final SchematronEngineResource aSch = SchematronEngineFactory.createResource (m_aSchematronFile, aSettings);
    for (final IError aError : aSch.errors ())
      SchematronToolLogHelper.log (aLog, aError.getErrorLevel (), "Schematron: " + aError.getAsString (Locale.US));
    if (aSch.hasAnyError ())
    {
      aLog.error ("The Schematron file '" + m_aSchematronFile.getPath () + "' contains errors");
      return Integer.valueOf (SchematronCli.EXIT_ERROR);
    }

    final SchematronValidationRunner aRunner = new SchematronValidationRunner (aSch.resource (), aLog).setIgnoreWarnings (m_bIgnoreWarnings)
                                                                                                    .setErrorRoles (m_aErrorRoles)
                                                                                                    .setFailOnValidationError (m_bFailOnValidationError)
                                                                                                    .setFailOnValidationWarn (m_bFailOnValidationWarn)
                                                                                                    .setFailOnValidationInfo (m_bFailOnValidationInfo)
                                                                                                    .setEntityResolver (aCatalogResolver);

    final ICommonsList <CliInputFile> aAllFiles = new CommonsArrayList <> (aValidFiles);
    aAllFiles.addAll (aInvalidFiles);
    int nValidated = 0;
    int nFailed = 0;
    boolean bTechnicalError = false;
    for (int nIndex = 0; nIndex < aAllFiles.size (); ++nIndex)
    {
      final CliInputFile aInput = aAllFiles.get (nIndex);
      // The files that must be valid come first
      final boolean bExpectSuccess = nIndex < aValidFiles.size ();
      final SchematronFileValidationResult aResult = aRunner.validateFile (aInput.file (),
                                                                           SchematronValidationRunner.getSVRLFile (m_aSvrlDirectory,
                                                                                                                   aInput.relativePath ()),
                                                                           bExpectSuccess);
      nValidated++;
      if (aResult.exception () != null)
        bTechnicalError = true;
      if (!aResult.isSuccess ())
      {
        nFailed++;
        if (m_bFailFast)
          break;
      }
    }

    aLog.info (nValidated + " XML file" + (nValidated == 1 ? "" : "s") + " validated, " + nFailed + " failed");
    if (bTechnicalError)
      return Integer.valueOf (SchematronCli.EXIT_ERROR);
    return Integer.valueOf (nFailed > 0 ? SchematronCli.EXIT_FAILURE : SchematronCli.EXIT_OK);
  }
}
