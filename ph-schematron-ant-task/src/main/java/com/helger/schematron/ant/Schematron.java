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
import java.io.Serializable;
import java.util.Locale;
import java.util.Map;

import javax.xml.transform.URIResolver;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceCollection;
import org.apache.tools.ant.types.XMLCatalog;
import org.apache.tools.ant.types.resources.FileProvider;
import org.apache.tools.ant.types.resources.FileResource;
import org.apache.tools.ant.util.ResourceUtils;
import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.xml.sax.EntityResolver;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.OverrideOnDemand;
import com.helger.annotation.style.UsedViaReflection;
import com.helger.base.string.StringHelper;
import com.helger.base.string.StringImplode;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsMap;
import com.helger.diagnostics.error.IError;
import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.schematron.CSchematron;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.enginefactory.SchematronEngineFactory;
import com.helger.schematron.enginefactory.SchematronEngineResource;
import com.helger.schematron.enginefactory.SchematronEngineSettings;
import com.helger.schematron.enginefactory.SchematronFileValidationResult;
import com.helger.schematron.enginefactory.SchematronValidationRunner;
import com.helger.schematron.sch.SchematronSCHConfig;
import com.helger.typeconvert.collection.IStringMap;
import com.helger.typeconvert.collection.StringMap;

/**
 * ANT task to perform Schematron validation.
 *
 * @author Philip Helger
 * @since 4.2.3
 */
@NotThreadSafe
public class Schematron extends AbstractSchematronTask
{
  /**
   * Custom role value that triggers an error.
   *
   * @author Philip Helger
   * @since 5.0.2
   */
  @NotThreadSafe
  public static class ErrorRole implements Serializable
  {
    private String m_sRole;

    public ErrorRole ()
    {}

    @UsedViaReflection
    public void setRole (@Nullable final String sRole)
    {
      m_sRole = sRole;
    }

    @Nullable
    public String getRole ()
    {
      return m_sRole;
    }

    public boolean equalsIgnoreCase (@NonNull final String sValue)
    {
      return sValue.equalsIgnoreCase (m_sRole);
    }
  }

  /**
   * Custom parameter for SCH/XSLT transformations only.
   *
   * @author Philip Helger
   * @since 5.0.6
   */
  @NotThreadSafe
  public static class Parameter implements Serializable
  {
    private String m_sName;
    private String m_sValue;

    public Parameter ()
    {}

    @UsedViaReflection
    public void setName (@Nullable final String sName)
    {
      m_sName = sName;
    }

    @Nullable
    public String getName ()
    {
      return m_sName;
    }

    @UsedViaReflection
    public void setValue (@Nullable final String sValue)
    {
      m_sValue = sValue;
    }

    @Nullable
    public String getValue ()
    {
      return m_sValue;
    }

    void addToMap (@NonNull final Map <String, String> aMap)
    {
      // Only add parameters that have a name
      // If the value is null it becomes ""
      if (StringHelper.isNotEmpty (m_sName))
        aMap.put (m_sName, StringHelper.getNotNull (m_sValue));
    }
  }

  /**
   * The Schematron file. This may also be an XSLT file if it is precompiled.
   */
  private File m_aSchematronFile;

  /**
   * The processing engine to use. Can be one of the following:
   * <ul>
   * <li>pure - for SCH files</li>
   * <li>schematron - for SCH files that will be converted to XSLT and applied from there.</li>
   * <li>xslt - apply pre-build XSLT files</li>
   * </ul>
   */
  private ESchematronEngine m_eSchematronProcessingEngine = ESchematronEngine.ISO_SCHEMATRON;

  /**
   * The XSLT processor for the engines <code>iso-schematron</code>, <code>schxslt</code>,
   * <code>schxslt2</code> and <code>xslt</code>: <code>saxon</code> or <code>phoxtrot</code>. If not
   * set, the only XSLT processor on the class path is used; with both on the class path it must be
   * set.
   */
  private String m_sXsltProcessor;

  /**
   * The collection for resources (like FileSets etc.) which are to be validated.
   */
  private final ICommonsList <ResourceCollection> m_aResCollections = new CommonsArrayList <> ();

  /**
   * The SVRL path to write to. The filenames are based on the source XML filenames.
   */
  private File m_aSvrlDirectory;

  /**
   * Define the phase to be used for Schematron validation. By default the <code>defaultPhase</code>
   * attribute of the Schematron file is used. This phase name is only used if the processing engine
   * <code>pure</code> or <code>schematron</code> are used.
   */
  private String m_sPhaseName;

