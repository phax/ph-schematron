/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.schematron.api.xslt;

import java.net.URL;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableObject;
import com.helger.commons.collection.impl.CommonsLinkedHashMap;
import com.helger.commons.collection.impl.ICommonsOrderedMap;
import com.helger.commons.debug.GlobalDebug;
import com.helger.commons.io.file.FileHelper;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.state.EValidity;
import com.helger.commons.string.StringHelper;
import com.helger.commons.string.ToStringGenerator;
import com.helger.commons.traits.IGenericImplTrait;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.api.xslt.validator.ISchematronOutputValidityDeterminator;
import com.helger.schematron.api.xslt.validator.SchematronOutputValidityDeterminatorDefault;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.helger.xml.transform.LoggingTransformErrorListener;

/**
 * Abstract implementation of a Schematron resource that is based on XSLT
 * transformations.
 *
 * @author Philip Helger
 * @param <IMPLTYPE>
 *        Implementation type
 */
@NotThreadSafe
public abstract class AbstractSchematronXSLTBasedResource <IMPLTYPE extends AbstractSchematronXSLTBasedResource <IMPLTYPE>>
                                                          extends
                                                          AbstractSchematronResource implements
                                                          ISchematronXSLTBasedResource,
                                                          IGenericImplTrait <IMPLTYPE>
{
  public static final boolean DEFAULT_VALIDATE_SVRL = true;
  private static final Logger LOGGER = LoggerFactory.getLogger (AbstractSchematronXSLTBasedResource.class);

  protected ErrorListener m_aCustomErrorListener;
  protected URIResolver m_aCustomURIResolver = new DefaultTransformURIResolver ();
  protected final ICommonsOrderedMap <String, Object> m_aCustomParameters = new CommonsLinkedHashMap <> ();
  private ISchematronOutputValidityDeterminator m_aSOVDeterminator = new SchematronOutputValidityDeterminatorDefault ();
  private boolean m_bValidateSVRL = DEFAULT_VALIDATE_SVRL;

  @Nullable
  private static String _findBaseURL (@Nonnull final IReadableResource aRes)
  {
    if (aRes instanceof FileSystemResource)
    {
      // Use parent file as resolution base
      return FileHelper.getAsURLString (((FileSystemResource) aRes).getAsFile ().getParentFile ());
    }

    // Generic URL
    final URL aBaseURL = aRes.getAsURL ();
    return aBaseURL != null ? aBaseURL.toExternalForm () : null;
  }

  public AbstractSchematronXSLTBasedResource (@Nonnull final IReadableResource aSCHResource)
  {
    super (aSCHResource);
    // The URI resolver is necessary for the XSLT to resolve URLs relative to
    // the SCH
    final String sBaseURL = _findBaseURL (aSCHResource);
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Using '" + sBaseURL + "' as base URL for SCH resource " + aSCHResource);
    setURIResolver (new DefaultTransformURIResolver ().setDefaultBase (sBaseURL));
  }

  @Nullable
  public final ErrorListener getErrorListener ()
  {
    return m_aCustomErrorListener;
  }

  @Nonnull
  public final IMPLTYPE setErrorListener (@Nullable final ErrorListener aCustomErrorListener)
  {
    m_aCustomErrorListener = aCustomErrorListener;
    return thisAsT ();
  }

  @Nullable
  public final URIResolver getURIResolver ()
  {
    return m_aCustomURIResolver;
  }

  @Nonnull
  public final IMPLTYPE setURIResolver (@Nullable final URIResolver aCustomURIResolver)
  {
    m_aCustomURIResolver = aCustomURIResolver;
    return thisAsT ();
  }

  @Nonnull
  @ReturnsMutableObject
  public final ICommonsOrderedMap <String, Object> parameters ()
  {
    return m_aCustomParameters;
  }

  /**
   * Set the XML entity resolver to be used when reading the XML to be
   * validated.
   *
   * @param aEntityResolver
   *        The entity resolver to set. May be <code>null</code>.
   * @return this
   * @since 4.2.3
   */
  @Nonnull
  public final IMPLTYPE setEntityResolver (@Nullable final EntityResolver aEntityResolver)
  {
    internalSetEntityResolver (aEntityResolver);
    return thisAsT ();
  }

  /**
   * @return The XSLT provider passed in the constructor. May be
   *         <code>null</code>.
   */
  @Nullable
  public abstract ISchematronXSLTBasedProvider getXSLTProvider ();

  /**
   * @return The Schematron output validator to be used. Never
   *         <code>null</code>.
   */
  @Nonnull
  public final ISchematronOutputValidityDeterminator getOutputValidityDeterminator ()
  {
    return m_aSOVDeterminator;
  }

  @Nonnull
  public final IMPLTYPE setOutputValidityDeterminator (@Nonnull final ISchematronOutputValidityDeterminator aSOVDeterminator)
  {
    ValueEnforcer.notNull (aSOVDeterminator, "SchematronOutputValidityDeterminator");
    m_aSOVDeterminator = aSOVDeterminator;
    return thisAsT ();
  }

  public final boolean isValidateSVRL ()
  {
    return m_bValidateSVRL;
  }

  @Nonnull
  public final IMPLTYPE setValidateSVRL (final boolean bValidateSVRL)
  {
    m_bValidateSVRL = bValidateSVRL;
    return thisAsT ();
  }

  public final boolean isValidSchematron ()
  {
    final ISchematronXSLTBasedProvider aXSLTProvider = getXSLTProvider ();
    return aXSLTProvider != null && aXSLTProvider.isValidSchematron ();
  }

  @Nonnull
  public final EValidity getSchematronValidity (@Nonnull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                               throws Exception
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    // We don't have a short circuit here - apply the full validation
    final SchematronOutputType aSO = applySchematronValidationToSVRL (aXMLNode, sBaseURI);
    if (aSO == null)
      return EValidity.INVALID;

    // And now filter all elements that make the passed source invalid
    return m_aSOVDeterminator.getSchematronOutputValidity (aSO);
  }

  @Nullable
  public final Document applySchematronValidation (@Nonnull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                                  throws TransformerException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    final ISchematronXSLTBasedProvider aXSLTProvider = getXSLTProvider ();
    if (aXSLTProvider == null || !aXSLTProvider.isValidSchematron ())
    {
      // We cannot progress because of invalid Schematron
      LOGGER.warn ("Cannot apply the Schematron validation, due to errors in the Schematron rules");
      return null;
    }

    // Debug print the created XSLT document
    if (SchematronDebug.isShowCreatedXSLT ())
      LOGGER.info ("Created XSLT document: " + XMLWriter.getNodeAsString (aXSLTProvider.getXSLTDocument ()));

    LOGGER.info ("Applying Schematron XSLT on XML instance" +
                 (StringHelper.hasText (sBaseURI) ? " with base URI '" + sBaseURI + "'" : ""));

    // Create result document
    final Document ret = XMLFactory.newDocument ();

    // Create the transformer object from the templates specified in the
    // constructor
    final Transformer aTransformer = aXSLTProvider.getXSLTTransformer ();

    // Apply customizations
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
      {
        if (LOGGER.isDebugEnabled ())
          LOGGER.debug ("Adding XSLT parameter '" + aEntry.getKey () + "' = '" + aEntry.getValue () + "'");
        aTransformer.setParameter (aEntry.getKey (), aEntry.getValue ());
      }

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Applying Schematron XSLT on XML [start]");

    // Do the main transformation
    {
      final DOMSource aSource = new DOMSource (aXMLNode);
      aSource.setSystemId (sBaseURI);
      aTransformer.transform (aSource, new DOMResult (ret));
    }

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Applying Schematron XSLT on XML [end]");

    // Debug print the created SVRL document
    if (SchematronDebug.isShowCreatedSVRL ())
      LOGGER.info ("Created SVRL:\n" + XMLWriter.getNodeAsString (ret));

    return ret;
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Node aXMLSource,
                                                               @Nullable final String sBaseURI) throws Exception
  {
    final Document aDoc = applySchematronValidation (aXMLSource, sBaseURI);
    if (aDoc == null)
      return null;

    // Avoid NPE later on
    if (aDoc.getDocumentElement () == null)
      throw new IllegalStateException ("Internal error: created SVRL DOM Document has no document node!");

    // Now try to read the resulting XML document as a SVRL document - may fail
    final SVRLMarshaller aMarshaller = new SVRLMarshaller (m_bValidateSVRL);
    if (GlobalDebug.isDebugMode ())
    {
      // Set an exception callback that logs the source node as well
      aMarshaller.readExceptionCallbacks ()
                 .set (ex -> LOGGER.error ("Error parsing the following SVRL:\n" + XMLWriter.getNodeAsString (aDoc),
                                           ex));
    }
    return aMarshaller.read (aDoc);
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ())
                            .append ("CustomErrorListener", m_aCustomErrorListener)
                            .append ("CustomURIResolver", m_aCustomURIResolver)
                            .append ("CustomParameters", m_aCustomParameters)
                            .append ("XSLTValidator", m_aSOVDeterminator)
                            .append ("ValidateSVRL", m_bValidateSVRL)
                            .getToString ();
  }
}
