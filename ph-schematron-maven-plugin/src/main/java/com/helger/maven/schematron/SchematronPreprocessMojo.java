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

import javax.annotation.Nonnull;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.slf4j.impl.StaticLoggerBinder;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.CSchematron;
import com.helger.schematron.SchematronException;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.PSQueryBindingRegistry;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.preprocess.PSPreprocessor;
import com.helger.schematron.pure.preprocess.SchematronPreprocessException;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.IXMLWriterSettings;
import com.helger.xml.serialize.write.XMLWriterSettings;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;

/**
 * Applies Schematron preprocessing
 *
 * @author Philip Helger
 */
@SuppressFBWarnings ({ "NP_UNWRITTEN_FIELD", "UWF_UNWRITTEN_FIELD" })
@Mojo (name = "preprocess", defaultPhase = LifecyclePhase.GENERATE_RESOURCES, threadSafe = true)
public final class SchematronPreprocessMojo extends AbstractMojo
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
   * The Schematron source file to be preprocessed
   */
  @Parameter (name = "sourceFile", required = true)
  private File m_aSourceFile;

  /**
   * The target preprocessed Schematron file.
   */
  @Parameter (name = "targetFile", required = true)
  private File m_aTargetFile;

  /**
   * Overwrite existing Schematron files without notice? If this is set to
   * <code>false</code> than existing XSLT files are not overwritten.
   */
  @Parameter (name = "overwriteWithoutNotice", defaultValue = "true")
  private boolean m_bOverwriteWithoutNotice;

  /**
   * If this is set to <code>false</code> than <code>&lt;title&gt;</code>
   * elements will be removed.
   */
  @Parameter (name = "keepTitles", defaultValue = "false")
  private boolean m_bKeepTitles;

  /**
   * If this is set to <code>false</code> than <code>&lt;diagnostics&gt;</code>
   * elements will be removed.
   */
  @Parameter (name = "keepDiagnostics", defaultValue = "false")
  private boolean m_bKeepDiagnostics;

  /**
   * Should <code>&lt;report&gt;</code> elements be kept or should they be
   * converted to &lt;assert&gt;-elements?
   */
  @Parameter (name = "keepReports", defaultValue = "false")
  private boolean m_bKeepReports;

  /**
   * Should <code>&lt;pattern&gt;</code> elements without a single rule be kept
   * or deleted?
   */
  @Parameter (name = "keepEmptyPatterns", defaultValue = "false")
  private boolean m_bKeepEmptyPatterns;

  public void setSourceFile (@Nonnull final File aFile)
  {
    m_aSourceFile = aFile;
    if (!m_aSourceFile.isAbsolute ())
      m_aSourceFile = new File (project.getBasedir (), aFile.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Using Source file '" + m_aSourceFile + "'");
  }

  public void setTargetFile (@Nonnull final File aFile)
  {
    m_aTargetFile = aFile;
    if (!m_aTargetFile.isAbsolute ())
      m_aTargetFile = new File (project.getBasedir (), aFile.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Using Target file '" + m_aTargetFile + "'");
  }

  public void setOverwriteWithoutNotice (final boolean bOverwrite)
  {
    m_bOverwriteWithoutNotice = bOverwrite;
    if (m_bOverwriteWithoutNotice)
      getLog ().debug ("Overwriting Target file without notice");
    else
      getLog ().debug ("Ignoring existing Target file");
  }

  public void setKeepTitles (final boolean bKeepTitles)
  {
    m_bKeepTitles = bKeepTitles;
    if (bKeepTitles)
      getLog ().debug ("Keeping <title> elements");
    else
      getLog ().debug ("Removing <title> elements");
  }

  public void setKeepDiagnostics (final boolean bKeepDiagnostics)
  {
    m_bKeepDiagnostics = bKeepDiagnostics;
    if (bKeepDiagnostics)
      getLog ().debug ("Keeping <diagnostic> elements");
    else
      getLog ().debug ("Removing <diagnostic> elements");
  }

  public void setKeepReports (final boolean bKeepReports)
  {
    m_bKeepReports = bKeepReports;
    if (bKeepReports)
      getLog ().debug ("Keeping <report> elements");
    else
      getLog ().debug ("Converting <report> to <assert> elements");
  }

  public void setKeepEmptyPatterns (final boolean bKeepEmptyPatterns)
  {
    m_bKeepEmptyPatterns = bKeepEmptyPatterns;
    if (bKeepEmptyPatterns)
      getLog ().debug ("Keeping <pattern> elements without rules");
    else
      getLog ().debug ("Removing <pattern> elements without rules");
  }

  public void execute () throws MojoExecutionException, MojoFailureException
  {
    StaticLoggerBinder.getSingleton ().setMavenLog (getLog ());
    if (m_aSourceFile == null)
      throw new MojoExecutionException ("No Source file specified!");
    if (m_aSourceFile.exists () && !m_aSourceFile.isFile ())
      throw new MojoExecutionException ("The specified Source file " + m_aSourceFile + " is not a file!");

    if (m_aTargetFile == null)
      throw new MojoExecutionException ("No Target file specified!");
    if (m_aTargetFile.exists ())
    {
      if (!m_bOverwriteWithoutNotice)
      {
        // 3.1 Not overwriting the existing file
        getLog ().debug ("Skipping Target file '" + m_aTargetFile.getPath () + "' because it already exists!");
      }
      else
      {
        if (!m_aTargetFile.isFile ())
          throw new MojoExecutionException ("The specified Target file " + m_aTargetFile + " is not a file!");
      }
    }

    try
    {
      final PSSchema aSchema = new PSReader (new FileSystemResource (m_aSourceFile), null, null).readSchema ();
      final IPSQueryBinding aQueryBinding = PSQueryBindingRegistry.getQueryBindingOfNameOrThrow (aSchema.getQueryBinding ());

      final PSPreprocessor aPreprocessor = new PSPreprocessor (aQueryBinding);
      aPreprocessor.setKeepTitles (m_bKeepTitles);
      aPreprocessor.setKeepDiagnostics (m_bKeepDiagnostics);
      aPreprocessor.setKeepReports (m_bKeepReports);
      aPreprocessor.setKeepEmptyPatterns (m_bKeepEmptyPatterns);

      // Pre-process
      final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);
      if (aPreprocessedSchema == null)
        throw new SchematronPreprocessException ("Failed to preprocess schema " +
                                                 aSchema +
                                                 " with query binding " +
                                                 aQueryBinding);

      // Convert to XML string
      final MapBasedNamespaceContext aNSCtx = new MapBasedNamespaceContext ();
      aNSCtx.addDefaultNamespaceURI (CSchematron.NAMESPACE_SCHEMATRON);
      aNSCtx.addMapping ("xsl", "http://www.w3.org/1999/XSL/Transform");
      aNSCtx.addMapping ("svrl", CSVRL.SVRL_NAMESPACE_URI);
      final IXMLWriterSettings XWS = new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN)
                                                             .setNamespaceContext (aNSCtx);
      if (MicroWriter.writeToFile (aPreprocessedSchema.getAsMicroElement (), m_aTargetFile, XWS).isSuccess ())
        getLog ().info ("Successfully wrote preprocessed Schematron file '" + m_aTargetFile.getPath () + "'");
      else
        getLog ().error ("Error writing preprocessed Schematron file to '" + m_aTargetFile.getPath () + "'");
    }
    catch (final SchematronException ex)
    {
      throw new MojoExecutionException ("Error preprocessing Schematron file '" + m_aSourceFile + "'", ex);
    }
  }
}
