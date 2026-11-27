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
package com.helger.schematron.purexslt;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.Locale;
import java.util.Objects;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.Templates;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.xml.sax.EntityResolver;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.builder.IBuilder;
import com.helger.base.concurrent.SimpleLock;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.SchematronException;
import com.helger.schematron.api.cache.ISchematronCompilation;
import com.helger.schematron.api.cache.ISchematronCompilationCacheKey;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.api.xslt.TransformerFactoryLocks;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.exchange.SchematronReadException;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.preprocess.PSPreprocessor;
import com.helger.schematron.purexslt.binding.PureXsltQueryBindingTransform;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;
import com.helger.schematron.purexslt.xslt.PureXsltStylesheetGenerator;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;
import com.helger.xml.transform.LoggingTransformErrorListener;

/**
 * Immutable configuration for compiling a Schematron <code>.sch</code> file through the pure-Java
 * XSLT pipeline: the XSLT is generated in Java and compiled by the selected XSLT processor.
 * Cache-key dimensions are <code>(resourceID, phase, xsltVersion, tracing, xsltProcessorID)</code>.
 * A custom URI resolver or error listener bypasses caching unless
 * {@link Builder#forceCacheResult(boolean)} is true.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class SchematronPureXsltConfig implements ISchematronCompilation <ISchematronXSLTBasedProvider>
{
  /** Default for {@link Builder#forceCacheResult(boolean)}. */
  public static final boolean DEFAULT_FORCE_CACHE_RESULT = false;

  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronPureXsltConfig.class);

  private final IReadableResource m_aResource;
  private final String m_sPhase;
  private final EPureXsltVersion m_eXsltVersion;
  private final ISchematronXsltProcessor m_aXsltProcessor;
  private final IPSErrorHandler m_aErrorHandler;
  private final EntityResolver m_aEntityResolver;
  private final URIResolver m_aURIResolver;
  private final ErrorListener m_aErrorListener;
  private final ISchematronTemplateTelemetry m_aTelemetry;
  private final boolean m_bForceCacheResult;
  private final CacheKey m_aCacheKey;

  private SchematronPureXsltConfig (@NonNull final Builder aBuilder)
  {
    m_aResource = aBuilder.m_aResource;
    m_sPhase = aBuilder.m_sPhase;
    m_eXsltVersion = aBuilder.m_eXsltVersion;
    m_aXsltProcessor = aBuilder.m_aXsltProcessor != null ? aBuilder.m_aXsltProcessor
                                                         : SchematronXsltProcessorRegistry.getDefaultProcessor ();
    m_aErrorHandler = aBuilder.m_aErrorHandler;
    m_aEntityResolver = aBuilder.m_aEntityResolver;
    m_aURIResolver = aBuilder.m_aURIResolver;
    m_aErrorListener = aBuilder.m_aErrorListener;
    m_aTelemetry = aBuilder.m_aTelemetry;
    m_bForceCacheResult = aBuilder.m_bForceCacheResult;
    m_aCacheKey = new CacheKey (m_aResource.getResourceID (),
                                m_sPhase,
                                m_eXsltVersion.getID (),
                                isTracingEnabled (),
                                m_aXsltProcessor.getID ());
  }

  @Override
  @NonNull
  public IReadableResource getResource ()
  {
    return m_aResource;
  }

  /**
   * @return The Schematron phase to use, or <code>null</code> for the default phase. Participates
   *         in the cache key.
   */
  @Nullable
  public String getPhase ()
  {
    return m_sPhase;
  }

  /**
   * @return The XSLT version used for stylesheet generation. Never <code>null</code>. Participates
   *         in the cache key.
   */
  @NonNull
  public EPureXsltVersion getXsltVersion ()
  {
    return m_eXsltVersion;
  }

  /**
   * @return The XSLT processor that compiles and runs the XSLT. Never <code>null</code>.
   *         Participates in the cache key by its ID.
   * @since 11.1.0
   */
  @NonNull
  public ISchematronXsltProcessor getXsltProcessor ()
  {
    return m_aXsltProcessor;
  }

  /**
   * @return The Schematron error handler used while reading the schema. Never <code>null</code>.
   */
  @NonNull
  public IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  /**
   * @return The entity resolver used while reading the schema, or <code>null</code> for none.
   */
  @Nullable
  public EntityResolver getEntityResolver ()
  {
    return m_aEntityResolver;
  }

  /**
   * @return The URI resolver applied to the XSLT compiler, or <code>null</code> for the engine
   *         default. Setting this disables caching unless {@link #isForceCacheResult()} is true.
   */
  @Nullable
  public URIResolver getURIResolver ()
  {
    return m_aURIResolver;
  }

  /**
   * @return The error listener applied to the XSLT compiler, or <code>null</code> for the engine
   *         default. Setting this disables caching unless {@link #isForceCacheResult()} is true.
   */
  @Nullable
  public ErrorListener getErrorListener ()
  {
    return m_aErrorListener;
  }

  /**
   * @return The per-template telemetry callback configured for the XSLT transformation, or
   *         <code>null</code> if telemetry is disabled. When non-<code>null</code>, the stylesheet
   *         is compiled with tracing (on Saxon {@code COMPILE_WITH_TRACING}) and the trace-enabled
   *         provider is cached under a separate key (see {@link #getCacheKey()}).
   */
  @Nullable
  public ISchematronTemplateTelemetry getTelemetry ()
  {
    return m_aTelemetry;
  }

  /**
   * @return <code>true</code> if {@link #getTelemetry()} is non-<code>null</code>, i.e. the
   *         stylesheet should be compiled with tracing enabled.
   */
  public boolean isTracingEnabled ()
  {
    return m_aTelemetry != null;
  }

  /**
   * @return <code>true</code> if the compilation result must be cached even when custom runtime
   *         hooks are present. See {@link #canCacheResult()}.
   */
  public boolean isForceCacheResult ()
  {
    return m_bForceCacheResult;
  }

  @Override
  @NonNull
  public CacheKey getCacheKey ()
  {
    return m_aCacheKey;
  }

  @Override
  public boolean canCacheResult ()
  {
    final boolean bHaveCustomHooks = m_aURIResolver != null || m_aErrorListener != null;
    return !bHaveCustomHooks || m_bForceCacheResult;
  }

  /**
   * Generate the XSLT from the Schematron and compile it with the XSLT processor of this config.
   * The SVRL <code>location</code> is computed with the linear location functions if the processor
   * has all of them (see {@link ISchematronXsltProcessor#isAllLocationFunctionsAvailable()}),
   * otherwise in a portable way.
   *
   * @return The provider with the compiled XSLT. Never <code>null</code>.
   * @throws SchematronException
   *         If the Schematron cannot be read or the XSLT does not compile
   */
  @Override
  @NonNull
  public ISchematronXSLTBasedProvider compile () throws SchematronException
  {
    final PSReader aReader = new PSReader (m_aResource, m_aErrorHandler, m_aEntityResolver);
    aReader.setPreserveLetBodyElements (true);
    final PSSchema aRaw = aReader.readSchema ();
    if (aRaw == null)
      throw new SchematronReadException (m_aResource, "Failed to read Schematron from " + m_aResource);

    // Preprocess schema (resolve includes etc.)
    final PSPreprocessor aPreprocessor = PSPreprocessor.createPreprocessorWithoutInformationLoss (PureXsltQueryBindingTransform.getInstance ());
    final PSSchema aSchema = aPreprocessor.getAsPreprocessedSchema (aRaw);

    final Document aXsltDoc = PureXsltStylesheetGenerator.generate (aSchema,
                                                                    m_sPhase,
                                                                    m_eXsltVersion,
                                                                    m_aXsltProcessor.isAllLocationFunctionsAvailable ());
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Generated XSLT for pure XSLT validation:\n" +
                    XMLWriter.getNodeAsString (aXsltDoc,
                                               new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));
    return new SchematronProviderXSLTFromPureXslt (m_aXsltProcessor, aXsltDoc, compileXslt (aXsltDoc));
  }

  /**
   * Compile a generated XSLT with the XSLT processor, the error listener and the URI resolver of
   * this config, with tracing if telemetry is enabled.
   *
   * @param aXsltDoc
   *        The XSLT to compile. May not be <code>null</code>.
   * @return The compiled XSLT. Never <code>null</code>.
   * @throws SchematronException
   *         If the XSLT does not compile
   */
  @NonNull
  Templates compileXslt (@NonNull final Document aXsltDoc) throws SchematronException
  {
    final TransformerFactory aTF = isTracingEnabled () ? m_aXsltProcessor.createTransformerFactory (true)
                                                       : m_aXsltProcessor.getDefaultTransformerFactory ();
    // The default factory is shared: configuring it and compiling must not interleave with other
    // compilations that run in parallel
    final SimpleLock aTFLock = TransformerFactoryLocks.getLock (aTF);
    aTFLock.lock ();
    try
    {
      aTF.setErrorListener (m_aErrorListener != null ? m_aErrorListener : new LoggingTransformErrorListener (Locale.US));
      if (m_aURIResolver != null)
        aTF.setURIResolver (m_aURIResolver);
      return aTF.newTemplates (new DOMSource (aXsltDoc));
    }
    catch (final TransformerConfigurationException ex)
    {
      throw new SchematronException ("The XSLT processor '" +
                                     m_aXsltProcessor.getID () +
                                     "' rejected the generated XSLT",
                                     ex);
    }
    finally
    {
      aTFLock.unlock ();
    }
  }

  /**
   * @return A new {@link Builder} pre-populated with the values from this config. Never
   *         <code>null</code>.
   */
  @NonNull
  public Builder toBuilder ()
  {
    return new Builder (m_aResource).phase (m_sPhase)
                                    .xsltVersion (m_eXsltVersion)
                                    .xsltProcessor (m_aXsltProcessor)
                                    .errorHandler (m_aErrorHandler)
                                    .entityResolver (m_aEntityResolver)
                                    .uriResolver (m_aURIResolver)
                                    .errorListener (m_aErrorListener)
                                    .telemetry (m_aTelemetry)
                                    .forceCacheResult (m_bForceCacheResult);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Resource", m_aResource)
                                       .appendIfNotNull ("Phase", m_sPhase)
                                       .append ("XsltVersion", m_eXsltVersion)
                                       .append ("XsltProcessor", m_aXsltProcessor)
                                       .append ("ErrorHandler", m_aErrorHandler)
                                       .appendIfNotNull ("EntityResolver", m_aEntityResolver)
                                       .appendIfNotNull ("URIResolver", m_aURIResolver)
                                       .appendIfNotNull ("ErrorListener", m_aErrorListener)
                                       .appendIfNotNull ("Telemetry", m_aTelemetry)
                                       .append ("ForceCacheResult", m_bForceCacheResult)
                                       .getToString ();
  }

  // === Factories ===

  /**
   * @param aResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return A new {@link Builder} based on the given resource. Never <code>null</code>.
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aResource)
  {
    return new Builder (aResource);
  }

  /**
   * @param sSCHPath
   *        The classpath-relative path of the Schematron. May neither be <code>null</code> nor
   *        empty.
   * @return A new {@link Builder} reading the Schematron from the default classloader. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return builder (new ClassPathResource (sSCHPath));
  }

  /**
   * @param sSCHPath
   *        The classpath-relative path of the Schematron. May neither be <code>null</code> nor
   *        empty.
   * @param aClassLoader
   *        The classloader to use, or <code>null</code> for the default classloader.
   * @return A new {@link Builder} reading the Schematron from the given classloader. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromClassPath (@NonNull @Nonempty final String sSCHPath,
                                       @Nullable final ClassLoader aClassLoader)
  {
    return builder (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * @param sSCHPath
   *        The file system path of the Schematron. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the Schematron from the file system. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return builder (new FileSystemResource (sSCHPath));
  }

  /**
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given file. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromFile (@NonNull final File aSCHFile)
  {
    return builder (new FileSystemResource (aSCHFile));
  }

  /**
   * @param sSCHURL
   *        The Schematron URL as string. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the Schematron from the given URL. Never
   *         <code>null</code>.
   * @throws MalformedURLException
   *         If the URL is not well-formed.
   */
  @NonNull
  public static Builder fromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return builder (new URLResource (sSCHURL));
  }

  /**
   * @param aSCHURL
   *        The Schematron URL. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given URL. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromURL (@NonNull final URL aSCHURL)
  {
    return builder (new URLResource (aSCHURL));
  }

  /**
   * @param sResourceID
   *        The logical resource ID used in error messages and cache keys. May neither be
   *        <code>null</code> nor empty.
   * @param aSchematronIS
   *        The input stream providing the Schematron bytes. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given input stream. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromInputStream (@NonNull @Nonempty final String sResourceID,
                                         @NonNull final InputStream aSchematronIS)
  {
    return builder (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  /**
   * @param aSchematron
   *        The Schematron bytes. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given byte array. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromByteArray (final byte @NonNull [] aSchematron)
  {
    return builder (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * @param sSchematron
   *        The Schematron as a string. May not be <code>null</code>.
   * @param aCharset
   *        The charset used to encode the string to bytes. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the encoded string bytes. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromString (@NonNull final String sSchematron, @NonNull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }

  // === Cache key ===

  @Immutable
  public static final class CacheKey implements ISchematronCompilationCacheKey
  {
    private final String m_sResourceID;
    private final String m_sPhase;
    private final String m_sVersion;
    private final boolean m_bTracingEnabled;
    private final String m_sXsltProcessorID;
    private final int m_nHashCode;

    private CacheKey (@NonNull final String sResourceID,
                      @Nullable final String sPhase,
                      @NonNull final String sVersion,
                      final boolean bTracingEnabled,
                      @NonNull final String sXsltProcessorID)
    {
      m_sResourceID = sResourceID;
      m_sPhase = sPhase;
      m_sVersion = sVersion;
      m_bTracingEnabled = bTracingEnabled;
      m_sXsltProcessorID = sXsltProcessorID;
      m_nHashCode = Objects.hash (sResourceID, sPhase, sVersion, Boolean.valueOf (bTracingEnabled), sXsltProcessorID);
    }

    @Override
    public boolean equals (@Nullable final Object o)
    {
      if (o == this)
        return true;
      if (!(o instanceof final CacheKey aRhs))
        return false;
      return m_bTracingEnabled == aRhs.m_bTracingEnabled &&
             m_sResourceID.equals (aRhs.m_sResourceID) &&
             Objects.equals (m_sPhase, aRhs.m_sPhase) &&
             m_sVersion.equals (aRhs.m_sVersion) &&
             m_sXsltProcessorID.equals (aRhs.m_sXsltProcessorID);
    }

    @Override
    public int hashCode ()
    {
      return m_nHashCode;
    }

    @Override
    public String toString ()
    {
      return "SchematronPureXsltConfig.CacheKey[" +
             m_sResourceID +
             ":" +
             StringHelper.getNotNull (m_sPhase) +
             ":" +
             m_sVersion +
             (m_bTracingEnabled ? ":trace" : "") +
             ":" +
             m_sXsltProcessorID +
             "]";
    }
  }

  // === Builder ===

  @NotThreadSafe
  public static final class Builder implements IBuilder <SchematronPureXsltConfig>
  {
    private final IReadableResource m_aResource;
    private String m_sPhase;
    private EPureXsltVersion m_eXsltVersion = EPureXsltVersion.DEFAULT;
    private ISchematronXsltProcessor m_aXsltProcessor;
    private IPSErrorHandler m_aErrorHandler = new LoggingPSErrorHandler ();
    private EntityResolver m_aEntityResolver;
    private URIResolver m_aURIResolver;
    private ErrorListener m_aErrorListener;
    private ISchematronTemplateTelemetry m_aTelemetry;
    private boolean m_bForceCacheResult = DEFAULT_FORCE_CACHE_RESULT;

    Builder (@NonNull final IReadableResource aResource)
    {
      ValueEnforcer.notNull (aResource, "Resource");
      m_aResource = aResource;
    }

    /**
     * Set the Schematron phase to run.
     *
     * @param s
     *        The phase name, or <code>null</code> for the default phase.
     * @return this for chaining
     */
    @NonNull
    public Builder phase (@Nullable final String s)
    {
      m_sPhase = s;
      return this;
    }

    /**
     * Set the XSLT version used for stylesheet generation.
     *
     * @param e
     *        The XSLT version. May not be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder xsltVersion (@NonNull final EPureXsltVersion e)
    {
      ValueEnforcer.notNull (e, "XsltVersion");
      m_eXsltVersion = e;
      return this;
    }

    /**
     * Set the XSLT processor that compiles and runs the XSLT.
     *
     * @param a
     *        The XSLT processor, or <code>null</code> for the only one on the class path (see
     *        {@link SchematronXsltProcessorRegistry#getDefaultProcessor()}).
     * @return this for chaining
     * @since 11.1.0
     */
    @NonNull
    public Builder xsltProcessor (@Nullable final ISchematronXsltProcessor a)
    {
      m_aXsltProcessor = a;
      return this;
    }

    /**
     * Set the Schematron error handler used while reading the schema.
     *
     * @param a
     *        The error handler. May not be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder errorHandler (@NonNull final IPSErrorHandler a)
    {
      ValueEnforcer.notNull (a, "ErrorHandler");
      m_aErrorHandler = a;
      return this;
    }

    /**
     * Set the entity resolver used while reading the schema.
     *
     * @param a
     *        The entity resolver, or <code>null</code> to disable entity resolution.
     * @return this for chaining
     */
    @NonNull
    public Builder entityResolver (@Nullable final EntityResolver a)
    {
      m_aEntityResolver = a;
      return this;
    }

    /**
     * Set the URI resolver applied to the XSLT compiler. Setting a non-<code>null</code> value
     * disables caching unless {@link #forceCacheResult(boolean)} is also <code>true</code>.
     *
     * @param a
     *        The URI resolver, or <code>null</code> for the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder uriResolver (@Nullable final URIResolver a)
    {
      m_aURIResolver = a;
      return this;
    }

    /**
     * Set the error listener applied to the XSLT compiler. Setting a non-<code>null</code> value
     * disables caching unless {@link #forceCacheResult(boolean)} is also <code>true</code>.
     *
     * @param a
     *        The error listener, or <code>null</code> for the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder errorListener (@Nullable final ErrorListener a)
    {
      m_aErrorListener = a;
      return this;
    }

    /**
     * Set the per-template telemetry callback. When non-<code>null</code>, the stylesheet is
     * compiled with tracing (on Saxon {@code COMPILE_WITH_TRACING}; separate cache entry) and the
     * telemetry is installed on each transform via
     * {@link ISchematronXsltProcessor#installTemplateTelemetry(javax.xml.transform.Transformer, ISchematronTemplateTelemetry)}
     * so that the callback receives one
     * {@link ISchematronTemplateTelemetry#onTemplateEnter(com.helger.schematron.api.telemetry.SchematronTemplateInfo)}
     * /
     * {@link ISchematronTemplateTelemetry#onTemplateLeave(com.helger.schematron.api.telemetry.SchematronTemplateInfo, long)}
     * pair per executed XSLT template.
     *
     * @param a
     *        The telemetry callback, or <code>null</code> to disable telemetry. Default is
     *        <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder telemetry (@Nullable final ISchematronTemplateTelemetry a)
    {
      m_aTelemetry = a;
      return this;
    }

    /**
     * Toggle whether compilation results should be cached even when custom runtime hooks (URI
     * resolver or error listener) are present.
     *
     * @param b
     *        <code>true</code> to force caching, <code>false</code> for the default behaviour
     *        ({@link #DEFAULT_FORCE_CACHE_RESULT}).
     * @return this for chaining
     */
    @NonNull
    public Builder forceCacheResult (final boolean b)
    {
      m_bForceCacheResult = b;
      return this;
    }

    /**
     * @return The built {@link SchematronPureXsltConfig} value object. Never <code>null</code>.
     */
    @Override
    @NonNull
    public SchematronPureXsltConfig build ()
    {
      return new SchematronPureXsltConfig (this);
    }
  }
}
