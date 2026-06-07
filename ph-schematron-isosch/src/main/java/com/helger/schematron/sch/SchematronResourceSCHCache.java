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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronException;
import com.helger.xml.serialize.write.XMLWriter;

/**
 * Legacy static facade for the SCH compilation cache. Since v10.0.0 this is a thin wrapper around
 * {@link SchematronSCHCache#shared()}; prefer the new API ({@link SchematronSCHConfig},
 * {@link SchematronSCHCache}, {@link SchematronSCH}) for new code — the new API supports multiple
 * cache instances, bounded eviction and a fluent builder.
 *
 * @author Philip Helger
 * @deprecated Use {@link SchematronSCHCache#shared()} and the {@link SchematronSCHConfig} builder
 *             instead.
 */
@Deprecated (since = "10.0.0", forRemoval = false)
@ThreadSafe
public final class SchematronResourceSCHCache
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceSCHCache.class);

  private SchematronResourceSCHCache ()
  {}

  /**
   * Create a new Schematron validator for the passed resource — uncached, equivalent to
   * {@link SchematronSCHConfig#compile()}.
   *
   * @param aSchematronResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aTransformerCustomizer
   *        The XSLT transformer customizer to be used. May not be <code>null</code>.
   * @return <code>null</code> if the passed Schematron resource does not exist or is invalid.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @Nullable
  public static SchematronProviderXSLTFromSCH createSchematronXSLTProvider (@NonNull final IReadableResource aSchematronResource,
                                                                            @NonNull final TransformerCustomizerSCH aTransformerCustomizer)
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Compiling Schematron instance " + aSchematronResource);

    final SchematronProviderXSLTFromSCH aXSLTPreprocessor = new SchematronProviderXSLTFromSCH (aSchematronResource,
                                                                                               aTransformerCustomizer);
    aXSLTPreprocessor.convertSchematronToXSLT ();

    if (!aXSLTPreprocessor.isValidSchematron ())
    {
      LOGGER.warn ("The Schematron resource '" + aSchematronResource.getResourceID () + "' is invalid!");
      if (LOGGER.isDebugEnabled () && aXSLTPreprocessor.getXSLTDocument () != null)
        LOGGER.debug ("  Created XSLT document:\n" + XMLWriter.getNodeAsString (aXSLTPreprocessor.getXSLTDocument ()));
      return null;
    }

    if (aXSLTPreprocessor.getXSLTDocument () == null)
      throw new IllegalStateException ("No XSLT document retrieved from Schematron resource '" +
                                       aSchematronResource.getResourceID () +
                                       "'!");

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Finished compiling Schematron instance " + aSchematronResource);
    return aXSLTPreprocessor;
  }

  /**
   * Get the Schematron validator for the passed resource via the {@link SchematronSCHCache#shared()
   * shared cache}.
   *
   * @param aSchematronResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aTransformerCustomizer
   *        The XSLT transformer customizer to be used. May not be <code>null</code>.
   * @return <code>null</code> if the passed Schematron resource does not exist or is invalid.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @Nullable
  public static SchematronProviderXSLTFromSCH getSchematronXSLTProvider (@NonNull final IReadableResource aSchematronResource,
                                                                         @NonNull final TransformerCustomizerSCH aTransformerCustomizer)
  {
    ValueEnforcer.notNull (aSchematronResource, "SchematronResource");
    ValueEnforcer.notNull (aTransformerCustomizer, "TransformerCustomizer");

    if (!aSchematronResource.exists ())
    {
      LOGGER.warn ("Schematron resource " + aSchematronResource + " does not exist!");
      return null;
    }

    if (!aTransformerCustomizer.canCacheResult ())
      return createSchematronXSLTProvider (aSchematronResource, aTransformerCustomizer);

    final SchematronSCHConfig aConfig = SchematronSCHConfig.builder (aSchematronResource)
                                                           .phase (aTransformerCustomizer.getPhase ())
                                                           .languageCode (aTransformerCustomizer.getLanguageCode ())
                                                           .errorListener (aTransformerCustomizer.getErrorListener ())
                                                           .uriResolver (aTransformerCustomizer.getURIResolver ())
                                                           .parameters (aTransformerCustomizer.getParameters ())
                                                           .forceCacheResult (aTransformerCustomizer.isForceCacheResult ())
                                                           .build ();
    try
    {
      // Cast: the cache stores ISchematronXSLTBasedProvider, but here it is always a
      // SchematronProviderXSLTFromSCH (set by SchematronSCHConfig.compile).
      return (SchematronProviderXSLTFromSCH) SchematronSCHCache.shared ().getOrCompile (aConfig);
    }
    catch (final SchematronException ex)
    {
      throw new IllegalStateException ("Failed to compile Schematron", ex);
    }
  }

  /**
   * Clear the {@link SchematronSCHCache#shared() shared cache}.
   *
   * @since 5.6.5
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  public static void clearCache ()
  {
    SchematronSCHCache.shared ().clear ();
  }
}
