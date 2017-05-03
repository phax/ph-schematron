/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.util.DirectoryScanner;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.slf4j.impl.StaticLoggerBinder;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.commons.collection.ext.ICommonsList;
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
import com.helger.schematron.svrl.SVRLWriter;
import com.helger.schematron.xslt.SchematronResourceSCH;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.xml.transform.AbstractTransformErrorListener;
import com.helger.xml.transform.CollectingTransformErrorListener;
import com.helger.xml.transform.TransformResultFactory;
import com.helger.xml.transform.TransformSourceFactory;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;

/**
 * Applies Schematron validation onto an XML file
 *
 * @goal validate
 * @phase process-resources
 * @author Philip Helger
 */
@SuppressFBWarnings ({ "NP_UNWRITTEN_FIELD", "UWF_UNWRITTEN_FIELD" })
public final class SchematronValidationMojo extends AbstractMojo
{
  public final class PluginErrorListener extends AbstractTransformErrorListener
  {
    private final File m_aSourceFile;

    public PluginErrorListener (@Nonnull final File aSource)
    {
      m_aSourceFile = aSource;
    }

    @Override
    protected void internalLog (@Nonnull final IError aResError)
    {
      final int nLine = aResError.getErrorLocation ().getLineNumber ();
      final int nColumn = aResError.getErrorLocation ().getColumnNumber ();
      final String sMessage = StringHelper.getImplodedNonEmpty (" - ",
                                                                aResError.getErrorText (Locale.US),
                                                                aResError.getLinkedExceptionMessage ());

      // 0 means undefined line/column
      buildContext.addMessage (m_aSourceFile,
                               nLine <= 0 ? 0 : nLine,
                               nColumn <= 0 ? 0 : nColumn,
                               sMessage,
                               aResError.isError () ? BuildContext.SEVERITY_ERROR : BuildContext.SEVERITY_WARNING,
                               aResError.getLinkedExceptionCause ());
    }
  }

  /**
   * BuildContext for m2e (it's a pass-though straight to the filesystem when
   * invoked from the Maven cli)
   *
   * @component
   */
  private BuildContext buildContext;

  /**
   * The Maven Project.
   *
   * @parameter property="project"
   * @required
   * @readonly
   */
  @SuppressFBWarnings ({ "NP_UNWRITTEN_FIELD", "UWF_UNWRITTEN_FIELD" })
  private MavenProject project;

  /**
   * The Schematron file. This may also be an XSLT file if it is precompiled.
   *
   * @parameter property="schematronFile"
   */
  private File schematronFile;

  /**
   * The processing engine to use. Can be one of the following:
   * <ul>
   * <li>pure - for SCH files</li>
   * <li>schematron - for SCH files that will be converted to XSLT and applied
   * from there.</li>
   * <li>xslt - apply pre-build XSLT files</li>
   * </ul>
   */
  private String schematronProcessingEngine = ESchematronMode.PURE.getID ();

  /**
   * The directory where the XML files reside that are expected to match the
   * Schematron rules.
   *
   * @parameter property="xmlDirectory"
   */
  private File xmlDirectory;

  /**
   * A pattern for the XML files that should be included. Can contain Ant-style
   * wildcards and double wildcards. All files that match the pattern will be
   * converted. Files in the xmlDirectory and its subdirectories will be
   * considered.
   *
   * @parameter property="xmlIncludes" default-value="**\/*.xml"
   */
  private String xmlIncludes;

  /**
   * A pattern for the XML files that should be excluded. Can contain Ant-style
   * wildcards and double wildcards. All files that match the pattern will NOT
   * be converted. Only files in the xmlDirectory and its subdirectories will be
   * considered.
   *
   * @parameter property="xmlExcludes"
   */
  private String xmlExcludes;

  /**
   * Define the phase to be used for Schematron validation. By default the
   * <code>defaultPhase</code> attribute of the Schematron file is used. This
   * phase name is only used if the processing engine <code>pure</code> or
   * <code>schematron</code> are used.
   *
   * @parameter property="phaseName"
   */
  private String phaseName;

  /**
   * Define the language code to be used for Schematron validation. Default is
   * English. Supported language codes are: cs, de, en, fr, nl.
   *
   * @parameter property="languageCode"
   */
  private String languageCode;