  /**
   * Define the language code to be used for Schematron validation. Default is English. Supported
   * language codes are: cs, de, en, fr, nl.
   */
  private String m_sLanguageCode;

  /**
   * <code>true</code> if internal caching of the result should be forced, <code>false</code> if
   * not. This only applies when Schematron to XSLT conversion is performed.
   */
  private boolean m_bForceCacheResult = SchematronSCHConfig.DEFAULT_FORCE_CACHE_RESULT;

  /**
   * <code>true</code> if the XMLs are supposed to be valid, <code>false</code> otherwise. Defaults
   * to <code>true</code>.
   */
  private boolean m_bExpectSuccess = true;

  /**
   * List of "role" attribute values that will trigger an error. If combined with "failOnError" it
   * will break the build.
   */
  private final ICommonsList <Schematron.ErrorRole> m_aErrorRoles = new CommonsArrayList <> ();

  /**
   * <code>true</code> if the build should fail if any validation "error" occurs. Defaults to
   * <code>false</code>. Since v5.0.11.
   */
  private boolean m_bFailOnValidationError = false;

  /**
   * <code>true</code> if the build should fail if any validation "warnings" occurs. Defaults to
   * <code>false</code>. Since v5.0.11.
   */
  private boolean m_bFailOnValidationWarn = false;

  /**
   * <code>true</code> if the build should fail if any validation "information" occurs. Defaults to
   * <code>false</code>. Since v5.0.11.
   */
  private boolean m_bFailOnValidationInfo = false;

  /**
   * For resolving entities such as DTDs. This is used both for the Schematron file as well as for
   * the XML files to be validated.
   */
  private final XMLCatalog m_aXmlCatalog = new XMLCatalog ();

  /**
   * Custom parameters for SCH/XSLT version.
   */
  private final ICommonsList <Schematron.Parameter> m_aParameters = new CommonsArrayList <> ();

  /**
   * <code>true</code> if an <code>xmlcatalog</code> element was added. Only then the XML files are
   * read with the catalog: external DTDs and entities only from the catalog, one that is not in the
   * catalog makes the file fail.
   */
  private boolean m_bXmlCatalogSet = false;

  /**
   * <code>true</code> to accept deprecated Schematron namespace URIs. Only used by the engine
   * <code>pure-xpath</code>. Since v11.0.0.
   */
  private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;

  /**
   * <code>true</code> to ignore all failed asserts and successful reports below level error: they
   * are neither logged nor counted. Since v11.0.0.
   */
  private boolean m_bIgnoreWarnings = false;

  /**
   * <code>true</code> to stop at the first XML file that fails, <code>false</code> to validate all
   * files and fail at the end. Since v11.0.0.
   */
  private boolean m_bFailFast = true;

  public Schematron ()
  {}

  public void setSchematronFile (@NonNull final File aFile)
  {
    m_aSchematronFile = aFile;
    if (!m_aSchematronFile.isAbsolute ())
      m_aSchematronFile = new File (getProject ().getBaseDir (), aFile.getPath ());
    _debug ("Using Schematron file '" + m_aSchematronFile + "'");
  }

  public void setSchematronProcessingEngine (@Nullable final String sEngine)
  {
    m_eSchematronProcessingEngine = ESchematronEngine.getFromIDOrNull (sEngine);
    _debug ("Schematron processing mode set to '" + m_eSchematronProcessingEngine + "'");
  }

  /**
   * @param sXsltProcessor
   *        The ID of the XSLT processor (<code>saxon</code> or <code>phoxtrot</code>). May be
   *        <code>null</code> to use the only one on the class path.
   * @since 11.0.0
   */
  public void setXsltProcessor (@Nullable final String sXsltProcessor)
  {
    m_sXsltProcessor = sXsltProcessor;
    _debug ("XSLT processor set to '" + sXsltProcessor + "'");
  }

  /**
   * Add a collection of files to copy.
   *
   * @param aResCollection
   *        a resource collection to copy.
   * @since Ant 1.7
   */
  public void add (final ResourceCollection aResCollection)
  {
    m_aResCollections.add (aResCollection);
  }

  public void setSvrlDirectory (@NonNull final File aDir)
  {
    m_aSvrlDirectory = aDir;
    if (!m_aSvrlDirectory.isAbsolute ())
      m_aSvrlDirectory = new File (getProject ().getBaseDir (), aDir.getPath ());
    _debug ("Writing SVRL files to directory '" + m_aSvrlDirectory + "'");
  }

