/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
import java.io.OutputStream;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.xml.XMLConstants;
import javax.xml.transform.ErrorListener;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.util.DirectoryScanner;
import org.sonatype.plexus.build.incremental.BuildContext;
import org.w3c.dom.Document;

import com.helger.annotation.misc.Since;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.annotation.style.VisibleForTesting;
import com.helger.base.CGlobal;
import com.helger.base.concurrent.ExecutorServiceHelper;
import com.helger.base.concurrent.ThreadHelper;
import com.helger.base.string.StringHelper;
import com.helger.base.wrapper.Wrapper;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.io.file.FileHelper;
import com.helger.io.file.FilenameHelper;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.sch.SchematronProviderXSLTFromSCH;
import com.helger.schematron.sch.TransformerCustomizerSCH;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.XMLHelper;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

/**
 * Converts one or more Schematron schema files into XSLT scripts.
 *
 * @author PEPPOL.AT, BRZ, Philip Helger
 */
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
  private boolean m_bForceCacheResult = TransformerCustomizerSCH.DEFAULT_FORCE_CACHE_RESULT;

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

  public void setSchematronDirectory (@Nonnull final File aDir)
  {
    m_aSchematronDirectory = aDir;
    if (!m_aSchematronDirectory.isAbsolute ())
      m_aSchematronDirectory = new File (project.getBasedir (), aDir.getPath ());
    getLog ().debug ("Searching Schematron files in the directory '" + m_aSchematronDirectory + "'");
  }

  public void setSchematronPattern (@Nonnull final String sPattern)
  {
    m_sSchematronPattern = sPattern;
    getLog ().debug ("Setting Schematron pattern to '" + sPattern + "'");
  }

  public void setXsltDirectory (@Nonnull final File aDir)
  {
    m_aXsltDirectory = aDir;
    if (!m_aXsltDirectory.isAbsolute ())
      m_aXsltDirectory = new File (project.getBasedir (), aDir.getPath ());
    getLog ().debug ("Writing XSLT files into directory '" + m_aXsltDirectory + "'");
  }

  public void setXsltExtension (@Nonnull final String sExt)
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

  @Nonnull
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

        // 2. The Schematron resource
        final IReadableResource aSchematronResource = new FileSystemResource (aFile);

        // 3. Check if the XSLT file already exists
        if (aXSLTFile.exists () && !m_bOverwriteWithoutQuestion)
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
              final String sMessage = "Failed to convert '" +
                                      aFile.getPath () +
                                      "' because directory '" +
                                      aXsltFileDirectory.getPath () +
                                      "' could not be created";
              getLog ().error (sMessage);
              throw new MojoFailureException (sMessage);
            }
          }

          // 3.3 The main SCH to XSLT conversion
          final Wrapper <MojoFailureException> fe = new Wrapper <> ();
          final Wrapper <MojoExecutionException> ee = new Wrapper <> ();
          final Runnable r = () -> {
            try
            {
              buildContext.removeMessages (aFile);
              // Custom error listener to log to the Mojo logger
              final ErrorListener aMojoErrorListener = new PluginErrorListener (buildContext, aFile);

              // Custom error listener
              // No custom URI resolver
              // Specified phase - default = null
              // Specified language code - default = null
              final TransformerCustomizerSCH aCustomizer = new TransformerCustomizerSCH ().setErrorListener (aMojoErrorListener)
                                                                                          .setPhase (m_sPhaseName)
                                                                                          .setLanguageCode (m_sLanguageCode)
                                                                                          .setParameters (m_aCustomParameters)
                                                                                          .setForceCacheResult (m_bForceCacheResult);

              getLog ().debug ("Compiling Schematron instance " + aSchematronResource.toString ());

              final Document aXsltDoc = SchematronProviderXSLTFromSCH.createSchematronXSLT (aSchematronResource,
                                                                                            aCustomizer);
              if (aXsltDoc != null)
              {
                if (StringHelper.isNotEmpty (m_sXSLTHeader))
                {
                  // Inject the header into the XSLT
                  aXsltDoc.insertBefore (aXsltDoc.createComment (m_sXSLTHeader), aXsltDoc.getDocumentElement ());
                }

                // Write the resulting XSLT file to disk
                final MapBasedNamespaceContext aNSContext = new MapBasedNamespaceContext ().addMapping ("svrl",
                                                                                                        CSVRL.SVRL_NAMESPACE_URI);
                // Add all namespaces from XSLT document root
                final String sNSPrefix = XMLConstants.XMLNS_ATTRIBUTE + ":";
                XMLHelper.forAllAttributes (aXsltDoc.getDocumentElement (), (sAttrName, sAttrValue) -> {
                  if (sAttrName.startsWith (sNSPrefix))
                    aNSContext.addMapping (sAttrName.substring (sNSPrefix.length ()), sAttrValue);
                });

                final XMLWriterSettings aXWS = new XMLWriterSettings ().setNamespaceContext (aNSContext)
                                                                       .setPutNamespaceContextPrefixesInRoot (true);

                final OutputStream aOS = FileHelper.getOutputStream (aXSLTFile);
                if (aOS == null)
                  throw new IllegalStateException ("Failed to open output stream for file " +
                                                   aXSLTFile.getAbsolutePath ());
                XMLWriter.writeToStream (aXsltDoc, aOS, aXWS);

                getLog ().debug ("Finished creating XSLT file '" + aXSLTFile.getPath () + "'");

                buildContext.refresh (aXsltFileDirectory);
              }
              else
              {
                final String message = "Failed to convert '" +
                                       aFile.getPath () +
                                       "': the Schematron resource is invalid";
                getLog ().error (message);
                throw new MojoFailureException (message);
              }
            }
            catch (final MojoFailureException up)
            {
              fe.set (up);
            }
            catch (final Exception ex)
            {
              final String sMessage = "Failed to convert '" +
                                      aFile.getPath () +
                                      "' to XSLT file '" +
                                      aXSLTFile.getPath () +
                                      "'";
              getLog ().error (sMessage, ex);
              ee.set (new MojoExecutionException (sMessage, ex));
            }
          };

          if (m_bShowProgress)
          {
            // Run conversion in one thread and run another thread that logs the
            // time
            final ExecutorService aES = Executors.newSingleThreadExecutor ();
            aES.submit (r);

            final long nStartTime = System.currentTimeMillis ();
            final AtomicBoolean aLoggedAnything = new AtomicBoolean (false);
            final Thread t = new Thread ( () -> {
              long nLastSecs = 0;
              while (!Thread.currentThread ().isInterrupted ())
              {
                if (ThreadHelper.sleep (500).isSuccess ())
                {
                  final long nDurationSecs = (System.currentTimeMillis () - nStartTime) /
                                             CGlobal.MILLISECONDS_PER_SECOND;
                  // Log only every x seconds
                  if (nDurationSecs >= nLastSecs + 5)
                  {
                    getLog ().info ("Schematron conversion of '" +
                                    aFile.getName () +
                                    "' already takes " +
                                    nDurationSecs +
                                    " seconds - please wait...");
                    nLastSecs = nDurationSecs;
                    aLoggedAnything.set (true);
                  }
                }
              }
            });
            t.setDaemon (true);
            t.start ();
            ExecutorServiceHelper.shutdownAndWaitUntilAllTasksAreFinished (aES);
            t.interrupt ();
            if (aLoggedAnything.get ())
            {
              // Log finalization of conversion if it took longer
              final long nDurationSecs = (System.currentTimeMillis () - nStartTime) / CGlobal.MILLISECONDS_PER_SECOND;
              getLog ().info ("Schematron conversion of '" +
                              aFile.getName () +
                              "' was finalized after " +
                              nDurationSecs +
                              " seconds");
            }
          }
          else
          {
            // No progress version
            r.run ();
          }

          // Did any exceptions occur?
          if (fe.isSet ())
          {
            if (m_bStopOnError)
              throw fe.get ();
            getLog ().warn ("Received an error, but continuing anyway", fe.get ());
          }
          if (ee.isSet ())
          {
            if (m_bStopOnError)
              throw ee.get ();
            getLog ().warn ("Received an error, but continuing anyway", ee.get ());
          }
        }
      }
    }
  }
}
