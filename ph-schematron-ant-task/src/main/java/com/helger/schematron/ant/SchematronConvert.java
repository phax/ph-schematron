/*
 * Copyright (C) 2017-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.ant;

import java.io.File;
import java.util.Locale;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diagnostics.error.IError;
import com.helger.io.file.FilenameHelper;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.enginefactory.SchematronEngineFactory;
import com.helger.schematron.enginefactory.SchematronEngineSettings;
import com.helger.schematron.enginefactory.SchematronToolException;
import com.helger.schematron.enginefactory.SchematronToolLogHelper;
import com.helger.schematron.enginefactory.SchematronXsltCreator;
import com.helger.schematron.sch.SchematronSCHConfig;
import com.helger.typeconvert.collection.IStringMap;
import com.helger.typeconvert.collection.StringMap;
import com.helger.xml.transform.CollectingTransformErrorListener;

/**
 * ANT task to convert Schematron files to XSLT files, like the Maven goal <code>convert</code>.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
public class SchematronConvert extends AbstractSchematronTask
{
  public static final String DEFAULT_SCHEMATRON_PATTERN = "**/*.sch";
  public static final String DEFAULT_XSLT_EXTENSION = ".xslt";

  /**
   * The directory where the Schematron files reside.
   */
  private File m_aSchematronDirectory;

  /**
   * A pattern for the Schematron files. Can contain Ant-style wildcards and double wildcards.
   */
  private String m_sSchematronPattern = DEFAULT_SCHEMATRON_PATTERN;

  /**
   * The directory where the XSLT files will be saved.
   */
  private File m_aXsltDirectory;

  /**
   * The file extension of the created XSLT files.
   */
  private String m_sXsltExtension = DEFAULT_XSLT_EXTENSION;

  /**
   * <code>false</code> to leave existing XSLT files untouched.
   */
  private boolean m_bOverwriteWithoutQuestion = true;

  /**
   * The phase to use. By default the <code>defaultPhase</code> attribute of the Schematron file is
   * used.
   */
  private String m_sPhaseName;

  /**
   * The language code to use. Default is English. Supported language codes are: cs, de, en, fr,
   * nl.
   */
  private String m_sLanguageCode;

  /**
   * Custom parameters for the SCH to XSLT conversion.
   */
  private final ICommonsList <Schematron.Parameter> m_aParameters = new CommonsArrayList <> ();

  /**
   * <code>true</code> if the result of the SCH to XSLT conversion should be cached.
   */
  private boolean m_bForceCacheResult = SchematronSCHConfig.DEFAULT_FORCE_CACHE_RESULT;

  /**
   * A constant header string that is added to all XSLT files as an XML comment.
   */
  private String m_sXsltHeader;

  /**
   * <code>true</code> to log a message every 5 seconds while a conversion is running.
   */
  private boolean m_bShowProgress = true;

  /**
   * <code>true</code> to stop at the first Schematron file that cannot be converted.
   */
  private boolean m_bStopOnError = true;

  /**
   * The engine to use for the conversion.
   */
  private String m_sSchematronEngine = ESchematronEngine.ISO_SCHEMATRON.getID ();

  /**
   * The XSLT processor of the engines <code>pure-xslt</code>, <code>iso-schematron</code>,
   * <code>schxslt</code> and <code>schxslt2</code>.
   */
  private String m_sXsltProcessor;

  public SchematronConvert ()
  {}

  public void setSchematronDirectory (@NonNull final File aDir)
  {
    m_aSchematronDirectory = aDir;
    if (!m_aSchematronDirectory.isAbsolute ())
      m_aSchematronDirectory = new File (getProject ().getBaseDir (), aDir.getPath ());
    _debug ("Searching Schematron files in the directory '" + m_aSchematronDirectory + "'");
  }

  public void setSchematronPattern (@Nullable final String sPattern)
  {
    m_sSchematronPattern = sPattern;
    _debug ("Setting Schematron pattern to '" + sPattern + "'");
  }

  public void setXsltDirectory (@NonNull final File aDir)
  {
    m_aXsltDirectory = aDir;
    if (!m_aXsltDirectory.isAbsolute ())
      m_aXsltDirectory = new File (getProject ().getBaseDir (), aDir.getPath ());
    _debug ("Writing XSLT files into directory '" + m_aXsltDirectory + "'");
  }

  public void setXsltExtension (@Nullable final String sExt)
  {
    m_sXsltExtension = sExt;
    _debug ("Setting XSLT file extension to '" + sExt + "'");
  }

  public void setOverwriteWithoutQuestion (final boolean bOverwrite)
  {
    m_bOverwriteWithoutQuestion = bOverwrite;
    _debug (bOverwrite ? "Overwriting XSLT files without notice" : "Ignoring existing XSLT files");
  }

  public void setPhaseName (@Nullable final String sPhaseName)
  {
    m_sPhaseName = sPhaseName;
    _debug (sPhaseName == null ? "Using default phase" : "Using the phase '" + sPhaseName + "'");
  }

  public void setLanguageCode (@Nullable final String sLanguageCode)
  {
    m_sLanguageCode = sLanguageCode;
    _debug (sLanguageCode == null ? "Using default language code"
                                  : "Using the language code '" + sLanguageCode + "'");
  }

  public Schematron.@NonNull Parameter createParameter ()
  {
    final Schematron.Parameter aParameter = new Schematron.Parameter ();
    m_aParameters.add (aParameter);
    return aParameter;
  }

  public void setForceCacheResult (final boolean bForceCacheResult)
  {
    m_bForceCacheResult = bForceCacheResult;
    _debug (bForceCacheResult ? "Results are forcebly cached" : "Results not not forcebly cached");
  }

  public void setXsltHeader (@Nullable final String sXsltHeader)
  {
    m_sXsltHeader = sXsltHeader;
    _debug (StringHelper.isNotEmpty (sXsltHeader) ? "Using the XSLT header '" + sXsltHeader + "'"
                                                  : "No XSLT header is configured");
  }

  public void setShowProgress (final boolean bShowProgress)
  {
    m_bShowProgress = bShowProgress;
    _debug (bShowProgress ? "Progress indicator is enabled" : "Progress indicator is disabled");
  }

  public void setStopOnError (final boolean bStopOnError)
  {
    m_bStopOnError = bStopOnError;
    _debug (bStopOnError ? "Stop on error is enabled" : "Stop on error is disabled");
  }

  public void setSchematronEngine (@Nullable final String sEngine)
  {
    m_sSchematronEngine = sEngine;
    _debug ("Using the Schematron engine '" + sEngine + "'");
  }

  public void setXsltProcessor (@Nullable final String sXsltProcessor)
  {
    m_sXsltProcessor = sXsltProcessor;
    _debug ("Using the XSLT processor '" + sXsltProcessor + "'");
  }

  @Nullable
  private SchematronXsltCreator _createCreator ()
  {
    final ESchematronEngine eEngine = ESchematronEngine.getFromIDOrNull (m_sSchematronEngine);
    if (eEngine == null || !SchematronEngineFactory.isXsltCreating (eEngine))
    {
      _errorOrFail ("The provided Schematron engine '" +
                    m_sSchematronEngine +
                    "' is not supported. Supported values are: " +
                    SchematronEngineFactory.getEngineIDsAsString (SchematronEngineFactory::isXsltCreating));
      return null;
    }

    final ISchematronXsltProcessor aXsltProcessor;
    try
    {
      aXsltProcessor = SchematronEngineFactory.getXsltProcessor (eEngine, m_sXsltProcessor);
      if (aXsltProcessor != null)
        _debug ("Using the XSLT processor '" + aXsltProcessor.getID () + "'");
    }
    catch (final IllegalArgumentException | IllegalStateException ex)
    {
      _errorOrFail (ex.getMessage ());
      return null;
    }

    final IStringMap aParams = new StringMap ();
    m_aParameters.forEach (x -> x.addToMap (aParams));
    if (aParams.isNotEmpty ())
      _info ("Using the following custom parameters: " + aParams);

    final SchematronEngineSettings aSettings = new SchematronEngineSettings ().setEngine (eEngine)
                                                                              .setXsltProcessor (aXsltProcessor)
                                                                              .setPhase (m_sPhaseName)
                                                                              .setLanguageCode (m_sLanguageCode)
                                                                              .setParameters (aParams)
                                                                              .setForceCacheResult (m_bForceCacheResult);
    return new SchematronXsltCreator (aSettings, new AntLogHandler (this)).setXsltHeader (m_sXsltHeader)
                                                                         .setShowProgress (m_bShowProgress);
  }

  @Override
  public void execute () throws BuildException
  {
    boolean bCanRun = false;
    if (m_aSchematronDirectory == null)
      _errorOrFail ("No Schematron directory specified!");
    else
      if (!m_aSchematronDirectory.isDirectory ())
        _errorOrFail ("The specified Schematron directory " + m_aSchematronDirectory + " is not a directory!");
      else
        if (StringHelper.isEmpty (m_sSchematronPattern))
          _errorOrFail ("No Schematron pattern specified!");
        else
          if (m_aXsltDirectory == null)
            _errorOrFail ("No XSLT directory specified!");
          else
            if (m_aXsltDirectory.exists () && !m_aXsltDirectory.isDirectory ())
              _errorOrFail ("The specified XSLT directory " + m_aXsltDirectory + " is not a directory!");
            else
              if (StringHelper.isEmpty (m_sXsltExtension) || !m_sXsltExtension.startsWith ("."))
                _errorOrFail ("The XSLT extension '" + m_sXsltExtension + "' is invalid!");
              else
                bCanRun = true;
    if (!bCanRun)
      return;

    final SchematronXsltCreator aCreator = _createCreator ();
    if (aCreator == null)
      return;

    // for all Schematron files that match the pattern
    final DirectoryScanner aScanner = new DirectoryScanner ();
    aScanner.setBasedir (m_aSchematronDirectory);
    aScanner.setIncludes (new String [] { m_sSchematronPattern });
    aScanner.setCaseSensitive (true);
    aScanner.scan ();
    final String [] aFilenames = aScanner.getIncludedFiles ();
    if (aFilenames != null)
      for (final String sFilename : aFilenames)
      {
        final File aFile = new File (m_aSchematronDirectory, sFilename);
        final File aXsltFile = new File (m_aXsltDirectory,
                                         FilenameHelper.getWithoutExtension (sFilename) + m_sXsltExtension);

        if (aXsltFile.exists () && !m_bOverwriteWithoutQuestion)
        {
          _debug ("Skipping XSLT file '" + aXsltFile.getPath () + "' because it already exists!");
          continue;
        }

        _info ("Converting Schematron file '" + aFile.getPath () + "' to XSLT file '" + aXsltFile.getPath () + "'");
        final CollectingTransformErrorListener aErrorListener = new CollectingTransformErrorListener ();
        try
        {
          aCreator.convertFile (aFile, aXsltFile, aErrorListener);
        }
        catch (final SchematronToolException ex)
        {
          if (m_bStopOnError)
          {
            _errorOrFail (ex.getMessage (), ex.getCause ());
            return;
          }
          _error (ex.getMessage (), ex.getCause ());
          _warn ("Received an error, but continuing anyway");
        }
        finally
        {
          for (final IError aError : aErrorListener.getErrorList ())
            SchematronToolLogHelper.log (new AntLogHandler (this), aError.getErrorLevel (), aError.getAsString (Locale.US));
        }
      }
  }
}
