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

import java.util.Locale;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diagnostics.error.IError;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronException;
import com.helger.xml.transform.CollectingTransformErrorListener;
import com.helger.xml.transform.LoggingTransformErrorListener;

/**
 * Legacy static facade for the pre-built XSLT compilation cache. Since v10.0.0 this is a thin
 * wrapper around {@link SchematronXSLTCache#shared()}; prefer the new API
 * ({@link SchematronXSLTConfig}, {@link SchematronXSLTCache}, {@link SchematronXSLT}) for new
 * code.
 *
 * @author Philip Helger
 * @deprecated Use {@link SchematronXSLTCache#shared()} and the {@link SchematronXSLTConfig}
 *             builder instead.
 */
@Deprecated (since = "10.0.0", forRemoval = false)
@ThreadSafe
public final class SchematronResourceXSLTCache
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceXSLTCache.class);

  private SchematronResourceXSLTCache ()
  {}

  @Nullable
  public static SchematronProviderXSLTPrebuild createSchematronXSLTProvider (@NonNull final IReadableResource aXSLTResource,
                                                                             @Nullable final ErrorListener aCustomErrorListener,
                                                                             @Nullable final URIResolver aCustomURIResolver)
  {
    LOGGER.info ("Compiling XSLT instance " + aXSLTResource);

    final CollectingTransformErrorListener aCEH = new CollectingTransformErrorListener ();
    final SchematronProviderXSLTPrebuild aXSLTPreprocessor = new SchematronProviderXSLTPrebuild (aXSLTResource,
                                                                                                 aCEH.andThen (aCustomErrorListener !=
                                                                                                               null ? aCustomErrorListener
                                                                                                                    : new LoggingTransformErrorListener (Locale.US)),
                                                                                                 aCustomURIResolver);
    if (!aXSLTPreprocessor.isValidSchematron ())
    {
      LOGGER.warn ("The XSLT resource '" + aXSLTResource.getResourceID () + "' is invalid!");
      for (final IError aError : aCEH.getErrorList ())
        LOGGER.warn ("  " + aError.getAsStringLocaleIndepdent ());
      return null;
    }
    if (aXSLTPreprocessor.getXSLTDocument () == null)
      throw new IllegalStateException ("No XSLT document retrieved from XSLT resource '" +
                                       aXSLTResource.getResourceID () +
                                       "'!");
    return aXSLTPreprocessor;
  }

  /**
   * Return an existing or create a new Schematron XSLT provider for the passed resource via the
   * {@link SchematronXSLTCache#shared() shared cache}.
   */
  @Nullable
  public static SchematronProviderXSLTPrebuild getSchematronXSLTProvider (@NonNull final IReadableResource aXSLTResource,
                                                                          @Nullable final ErrorListener aCustomErrorListener,
                                                                          @Nullable final URIResolver aCustomURIResolver)
  {
    ValueEnforcer.notNull (aXSLTResource, "resource");
    if (!aXSLTResource.exists ())
    {
      LOGGER.warn ("XSLT resource " + aXSLTResource + " does not exist!");
      return null;
    }
    final SchematronXSLTConfig aConfig = SchematronXSLTConfig.builder (aXSLTResource)
                                                             .errorListener (aCustomErrorListener)
                                                             .uriResolver (aCustomURIResolver)
                                                             .build ();
    try
    {
      return (SchematronProviderXSLTPrebuild) SchematronXSLTCache.shared ().getOrCompile (aConfig);
    }
    catch (final SchematronException ex)
    {
      throw new IllegalStateException ("Failed to compile XSLT", ex);
    }
  }

  /**
   * Clear the {@link SchematronXSLTCache#shared() shared cache}.
   *
   * @since 5.6.5
   */
  public static void clearCache ()
  {
    SchematronXSLTCache.shared ().clear ();
  }
}
