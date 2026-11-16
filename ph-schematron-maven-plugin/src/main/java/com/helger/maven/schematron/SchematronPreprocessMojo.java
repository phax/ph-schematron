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

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.jspecify.annotations.NonNull;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.misc.Since;
import com.helger.base.string.StringHelper;
import com.helger.schematron.SchematronException;
import com.helger.schematron.enginefactory.SchematronFilePreprocessor;

/**
 * Applies Schematron preprocessing
 *
 * @author Philip Helger
 * @since 5.0.9
 */
@NotThreadSafe
@Mojo (name = "preprocess", defaultPhase = LifecyclePhase.GENERATE_RESOURCES, threadSafe = true)
public final class SchematronPreprocessMojo extends AbstractMojo
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
   * Overwrite existing Schematron files without notice? If this is set to <code>false</code> than
   * existing Schematron files are not overwritten.
   */
  @Parameter (name = "overwriteWithoutNotice", defaultValue = "true")
  private boolean m_bOverwriteWithoutNotice = SchematronFilePreprocessor.DEFAULT_OVERWRITE;

  /**
   * If this is set to <code>false</code> than <code>&lt;title&gt;</code> elements will be removed.
   */
  @Parameter (name = "keepTitles", defaultValue = "false")
  private boolean m_bKeepTitles = SchematronFilePreprocessor.DEFAULT_KEEP_TITLES;

  /**
   * If this is set to <code>false</code> than <code>&lt;diagnostics&gt;</code> elements will be
   * removed.
   */
  @Parameter (name = "keepDiagnostics", defaultValue = "false")
  private boolean m_bKeepDiagnostics = SchematronFilePreprocessor.DEFAULT_KEEP_DIAGNOSTICS;

  /**
   * Should <code>&lt;report&gt;</code> elements be kept or should they be converted to
   * <code>&lt;assert&gt;</code> elements?
   */
  @Parameter (name = "keepReports", defaultValue = "false")
  private boolean m_bKeepReports = SchematronFilePreprocessor.DEFAULT_KEEP_REPORTS;

  /**
   * Should <code>&lt;pattern&gt;</code> elements without a single rule be kept or deleted?
   */
  @Parameter (name = "keepEmptyPatterns", defaultValue = "false")
  private boolean m_bKeepEmptyPatterns = SchematronFilePreprocessor.DEFAULT_KEEP_EMPTY_PATTERNS;

  /**
   * A constant header string that should be added to all preprocessed SCH files, e.g. as a version
   * number etc.
   */
  @Parameter (name = "schHeader")
  @Since ("6.2.2")
  private String m_sSCHHeader;

  public void setSourceFile (@NonNull final File aFile)
  {
    m_aSourceFile = aFile;
    if (!m_aSourceFile.isAbsolute ())
      m_aSourceFile = new File (project.getBasedir (), aFile.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Using Source file '" + m_aSourceFile + "'");
  }

  public void setTargetFile (@NonNull final File aFile)
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

  public void setSchHeader (final String s)
  {
    m_sSCHHeader = s;
    if (StringHelper.isNotEmpty (m_sSCHHeader))
      getLog ().debug ("Using the SCH header '" + m_sSCHHeader + "'");
    else
      getLog ().debug ("No SCH header is configured");
  }

  public void execute () throws MojoExecutionException, MojoFailureException
  {
    if (m_aSourceFile == null)
      throw new MojoExecutionException ("No Source file specified!");
    if (m_aSourceFile.exists () && !m_aSourceFile.isFile ())
      throw new MojoExecutionException ("The specified Source file " + m_aSourceFile + " is not a file!");
    if (m_aTargetFile == null)
      throw new MojoExecutionException ("No Target file specified!");

    try
    {
      new SchematronFilePreprocessor (new MavenLogHandler (getLog ())).setKeepTitles (m_bKeepTitles)
                                                                      .setKeepDiagnostics (m_bKeepDiagnostics)
                                                                      .setKeepReports (m_bKeepReports)
                                                                      .setKeepEmptyPatterns (m_bKeepEmptyPatterns)
                                                                      .setSchHeader (m_sSCHHeader)
                                                                      .setOverwrite (m_bOverwriteWithoutNotice)
                                                                      .preprocessFile (m_aSourceFile, m_aTargetFile);
    }
    catch (final SchematronException ex)
    {
      throw new MojoExecutionException ("Error preprocessing Schematron file '" + m_aSourceFile + "'", ex);
    }
  }
}
