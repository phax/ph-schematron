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

import java.util.Map;
import java.util.function.Predicate;

import org.jspecify.annotations.NonNull;

import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.enginefactory.SchematronEngineFactory;
import com.helger.schematron.enginefactory.SchematronEngineSettings;
import com.helger.schematron.saxon.SaxonXsltProcessor;

import picocli.CommandLine.Model.CommandSpec;
import picocli.CommandLine.Option;
import picocli.CommandLine.ParameterException;

/**
 * The engine options shared by the commands <code>validate</code> and <code>convert</code>.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
final class SchematronEngineOptions
{
  /** The ID or alias of the engine. Resolved with {@link ESchematronEngine#getFromIDOrNull(String)}. */
  @Option (names = { "-e", "--engine" },
           paramLabel = "ID",
           defaultValue = "iso-schematron",
           description = "The Schematron engine: pure-xpath, pure-xslt, iso-schematron, schxslt, schxslt2 or xslt (pre-built XSLT). Default: ${DEFAULT-VALUE}.")
  String m_sEngine;

  /** The ID of the XSLT processor. <code>null</code> for Saxon. */
  @Option (names = { "-x", "--xslt-processor" },
           paramLabel = "ID",
           description = "The XSLT processor of the engines iso-schematron, schxslt, schxslt2 and xslt: saxon or phoxtrot. Default: saxon.")
  String m_sXsltProcessor;

  /** The phase to use. <code>null</code> for the default phase of the Schematron. */
  @Option (names = "--phase", paramLabel = "NAME", description = "The phase to use. Default: the defaultPhase of the Schematron.")
  String m_sPhase;

  /** The language code. <code>null</code> for English. */
  @Option (names = "--language",
           paramLabel = "CODE",
           description = "The language code of the engines iso-schematron, schxslt and schxslt2 (cs, de, en, fr, nl). Default: en.")
  String m_sLanguageCode;

  /** The custom XSLT parameters. May be <code>null</code>. */
  @Option (names = { "-P", "--param" },
           paramLabel = "NAME=VALUE",
           description = "A custom XSLT parameter of the engines iso-schematron, schxslt, schxslt2 and xslt. Repeatable.")
  Map <String, String> m_aParameters;

  /** <code>true</code> to force the caching of the SCH to XSLT conversion. */
  @Option (names = "--force-cache-result", description = "Force the caching of the SCH to XSLT conversion.")
  boolean m_bForceCacheResult;

  /** Constructor. Called by picocli. */
  SchematronEngineOptions ()
  {}

  /**
   * Create the engine settings from these options. Without <code>--xslt-processor</code> Saxon is
   * used, because both XSLT processors are on the class path.
   *
   * @param aSpec
   *        The command for usage errors. May not be <code>null</code>.
   * @param aAllowedEngines
   *        The engines the command supports. May not be <code>null</code>.
   * @return The engine settings. Never <code>null</code>.
   * @throws ParameterException
   *         If the engine or the XSLT processor is unknown or not allowed
   */
  @NonNull
  SchematronEngineSettings createSettings (@NonNull final CommandSpec aSpec,
                                           @NonNull final Predicate <ESchematronEngine> aAllowedEngines)
  {
    final ESchematronEngine eEngine = ESchematronEngine.getFromIDOrNull (m_sEngine);
    if (eEngine == null || !aAllowedEngines.test (eEngine))
      throw new ParameterException (aSpec.commandLine (),
                                    "The Schematron engine '" +
                                                        m_sEngine +
                                                        "' is not supported. Supported values are: " +
                                                        SchematronEngineFactory.getEngineIDsAsString (aAllowedEngines));

    final ISchematronXsltProcessor aXsltProcessor;
    try
    {
      // With both XSLT processors on the class path, Saxon is the default
      aXsltProcessor = SchematronEngineFactory.getXsltProcessor (eEngine,
                                                                 m_sXsltProcessor != null ? m_sXsltProcessor
                                                                                          : SaxonXsltProcessor.ID);
    }
    catch (final IllegalArgumentException | IllegalStateException ex)
    {
      throw new ParameterException (aSpec.commandLine (), ex.getMessage ());
    }

    return new SchematronEngineSettings ().setEngine (eEngine)
                                          .setXsltProcessor (aXsltProcessor)
                                          .setPhase (m_sPhase)
                                          .setLanguageCode (m_sLanguageCode)
                                          .setParameters (m_aParameters)
                                          .setForceCacheResult (m_bForceCacheResult);
  }
}
