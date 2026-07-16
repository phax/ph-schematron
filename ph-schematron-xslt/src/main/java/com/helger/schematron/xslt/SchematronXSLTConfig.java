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
import java.util.Map;
import java.util.function.Consumer;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.builder.IBuilder;
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
import com.helger.schematron.api.xslt.SchematronXSLTBaseURL;
import com.helger.xml.transform.DefaultTransformURIResolver;

/**
 * Immutable configuration for using a pre-built XSLT script as the Schematron validator. The only
 * cache-key dimension is the resource ID — the runtime hooks (error listener, URI resolver, XSLT
 * parameters) are not part of the key but participate in compilation/transformation.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class SchematronXSLTConfig implements ISchematronCompilation <ISchematronXSLTBasedProvider>
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronXSLTConfig.class);

  private final IReadableResource m_aResource;
  private final ErrorListener m_aErrorListener;
  private final URIResolver m_aURIResolver;
  private final ICommonsOrderedMap <String, Object> m_aParameters;
  private final ISchematronTemplateTelemetry m_aTelemetry;
  private final Consumer <TransformerFactory> m_aTFCustomizer;

  public static record CacheKey (String key) implements ISchematronCompilationCacheKey
  {}

  private SchematronXSLTConfig (@NonNull final Builder b)
  {
    m_aResource = b.m_aResource;
    m_aErrorListener = b.m_aErrorListener;
    m_aURIResolver = b.m_aURIResolver;
    m_aParameters = new CommonsLinkedHashMap <> (b.m_aParameters);
    m_aTelemetry = b.m_aTelemetry;
    m_aTFCustomizer = b.m_aTFCustomizer;
  }

  @Override
  @NonNull
  public IReadableResource getResource ()
  {
    return m_aResource;
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
   * @return The per-template telemetry callback configured for the XSLT transformation, or
   *         <code>null</code> if telemetry is disabled. When non-<code>null</code>, the stylesheet
   *         is compiled with Saxon's {@code COMPILE_WITH_TRACING} feature and the trace-enabled
   *         provider is cached under a separate key (see {@link #getCacheKey()}).
   */
  @Nullable
  public ISchematronTemplateTelemetry getTelemetry ()
  {
    return m_aTelemetry;
  }

  /**
   * @return <code>true</code> if {@link #getTelemetry()} is non-<code>null</code>, i.e. the
   *         stylesheet should be compiled with Saxon tracing enabled.
   */
  public boolean isTracingEnabled ()
  {
    return m_aTelemetry != null;
  }

  /**
   * @return The custom {@link TransformerFactory} customizer applied to the compile-step
   *         transformer factory just before the validation stylesheet is compiled, or
   *         <code>null</code> if none. Used to register Saxon extension functions or otherwise
   *         tweak the factory. When non-<code>null</code>, the cache is bypassed since the cache
   *         key does not capture customizer identity.
   */
  @Nullable
  public Consumer <TransformerFactory> getTransformerFactoryCustomizer ()
  {
    return m_aTFCustomizer;
  }

  @NonNull
  public CacheKey getCacheKey ()
  {
    final String sResourceID = m_aResource.getResourceID ();
    return new CacheKey (isTracingEnabled () ? sResourceID + "#trace" : sResourceID);
  }

  @Override
  public boolean canCacheResult ()
  {
    return m_aTFCustomizer == null;
  }

  @Override
  @Nullable
  public ISchematronXSLTBasedProvider compile () throws SchematronException
  {
    if (!m_aResource.exists ())
    {
      LOGGER.warn ("XSLT resource " + m_aResource + " does not exist!");
      return null;
    }
    final SchematronProviderXSLTPrebuild aProvider = new SchematronProviderXSLTPrebuild (m_aResource,
                                                                                         m_aErrorListener,
                                                                                         m_aURIResolver,
                                                                                         isTracingEnabled (),
                                                                                         m_aTFCustomizer);
    if (!aProvider.isValidSchematron ())
    {
      LOGGER.warn ("XSLT resource '" + m_aResource.getResourceID () + "' is invalid!");
      return null;
    }
    return aProvider;
  }

  /**
   * @return A new {@link Builder} pre-populated with the values from this config. Never
   *         <code>null</code>.
   */
  @NonNull
  public Builder toBuilder ()
  {
    return new Builder (m_aResource).errorListener (m_aErrorListener)
                                    .uriResolver (m_aURIResolver)
                                    .parameters (m_aParameters)
                                    .telemetry (m_aTelemetry)
                                    .transformerFactoryCustomizer (m_aTFCustomizer);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Resource", m_aResource)
                                       .appendIfNotNull ("ErrorListener", m_aErrorListener)
                                       .appendIfNotNull ("URIResolver", m_aURIResolver)
                                       .append ("Parameters", m_aParameters)
                                       .appendIfNotNull ("Telemetry", m_aTelemetry)
                                       .appendIfNotNull ("TransformerFactoryCustomizer", m_aTFCustomizer)
                                       .getToString ();
  }

  // === Factories ===

  /**
   * @param aResource
   *        The XSLT resource. May not be <code>null</code>.
   * @return A new {@link Builder} based on the given resource. Never <code>null</code>.
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aResource)
  {
    return new Builder (aResource);
  }

  /**
   * @param sXSLTPath
   *        The classpath-relative path of the XSLT. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the XSLT from the default classloader. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromClassPath (@NonNull @Nonempty final String sXSLTPath)
  {
    return builder (new ClassPathResource (sXSLTPath));
  }

  /**
   * @param sXSLTPath
   *        The classpath-relative path of the XSLT. May neither be <code>null</code> nor empty.
   * @param aClassLoader
   *        The classloader to use, or <code>null</code> for the default classloader.
   * @return A new {@link Builder} reading the XSLT from the given classloader. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromClassPath (@NonNull @Nonempty final String sXSLTPath,
                                       @Nullable final ClassLoader aClassLoader)
  {
    return builder (new ClassPathResource (sXSLTPath, aClassLoader));
  }

  /**
   * @param sXSLTPath
   *        The file system path of the XSLT. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the XSLT from the file system. Never <code>null</code>.
   */
  @NonNull
  public static Builder fromFile (@NonNull @Nonempty final String sXSLTPath)
  {
    return builder (new FileSystemResource (sXSLTPath));
  }

  /**
   * @param aXSLTFile
   *        The XSLT file. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given file. Never <code>null</code>.
   */
  @NonNull
  public static Builder fromFile (@NonNull final File aXSLTFile)
  {
    return builder (new FileSystemResource (aXSLTFile));
  }

  /**
   * @param sXSLTURL
   *        The XSLT URL as string. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the XSLT from the given URL. Never <code>null</code>.
   * @throws MalformedURLException
   *         If the URL is not well-formed.
   */
  @NonNull
  public static Builder fromURL (@NonNull @Nonempty final String sXSLTURL) throws MalformedURLException
  {
    return builder (new URLResource (sXSLTURL));
  }

  /**
   * @param aXSLTURL
   *        The XSLT URL. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given URL. Never <code>null</code>.
   */
  @NonNull
  public static Builder fromURL (@NonNull final URL aXSLTURL)
  {
    return builder (new URLResource (aXSLTURL));
  }

  /**
   * @param sResourceID
   *        The logical resource ID used in error messages and cache keys. May neither be
   *        <code>null</code> nor empty.
   * @param aXSLTIS
   *        The input stream providing the XSLT bytes. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given input stream. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromInputStream (@NonNull @Nonempty final String sResourceID,
                                         @NonNull final InputStream aXSLTIS)
  {
    return builder (new ReadableResourceInputStream (sResourceID, aXSLTIS));
  }

  /**
   * @param aXSLT
   *        The XSLT bytes. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the given byte array. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromByteArray (@NonNull final byte [] aXSLT)
  {
    return builder (new ReadableResourceByteArray (aXSLT));
  }

  /**
   * @param sXSLT
   *        The XSLT as a string. May not be <code>null</code>.
   * @param aCharset
   *        The charset used to encode the string to bytes. May not be <code>null</code>.
   * @return A new {@link Builder} reading the XSLT from the encoded string bytes. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder fromString (@NonNull final String sXSLT, @NonNull final Charset aCharset)
  {
    return fromByteArray (sXSLT.getBytes (aCharset));
  }

  // === Builder ===

  @NotThreadSafe
  public static final class Builder implements IBuilder <SchematronXSLTConfig>
  {
    private final IReadableResource m_aResource;
    private ErrorListener m_aErrorListener;
    private URIResolver m_aURIResolver;
    private final ICommonsOrderedMap <String, Object> m_aParameters = new CommonsLinkedHashMap <> ();
    private ISchematronTemplateTelemetry m_aTelemetry;
    private Consumer <TransformerFactory> m_aTFCustomizer;

    Builder (@NonNull final IReadableResource aResource)
    {
      ValueEnforcer.notNull (aResource, "Resource");
      m_aResource = aResource;
      m_aURIResolver = new DefaultTransformURIResolver ().setDefaultBase (SchematronXSLTBaseURL.findBaseURL (aResource));
    }

    /**
     * Set the transformer error listener applied during XSLT transformation.
     *
     * @param a
     *        The error listener, or <code>null</code> to use the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder errorListener (@Nullable final ErrorListener a)
    {
      m_aErrorListener = a;
      return this;
    }

    /**
     * Set the URI resolver applied during XSLT transformation. The default is a
     * {@link DefaultTransformURIResolver} with the resource's parent directory as base URL.
     *
     * @param a
     *        The URI resolver, or <code>null</code> to disable URI resolution entirely.
     * @return this for chaining
     */
    @NonNull
    public Builder uriResolver (@Nullable final URIResolver a)
    {
      m_aURIResolver = a;
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
     * Set the per-template telemetry callback. When non-<code>null</code>, the stylesheet is
     * compiled with Saxon's {@code COMPILE_WITH_TRACING} feature (separate cache entry) and a
     * {@link com.helger.schematron.api.telemetry.SchematronTraceListener} is installed on each
     * transform so that the callback receives one
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
     * Set a {@link TransformerFactory} customizer applied to the compile-step transformer factory,
     * just before the validation stylesheet is compiled. Use this to register Saxon extension
     * functions (cast the {@link TransformerFactory} to {@code net.sf.saxon.TransformerFactoryImpl}
     * and reach the underlying {@code Processor}). Setting this disables caching, since the cache
     * key does not capture customizer identity.
     *
     * @param a
     *        The customizer, or <code>null</code> to clear. Default is <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder transformerFactoryCustomizer (@Nullable final Consumer <TransformerFactory> a)
    {
      m_aTFCustomizer = a;
      return this;
    }

    /**
     * @return The built {@link SchematronXSLTConfig} value object. Never <code>null</code>.
     */
    @Override
    @NonNull
    public SchematronXSLTConfig build ()
    {
      return new SchematronXSLTConfig (this);
    }
  }
}