  public void setPhaseName (@Nullable final String sPhaseName)
  {
    m_sPhaseName = sPhaseName;

    if (m_sPhaseName == null)
      _debug ("Using default phase");
    else
      _debug ("Using the phase '" + m_sPhaseName + "'");
  }

  public void setLanguageCode (@Nullable final String sLanguageCode)
  {
    m_sLanguageCode = sLanguageCode;

    if (m_sLanguageCode == null)
      _debug ("Using default language code");
    else
      _debug ("Using the language code '" + m_sLanguageCode + "'");
  }

  public void setForceCacheResult (final boolean bForceCacheResult)
  {
    m_bForceCacheResult = bForceCacheResult;
    if (m_bForceCacheResult)
      _debug ("Results are forcebly cached");
    else
      _debug ("Results not not forcebly cached");
  }

  public void setExpectSuccess (final boolean bExpectSuccess)
  {
    m_bExpectSuccess = bExpectSuccess;

    _debug ("Expecting that XML files " +
            (bExpectSuccess ? "conform" : "do not conform") +
            " to the provided Schematron file");
  }

  public Schematron.@NonNull ErrorRole createErrorRole ()
  {
    final Schematron.ErrorRole aErrorRole = new Schematron.ErrorRole ();
    m_aErrorRoles.add (aErrorRole);
    return aErrorRole;
  }

  public void setFailOnValidationError (final boolean bFail)
  {
    m_bFailOnValidationError = bFail;

    _debug (bFail ? "Will fail on validation error" : "Will not fail on validation error");
  }

  public void setFailOnValidationWarn (final boolean bFail)
  {
    m_bFailOnValidationWarn = bFail;

    _debug (bFail ? "Will fail on validation warning" : "Will not fail on validation warning");
  }

  public void setFailOnValidationInfo (final boolean bFail)
  {
    m_bFailOnValidationInfo = bFail;

    _debug (bFail ? "Will fail on validation information" : "Will not fail on validation information");
  }

  /**
   * Add the catalog to our internal catalog
   *
   * @param aXmlCatalog
   *        the XMLCatalog instance to use to look up DTDs
   */
  public void addConfiguredXMLCatalog (@NonNull final XMLCatalog aXmlCatalog)
  {
    m_aXmlCatalog.addConfiguredXMLCatalog (aXmlCatalog);
    m_bXmlCatalogSet = true;
    _debug ("Added XMLCatalog " + aXmlCatalog);
  }

  public Schematron.@NonNull Parameter createParameter ()
  {
    final Schematron.Parameter aParameter = new Schematron.Parameter ();
    m_aParameters.add (aParameter);
    return aParameter;
  }

  /**
   * @param bLenient
   *        <code>true</code> to accept deprecated Schematron namespace URIs (engine
   *        <code>pure-xpath</code> only).
   * @since 11.0.0
   */
  public void setLenient (final boolean bLenient)
  {
    m_bLenient = bLenient;
    _debug (bLenient ? "Old deprecated namespace URIs are supported"
                     : "Old deprecated namespace URIs are not supported");
  }

  /**
   * @param bIgnoreWarnings
   *        <code>true</code> to ignore all warnings and information.
   * @since 11.0.0
   */
  public void setIgnoreWarnings (final boolean bIgnoreWarnings)
  {
    m_bIgnoreWarnings = bIgnoreWarnings;
    _debug (bIgnoreWarnings ? "Warnings will be ignored and only errors will be displayed"
                            : "Warning and errors will be displayed");
  }

  /**
   * @param bFailFast
   *        <code>true</code> to stop at the first failing XML file, <code>false</code> to fail
   *        after all files were validated.
   * @since 11.0.0
   */
  public void setFailFast (final boolean bFailFast)
  {
    m_bFailFast = bFailFast;
    _debug (bFailFast ? "Failing at the first erroneous file" : "Failing after validating all files");
  }

  /**
   * Get the {@link EntityResolver} to be used.
   *
   * @return Never <code>null</code>.
   */
  @NonNull
  @OverrideOnDemand
  protected EntityResolver getEntityResolver ()
  {
    return m_aXmlCatalog;
  }

