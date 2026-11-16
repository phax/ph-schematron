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

import com.helger.base.log.ILogHandler;
import com.helger.diagnostics.error.IError;
import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.diagnostics.error.list.IErrorList;
import com.helger.schematron.enginefactory.SchematronToolLogHelper;
import com.helger.schematron.validator.SchematronValidator;
import com.helger.xml.transform.TransformSourceFactory;

import picocli.CommandLine.Command;
import picocli.CommandLine.Mixin;
import picocli.CommandLine.Model.CommandSpec;
import picocli.CommandLine.ParameterException;
import picocli.CommandLine.Parameters;
import picocli.CommandLine.Spec;

/**
 * The command <code>check</code>: validate Schematron files against the RELAX NG schema of ISO
 * Schematron.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Command (name = "check",
          mixinStandardHelpOptions = true,
          description = "Validate Schematron files against the RELAX NG Compact schema of ISO Schematron (ISO/IEC 19757-3:2006).")
public final class CheckCommand implements Callable <Integer>
{
  @Spec
  CommandSpec m_aSpec;

  @Mixin
  CliLogOptions m_aLogOptions;

  @Parameters (paramLabel = "FILE", arity = "1..*", description = "The Schematron files to check.")
  List <File> m_aSchematronFiles;

  public CheckCommand ()
  {}

  public Integer call ()
  {
    final ILogHandler aLog = m_aLogOptions.createLogHandler (m_aSpec, false);
    int nFailed = 0;
    boolean bTechnicalError = false;
    for (final File aFile : m_aSchematronFiles)
    {
      if (!aFile.isFile ())
        throw new ParameterException (m_aSpec.commandLine (), "The Schematron file '" + aFile.getPath () + "' does not exist");

      final IErrorList aErrors = SchematronValidator.validateSchematron (TransformSourceFactory.create (aFile));
      if (aErrors == null)
      {
        aLog.error ("The Schematron file '" + aFile.getPath () + "' could not be read");
        bTechnicalError = true;
        continue;
      }

      for (final IError aError : aErrors)
        SchematronToolLogHelper.log (aLog, aError.getErrorLevel (), aError.getAsString (Locale.US));
      if (aErrors.containsAny (x -> x.getErrorLevel ().isGE (EErrorLevel.ERROR)))
      {
        aLog.error ("The Schematron file '" + aFile.getPath () + "' is not valid");
        nFailed++;
      }
      else
        aLog.info ("The Schematron file '" + aFile.getPath () + "' is valid");
    }
    if (bTechnicalError)
      return Integer.valueOf (SchematronCli.EXIT_ERROR);
    return Integer.valueOf (nFailed > 0 ? SchematronCli.EXIT_FAILURE : SchematronCli.EXIT_OK);
  }
}
