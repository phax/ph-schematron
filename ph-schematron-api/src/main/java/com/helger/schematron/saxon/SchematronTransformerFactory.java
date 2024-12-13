/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import java.net.URL;
import java.util.Enumeration;
import java.util.Locale;
import java.util.function.Consumer;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.URIResolver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.exception.InitializationException;
import com.helger.commons.lang.ClassLoaderHelper;
import com.helger.xml.XMLFactory;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.helger.xml.transform.LoggingTransformErrorListener;

import net.sf.saxon.lib.FeatureKeys;

/**
 * A special {@link TransformerFactory} handler that prefers Saxon's
 * {@link TransformerFactory} before calling the SPI version
 * <code>TransformerFactory.newInstance ()</code>. This is mainly to solve the
 * interoperability issue when using Xalan and Saxon together in the class path.
 * Also in general, Saxon is always to be preferred to Xalan. Xalan is simply
 * out of date.
 *
 * @author Philip Helger
 */
@Immutable
public final class SchematronTransformerFactory
{
  public static final String SAXON_TRANSFORMER_FACTORY_CLASS = "net.sf.saxon.TransformerFactoryImpl";
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronTransformerFactory.class);

  private static final class SingletonHolder
  {
    static final TransformerFactory INSTANCE = createTransformerFactorySaxonFirst (SchematronTransformerFactory.class.getClassLoader (),
                                                                                   new LoggingTransformErrorListener (Locale.US),
                                                                                   new DefaultTransformURIResolver ());
  }

  private static Consumer <TransformerFactory> s_aFactoryCustomizer;

  private SchematronTransformerFactory ()
  {}

  /**
   * @return The default "Saxon first" {@link TransformerFactory}. Never
   *         <code>null</code>.
   */
  @Nonnull
  public static TransformerFactory getDefaultSaxonFirst ()
  {
    return SingletonHolder.INSTANCE;
  }

  /**
   * Set an optional {@link Consumer} that is called for every
   * {@link TransformerFactory} created by this class. This may e.g. be used, to
   * add implementation specific configuration. Based on #176.
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
   * Create a new {@link TransformerFactory} trying to invoke the Saxon
   * implementation first using the class
   * {@value #SAXON_TRANSFORMER_FACTORY_CLASS}.
   *
   * @param aClassLoader
   *        The optional class loader to be used. May be <code>null</code>.
   * @param aErrorListener
   *        An optional XSLT error listener to be used. May be
   *        <code>null</code>.
   * @param aURIResolver
   *        An optional XSLT URI resolver to be used. May be <code>null</code>.
   * @return A new {@link TransformerFactory} and not <code>null</code>.
   * @throws InitializationException
   *         In case initialization fails.
   */
  @Nonnull
  public static TransformerFactory createTransformerFactorySaxonFirst (@Nullable final ClassLoader aClassLoader,
                                                                       @Nullable final ErrorListener aErrorListener,
                                                                       @Nullable final URIResolver aURIResolver)
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Calling createTransformerFactorySaxonFirst");

    final ClassLoader aEffectiveClassLoader = aClassLoader != null ? aClassLoader
                                                                   : ClassLoaderHelper.getContextClassLoader ();

    TransformerFactory aFactory;
    try
    {
      // Try Saxon first
      aFactory = TransformerFactory.newInstance (SAXON_TRANSFORMER_FACTORY_CLASS, aEffectiveClassLoader);

      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Created TransformerFactory with Saxon using '" + SAXON_TRANSFORMER_FACTORY_CLASS + "'");

      // Maintain position #52
      aFactory.setFeature (FeatureKeys.LINE_NUMBERING, true);
      // Allow XInclude #86
      aFactory.setFeature (FeatureKeys.XINCLUDE, true);

      // Debug/testing only
      if (false)
        aFactory.setFeature (FeatureKeys.TRACE_OPTIMIZER_DECISIONS, true);
      if (false)
        aFactory.setFeature (FeatureKeys.COMPILE_WITH_TRACING, true);
    }
    catch (final TransformerFactoryConfigurationError | TransformerConfigurationException ex)
    {
      if (LOGGER.isDebugEnabled ())
      {
        LOGGER.debug ("Failed to create TransformerFactory with Saxon.", ex);
        try
        {
          LOGGER.debug ("Done checking implementations using classloader " + aEffectiveClassLoader);
          final Enumeration <URL> x = aEffectiveClassLoader.getResources ("META-INF/services/javax.xml.transform.TransformerFactory");
          while (x.hasMoreElements ())
          {
            LOGGER.debug ("  " + x.nextElement ().toExternalForm ());
          }
          LOGGER.debug ("Done checking implementations");
        }
        catch (final Exception ex2)
        {
          LOGGER.error ("Error determining implementations", ex2);
        }
      }

      try
      {
        // Try default afterwards
        aFactory = XMLFactory.createDefaultTransformerFactory ();
      }
      catch (final TransformerFactoryConfigurationError ex2)
      {
        throw new InitializationException ("Failed to create XML TransformerFactory", ex2);
      }
    }

    if (aErrorListener != null)
      aFactory.setErrorListener (aErrorListener);
    if (aURIResolver != null)
      aFactory.setURIResolver (aURIResolver);

    // Call the customizer
    if (s_aFactoryCustomizer != null)
      s_aFactoryCustomizer.accept (aFactory);

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Created TransformerFactory is " + aFactory);

    return aFactory;
  }
}
