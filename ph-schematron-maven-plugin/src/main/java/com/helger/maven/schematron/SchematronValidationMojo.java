/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
import java.util.Locale;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.util.DirectoryScanner;
import org.slf4j.impl.StaticLoggerBinder;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.annotation.Since;
import com.helger.commons.annotation.VisibleForTesting;
import com.helger.commons.collection.ArrayHelper;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.error.IError;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.error.list.IErrorList;
import com.helger.commons.io.file.FileIOError;
import com.helger.commons.io.file.FileOperationManager;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.CSchematron;
import com.helger.schematron.ESchematronMode;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.sch.TransformerCustomizerSCH;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.svrl.AbstractSVRLMessage;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.xml.transform.CollectingTransformErrorListener;
import com.helger.xml.transform.TransformSourceFactory;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;

/**
 * Applies Schematron validation onto an XML file
 *
 * @author Philip Helger
 */
@SuppressFBWarnings ({ "NP_UNWRITTEN_FIELD", "UWF_UNWRITTEN_FIELD" })
@Mojo (name = "validate", defaultPhase = LifecyclePhase.PROCESS_RESOURCES, threadSafe = true)
public final class SchematronValidationMojo extends AbstractMojo
{
  /**
   * BuildContext for m2e (it's a pass-though straight to the filesystem when
   * invoked from the Maven cli)
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
   * The processing engine to use. Can be one of the following:
   * <ul>
   * <li>pure - for SCH files</li>
   * <li>schematron - for SCH files that will be converted to XSLT and applied
   * from there.</li>
   * <li>xslt - apply pre-build XSLT files</li>
   * </ul>
   */
  @Parameter (name = "schematronProcessingEngine", required = true)
  private String m_sSchematronProcessingEngine = ESchematronMode.SCHEMATRON.getID ();

  /**
   * The directory where the XML files reside that are expected to match the
   * Schematron rules.
   */
  @Parameter (name = "xmlDirectory", required = true)
  private File m_aXmlDirectory;

  /**
   * A pattern for the XML files that should be included. Can contain Ant-style
   * wildcards and double wildcards. All files that match the pattern will be
   * converted. Files in the xmlDirectory and its subdirectories will be
   * considered.
   */
  @Parameter (name = "xmlIncludes", defaultValue = "**/*.xml", required = true)
  private String [] m_aXmlIncludes;

  /**
   * A pattern for the XML files that should be excluded. Can contain Ant-style
   * wildcards and double wildcards. All files that match the pattern will NOT
   * be converted. Only files in the xmlDirectory and its subdirectories will be
   * considered.
   */
  @Parameter (name = "xmlExcludes")
  private String [] m_aXmlExcludes;

  /**
   * The SVRL path to write to (for positive tests). The filenames are based on
   * the source XML filenames. If this parameter is not set, the SVRL files are
   * <b>not</b> written.
   */
  @Parameter (name = "svrlDirectory")
  private File m_aSvrlDirectory;

  /**
   * The directory where the erroneous XML files reside that are expected to NOT
   * match the Schematron rules.
   */
  @Parameter (name = "xmlErrorDirectory")
  private File m_aXmlErrorDirectory;

  /**
   * A pattern for the erroneous XML files that should be included. Can contain
   * Ant-style wildcards and double wildcards. All files that match the pattern
   * will be converted. Files in the xmlDirectory and its subdirectories will be
   * considered.
   */
  @Parameter (name = "xmlErrorIncludes", defaultValue = "**/*.xml")
  private String [] m_aXmlErrorIncludes;

  /**
   * A pattern for the erroneous XML files that should be excluded. Can contain
   * Ant-style wildcards and double wildcards. All files that match the pattern
   * will NOT be converted. Only files in the xmlDirectory and its
   * subdirectories will be considered.
   */
  @Parameter (name = "xmlErrorExcludes")
  private String [] m_aXmlErrorExcludes;

  /**
   * The SVRL path to write to (for negative tests). The filenames are based on
   * the source XML filenames. If this parameter is not set, the SVRL files are
   * <b>not</b> written.
   */
  @Parameter (name = "svrlErrorDirectory")
  private File m_aSvrlErrorDirectory;

  /**
   * Define the phase to be used for Schematron validation. By default the
   * <code>defaultPhase</code> attribute of the Schematron file is used. This
   * phase name is only used if the processing engine <code>pure</code> or
   * <code>schematron</code> are used.
   */
  @Parameter (name = "phaseName")
  private String m_sPhaseName;

