/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.ThreadSafe;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.ext.CommonsHashMap;
import com.helger.commons.collection.ext.ICommonsMap;
import com.helger.commons.debug.GlobalDebug;
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
  private static final Logger s_aLogger = LoggerFactory.getLogger (SchematronResourceSCHCache.class);
  private static final Lock s_aLock = new ReentrantLock ();
  private static final ICommonsMap <String, SchematronProviderXSLTFromSCH> s_aCache = new CommonsHashMap<> ();

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
    if (s_aLogger.isDebugEnabled ())
      s_aLogger.debug ("Compiling Schematron instance " + aSchematronResource.toString ());

    final SchematronProviderXSLTFromSCH aXSLTPreprocessor = new SchematronProviderXSLTFromSCH (aSchematronResource,
                                                                                               aTransformerCustomizer);
    if (!aXSLTPreprocessor.isValidSchematron ())
    {
      // Schematron is invalid -> parsing failed
      s_aLogger.warn ("The Schematron resource '" + aSchematronResource.getResourceID () + "' is invalid!");
      if (GlobalDebug.isDebugMode () && aXSLTPreprocessor.getXSLTDocument () != null)
      {
        // Log the created XSLT document for better error tracking
        s_aLogger.warn ("  Created XSLT document:\n" + XMLWriter.getXMLString (aXSLTPreprocessor.getXSLTDocument ()));
      }
      return null;
    }

    // If it is a valid schematron, there must be a result XSLT present!
    if (aXSLTPreprocessor.getXSLTDocument () == null)
      throw new IllegalStateException ("No XSLT document retrieved from Schematron resource '" +
                                       aSchematronResource.getResourceID () +
                                       "'!");

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
      s_aLogger.warn ("Schematron resource " + aSchematronResource + " does not exist!");
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

    s_aLock.lock ();
    try
    {
      // Validator already in the cache?
      SchematronProviderXSLTFromSCH aProvider = s_aCache.get (sCacheKey);
      if (aProvider == null)
      {
        // Create new object and put in cache
        aProvider = createSchematronXSLTProvider (aSchematronResource, aTransformerCustomizer);
        if (aProvider != null)
          s_aCache.put (sCacheKey, aProvider);
      }
      return aProvider;
    }
    finally
    {
      s_aLock.unlock ();
    }
  }
}
