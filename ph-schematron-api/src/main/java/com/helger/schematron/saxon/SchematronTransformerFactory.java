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
package com.helger.schematron.saxon;

import java.util.Locale;
import java.util.function.Consumer;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.Immutable;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.helger.xml.transform.LoggingTransformErrorListener;

import net.sf.saxon.TransformerFactoryImpl;
import net.sf.saxon.lib.FeatureKeys;

/**
 * Factory for the Saxon-based {@link TransformerFactory} used by all XSLT-based Schematron engines.
 * Saxon is a hard compile-time dependency of this module, so no SPI lookup or fallback is required
 * - the class instantiates {@link TransformerFactoryImpl} directly.
 *
 * @author Philip Helger
 */
@Immutable
public final class SchematronTransformerFactory
{
  /**
   * Class name of the Saxon JAXP {@link TransformerFactory} implementation. Kept for callers that
   * reference it; new code should not need it.
   */
  public static final String SAXON_TRANSFORMER_FACTORY_CLASS = "net.sf.saxon.TransformerFactoryImpl";
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronTransformerFactory.class);

  private static final class SingletonHolder
  {
    static final TransformerFactory INSTANCE = createTransformerFactory (new LoggingTransformErrorListener (Locale.US),
                                                                         new DefaultTransformURIResolver ());
  }

  private static Consumer <TransformerFactory> s_aFactoryCustomizer;

  private SchematronTransformerFactory ()
  {}

  /**
   * @return The default cached Saxon-based {@link TransformerFactory}. Never <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static TransformerFactory getDefault ()
  {
    return SingletonHolder.INSTANCE;
  }

  /**
   * @return The default cached Saxon-based {@link TransformerFactory}. Never <code>null</code>.
   * @deprecated Since 10.0.0; use {@link #getDefault()} instead.
   */
  @Deprecated (since = "10.0.0", forRemoval = true)
  @NonNull
  public static TransformerFactory getDefaultSaxonFirst ()
  {
    return getDefault ();
  }

  /**
   * Set an optional {@link Consumer} that is called for every {@link TransformerFactory} created by
   * this class. This may e.g. be used to add implementation specific configuration. Based on #176.
   *
   * @param a
   *        The consumer to invoke. May be <code>null</code>.
   * @since 8.0.3
   */
  public static void setTransformerFactoryCustomizer (@Nullable final Consumer <TransformerFactory> a)
  {
    s_aFactoryCustomizer = a;
  }

  /**
   * @return The global {@link TransformerFactory} customizer.
   * @since 10.0.0
   */
  public static @Nullable Consumer <TransformerFactory> getTransformerFactoryCustomizer ()
  {
    return s_aFactoryCustomizer;
  }

  /**
   * Create a new Saxon-based {@link TransformerFactory} with the standard Schematron defaults
   * applied: line numbering (#52) and XInclude (#86) are enabled. Optionally enables Saxon's
   * {@code COMPILE_WITH_TRACING} feature so that stylesheets compiled by the returned factory emit
   * per-instruction events to a {@link net.sf.saxon.lib.TraceListener} at execution time.
   * <p>
   * Tracing disables several Saxon optimisations and typically costs 1.5&times;&ndash;3&times;
   * wall-clock per transform; callers should treat trace-enabled factories as distinct from the
   * normal cached factory.
   *
   * @param bEnableTracing
   *        <code>true</code> to enable Saxon's {@code COMPILE_WITH_TRACING} on the returned
   *        factory.
   * @return A new {@link TransformerFactory} and not <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static TransformerFactory createTransformerFactory (final boolean bEnableTracing)
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Calling createTransformerFactory (tracing=" + bEnableTracing + ")");

    final TransformerFactory aFactory = new TransformerFactoryImpl ();

    // Maintain position #52
    aFactory.setAttribute (FeatureKeys.LINE_NUMBERING, Boolean.TRUE);

    // Allow XInclude #86
    aFactory.setAttribute (FeatureKeys.XINCLUDE, Boolean.TRUE);

    // Tracing is conditional
    if (bEnableTracing)
      aFactory.setAttribute (FeatureKeys.COMPILE_WITH_TRACING, Boolean.TRUE);

    // Call the customizer
    if (s_aFactoryCustomizer != null)
      s_aFactoryCustomizer.accept (aFactory);

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Created TransformerFactory is " + aFactory);

    return aFactory;
  }

  /**
   * Create a new Saxon-based {@link TransformerFactory} with the standard Schematron defaults
   * applied: line numbering (#52) and XInclude (#86) are enabled.
   *
   * @param aErrorListener
   *        An optional XSLT error listener to be used. May be <code>null</code>.
   * @param aURIResolver
   *        An optional XSLT URI resolver to be used. May be <code>null</code>.
   * @return A new {@link TransformerFactory} and not <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static TransformerFactory createTransformerFactory (@Nullable final ErrorListener aErrorListener,
                                                             @Nullable final URIResolver aURIResolver)
  {
    return createTransformerFactory (aErrorListener, aURIResolver, false);
  }

  /**
   * Create a new Saxon-based {@link TransformerFactory} with the standard Schematron defaults
   * applied: line numbering (#52) and XInclude (#86) are enabled. Optionally enables Saxon's
   * {@code COMPILE_WITH_TRACING} feature so that stylesheets compiled by the returned factory emit
   * per-instruction events to a {@link net.sf.saxon.lib.TraceListener} at execution time.
   * <p>
   * Tracing disables several Saxon optimisations and typically costs 1.5&times;&ndash;3&times;
   * wall-clock per transform; callers should treat trace-enabled factories as distinct from the
   * normal cached factory.
   *
   * @param aErrorListener
   *        An optional XSLT error listener to be used. May be <code>null</code>.
   * @param aURIResolver
   *        An optional XSLT URI resolver to be used. May be <code>null</code>.
   * @param bEnableTracing
   *        <code>true</code> to enable Saxon's {@code COMPILE_WITH_TRACING} on the returned
   *        factory.
   * @return A new {@link TransformerFactory} and not <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static TransformerFactory createTransformerFactory (@Nullable final ErrorListener aErrorListener,
                                                             @Nullable final URIResolver aURIResolver,
                                                             final boolean bEnableTracing)
  {
    final TransformerFactory aFactory = createTransformerFactory (bEnableTracing);

    if (aErrorListener != null)
      aFactory.setErrorListener (aErrorListener);
    if (aURIResolver != null)
      aFactory.setURIResolver (aURIResolver);

    return aFactory;
  }

  /**
   * Create a new Saxon-based {@link TransformerFactory}. The {@code aClassLoader} parameter is no
   * longer required - Saxon is a hard compile-time dependency of this module - and is ignored.
   *
   * @param aClassLoader
   *        Ignored.
   * @param aErrorListener
   *        An optional XSLT error listener to be used. May be <code>null</code>.
   * @param aURIResolver
   *        An optional XSLT URI resolver to be used. May be <code>null</code>.
   * @return A new {@link TransformerFactory} and not <code>null</code>.
   * @deprecated Since 10.0.0; use {@link #createTransformerFactory(ErrorListener, URIResolver)}
   *             instead.
   */
  @Deprecated (since = "10.0.0", forRemoval = true)
  @NonNull
  public static TransformerFactory createTransformerFactorySaxonFirst (@Nullable final ClassLoader aClassLoader,
                                                                       @Nullable final ErrorListener aErrorListener,
                                                                       @Nullable final URIResolver aURIResolver)
  {
    return createTransformerFactory (aErrorListener, aURIResolver);
  }
}
