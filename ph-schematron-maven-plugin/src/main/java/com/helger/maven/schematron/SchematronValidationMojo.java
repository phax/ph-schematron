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
import java.util.Arrays;
import java.util.Map;

import javax.xml.catalog.CatalogResolver;

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
import com.helger.base.array.ArrayHelper;
import com.helger.base.string.StringImplode;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.diagnostics.error.IError;
import com.helger.schematron.CSchematron;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.enginefactory.SchematronCatalogHelper;
import com.helger.schematron.enginefactory.SchematronEngineFactory;
import com.helger.schematron.enginefactory.SchematronEngineResource;
import com.helger.schematron.enginefactory.SchematronEngineSettings;
import com.helger.schematron.enginefactory.SchematronFileValidationResult;
import com.helger.schematron.enginefactory.SchematronValidationRunner;
import com.helger.schematron.sch.SchematronSCHConfig;

/**
 * Applies Schematron validation onto an XML file
 *
 * @author Philip Helger
 */
@NotThreadSafe
@Mojo (name = "validate", defaultPhase = LifecyclePhase.PROCESS_RESOURCES, threadSafe = true)
public final class SchematronValidationMojo extends AbstractMojo
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
   * The Schematron file. This may also be an XSLT file if it is precompiled.
   */
  @Parameter (name = "schematronFile", required = true)
  private File m_aSchematronFile;

  /**
   * The processing engine to use. Recognised values (case-insensitive) and their pre-v10 aliases:
   * <ul>
   * <li><code>pure-xpath</code> (alias: <code>pure</code>) - pure-Java XPath-only engine
   * ({@code SchematronResourcePureXPath}). Reads the SCH directly; honours {@code phaseName}.</li>
   * <li><code>pure-xslt</code> (alias: <code>pure-saxon</code>) - pure-Java engine that generates
   * an XSLT 3.0 stylesheet in Java and runs it through Saxon s9api
   * ({@code SchematronResourcePureXslt}). Honours {@code phaseName}. {@code languageCode} and
   * {@code parameters} are ignored.</li>
   * <li><code>iso-schematron</code> (aliases: <code>schematron</code>, <code>sch</code>,
   * <code>iso</code>, <code>isoschematron</code>) - SCH file preprocessed to XSLT through the
   * canonical ISO Schematron stylesheet chain ({@code SchematronResourceSCH}). Honours
   * {@code phaseName}, {@code languageCode}, {@code parameters}.</li>
   * <li><code>schxslt</code> (aliases: <code>schxslt1</code>, <code>schxslt-xslt2</code>) - SchXslt
   * v1 (XSLT 2). Honours {@code phaseName}, {@code languageCode}, {@code parameters}.</li>
   * <li><code>schxslt2</code> - SchXslt v2 (XSLT 3). Honours {@code phaseName},
   * {@code languageCode}, {@code parameters}.</li>
   * <li><code>xslt</code> - apply a pre-built XSLT file directly ({@code SchematronResourceXSLT}).
   * {@code phaseName} and {@code languageCode} are ignored. Default is {@code iso-schematron}.</li>
   * </ul>
   */
  @Parameter (name = "schematronProcessingEngine", required = true)
  private String m_sSchematronProcessingEngine = ESchematronEngine.ISO_SCHEMATRON.getID ();

  /**
   * The directory where the XML files reside that are expected to match the Schematron rules.
   */
  @Parameter (name = "xmlDirectory", required = true)
  private File m_aXmlDirectory;

  /**
   * A pattern for the XML files that should be included. Can contain Ant-style wildcards and double
   * wildcards. All files that match the pattern will be converted. Files in the xmlDirectory and
   * its subdirectories will be considered.
   */
  @Parameter (name = "xmlIncludes", defaultValue = "**/*.xml", required = true)
  private String [] m_aXmlIncludes;

  /**
   * A pattern for the XML files that should be excluded. Can contain Ant-style wildcards and double
   * wildcards. All files that match the pattern will NOT be converted. Only files in the
   * xmlDirectory and its subdirectories will be considered.
   */
  @Parameter (name = "xmlExcludes")
  private String [] m_aXmlExcludes;

  /**
   * The SVRL path to write to (for positive tests). The filenames are based on the source XML
   * filenames. If this parameter is not set, the SVRL files are <b>not</b> written.
   */
  @Parameter (name = "svrlDirectory")
  private File m_aSvrlDirectory;

  /**
   * The directory where the erroneous XML files reside that are expected to NOT match the
   * Schematron rules.
   */
  @Parameter (name = "xmlErrorDirectory")
  private File m_aXmlErrorDirectory;

  /**
   * A pattern for the erroneous XML files that should be included. Can contain Ant-style wildcards
   * and double wildcards. All files that match the pattern will be converted. Files in the
   * xmlDirectory and its subdirectories will be considered.
   */
  @Parameter (name = "xmlErrorIncludes", defaultValue = "**/*.xml")
  private String [] m_aXmlErrorIncludes;

  /**
   * A pattern for the erroneous XML files that should be excluded. Can contain Ant-style wildcards
   * and double wildcards. All files that match the pattern will NOT be converted. Only files in the
   * xmlDirectory and its subdirectories will be considered.
   */
  @Parameter (name = "xmlErrorExcludes")
  private String [] m_aXmlErrorExcludes;

  /**
   * The SVRL path to write to (for negative tests). The filenames are based on the source XML
   * filenames. If this parameter is not set, the SVRL files are <b>not</b> written.
   */
  @Parameter (name = "svrlErrorDirectory")
  private File m_aSvrlErrorDirectory;

  /**
   * Define the phase to be used for Schematron validation. By default the <code>defaultPhase</code>
   * attribute of the Schematron file is used. Honoured by the {@code pure-xpath},
   * {@code pure-xslt}, {@code iso-schematron}, {@code schxslt} and {@code schxslt2} engines;
   * ignored by {@code xslt} (the phase is baked into the pre-built stylesheet at build time).
   */
  @Parameter (name = "phaseName")
  private String m_sPhaseName;

  /**
   * Define the language code to be used for Schematron diagnostic messages. Default is English.
   * Supported codes: cs, de, en, fr, nl. Honoured by the {@code iso-schematron}, {@code schxslt}
   * and {@code schxslt2} engines (where it is forwarded to the ISO / SchXslt stylesheet chain).
   * Ignored by {@code pure-xpath}, {@code pure-xslt} and {@code xslt}.
   */
  @Parameter (name = "languageCode")
  private String m_sLanguageCode;

  /**
   * Custom parameters forwarded to the SCH-to-XSLT preprocessing stage (used as {@code <xsl:param>}
   * bindings on the generated stylesheet). Honoured by {@code iso-schematron}, {@code schxslt},
   * {@code schxslt2} and {@code xslt}. Ignored by {@code pure-xpath} and {@code pure-xslt}.
   */
  @Parameter (name = "parameters")
  @Since ("5.0.2")
  private Map <String, String> m_aCustomParameters;

  /**
   * When validating multiple files, this flag indicates, whether validation should fail at the
   * first file with an error (this is the default) or at the end only.
   */
  @Parameter (name = "failFast", defaultValue = "true", required = true)
  @Since ("5.0.5")
  private boolean m_bFailFast = true;

  /**
   * Force the results to be cached. This only applies when Schematron to XSLT conversion is
   * performed.
   */
  @Parameter (name = "forceCacheResult", defaultValue = "false")
  @Since ("5.2.1")
  private boolean m_bForceCacheResult = SchematronSCHConfig.DEFAULT_FORCE_CACHE_RESULT;

  /**
   * Define if old namespace URIs should be supported or not. By default this is disabled. This
   * parameter takes only effect when using schematronProcessingEngine "pure".
   */
  @Parameter (name = "lenient", defaultValue = "false")
  @Since ("5.4.1")
  private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;

  /**
   * <code>true</code> to ignore all failed asserts and successful reports below level error: they
   * are neither logged nor counted. Only errors decide whether a file is valid, also without this
   * setting.
   */
  @Parameter (name = "ignoreWarnings", defaultValue = "false")
  @Since ("7.1.3")
  private boolean m_bIgnoreWarnings = false;

  /**
   * The XSLT processor for the engines <code>iso-schematron</code>, <code>schxslt</code>,
   * <code>schxslt2</code> and <code>xslt</code>: <code>saxon</code> (contained in the plugin) or
   * <code>phoxtrot</code> (requires <code>ph-schematron-phoxtrot</code> as plugin dependency). If not
   * set, the only XSLT processor on the class path is used; with both on the class path it must be
   * set.
   */
  @Parameter (name = "xsltProcessor")
  @Since ("11.0.0")
  private String m_sXsltProcessor;

  /**
   * <code>true</code> to fail a file that contains at least one Schematron error, also if the file
   * is expected to be invalid.
   */
  @Parameter (name = "failOnValidationError", defaultValue = "false")
  @Since ("11.0.0")
  private boolean m_bFailOnValidationError = false;

  /**
   * <code>true</code> to fail a file that contains at least one Schematron warning.
   */
  @Parameter (name = "failOnValidationWarn", defaultValue = "false")
  @Since ("11.0.0")
  private boolean m_bFailOnValidationWarn = false;

  /**
   * <code>true</code> to fail a file that contains at least one Schematron information.
   */
  @Parameter (name = "failOnValidationInfo", defaultValue = "false")
  @Since ("11.0.0")
  private boolean m_bFailOnValidationInfo = false;

  /**
   * Values of the <code>role</code>, <code>flag</code> or <code>severity</code> attributes that are
   * treated as error (case insensitive).
   */
  @Parameter (name = "errorRoles")
  @Since ("11.0.0")
  private String [] m_aErrorRoles;

  /**
   * OASIS XML catalog files used as entity and URI resolver for the Schematron and the validated
   * XML files. With a catalog, external DTDs and entities of the XML files are loaded only via the
   * catalog; one that is not in the catalog makes the file fail.
   */
  @Parameter (name = "catalogFiles")
  @Since ("11.0.0")
  private File [] m_aCatalogFiles;

  public void setSchematronFile (@NonNull final File aFile)
  {
    m_aSchematronFile = aFile;
    if (!m_aSchematronFile.isAbsolute ())
      m_aSchematronFile = new File (project.getBasedir (), aFile.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Using Schematron file '" + m_aSchematronFile + "'");
  }

  public void setSchematronProcessingEngine (@Nullable final String sEngine)
  {
    final ESchematronEngine eEngine = ESchematronEngine.getFromIDOrNull (sEngine);
    m_sSchematronProcessingEngine = eEngine == null ? null : eEngine.getID ();
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Schematron processing engine set to '" + eEngine + "'");
  }

  public void setXsltProcessor (@Nullable final String sXsltProcessor)
  {
    m_sXsltProcessor = sXsltProcessor;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("XSLT processor set to '" + sXsltProcessor + "'");
  }

  public void setXmlDirectory (@NonNull final File aDir)
  {
    m_aXmlDirectory = aDir;
    if (!m_aXmlDirectory.isAbsolute ())
      m_aXmlDirectory = new File (project.getBasedir (), aDir.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Searching XML files in the directory '" + m_aXmlDirectory + "'");
  }

  public void setXmlIncludes (@Nullable final String [] aPattern)
  {
    m_aXmlIncludes = aPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting XML file includes to " +
                       StringImplode.imploder ().source (aPattern, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setXmlExcludes (@Nullable final String [] aPattern)
  {
    m_aXmlExcludes = aPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting XML file excludes to " +
                       StringImplode.imploder ().source (aPattern, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setSvrlDirectory (@NonNull final File aDir)
  {
    m_aSvrlDirectory = aDir;
    if (!m_aSvrlDirectory.isAbsolute ())
      m_aSvrlDirectory = new File (project.getBasedir (), aDir.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Writing SVRL files to directory '" + m_aSvrlDirectory + "'");
  }

  public void setXmlErrorDirectory (@NonNull final File aDir)
  {
    m_aXmlErrorDirectory = aDir;
    if (!m_aXmlErrorDirectory.isAbsolute ())
      m_aXmlErrorDirectory = new File (project.getBasedir (), aDir.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Searching erroneous XML files in the directory '" + m_aXmlDirectory + "'");
  }

  public void setXmlErrorIncludes (@Nullable final String [] aPattern)
  {
    m_aXmlErrorIncludes = aPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting erroneous XML file includes to " +
                       StringImplode.imploder ().source (aPattern, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setXmlErrorExcludes (@Nullable final String [] aPattern)
  {
    m_aXmlErrorExcludes = aPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting erroneous XML file excludes to " +
                       StringImplode.imploder ().source (aPattern, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setSvrlErrorDirectory (@NonNull final File aDir)
  {
    m_aSvrlErrorDirectory = aDir;
    if (!m_aSvrlErrorDirectory.isAbsolute ())
      m_aSvrlErrorDirectory = new File (project.getBasedir (), aDir.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Writing erroneous SVRL files to directory '" + m_aSvrlErrorDirectory + "'");
  }

  public void setPhaseName (@Nullable final String sPhaseName)
  {
    m_sPhaseName = sPhaseName;

    if (getLog ().isDebugEnabled ())
      if (m_sPhaseName == null)
        getLog ().debug ("Using default phase");
      else
        getLog ().debug ("Using the phase '" + m_sPhaseName + "'");
  }

  public void setLanguageCode (@Nullable final String sLanguageCode)
  {
    m_sLanguageCode = sLanguageCode;

    if (getLog ().isDebugEnabled ())
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

  public void setFailFast (final boolean bFailFast)
  {
    m_bFailFast = bFailFast;
    if (bFailFast)
      getLog ().debug ("Failing at the first erroneous file");
    else
      getLog ().debug ("Failing after validating all files");
  }

  public void setForceCacheResult (final boolean bForceCacheResult)
  {
    m_bForceCacheResult = bForceCacheResult;
    if (m_bForceCacheResult)
      getLog ().debug ("Results are forcebly cached");
    else
      getLog ().debug ("Results not not forcebly cached");
  }

  public void setLenient (final boolean bLenient)
  {
    m_bLenient = bLenient;
    if (m_bLenient)
      getLog ().debug ("Old deprecated namespace URIs are supported");
    else
      getLog ().debug ("Old deprecated namespace URIs are not supported");
  }

  public void setIgnoreWarnings (final boolean bIgnoreWarnings)
  {
    m_bIgnoreWarnings = bIgnoreWarnings;
    if (m_bIgnoreWarnings)
      getLog ().debug ("Warnings will be ignored and only errors will be displayed");
    else
      getLog ().debug ("Warning and errors will be displayed");
  }

  public void setFailOnValidationError (final boolean bFail)
  {
    m_bFailOnValidationError = bFail;
    getLog ().debug (bFail ? "Will fail on validation error" : "Will not fail on validation error");
  }

  public void setFailOnValidationWarn (final boolean bFail)
  {
    m_bFailOnValidationWarn = bFail;
    getLog ().debug (bFail ? "Will fail on validation warning" : "Will not fail on validation warning");
  }

  public void setFailOnValidationInfo (final boolean bFail)
  {
    m_bFailOnValidationInfo = bFail;
    getLog ().debug (bFail ? "Will fail on validation information" : "Will not fail on validation information");
  }

  public void setErrorRoles (@Nullable final String [] aErrorRoles)
  {
    m_aErrorRoles = aErrorRoles;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting error roles to " +
                       StringImplode.imploder ().source (aErrorRoles, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setCatalogFiles (@Nullable final File [] aCatalogFiles)
  {
    m_aCatalogFiles = null;
    if (aCatalogFiles != null)
    {
      m_aCatalogFiles = new File [aCatalogFiles.length];
      for (int i = 0; i < aCatalogFiles.length; ++i)
      {
        final File aFile = aCatalogFiles[i];
        m_aCatalogFiles[i] = aFile.isAbsolute () ? aFile : new File (project.getBasedir (), aFile.getPath ());
        getLog ().debug ("Using XML catalog file '" + m_aCatalogFiles[i] + "'");
      }
    }
  }

  @NonNull
  @ReturnsMutableCopy
  @VisibleForTesting
  ICommonsMap <String, String> getParameters ()
  {
    return new CommonsHashMap <> (m_aCustomParameters);
  }

  /**
   * @param aSch
   *        Schematron resource to apply on validation artefacts
   * @param aXMLDirectory
   *        XML directory to be scanned
   * @param aXMLIncludes
   *        XML include mask - may be <code>null</code> or empty
   * @param aXMLExcludes
   *        XML exclude mask - may be <code>null</code> or empty
   * @param aSVRLDirectory
   *        SVRL directory to write to (maybe <code>null</code> in which case the SVRL is not
   *        written)
   * @param bExpectSuccess
   *        <code>true</code> if this is a positive validation, <code>false</code> if error is
   *        expected
   * @param aErrorMessages
   *        The list of collected error messages (only used if fail-fast is disabled)
   * @throws MojoExecutionException
   *         Internal error
   * @throws MojoFailureException
   *         Validation error
   */
  private void _performValidation (@NonNull final SchematronValidationRunner aRunner,
                                   @NonNull final File aXMLDirectory,
                                   @Nullable final String [] aXMLIncludes,
                                   @Nullable final String [] aXMLExcludes,
                                   @Nullable final File aSVRLDirectory,
                                   final boolean bExpectSuccess,
                                   @NonNull final ICommonsList <String> aErrorMessages) throws MojoExecutionException,
                                                                                         MojoFailureException
  {
    final DirectoryScanner aScanner = new DirectoryScanner ();
    aScanner.setBasedir (aXMLDirectory);
    if (ArrayHelper.isNotEmpty (aXMLIncludes))
      aScanner.setIncludes (aXMLIncludes);
    if (ArrayHelper.isNotEmpty (aXMLExcludes))
      aScanner.setExcludes (aXMLExcludes);
    aScanner.setCaseSensitive (true);
    aScanner.scan ();
    final String [] aXMLFilenames = aScanner.getIncludedFiles ();
    if (aXMLFilenames != null)
    {
      for (final String sXMLFilename : aXMLFilenames)
      {
        final File aXMLFile = new File (aXMLDirectory, sXMLFilename);
        final SchematronFileValidationResult aResult = aRunner.validateFile (aXMLFile,
                                                                             SchematronValidationRunner.getSVRLFile (aSVRLDirectory,
                                                                                                                     sXMLFilename),
                                                                             bExpectSuccess);
        if (aResult.exception () != null)
          throw new MojoExecutionException (aResult.failureMessage (), aResult.exception ());
        if (!aResult.isSuccess ())
        {
          if (m_bFailFast)
            throw new MojoFailureException (aResult.failureMessage ());
          aErrorMessages.add (aResult.failureMessage ());
        }
      }
    }
  }

  public void execute () throws MojoExecutionException, MojoFailureException
  {
    if (m_aSchematronFile == null)
      throw new MojoExecutionException ("No Schematron file specified!");
    if (m_aSchematronFile.exists () && !m_aSchematronFile.isFile ())
      throw new MojoExecutionException ("The specified Schematron file " + m_aSchematronFile + " is not a file!");
    final ESchematronEngine eEngine = ESchematronEngine.getFromIDOrNull (m_sSchematronProcessingEngine);
    if (eEngine == null)
      throw new MojoExecutionException ("An invalid Schematron processing instance is specified! Only one of the following values is allowed: " +
                                        SchematronEngineFactory.getEngineIDsAsString (x -> true));
    if (m_aXmlDirectory == null && m_aXmlErrorDirectory == null)
      throw new MojoExecutionException ("No XML directory specified - positive or negative directory must be present!");

    if (m_aXmlDirectory != null)
    {
      if (m_aXmlDirectory.exists () && !m_aXmlDirectory.isDirectory ())
        throw new MojoExecutionException ("The specified XML directory " + m_aXmlDirectory + " is not a directory!");
      if (ArrayHelper.isEmpty (m_aXmlIncludes))
        throw new MojoExecutionException ("No XML include pattern specified!");

      if (m_aSvrlDirectory != null)
      {
        if (!m_aSvrlDirectory.exists () && !m_aSvrlDirectory.mkdirs ())
          throw new MojoExecutionException ("Failed to create the SVRL directory " + m_aSvrlDirectory);
      }
    }

    if (m_aXmlErrorDirectory != null)
    {
      if (m_aXmlErrorDirectory.exists () && !m_aXmlErrorDirectory.isDirectory ())
        throw new MojoExecutionException ("The specified erroneous XML directory " +
                                          m_aXmlErrorDirectory +
                                          " is not a directory!");
      if (ArrayHelper.isEmpty (m_aXmlErrorIncludes))
        throw new MojoExecutionException ("No erroneous XML include pattern specified!");

      if (m_aSvrlErrorDirectory != null)
      {
        if (!m_aSvrlErrorDirectory.exists () && !m_aSvrlErrorDirectory.mkdirs ())
          throw new MojoExecutionException ("Failed to create the erroneous SVRL directory " + m_aSvrlErrorDirectory);
      }
    }

    final ISchematronXsltProcessor aXsltProcessor;
    final CatalogResolver aCatalogResolver;
    try
    {
      aXsltProcessor = SchematronEngineFactory.getXsltProcessor (eEngine, m_sXsltProcessor);
      if (aXsltProcessor != null)
        getLog ().debug ("Using the XSLT processor '" + aXsltProcessor.getID () + "'");
      aCatalogResolver = SchematronCatalogHelper.createCatalogResolver (m_aCatalogFiles == null ? null
                                                                                                : Arrays.asList (m_aCatalogFiles));
    }
    catch (final IllegalArgumentException | IllegalStateException ex)
    {
      throw new MojoExecutionException (ex.getMessage ());
    }

    final SchematronEngineSettings aSettings = new SchematronEngineSettings ().setEngine (eEngine)
                                                                              .setXsltProcessor (aXsltProcessor)
                                                                              .setPhase (m_sPhaseName)
                                                                              .setLanguageCode (m_sLanguageCode)
                                                                              .setParameters (m_aCustomParameters)
                                                                              .setForceCacheResult (m_bForceCacheResult)
                                                                              .setLenient (m_bLenient)
                                                                              .setURIResolver (aCatalogResolver)
                                                                              .setEntityResolver (aCatalogResolver);
    final SchematronEngineResource aSch = SchematronEngineFactory.createResource (m_aSchematronFile, aSettings);
    for (final IError aError : aSch.errors ())
      PluginErrorListener.logIError (buildContext, m_aSchematronFile, aError);
    if (aSch.hasAnyError ())
      throw new MojoExecutionException ("The provided Schematron file contains errors. See log for details.");
    getLog ().info ("Successfully parsed Schematron file '" + m_aSchematronFile.getPath () + "'");

    final SchematronValidationRunner aRunner = new SchematronValidationRunner (aSch.resource (),
                                                                               new MavenLogHandler (getLog ())).setIgnoreWarnings (m_bIgnoreWarnings)
                                                                                                               .setErrorRoles (m_aErrorRoles == null ? null
                                                                                                                                                     : Arrays.asList (m_aErrorRoles))
                                                                                                               .setFailOnValidationError (m_bFailOnValidationError)
                                                                                                               .setFailOnValidationWarn (m_bFailOnValidationWarn)
                                                                                                               .setFailOnValidationInfo (m_bFailOnValidationInfo)
                                                                                                               .setEntityResolver (aCatalogResolver);

    final ICommonsList <String> aErrorMessages = new CommonsArrayList <> ();
    if (m_aXmlDirectory != null)
    {
      _performValidation (aRunner,
                          m_aXmlDirectory,
                          m_aXmlIncludes,
                          m_aXmlExcludes,
                          m_aSvrlDirectory,
                          true,
                          aErrorMessages);
    }
    if (m_aXmlErrorDirectory != null)
    {
      _performValidation (aRunner,
                          m_aXmlErrorDirectory,
                          m_aXmlErrorIncludes,
                          m_aXmlErrorExcludes,
                          m_aSvrlErrorDirectory,
                          false,
                          aErrorMessages);
    }

    if (!m_bFailFast && aErrorMessages.isNotEmpty ())
    {
      aErrorMessages.add (0, aErrorMessages.size () + " errors found:");
      final String sCollectedErrorMessages = StringImplode.imploder ()
                                                          .source (aErrorMessages)
                                                          .separator ("\n  ")
                                                          .build ();
      throw new MojoFailureException (sCollectedErrorMessages);
    }
  }
}
