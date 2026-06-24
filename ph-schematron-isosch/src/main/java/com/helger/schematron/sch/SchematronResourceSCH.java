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
package com.helger.schematron.sch;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.function.Consumer;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.xml.sax.EntityResolver;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.builder.IBuilder;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.CSchematron;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.SchematronException;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.xslt.AbstractSchematronXSLTBasedResource;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.api.xslt.validator.ISchematronOutputValidityDeterminator;

/**
 * A Schematron resource that is based on the original SCH file. It uses ISO Schematron XSLT to
 * convert the SCH file to an XSLT before applying this XSLT onto the XML to be validated.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourceSCH extends AbstractSchematronXSLTBasedResource <SchematronResourceSCH>
{
  private String m_sPhase;
  private String m_sLanguageCode;
  private boolean m_bForceCacheResult = SchematronSCHConfig.DEFAULT_FORCE_CACHE_RESULT;
  private SchematronSCHCache m_aCache;

  /**
   * Constructor
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   */
  public SchematronResourceSCH (@NonNull final IReadableResource aSCHResource)
  {
    super (aSCHResource);
  }

  /**
   * Builder-based constructor. Applies all configurable state from the supplied {@link Builder} to
   * the newly-constructed resource. Invoked by {@link Builder#build()}.
   *
   * @param aBuilder
   *        The configured builder. May not be <code>null</code>.
   * @since 10.0.0
   */
  protected SchematronResourceSCH (@NonNull final Builder aBuilder)
  {
    super (aBuilder.m_aResource,
           aBuilder.m_bUseCache,
           aBuilder.m_bLenient,
           aBuilder.m_bEntityResolverSet ? aBuilder.m_aEntityResolver : null,
           aBuilder.m_bUseTelemetry,
           aBuilder.m_bPerAssertionResultTelemetry,
           aBuilder.m_aErrorListener,
           aBuilder.m_bURIResolverSet ? aBuilder.m_aURIResolver : null,
           aBuilder.m_aTFCustomizer,
           aBuilder.m_aTelemetry,
           aBuilder.m_aSOVDeterminator,
           aBuilder.m_bValidateSVRL);
    m_sPhase = aBuilder.m_sPhase;
    m_sLanguageCode = aBuilder.m_sLanguageCode;
    parameters ().setAll (aBuilder.m_aParameters);
    m_bForceCacheResult = aBuilder.m_bForceCacheResult;
    m_aCache = aBuilder.m_aCache;
    m_bPerRuleExecutionTelemetry = aBuilder.m_bPerRuleExecutionTelemetry;
  }

  @Override
  @NonNull
  protected String getTelemetryEngineID ()
  {
    return ESchematronEngine.ISO_SCHEMATRON.getID ();
  }

  @Nullable
  public final String getPhase ()
  {
    return m_sPhase;
  }

  /**
   * @param sPhase
   *        The Schematron phase to use, or <code>null</code> for the default phase.
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  public final void setPhase (@Nullable final String sPhase)
  {
    checkNotCompiledYet ();
    m_sPhase = sPhase;
  }

  @Nullable
  public final String getLanguageCode ()
  {
    return m_sLanguageCode;
  }

  /**
   * @param sLanguageCode
   *        The diagnostics language code, or <code>null</code> for the default language.
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  public final void setLanguageCode (@Nullable final String sLanguageCode)
  {
    checkNotCompiledYet ();
    m_sLanguageCode = sLanguageCode;
  }

  /**
   * @return <code>true</code> if internal caching of the result should be forced,
   *         <code>false</code> if not.
   * @since 5.2.1
   */
  public final boolean isForceCacheResult ()
  {
    return m_bForceCacheResult;
  }

  /**
   * Force the caching of results. This only applies when Schematron to XSLT conversion is
   * performed.
   *
   * @param bForceCacheResult
   *        <code>true</code> to force result caching, <code>false</code> to cache only if no
   *        parameters are present.
   * @since 5.2.1
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  public final void setForceCacheResult (final boolean bForceCacheResult)
  {
    checkNotCompiledYet ();
    m_bForceCacheResult = bForceCacheResult;
  }

  /**
   * @return The {@link SchematronSCHCache} this resource compiles against, or <code>null</code> to
   *         use {@link SchematronSCHCache#shared()}. Default is <code>null</code>.
   * @since 10.0.0
   */
  @Nullable
  public final SchematronSCHCache getCache ()
  {
    return m_aCache;
  }

  /**
   * @return A {@link SchematronSCHConfig} snapshot of this resource's current state.
   * @since 10.0.0
   */
  @NonNull
  public final SchematronSCHConfig toConfig ()
  {
    return SchematronSCHConfig.builder (getResource ())
                              .phase (m_sPhase)
                              .languageCode (m_sLanguageCode)
                              .errorListener (getErrorListener ())
                              .uriResolver (getURIResolver ())
                              .parameters (parameters ())
                              .forceCacheResult (m_bForceCacheResult)
                              .transformerFactoryCustomizer (getTransformerFactoryCustomizer ())
                              .telemetry (getEffectiveTemplateTelemetry ())
                              .build ();
  }

  @Override
  @Nullable
  public ISchematronXSLTBasedProvider getXSLTProvider ()
  {
    markCompiled ();
    final SchematronSCHConfig aConfig = toConfig ();
    if (!isUseCache ())
      return aConfig.compile ();

    try
    {
      final SchematronSCHCache aCache = m_aCache != null ? m_aCache : SchematronSCHCache.shared ();
      return aCache.getOrCompile (aConfig);
    }
    catch (final SchematronException ex)
    {
      throw new IllegalStateException ("Failed to compile Schematron", ex);
    }
  }

  // === Builder factories ===

  /**
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return A new {@link Builder} that produces a configured {@link SchematronResourceSCH}. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aSCHResource)
  {
    return new Builder (aSCHResource);
  }

  /**
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be <code>null</code> nor
   *        empty.
   * @return A new {@link Builder} reading the Schematron from the default classloader. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new Builder (new ClassPathResource (sSCHPath));
  }

  /**
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be <code>null</code> nor
   *        empty.
   * @param aClassLoader
   *        The class loader to be used to retrieve the classpath resource. May be
   *        <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given classloader. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromClassPath (@NonNull @Nonempty final String sSCHPath,
                                              @Nullable final ClassLoader aClassLoader)
  {
    return new Builder (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the Schematron from the file system. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return new Builder (new FileSystemResource (sSCHPath));
  }

  /**
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given file. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromFile (@NonNull final File aSCHFile)
  {
    return new Builder (new FileSystemResource (aSCHFile));
  }

  /**
   * @param sSCHURL
   *        The URL to the Schematron rules. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the Schematron from the given URL. Never
   *         <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new Builder (new URLResource (sSCHURL));
  }

  /**
   * @param aSCHURL
   *        The URL to the Schematron rules. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given URL. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromURL (@NonNull final URL aSCHURL)
  {
    return new Builder (new URLResource (aSCHURL));
  }

  /**
   * @param sResourceID
   *        Resource ID to be used as the cache key. Should neither be <code>null</code> nor empty.
   * @param aSchematronIS
   *        The {@link InputStream} to read the Schematron rules from. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given input stream. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromInputStream (@NonNull @Nonempty final String sResourceID,
                                                @NonNull final InputStream aSchematronIS)
  {
    return new Builder (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  /**
   * @param aSchematron
   *        The byte array representing the Schematron. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given byte array. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromByteArray (@NonNull final byte [] aSchematron)
  {
    return new Builder (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * @param sSchematron
   *        The String representing the Schematron. May not be <code>null</code>.
   * @param aCharset
   *        The charset used to encode the string to bytes. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the encoded string bytes. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromString (@NonNull final String sSchematron, @NonNull final Charset aCharset)
  {
    return builderFromByteArray (sSchematron.getBytes (aCharset));
  }

  /**
   * @param sSchematron
   *        The String representing the Schematron. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the encoded string bytes. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromString (@NonNull final String sSchematron)
  {
    return builderFromString (sSchematron, StandardCharsets.UTF_8);
  }

  // === Eager-compile shortcuts ===

  /**
   * Convenience: equivalent to {@code builder(aSCHResource).buildCached()}.
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return The fully compiled resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourceSCH compileCached (@NonNull final IReadableResource aSCHResource) throws SchematronException
  {
    return builder (aSCHResource).buildCached ();
  }

  /**
   * Convenience: equivalent to {@code builder(aSCHResource).buildCached(aCache)}.
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @param aCache
   *        The cache instance to use. May not be <code>null</code>.
   * @return The fully compiled resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourceSCH compileCached (@NonNull final IReadableResource aSCHResource,
                                                     @NonNull final SchematronSCHCache aCache) throws SchematronException
  {
    return builder (aSCHResource).buildCached (aCache);
  }

  /**
   * Convenience: equivalent to {@code builder(aSCHResource).buildUncached()}.
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return The configured resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourceSCH compileUncached (@NonNull final IReadableResource aSCHResource) throws SchematronException
  {
    return builder (aSCHResource).buildUncached ();
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be <code>null</code> nor
   *        empty.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromClassPath(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be <code>null</code> nor
   *        empty.
   * @param aClassLoader
   *        The class loader to be used to retrieve the classpath resource. May be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.0.4
   * @deprecated since 10.0.0 — use {@link #builderFromClassPath(String, ClassLoader)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromClassPath (@NonNull @Nonempty final String sSCHPath,
                                                     @Nullable final ClassLoader aClassLoader)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be <code>null</code> nor empty.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromFile(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromFile(File)} instead. Will remain for backward
   *             compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromFile (@NonNull final File aSCHFile)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided at a URL
   *
   * @param sSCHURL
   *        The URL to the Schematron rules. May neither be <code>null</code> nor empty.
   * @return Never <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   * @since 6.2.6
   * @deprecated since 10.0.0 — use {@link #builderFromURL(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourceSCH (new URLResource (sSCHURL));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided at a URL
   *
   * @param aSCHURL
   *        The URL to the Schematron rules. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.6
   * @deprecated since 10.0.0 — use {@link #builderFromURL(URL)} instead. Will remain for backward
   *             compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromURL (@NonNull final URL aSCHURL)
  {
    return new SchematronResourceSCH (new URLResource (aSCHURL));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided by an arbitrary
   * {@link InputStream}.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param sResourceID
   *        Resource ID to be used as the cache key. Should neither be <code>null</code> nor empty.
   * @param aSchematronIS
   *        The {@link InputStream} to read the Schematron rules from. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.6
   * @deprecated since 10.0.0 — use {@link #builderFromInputStream(String, InputStream)} instead.
   *             Will remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromInputStream (@NonNull @Nonempty final String sResourceID,
                                                       @NonNull final InputStream aSchematronIS)
  {
    return new SchematronResourceSCH (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided by an arbitrary byte
   * array.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param aSchematron
   *        The byte array representing the Schematron. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.6
   * @deprecated since 10.0.0 — use {@link #builderFromByteArray(byte[])} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromByteArray (@NonNull final byte [] aSchematron)
  {
    return new SchematronResourceSCH (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided by an arbitrary
   * String.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param sSchematron
   *        The String representing the Schematron. May not be <code>null</code> .
   * @param aCharset
   *        The charset to be used to convert the String to a byte array.
   * @return Never <code>null</code>.
   * @since 6.2.6
   * @deprecated since 10.0.0 — use {@link #builderFromString(String, Charset)} instead. Will remain
   *             for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceSCH fromString (@NonNull final String sSchematron, @NonNull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }

  // === Builder ===

  /**
   * Fluent builder for {@link SchematronResourceSCH}. Not thread-safe.
   *
   * @since 10.0.0
   */
  @NotThreadSafe
  public static final class Builder implements IBuilder <SchematronResourceSCH>
  {
    private final IReadableResource m_aResource;
    private boolean m_bUseCache = AbstractSchematronResource.DEFAULT_USE_CACHE;
    private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;
    private EntityResolver m_aEntityResolver;
    private boolean m_bEntityResolverSet;
    private String m_sPhase;
    private String m_sLanguageCode;
    private ErrorListener m_aErrorListener;
    private URIResolver m_aURIResolver;
    private boolean m_bURIResolverSet;
    private final ICommonsOrderedMap <String, Object> m_aParameters = new CommonsLinkedHashMap <> ();
    private boolean m_bForceCacheResult = SchematronSCHConfig.DEFAULT_FORCE_CACHE_RESULT;
    private Consumer <TransformerFactory> m_aTFCustomizer;
    private ISchematronTemplateTelemetry m_aTelemetry;
    private ISchematronOutputValidityDeterminator m_aSOVDeterminator;
    private boolean m_bValidateSVRL = AbstractSchematronXSLTBasedResource.DEFAULT_VALIDATE_SVRL;
    private boolean m_bUseTelemetry;
    private boolean m_bPerAssertionResultTelemetry;
    private boolean m_bPerRuleExecutionTelemetry;
    private SchematronSCHCache m_aCache;

    Builder (@NonNull final IReadableResource aResource)
    {
      ValueEnforcer.notNull (aResource, "Resource");
      m_aResource = aResource;
    }

    /**
     * @param b
     *        <code>true</code> to participate in the compilation cache, <code>false</code> to
     *        bypass it. Default is {@link AbstractSchematronResource#DEFAULT_USE_CACHE}.
     * @return this for chaining
     */
    @NonNull
    public Builder useCache (final boolean b)
    {
      m_bUseCache = b;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to allow deprecated Schematron namespaces, <code>false</code> for
     *        strict mode.
     * @return this for chaining
     */
    @NonNull
    public Builder lenient (final boolean b)
    {
      m_bLenient = b;
      return this;
    }

    /**
     * @param a
     *        The XML entity resolver, or <code>null</code> to disable entity resolution. Replaces
     *        the resource-derived default.
     * @return this for chaining
     */
    @NonNull
    public Builder entityResolver (@Nullable final EntityResolver a)
    {
      m_aEntityResolver = a;
      m_bEntityResolverSet = true;
      return this;
    }

    /**
     * @param s
     *        The Schematron phase to use, or <code>null</code> for the default phase.
     * @return this for chaining
     */
    @NonNull
    public Builder phase (@Nullable final String s)
    {
      m_sPhase = s;
      return this;
    }

    /**
     * @param s
     *        The diagnostics language code (e.g. <code>"en"</code>), or <code>null</code> for the
     *        default language.
     * @return this for chaining
     */
    @NonNull
    public Builder languageCode (@Nullable final String s)
    {
      m_sLanguageCode = s;
      return this;
    }

    /**
     * @param a
     *        The XSLT error listener, or <code>null</code> to use the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder errorListener (@Nullable final ErrorListener a)
    {
      m_aErrorListener = a;
      return this;
    }

    /**
     * @param a
     *        The URI resolver, or <code>null</code> to use the engine default. Replaces the
     *        resource-derived default.
     * @return this for chaining
     */
    @NonNull
    public Builder uriResolver (@Nullable final URIResolver a)
    {
      m_aURIResolver = a;
      m_bURIResolverSet = true;
      return this;
    }

    /**
     * Add an XSLT parameter. Latter call wins.
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
     * @param b
     *        <code>true</code> to force result caching even when parameters are set,
     *        <code>false</code> for the default behaviour. Default is
     *        {@link SchematronSCHConfig#DEFAULT_FORCE_CACHE_RESULT}.
     * @return this for chaining
     */
    @NonNull
    public Builder forceCacheResult (final boolean b)
    {
      m_bForceCacheResult = b;
      return this;
    }

    /**
     * @param a
     *        The {@link TransformerFactory} customizer, or <code>null</code> to clear.
     * @return this for chaining
     */
    @NonNull
    public Builder transformerFactoryCustomizer (@Nullable final Consumer <TransformerFactory> a)
    {
      m_aTFCustomizer = a;
      return this;
    }

    /**
     * @param a
     *        The per-template telemetry callback, or <code>null</code> to disable telemetry.
     * @return this for chaining
     */
    @NonNull
    public Builder telemetry (@Nullable final ISchematronTemplateTelemetry a)
    {
      m_aTelemetry = a;
      return this;
    }

    /**
     * Enable or disable runtime ph-telemetry. When enabled, every validation emits a
     * {@code schematron.validate} span, the aggregate counters (failed asserts, fired reports,
     * fired rules, active patterns) and a {@code schematron.validate.duration} histogram entry via
     * ph-telemetry. Mirrors the pure engine's switch and is zero-cost when no ph-telemetry SPI is
     * installed.
     *
     * @param b
     *        <code>true</code> to enable aggregate-level telemetry.
     * @return this for chaining
     * @since 10.0.0
     */
    @NonNull
    public Builder telemetry (final boolean b)
    {
      m_bUseTelemetry = b;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to emit a {@code schematron.svrl.assertion} span per failed-assert /
     *        successful-report (post-evaluation findings from the SVRL). Only meaningful when
     *        {@link #telemetry(boolean)} is also <code>true</code>.
     * @return this for chaining
     * @since 10.0.0
     */
    @NonNull
    public Builder perAssertionResultTelemetry (final boolean b)
    {
      m_bPerAssertionResultTelemetry = b;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to record per-rule execution timing
     *        ({@code schematron.rule.duration}) via the Saxon trace listener for ranking the most
     *        expensive rules. Forces {@code COMPILE_WITH_TRACING} (1.5x-3x slower). Only meaningful
     *        when {@link #telemetry(boolean)} is also <code>true</code>.
     * @return this for chaining
     * @since 10.0.0
     */
    @NonNull
    public Builder perRuleExecutionTelemetry (final boolean b)
    {
      m_bPerRuleExecutionTelemetry = b;
      return this;
    }

    /**
     * @param a
     *        The output validity determinator. May not be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder outputValidityDeterminator (@NonNull final ISchematronOutputValidityDeterminator a)
    {
      ValueEnforcer.notNull (a, "SchematronOutputValidityDeterminator");
      m_aSOVDeterminator = a;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to validate the produced SVRL against its XSD, <code>false</code> to
     *        skip validation. Default is
     *        {@link AbstractSchematronXSLTBasedResource#DEFAULT_VALIDATE_SVRL}.
     * @return this for chaining
     */
    @NonNull
    public Builder validateSVRL (final boolean b)
    {
      m_bValidateSVRL = b;
      return this;
    }

    /**
     * @param a
     *        The {@link SchematronSCHCache} to use, or <code>null</code> for the shared cache.
     * @return this for chaining
     */
    @NonNull
    public Builder cache (@Nullable final SchematronSCHCache a)
    {
      m_aCache = a;
      return this;
    }

    /**
     * @return A new {@link SchematronResourceSCH} configured with the values of this builder. Never
     *         <code>null</code>.
     */
    @NonNull
    public SchematronResourceSCH build ()
    {
      return new SchematronResourceSCH (this);
    }

    /**
     * Build the resource and eagerly compile via the {@link SchematronSCHCache#shared() shared
     * cache} (or the cache configured on this builder). Surfaces compilation failures as
     * {@link SchematronException} instead of letting them appear lazily on the first validation
     * call.
     *
     * @return The fully compiled resource. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     * @since 10.0.0
     */
    @NonNull
    public SchematronResourceSCH buildCached () throws SchematronException
    {
      useCache (true);
      final SchematronResourceSCH ret = build ();
      final SchematronSCHCache aCache = m_aCache != null ? m_aCache : SchematronSCHCache.shared ();
      aCache.getOrCompile (ret.toConfig ());
      return ret;
    }

    /**
     * Build the resource and eagerly compile via the supplied cache.
     *
     * @param aCache
     *        The cache instance to use. May not be <code>null</code>.
     * @return The fully compiled resource. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     * @since 10.0.0
     */
    @NonNull
    public SchematronResourceSCH buildCached (@NonNull final SchematronSCHCache aCache) throws SchematronException
    {
      ValueEnforcer.notNull (aCache, "Cache");
      useCache (true).cache (aCache);
      final SchematronResourceSCH ret = build ();
      aCache.getOrCompile (ret.toConfig ());
      return ret;
    }

    /**
     * Build the resource and eagerly compile without using any cache. The validation result is
     * discarded; subsequent validation calls will recompile per the resource's lazy-compile
     * semantics. Useful as a fail-fast verification at construction time.
     *
     * @return The configured resource. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     * @since 10.0.0
     */
    @NonNull
    public SchematronResourceSCH buildUncached () throws SchematronException
    {
      useCache (false);
      final SchematronResourceSCH ret = build ();
      ret.toConfig ().compile ();
      return ret;
    }
  }
}
