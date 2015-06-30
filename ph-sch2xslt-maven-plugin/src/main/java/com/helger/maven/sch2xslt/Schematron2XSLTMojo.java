/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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
package com.helger.maven.sch2xslt;

import java.io.File;
import java.util.Locale;

import javax.annotation.Nonnull;
import javax.xml.transform.ErrorListener;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.util.DirectoryScanner;
import org.slf4j.impl.StaticLoggerBinder;

import com.helger.commons.error.IResourceError;
import com.helger.commons.io.file.FileHelper;
import com.helger.commons.io.file.FilenameHelper;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.xml.serialize.write.XMLWriter;
import com.helger.commons.xml.transform.AbstractTransformErrorListener;
import com.helger.schematron.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.xslt.SCHTransformerCustomizer;
import com.helger.schematron.xslt.SchematronResourceSCHCache;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;

/**
 * Converts one or more Schematron schema files into XSLT scripts.
 *
 * @goal convert
 * @phase generate-resources
 * @author PEPPOL.AT, BRZ, Philip Helger
 */
public final class Schematron2XSLTMojo extends AbstractMojo
{
  public final class PluginErrorListener extends AbstractTransformErrorListener
  {
    @Override
    protected void internalLog (@Nonnull final IResourceError aResError)
    {
      if (aResError.isError ())
        getLog ().error (aResError.getAsString (Locale.US), aResError.getLinkedException ());
      else
        getLog ().warn (aResError.getAsString (Locale.US), aResError.getLinkedException ());
    }
  }

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
   * The directory where the Schematron files reside.
   *
   * @parameter property="schematronDirectory"
   *            default="${basedir}/src/main/schematron"
   */
  private File schematronDirectory;

  /**
   * A pattern for the Schematron files. Can contain Ant-style wildcards and
   * double wildcards. All files that match the pattern will be converted. Files
   * in the schematronDirectory and its subdirectories will be considered.
   *
   * @parameter property="schematronPattern" default-value="**\/*.sch"
   */
  private String schematronPattern;

  /**
   * The directory where the XSLT files will be saved.
   *
   * @required
   * @parameter property="xsltDirectory" default="${basedir}/src/main/xslt"
   */
  private File xsltDirectory;

  /**
   * The file extension of the created XSLT files.
   *
   * @parameter property="xsltExtension" default-value=".xslt"
   */
  private String xsltExtension;

  /**
   * Overwrite existing Schematron files without notice? If this is set to
   * <code>false</code> than existing XSLT files are not overwritten.
   *
   * @parameter property="overwrite" default-value="true"
   */
  private boolean overwriteWithoutQuestion = true;

  /**
   * Define the phase to be used for XSLT creation. By default the
   * <code>defaultPhase</code> attribute of the Schematron file is used.
   *
   * @parameter property="phaseName"
   */
  private String phaseName;

  /**
   * Define the language code for the XSLT creation. Default is English.
   * Supported language codes are: cs, de, en, fr, nl.
   *
   * @parameter property="languageCode"
   */
  private String languageCode;

  public void setSchematronDirectory (final File aDir)
  {
    schematronDirectory = aDir;
    if (!schematronDirectory.isAbsolute ())
      schematronDirectory = new File (project.getBasedir (), aDir.getPath ());
    getLog ().debug ("Searching Schematron files in the directory '" + schematronDirectory + "'");
  }

  public void setSchematronPattern (final String sPattern)
  {
    schematronPattern = sPattern;
    getLog ().debug ("Setting Schematron pattern to '" + sPattern + "'");
  }

  public void setXsltDirectory (final File aDir)
  {
    xsltDirectory = aDir;
    if (!xsltDirectory.isAbsolute ())
      xsltDirectory = new File (project.getBasedir (), aDir.getPath ());
    getLog ().debug ("Writing XSLT files into directory '" + xsltDirectory + "'");
  }

  public void setXsltExtension (final String sExt)
  {
    xsltExtension = sExt;
    getLog ().debug ("Setting XSLT file extension to '" + sExt + "'");
  }

  public void setOverwriteWithoutQuestion (final boolean bOverwrite)
  {
    overwriteWithoutQuestion = bOverwrite;
    if (overwriteWithoutQuestion)
      getLog ().debug ("Overwriting XSLT files without notice");
    else
      getLog ().debug ("Ignoring existing Schematron files");
  }

  public void setPhaseName (final String sPhaseName)
  {
    phaseName = sPhaseName;
    if (phaseName == null)
      getLog ().debug ("Using default phase");
    else
      getLog ().debug ("Using the phase '" + phaseName + "'");
  }

  public void setLanguageCode (final String sLanguageCode)
  {
    languageCode = sLanguageCode;
    if (languageCode == null)
      getLog ().debug ("Using default language code");
    else
      getLog ().debug ("Using the language code '" + languageCode + "'");
  }