  /**
   * Define the language code to be used for Schematron validation. Default is
   * English. Supported language codes are: cs, de, en, fr, nl. This parameter
   * takes only effect when using schematronProcessingEngine "schematron".
   */
  @Parameter (name = "languageCode")
  private String m_sLanguageCode;

  /**
   * Custom attributes to be used for the SCH to XSLT conversion. This parameter
   * takes only effect when using schematronProcessingEngine "schematron" or
   * "xslt".
   */
  @Parameter (name = "parameters")
  @Since ("5.0.2")
  private Map <String, String> m_aCustomParameters;

  /**
   * When validating multiple files, this flag indicates, whether validation
   * should fail at the first file with an error (this is the default) or at the
   * end only.
   */
  @Parameter (name = "failFast", defaultValue = "true", required = true)
  @Since ("5.0.5")
  private boolean m_bFailFast = true;

  /**
   * Force the results to be cached. This only applies when Schematron to XSLT
   * conversion is performed.
   */
  @Parameter (name = "forceCacheResult", defaultValue = "false")
  @Since ("5.2.1")
  private boolean m_bForceCacheResult = TransformerCustomizerSCH.DEFAULT_FORCE_CACHE_RESULT;

  /**
   * Define if old namespace URIs should be supported or not. By default this is
   * disabled. This parameter takes only effect when using
   * schematronProcessingEngine "pure".
   */
  @Parameter (name = "lenient", defaultValue = "false")
  @Since ("5.4.1")
  private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;

  /**
   * <code>true</code> to ignore all warnings, <code>false</code> to also show
   * warning messages,
   */
  @Parameter (name = "ignoreWarnings", defaultValue = "false")
  @Since ("7.1.3")
  private boolean m_bIgnoreWarnings = false;

