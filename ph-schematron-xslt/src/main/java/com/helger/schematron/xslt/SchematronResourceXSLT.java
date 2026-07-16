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
package com.helger.schematron.xslt;

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
 * A Schematron resource that is based on an existing, pre-compiled XSLT script.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourceXSLT extends AbstractSchematronXSLTBasedResource <SchematronResourceXSLT>
{
  private SchematronXSLTCache m_aCache;

  /**
   * Constructor
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  public SchematronResourceXSLT (@NonNull final IReadableResource aXSLTResource)
  {
    super (aXSLTResource);
  }

  /**
   * Builder-based constructor. Applies all configurable state from the supplied {@link Builder} to
   * the newly-constructed resource. Invoked by {@link Builder#build()}.
   *
   * @param aBuilder
   *        The configured builder. May not be <code>null</code>.
   * @since 10.0.0
   */
  protected SchematronResourceXSLT (@NonNull final Builder aBuilder)
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
    parameters ().setAll (aBuilder.m_aParameters);
    m_aCache = aBuilder.m_aCache;
    m_bPerRuleExecutionTelemetry = aBuilder.m_bPerRuleExecutionTelemetry;
  }

  @Override
  @NonNull
  protected String getTelemetryEngineID ()
  {
    return ESchematronEngine.XSLT_PREBUILT.getID ();
  }

  /**
   * @return The {@link SchematronXSLTCache} this resource compiles against, or <code>null</code> to
   *         use {@link SchematronXSLTCache#shared()}. Default is <code>null</code>.
   * @since 10.0.0
   */
  @Nullable
  public final SchematronXSLTCache getCache ()
  {
    return m_aCache;
  }

  /**
   * @return The new builder-style config matching this resource's current state.
   * @since 10.0.0
   */
  @NonNull
  public final SchematronXSLTConfig toConfig ()
  {
    return SchematronXSLTConfig.builder (getResource ())
                               .errorListener (getErrorListener ())
                               .uriResolver (getURIResolver ())
                               .parameters (parameters ())
                               .transformerFactoryCustomizer (getTransformerFactoryCustomizer ())
                               .telemetry (getEffectiveTemplateTelemetry ())
                               .build ();
  }

  @Override
  @Nullable
  public ISchematronXSLTBasedProvider getXSLTProvider ()
  {
    markCompiled ();
    final SchematronXSLTConfig aConfig = toConfig ();
    try
    {
      if (!isUseCache ())
        return aConfig.compile ();
      final SchematronXSLTCache aCache = m_aCache != null ? m_aCache : SchematronXSLTCache.shared ();
      return aCache.getOrCompile (aConfig);
    }
    catch (final com.helger.schematron.SchematronException ex)
    {
      throw new IllegalStateException ("Failed to compile XSLT", ex);
    }
  }

  // === Builder factories ===

  /**
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   * @return A new {@link Builder} that produces a configured {@link SchematronResourceXSLT}. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aXSLTResource)
  {
    return new Builder (aXSLTResource);
  }

  /**
   * @param sXSLTPath
   *        The classpath relative path to the Schematron XSLT file. May neither be
   *        <code>null</code> nor empty.
   * @return A new {@link Builder} reading the XSLT from the default classloader. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromClassPath (@NonNull @Nonempty final String sXSLTPath)
  {
    return new Builder (new ClassPathResource (sXSLTPath));
  }

  /**
   * @param sXSLTPath
   *        The classpath relative path to the Schematron XSLT file. May neither be
   *        <code>null</code> nor empty.
   * @param aClassLoader
   *        The class loader to be used to retrieve the classpath resource. May be
   *        <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given classloader. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromClassPath (@NonNull @Nonempty final String sXSLTPath,
                                              @Nullable final ClassLoader aClassLoader)
  {
    return new Builder (new ClassPathResource (sXSLTPath, aClassLoader));
  }

  /**
   * @param sXSLTPath
   *        The file system path to the Schematron XSLT file. May neither be <code>null</code> nor
   *        empty.
   * @return A new {@link Builder} reading the XSLT from the file system. Never <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromFile (@NonNull @Nonempty final String sXSLTPath)
  {
    return new Builder (new FileSystemResource (sXSLTPath));
  }

  /**
   * @param aXSLTFile
   *        The {@link File} of the Schematron XSLT file. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given file. Never <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromFile (@NonNull final File aXSLTFile)
  {
    return new Builder (new FileSystemResource (aXSLTFile));
  }

  /**
   * @param sXSLTURL
   *        The URL to the XSLT Schematron rules. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the XSLT from the given URL. Never <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromURL (@NonNull @Nonempty final String sXSLTURL) throws MalformedURLException
  {
    return new Builder (new URLResource (sXSLTURL));
  }

  /**
   * @param aXSLTURL
   *        The URL to the XSLT Schematron rules. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given URL. Never <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromURL (@NonNull final URL aXSLTURL)
  {
    return new Builder (new URLResource (aXSLTURL));
  }

  /**
   * @param sResourceID
   *        Resource ID to be used as the cache key. Should neither be <code>null</code> nor empty.
   * @param aXSLTIS
   *        The {@link InputStream} to read the XSLT Schematron rules from. May not be
   *        <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given input stream. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromInputStream (@NonNull @Nonempty final String sResourceID,
                                                @NonNull final InputStream aXSLTIS)
  {
    return new Builder (new ReadableResourceInputStream (sResourceID, aXSLTIS));
  }

  /**
   * @param aXSLT
   *        The byte array representing the XSLT Schematron. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given byte array. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromByteArray (@NonNull final byte [] aXSLT)
  {
    return new Builder (new ReadableResourceByteArray (aXSLT));
  }

  /**
   * @param sXSLT
   *        The String representing the XSLT Schematron. May not be <code>null</code>.
   * @param aCharset
   *        The charset to be used to convert the String to a byte array. May not be
   *        <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the encoded string bytes. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromString (@NonNull final String sXSLT, @NonNull final Charset aCharset)
  {
    return builderFromByteArray (sXSLT.getBytes (aCharset));
  }

  /**
   * @param sXSLT
   *        The String representing the XSLT Schematron. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the encoded string bytes. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromString (@NonNull final String sXSLT)
  {
    return builderFromString (sXSLT, StandardCharsets.UTF_8);
  }

  // === Eager-compile shortcuts ===

  /**
   * Convenience: equivalent to {@code builder(aXSLTResource).buildCached()}.
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   * @return The fully compiled resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourceXSLT compileCached (@NonNull final IReadableResource aXSLTResource) throws SchematronException
  {
    return builder (aXSLTResource).buildCached ();
  }

  /**
   * Convenience: equivalent to {@code builder(aXSLTResource).buildCached(aCache)}.
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   * @param aCache
   *        The cache instance to use. May not be <code>null</code>.
   * @return The fully compiled resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourceXSLT compileCached (@NonNull final IReadableResource aXSLTResource,
                                                      @NonNull final SchematronXSLTCache aCache) throws SchematronException
  {
    return builder (aXSLTResource).buildCached (aCache);
  }

  /**
   * Convenience: equivalent to {@code builder(aXSLTResource).buildUncached()}.
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   * @return The configured resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourceXSLT compileUncached (@NonNull final IReadableResource aXSLTResource) throws SchematronException
  {
    return builder (aXSLTResource).buildUncached ();
  }

  /**
   * Create a new {@link SchematronResourceXSLT} resource.
   *
   * @param sXSLTPath
   *        The classpath relative path to the Schematron XSLT file. May neither be
   *        <code>null</code> nor empty.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromClassPath(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromClassPath (@NonNull @Nonempty final String sXSLTPath)
  {
    return new SchematronResourceXSLT (new ClassPathResource (sXSLTPath));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} resource.
   *
   * @param sXSLTPath
   *        The classpath relative path to the Schematron XSLT file. May neither be
   *        <code>null</code> nor empty.
   * @param aClassLoader
   *        The class loader to be used to retrieve the classpath resource. May be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromClassPath(String, ClassLoader)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromClassPath (@NonNull @Nonempty final String sXSLTPath,
                                                      @Nullable final ClassLoader aClassLoader)
  {
    return new SchematronResourceXSLT (new ClassPathResource (sXSLTPath, aClassLoader));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} resource.
   *
   * @param sXSLTPath
   *        The file system path to the Schematron XSLT file. May neither be <code>null</code> nor
   *        empty.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromFile(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromFile (@NonNull @Nonempty final String sXSLTPath)
  {
    return new SchematronResourceXSLT (new FileSystemResource (sXSLTPath));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} resource.
   *
   * @param aXSLTFile
   *        The {@link File} of the Schematron XSLT file. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromFile(File)} instead. Will remain for backward
   *             compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromFile (@NonNull final File aXSLTFile)
  {
    return new SchematronResourceXSLT (new FileSystemResource (aXSLTFile));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided at a URL
   *
   * @param sXSLTURL
   *        The URL to the XSLT Schematron rules. May neither be <code>null</code> nor empty.
   * @return Never <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   * @deprecated since 10.0.0 — use {@link #builderFromURL(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromURL (@NonNull @Nonempty final String sXSLTURL) throws MalformedURLException
  {
    return new SchematronResourceXSLT (new URLResource (sXSLTURL));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided at a URL
   *
   * @param aXSLTURL
   *        The URL to the XSLT Schematron rules. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromURL(URL)} instead. Will remain for backward
   *             compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromURL (@NonNull final URL aXSLTURL)
  {
    return new SchematronResourceXSLT (new URLResource (aXSLTURL));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided by an arbitrary
   * {@link InputStream}.<br>
   *
   * @param sResourceID
   *        Resource ID to be used as the cache key. Should neither be <code>null</code> nor empty.
   * @param aXSLTIS
   *        The {@link InputStream} to read the XSLT Schematron rules from. May not be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromInputStream(String, InputStream)} instead.
   *             Will remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromInputStream (@NonNull @Nonempty final String sResourceID,
                                                        @NonNull final InputStream aXSLTIS)
  {
    return new SchematronResourceXSLT (new ReadableResourceInputStream (sResourceID, aXSLTIS));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided by an arbitrary
   * byte array.<br>
   *
   * @param aXSLT
   *        The byte array representing the XSLT Schematron. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromByteArray(byte[])} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromByteArray (@NonNull final byte [] aXSLT)
  {
    return new SchematronResourceXSLT (new ReadableResourceByteArray (aXSLT));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided by an arbitrary
   * String.<br>
   *
   * @param sXSLT
   *        The String representing the XSLT Schematron. May not be <code>null</code>.
   * @param aCharset
   *        The charset to be used to convert the String to a byte array.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromString(String, Charset)} instead. Will remain
   *             for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourceXSLT fromString (@NonNull final String sXSLT, @NonNull final Charset aCharset)
  {
    return fromByteArray (sXSLT.getBytes (aCharset));
  }

  // === Builder ===

  /**
   * Fluent builder for {@link SchematronResourceXSLT}. Not thread-safe.
   *
   * @since 10.0.0
   */
  @NotThreadSafe
  public static final class Builder implements IBuilder <SchematronResourceXSLT>
  {
    private final IReadableResource m_aResource;
    private boolean m_bUseCache = AbstractSchematronResource.DEFAULT_USE_CACHE;
    private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;
    private EntityResolver m_aEntityResolver;
    private boolean m_bEntityResolverSet;
    private ErrorListener m_aErrorListener;
    private URIResolver m_aURIResolver;
    private boolean m_bURIResolverSet;
    private final ICommonsOrderedMap <String, Object> m_aParameters = new CommonsLinkedHashMap <> ();
    private Consumer <TransformerFactory> m_aTFCustomizer;
    private ISchematronTemplateTelemetry m_aTelemetry;
    private ISchematronOutputValidityDeterminator m_aSOVDeterminator;
    private boolean m_bValidateSVRL = AbstractSchematronXSLTBasedResource.DEFAULT_VALIDATE_SVRL;
    private SchematronXSLTCache m_aCache;
    private boolean m_bUseTelemetry;
    private boolean m_bPerAssertionResultTelemetry;
    private boolean m_bPerRuleExecutionTelemetry;

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
     *        The {@link SchematronXSLTCache} to use, or <code>null</code> for the shared cache.
     * @return this for chaining
     */
    @NonNull
    public Builder cache (@Nullable final SchematronXSLTCache a)
    {
      m_aCache = a;
      return this;
    }

    /**
     * @return A new {@link SchematronResourceXSLT} configured with the values of this builder.
     *         Never <code>null</code>.
     */
    @NonNull
    public SchematronResourceXSLT build ()
    {
      return new SchematronResourceXSLT (this);
    }

    /**
     * Build the resource and eagerly compile via the {@link SchematronXSLTCache#shared() shared
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
    public SchematronResourceXSLT buildCached () throws SchematronException
    {
      useCache (true);
      final SchematronResourceXSLT ret = build ();
      final SchematronXSLTCache aCache = m_aCache != null ? m_aCache : SchematronXSLTCache.shared ();
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
    public SchematronResourceXSLT buildCached (@NonNull final SchematronXSLTCache aCache) throws SchematronException
    {
      ValueEnforcer.notNull (aCache, "Cache");

      useCache (true).cache (aCache);
      final SchematronResourceXSLT ret = build ();
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
    public SchematronResourceXSLT buildUncached () throws SchematronException
    {
      useCache (false);
      final SchematronResourceXSLT ret = build ();
      ret.toConfig ().compile ();
      return ret;
    }
  }
}
