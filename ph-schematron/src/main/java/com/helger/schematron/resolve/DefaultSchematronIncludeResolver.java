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
package com.helger.schematron.resolve;

import java.io.IOException;
import java.net.URL;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.resourceresolver.DefaultResourceResolver;
import com.helger.commons.string.ToStringGenerator;

/**
 * The default implementation of {@link ISchematronIncludeResolver} using the
 * {@link DefaultResourceResolver#getResolvedResource(String, String)} method
 * internally.
 *
 * @author Philip Helger
 */
public class DefaultSchematronIncludeResolver implements ISchematronIncludeResolver
{
  private final String m_sBaseHref;

  @Nullable
  private static String _getBaseHref (@Nonnull final IReadableResource aResource)
  {
    final URL aURL = aResource.getAsURL ();
    return aURL == null ? null : aURL.toExternalForm ();
  }

  public DefaultSchematronIncludeResolver (@Nonnull final IReadableResource aResource)
  {
    this (_getBaseHref (aResource));
  }

  public DefaultSchematronIncludeResolver (@Nullable final String sBaseHref)
  {
    m_sBaseHref = sBaseHref;
  }

  @Nullable
  public String getBaseHref ()
  {
    return m_sBaseHref;
  }

  @Nonnull
  public IReadableResource getResolvedSchematronResource (@Nonnull @Nonempty final String sHref) throws IOException
  {
    return DefaultResourceResolver.getResolvedResource (sHref, getBaseHref ());
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("baseHref", m_sBaseHref).getToString ();
  }
}