  public void setSchematronFile (@Nonnull final File aFile)
  {
    m_aSchematronFile = aFile;
    if (!m_aSchematronFile.isAbsolute ())
      m_aSchematronFile = new File (project.getBasedir (), aFile.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Using Schematron file '" + m_aSchematronFile + "'");
  }

  public void setSchematronProcessingEngine (@Nullable final String sEngine)
  {
    final ESchematronMode eMode = ESchematronMode.getFromIDOrNull (sEngine);
    m_sSchematronProcessingEngine = eMode == null ? null : eMode.getID ();
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Schematron processing mode set to '" + eMode + "'");
  }

  public void setXmlDirectory (@Nonnull final File aDir)
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
                       StringHelper.imploder ().source (aPattern, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setXmlExcludes (@Nullable final String [] aPattern)
  {
    m_aXmlExcludes = aPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting XML file excludes to " +
                       StringHelper.imploder ().source (aPattern, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setSvrlDirectory (@Nonnull final File aDir)
  {
    m_aSvrlDirectory = aDir;
    if (!m_aSvrlDirectory.isAbsolute ())
      m_aSvrlDirectory = new File (project.getBasedir (), aDir.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Writing SVRL files to directory '" + m_aSvrlDirectory + "'");
  }

  public void setXmlErrorDirectory (@Nonnull final File aDir)
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
                       StringHelper.imploder ().source (aPattern, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setXmlErrorExcludes (@Nullable final String [] aPattern)
  {
    m_aXmlErrorExcludes = aPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting erroneous XML file excludes to " +
                       StringHelper.imploder ().source (aPattern, x -> "'" + x + "'").separator (", ").build ());
  }

  public void setSvrlErrorDirectory (@Nonnull final File aDir)
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

  @Nonnull
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
   *        SVRL directory to write to (maybe <code>null</code> in which case
   *        the SVRL is not written)
   * @param bExpectSuccess
   *        <code>true</code> if this is a positive validation,
   *        <code>false</code> if error is expected
   * @param aErrorMessages
   *        The list of collected error messages (only used if fail-fast is
   *        disabled)
   * @throws MojoExecutionException
   *         Internal error
   * @throws MojoFailureException
   *         Validation error
   */
  private void _performValidation (@Nonnull final ISchematronResource aSch,
                                   @Nonnull final File aXMLDirectory,
                                   @Nullable final String [] aXMLIncludes,
                                   @Nullable final String [] aXMLExcludes,
                                   @Nullable final File aSVRLDirectory,
                                   final boolean bExpectSuccess,
                                   @Nonnull final ICommonsList <String> aErrorMessages) throws MojoExecutionException,
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

        // Validate XML file
        getLog ().info ("Validating XML file '" +
                        aXMLFile.getPath () +
                        "' against Schematron rules from '" +
                        m_aSchematronFile +
                        "' expecting " +
                        (bExpectSuccess ? "success" : "failure"));
        try
        {
          final SchematronOutputType aSOT = aSch.applySchematronValidationToSVRL (TransformSourceFactory.create (aXMLFile));

          if (aSVRLDirectory != null)
          {
            // Save SVRL
            final File aSVRLFile = new File (aSVRLDirectory, sXMLFilename + ".svrl");
            final FileIOError aIOErr = FileOperationManager.INSTANCE.createDirRecursiveIfNotExisting (aSVRLFile.getParentFile ());
            if (aIOErr.isFailure ())
              getLog ().error ("Failed to create parent directory of '" +
                               aSVRLFile.getAbsolutePath () +
                               "': " +
                               aIOErr.toString ());

            if (new SVRLMarshaller ().write (aSOT, aSVRLFile).isSuccess ())
              getLog ().info ("Successfully saved SVRL file '" + aSVRLFile.getPath () + "'");
            else
              getLog ().error ("Error saving SVRL file '" + aSVRLFile.getPath () + "'");
          }

          // Failed asserts and Successful reports
          ICommonsList <AbstractSVRLMessage> aSVRLErrors = SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSOT);
          if (m_bIgnoreWarnings)
          {
            // Use errors only
            final int nOld = aSVRLErrors.size ();
            aSVRLErrors = aSVRLErrors.getAll (x -> x.getFlag ().isError ());
            final int nNew = aSVRLErrors.size ();
            if (nOld > nNew)
              getLog ().info ("Ignoring " + (nOld - nNew) + " Schematron warnings");
          }

          if (bExpectSuccess)
          {
            // No failed assertions expected
            if (aSVRLErrors.isNotEmpty ())
            {
              final String sMessage = aSVRLErrors.size () +
                                      " failed Schematron assertions for XML file '" +
                                      aXMLFile.getPath () +
                                      "'";
              getLog ().error (sMessage);
              aSVRLErrors.forEach (x -> getLog ().error (x.getAsResourceError (aXMLFile.getPath ())
                                                          .getAsString (Locale.US)));
              if (m_bFailFast)
                throw new MojoFailureException (sMessage);
              aErrorMessages.add (sMessage);
            }
          }
          else
          {
            // At least one failed assertions expected
            if (aSVRLErrors.isEmpty ())
            {
              final String sMessage = "No failed Schematron assertions for erroneous XML file '" +
                                      aXMLFile.getPath () +
                                      "'";
              getLog ().error (sMessage);
              if (m_bFailFast)
                throw new MojoFailureException (sMessage);
              aErrorMessages.add (sMessage);
            }
          }
        }
        catch (final MojoExecutionException | MojoFailureException up)
        {
          throw up;
        }
        catch (final Exception ex)
        {
          final String sMessage = "Exception validating XML '" +
                                  aXMLFile.getPath () +
                                  "' against Schematron rules from '" +
                                  m_aSchematronFile +
                                  "'";
          getLog ().error (sMessage, ex);
          throw new MojoExecutionException (sMessage, ex);
        }
      }
    }
  }

  public void execute () throws MojoExecutionException, MojoFailureException
  {
    StaticLoggerBinder.getSingleton ().setMavenLog (getLog ());
    if (m_aSchematronFile == null)
      throw new MojoExecutionException ("No Schematron file specified!");
    if (m_aSchematronFile.exists () && !m_aSchematronFile.isFile ())
      throw new MojoExecutionException ("The specified Schematron file " + m_aSchematronFile + " is not a file!");
    if (m_sSchematronProcessingEngine == null)
      throw new MojoExecutionException ("An invalid Schematron processing instance is specified! Only one of the following values is allowed: " +
                                        StringHelper.getImplodedMapped (", ",
                                                                        ESchematronMode.values (),
                                                                        x -> "'" + x.getID () + "'"));
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

    // 1. Parse Schematron file
    ISchematronResource aSch;
    IErrorList aSCHErrors;
    switch (ESchematronMode.getFromIDOrNull (m_sSchematronProcessingEngine))
    {
      case PURE:
      {
        // pure
        final CollectingPSErrorHandler aErrorHdl = new CollectingPSErrorHandler ();
        final SchematronResourcePure aRealSCH = new SchematronResourcePure (new FileSystemResource (m_aSchematronFile));
        aRealSCH.setPhase (m_sPhaseName);
        aRealSCH.setLenient (m_bLenient);
        // language code is ignored
        // custom parameters are ignored
        aRealSCH.setErrorHandler (aErrorHdl);
        aRealSCH.validateCompletely ();

        aSch = aRealSCH;
        aSCHErrors = aErrorHdl.getAllErrors ();
        break;
      }
      case SCHEMATRON:
      {
        // SCH
        final CollectingTransformErrorListener aErrorHdl = new CollectingTransformErrorListener ();
        final SchematronResourceSCH aRealSCH = new SchematronResourceSCH (new FileSystemResource (m_aSchematronFile));
        aRealSCH.setPhase (m_sPhaseName);
        aRealSCH.setLanguageCode (m_sLanguageCode);
        aRealSCH.setForceCacheResult (m_bForceCacheResult);
        aRealSCH.parameters ().setAll (m_aCustomParameters);
        aRealSCH.setErrorListener (aErrorHdl);
        aRealSCH.isValidSchematron ();

        aSch = aRealSCH;
        aSCHErrors = aErrorHdl.getErrorList ();
        break;
      }
      case SCHXSLT_XSLT2:
      {
        // SchXslt
        final CollectingTransformErrorListener aErrorHdl = new CollectingTransformErrorListener ();
        final SchematronResourceSchXslt_XSLT2 aRealSCH = new SchematronResourceSchXslt_XSLT2 (new FileSystemResource (m_aSchematronFile));
        aRealSCH.setPhase (m_sPhaseName);
        aRealSCH.setLanguageCode (m_sLanguageCode);
        aRealSCH.setForceCacheResult (m_bForceCacheResult);
        aRealSCH.parameters ().setAll (m_aCustomParameters);
        aRealSCH.setErrorListener (aErrorHdl);
        aRealSCH.isValidSchematron ();

        aSch = aRealSCH;
        aSCHErrors = aErrorHdl.getErrorList ();
        break;
      }
      case XSLT:
      {
        // SCH
        final CollectingTransformErrorListener aErrorHdl = new CollectingTransformErrorListener ();
        final SchematronResourceXSLT aRealSCH = new SchematronResourceXSLT (new FileSystemResource (m_aSchematronFile));
        // phase is ignored
        // language code is ignored
        aRealSCH.parameters ().setAll (m_aCustomParameters);
        aRealSCH.setErrorListener (aErrorHdl);
        aRealSCH.isValidSchematron ();

        aSch = aRealSCH;
        aSCHErrors = aErrorHdl.getErrorList ();
        break;
      }
      default:
        throw new MojoExecutionException ("No handler for processing engine '" + m_sSchematronProcessingEngine + "'");
    }
    if (aSCHErrors != null)
    {
      // Error validating the Schematrons!!
      boolean bAnyError = false;
      for (final IError aError : aSCHErrors)
      {
        if (aError.getErrorLevel ().isGE (EErrorLevel.ERROR))
          bAnyError = true;
        PluginErrorListener.logIError (buildContext, m_aSchematronFile, aError);
      }
      if (bAnyError)
        throw new MojoExecutionException ("The provided Schematron file contains errors. See log for details.");
    }
    getLog ().info ("Successfully parsed Schematron file '" + m_aSchematronFile.getPath () + "'");

    // 2. for all XML files that match the pattern
    final ICommonsList <String> aErrorMessages = new CommonsArrayList <> ();
    if (m_aXmlDirectory != null)
    {
      // Expect success
      _performValidation (aSch,
                          m_aXmlDirectory,
                          m_aXmlIncludes,
                          m_aXmlExcludes,
                          m_aSvrlDirectory,
                          true,
                          aErrorMessages);
    }
    if (m_aXmlErrorDirectory != null)
    {
      // Expect error
      _performValidation (aSch,
                          m_aXmlErrorDirectory,
                          m_aXmlErrorIncludes,
                          m_aXmlErrorExcludes,
                          m_aSvrlErrorDirectory,
                          false,
                          aErrorMessages);
    }

    if (!m_bFailFast && aErrorMessages.isNotEmpty ())
    {
      // Build collecting error message
      aErrorMessages.add (0, aErrorMessages.size () + " errors found:");
      final String sCollectedErrorMessages = StringHelper.getImploded ("\n  ", aErrorMessages);
      throw new MojoFailureException (sCollectedErrorMessages);
    }
  }
}
