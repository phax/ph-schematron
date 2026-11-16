/*
 * Copyright (C) 2017-2026 Philip Helger (www.helger.com)
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
import com.helger.schematron.SchematronException;
import com.helger.schematron.enginefactory.SchematronFilePreprocessor;

/**
 * ANT task to perform Schematron preprocessing. It converts an existing schema to the minimal
 * syntax (by default) but allows for a certain degree of customization by keeping certain elements
 * in the resulting schema. The actual query binding is used, so that report test expressions can be
 * converted to assertions, and to replace the content of &lt;param&gt; elements into actual values.
 *
 * @author Philip Helger
 * @since 5.0.0
 */
@NotThreadSafe
public class SchematronPreprocess extends AbstractSchematronTask
{
  /**
   * The Schematron source file to be pre-processed.
   */
  private File m_aSrcFile;

  /**
   * The Schematron destination file to be written.
   */
  private File m_aDstFile;

  /**
   * <code>true</code> if &lt;title&gt;-elements should be kept.
   */
  private boolean m_bKeepTitles = SchematronFilePreprocessor.DEFAULT_KEEP_TITLES;

  /**
   * <code>true</code> if &lt;diagnostic&gt;-elements should be kept.
   */
  private boolean m_bKeepDiagnostics = SchematronFilePreprocessor.DEFAULT_KEEP_DIAGNOSTICS;

  /**
   * Should &lt;report&gt;-elements be kept or should they be converted to &lt;assert&gt;-elements?
   */
  private boolean m_bKeepReports = SchematronFilePreprocessor.DEFAULT_KEEP_REPORTS;

  /**
   * Should &lt;pattern&gt;-elements without a single rule be kept or deleted?
   */
  private boolean m_bKeepEmptyPatterns = SchematronFilePreprocessor.DEFAULT_KEEP_EMPTY_PATTERNS;

  /**
   * A constant header string that is added as an XML comment, e.g. as a version number. Since
   * v11.0.0.
   */
  private String m_sSchHeader;

  /**
   * <code>false</code> to leave an existing destination file untouched. Since v11.0.0.
   */
  private boolean m_bOverwriteWithoutNotice = SchematronFilePreprocessor.DEFAULT_OVERWRITE;

  public SchematronPreprocess ()
  {}

  public void setSrcFile (@NonNull final File aFile)
  {
    m_aSrcFile = aFile;
    if (!m_aSrcFile.isAbsolute ())
      m_aSrcFile = new File (getProject ().getBaseDir (), aFile.getPath ());
    _debug ("Using source Schematron file '" + m_aSrcFile + "'");
  }

  public void setDstFile (@NonNull final File aFile)
  {
    m_aDstFile = aFile;
    if (!m_aDstFile.isAbsolute ())
      m_aDstFile = new File (getProject ().getBaseDir (), aFile.getPath ());
    _debug ("Using destination Schematron file '" + m_aDstFile + "'");
  }

  public void setKeepTitles (final boolean bKeepTitles)
  {
    m_bKeepTitles = bKeepTitles;
    _debug (bKeepTitles ? "Keeping <title>-elements." : "Removing <title>-elements.");
  }

  public void setKeepDiagnostics (final boolean bKeepDiagnostics)
  {
    m_bKeepDiagnostics = bKeepDiagnostics;
    _debug (bKeepDiagnostics ? "Keeping <diagnostic>-elements." : "Removing <diagnostic>-elements.");
  }

  public void setKeepReports (final boolean bKeepReports)
  {
    m_bKeepReports = bKeepReports;
    _debug (bKeepReports ? "Keeping <report>-elements." : "Changing to <assert>-elements.");
  }

  public void setKeepEmptyPatterns (final boolean bKeepEmptyPatterns)
  {
    m_bKeepEmptyPatterns = bKeepEmptyPatterns;
    _debug (bKeepEmptyPatterns ? "Keeping <pattern>-elements without rules."
                               : "Deleting <pattern>-elements without rules.");
  }

  /**
   * @param sSchHeader
   *        A text that is added as an XML comment before the root element. May be
   *        <code>null</code>.
   * @since 11.0.0
   */
  public void setSchHeader (@Nullable final String sSchHeader)
  {
    m_sSchHeader = sSchHeader;
    _debug (StringHelper.isNotEmpty (sSchHeader) ? "Using the SCH header '" + sSchHeader + "'"
                                                 : "No SCH header is configured");
  }

  /**
   * @param bOverwrite
   *        <code>false</code> to leave an existing destination file untouched.
   * @since 11.0.0
   */
  public void setOverwriteWithoutNotice (final boolean bOverwrite)
  {
    m_bOverwriteWithoutNotice = bOverwrite;
    _debug (bOverwrite ? "Overwriting the destination file without notice" : "Ignoring an existing destination file");
  }

  @Override
  public void execute () throws BuildException
  {
    boolean bCanRun = false;
    if (m_aSrcFile == null)
      _errorOrFail ("No source Schematron file specified!");
    else
      if (m_aSrcFile.exists () && !m_aSrcFile.isFile ())
        _errorOrFail ("The specified source Schematron file " + m_aSrcFile + " is not a file!");
      else
        if (m_aDstFile == null)
          _errorOrFail ("No destination Schematron file specified!");
        else
          bCanRun = true;

    if (bCanRun)
      try
      {
        new SchematronFilePreprocessor (new AntLogHandler (this)).setKeepTitles (m_bKeepTitles)
                                                                 .setKeepDiagnostics (m_bKeepDiagnostics)
                                                                 .setKeepReports (m_bKeepReports)
                                                                 .setKeepEmptyPatterns (m_bKeepEmptyPatterns)
                                                                 .setSchHeader (m_sSchHeader)
                                                                 .setOverwrite (m_bOverwriteWithoutNotice)
                                                                 .preprocessFile (m_aSrcFile, m_aDstFile);
      }
      catch (final SchematronException ex)
      {
        _errorOrFail ("Error processing Schematron " + m_aSrcFile.getAbsolutePath (), ex);
      }
  }
}
