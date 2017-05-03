/**
 * Copyright (C) 2017 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;

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
import com.helger.xml.transform.CollectingTransformErrorListener;
import com.helger.xml.transform.TransformResultFactory;
import com.helger.xml.transform.TransformSourceFactory;

public class Schematron extends Task
{
  /**
   * The Schematron file. This may also be an XSLT file if it is precompiled.
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
   */
  private File xmlDirectory;

  /**
   * A pattern for the XML files that should be included. Can contain Ant-style
   * wildcards and double wildcards. All files that match the pattern will be
   * converted. Files in the xmlDirectory and its subdirectories will be
   * considered.
   */
  private String xmlIncludes = "**/*.xml";

  /**
   * A pattern for the XML files that should be excluded. Can contain Ant-style
   * wildcards and double wildcards. All files that match the pattern will NOT
   * be converted. Only files in the xmlDirectory and its subdirectories will be
   * considered.
   */
  private String xmlExcludes;

  /**
   * The SVRL path to write to(for positive tests). The filenames are based on
   * the source XML filenames.
   */
  private File svrlDirectory;

  /**
   * The directory where the erroneous XML files reside that are expected to NOT
   * match the Schematron rules.
   */
  private File xmlErrorDirectory;

  /**
   * A pattern for the erroneous XML files that should be included. Can contain
   * Ant-style wildcards and double wildcards. All files that match the pattern
   * will be converted. Files in the xmlDirectory and its subdirectories will be
   * considered.
   */
  private String xmlErrorIncludes = "**/*.xml";

  /**
   * A pattern for the erroneous XML files that should be excluded. Can contain
   * Ant-style wildcards and double wildcards. All files that match the pattern
   * will NOT be converted. Only files in the xmlDirectory and its
   * subdirectories will be considered.
   */
  private String xmlErrorExcludes;

  /**
   * The SVRL path to write to (for negative tests). The filenames are based on
   * the source XML filenames.
   */
  private File svrlErrorDirectory;

  /**
   * Define the phase to be used for Schematron validation. By default the
   * <code>defaultPhase</code> attribute of the Schematron file is used. This
   * phase name is only used if the processing engine <code>pure</code> or
   * <code>schematron</code> are used.
   */
  private String phaseName;

  /**
   * Define the language code to be used for Schematron validation. Default is
   * English. Supported language codes are: cs, de, en, fr, nl.
   */
  private String languageCode;

  public void setSchematronFile (@Nonnull final File aFile)
  {
    schematronFile = aFile;
    if (!schematronFile.isAbsolute ())
      schematronFile = new File (getProject ().getBaseDir (), aFile.getPath ());
    log ("Using Schematron file '" + schematronFile + "'", Project.MSG_DEBUG);
  }

  public void setSchematronProcessingEngine (@Nullable final String sEngine)
  {
    final ESchematronMode eMode = ESchematronMode.getFromIDOrNull (sEngine);
    schematronProcessingEngine = eMode == null ? null : eMode.getID ();
    log ("Schematron processing mode set to '" + eMode + "'", Project.MSG_DEBUG);
  }

  public void setXmlDirectory (@Nonnull final File aDir)
  {
    xmlDirectory = aDir;
    if (!xmlDirectory.isAbsolute ())
      xmlDirectory = new File (getProject ().getBaseDir (), aDir.getPath ());
    log ("Searching XML files in the directory '" + xmlDirectory + "'", Project.MSG_DEBUG);
  }

  public void setXmlIncludes (@Nullable final String sPattern)
  {
    xmlIncludes = sPattern;
    log ("Setting XML file includes to '" + sPattern + "'", Project.MSG_DEBUG);
  }

  public void setXmlExcludes (@Nullable final String sPattern)
  {
    xmlExcludes = sPattern;
    log ("Setting XML file excludes to '" + sPattern + "'", Project.MSG_DEBUG);
  }

  public void setSvrlDirectory (@Nonnull final File aDir)
  {
    svrlDirectory = aDir;
    if (!svrlDirectory.isAbsolute ())
      svrlDirectory = new File (getProject ().getBaseDir (), aDir.getPath ());
    log ("Writing SVRL files to directory '" + svrlDirectory + "'", Project.MSG_DEBUG);
  }

  public void setXmlErrorDirectory (@Nonnull final File aDir)
  {
    xmlErrorDirectory = aDir;
    if (!xmlErrorDirectory.isAbsolute ())
      xmlErrorDirectory = new File (getProject ().getBaseDir (), aDir.getPath ());
    log ("Searching erroneous XML files in the directory '" + xmlDirectory + "'", Project.MSG_DEBUG);
  }

  public void setXmlErrorIncludes (@Nullable final String sPattern)
  {
    xmlErrorIncludes = sPattern;
    log ("Setting erroneous XML file includes to '" + sPattern + "'", Project.MSG_DEBUG);
  }

  public void setXmlErrorExcludes (@Nullable final String sPattern)
  {
    xmlErrorExcludes = sPattern;
    log ("Setting erroneous XML file excludes to '" + sPattern + "'", Project.MSG_DEBUG);
  }

  public void setSvrlErrorDirectory (@Nonnull final File aDir)
  {
    svrlErrorDirectory = aDir;
    if (!svrlErrorDirectory.isAbsolute ())
      svrlErrorDirectory = new File (getProject ().getBaseDir (), aDir.getPath ());
    log ("Writing erroneous SVRL files to directory '" + svrlErrorDirectory + "'", Project.MSG_DEBUG);
  }

  public void setPhaseName (@Nullable final String sPhaseName)
  {
    phaseName = sPhaseName;

    if (phaseName == null)
      log ("Using default phase", Project.MSG_DEBUG);
    else
      log ("Using the phase '" + phaseName + "'", Project.MSG_DEBUG);
  }

  public void setLanguageCode (@Nullable final String sLanguageCode)
  {
    languageCode = sLanguageCode;

    if (languageCode == null)
      log ("Using default language code", Project.MSG_DEBUG);
    else
      log ("Using the language code '" + languageCode + "'", Project.MSG_DEBUG);
  }

  @Override
  public void init () throws BuildException
  {
    super.init ();
  }

  private void _performValidation (@Nonnull final ISchematronResource aSch,
                                   @Nonnull final File aXMLDirectory,
                                   @Nullable final String sXMLIncludes,
                                   @Nullable final String sXMLExcludes,
                                   @Nullable final File aSVRLDirectory,
                                   final boolean bExpectSuccess) throws BuildException
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
        log ("Validating XML file '" +
             aXMLFile.getPath () +
             "' against Schematron rules from '" +
             schematronFile +
             "' expecting " +
             (bExpectSuccess ? "success" : "failure"),
             Project.MSG_INFO);
        try
        {
          final SchematronOutputType aSOT = aSch.applySchematronValidationToSVRL (TransformSourceFactory.create (aXMLFile));

          if (aSVRLDirectory != null)
          {
            // Save SVRL
            final File aSVRLFile = new File (aSVRLDirectory, sXMLFilename + ".svrl");
            if (!aSVRLFile.getParentFile ().mkdirs ())
              log ("Failed to create parent directory of '" + aSVRLFile.getAbsolutePath () + "'!", Project.MSG_ERR);

            if (SVRLWriter.writeSVRL (aSOT, TransformResultFactory.create (aSVRLFile)).isSuccess ())
              log ("Successfully saved SVRL file '" + aSVRLFile.getPath () + "'", Project.MSG_INFO);
            else
              log ("Error saving SVRL file '" + aSVRLFile.getPath () + "'", Project.MSG_ERR);
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
              log (sMessage, Project.MSG_ERR);
              aFailedAsserts.forEach (x -> log (x.getAsResourceError (aXMLFile.getPath ()).getAsString (Locale.US),
                                                Project.MSG_ERR));
              throw new BuildException (sMessage);
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
              log (sMessage, Project.MSG_ERR);
              throw new BuildException (sMessage);
            }
          }
        }
        catch (final BuildException up)
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
          log (sMessage, ex, Project.MSG_DEBUG);
          throw new BuildException (sMessage, ex);
        }
      }
    }
  }

  @Override
  public void execute () throws BuildException
  {
    if (schematronFile == null)
      throw new BuildException ("No Schematron file specified!");
    if (schematronFile.exists () && !schematronFile.isFile ())
      throw new BuildException ("The specified Schematron file " + schematronFile + " is not a file!");
    if (schematronProcessingEngine == null)
      throw new BuildException ("An invalid Schematron processing instance is specified! Only one of the following values is allowed: " +
                                StringHelper.getImplodedMapped (", ",
                                                                ESchematronMode.values (),
                                                                x -> "'" + x.getID () + "'"));
    if (xmlDirectory == null && xmlErrorDirectory == null)
      throw new BuildException ("No XML directory specified - positive or negative directory must be present!");

    if (xmlDirectory != null)
    {
      if (xmlDirectory.exists () && !xmlDirectory.isDirectory ())
        throw new BuildException ("The specified XML directory " + xmlDirectory + " is not a directory!");
      if (StringHelper.hasNoText (xmlIncludes))
        throw new BuildException ("No XML include pattern specified!");
      if (svrlDirectory != null)
      {
        if (!svrlDirectory.exists () && !svrlDirectory.mkdirs ())
          throw new BuildException ("Failed to create the SVRL directory " + svrlDirectory);
      }
    }

    if (xmlErrorDirectory != null)
    {
      if (xmlErrorDirectory.exists () && !xmlErrorDirectory.isDirectory ())
        throw new BuildException ("The specified erroneous XML directory " +
                                  xmlErrorDirectory +
                                  " is not a directory!");
      if (StringHelper.hasNoText (xmlErrorIncludes))
        throw new BuildException ("No erroneous XML include pattern specified!");

      if (svrlErrorDirectory != null)
      {
        if (!svrlErrorDirectory.exists () && !svrlErrorDirectory.mkdirs ())
          throw new BuildException ("Failed to create the erroneous SVRL directory " + svrlErrorDirectory);
      }
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
        throw new BuildException ("No handler for processing engine '" + schematronProcessingEngine + "'");
    }
    if (aSCHErrors != null)
    {
      // Error validating the Schematrons!!
      boolean bAnyError = false;
      for (final IError aError : aSCHErrors)
        if (aError.getErrorLevel ().isMoreOrEqualSevereThan (EErrorLevel.ERROR))
        {
          log ("Error in Schematron: " + aError.getAsString (aDisplayLocale), Project.MSG_ERR);
          bAnyError = true;
        }
        else
          if (aError.getErrorLevel ().isMoreOrEqualSevereThan (EErrorLevel.WARN))
            log ("Warning in Schematron: " + aError.getAsString (aDisplayLocale), Project.MSG_WARN);
      if (bAnyError)
        throw new BuildException ("The provided Schematron file contains errors. See log for details.");
    }
    log ("Successfully parsed Schematron file '" + schematronFile.getPath () + "'", Project.MSG_INFO);

    // 2. for all XML files that match the pattern
    if (xmlDirectory != null)
      _performValidation (aSch, xmlDirectory, xmlIncludes, xmlExcludes, svrlDirectory, true);
    if (xmlErrorDirectory != null)
      _performValidation (aSch, xmlErrorDirectory, xmlErrorIncludes, xmlErrorExcludes, svrlErrorDirectory, false);
  }
}
