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
package com.helger.schematron.ant;

import java.io.File;

import org.apache.tools.ant.BuildException;
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
 * ANT task that reports per rule whether a Schematron can be validated while streaming the instance document
 * (motionless, burst or non-local), and optionally fails if the schema needs more than a maximum class. The analysis is
 * a property of the schema and holds for every engine.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
public class SchematronStreamability extends AbstractSchematronTask
{
  /**
   * The Schematron file to be analysed.
   */
  private File m_aSchematronFile;

  /**
   * The worst streamability class the Schematron may have, or <code>null</code> to only report.
   */
  private EStreamabilityClass m_eMaximumClass;

  /**
   * The text of the maximum class as configured, for the error message of an unknown one.
   */
  private String m_sMaximumClass;

  public SchematronStreamability ()
  {}

  public void setSchematronFile (@NonNull final File aFile)
  {
    m_aSchematronFile = aFile;
    if (!m_aSchematronFile.isAbsolute ())
      m_aSchematronFile = new File (getProject ().getBaseDir (), aFile.getPath ());
    _debug ("Using Schematron file '" + m_aSchematronFile + "'");
  }

  /**
   * @param sMaximumClass
   *        The worst streamability class the Schematron may have: <code>motionless</code>, <code>burst</code> or
   *        <code>non-local</code>. If the Schematron needs more, the task fails.
   */
  public void setMaximumClass (@Nullable final String sMaximumClass)
  {
    m_sMaximumClass = sMaximumClass;
    m_eMaximumClass = EStreamabilityClass.getFromIDOrNull (sMaximumClass);
    _debug ("Using the maximum streamability class '" + sMaximumClass + "'");
  }

  @Override
  public void execute () throws BuildException
  {
    boolean bCanRun = false;
    if (m_aSchematronFile == null)
      _errorOrFail ("No Schematron file specified!");
    else
      if (!m_aSchematronFile.isFile ())
        _errorOrFail ("The specified Schematron file " + m_aSchematronFile + " is not a file!");
      else
        if (StringHelper.isNotEmpty (m_sMaximumClass) && m_eMaximumClass == null)
          _errorOrFail ("The maximum streamability class '" +
                        m_sMaximumClass +
                        "' is unknown. Use one of 'motionless', 'burst' or 'non-local'.");
        else
          bCanRun = true;

    if (bCanRun)
      try
      {
        final SchematronStreamabilityReport aReport = SchematronStreamabilityAnalyzer.analyze (new FileSystemResource (m_aSchematronFile));
        _info ("Streamability of Schematron " + m_aSchematronFile + ": " + aReport.getSummaryText ());
        for (final String sFinding : aReport.getAllFindingTexts ())
          _info ("  " + sFinding);

        if (m_eMaximumClass != null && aReport.getStreamabilityClass ().isWorseThan (m_eMaximumClass))
          _errorOrFail ("The Schematron " +
                        m_aSchematronFile +
                        " is " +
                        aReport.getStreamabilityClass ().getID () +
                        ", but at most " +
                        m_eMaximumClass.getID () +
                        " is allowed");
      }
      catch (final SchematronException ex)
      {
        _errorOrFail ("Error analysing the streamability of Schematron " + m_aSchematronFile.getAbsolutePath (), ex);
      }
  }
}
