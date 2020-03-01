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
package com.helger.schematron;

import java.io.InputStream;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

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
  public AbstractSchematronResource (@Nonnull final IReadableResource aResource)
  {
    m_aResource = ValueEnforcer.notNull (aResource, "Resource");
    m_sResourceID = aResource.getResourceID ();
    // Set a default entity resolver
    m_aEntityResolver = DefaultEntityResolver.createOnDemand (aResource);
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
  @Nonnull
  @ReturnsMutableCopy
  protected DOMReaderSettings internalCreateDOMReaderSettings ()
  {
    final DOMReaderSettings aDRS = new DOMReaderSettings ();
    aDRS.setFeatureValues (EXMLParserFeature.AVOID_XML_ATTACKS);
    if (m_aEntityResolver != null)
      aDRS.setEntityResolver (m_aEntityResolver);
    if (false)
    {
      final boolean m_bLoadExternalSchemas = false;
      aDRS.setFeatureValue (EXMLParserFeature.EXTERNAL_GENERAL_ENTITIES, m_bLoadExternalSchemas);
      aDRS.setFeatureValue (EXMLParserFeature.EXTERNAL_PARAMETER_ENTITIES, m_bLoadExternalSchemas);
      aDRS.setFeatureValue (EXMLParserFeature.LOAD_EXTERNAL_DTD, m_bLoadExternalSchemas);
      aDRS.setFeatureValue (EXMLParserFeature.VALIDATION, true);
      aDRS.setFeatureValue (EXMLParserFeature.NAMESPACES, true);
    }
    return aDRS;
  }

  protected static final class NodeAndBaseURI
  {
    private final Document m_aDoc;
    private final String m_sBaseURI;

    public NodeAndBaseURI (@Nonnull final Document aDoc, @Nullable final String sBaseURI)
    {
      m_aDoc = aDoc;
      m_sBaseURI = sBaseURI;
    }
  }

  @Nullable
  protected NodeAndBaseURI getAsNode (@Nonnull final IHasInputStream aXMLResource) throws Exception
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
  protected Node getAsNode (@Nonnull final Source aXMLSource) throws Exception
  {
    DOMReaderSettings settings = internalCreateDOMReaderSettings ();
    settings.setFeatureValue(EXMLParserFeature.DISALLOW_DOCTYPE_DECL, false);
    // Convert to Node
    return SchematronResourceHelper.getNodeOfSource (aXMLSource, settings);
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    if (!isValidSchematron ())
      return EValidity.INVALID;

    final NodeAndBaseURI aXMLNode = getAsNode (aXMLResource);
    if (aXMLNode == null)
      return EValidity.INVALID;

    return getSchematronValidity (aXMLNode.m_aDoc, aXMLNode.m_sBaseURI);
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final Source aXMLSource) throws Exception
  {
    if (!isValidSchematron ())
      return EValidity.INVALID;

    final Node aXMLNode = getAsNode (aXMLSource);
    if (aXMLNode == null)
      return EValidity.INVALID;

    return getSchematronValidity (aXMLNode, aXMLSource.getSystemId ());
  }

  @Nullable
  public Document applySchematronValidation (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    if (!isValidSchematron ())
      return null;

    final NodeAndBaseURI aXMLNode = getAsNode (aXMLResource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidation (aXMLNode.m_aDoc, aXMLNode.m_sBaseURI);
  }

  @Nullable
  public Document applySchematronValidation (@Nonnull final Source aXMLSource) throws Exception
  {
    if (!isValidSchematron ())
      return null;

    final Node aXMLNode = getAsNode (aXMLSource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidation (aXMLNode, aXMLSource.getSystemId ());
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    if (!isValidSchematron ())
      return null;

    final NodeAndBaseURI aXMLNode = getAsNode (aXMLResource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidationToSVRL (aXMLNode.m_aDoc, aXMLNode.m_sBaseURI);
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Source aXMLSource) throws Exception
  {
    if (!isValidSchematron ())
      return null;

    final Node aXMLNode = getAsNode (aXMLSource);
    if (aXMLNode == null)
      return null;

    return applySchematronValidationToSVRL (aXMLNode, aXMLSource.getSystemId ());
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
