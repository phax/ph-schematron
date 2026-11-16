/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.enginefactory;

import java.io.File;
import java.util.Locale;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.log.ILogHandler;
import com.helger.base.string.StringHelper;
import com.helger.diagnostics.error.IError;
import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.CSchematron;
import com.helger.schematron.SchematronException;
import com.helger.schematron.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.model.PSNS;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.model.PSVersionChecker;
import com.helger.schematron.preprocess.PSPreprocessor;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.PSQueryBindingRegistry;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.MicroDocument;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.IXMLWriterSettings;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Preprocesses a Schematron file into a new Schematron file (includes and abstract patterns
 * resolved), as done by the Maven goal <code>preprocess</code>, the Ant task
 * <code>schematron-preprocess</code> and the command line client.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
public class SchematronFilePreprocessor
{
  public static final boolean DEFAULT_KEEP_TITLES = false;
  public static final boolean DEFAULT_KEEP_DIAGNOSTICS = false;
  public static final boolean DEFAULT_KEEP_REPORTS = false;
  // Deliberately different from PSPreprocessor.DEFAULT_KEEP_EMPTY_PATTERNS
  public static final boolean DEFAULT_KEEP_EMPTY_PATTERNS = false;
  public static final boolean DEFAULT_OVERWRITE = true;

  private final ILogHandler m_aLogger;
  private boolean m_bKeepTitles = DEFAULT_KEEP_TITLES;
  private boolean m_bKeepDiagnostics = DEFAULT_KEEP_DIAGNOSTICS;
  private boolean m_bKeepReports = DEFAULT_KEEP_REPORTS;
  private boolean m_bKeepEmptyPatterns = DEFAULT_KEEP_EMPTY_PATTERNS;
  private String m_sSchHeader;
  private boolean m_bOverwrite = DEFAULT_OVERWRITE;

  public SchematronFilePreprocessor (@NonNull final ILogHandler aLogger)
  {
    ValueEnforcer.notNull (aLogger, "Logger");
    m_aLogger = aLogger;
  }

  @NonNull
  public SchematronFilePreprocessor setKeepTitles (final boolean bKeepTitles)
  {
    m_bKeepTitles = bKeepTitles;
    return this;
  }

  @NonNull
  public SchematronFilePreprocessor setKeepDiagnostics (final boolean bKeepDiagnostics)
  {
    m_bKeepDiagnostics = bKeepDiagnostics;
    return this;
  }

  /**
   * @param bKeepReports
   *        <code>true</code> to keep <code>report</code> elements, <code>false</code> to convert
   *        them to <code>assert</code> elements.
   * @return this for chaining
   */
  @NonNull
  public SchematronFilePreprocessor setKeepReports (final boolean bKeepReports)
  {
    m_bKeepReports = bKeepReports;
    return this;
  }

  /**
   * @param bKeepEmptyPatterns
   *        <code>true</code> to keep <code>pattern</code> elements without a rule.
   * @return this for chaining
   */
  @NonNull
  public SchematronFilePreprocessor setKeepEmptyPatterns (final boolean bKeepEmptyPatterns)
  {
    m_bKeepEmptyPatterns = bKeepEmptyPatterns;
    return this;
  }

  /**
   * @param sSchHeader
   *        A text that is added as an XML comment before the root element. May be
   *        <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public SchematronFilePreprocessor setSchHeader (@Nullable final String sSchHeader)
  {
    m_sSchHeader = sSchHeader;
    return this;
  }

  /**
   * @param bOverwrite
   *        <code>false</code> to leave an existing target file untouched.
   * @return this for chaining
   */
  @NonNull
  public SchematronFilePreprocessor setOverwrite (final boolean bOverwrite)
  {
    m_bOverwrite = bOverwrite;
    return this;
  }

