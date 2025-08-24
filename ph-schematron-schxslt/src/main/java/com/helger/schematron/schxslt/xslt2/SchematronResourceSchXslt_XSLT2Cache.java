/*
 * Copyright (C) 2020-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.schxslt.xslt2;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.GuardedBy;
import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.base.concurrent.SimpleReadWriteLock;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.string.StringImplode;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.io.resource.IReadableResource;
import com.helger.xml.serialize.write.XMLWriter;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

/**
 * Factory for creating {@link SchematronProviderXSLTFromSchXslt_XSLT2} objects.
 *
 * @author Philip Helger
 */
@ThreadSafe
public final class SchematronResourceSchXslt_XSLT2Cache
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceSchXslt_XSLT2Cache.class);
  private static final SimpleReadWriteLock RW_LOCK = new SimpleReadWriteLock ();
  @GuardedBy ("RW_LOCK")
  private static final ICommonsMap <String, SchematronProviderXSLTFromSchXslt_XSLT2> MAP = new CommonsHashMap <> ();

  private SchematronResourceSchXslt_XSLT2Cache ()
  {}

  /**
   * Create a new Schematron validator for the passed resource.
   *
   * @param aSchematronResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aTransformerCustomizer
   *        The XSLT transformer customizer to be used. May not be <code>null</code>.
   * @return <code>null</code> if the passed Schematron resource does not exist or is invalid.
   */
  @Nullable
  public static SchematronProviderXSLTFromSchXslt_XSLT2 createSchematronXSLTProvider (@Nonnull final IReadableResource aSchematronResource,
                                                                                      @Nonnull final TransformerCustomizerSchXslt_XSLT2 aTransformerCustomizer)
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Compiling Schematron instance " + aSchematronResource.toString ());

    final SchematronProviderXSLTFromSchXslt_XSLT2 aXSLTPreprocessor = new SchematronProviderXSLTFromSchXslt_XSLT2 (aSchematronResource,
                                                                                                                   aTransformerCustomizer);
    // This is the call to convert Schematron to XSLT
    aXSLTPreprocessor.convertSchematronToXSLT ();
    if (!aXSLTPreprocessor.isValidSchematron ())
    {
      // Schematron is invalid -> parsing failed
      LOGGER.warn ("The Schematron resource '" + aSchematronResource.getResourceID () + "' is invalid!");
      if (LOGGER.isDebugEnabled () && aXSLTPreprocessor.getXSLTDocument () != null)
      {
        // Log the created XSLT document for better error tracking
        LOGGER.debug ("  Created XSLT document:\n" + XMLWriter.getNodeAsString (aXSLTPreprocessor.getXSLTDocument ()));
      }
      return null;
    }

    // If it is a valid schematron, there must be a result XSLT present!
    if (aXSLTPreprocessor.getXSLTDocument () == null)
      throw new IllegalStateException ("No XSLT document retrieved from Schematron resource '" +
                                       aSchematronResource.getResourceID () +
                                       "'!");

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Finished compiling Schematron instance " + aSchematronResource.toString ());

    // Create the main validator for the schematron
    return aXSLTPreprocessor;
  }

  /**
   * Get the Schematron validator for the passed resource. If no custom parameter are present, the
   * result is cached. The respective cache key is a combination of the Schematron resource path,
   * the phase and the language code.
   *
   * @param aSchematronResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aTransformerCustomizer
   *        The XSLT transformer customizer to be used. May not be <code>null</code>.
   * @return <code>null</code> if the passed Schematron resource does not exist or is invalid.
   */
  @Nullable
  public static SchematronProviderXSLTFromSchXslt_XSLT2 getSchematronXSLTProvider (@Nonnull final IReadableResource aSchematronResource,
                                                                                   @Nonnull final TransformerCustomizerSchXslt_XSLT2 aTransformerCustomizer)
  {
    ValueEnforcer.notNull (aSchematronResource, "SchematronResource");
    ValueEnforcer.notNull (aTransformerCustomizer, "TransformerCustomizer");

    if (!aSchematronResource.exists ())
    {
      LOGGER.warn ("Schematron resource " + aSchematronResource + " does not exist!");
      return null;
    }

    if (!aTransformerCustomizer.canCacheResult ())
    {
      // Create new object and return without cache handling because the custom
      // parameters may have side effects on the created XSLT!
      return createSchematronXSLTProvider (aSchematronResource, aTransformerCustomizer);
    }

    // Determine the unique resource ID for caching
    final String sCacheKey = StringImplode.imploder ()
                                          .separator (':')
                                          .source (aSchematronResource.getResourceID (),
                                                   StringHelper.getNotNull (aTransformerCustomizer.getPhase ()),
                                                   StringHelper.getNotNull (aTransformerCustomizer.getLanguageCode ()))
                                          .build ();

    // Validator already in the cache?
    SchematronProviderXSLTFromSchXslt_XSLT2 aProvider = RW_LOCK.readLockedGet ( () -> MAP.get (sCacheKey));
    if (aProvider == null)
    {
      // Check again in write lock
      aProvider = RW_LOCK.writeLockedGet ( () -> MAP.get (sCacheKey));
      if (aProvider == null)
      {
        // Create new object outside of the write lock
        final SchematronProviderXSLTFromSchXslt_XSLT2 aProviderNew = createSchematronXSLTProvider (aSchematronResource,
                                                                                                   aTransformerCustomizer);
        if (aProviderNew != null)
        {
          // Put in cache
          RW_LOCK.writeLocked ( () -> MAP.put (sCacheKey, aProviderNew));
        }
        aProvider = aProviderNew;
      }
    }
    return aProvider;
  }

  /**
   * Clear the internal cache.
   */
  public static void clearCache ()
  {
    RW_LOCK.writeLocked (MAP::clear);
  }
}
