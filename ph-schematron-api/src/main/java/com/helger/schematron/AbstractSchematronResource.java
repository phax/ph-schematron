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
package com.helger.schematron;

import java.io.InputStream;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.OverrideOnDemand;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.io.iface.IHasInputStream;
import com.helger.base.state.EValidity;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.EXMLParserFeature;
import com.helger.xml.sax.DefaultEntityResolver;
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
  public static final boolean DEFAULT_USE_CACHE = true;

  private static final Logger LOGGER = LoggerFactory.getLogger (AbstractSchematronResource.class);

  private final IReadableResource m_aResource;
  private final String m_sResourceID;
  private boolean m_bUseCache = DEFAULT_USE_CACHE;
  private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;
  private EntityResolver m_aEntityResolver;

  /**
   * Constructor
   *
   * @param aResource
   *        The Schematron resource. May not be <code>null</code>.
   */
  public AbstractSchematronResource (@NonNull final IReadableResource aResource)
  {
    m_aResource = ValueEnforcer.notNull (aResource, "Resource");
    m_sResourceID = aResource.getResourceID ();
    // Set a default entity resolver
    m_aEntityResolver = DefaultEntityResolver.createOnDemand (aResource);
  }

  @NonNull
  public final String getID ()
  {
    return m_sResourceID;
  }

  @NonNull
  public final IReadableResource getResource ()
  {
    return m_aResource;
  }

  public final boolean isUseCache ()
  {
    return m_bUseCache;
  }

  public final void setUseCache (final boolean bUseCache)
  {
    m_bUseCache = bUseCache;
  }

  public final boolean isLenient ()
  {
    return m_bLenient;
  }

  public final void setLenient (final boolean bLenient)
  {
    m_bLenient = bLenient;
  }

  @Nullable
  public final EntityResolver getEntityResolver ()
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

  /**
   * @return The {@link DOMReaderSettings} to be used for reading the XML files
   *         to be validated. This includes the {@link EntityResolver} to be
   *         used.
   * @see #getEntityResolver()
   */
  @NonNull
  @ReturnsMutableCopy
  protected DOMReaderSettings internalCreateDOMReaderSettings ()
  {
    final DOMReaderSettings aDRS = new DOMReaderSettings ();
    if (m_aEntityResolver != null)
      aDRS.setEntityResolver (m_aEntityResolver);
    return aDRS;
  }

  /**
   * Helper class to handle DOM Document and base URI for reference
   *
   * @author Philip Helger
   */
  protected static final class NodeAndBaseURI
  {
    private final Document m_aDoc;
    private final String m_sBaseURI;

    public NodeAndBaseURI (@NonNull final Document aDoc, @Nullable final String sBaseURI)
    {
      m_aDoc = aDoc;
      m_sBaseURI = sBaseURI;
    }
  }

  @Nullable
  @OverrideOnDemand
  protected NodeAndBaseURI getAsNode (@NonNull final IHasInputStream aXMLResource) throws Exception
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
      LOGGER.warn ("XML resource " + aXMLResource + " does not exist!");
      return null;
    }
    final Document aDoc = DOMReader.readXMLDOM (aIS, internalCreateDOMReaderSettings ());
    if (aDoc == null)
      throw new IllegalArgumentException ("Failed to read resource " + aXMLResource + " as XML");

    LOGGER.info ("Read XML resource " + aXMLResource);
    return new NodeAndBaseURI (aDoc, aStreamSrc.getSystemId ());
  }

  @Nullable
  @OverrideOnDemand
  protected Node getAsNode (@NonNull final Source aXMLSource) throws Exception
  {
    final DOMReaderSettings aDRS = internalCreateDOMReaderSettings ();
    aDRS.setFeatureValue (EXMLParserFeature.DISALLOW_DOCTYPE_DECL, false);
    // Convert to Node
    return SchematronResourceHelper.getNodeOfSource (aXMLSource, aDRS);
  }

  @NonNull
  public EValidity getSchematronValidity (@NonNull final IHasInputStream aXMLResource) throws Exception
  {
    // Don't check for valid Schematron upfront, because in case of a XSLT based
    // implementation and disabled caching, a Schematron might be evaluated
    // twice!

    final NodeAndBaseURI aXMLNode = getAsNode (aXMLResource);
    if (aXMLNode == null)
      return EValidity.INVALID;

    return getSchematronValidity (aXMLNode.m_aDoc, aXMLNode.m_sBaseURI);
  }

  @NonNull
  public EValidity getSchematronValidity (@NonNull final Source aXMLSource) throws Exception
  {
    // Don't check for valid Schematron upfront, because in case of a XSLT based
    // implementation and disabled caching, a Schematron might be evaluated
    // twice!

    final Node aXMLNode = getAsNode (aXMLSource);
    if (aXMLNode == null)
      return EValidity.INVALID;

    return getSchematronValidity (aXMLNode, aXMLSource.getSystemId ());
  }

  @Nullable
  public Document applySchematronValidation (@NonNull final IHasInputStream aXMLResource) throws Exception
  {
    // Don't check for valid Schematron upfront, because in case of a XSLT based
    // implementation and disabled caching, a Schematron might be evaluated
    // twice!

    final NodeAndBaseURI aXMLNode = getAsNode (aXMLResource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidation (aXMLNode.m_aDoc, aXMLNode.m_sBaseURI);
  }

  @Nullable
  public Document applySchematronValidation (@NonNull final Source aXMLSource) throws Exception
  {
    // Don't check for valid Schematron upfront, because in case of a XSLT based
    // implementation and disabled caching, a Schematron might be evaluated
    // twice!

    final Node aXMLNode = getAsNode (aXMLSource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidation (aXMLNode, aXMLSource.getSystemId ());
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@NonNull final IHasInputStream aXMLResource) throws Exception
  {
    // Don't check for valid Schematron upfront, because in case of a XSLT based
    // implementation and disabled caching, a Schematron might be evaluated
    // twice!

    final NodeAndBaseURI aXMLNode = getAsNode (aXMLResource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidationToSVRL (aXMLNode.m_aDoc, aXMLNode.m_sBaseURI);
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@NonNull final Source aXMLSource) throws Exception
  {
    // Don't check for valid Schematron upfront, because in case of a XSLT based
    // implementation and disabled caching, a Schematron might be evaluated
    // twice!

    final Node aXMLNode = getAsNode (aXMLSource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidationToSVRL (aXMLNode, aXMLSource.getSystemId ());
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Resource", m_aResource)
                                       .append ("ResourceID", m_sResourceID)
                                       .append ("UseCache", m_bUseCache)
                                       .append ("Lenient", m_bLenient)
                                       .appendIfNotNull ("EntityResolver", m_aEntityResolver)
                                       .getToString ();
  }
}
