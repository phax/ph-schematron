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
package com.helger.schematron.sch;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.Map;
import java.util.Objects;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsOrderedMap;
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
import com.helger.schematron.api.xslt.ISchematronXSLTBasedValidatorBuilder;
import com.helger.schematron.api.xslt.SchematronXSLTBaseURL;
import com.helger.xml.transform.DefaultTransformURIResolver;

/**
 * Immutable configuration describing how to compile an ISO Schematron <code>.sch</code> resource
 * into an XSLT-based validator. Build instances via {@link #builder(IReadableResource)}.
 * <p>
 * The cache-key dimensions are <code>(resourceID, phase, languageCode, tracingEnabled)</code>;
 * runtime hooks ({@link ErrorListener}, {@link URIResolver}, custom XSLT parameters) do not
 * participate in caching but are applied during compilation and transformation. Custom parameters
 * cause {@link #canCacheResult()} to return <code>false</code> unless
 * {@link Builder#forceCacheResult(boolean)} was set.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class SchematronSCHConfig implements ISchematronCompilation <ISchematronXSLTBasedProvider>
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronSCHConfig.class);

  private final IReadableResource m_aResource;
  private final String m_sPhase;
  private final String m_sLanguageCode;
  private final ErrorListener m_aErrorListener;
  private final URIResolver m_aURIResolver;
  private final ICommonsOrderedMap <String, Object> m_aParameters;
  private final boolean m_bForceCacheResult;
  private final ISchematronTemplateTelemetry m_aTelemetry;
  // Memoized cache key
  private final CacheKey m_aCacheKey;

  private SchematronSCHConfig (@NonNull final Builder aBuilder)
  {
    m_aResource = aBuilder.m_aResource;
    m_sPhase = aBuilder.m_sPhase;
    m_sLanguageCode = aBuilder.m_sLanguageCode;
    m_aErrorListener = aBuilder.m_aErrorListener;
    m_aURIResolver = aBuilder.m_aURIResolver;
    m_aParameters = new CommonsLinkedHashMap <> (aBuilder.m_aParameters);
    m_bForceCacheResult = aBuilder.m_bForceCacheResult;
    m_aTelemetry = aBuilder.m_aTelemetry;
    m_aCacheKey = new CacheKey (m_aResource.getResourceID (), m_sPhase, m_sLanguageCode, m_aTelemetry != null);
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
   * @return The diagnostics language code (e.g. <code>"en"</code>), or <code>null</code> for the
   *         default language. Participates in the cache key.
   */
  @Nullable
  public String getLanguageCode ()
  {
    return m_sLanguageCode;
  }

  /**
   * @return The transformer error listener configured for the XSLT transformation, or
   *         <code>null</code> for the engine default.
   */
  @Nullable
  public ErrorListener getErrorListener ()
  {
    return m_aErrorListener;
  }

  /**
   * @return The URI resolver applied to the transformer, or <code>null</code> for the engine
   *         default.
   */
  @Nullable
  public URIResolver getURIResolver ()
  {
    return m_aURIResolver;
  }

  /**
   * @return A mutable copy of the XSLT parameters configured for this compilation. Never
   *         <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, Object> getParameters ()
  {
    return new CommonsLinkedHashMap <> (m_aParameters);
  }

  /**
   * @return <code>true</code> if at least one XSLT parameter is set.
   */
  public boolean hasParameters ()
  {
    return !m_aParameters.isEmpty ();
  }

  /**
   * @return <code>true</code> if the compilation result must be cached even when parameters are
   *         present. See {@link #canCacheResult()}.
   */
  public boolean isForceCacheResult ()
  {
    return m_bForceCacheResult;
  }

  /**
   * @return The per-template telemetry callback configured for the XSLT transformation, or
   *         <code>null</code> if telemetry is disabled. When non-<code>null</code>, the final
   *         validation stylesheet is compiled with Saxon's {@code COMPILE_WITH_TRACING} feature and
   *         the trace-enabled provider is cached under a separate key.
   * @since 10.0.0
   */
  @Nullable
  public ISchematronTemplateTelemetry getTelemetry ()
  {
    return m_aTelemetry;
  }

  /**
   * @return <code>true</code> if {@link #getTelemetry()} is non-<code>null</code>, i.e. the final
   *         validation stylesheet should be compiled with Saxon tracing enabled.
   * @since 10.0.0
   */
  public boolean isTracingEnabled ()
  {
    return m_aTelemetry != null;
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
    return !hasParameters () || m_bForceCacheResult;
  }

  /**
   * Build the legacy {@link TransformerCustomizerSCH} object that drives the SCH-&gt;XSLT pipeline
   * and per-transform customization.
   */
  @NonNull
  TransformerCustomizerSCH toTransformerCustomizer ()
  {
    return new TransformerCustomizerSCH ().setErrorListener (m_aErrorListener)
                                          .setURIResolver (m_aURIResolver)
                                          .setParameters (m_aParameters)
                                          .setPhase (m_sPhase)
                                          .setLanguageCode (m_sLanguageCode)
                                          .setForceCacheResult (m_bForceCacheResult)
                                          .setTelemetry (m_aTelemetry);
  }

  @Override
  @Nullable
  public ISchematronXSLTBasedProvider compile ()
  {
    if (!m_aResource.exists ())
    {
      LOGGER.warn ("Schematron resource " + m_aResource + " does not exist!");
      return null;
    }
    final SchematronProviderXSLTFromSCH aProvider = new SchematronProviderXSLTFromSCH (m_aResource,
                                                                                       toTransformerCustomizer ());
    aProvider.convertSchematronToXSLT ();
    if (!aProvider.isValidSchematron ())
    {
      LOGGER.warn ("The Schematron resource '" + m_aResource.getResourceID () + "' is invalid!");
      return null;
    }
    return aProvider;
  }

  /**
   * @return A fresh builder pre-populated with the values of this config. Never <code>null</code>.
   */
  @NonNull
  public Builder toBuilder ()
  {
    return new Builder (m_aResource).phase (m_sPhase)
                                    .languageCode (m_sLanguageCode)
                                    .errorListener (m_aErrorListener)
                                    .uriResolver (m_aURIResolver)
                                    .parameters (m_aParameters)
                                    .forceCacheResult (m_bForceCacheResult)
                                    .telemetry (m_aTelemetry);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Resource", m_aResource)
                                       .appendIfNotNull ("Phase", m_sPhase)
                                       .appendIfNotNull ("LanguageCode", m_sLanguageCode)
                                       .appendIfNotNull ("ErrorListener", m_aErrorListener)
                                       .appendIfNotNull ("URIResolver", m_aURIResolver)
                                       .append ("Parameters", m_aParameters)
                                       .append ("ForceCacheResult", m_bForceCacheResult)
                                       .appendIfNotNull ("Telemetry", m_aTelemetry)
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
  public static Builder fromByteArray (@NonNull final byte [] aSchematron)
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

  /**
   * Immutable cache key for {@link SchematronSCHConfig}. Equality is by
   * <code>(resourceID, phase, languageCode)</code>.
   */
  @Immutable
  public static final class CacheKey implements ISchematronCompilationCacheKey
  {
    private final String m_sResourceID;
    private final String m_sPhase;
    private final String m_sLanguageCode;
    private final boolean m_bTracingEnabled;
    private final int m_nHashCode;

    private CacheKey (@NonNull final String sResourceID,
                      @Nullable final String sPhase,
                      @Nullable final String sLanguageCode,
                      final boolean bTracingEnabled)
    {
      m_sResourceID = sResourceID;
      m_sPhase = sPhase;
      m_sLanguageCode = sLanguageCode;
      m_bTracingEnabled = bTracingEnabled;
      m_nHashCode = Objects.hash (sResourceID, sPhase, sLanguageCode, Boolean.valueOf (bTracingEnabled));
    }

    @Override
    public boolean equals (@Nullable final Object o)
    {
      if (o == this)
        return true;
      if (!(o instanceof final CacheKey aRhs))
        return false;
      return m_sResourceID.equals (aRhs.m_sResourceID) &&
             Objects.equals (m_sPhase, aRhs.m_sPhase) &&
             Objects.equals (m_sLanguageCode, aRhs.m_sLanguageCode) &&
             m_bTracingEnabled == aRhs.m_bTracingEnabled;
    }

    @Override
    public int hashCode ()
    {
      return m_nHashCode;
    }

    @Override
    public String toString ()
    {
      return new ToStringGenerator (this).append ("ResourceID", m_sResourceID)
                                         .appendIfNotNull ("Phase", m_sPhase)
                                         .appendIfNotNull ("LanguageCode", m_sLanguageCode)
                                         .append ("TracingEnabled", m_bTracingEnabled)
                                         .getToString ();
    }
  }

  // === Builder ===

  /**
   * Fluent builder for {@link SchematronSCHConfig}. Not thread-safe.
   */
  @NotThreadSafe
  public static final class Builder implements
                                     ISchematronXSLTBasedValidatorBuilder <SchematronSCHConfig, SchematronSCHCache, SchematronSCH>
  {
    private final IReadableResource m_aResource;
    private String m_sPhase;
    private String m_sLanguageCode;
    private ErrorListener m_aErrorListener;
    private URIResolver m_aURIResolver;
    private final ICommonsOrderedMap <String, Object> m_aParameters = new CommonsLinkedHashMap <> ();
    private boolean m_bForceCacheResult = TransformerCustomizerSCH.DEFAULT_FORCE_CACHE_RESULT;
    private ISchematronTemplateTelemetry m_aTelemetry;

    Builder (@NonNull final IReadableResource aResource)
    {
      ValueEnforcer.notNull (aResource, "Resource");
      m_aResource = aResource;
      // Default URI resolver based on the resource's base URL — matches the legacy default
      m_aURIResolver = new DefaultTransformURIResolver ().setDefaultBase (SchematronXSLTBaseURL.findBaseURL (aResource));
    }

    /**
     * Set the Schematron phase to run.
     *
     * @param sPhase
     *        The phase name, or <code>null</code> for the default phase.
     * @return this for chaining
     */
    @NonNull
    public Builder phase (@Nullable final String sPhase)
    {
      m_sPhase = sPhase;
      return this;
    }

    /**
     * Set the diagnostics language code (e.g. <code>"en"</code>).
     *
     * @param sLanguageCode
     *        The language code, or <code>null</code> for the default language.
     * @return this for chaining
     */
    @NonNull
    public Builder languageCode (@Nullable final String sLanguageCode)
    {
      m_sLanguageCode = sLanguageCode;
      return this;
    }

    /**
     * Set the transformer error listener applied during XSLT transformation.
     *
     * @param aErrorListener
     *        The error listener, or <code>null</code> to use the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder errorListener (@Nullable final ErrorListener aErrorListener)
    {
      m_aErrorListener = aErrorListener;
      return this;
    }

    /**
     * Set the URI resolver applied during XSLT transformation. The default is a
     * {@link DefaultTransformURIResolver} with the resource's parent directory as base URL.
     *
     * @param aURIResolver
     *        The URI resolver, or <code>null</code> to disable URI resolution entirely.
     * @return this for chaining
     */
    @NonNull
    public Builder uriResolver (@Nullable final URIResolver aURIResolver)
    {
      m_aURIResolver = aURIResolver;
      return this;
    }

    /**
     * Add or overwrite a single XSLT parameter.
     *
     * @param sName
     *        The parameter name. May neither be <code>null</code> nor empty.
     * @param aValue
     *        The parameter value. May be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder parameter (@NonNull @Nonempty final String sName, @Nullable final Object aValue)
    {
      ValueEnforcer.notEmpty (sName, "Name");
      m_aParameters.put (sName, aValue);
      return this;
    }

    /**
     * Replace all XSLT parameters with the given map.
     *
     * @param aParameters
     *        The new parameter map. May be <code>null</code> or empty to clear all parameters.
     * @return this for chaining
     */
    @NonNull
    public Builder parameters (@Nullable final Map <String, ?> aParameters)
    {
      m_aParameters.clear ();
      if (aParameters != null)
        m_aParameters.putAll (aParameters);
      return this;
    }

    /**
     * Toggle whether compilation results should be cached even when XSLT parameters are present.
     *
     * @param bForceCacheResult
     *        <code>true</code> to force caching, <code>false</code> for the default behaviour
     *        (bypass cache when parameters are set).
     * @return this for chaining
     */
    @NonNull
    public Builder forceCacheResult (final boolean bForceCacheResult)
    {
      m_bForceCacheResult = bForceCacheResult;
      return this;
    }

    /**
     * Set the per-template telemetry callback. When non-<code>null</code>, the final validation
     * stylesheet is compiled with Saxon's {@code COMPILE_WITH_TRACING} feature (separate cache
     * entry) and a {@link com.helger.schematron.api.telemetry.SchematronTraceListener} is installed
     * on each transform.
     *
     * @param a
     *        The telemetry callback, or <code>null</code> to disable telemetry. Default is
     *        <code>null</code>.
     * @return this for chaining
     * @since 10.0.0
     */
    @NonNull
    public Builder telemetry (@Nullable final ISchematronTemplateTelemetry a)
    {
      m_aTelemetry = a;
      return this;
    }

    /**
     * @return The built {@link SchematronSCHConfig} value object. Never <code>null</code>.
     */
    @Override
    @NonNull
    public SchematronSCHConfig build ()
    {
      return new SchematronSCHConfig (this);
    }

    /**
     * Convenience: build the config and compile via the {@link SchematronSCHCache#shared() shared
     * cache}.
     *
     * @return The compiled {@link SchematronSCH} instance. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     */
    @NonNull
    public SchematronSCH buildCached () throws SchematronException
    {
      return SchematronSCH.compileCached (build ());
    }

    /**
     * Convenience: build the config and compile via the given cache.
     *
     * @param aCache
     *        The cache instance to use. May not be <code>null</code>.
     * @return The compiled {@link SchematronSCH} instance. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     */
    @NonNull
    public SchematronSCH buildCached (@NonNull final SchematronSCHCache aCache) throws SchematronException
    {
      return SchematronSCH.compileCached (build (), aCache);
    }

    /**
     * Convenience: build the config and compile without caching.
     *
     * @return The compiled {@link SchematronSCH} instance. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     */
    @NonNull
    public SchematronSCH buildUncached () throws SchematronException
    {
      return SchematronSCH.compileUncached (build ());
    }
  }
}
