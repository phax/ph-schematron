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
package com.helger.schematron.xslt;

import java.io.InputStream;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMResult;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.ext.CommonsLinkedHashMap;
import com.helger.commons.collection.ext.ICommonsOrderedMap;
import com.helger.commons.io.IHasInputStream;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.stream.StreamHelper;
import com.helger.commons.state.EValidity;
import com.helger.commons.string.ToStringGenerator;
import com.helger.commons.traits.IGenericImplTrait;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.svrl.SVRLReader;
import com.helger.schematron.xslt.validator.ISchematronXSLTValidator;
import com.helger.schematron.xslt.validator.SchematronXSLTValidatorDefault;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.LoggingTransformErrorListener;
import com.helger.xml.transform.TransformSourceFactory;

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
                                                          extends AbstractSchematronResource
                                                          implements IGenericImplTrait <IMPLTYPE>
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (AbstractSchematronXSLTBasedResource.class);

  protected ErrorListener m_aCustomErrorListener;
  protected URIResolver m_aCustomURIResolver;
  protected ICommonsOrderedMap <String, ?> m_aCustomParameters;
  private ISchematronXSLTValidator m_aXSLTValidator = new SchematronXSLTValidatorDefault ();

  public AbstractSchematronXSLTBasedResource (@Nonnull final IReadableResource aSCHResource)
  {
    super (aSCHResource);
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
    return m_aCustomParameters != null && m_aCustomParameters.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, ?> getParameters ()
  {
    return new CommonsLinkedHashMap <> (m_aCustomParameters);
  }

  @Nonnull
  public IMPLTYPE setParameters (@Nullable final Map <String, ?> aCustomParameters)
  {
    m_aCustomParameters = new CommonsLinkedHashMap <> (aCustomParameters);
    return thisAsT ();
  }

  /**
   * @return The XSLT provider passed in the constructor. May be
   *         <code>null</code>.
   */
  @Nullable
  public abstract ISchematronXSLTBasedProvider getXSLTProvider ();

  /**
   * @return The XSLT validator to be used. Never <code>null</code>.
   */
  @Nonnull
  public ISchematronXSLTValidator getXSLTValidator ()
  {
    return m_aXSLTValidator;
  }

  @Nonnull
  public IMPLTYPE setXSLTValidator (@Nonnull final ISchematronXSLTValidator aXSLTValidator)
  {
    ValueEnforcer.notNull (aXSLTValidator, "XSLTValidator");
    m_aXSLTValidator = aXSLTValidator;
    return thisAsT ();
  }

  public final boolean isValidSchematron ()
  {
    final ISchematronXSLTBasedProvider aXSLTProvider = getXSLTProvider ();
    return aXSLTProvider != null && aXSLTProvider.isValidSchematron ();
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    ValueEnforcer.notNull (aXMLResource, "XMLResource");

    final InputStream aIS = aXMLResource.getInputStream ();
    if (aIS == null)
    {
      // Resource not found
      s_aLogger.warn ("XML resource " + aXMLResource + " does not exist!");
      return EValidity.INVALID;
    }

    try
    {
      // InputStream to Source
      return getSchematronValidity (TransformSourceFactory.create (aIS));
    }
    finally
    {
      // Ensure InputStream is closed
      StreamHelper.close (aIS);
    }
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final Source aXMLSource) throws Exception
  {
    // We don't have a short circuit here - apply the full validation
    final SchematronOutputType aSO = applySchematronValidationToSVRL (aXMLSource);
    if (aSO == null)
      return EValidity.INVALID;

    // And now filter all elements that make the passed source invalid
    return m_aXSLTValidator.getSchematronValidity (aSO);
  }

  @Nullable
  public Document applySchematronValidation (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    ValueEnforcer.notNull (aXMLResource, "XMLResource");

    final InputStream aIS = aXMLResource.getInputStream ();
    if (aIS == null)
    {
      // Resource not found
      s_aLogger.warn ("XML resource " + aXMLResource + " does not exist!");
      return null;
    }

    try
    {
      return applySchematronValidation (TransformSourceFactory.create (aIS));
    }
    finally
    {
      StreamHelper.close (aIS);
    }
  }

  @Nullable
  public Document applySchematronValidation (@Nonnull final Node aXMLResource) throws Exception
  {
    ValueEnforcer.notNull (aXMLResource, "XMLResource");

    return applySchematronValidation (TransformSourceFactory.create (aXMLResource));
  }

  @Nullable
  public final Document applySchematronValidation (@Nonnull final Source aXMLSource) throws TransformerException
  {
    ValueEnforcer.notNull (aXMLSource, "XMLSource");

    final ISchematronXSLTBasedProvider aXSLTProvider = getXSLTProvider ();
    if (aXSLTProvider == null || !aXSLTProvider.isValidSchematron ())
    {
      // We cannot progress because of invalid Schematron
      return null;
    }

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
        aTransformer.setParameter (aEntry.getKey (), aEntry.getValue ());

    // Debug print the created XSLT document
    if (false)
      System.out.println (XMLWriter.getNodeAsString (aXSLTProvider.getXSLTDocument ()));

    if (s_aLogger.isDebugEnabled ())
      s_aLogger.debug ("Applying Schematron XSLT on XML [start]");

    // Do the main transformation
    aTransformer.transform (aXMLSource, new DOMResult (ret));

    if (s_aLogger.isDebugEnabled ())
      s_aLogger.debug ("Applying Schematron XSLT on XML [end]");

    // Debug print the created SVRL document
    if (false)
      System.out.println (XMLWriter.getNodeAsString (ret));

    return ret;
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    final Document aDoc = applySchematronValidation (aXMLResource);
    return aDoc == null ? null : SVRLReader.readXML (aDoc);
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Source aXMLSource) throws Exception
  {
    final Document aDoc = applySchematronValidation (aXMLSource);
    return aDoc == null ? null : SVRLReader.readXML (aDoc);
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Node aXMLSource) throws Exception
  {
    final Document aDoc = applySchematronValidation (aXMLSource);
    return aDoc == null ? null : SVRLReader.readXML (aDoc);
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ()).append ("XSLTValidator", m_aXSLTValidator).getToString ();
  }
}
