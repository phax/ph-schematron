/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.resolve;

import java.io.IOException;
import java.net.URL;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resourceresolver.DefaultResourceResolver;

/**
 * The default implementation of {@link ISchematronIncludeResolver} using the
 * {@link DefaultResourceResolver#getResolvedResource(String, String)} method internally.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class DefaultSchematronIncludeResolver implements ISchematronIncludeResolver
{
  private final IReadableResource m_aBaseResource;
  private final String m_sBaseHref;
  private ISchematronIncludeResolver m_aCustomIncludeResolver;

  @Nullable
  private static String _getBaseHref (@NonNull final IReadableResource aResource)
  {
    final URL aURL = aResource.getAsURL ();
    return aURL == null ? null : aURL.toExternalForm ();
  }

  public DefaultSchematronIncludeResolver (@NonNull final IReadableResource aResource)
  {
    m_aBaseResource = aResource;
    m_sBaseHref = _getBaseHref (aResource);
  }

  public DefaultSchematronIncludeResolver (@Nullable final String sBaseHref)
  {
    m_aBaseResource = null;
    m_sBaseHref = sBaseHref;
  }

  /**
   * @return The resource that contains the includes, as passed in the constructor. May be
   *         <code>null</code> if the constructor with the base href was used.
   * @since 10.3.4
   */
  @Nullable
  public final IReadableResource getBaseResource ()
  {
    return m_aBaseResource;
  }

  @Nullable
  public final String getBaseHref ()
  {
    return m_sBaseHref;
  }

  public void setCustomSchematronIncludeResolver (@Nullable final ISchematronIncludeResolver aCustomIncludeResolver)
  {
    m_aCustomIncludeResolver = aCustomIncludeResolver;
  }

  @NonNull
  public IReadableResource getResolvedSchematronResource (@NonNull @Nonempty final String sHref) throws IOException
  {
    if (m_aCustomIncludeResolver != null)
    {
      final IReadableResource ret = m_aCustomIncludeResolver.getResolvedSchematronResource (sHref, m_aBaseResource);
      if (ret != null)
        return ret;
    }
    return DefaultResourceResolver.getResolvedResource (sHref, getBaseHref ());
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("BaseResource", m_aBaseResource)
                                       .append ("BaseHref", m_sBaseHref)
                                       .appendIfNotNull ("CustomIncludeResolver", m_aCustomIncludeResolver)
                                       .getToString ();
  }
}
