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
import javax.xml.transform.Transformer;

import com.helger.commons.xml.transform.LoggingTransformErrorListener;

/**
 * The default implementation of {@link ISCHTransformerCustomizer}.
 *
 * @author Philip Helger
 */
public class SCHTransformerCustomizer extends AbstractTransformerCustomizer <SCHTransformerCustomizer> implements ISCHTransformerCustomizer
{
  private String m_sPhase;
  private String m_sLanguageCode;

  public SCHTransformerCustomizer ()
  {}

  @Nullable
  public String getPhase ()
  {
    return m_sPhase;
  }

  @Nonnull
  public SCHTransformerCustomizer setPhase (@Nullable final String sPhase)
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
  public SCHTransformerCustomizer setLanguageCode (@Nullable final String sLanguageCode)
  {
    m_sLanguageCode = sLanguageCode;
    return this;
  }

  public boolean canCacheResult ()
  {
    return !hasParameters ();
  }

  public void customize (@Nonnull final EStep eStep, @Nonnull final Transformer aTransformer)
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

    if (eStep == EStep.SCH2XSLT_3)
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
