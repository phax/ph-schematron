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
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.string.StringHelper;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.SchematronException;
import com.helger.schematron.streamability.EStreamabilityClass;
import com.helger.schematron.streamability.SchematronStreamabilityAnalyzer;
import com.helger.schematron.streamability.SchematronStreamabilityReport;

/**
 * Reports per rule whether a Schematron can be validated while streaming the instance document (motionless, burst or
 * non-local), and optionally fails the build if the schema needs more than a maximum class. The analysis is a property
 * of the schema and holds for every engine.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
@Mojo (name = "streamability", defaultPhase = LifecyclePhase.PROCESS_RESOURCES, threadSafe = true)
public final class SchematronStreamabilityMojo extends AbstractMojo
{
  /**
   * The Maven Project.
   */
  @Parameter (defaultValue = "${project}", readonly = true)
  private MavenProject project;

  /**
   * The Schematron file to be analysed.
   */
  @Parameter (name = "schematronFile", required = true)
  private File m_aSchematronFile;

  /**
   * The worst streamability class the Schematron may have: <code>motionless</code>, <code>burst</code> or
   * <code>non-local</code>. If the Schematron needs more, the build fails. If it is not set, the report is only
   * logged.
   */
  @Parameter (name = "maximumClass")
  private String m_sMaximumClass;

  public void setSchematronFile (@NonNull final File aFile)
  {
    m_aSchematronFile = aFile;
    if (!m_aSchematronFile.isAbsolute ())
      m_aSchematronFile = new File (project.getBasedir (), aFile.getPath ());
    if (getLog ().isDebugEnabled ())
      getLog ().debug ("Using Schematron file '" + m_aSchematronFile + "'");
  }

  public void setMaximumClass (@Nullable final String sMaximumClass)
  {
    m_sMaximumClass = sMaximumClass;
    if (StringHelper.isNotEmpty (sMaximumClass))
      getLog ().debug ("Using the maximum streamability class '" + sMaximumClass + "'");
    else
      getLog ().debug ("No maximum streamability class is configured");
  }

  public void execute () throws MojoExecutionException, MojoFailureException
  {
    if (m_aSchematronFile == null)
      throw new MojoExecutionException ("No Schematron file specified!");
    if (!m_aSchematronFile.isFile ())
      throw new MojoExecutionException ("The specified Schematron file " + m_aSchematronFile + " is not a file!");

    EStreamabilityClass eMaximumClass = null;
    if (StringHelper.isNotEmpty (m_sMaximumClass))
    {
      eMaximumClass = EStreamabilityClass.getFromIDOrNull (m_sMaximumClass);
      if (eMaximumClass == null)
        throw new MojoExecutionException ("The maximum streamability class '" +
                                          m_sMaximumClass +
                                          "' is unknown. Use one of 'motionless', 'burst' or 'non-local'.");
    }

    final SchematronStreamabilityReport aReport;
    try
    {
      aReport = SchematronStreamabilityAnalyzer.analyze (new FileSystemResource (m_aSchematronFile));
    }
    catch (final SchematronException ex)
    {
      throw new MojoExecutionException ("Error analysing the streamability of Schematron file '" +
                                        m_aSchematronFile +
                                        "'",
                                        ex);
    }

    getLog ().info ("Streamability of Schematron file '" + m_aSchematronFile.getPath () + "': " + aReport.getSummaryText ());
    for (final String sFinding : aReport.getAllFindingTexts ())
      getLog ().info ("  " + sFinding);

    if (eMaximumClass != null && aReport.getStreamabilityClass ().isWorseThan (eMaximumClass))
      throw new MojoFailureException ("The Schematron file '" +
                                      m_aSchematronFile +
                                      "' is " +
                                      aReport.getStreamabilityClass ().getID () +
                                      ", but at most " +
                                      eMaximumClass.getID () +
                                      " is allowed");
  }
}
