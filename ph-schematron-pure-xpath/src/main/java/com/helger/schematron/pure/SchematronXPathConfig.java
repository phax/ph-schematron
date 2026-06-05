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
package com.helger.schematron.pure;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.xml.sax.EntityResolver;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.builder.IBuilder;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.AbstractMemoryReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.SchematronException;
import com.helger.schematron.api.cache.ISchematronCompilation;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.bound.PSBoundSchemaCacheKey;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;

/**
 * Immutable configuration for compiling a Schematron file with the pure-Java XPath engine. The
 * cache-key dimensions are <code>(resource, phase, xpathConfig)</code> — matching the legacy
 * {@link PSBoundSchemaCacheKey} equality semantics. Runtime hooks (error handler, custom
 * validation handler, entity resolver, telemetry flags) participate in compilation but not in
 * caching.
 * <p>
 * In-memory resources always bypass the cache.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class SchematronXPathConfig implements ISchematronCompilation <IPSBoundSchema>
{
  private final IReadableResource m_aResource;
  private final String m_sPhase;
  private final IPSErrorHandler m_aErrorHandler;
  private final IPSValidationHandler m_aCustomValidationHandler;
  private final IXPathConfig m_aXPathConfig;
  private final EntityResolver m_aEntityResolver;
  private final boolean m_bLenient;
  private final PSBoundSchemaCacheKey m_aCacheKey;

  private SchematronXPathConfig (@NonNull final Builder b)
  {
    m_aResource = b.m_aResource;
    m_sPhase = b.m_sPhase;
    m_aErrorHandler = b.m_aErrorHandler;
    m_aCustomValidationHandler = b.m_aCustomValidationHandler;
    m_aXPathConfig = b.m_aXPathConfig;
    m_aEntityResolver = b.m_aEntityResolver;
    m_bLenient = b.m_bLenient;
    m_aCacheKey = new PSBoundSchemaCacheKey (m_aResource,
                                             m_sPhase,
                                             m_aErrorHandler,
                                             m_aCustomValidationHandler,
                                             m_aXPathConfig,
                                             m_aEntityResolver,
                                             m_bLenient);
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
   * @return The Schematron error handler, or <code>null</code> for the engine default.
   */
  @Nullable
  public IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  /**
   * @return The custom validation handler invoked during validation, or <code>null</code> for none.
   */
  @Nullable
  public IPSValidationHandler getCustomValidationHandler ()
  {
    return m_aCustomValidationHandler;
  }

  /**
   * @return The XPath configuration used during schema binding. Never <code>null</code>.
   *         Participates in the cache key.
   */
  @NonNull
  public IXPathConfig getXPathConfig ()
  {
    return m_aXPathConfig;
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
   * @return <code>true</code> if schema binding is in lenient mode. Default is <code>false</code>.
   */
  public boolean isLenient ()
  {
    return m_bLenient;
  }

  /**
   * @return The underlying legacy cache key. Useful for code that already speaks
   *         {@link PSBoundSchemaCacheKey}. Never <code>null</code>.
   */
  @NonNull
  public PSBoundSchemaCacheKey getBoundSchemaCacheKey ()
  {
    return m_aCacheKey;
  }

  @Override
  @NonNull
  public Object getCacheKey ()
  {
    return m_aCacheKey;
  }

  @Override
  public boolean canCacheResult ()
  {
    // In-memory resources cannot be cached — preserves legacy behavior
    return !(m_aResource instanceof AbstractMemoryReadableResource);
  }

  @Override
  @NonNull
  public IPSBoundSchema compile () throws SchematronException
  {
    return m_aCacheKey.createBoundSchema ();
  }

  /**
   * @return A new {@link Builder} pre-populated with the values from this config. Never
   *         <code>null</code>.
   */
  @NonNull
  public Builder toBuilder ()
  {
    return new Builder (m_aResource).phase (m_sPhase)
                                    .errorHandler (m_aErrorHandler)
                                    .customValidationHandler (m_aCustomValidationHandler)
                                    .xpathConfig (m_aXPathConfig)
                                    .entityResolver (m_aEntityResolver)
                                    .lenient (m_bLenient);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Resource", m_aResource)
                                       .appendIfNotNull ("Phase", m_sPhase)
                                       .appendIfNotNull ("ErrorHandler", m_aErrorHandler)
                                       .appendIfNotNull ("CustomValidationHandler", m_aCustomValidationHandler)
                                       .append ("XPathConfig", m_aXPathConfig)
                                       .appendIfNotNull ("EntityResolver", m_aEntityResolver)
                                       .append ("Lenient", m_bLenient)
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

  // === Builder ===

  @NotThreadSafe
  public static final class Builder implements IBuilder <SchematronXPathConfig>
  {
    private final IReadableResource m_aResource;
    private String m_sPhase;
    private IPSErrorHandler m_aErrorHandler;
    private IPSValidationHandler m_aCustomValidationHandler;
    private IXPathConfig m_aXPathConfig = XPathConfigBuilder.DEFAULT;
    private EntityResolver m_aEntityResolver;
    private boolean m_bLenient;

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
     * Set the Schematron error handler.
     *
     * @param a
     *        The error handler, or <code>null</code> for the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder errorHandler (@Nullable final IPSErrorHandler a)
    {
      m_aErrorHandler = a;
      return this;
    }

    /**
     * Set the custom validation handler invoked during validation.
     *
     * @param a
     *        The validation handler, or <code>null</code> for none.
     * @return this for chaining
     */
    @NonNull
    public Builder customValidationHandler (@Nullable final IPSValidationHandler a)
    {
      m_aCustomValidationHandler = a;
      return this;
    }

    /**
     * Set the XPath configuration used during schema binding.
     *
     * @param a
     *        The XPath configuration. May not be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder xpathConfig (@NonNull final IXPathConfig a)
    {
      ValueEnforcer.notNull (a, "XPathConfig");
      m_aXPathConfig = a;
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
     * Toggle lenient schema binding mode.
     *
     * @param b
     *        <code>true</code> for lenient mode, <code>false</code> for strict mode (default).
     * @return this for chaining
     */
    @NonNull
    public Builder lenient (final boolean b)
    {
      m_bLenient = b;
      return this;
    }

    /**
     * @return The built {@link SchematronXPathConfig} value object. Never <code>null</code>.
     */
    @Override
    @NonNull
    public SchematronXPathConfig build ()
    {
      return new SchematronXPathConfig (this);
    }

    /**
     * Build the config and compile via the {@link SchematronXPathCache#shared() shared cache}.
     *
     * @return The compiled {@link SchematronXPath} instance. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     */
    @NonNull
    public SchematronXPath buildCached () throws SchematronException
    {
      return SchematronXPath.compileCached (build ());
    }

    /**
     * Build the config and compile via the supplied cache.
     *
     * @param aCache
     *        The cache instance to use. May not be <code>null</code>.
     * @return The compiled {@link SchematronXPath} instance. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     */
    @NonNull
    public SchematronXPath buildCached (@NonNull final SchematronXPathCache aCache) throws SchematronException
    {
      return SchematronXPath.compileCached (build (), aCache);
    }

    /**
     * Build the config and compile without using any cache.
     *
     * @return The compiled {@link SchematronXPath} instance. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     */
    @NonNull
    public SchematronXPath buildUncached () throws SchematronException
    {
      return SchematronXPath.compileUncached (build ());
    }
  }
}
