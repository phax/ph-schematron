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
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import org.xml.sax.EntityResolver;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.ToStringGenerator;
import com.helger.xml.serialize.read.DOMReaderSettings;

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
  private EntityResolver m_aEntityResolver;

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

  /**
   * @return The XML entity resolver to be used to read the Schematron or XML to
   *         be validated. May be <code>null</code>.
   * @since 4.1.1
   */
  @Nullable
  public EntityResolver getEntityResolver ()
  {
    return m_aEntityResolver;
  }

  /**
   * Set the XML entity resolver to be used when reading the Schematron or the
   * XML to be validated. This can only be set before the Schematron is bound.
   * If it is already bound an exception is thrown to indicate the unnecessity
   * of the call.
   *
   * @param aEntityResolver
   *        The entity resolver to set. May be <code>null</code>.
   * @since 4.2.3
   */
  protected final void internalSetEntityResolver (@Nullable final EntityResolver aEntityResolver)
  {
    m_aEntityResolver = aEntityResolver;
  }

  @Nonnull
  @ReturnsMutableCopy
  protected DOMReaderSettings internalCreateDOMReaderSettings ()
  {
    final DOMReaderSettings aDRS = new DOMReaderSettings ();
    if (m_aEntityResolver != null)
      aDRS.setEntityResolver (m_aEntityResolver);
    return aDRS;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Resource", m_aResource)
                                       .append ("UseCache", m_bUseCache)
                                       .appendIfNotNull ("EntityResolver", m_aEntityResolver)
                                       .getToString ();
  }
}