  public void execute () throws MojoExecutionException, MojoFailureException
  {
    StaticLoggerBinder.getSingleton ().setMavenLog (getLog ());
    if (schematronDirectory == null)
      throw new MojoExecutionException ("No Schematron directory specified!");
    if (schematronDirectory.exists () && !schematronDirectory.isDirectory ())
      throw new MojoExecutionException ("The specified Schematron directory " +
                                        schematronDirectory +
                                        " is not a directory!");
    if (schematronPattern == null || schematronPattern.isEmpty ())
    {
      throw new MojoExecutionException ("No Schematron pattern specified!");
    }
    if (xsltDirectory == null)
      throw new MojoExecutionException ("No XSLT directory specified!");
    if (xsltDirectory.exists () && !xsltDirectory.isDirectory ())
      throw new MojoExecutionException ("The specified XSLT directory " + xsltDirectory + " is not a directory!");
    if (xsltExtension == null || xsltExtension.length () == 0 || !xsltExtension.startsWith ("."))
      throw new MojoExecutionException ("The XSLT extension '" + xsltExtension + "' is invalid!");

    if (!xsltDirectory.exists () && !xsltDirectory.mkdirs ())
      throw new MojoExecutionException ("Failed to create the XSLT directory " + xsltDirectory);

    // for all Schematron files that match the pattern
    final DirectoryScanner aScanner = new DirectoryScanner ();
    aScanner.setBasedir (schematronDirectory);
    aScanner.setIncludes (new String [] { schematronPattern });
    aScanner.setCaseSensitive (true);
    aScanner.scan ();
    final String [] aFilenames = aScanner.getIncludedFiles ();
    if (aFilenames != null)
    {
      for (final String sFilename : aFilenames)
      {
        final File aFile = new File (schematronDirectory, sFilename);

        // 1. build XSLT file name (outputdir + localpath with new extension)
        final File aXSLTFile = new File (xsltDirectory, FilenameHelper.getWithoutExtension (sFilename) + xsltExtension);

        getLog ().info ("Converting Schematron file '" +
                        aFile.getPath () +
                        "' to XSLT file '" +
                        aXSLTFile.getPath () +
                        "'");

        // 2. The Schematron resource
        final IReadableResource aSchematronResource = new FileSystemResource (aFile);

        // 3. Check if the XSLT file already exists
        if (aXSLTFile.exists () && !overwriteWithoutQuestion)
        {
          // 3.1 Not overwriting the existing file
          getLog ().debug ("Skipping XSLT file '" + aXSLTFile.getPath () + "' because it already exists!");
        }
        else
        {
          // 3.2 Create the directory, if necessary
          final File aXsltFileDirectory = aXSLTFile.getParentFile ();
          if (aXsltFileDirectory != null && !aXsltFileDirectory.exists ())
          {
            getLog ().debug ("Creating directory '" + aXsltFileDirectory.getPath () + "'");
            if (!aXsltFileDirectory.mkdirs ())
            {
              final String message = "Failed to convert '" +
                                     aFile.getPath () +
                                     "' because directory '" +
                                     aXsltFileDirectory.getPath () +
                                     "' could not be created";
              getLog ().error (message);
              throw new MojoFailureException (message);
            }
          }
          // 3.3 Okay, write the XSLT file
          try
          {
            // Custom error listener to log to the Mojo logger
            final ErrorListener aMojoErrorListener = new PluginErrorListener ();

            // Custom error listener
            // No custom URI resolver
            // Specified phase - default = null
            // Specified language code - default = null
            final ISchematronXSLTBasedProvider aXsltProvider = SchematronResourceSCHCache.createSchematronXSLTProvider (aSchematronResource,
                                                                                                                        new SCHTransformerCustomizer ().setErrorListener (aMojoErrorListener)
                                                                                                                                                       .setPhase (phaseName)
                                                                                                                                                       .setLanguageCode (languageCode));
            if (aXsltProvider != null)
            {
              // Write the resulting XSLT file to disk
              XMLWriter.writeToStream (aXsltProvider.getXSLTDocument (), FileHelper.getOutputStream (aXSLTFile));
            }
            else
            {
              final String message = "Failed to convert '" + aFile.getPath () + "': the Schematron resource is invalid";
              getLog ().error (message);
              throw new MojoFailureException (message);
            }
          }
          catch (final MojoFailureException up)
          {
            throw up;
          }
          catch (final Exception ex)
          {
            final String message = "Failed to convert '" +
                                   aFile.getPath () +
                                   "' to XSLT file '" +
                                   aXSLTFile.getPath () +
                                   "'";
            getLog ().error (message, ex);
            throw new MojoFailureException (message, ex);
          }
        }
      }
    }
  }
}
