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
package com.helger.schematron.xslt.customizer;

import java.util.Locale;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Transformer;
import javax.xml.transform.URIResolver;

import com.helger.commons.annotations.ReturnsMutableCopy;
import com.helger.commons.collections.CollectionHelper;
import com.helger.commons.lang.GenericReflection;
import com.helger.commons.xml.transform.LoggingTransformErrorListener;

/**
 * The default implementation of {@link IXSLTTransformerCustomizer}.
 *
 * @author Philip Helger
 */
public abstract class AbstractTransformerCustomizer <IMPLTYPE extends AbstractTransformerCustomizer <IMPLTYPE>>
{
  protected ErrorListener m_aCustomErrorListener;
  protected URIResolver m_aCustomURIResolver;
  protected Map <String, ?> m_aCustomParameters;

  public AbstractTransformerCustomizer ()
  {}

  @Nonnull
  protected final IMPLTYPE thisAsT ()
  {
    // Avoid the unchecked cast warning in all places
    return GenericReflection.<AbstractTransformerCustomizer <IMPLTYPE>, IMPLTYPE> uncheckedCast (this);
  }

  @Nullable
  public ErrorListener getErrorListener ()
  {
    return m_aCustomErrorListener;
  }

  @Nonnull
  public IMPLTYPE setErrorListener (@Nullable final ErrorListener aCustomErrorListener)
  {
    m_aCustomErrorListener = aCustomErrorListener;
    return thisAsT ();
  }

  @Nullable
  public URIResolver getURIResolver ()
  {
    return m_aCustomURIResolver;
  }

  @Nonnull
  public IMPLTYPE setURIResolver (@Nullable final URIResolver aCustomURIResolver)
  {
    m_aCustomURIResolver = aCustomURIResolver;
    return thisAsT ();
  }

  public boolean hasParameters ()
  {
    return CollectionHelper.isNotEmpty (m_aCustomParameters);
  }

  @Nonnull
  @ReturnsMutableCopy
  public Map <String, ?> getParameters ()
  {
    return CollectionHelper.newOrderedMap (m_aCustomParameters);
  }

  @Nonnull
  public IMPLTYPE setParameters (@Nullable final Map <String, ?> aCustomParameters)
  {
    m_aCustomParameters = CollectionHelper.newOrderedMap (aCustomParameters);
    return thisAsT ();
  }

  public void customize (@Nonnull final Transformer aTransformer)
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
  }
}