  /**
   * Read the source Schematron and preprocess it with the query binding it declares.
   *
   * @param aSourceFile
   *        The Schematron file to preprocess. May not be <code>null</code>.
   * @return The preprocessed Schematron. Never <code>null</code>.
   * @throws SchematronException
   *         If reading, binding or preprocessing fails
   */
  @NonNull
  public PSSchema getPreprocessedSchema (@NonNull final File aSourceFile) throws SchematronException
  {
    ValueEnforcer.notNull (aSourceFile, "SourceFile");

    final PSSchema aSchema = new PSReader (new FileSystemResource (aSourceFile), null, null).readSchema ();
    final IPSQueryBinding aQueryBinding = PSQueryBindingRegistry.getQueryBindingOfNameOrThrow (aSchema.getQueryBinding ());

    final PSPreprocessor aPreprocessor = new PSPreprocessor (aQueryBinding).setKeepTitles (m_bKeepTitles)
                                                                           .setKeepDiagnostics (m_bKeepDiagnostics)
                                                                           .setKeepReports (m_bKeepReports)
                                                                           .setKeepEmptyPatterns (m_bKeepEmptyPatterns);
    final PSSchema aPreprocessedSchema = aPreprocessor.getForcedPreprocessedSchema (aSchema);
    if (aPreprocessedSchema == null)
      throw new SchematronToolException ("Failed to preprocess Schematron file '" +
                                         aSourceFile.getPath () +
                                         "' with query binding " +
                                         aQueryBinding);

    // Report elements that don't match the Schematron version
    final CollectingPSErrorHandler aVersionErrors = new CollectingPSErrorHandler ();
    PSVersionChecker.checkSchematronVersionCompliance (aPreprocessedSchema, aVersionErrors);
    for (final IError aError : aVersionErrors.getAllErrors ())
      SchematronToolLogHelper.log (m_aLogger,
                                   aError.getErrorLevel (),
                                   "Schematron version check: " + aError.getAsString (Locale.US));

    return aPreprocessedSchema;
  }

  /**
   * @param aSchema
   *        The preprocessed Schematron. May not be <code>null</code>.
   * @return The document to write, with the optional header comment. Never <code>null</code>.
   */
  @NonNull
  public IMicroDocument getAsDocument (@NonNull final PSSchema aSchema)
  {
    final IMicroDocument aDoc = new MicroDocument ();
    if (StringHelper.isNotEmpty (m_sSchHeader))
      aDoc.addComment (m_sSchHeader);
    aDoc.addChild (aSchema.getAsMicroElement ());
    return aDoc;
  }

  /**
   * @param aSchema
   *        The preprocessed Schematron. Its <code>ns</code> elements are used. May not be
   *        <code>null</code>.
   * @return The XML writer settings for a preprocessed Schematron: indented, with the Schematron
   *         namespace as default namespace and the prefixes <code>xsl</code>, <code>svrl</code>
   *         and those of all <code>ns</code> elements.
   */
  @NonNull
  public static IXMLWriterSettings createXMLWriterSettings (@NonNull final PSSchema aSchema)
  {
    final MapBasedNamespaceContext aNSCtx = new MapBasedNamespaceContext ();
    aNSCtx.addDefaultNamespaceURI (CSchematron.NAMESPACE_SCHEMATRON);
    aNSCtx.addMapping ("xsl", CSchematron.NAMESPACE_URI_XSL);
    aNSCtx.addMapping ("svrl", CSVRL.SVRL_NAMESPACE_URI);

    // Add all <ns> elements from schema as NS context
    for (final PSNS aItem : aSchema.getAllNSs ())
      aNSCtx.setMapping (aItem.getPrefix (), aItem.getUri ());

    return new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN).setNamespaceContext (aNSCtx);
  }

  /**
   * Preprocess a Schematron file and write the result.
   *
   * @param aSourceFile
   *        The Schematron file to preprocess. May not be <code>null</code>.
   * @param aTargetFile
   *        The file to write. May not be <code>null</code>.
   * @return <code>true</code> if the target file was written, <code>false</code> if it existed and
   *         overwriting is disabled.
   * @throws SchematronException
   *         If reading, preprocessing or writing fails
   */
  public boolean preprocessFile (@NonNull final File aSourceFile, @NonNull final File aTargetFile) throws SchematronException
  {
    ValueEnforcer.notNull (aSourceFile, "SourceFile");
    ValueEnforcer.notNull (aTargetFile, "TargetFile");

    if (aTargetFile.exists ())
    {
      if (!m_bOverwrite)
      {
        m_aLogger.info ("Skipping target file '" + aTargetFile.getPath () + "' because it already exists");
        return false;
      }
      if (!aTargetFile.isFile ())
        throw new SchematronToolException ("The target file '" + aTargetFile.getPath () + "' is not a file");
    }

    final PSSchema aPreprocessedSchema = getPreprocessedSchema (aSourceFile);
    if (MicroWriter.writeToFile (getAsDocument (aPreprocessedSchema),
                                 aTargetFile,
                                 createXMLWriterSettings (aPreprocessedSchema)).isFailure ())
      throw new SchematronToolException ("Error writing preprocessed Schematron file '" + aTargetFile.getPath () + "'");

    m_aLogger.info ("Successfully wrote preprocessed Schematron file '" + aTargetFile.getPath () + "'");
    return true;
  }
}
