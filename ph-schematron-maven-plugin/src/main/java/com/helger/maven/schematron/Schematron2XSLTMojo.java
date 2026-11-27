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
package com.helger.maven.schematron;

import java.io.File;
import java.util.Map;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.util.DirectoryScanner;
import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.misc.Since;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.annotation.style.VisibleForTesting;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.io.file.FilenameHelper;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.enginefactory.SchematronEngineFactory;
import com.helger.schematron.enginefactory.SchematronEngineSettings;
import com.helger.schematron.enginefactory.SchematronToolException;
import com.helger.schematron.enginefactory.SchematronXsltCreator;
import com.helger.schematron.sch.SchematronSCHConfig;

/**
 * Converts one or more Schematron schema files into XSLT scripts.
 *
 * @author PEPPOL.AT, BRZ, Philip Helger
 */
@NotThreadSafe
@Mojo (name = "convert", defaultPhase = LifecyclePhase.GENERATE_RESOURCES, threadSafe = true)
public final class Schematron2XSLTMojo extends AbstractMojo
{
  /**
   * BuildContext for m2e (it's a pass-though straight to the filesystem when invoked from the Maven
   * cli)
   */
  @Component
  private BuildContext buildContext;

  /**
   * The Maven Project.
   */
  @Parameter (defaultValue = "${project}", readonly = true)
  private MavenProject project;

  /**
   * The directory where the Schematron files reside.
   */
  @Parameter (name = "schematronDirectory", defaultValue = "${basedir}/src/main/schematron", required = true)
  private File m_aSchematronDirectory;

  /**
   * A pattern for the Schematron files. Can contain Ant-style wildcards and double wildcards. All
   * files that match the pattern will be converted. Files in the schematronDirectory and its
   * subdirectories will be considered.
   */
  @Parameter (name = "schematronPattern", defaultValue = "**/*.sch", required = true)
  private String m_sSchematronPattern;

  /**
   * The directory where the XSLT files will be saved.
   */
  @Parameter (name = "xsltDirectory", defaultValue = "${basedir}/src/main/xslt", required = true)
  private File m_aXsltDirectory;

  /**
   * The file extension of the created XSLT files.
   */
  @Parameter (name = "xsltExtension", defaultValue = ".xslt", required = true)
  private String m_sXsltExtension;

  /**
   * Overwrite existing Schematron files without notice? If this is set to <code>false</code> than
   * existing XSLT files are not overwritten.
   */
  @Parameter (name = "overwriteWithoutQuestion", defaultValue = "true")
  private boolean m_bOverwriteWithoutQuestion = true;

  /**
   * Define the phase to be used for XSLT creation. By default the <code>defaultPhase</code>
   * attribute of the Schematron file is used.
   */
  @Parameter (name = "phaseName")
  private String m_sPhaseName;

  /**
   * Define the language code for the XSLT creation. Default is English. Supported language codes
   * are: cs, de, en, fr, nl.
   */
  @Parameter (name = "languageCode")
  private String m_sLanguageCode;

  /**
   * Custom attributes to be used for the SCH to XSLT conversion.
   */
  @Parameter (name = "parameters")
  @Since ("5.0.2")
  private Map <String, String> m_aCustomParameters;

  /**
   * Force the results to be cached.
   */
  @Parameter (name = "forceCacheResult", defaultValue = "false")
  @Since ("5.2.1")
  private boolean m_bForceCacheResult = SchematronSCHConfig.DEFAULT_FORCE_CACHE_RESULT;

  /**
   * A constant header string that should be added to all XSLT files, e.g. as a version number etc.
   */
  @Parameter (name = "xsltHeader")
  @Since ("6.2.2")
  private String m_sXSLTHeader;

  /**
   * If the transformation of a Schematron to XSLT takes longer than 5 seconds, a message is
   * displayed every 5 seconds to inform you that the transformation is still in progress. This is
   * enabled by default.
   */
  @Parameter (name = "showProgress", defaultValue = "true")
  @Since ("6.2.8")
  private boolean m_bShowProgress = true;

  /**
   * If an error occurs, shall the conversion stop or shall the next file be tried? For backwards
   * compatibility reason, this is enabled by default.
   */
  @Parameter (name = "stopOnError", defaultValue = "true")
  @Since ("6.3.2")
  private boolean m_bStopOnError = true;

  /**
   * The Schematron engine to use for the transformation. See {@link ESchematronEngine} for the
   * possible values.
   */
  @Parameter (name = "schematronEngine", defaultValue = "iso-schematron")
  @Since ("9.1.1")
  private String m_sSchematronEngine = ESchematronEngine.ISO_SCHEMATRON.getID ();

