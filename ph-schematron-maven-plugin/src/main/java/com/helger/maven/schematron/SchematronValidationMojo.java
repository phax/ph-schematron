/**
 * Copyright (C) 2014-2019 Philip Helger (www.helger.com)
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
import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.slf4j.impl.StaticLoggerBinder;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.google.common.annotations.VisibleForTesting;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.annotation.Since;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.error.IError;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.error.list.IErrorList;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.ESchematronMode;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.xslt.SchematronResourceSCH;
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
  @Component
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
  private String m_sSchematronProcessingEngine = ESchematronMode.PURE.getID ();

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
  private String m_sXmlIncludes;

  /**
   * A pattern for the XML files that should be excluded. Can contain Ant-style
   * wildcards and double wildcards. All files that match the pattern will NOT
   * be converted. Only files in the xmlDirectory and its subdirectories will be
   * considered.
   */
  @Parameter (name = "xmlExcludes")
  private String m_sXmlExcludes;

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
  private String m_sXmlErrorIncludes;

  /**
   * A pattern for the erroneous XML files that should be excluded. Can contain
   * Ant-style wildcards and double wildcards. All files that match the pattern
   * will NOT be converted. Only files in the xmlDirectory and its
   * subdirectories will be considered.
   */
  @Parameter (name = "xmlErrorExcludes")
  private String m_sXmlErrorExcludes;

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

  public void setXmlIncludes (@Nullable final String sPattern)
  {
    m_sXmlIncludes = sPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting XML file includes to '" + sPattern + "'");
  }

  public void setXmlExcludes (@Nullable final String sPattern)
  {
    m_sXmlExcludes = sPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting XML file excludes to '" + sPattern + "'");
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

  public void setXmlErrorIncludes (@Nullable final String sPattern)
  {
    m_sXmlErrorIncludes = sPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting erroneous XML file includes to '" + sPattern + "'");
  }

  public void setXmlErrorExcludes (@Nullable final String sPattern)
  {
    m_sXmlErrorExcludes = sPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting erroneous XML file excludes to '" + sPattern + "'");
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
   * @param sXMLIncludes
   *        XML include mask
   * @param sXMLExcludes
   *        XML exclude mask
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
                                   @Nullable final String sXMLIncludes,
                                   @Nullable final String sXMLExcludes,
                                   @Nullable final File aSVRLDirectory,
                                   final boolean bExpectSuccess,
                                   @Nonnull final ICommonsList <String> aErrorMessages) throws MojoExecutionException,
                                                                                        MojoFailureException
  {
    final DirectoryScanner aScanner = new DirectoryScanner ();
    aScanner.setBasedir (aXMLDirectory);
    if (StringHelper.hasText (sXMLIncludes))
      aScanner.setIncludes (new String [] { sXMLIncludes });
    if (StringHelper.hasText (sXMLExcludes))
      aScanner.setExcludes (new String [] { sXMLExcludes });
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
            if (!aSVRLFile.getParentFile ().mkdirs ())
              getLog ().error ("Failed to create parent directory of '" + aSVRLFile.getAbsolutePath () + "'!");

            if (new SVRLMarshaller ().write (aSOT, aSVRLFile).isSuccess ())
              getLog ().info ("Successfully saved SVRL file '" + aSVRLFile.getPath () + "'");
            else
              getLog ().error ("Error saving SVRL file '" + aSVRLFile.getPath () + "'");
          }

          final ICommonsList <SVRLFailedAssert> aFailedAsserts = SVRLHelper.getAllFailedAssertions (aSOT);
          if (bExpectSuccess)
          {
            // No failed assertions expected
            if (aFailedAsserts.isNotEmpty ())
            {
              final String sMessage = aFailedAsserts.size () +
                                      " failed Schematron assertions for XML file '" +
                                      aXMLFile.getPath () +
                                      "'";
              getLog ().error (sMessage);
              aFailedAsserts.forEach (x -> getLog ().error (x.getAsResourceError (aXMLFile.getPath ())
                                                             .getAsString (Locale.US)));
              if (m_bFailFast)
                throw new MojoFailureException (sMessage);
              aErrorMessages.add (sMessage);
            }
          }
          else
          {
            // At least one failed assertions expected
            if (aFailedAsserts.isEmpty ())
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
      if (StringHelper.hasNoText (m_sXmlIncludes))
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
      if (StringHelper.hasNoText (m_sXmlErrorIncludes))
        throw new MojoExecutionException ("No erroneous XML include pattern specified!");

      if (m_aSvrlErrorDirectory != null)
      {
        if (!m_aSvrlErrorDirectory.exists () && !m_aSvrlErrorDirectory.mkdirs ())
          throw new MojoExecutionException ("Failed to create the erroneous SVRL directory " + m_aSvrlErrorDirectory);
      }
    }

    // 1. Parse Schematron file
    final Locale aDisplayLocale = Locale.US;
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
        if (aError.getErrorLevel ().isGE (EErrorLevel.ERROR))
        {
          getLog ().error ("Error in Schematron: " + aError.getAsString (aDisplayLocale));
          bAnyError = true;
        }
        else
          if (aError.getErrorLevel ().isGE (EErrorLevel.WARN))
            getLog ().warn ("Warning in Schematron: " + aError.getAsString (aDisplayLocale));
      if (bAnyError)
        throw new MojoExecutionException ("The provided Schematron file contains errors. See log for details.");
    }
    getLog ().info ("Successfully parsed Schematron file '" + m_aSchematronFile.getPath () + "'");

    // 2. for all XML files that match the pattern
    final ICommonsList <String> aErrorMessages = new CommonsArrayList <> ();
    if (m_aXmlDirectory != null)
    {
      _performValidation (aSch,
                          m_aXmlDirectory,
                          m_sXmlIncludes,
                          m_sXmlExcludes,
                          m_aSvrlDirectory,
                          true,
                          aErrorMessages);
    }
    if (m_aXmlErrorDirectory != null)
    {
      _performValidation (aSch,
                          m_aXmlErrorDirectory,
                          m_sXmlErrorIncludes,
                          m_sXmlErrorExcludes,
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
