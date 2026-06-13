/*
 * Copyright (C) 2020-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.schxslt2.xslt;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.api.cache.AbstractSchematronCache;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.xml.serialize.write.XMLWriter;

/**
 * Cache for compiled {@link ISchematronXSLTBasedProvider} instances produced from
 * {@link SchematronSchXslt2Config}.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@ThreadSafe
public final class SchematronSchXslt2Cache extends
                                           AbstractSchematronCache <SchematronSchXslt2Config, ISchematronXSLTBasedProvider>
{
  /** Default name of the shared cache. */
  public static final String DEFAULT_NAME = "schematron-schxslt2";

  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronSchXslt2Cache.class);

  private static final class SingletonHolder
  {
    static final SchematronSchXslt2Cache INSTANCE = new SchematronSchXslt2Cache ();
  }

  /**
   * Create a new, unbounded cache with the {@link #DEFAULT_NAME default name}.
   */
  public SchematronSchXslt2Cache ()
  {
    this (DEFAULT_NAME, NO_MAX_SIZE);
  }

  /**
   * Create a new cache with a custom name and no max size.
   *
   * @param sName
   *        The cache name. May neither be <code>null</code> nor empty.
   */
  public SchematronSchXslt2Cache (@NonNull @Nonempty final String sName)
  {
    this (sName, NO_MAX_SIZE);
  }

  /**
   * Create a new cache with a custom name and a maximum size.
   *
   * @param sName
   *        The cache name. May neither be <code>null</code> nor empty.
   * @param nMaxSize
   *        The maximum number of entries. Values &le; 0 mean unbounded.
   */
  public SchematronSchXslt2Cache (@NonNull @Nonempty final String sName, final int nMaxSize)
  {
    super (sName, nMaxSize);
  }

  /**
   * @return The process-wide shared instance.
   */
  @NonNull
  public static SchematronSchXslt2Cache shared ()
  {
    return SingletonHolder.INSTANCE;
  }

  /**
   * Compile a Schematron resource into an {@link ISchematronXSLTBasedProvider} without consulting
   * any cache. Use this when the caller has a subclassed {@link TransformerCustomizerSchXslt2} whose
   * behaviour cannot be expressed via {@link SchematronSchXslt2Config}, or when caching is
   * explicitly disabled. Returns <code>null</code> for an invalid Schematron resource; throws on
   * internal inconsistency (no XSLT document despite a valid Schematron).
   *
   * @param aSchematronResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aTransformerCustomizer
   *        The XSLT transformer customizer to be used. May not be <code>null</code>.
   * @return The compiled provider, or <code>null</code> if the Schematron resource is invalid.
   * @since 10.0.0
   */
  @Nullable
  public static SchematronProviderXSLTFromSchXslt2 compileUncached (@NonNull final IReadableResource aSchematronResource,
                                                                    @NonNull final TransformerCustomizerSchXslt2 aTransformerCustomizer)
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Compiling Schematron instance " + aSchematronResource);

    final SchematronProviderXSLTFromSchXslt2 aXSLTPreprocessor = new SchematronProviderXSLTFromSchXslt2 (aSchematronResource,
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
}
