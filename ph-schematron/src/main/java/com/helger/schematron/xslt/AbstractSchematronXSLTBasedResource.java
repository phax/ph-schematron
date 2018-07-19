/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.annotation.ReturnsMutableObject;
import com.helger.commons.collection.impl.CommonsLinkedHashMap;
import com.helger.commons.collection.impl.ICommonsOrderedMap;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.state.EValidity;
import com.helger.commons.string.ToStringGenerator;
import com.helger.commons.traits.IGenericImplTrait;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.xslt.validator.ISchematronXSLTValidator;
import com.helger.schematron.xslt.validator.SchematronXSLTValidatorDefault;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.helger.xml.transform.LoggingTransformErrorListener;

import net.sf.saxon.jaxp.TransformerImpl;
import net.sf.saxon.lib.StandardLogger;
import net.sf.saxon.s9api.XsltTransformer;
import net.sf.saxon.trace.TraceEventMulticaster;
import net.sf.saxon.trace.XSLTTraceListener;

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
  private static final Logger LOGGER = LoggerFactory.getLogger (AbstractSchematronXSLTBasedResource.class);

  protected ErrorListener m_aCustomErrorListener;
  protected URIResolver m_aCustomURIResolver = new DefaultTransformURIResolver ();
  protected final ICommonsOrderedMap <String, Object> m_aCustomParameters = new CommonsLinkedHashMap <> ();
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

  @Nonnull
  @ReturnsMutableObject
  public ICommonsOrderedMap <String, Object> parameters ()
  {
    return m_aCustomParameters;
  }

  @Deprecated
  public boolean hasParameters ()
  {
    return m_aCustomParameters.isNotEmpty ();
  }

  @Nonnull
  @ReturnsMutableCopy
  @Deprecated
  public ICommonsOrderedMap <String, Object> getParameters ()
  {
    return m_aCustomParameters.getClone ();
  }

  @Nonnull
  @Deprecated
  public IMPLTYPE setParameters (@Nullable final Map <String, ?> aCustomParameters)
  {
    m_aCustomParameters.setAll (aCustomParameters);
    return thisAsT ();
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
  public IMPLTYPE setEntityResolver (@Nullable final EntityResolver aEntityResolver)
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
  public EValidity getSchematronValidity (@Nonnull final Node aXMLNode,
                                          @Nullable final String sBaseURI) throws Exception
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    // We don't have a short circuit here - apply the full validation
    final SchematronOutputType aSO = applySchematronValidationToSVRL (aXMLNode, sBaseURI);
    if (aSO == null)
      return EValidity.INVALID;

    // And now filter all elements that make the passed source invalid
    return m_aXSLTValidator.getSchematronValidity (aSO);
  }

  @Nullable
  public final Document applySchematronValidation (@Nonnull final Node aXMLNode,
                                                   @Nullable final String sBaseURI) throws TransformerException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    final ISchematronXSLTBasedProvider aXSLTProvider = getXSLTProvider ();
    if (aXSLTProvider == null || !aXSLTProvider.isValidSchematron ())
    {
      // We cannot progress because of invalid Schematron
      return null;
    }

    // Debug print the created XSLT document
    if (SchematronDebug.isShowCreatedXSLT ())
      LOGGER.info ("Created XSLT document: " + XMLWriter.getNodeAsString (aXSLTProvider.getXSLTDocument ()));

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

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Applying Schematron XSLT on XML [start]");

    // Enable this for hardcore Saxon debugging only
    if (false)
      if (aTransformer.getClass ().getName ().equals ("net.sf.saxon.jaxp.TransformerImpl"))
      {
        final XsltTransformer aXT = ((TransformerImpl) aTransformer).getUnderlyingXsltTransformer ();

        aXT.setMessageListener ( (a, b, c) -> LOGGER.info ("MessageListener: " + a + ", " + b + ", " + c));
        aXT.setTraceFunctionDestination (new StandardLogger (System.err));
        if (false)
          aXT.getUnderlyingController ().setTraceListener (new XSLTTraceListener ());
        if (false)
        {
          final XSLTTraceListener aTL = new XSLTTraceListener ();
          aTL.setOutputDestination (new StandardLogger (System.err));
          aXT.getUnderlyingController ().setTraceListener (TraceEventMulticaster.add (aTL, null));
        }

        if (false)
          System.out.println ("mode=" + aXT.getInitialMode ());
        if (false)
          System.out.println ("temp=" + aXT.getInitialTemplate ());
        if (false)
          System.out.println (aTransformer.getOutputProperties ());
      }

    // Do the main transformation
    aTransformer.transform (new DOMSource (aXMLNode), new DOMResult (ret));

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
    return new SVRLMarshaller ().read (aDoc);
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ()).append ("XSLTValidator", m_aXSLTValidator).getToString ();
  }
}
