/*
 * Copyright (C) 2017-2024 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;

import org.apache.tools.ant.BuildException;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.pure.binding.xpath.PSXPathQueryBinding;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.exchange.PSWriter;
import com.helger.schematron.pure.exchange.PSWriterSettings;
import com.helger.schematron.pure.exchange.SchematronReadException;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.preprocess.PSPreprocessor;
import com.helger.schematron.pure.preprocess.SchematronPreprocessException;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * ANT task to perform Schematron preprocessing. It converts an existing schema
 * to the minimal syntax (by default) but allows for a certain degree of
 * customization by keeping certain elements in the resulting schema. The actual
 * query binding is used, so that report test expressions can be converted to
 * assertions, and to replace the content of &lt;param&gt; elements into actual
 * values.
 *
 * @author Philip Helger
 * @since 5.0.0
 */
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
  private boolean m_bKeepTitles = PSPreprocessor.DEFAULT_KEEP_TITLES;

  /**
   * <code>true</code> if &lt;diagnostic&gt;-elements should be kept.
   */
  private boolean m_bKeepDiagnostics = PSPreprocessor.DEFAULT_KEEP_DIAGNOSTICS;

  /**
   * Should &lt;report&gt;-elements be kept or should they be converted to
   * &lt;assert&gt;-elements?
   */
  private boolean m_bKeepReports = PSPreprocessor.DEFAULT_KEEP_REPORTS;

  /**
   * Should &lt;pattern&gt;-elements without a single rule be kept or deleted?
   */
  private boolean m_bKeepEmptyPatterns = PSPreprocessor.DEFAULT_KEEP_EMPTY_PATTERNS;

  public SchematronPreprocess ()
  {}

  public void setSrcFile (@Nonnull final File aFile)
  {
    m_aSrcFile = aFile;
    if (!m_aSrcFile.isAbsolute ())
      m_aSrcFile = new File (getProject ().getBaseDir (), aFile.getPath ());
    _debug ("Using source Schematron file '" + m_aSrcFile + "'");
  }

  public void setDstFile (@Nonnull final File aFile)
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
    _debug (bKeepEmptyPatterns ? "Keeping <pattern>-elements without rules." : "Deleting <pattern>-elements without rules.");
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
          if (m_aDstFile.exists () && !m_aDstFile.isFile ())
            _errorOrFail ("The specified destination Schematron file " + m_aDstFile + " is not a file!");
          else
            bCanRun = true;

    if (bCanRun)
      try
      {
        // Read source
        final PSSchema aSchema = new PSReader (new FileSystemResource (m_aSrcFile)).readSchema ();

        // Setup preprocessor
        final PSPreprocessor aPreprocessor = new PSPreprocessor (PSXPathQueryBinding.getInstance ());
        aPreprocessor.setKeepTitles (m_bKeepTitles);
        aPreprocessor.setKeepDiagnostics (m_bKeepDiagnostics);
        aPreprocessor.setKeepReports (m_bKeepReports);
        aPreprocessor.setKeepEmptyPatterns (m_bKeepEmptyPatterns);
        aPreprocessor.setKeepEmptySchema (true);

        // Main pre-processing
        final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);

        // Write the result file
        new PSWriter (new PSWriterSettings ().setXMLWriterSettings (new XMLWriterSettings ())).writeToFile (aPreprocessedSchema,
                                                                                                            m_aDstFile);
        _info ("Successfully pre-processed Schematron " + m_aSrcFile + " to " + m_aDstFile);
      }
      catch (final SchematronReadException | SchematronPreprocessException ex)
      {
        _errorOrFail ("Error processing Schemtron " + m_aSrcFile.getAbsolutePath (), ex);
      }
  }
}
