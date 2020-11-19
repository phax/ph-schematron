/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.GuardedBy;
import javax.annotation.concurrent.ThreadSafe;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.concurrent.SimpleReadWriteLock;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.StringHelper;
import com.helger.xml.serialize.write.XMLWriter;

/**
 * Factory for creating {@link ISchematronXSLTBasedProvider} objects.
 *
 * @author Philip Helger
 */
@ThreadSafe
public final class SchematronResourceSCHCache
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceSCHCache.class);
  private static final SimpleReadWriteLock RW_LOCK = new SimpleReadWriteLock ();
  @GuardedBy ("RW_LOCK")
  private static final ICommonsMap <String, SchematronProviderXSLTFromSCH> CACHE = new CommonsHashMap <> ();

  private SchematronResourceSCHCache ()
  {}

  /**
   * Create a new Schematron validator for the passed resource.
   *
   * @param aSchematronResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aTransformerCustomizer
   *        The XSLT transformer customizer to be used. May not be
   *        <code>null</code>.
   * @return <code>null</code> if the passed Schematron resource does not exist
   *         or is invalid.
   */
  @Nullable
  public static SchematronProviderXSLTFromSCH createSchematronXSLTProvider (@Nonnull final IReadableResource aSchematronResource,
                                                                            @Nonnull final SCHTransformerCustomizer aTransformerCustomizer)
  {
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Compiling Schematron instance " + aSchematronResource.toString ());

    final SchematronProviderXSLTFromSCH aXSLTPreprocessor = new SchematronProviderXSLTFromSCH (aSchematronResource, aTransformerCustomizer);
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
   * Get the Schematron validator for the passed resource. If no custom
   * parameter are present, the result is cached. The respective cache key is a
   * combination of the Schematron resource path, the phase and the language
   * code.
   *
   * @param aSchematronResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aTransformerCustomizer
   *        The XSLT transformer customizer to be used. May not be
   *        <code>null</code>.
   * @return <code>null</code> if the passed Schematron resource does not exist
   *         or is invalid.
   */
  @Nullable
  public static SchematronProviderXSLTFromSCH getSchematronXSLTProvider (@Nonnull final IReadableResource aSchematronResource,
                                                                         @Nonnull final SCHTransformerCustomizer aTransformerCustomizer)
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
    final String sCacheKey = StringHelper.<String> getImploded (':',
                                                                aSchematronResource.getResourceID (),
                                                                StringHelper.getNotNull (aTransformerCustomizer.getPhase ()),
                                                                StringHelper.getNotNull (aTransformerCustomizer.getLanguageCode ()));

    // Validator already in the cache?
    final SchematronProviderXSLTFromSCH aProvider = RW_LOCK.readLockedGet ( () -> CACHE.get (sCacheKey));
    if (aProvider != null)
      return aProvider;

    return RW_LOCK.writeLockedGet ( () -> {
      // Validator already in the cache?
      SchematronProviderXSLTFromSCH aProvider2 = CACHE.get (sCacheKey);
      if (aProvider2 == null)
      {
        // Create new object and put in cache
        aProvider2 = createSchematronXSLTProvider (aSchematronResource, aTransformerCustomizer);
        if (aProvider2 != null)
          CACHE.put (sCacheKey, aProvider2);
      }
      return aProvider2;
    });
  }

  /**
   * Clear the internal cache.
   *
   * @since 5.6.5
   */
  public static void clearCache ()
  {
    RW_LOCK.writeLocked ( () -> CACHE.clear ());
  }
}
