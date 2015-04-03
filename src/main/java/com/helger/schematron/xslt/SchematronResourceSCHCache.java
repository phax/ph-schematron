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
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.ThreadSafe;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Transformer;
import javax.xml.transform.URIResolver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.GlobalDebug;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.collections.CollectionHelper;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.string.StringHelper;
import com.helger.commons.xml.serialize.XMLWriter;
import com.helger.commons.xml.transform.LoggingTransformErrorListener;

/**
 * Factory for creating {@link ISchematronXSLTProvider} objects.
 *
 * @author Philip Helger
 */
@ThreadSafe
public final class SchematronResourceSCHCache
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (SchematronResourceSCHCache.class);
  private static final Lock s_aLock = new ReentrantLock ();
  private static final Map <String, SchematronProviderXSLTFromSCH> s_aCache = new HashMap <String, SchematronProviderXSLTFromSCH> ();

  private SchematronResourceSCHCache ()
  {}

  /**
   * Create a new Schematron validator for the passed resource.
   *
   * @param aSchematronResource
   *        The resource of the Schematron rules. May not be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document. May be
   *        <code>null</code>.
   * @param aCustomParameters
   *        A set of custom parameters that is passed to the XSLT Transformer.
   *        May be <code>null</code> or empty.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @return <code>null</code> if the passed Schematron resource does not exist
   *         or is invalid.
   */
  @Nullable
  public static SchematronProviderXSLTFromSCH createSchematronXSLTProvider (@Nonnull final IReadableResource aSchematronResource,
                                                                            @Nullable final ErrorListener aCustomErrorListener,
                                                                            @Nullable final URIResolver aCustomURIResolver,
                                                                            @Nullable final Map <String, ?> aCustomParameters,
                                                                            @Nullable final String sPhase,
                                                                            @Nullable final String sLanguageCode)
  {
    if (GlobalDebug.isDebugMode () && s_aLogger.isInfoEnabled ())
      s_aLogger.info ("Compiling Schematron instance " + aSchematronResource.toString ());

    // Ensure an error listener is present
    final ErrorListener aRealErrorListener = aCustomErrorListener != null ? aCustomErrorListener
                                                                         : new LoggingTransformErrorListener (Locale.US);

    // Create the TransformerCustomizer
    final IXSLTTransformerCustomizer aCustomizer = new IXSLTTransformerCustomizer ()
    {
      public void customize (@Nonnull final EStep eStep, @Nonnull final Transformer aTransformer)
      {
        aTransformer.setErrorListener (aRealErrorListener);
        if (aCustomURIResolver != null)
          aTransformer.setURIResolver (aCustomURIResolver);

        if (eStep == EStep.STEP3)
        {
          // Set all custom parameters
          if (aCustomParameters != null)
            for (final Map.Entry <String, ?> aEntry : aCustomParameters.entrySet ())
              aTransformer.setParameter (aEntry.getKey (), aEntry.getValue ());

          // On the last step, set the respective Schematron parameters as the
          // last action to avoid they are overwritten by a custom parameter.
          if (sPhase != null)
            aTransformer.setParameter ("phase", sPhase);
          if (sLanguageCode != null)
            aTransformer.setParameter ("langCode", sLanguageCode);
        }
      }
    };

    final SchematronProviderXSLTFromSCH aXSLTPreprocessor = new SchematronProviderXSLTFromSCH (aSchematronResource,
                                                                                               aCustomizer);
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
   * @param aCustomErrorListener
   *        An optional custom XSLT error listener that is used when converting
   *        the Schematron resource to an XSLT document. May be
   *        <code>null</code>.
   * @param aCustomURIResolver
   *        An optional custom XSLT URI resolver that is used when converting
   *        the Schematron resource to an XSLT document. May be
   *        <code>null</code>.
   * @param aCustomParameters
   *        A set of custom parameters that is passed to the XSLT Transformer.
   *        May be <code>null</code> or empty.
   * @param sPhase
   *        Optional phase to use. If not specified, the defaultPhase from the
   *        schema is used. If no default phase is specified, than all patterns
   *        are used.
   * @param sLanguageCode
   *        An optional language code for the error messages. <code>null</code>
   *        means English. Supported language codes are: cs, de, en, fr, nl (see
   *        directory files schematron\20100414-xslt2\sch-messages-??.xhtml).
   * @return <code>null</code> if the passed Schematron resource does not exist
   *         or is invalid.
   */
  @Nullable
  public static SchematronProviderXSLTFromSCH getSchematronXSLTProvider (@Nonnull final IReadableResource aSchematronResource,
                                                                         @Nullable final ErrorListener aCustomErrorListener,
                                                                         @Nullable final URIResolver aCustomURIResolver,
                                                                         @Nullable final Map <String, ?> aCustomParameters,
                                                                         @Nullable final String sPhase,
                                                                         @Nullable final String sLanguageCode)
  {
    ValueEnforcer.notNull (aSchematronResource, "resource");

    if (!aSchematronResource.exists ())
    {
      s_aLogger.warn ("Schematron resource " + aSchematronResource + " does not exist!");
      return null;
    }

    if (CollectionHelper.isNotEmpty (aCustomParameters))
    {
      // Create new object and return without cache handling because the custom
      // parameters may have side effects on the created XSLT!
      return createSchematronXSLTProvider (aSchematronResource,
                                           aCustomErrorListener,
                                           aCustomURIResolver,
                                           aCustomParameters,
                                           sPhase,
                                           sLanguageCode);
    }

    // Determine the unique resource ID for caching
    final String sCacheKey = StringHelper.<String> getImploded (':',
                                                                aSchematronResource.getResourceID (),
                                                                StringHelper.getNotNull (sPhase),
                                                                StringHelper.getNotNull (sLanguageCode));

    s_aLock.lock ();
    try
    {
      // Validator already in the cache?
      SchematronProviderXSLTFromSCH aProvider = s_aCache.get (sCacheKey);
      if (aProvider == null)
      {
        // Create new object and put in cache
        aProvider = createSchematronXSLTProvider (aSchematronResource,
                                                  aCustomErrorListener,
                                                  aCustomURIResolver,
                                                  aCustomParameters,
                                                  sPhase,
                                                  sLanguageCode);
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
