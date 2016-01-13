/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.GuardedBy;
import javax.annotation.concurrent.ThreadSafe;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.concurrent.SimpleReadWriteLock;
import com.helger.commons.debug.GlobalDebug;
import com.helger.commons.error.IResourceError;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.xml.transform.CollectingTransformErrorListener;
import com.helger.commons.xml.transform.LoggingTransformErrorListener;

/**
 * Factory for creating {@link ISchematronXSLTBasedProvider} objects.
 *
 * @author Philip Helger
 */
@ThreadSafe
public final class SchematronResourceXSLTCache
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (SchematronResourceXSLTCache.class);
  private static final SimpleReadWriteLock s_aRWLock = new SimpleReadWriteLock ();
  @GuardedBy ("s_aRWLock")
  private static final Map <String, SchematronProviderXSLTPrebuild> s_aCache = new HashMap <> ();

  private SchematronResourceXSLTCache ()
  {}

  @Nullable
  public static SchematronProviderXSLTPrebuild createSchematronXSLTProvider (@Nonnull final IReadableResource aXSLTResource,
                                                                             @Nullable final ErrorListener aCustomErrorListener,
                                                                             @Nullable final URIResolver aCustomURIResolver)
  {
    if (GlobalDebug.isDebugMode () && s_aLogger.isInfoEnabled ())
      s_aLogger.info ("Compiling XSLT instance " + aXSLTResource.toString ());

    final CollectingTransformErrorListener aCEH = new CollectingTransformErrorListener (aCustomErrorListener != null ? aCustomErrorListener
                                                                                                                     : new LoggingTransformErrorListener (Locale.US));
    final SchematronProviderXSLTPrebuild aXSLTPreprocessor = new SchematronProviderXSLTPrebuild (aXSLTResource,
                                                                                                 aCEH,
                                                                                                 aCustomURIResolver);
    if (!aXSLTPreprocessor.isValidSchematron ())
    {
      // Schematron is invalid -> parsing failed
      s_aLogger.warn ("The XSLT resource '" + aXSLTResource.getResourceID () + "' is invalid!");
      for (final IResourceError aError : aCEH.getResourceErrors ())
        s_aLogger.warn ("  " + aError.getAsString (Locale.US));
      return null;
    }

    // If it is a valid schematron, there must be a result XSLT present!
    if (aXSLTPreprocessor.getXSLTDocument () == null)
    {
      // Note: this should never occur, as it is in the Prebuild implementation
      // the same as "isValidSchematron" but to be implementation agnostic, we
      // leave the check anyway.
      throw new IllegalStateException ("No XSLT document retrieved from XSLT resource '" +
                                       aXSLTResource.getResourceID () +
                                       "'!");
    }

    // Create the main validator for the schematron
    return aXSLTPreprocessor;
  }

  /**
   * Return an existing or create a new Schematron XSLT provider for the passed
   * resource.
   *
   * @param aXSLTResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        The custom error listener to be used. May be <code>null</code>.
   * @param aCustomURIResolver
   *        The custom URI resolver to be used. May be <code>null</code>.
   * @return <code>null</code> if the passed Schematron XSLT resource does not
   *         exist.
   */
  @Nullable
  public static SchematronProviderXSLTPrebuild getSchematronXSLTProvider (@Nonnull final IReadableResource aXSLTResource,
                                                                          @Nullable final ErrorListener aCustomErrorListener,
                                                                          @Nullable final URIResolver aCustomURIResolver)
  {
    ValueEnforcer.notNull (aXSLTResource, "resource");

    if (!aXSLTResource.exists ())
    {
      s_aLogger.warn ("XSLT resource " + aXSLTResource + " does not exist!");
      return null;
    }

    // Determine the unique resource ID for caching
    final String sResourceID = aXSLTResource.getResourceID ();

    // Validator already in the cache?
    final SchematronProviderXSLTPrebuild aProvider = s_aRWLock.readLocked ( () -> s_aCache.get (sResourceID));
    if (aProvider != null)
      return aProvider;

    return s_aRWLock.writeLocked ( () -> {
      // Check again in write lock
      SchematronProviderXSLTPrebuild aProvider2 = s_aCache.get (sResourceID);
      if (aProvider2 == null)
      {
        // Create new object and put in cache
        aProvider2 = createSchematronXSLTProvider (aXSLTResource, aCustomErrorListener, aCustomURIResolver);
        if (aProvider2 != null)
          s_aCache.put (sResourceID, aProvider2);
      }
      return aProvider2;
    });
  }

}