  /**
   * The XSLT processor for the engines <code>pure-xslt</code>, <code>iso-schematron</code>,
   * <code>schxslt</code> and <code>schxslt2</code>: <code>saxon</code> (contained in the plugin) or <code>phoxtrot</code>
   * (requires <code>ph-schematron-phoxtrot</code> as plugin dependency). If not set, the only XSLT
   * processor on the class path is used; with both on the class path it must be set.
   */
  @Parameter (name = "xsltProcessor")
  @Since ("11.0.0")
  private String m_sXsltProcessor;

  public void setSchematronDirectory (@NonNull final File aDir)
  {
    m_aSchematronDirectory = aDir;
    if (!m_aSchematronDirectory.isAbsolute ())
      m_aSchematronDirectory = new File (project.getBasedir (), aDir.getPath ());
    getLog ().debug ("Searching Schematron files in the directory '" + m_aSchematronDirectory + "'");
  }

  public void setSchematronPattern (@NonNull final String sPattern)
  {
    m_sSchematronPattern = sPattern;
    getLog ().debug ("Setting Schematron pattern to '" + sPattern + "'");
  }

  public void setXsltDirectory (@NonNull final File aDir)
  {
    m_aXsltDirectory = aDir;
    if (!m_aXsltDirectory.isAbsolute ())
      m_aXsltDirectory = new File (project.getBasedir (), aDir.getPath ());
    getLog ().debug ("Writing XSLT files into directory '" + m_aXsltDirectory + "'");
  }

  public void setXsltExtension (@NonNull final String sExt)
  {
    m_sXsltExtension = sExt;
    getLog ().debug ("Setting XSLT file extension to '" + sExt + "'");
  }

  public void setOverwriteWithoutQuestion (final boolean bOverwrite)
  {
    m_bOverwriteWithoutQuestion = bOverwrite;
    if (m_bOverwriteWithoutQuestion)
      getLog ().debug ("Overwriting XSLT files without notice");
    else
      getLog ().debug ("Ignoring existing Schematron files");
  }

  public void setPhaseName (@Nullable final String sPhaseName)
  {
    m_sPhaseName = sPhaseName;
    if (m_sPhaseName == null)
      getLog ().debug ("Using default phase");
    else
      getLog ().debug ("Using the phase '" + m_sPhaseName + "'");
  }

  public void setLanguageCode (@Nullable final String sLanguageCode)
  {
    m_sLanguageCode = sLanguageCode;
    if (m_sLanguageCode == null)
      getLog ().debug ("Using default language code");
    else
      getLog ().debug ("Using the language code '" + m_sLanguageCode + "'");
  }

  public void setParameters (@Nullable final Map <String, String> aParameters)
  {
    m_aCustomParameters = aParameters;
    if (m_aCustomParameters == null || m_aCustomParameters.isEmpty ())
      getLog ().debug ("Using no custom parameters");
    else
      getLog ().debug ("Using custom parameters " + m_aCustomParameters.toString ());
  }

  @NonNull
  @ReturnsMutableCopy
  @VisibleForTesting
  ICommonsMap <String, String> getParameters ()
  {
    return new CommonsHashMap <> (m_aCustomParameters);
  }

  public void setForceCacheResult (final boolean bForceCacheResult)
  {
    m_bForceCacheResult = bForceCacheResult;
    if (m_bForceCacheResult)
      getLog ().debug ("Results are forcebly cached");
    else
      getLog ().debug ("Results not not forcebly cached");
  }

  public void setXsltHeader (final String s)
  {
    m_sXSLTHeader = s;
    if (StringHelper.isNotEmpty (m_sXSLTHeader))
      getLog ().debug ("Using the XSLT header '" + m_sXSLTHeader + "'");
    else
      getLog ().debug ("No XSLT header is configured");
  }

  public void setShowProgress (final boolean b)
  {
    m_bShowProgress = b;
    if (b)
      getLog ().debug ("Progress indicator is enabled");
    else
      getLog ().debug ("Progress indicator is disabled");
  }

  public void setStopOnError (final boolean b)
  {
    m_bStopOnError = b;
    if (b)
      getLog ().debug ("Stop on error is enabled");
    else
      getLog ().debug ("Stop on error is disabled");
  }

  public void setSchematronEngine (final String s)
  {
    m_sSchematronEngine = s;
    getLog ().debug ("Using the Schematron Engine '" + s + "'");
  }

  @Nullable
  @VisibleForTesting
  String getSchematronEngine ()
  {
    return m_sSchematronEngine;
  }

  public void setXsltProcessor (@Nullable final String s)
  {
    m_sXsltProcessor = s;
    getLog ().debug ("Using the XSLT processor '" + s + "'");
  }