  /**
   * Get the {@link URIResolver} to be used.
   *
   * @return Never <code>null</code>.
   */
  @NonNull
  @OverrideOnDemand
  protected URIResolver getURIResolver ()
  {
    return m_aXmlCatalog;
  }

  @Override
  public void init () throws BuildException
  {
    super.init ();
    m_aXmlCatalog.setProject (getProject ());
  }

  private static final File NULL_FILE_PLACEHOLDER = new File ("/dummy_NULL");

  @NonNull
  private static File _getKeyFile (@Nullable final File f)
  {
    return f != null ? f : NULL_FILE_PLACEHOLDER;
  }

  private void _performValidation (@NonNull final SchematronValidationRunner aRunner,
                                   @NonNull final ICommonsList <ResourceCollection> aResCollections,
                                   @Nullable final File aSVRLDirectory,
                                   final boolean bExpectSuccess) throws BuildException
  {
    // Resolve resourceCollections - pain in the ass
    final ICommonsMap <File, DirectoryData> aFiles = new CommonsHashMap <> ();
    for (final ResourceCollection aResCollection : aResCollections)
    {
      if (!aResCollection.isFilesystemOnly ())
        _errorOrFail ("Only FileSystem resources are supported.");
      else
        for (final Resource aRes : aResCollection)
        {
          if (!aRes.isExists ())
          {
            _errorOrFail ("Could not find resource " + aRes.toLongString () + " to copy.");
            continue;
          }

          File aBaseDir = NULL_FILE_PLACEHOLDER;
          String sName = aRes.getName ();
          final FileProvider aFP = aRes.as (FileProvider.class);
          if (aFP != null)
          {
            final FileResource aFR = ResourceUtils.asFileResource (aFP);
            aBaseDir = _getKeyFile (aFR.getBaseDir ());
            if (aBaseDir == NULL_FILE_PLACEHOLDER)
              sName = aFR.getFile ().getAbsolutePath ();
          }

          if ((aRes.isDirectory () || aFP != null) && sName != null)
          {
            final DirectoryData aBaseDirData = aFiles.computeIfAbsent (_getKeyFile (aBaseDir), DirectoryData::new);
            if (aRes.isDirectory ())
              aBaseDirData.addDir (sName);
            else
              aBaseDirData.addFile (sName);
          }
          else
            _errorOrFail ("Could not resolve resource " + aRes.toLongString () + " to a file.");
        }
    }

    final ICommonsList <String> aErrorMessages = new CommonsArrayList <> ();
    for (final DirectoryData aBaseDirData : aFiles.values ())
    {
      _debug ("Scanning directory " + aBaseDirData.getBaseDir () + " for XMLs to be Schematron validated");

      final ICommonsList <String> aIncludes = new CommonsArrayList <> ();
      aIncludes.addAll (aBaseDirData.getFiles ());
      for (final String sFile : aBaseDirData.getDirs ())
        aIncludes.add (sFile + "/**");

      final DirectoryScanner aScanner = new DirectoryScanner ();
      aScanner.setBasedir (aBaseDirData.getBaseDir ());
      if (aIncludes.isNotEmpty ())
        aScanner.setIncludes (aIncludes.toArray (new String [0]));
      aScanner.setCaseSensitive (true);
      aScanner.scan ();

      final String [] aXMLFilenames = aScanner.getIncludedFiles ();
      if (aXMLFilenames != null)
      {
        for (final String sXMLFilename : aXMLFilenames)
        {
          final File aXMLFile = new File (aBaseDirData.getBaseDir (), sXMLFilename);
          final SchematronFileValidationResult aResult = aRunner.validateFile (aXMLFile,
                                                                               SchematronValidationRunner.getSVRLFile (aSVRLDirectory,
                                                                                                                       sXMLFilename),
                                                                               bExpectSuccess);
          if (aResult.exception () != null)
            _errorOrFail (aResult.expectationFailureMessage (), aResult.exception ());
          else
          {
            if (aResult.expectationFailureMessage () != null)
            {
              if (m_bFailFast)
                _errorOrFail (aResult.expectationFailureMessage ());
              else
                aErrorMessages.add (aResult.expectationFailureMessage ());
            }
            // Independent of failOnError (#50)
            if (aResult.levelFailureMessage () != null)
              throw new BuildException (aResult.levelFailureMessage ());
          }
        }
      }
    }

    if (aErrorMessages.isNotEmpty ())
    {
      aErrorMessages.add (0, aErrorMessages.size () + " errors found:");
      _errorOrFail (StringImplode.imploder ().source (aErrorMessages).separator ("\n  ").build ());
    }
  }

