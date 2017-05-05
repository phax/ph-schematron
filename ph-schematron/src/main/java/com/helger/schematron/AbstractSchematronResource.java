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

import java.io.InputStream;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.io.IHasInputStream;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.state.EValidity;
import com.helger.commons.string.ToStringGenerator;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.serialize.read.DOMReaderSettings;
import com.helger.xml.transform.TransformSourceFactory;

/**
 * Abstract implementation of the {@link ISchematronResource} interface handling
 * the underlying resource and wrapping one method.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public abstract class AbstractSchematronResource implements ISchematronResource
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (AbstractSchematronResource.class);

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

  @Nullable
  private Node _getAsNode (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    final StreamSource aStreamSrc = TransformSourceFactory.create (aXMLResource);
    InputStream aIS = null;
    try
    {
      aIS = aStreamSrc.getInputStream ();
    }
    catch (final IllegalStateException ex)
    {
      // Fall through
      // Happens e.g. for ResourceStreamSource with non-existing resources
    }
    if (aIS == null)
    {
      // Resource not found
      s_aLogger.warn ("XML resource " + aXMLResource + " does not exist!");
      return null;
    }
    final Document aDoc = DOMReader.readXMLDOM (aIS, internalCreateDOMReaderSettings ());
    if (aDoc == null)
      throw new IllegalArgumentException ("Failed to read resource " + aXMLResource + " as XML");

    return aDoc;
  }

  @Nullable
  private Node _getAsNode (@Nonnull final Source aXMLSource) throws Exception
  {
    // Convert to Node
    final Node aNode = SchematronResourceHelper.getNodeOfSource (aXMLSource, internalCreateDOMReaderSettings ());
    if (aNode == null)
      return null;
    return aNode;
  }

  @Nonnull
  public final EValidity getSchematronValidity (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    if (!isValidSchematron ())
      return EValidity.INVALID;

    final Node aXMLNode = _getAsNode (aXMLResource);
    if (aXMLNode == null)
      return EValidity.INVALID;

    return getSchematronValidity (aXMLNode);
  }

  @Nonnull
  public final EValidity getSchematronValidity (@Nonnull final Source aXMLSource) throws Exception
  {
    if (!isValidSchematron ())
      return EValidity.INVALID;

    final Node aXMLNode = _getAsNode (aXMLSource);
    if (aXMLNode == null)
      return EValidity.INVALID;

    return getSchematronValidity (aXMLNode);
  }

  @Nullable
  public final Document applySchematronValidation (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    if (!isValidSchematron ())
      return null;

    final Node aXMLNode = _getAsNode (aXMLResource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidation (aXMLNode);
  }

  @Nullable
  public final Document applySchematronValidation (@Nonnull final Source aXMLSource) throws Exception
  {
    if (!isValidSchematron ())
      return null;

    final Node aXMLNode = _getAsNode (aXMLSource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidation (aXMLNode);
  }

  @Nullable
  public final SchematronOutputType applySchematronValidationToSVRL (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    if (!isValidSchematron ())
      return null;

    final Node aXMLNode = _getAsNode (aXMLResource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidationToSVRL (aXMLNode);
  }

  @Nullable
  public final SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Source aXMLSource) throws Exception
  {
    if (!isValidSchematron ())
      return null;

    final Node aXMLNode = _getAsNode (aXMLSource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidationToSVRL (aXMLNode);
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