  public void execute () throws MojoExecutionException, MojoFailureException
  {
    if (m_aSchematronDirectory == null)
      throw new MojoExecutionException ("No Schematron directory specified!");
    if (m_aSchematronDirectory.exists () && !m_aSchematronDirectory.isDirectory ())
      throw new MojoExecutionException ("The specified Schematron directory " +
                                        m_aSchematronDirectory +
                                        " is not a directory!");
    if (StringHelper.isEmpty (m_sSchematronPattern))
      throw new MojoExecutionException ("No Schematron pattern specified!");
    if (m_aXsltDirectory == null)
      throw new MojoExecutionException ("No XSLT directory specified!");
    if (m_aXsltDirectory.exists () && !m_aXsltDirectory.isDirectory ())
      throw new MojoExecutionException ("The specified XSLT directory " + m_aXsltDirectory + " is not a directory!");
    if (StringHelper.isEmpty (m_sXsltExtension) || !m_sXsltExtension.startsWith ("."))
      throw new MojoExecutionException ("The XSLT extension '" + m_sXsltExtension + "' is invalid!");

    if (!m_aXsltDirectory.exists () && !m_aXsltDirectory.mkdirs ())
      throw new MojoExecutionException ("Failed to create the XSLT directory " + m_aXsltDirectory);

    final ESchematronEngine eEngine = ESchematronEngine.getFromIDOrNull (m_sSchematronEngine);
    if (eEngine == null || !SchematronEngineFactory.isXsltCreating (eEngine))
      throw new MojoExecutionException ("The provided Schematron engine '" +
                                        m_sSchematronEngine +
                                        "' is not supported. Supported values are: " +
                                        SchematronEngineFactory.getEngineIDsAsString (SchematronEngineFactory::isXsltCreating));

    // The XSLT processor of the XSLT based engines
    final ISchematronXsltProcessor aXsltProcessor;
    try
    {
      aXsltProcessor = SchematronEngineFactory.getXsltProcessor (eEngine, m_sXsltProcessor);
      if (aXsltProcessor != null)
        getLog ().debug ("Using the XSLT processor '" + aXsltProcessor.getID () + "'");
    }
    catch (final IllegalArgumentException | IllegalStateException ex)
    {
      throw new MojoExecutionException (ex.getMessage ());
    }

    // No custom URI resolver (overrides the default of the config builder)
    final SchematronEngineSettings aSettings = new SchematronEngineSettings ().setEngine (eEngine)
                                                                              .setXsltProcessor (aXsltProcessor)
                                                                              .setPhase (m_sPhaseName)
                                                                              .setLanguageCode (m_sLanguageCode)
                                                                              .setParameters (m_aCustomParameters)
                                                                              .setForceCacheResult (m_bForceCacheResult);
    final SchematronXsltCreator aCreator = new SchematronXsltCreator (aSettings,
                                                                      new MavenLogHandler (getLog ())).setXsltHeader (m_sXSLTHeader)
                                                                                                      .setShowProgress (m_bShowProgress);

    // for all Schematron files that match the pattern
    final DirectoryScanner aScanner = new DirectoryScanner ();
    aScanner.setBasedir (m_aSchematronDirectory);
    aScanner.setIncludes (new String [] { m_sSchematronPattern });
    aScanner.setCaseSensitive (true);
    aScanner.scan ();
    final String [] aFilenames = aScanner.getIncludedFiles ();
    if (aFilenames != null)
    {
      for (final String sFilename : aFilenames)
      {
        final File aFile = new File (m_aSchematronDirectory, sFilename);

        // 1. build XSLT file name (outputdir + localpath with new extension)
        final File aXSLTFile = new File (m_aXsltDirectory,
                                         FilenameHelper.getWithoutExtension (sFilename) + m_sXsltExtension);

        getLog ().info ("Converting Schematron file '" +
                        aFile.getPath () +
                        "' to XSLT file '" +
                        aXSLTFile.getPath () +
                        "'");

        // 2. Check if the XSLT file already exists
        if (aXSLTFile.exists () && !m_bOverwriteWithoutQuestion)
        {
          // Not overwriting the existing file
          getLog ().debug ("Skipping XSLT file '" + aXSLTFile.getPath () + "' because it already exists!");
          continue;
        }

        // 3. The main SCH to XSLT conversion
        try
        {
          buildContext.removeMessages (aFile);
          // Custom error listener to log to the Mojo logger
          aCreator.convertFile (aFile, aXSLTFile, new PluginErrorListener (buildContext, aFile));
          buildContext.refresh (aXSLTFile.getParentFile ());
        }
        catch (final SchematronToolException ex)
        {
          new MavenLogHandler (getLog ()).error (ex.getMessage (), ex.getCause ());
          if (m_bStopOnError)
          {
            if (ex.getCause () != null)
              throw new MojoExecutionException (ex.getMessage (), ex.getCause ());
            throw new MojoFailureException (ex.getMessage ());
          }
          getLog ().warn ("Received an error, but continuing anyway");
        }
      }
    }
  }
}
