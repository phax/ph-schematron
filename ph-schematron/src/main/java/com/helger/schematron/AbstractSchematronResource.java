/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
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
package com.helger.schematron;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.ToStringGenerator;

/**
 * Abstract implementation of the {@link ISchematronResource} interface handling
 * the underlying resource and wrapping one method.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public abstract class AbstractSchematronResource implements ISchematronResource
{
  private final IReadableResource m_aResource;
  private final String m_sResourceID;
  private boolean m_bUseCache = true;

  public AbstractSchematronResource (@Nonnull final IReadableResource aResource)
  {
    m_aResource = ValueEnforcer.notNull (aResource, "Resource");
    m_sResourceID = aResource.getResourceID ();
  }

  @Nonnull
  public final String getID ()
  {
    return m_sResourceID;
  }

  @Nonnull
  public final IReadableResource getResource ()
  {
    return m_aResource;
  }

  public boolean isUseCache ()
  {
    return m_bUseCache;
  }

  public void setUseCache (final boolean bUseCache)
  {
    m_bUseCache = bUseCache;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Resource", m_aResource)
                                       .append ("UseCache", m_bUseCache)
                                       .getToString ();
  }
}
