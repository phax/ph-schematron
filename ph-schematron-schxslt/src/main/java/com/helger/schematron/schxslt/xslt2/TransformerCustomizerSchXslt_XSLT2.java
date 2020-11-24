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
package com.helger.schematron.schxslt.xslt2;

import java.util.Locale;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsLinkedHashMap;
import com.helger.commons.collection.impl.ICommonsOrderedMap;
import com.helger.xml.transform.LoggingTransformErrorListener;

/**
 * A wrapper for easier customization of the SCH to XSLT transformation.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class TransformerCustomizerSchXslt_XSLT2
{
  public static final boolean DEFAULT_FORCE_CACHE_RESULT = false;

  private ErrorListener m_aCustomErrorListener;
  private URIResolver m_aCustomURIResolver;
  private ICommonsOrderedMap <String, Object> m_aCustomParameters;
  private String m_sPhase;
  private String m_sLanguageCode;
  private boolean m_bForceCacheResult = DEFAULT_FORCE_CACHE_RESULT;

  public TransformerCustomizerSchXslt_XSLT2 ()
  {}

  @Nullable
  public ErrorListener getErrorListener ()
  {
    return m_aCustomErrorListener;
  }

  @Nonnull
  public TransformerCustomizerSchXslt_XSLT2 setErrorListener (@Nullable final ErrorListener aCustomErrorListener)
  {
    m_aCustomErrorListener = aCustomErrorListener;
    return this;
  }

  @Nullable
  public URIResolver getURIResolver ()
  {
    return m_aCustomURIResolver;
  }

  @Nonnull
  public TransformerCustomizerSchXslt_XSLT2 setURIResolver (@Nullable final URIResolver aCustomURIResolver)
  {
    m_aCustomURIResolver = aCustomURIResolver;
    return this;
  }

  public boolean hasParameters ()
  {
    return m_aCustomParameters != null && m_aCustomParameters.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, ?> getParameters ()
  {
    return new CommonsLinkedHashMap <> (m_aCustomParameters);
  }

  @Nonnull
  public TransformerCustomizerSchXslt_XSLT2 setParameters (@Nullable final Map <String, ?> aCustomParameters)
  {
    m_aCustomParameters = new CommonsLinkedHashMap <> (aCustomParameters);
    return this;
  }

  @Nullable
  public String getPhase ()
  {
    return m_sPhase;
  }

  @Nonnull
  public TransformerCustomizerSchXslt_XSLT2 setPhase (@Nullable final String sPhase)
  {
    m_sPhase = sPhase;
    return this;
  }

  @Nullable
  public String getLanguageCode ()
  {
    return m_sLanguageCode;
  }

  @Nonnull
  public TransformerCustomizerSchXslt_XSLT2 setLanguageCode (@Nullable final String sLanguageCode)
  {
    m_sLanguageCode = sLanguageCode;
    return this;
  }

  /**
   * @return <code>true</code> if internal caching of the result should be
   *         forced, <code>false</code> if not. The default is
   *         {@link #DEFAULT_FORCE_CACHE_RESULT}.
   */
  public boolean isForceCacheResult ()
  {
    return m_bForceCacheResult;
  }

  /**
   * Force the caching of results.
   *
   * @param bForceCacheResult
   *        <code>true</code> to force result caching, <code>false</code> to
   *        cache only if no parameters are present.
   * @return this for chaining
   */
  @Nonnull
  public TransformerCustomizerSchXslt_XSLT2 setForceCacheResult (final boolean bForceCacheResult)
  {
    m_bForceCacheResult = bForceCacheResult;
    return this;
  }

  /**
   * Can the results of the XSLT transformation be cached? By default results
   * cannot be cached if custom parameters are present, but since v.5.2.1 this
   * can be manually overridden.
   *
   * @return <code>true</code> if the result can be cached, <code>false</code>
   *         if not.
   * @see #setForceCacheResult(boolean) to force result caching
   */
  public boolean canCacheResult ()
  {
    return !hasParameters () || m_bForceCacheResult;
  }

  public void customize (@Nonnull final TransformerFactory aTransformer)
  {
    // Ensure an error listener is present
    if (m_aCustomErrorListener != null)
      aTransformer.setErrorListener (m_aCustomErrorListener);
    else
      aTransformer.setErrorListener (new LoggingTransformErrorListener (Locale.US));

    // Set the optional URI Resolver
    if (m_aCustomURIResolver != null)
      aTransformer.setURIResolver (m_aCustomURIResolver);
  }

  public void customize (@Nonnull final ESchXslt_XSLT2Step eStep, @Nonnull final Transformer aTransformer)
  {
    // Ensure an error listener is present
    if (m_aCustomErrorListener != null)
      aTransformer.setErrorListener (m_aCustomErrorListener);
    else
      aTransformer.setErrorListener (new LoggingTransformErrorListener (Locale.US));

    // Set the optional URI Resolver
    if (m_aCustomURIResolver != null)
      aTransformer.setURIResolver (m_aCustomURIResolver);

    // Set all custom parameters
    if (m_aCustomParameters != null)
      for (final Map.Entry <String, ?> aEntry : m_aCustomParameters.entrySet ())
        aTransformer.setParameter (aEntry.getKey (), aEntry.getValue ());

    if (eStep == ESchXslt_XSLT2Step.SCH2XSLT_3)
    {
      // On the last step, set the respective Schematron parameters as the
      // last action to avoid they are overwritten by a custom parameter.
      if (m_sPhase != null)
        aTransformer.setParameter ("phase", m_sPhase);

      if (m_sLanguageCode != null)
        aTransformer.setParameter ("langCode", m_sLanguageCode);
    }
  }
}