  /**
   * The SVRL path to write to. The filenames are based on the source XML
   * filenames.
   *
   * @parameter property="svrlDirectory"
   */
  private File svrlDirectory;

  public void setSchematronFile (@Nonnull final File aFile)
  {
    schematronFile = aFile;
    if (!schematronFile.isAbsolute ())
      schematronFile = new File (project.getBasedir (), aFile.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Using Schematron file '" + schematronFile + "'");
  }

  public void setSchematronProcessingEngine (@Nullable final String sEngine)
  {
    final ESchematronMode eMode = ESchematronMode.getFromIDOrNull (sEngine);
    schematronProcessingEngine = eMode == null ? null : eMode.getID ();
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Schematron processing mode set to '" + eMode + "'");
  }

  public void setXmlDirectory (@Nonnull final File aDir)
  {
    xmlDirectory = aDir;
    if (!xmlDirectory.isAbsolute ())
      xmlDirectory = new File (project.getBasedir (), aDir.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Searching XML files in the directory '" + xmlDirectory + "'");
  }

  public void setXmlIncludes (final String sPattern)
  {
    xmlIncludes = sPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting XML file includes to '" + sPattern + "'");
  }

  public void setXmlExcludes (final String sPattern)
  {
    xmlExcludes = sPattern;
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Setting XML file excludes to '" + sPattern + "'");
  }

  public void setPhaseName (final String sPhaseName)
  {
    phaseName = sPhaseName;

    if (getLog ().isDebugEnabled ())
      if (phaseName == null)
        getLog ().debug ("Using default phase");
      else
        getLog ().debug ("Using the phase '" + phaseName + "'");
  }

  public void setLanguageCode (final String sLanguageCode)
  {
    languageCode = sLanguageCode;

    if (getLog ().isDebugEnabled ())
      if (languageCode == null)
        getLog ().debug ("Using default language code");
      else
        getLog ().debug ("Using the language code '" + languageCode + "'");
  }

  public void setSvrlDirectory (@Nonnull final File aDir)
  {
    svrlDirectory = aDir;
    if (!svrlDirectory.isAbsolute ())
      svrlDirectory = new File (project.getBasedir (), aDir.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Writing SVRL files to directory '" + svrlDirectory + "'");
  }

  public void execute () throws MojoExecutionException, MojoFailureException
  {
    StaticLoggerBinder.getSingleton ().setMavenLog (getLog ());
    if (schematronFile == null)
      throw new MojoExecutionException ("No Schematron file specified!");
    if (schematronFile.exists () && !schematronFile.isFile ())
      throw new MojoExecutionException ("The specified Schematron file " + schematronFile + " is not a file!");
    if (schematronProcessingEngine == null)
      throw new MojoExecutionException ("An invalid Schematron processing instance is specified! Only one of the following values is allowed: " +
                                        StringHelper.getImplodedMapped (", ",
                                                                        ESchematronMode.values (),
                                                                        x -> "'" + x.getID () + "'"));
    if (xmlDirectory == null)
      throw new MojoExecutionException ("No XML directory specified!");
    if (xmlDirectory.exists () && !xmlDirectory.isDirectory ())
      throw new MojoExecutionException ("The specified XML directory " + xmlDirectory + " is not a directory!");
    if (StringHelper.hasNoText (xmlIncludes))
      throw new MojoExecutionException ("No XML include pattern specified!");

    if (svrlDirectory != null)
    {
      if (!svrlDirectory.exists () && !svrlDirectory.mkdirs ())
        throw new MojoExecutionException ("Failed to create the SVRL directory " + svrlDirectory);
    }

    // 1. Parse Schematron file
    final Locale aDisplayLocale = Locale.US;
    ISchematronResource aSch;
    IErrorList aSCHErrors;
    switch (ESchematronMode.getFromIDOrNull (schematronProcessingEngine))
    {
      case PURE:
      {
        // pure
        final CollectingPSErrorHandler aErrorHdl = new CollectingPSErrorHandler ();
        final SchematronResourcePure aRealSCH = new SchematronResourcePure (new FileSystemResource (schematronFile));
        aRealSCH.setPhase (phaseName);
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
        final SchematronResourceSCH aRealSCH = new SchematronResourceSCH (new FileSystemResource (schematronFile));
        aRealSCH.setPhase (phaseName);
        aRealSCH.setLanguageCode (languageCode);
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
        final SchematronResourceXSLT aRealSCH = new SchematronResourceXSLT (new FileSystemResource (schematronFile));
        // phase is ignored
        aRealSCH.setErrorListener (aErrorHdl);
        aRealSCH.isValidSchematron ();

        aSch = aRealSCH;
        aSCHErrors = aErrorHdl.getErrorList ();
        break;
      }
      default:
        throw new MojoExecutionException ("No handler for processing engine '" + schematronProcessingEngine + "'");
    }
    if (aSCHErrors != null)
    {
      // Error validating the Schematrons!!
      boolean bAnyError = false;
      for (final IError aError : aSCHErrors)
        if (aError.getErrorLevel ().isMoreOrEqualSevereThan (EErrorLevel.ERROR))
        {
          getLog ().error ("Error in Schematron: " + aError.getAsString (aDisplayLocale));
          bAnyError = true;
        }
        else
          if (aError.getErrorLevel ().isMoreOrEqualSevereThan (EErrorLevel.WARN))
            getLog ().warn ("Warning in Schematron: " + aError.getAsString (aDisplayLocale));
      if (bAnyError)
        throw new MojoExecutionException ("The provided Schematron file contains errors. See log for details.");
    }
    getLog ().info ("Successfully parsed Schematron file '" + schematronFile.getPath () + "'");

    // 2. for all XML files that match the pattern
    final DirectoryScanner aScanner = new DirectoryScanner ();
    aScanner.setBasedir (xmlDirectory);
    if (xmlIncludes != null)
      aScanner.setIncludes (new String [] { xmlIncludes });
    if (xmlExcludes != null)
      aScanner.setExcludes (new String [] { xmlExcludes });
    aScanner.setCaseSensitive (true);
    aScanner.scan ();
    final String [] aXMLFilenames = aScanner.getIncludedFiles ();
    if (aXMLFilenames != null)
    {
      for (final String sXMLFilename : aXMLFilenames)
      {
        final File aXMLFile = new File (xmlDirectory, sXMLFilename);

        // Validate XML file
        getLog ().info ("Validating XML file '" +
                        aXMLFile.getPath () +
                        "' against Schematron rules from '" +
                        schematronFile +
                        "'");
        try
        {
          final SchematronOutputType aSOT = aSch.applySchematronValidationToSVRL (TransformSourceFactory.create (aXMLFile));

          if (svrlDirectory != null)
          {
            // Save SVRL
            final File aSVRLFile = new File (svrlDirectory, sXMLFilename + ".svrl");
            if (!aSVRLFile.getParentFile ().mkdirs ())
              getLog ().error ("Failed to create parent directory of '" + aSVRLFile.getAbsolutePath () + "'!");

            if (SVRLWriter.writeSVRL (aSOT, TransformResultFactory.create (aSVRLFile)).isSuccess ())
              getLog ().info ("Successfully saved SVRL file '" + aSVRLFile.getPath () + "'");
            else
              getLog ().error ("Error saving SVRL file '" + aSVRLFile.getPath () + "'");
          }

          final ICommonsList <SVRLFailedAssert> aFailedAsserts = SVRLHelper.getAllFailedAssertions (aSOT);
          if (aFailedAsserts.isNotEmpty ())
          {
            final String sMessage = aFailedAsserts.size () +
                                    " failed Schematron assertions for XML file '" +
                                    aXMLFile.getPath () +
                                    "'";
            getLog ().error (sMessage);
            aFailedAsserts.forEach (x -> getLog ().error (x.getAsResourceError (aXMLFile.getPath ())
                                                           .getAsString (Locale.US)));
            throw new MojoFailureException (sMessage);
          }
        }
        catch (final MojoFailureException | MojoExecutionException up)
        {
          throw up;
        }
        catch (final Exception ex)
        {
          final String sMessage = "Exception validating XML '" +
                                  aXMLFile.getPath () +
                                  "' against Schematron rules from '" +
                                  schematronFile +
                                  "'";
          getLog ().error (sMessage, ex);
          throw new MojoExecutionException (sMessage, ex);
        }
      }
    }
  }
}
