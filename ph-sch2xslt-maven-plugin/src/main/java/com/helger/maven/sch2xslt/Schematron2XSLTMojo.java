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
package com.helger.maven.sch2xslt;

import java.io.File;
import java.io.OutputStream;
import java.util.Locale;

import javax.annotation.Nonnull;
import javax.xml.transform.ErrorListener;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.util.DirectoryScanner;
import org.slf4j.impl.StaticLoggerBinder;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.commons.error.IError;
import com.helger.commons.io.file.FileHelper;
import com.helger.commons.io.file.FilenameHelper;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.svrl.CSVRL;
import com.helger.schematron.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.xslt.SCHTransformerCustomizer;
import com.helger.schematron.xslt.SchematronResourceSCHCache;
import com.helger.xml.CXML;
import com.helger.xml.XMLHelper;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;
import com.helger.xml.transform.AbstractTransformErrorListener;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;

/**
 * Converts one or more Schematron schema files into XSLT scripts.
 *
 * @goal convert
 * @phase generate-resources
 * @author PEPPOL.AT, BRZ, Philip Helger
 */
@SuppressFBWarnings ({ "NP_UNWRITTEN_FIELD", "UWF_UNWRITTEN_FIELD" })
public final class Schematron2XSLTMojo extends AbstractMojo
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
   * The directory where the Schematron files reside.
   *
   * @parameter property="schematronDirectory"
   *            default-value="${basedir}/src/main/schematron"
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
   * @parameter property="xsltDirectory"
   *            default-value="${basedir}/src/main/xslt"
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

  public void setSchematronDirectory (@Nonnull final File aDir)
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

  public void setXsltDirectory (@Nonnull final File aDir)
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
    if (StringHelper.hasNoText (schematronPattern))
      throw new MojoExecutionException ("No Schematron pattern specified!");
    if (xsltDirectory == null)
      throw new MojoExecutionException ("No XSLT directory specified!");
    if (xsltDirectory.exists () && !xsltDirectory.isDirectory ())
      throw new MojoExecutionException ("The specified XSLT directory " + xsltDirectory + " is not a directory!");
    if (StringHelper.hasNoText (xsltExtension) || !xsltExtension.startsWith ("."))
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
            buildContext.removeMessages (aFile);
            // Custom error listener to log to the Mojo logger
            final ErrorListener aMojoErrorListener = new PluginErrorListener (aFile);

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
              final MapBasedNamespaceContext aNSContext = new MapBasedNamespaceContext ().addMapping ("svrl",
                                                                                                      CSVRL.SVRL_NAMESPACE_URI);
              // Add all namespaces from XSLT document root
              final String sNSPrefix = CXML.XML_ATTR_XMLNS + ":";
              XMLHelper.getAllAttributesAsMap (aXsltProvider.getXSLTDocument ().getDocumentElement ())
                       .forEach ( (sAttrName, sAttrValue) -> {
                         if (sAttrName.startsWith (sNSPrefix))
                           aNSContext.addMapping (sAttrName.substring (sNSPrefix.length ()), sAttrValue);
                       });

              final XMLWriterSettings aXWS = new XMLWriterSettings ();
              aXWS.setNamespaceContext (aNSContext).setPutNamespaceContextPrefixesInRoot (true);

              final OutputStream aOS = FileHelper.getOutputStream (aXSLTFile);
              if (aOS == null)
                throw new IllegalStateException ("Failed to open output stream for file " +
                                                 aXSLTFile.getAbsolutePath ());
              XMLWriter.writeToStream (aXsltProvider.getXSLTDocument (), aOS, aXWS);
              buildContext.refresh (aXsltFileDirectory);
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
            final String sMessage = "Failed to convert '" +
                                    aFile.getPath () +
                                    "' to XSLT file '" +
                                    aXSLTFile.getPath () +
                                    "'";
            getLog ().error (sMessage, ex);
            throw new MojoExecutionException (sMessage, ex);
          }
        }
      }
    }
  }
}
