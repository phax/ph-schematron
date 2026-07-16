/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt.xslt;

import java.io.File;
import java.io.OutputStream;
import java.io.Writer;
import java.nio.charset.Charset;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.ESuccess;
import com.helger.io.file.FileHelper;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.SchematronException;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.exchange.SchematronReadException;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.preprocess.PSPreprocessor;
import com.helger.schematron.purexslt.binding.PureXsltQueryBindingTransform;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Standalone tool that converts a Schematron schema into the XSLT&nbsp;3.0 stylesheet produced by
 * {@link PureXsltStylesheetGenerator}, and emits it in a variety of forms. Use this when you want
 * the generated stylesheet on its own - e.g. to ship it in a build artifact, apply it through
 * a non-Saxon XSLT processor, or simply inspect what the Saxon-native engine compiles internally.
 * <p>
 * By default the pipeline mirrors the one used at runtime inside
 * {@code SchematronResourcePureXslt}: the schema is read with {@link PSReader} (with let-body
 * elements preserved), preprocessed via {@link PSPreprocessor} (so abstract patterns,
 * {@code <sch:extends>} and {@code <sch:include>} are all expanded), then handed to
 * {@link PureXsltStylesheetGenerator}. The preprocessing step can be disabled if you want a 1:1
 * view of the source schema with no expansions.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public final class SchematronToXsltConverter
{
  private final IReadableResource m_aResource;
  private PSSchema m_aSchema;
  private IPSErrorHandler m_aErrorHandler = new LoggingPSErrorHandler ();
  private String m_sPhase;
  private EPureXsltVersion m_eVersion = EPureXsltVersion.DEFAULT;
  private boolean m_bPreprocess = true;
  private XMLWriterSettings m_aWriterSettings;

  private SchematronToXsltConverter (@NonNull final IReadableResource aResource)
  {
    m_aResource = ValueEnforcer.notNull (aResource, "Resource");
  }

  private SchematronToXsltConverter (@NonNull final PSSchema aSchema)
  {
    m_aSchema = ValueEnforcer.notNull (aSchema, "Schema");
    m_aResource = null;
  }

  // --- configuration ---

  /**
   * Set the {@link IPSErrorHandler} used by {@link PSReader} when reading the schema. Ignored if
   * the converter was constructed from an already-parsed {@link PSSchema}.
   *
   * @param aErrorHandler
   *        The handler. May not be <code>null</code>.
   * @return this
   */
  @NonNull
  public SchematronToXsltConverter setErrorHandler (@NonNull final IPSErrorHandler aErrorHandler)
  {
    ValueEnforcer.notNull (aErrorHandler, "ErrorHandler");
    m_aErrorHandler = aErrorHandler;
    return this;
  }

  /**
   * Restrict the generated stylesheet to the patterns active in a specific phase. {@code null}
   * (default), empty, or {@code "#ALL"} processes all concrete patterns. {@code "#DEFAULT"}
   * resolves to {@link PSSchema#getDefaultPhase()}.
   *
   * @param sPhase
   *        The phase id. May be <code>null</code>.
   * @return this
   */
  @NonNull
  public SchematronToXsltConverter setPhase (@Nullable final String sPhase)
  {
    m_sPhase = sPhase;
    return this;
  }

  /**
   * Set the XSLT language version written on the generated {@code xsl:stylesheet/@version}
   * attribute. Default is {@link EPureXsltVersion#DEFAULT}.
   *
   * @param eVersion
   *        The version. May not be <code>null</code>.
   * @return this
   */
  @NonNull
  public SchematronToXsltConverter setXsltVersion (@NonNull final EPureXsltVersion eVersion)
  {
    ValueEnforcer.notNull (eVersion, "XsltVersion");
    m_eVersion = eVersion;
    return this;
  }

  /**
   * Control whether {@link PSPreprocessor} runs over the schema before generation. Disable when you
   * want a 1:1 view of the source schema (abstract patterns and {@code <sch:extends>} not
   * expanded). Default is <code>true</code> - matches the runtime behaviour of
   * {@code SchematronResourcePureXslt}.
   *
   * @param bPreprocess
   *        <code>true</code> to preprocess, <code>false</code> to skip.
   * @return this
   */
  @NonNull
  public SchematronToXsltConverter setPreprocess (final boolean bPreprocess)
  {
    m_bPreprocess = bPreprocess;
    return this;
  }

  /**
   * Override the {@link XMLWriterSettings} used for serialization. If not set, {@link XMLWriter}'s
   * defaults are used. The DOM document returned by {@link PureXsltStylesheetGenerator} already
   * carries {@code xmlns:xsl}, {@code xmlns:svrl} and one {@code xmlns:<prefix>} per schema
   * {@code <sch:ns>} on its root element, so callers do not have to configure a namespace context
   * just for prefix preservation.
   *
   * @param aWriterSettings
   *        The settings. May be <code>null</code> to revert to the default.
   * @return this
   */
  @NonNull
  public SchematronToXsltConverter setWriterSettings (@Nullable final XMLWriterSettings aWriterSettings)
  {
    m_aWriterSettings = aWriterSettings;
    return this;
  }

  // --- output ---

  @NonNull
  private PSSchema _resolveSchema () throws SchematronException, SchematronReadException
  {
    if (m_aSchema == null)
    {
      final PSReader aReader = new PSReader (m_aResource, m_aErrorHandler, null);
      // Same opt-in as SchematronResourcePureXslt so XSLT-shaped <sch:let> bodies survive
      aReader.setPreserveLetBodyElements (true);
      final PSSchema aRaw = aReader.readSchema ();
      if (aRaw == null)
        throw new SchematronReadException (m_aResource, "Failed to read Schematron from " + m_aResource);
      m_aSchema = aRaw;
    }
    if (m_bPreprocess)
    {
      final PSPreprocessor aPre = PSPreprocessor.createPreprocessorWithoutInformationLoss (PureXsltQueryBindingTransform.getInstance ());
      return aPre.getAsPreprocessedSchema (m_aSchema);
    }
    return m_aSchema;
  }

  /**
   * Build the XSLT stylesheet as an in-memory DOM {@link Document}. The same document the
   * Saxon-native runtime hands to its {@code XsltCompiler}.
   *
   * @return The generated stylesheet. Never <code>null</code>.
   * @throws SchematronException
   *         if the input cannot be read as a Schematron.
   */
  @NonNull
  public Document getAsDocument () throws SchematronException
  {
    return PureXsltStylesheetGenerator.generate (_resolveSchema (), m_sPhase, m_eVersion);
  }

  /**
   * Pick the writer settings for the textual sinks. If the caller provided their own settings via
   * {@link #setWriterSettings}, those win unmodified. Otherwise we honor the {@code xmlns:*}
   * declarations the DOM tree already carries (so {@code xsl:} / {@code svrl:} / schema prefixes
   * survive serialization instead of being rewritten to {@code ns0:} etc.).
   */
  @NonNull
  private XMLWriterSettings _resolveWriterSettings ()
  {
    if (m_aWriterSettings != null)
      return m_aWriterSettings;
    return new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true);
  }

  /**
   * Serialize the generated XSLT to a {@link String}.
   *
   * @return The XSLT as a string. Never <code>null</code>.
   * @throws SchematronException
   *         if the input cannot be read as a Schematron.
   */
  @NonNull
  public String getAsString () throws SchematronException
  {
    return XMLWriter.getNodeAsString (getAsDocument (), _resolveWriterSettings ());
  }

  /**
   * Write the generated XSLT to an {@link OutputStream}. The stream is closed by {@link XMLWriter}
   * on completion.
   *
   * @param aOS
   *        The target stream. May not be <code>null</code>.
   * @return {@link ESuccess#SUCCESS} on success, {@link ESuccess#FAILURE} otherwise.
   * @throws SchematronException
   *         if the input cannot be read as a Schematron.
   */
  @NonNull
  public ESuccess writeTo (@NonNull final OutputStream aOS) throws SchematronException
  {
    ValueEnforcer.notNull (aOS, "OutputStream");
    return XMLWriter.writeToStream (getAsDocument (), aOS, _resolveWriterSettings ());
  }

  /**
   * Write the generated XSLT to a character {@link Writer}.
   *
   * @param aWriter
   *        The target writer. May not be <code>null</code>.
   * @return {@link ESuccess#SUCCESS} on success, {@link ESuccess#FAILURE} otherwise.
   * @throws SchematronException
   *         if the input cannot be read as a Schematron.
   */
  @NonNull
  public ESuccess writeTo (@NonNull final Writer aWriter) throws SchematronException
  {
    ValueEnforcer.notNull (aWriter, "Writer");
    return XMLWriter.writeToWriter (getAsDocument (), aWriter, _resolveWriterSettings ());
  }

  /**
   * Write the generated XSLT to a {@link File}.
   *
   * @param aFile
   *        The target file. May not be <code>null</code>.
   * @return {@link ESuccess#SUCCESS} on success, {@link ESuccess#FAILURE} otherwise.
   * @throws SchematronException
   *         if the input cannot be read as a Schematron.
   */
  @NonNull
  public ESuccess writeTo (@NonNull final File aFile) throws SchematronException
  {
    ValueEnforcer.notNull (aFile, "File");
    final OutputStream aOS = FileHelper.getOutputStream (aFile);
    if (aOS == null)
      return ESuccess.FAILURE;
    return writeTo (aOS);
  }

  // --- factories ---

  @NonNull
  public static SchematronToXsltConverter fromSchema (@NonNull final PSSchema aSchema)
  {
    return new SchematronToXsltConverter (aSchema);
  }

  @NonNull
  public static SchematronToXsltConverter fromResource (@NonNull final IReadableResource aResource)
  {
    return new SchematronToXsltConverter (aResource);
  }

  @NonNull
  public static SchematronToXsltConverter fromFile (@NonNull final File aSCHFile)
  {
    return new SchematronToXsltConverter (new FileSystemResource (aSCHFile));
  }

  @NonNull
  public static SchematronToXsltConverter fromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronToXsltConverter (new ClassPathResource (sSCHPath));
  }

  @NonNull
  public static SchematronToXsltConverter fromByteArray (@NonNull final byte [] aSchematron)
  {
    return new SchematronToXsltConverter (new ReadableResourceByteArray (aSchematron));
  }

  @NonNull
  public static SchematronToXsltConverter fromString (@NonNull final String sSchematron,
                                                      @NonNull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }
}