  @Override
  public void execute () throws BuildException
  {
    boolean bCanRun = false;
    if (m_aSchematronFile == null)
      _errorOrFail ("No Schematron file specified!");
    else
      if (m_aSchematronFile.exists () && !m_aSchematronFile.isFile ())
        _errorOrFail ("The specified Schematron file " + m_aSchematronFile + " is not a file!");
      else
        if (m_eSchematronProcessingEngine == null)
          _errorOrFail ("An invalid Schematron processing instance is specified! Only one of the following values is allowed: " +
                        SchematronEngineFactory.getEngineIDsAsString (x -> true));
        else
          if (m_aResCollections.isEmpty ())
            _errorOrFail ("No XML resources to be validated specified! Add e.g. a <fileset> element.");
          else
            if (m_aSvrlDirectory != null && !m_aSvrlDirectory.exists () && !m_aSvrlDirectory.mkdirs ())
              _errorOrFail ("Failed to create the SVRL directory " + m_aSvrlDirectory);
            else
              bCanRun = true;

    // The XSLT processor of the XSLT based engines
    ISchematronXsltProcessor aXsltProcessor = null;
    if (bCanRun)
      try
      {
        aXsltProcessor = SchematronEngineFactory.getXsltProcessor (m_eSchematronProcessingEngine, m_sXsltProcessor);
        if (aXsltProcessor != null)
          _debug ("Using the XSLT processor '" + aXsltProcessor.getID () + "'");
      }
      catch (final IllegalArgumentException | IllegalStateException ex)
      {
        _errorOrFail (ex.getMessage ());
        bCanRun = false;
      }

    if (bCanRun)
    {
      // 1. Parse Schematron file
      final IStringMap aParams = new StringMap ();
      m_aParameters.forEach (x -> x.addToMap (aParams));
      if (aParams.isNotEmpty ())
        _info ("Using the following custom parameters: " + aParams);

      final SchematronEngineSettings aSettings = new SchematronEngineSettings ().setEngine (m_eSchematronProcessingEngine)
                                                                                .setXsltProcessor (aXsltProcessor)
                                                                                .setPhase (m_sPhaseName)
                                                                                .setLanguageCode (m_sLanguageCode)
                                                                                .setParameters (aParams)
                                                                                .setForceCacheResult (m_bForceCacheResult)
                                                                                .setLenient (m_bLenient)
                                                                                .setURIResolver (getURIResolver ())
                                                                                .setEntityResolver (getEntityResolver ());
      final SchematronEngineResource aSch = SchematronEngineFactory.createResource (m_aSchematronFile, aSettings);

      final Locale aDisplayLocale = Locale.US;
      for (final IError aError : aSch.errors ())
        if (aError.getErrorLevel ().isGE (EErrorLevel.ERROR))
          _error ("Error in Schematron: " + aError.getAsString (aDisplayLocale));
        else
          if (aError.getErrorLevel ().isGE (EErrorLevel.WARN))
            _warn ("Warning in Schematron: " + aError.getAsString (aDisplayLocale));
          else
            _info ("Information in Schematron: " + aError.getAsString (aDisplayLocale));

      if (aSch.hasAnyError ())
        _errorOrFail ("The provided Schematron file contains errors. See log for details.");
      else
      {
        // Schematron is okay
        _info ("Successfully parsed Schematron file '" + m_aSchematronFile.getPath () + "'");

        // Start validation
        final ICommonsList <String> aErrorRoles = m_aErrorRoles.getAllMapped (Schematron.ErrorRole::getRole);
        final SchematronValidationRunner aRunner = new SchematronValidationRunner (aSch.resource (),
                                                                                   new AntLogHandler (this)).setIgnoreWarnings (m_bIgnoreWarnings)
                                                                                                            .setErrorRoles (aErrorRoles)
                                                                                                            .setFailOnValidationError (m_bFailOnValidationError)
                                                                                                            .setFailOnValidationWarn (m_bFailOnValidationWarn)
                                                                                                            .setFailOnValidationInfo (m_bFailOnValidationInfo)
                                                                                                            .setEntityResolver (m_bXmlCatalogSet ? getEntityResolver ()
                                                                                                                                                 : null);
        _performValidation (aRunner, m_aResCollections, m_aSvrlDirectory, m_bExpectSuccess);
      }
    }
  }
}
