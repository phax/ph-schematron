/**
 * Copyright (C) 2014-2015 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.dom.DOMResult;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.IInputStreamProvider;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.io.streams.StreamUtils;
import com.helger.commons.state.EValidity;
import com.helger.commons.string.ToStringGenerator;
import com.helger.commons.xml.XMLFactory;
import com.helger.commons.xml.serialize.XMLWriter;
import com.helger.commons.xml.transform.TransformSourceFactory;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.svrl.SVRLReader;
import com.helger.schematron.xslt.ISchematronXSLTTransformerCustomizer.EStep;

/**
 * Abstract implementation of a Schematron resource that is based on XSLT
 * transformations.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public abstract class AbstractSchematronXSLTResource extends AbstractSchematronResource
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (AbstractSchematronXSLTResource.class);

  private final ISchematronXSLTTransformerCustomizer m_aTransformerCustomizer;
  private final ISchematronXSLTProvider m_aXSLTProvider;
  private final ISchematronXSLTValidator m_aXSLTValidator;

  public AbstractSchematronXSLTResource (@Nonnull final IReadableResource aSCHResource,
                                         @Nonnull final ISchematronXSLTTransformerCustomizer aTransformerCustomizer,
                                         @Nullable final ISchematronXSLTProvider aXSLTProvider,
                                         @Nonnull final ISchematronXSLTValidator aXSLTValidator)
  {
    super (aSCHResource);
    ValueEnforcer.notNull (aTransformerCustomizer, "TransformerCustomizer");
    ValueEnforcer.notNull (aXSLTValidator, "XSLTValidator");

    m_aTransformerCustomizer = aTransformerCustomizer;
    m_aXSLTProvider = aXSLTProvider;
    m_aXSLTValidator = aXSLTValidator;
  }

  /**
   * @return The XSLT provider passed in the constructor. May be
   *         <code>null</code>.
   */
  @Nullable
  public ISchematronXSLTProvider getXSLTProvider ()
  {
    return m_aXSLTProvider;
  }

  /**
   * @return The XSLT validator passed in the constructor. Never
   *         <code>null</code>.
   */
  @Nonnull
  public ISchematronXSLTValidator getXSLTValidator ()
  {
    return m_aXSLTValidator;
  }

  public final boolean isValidSchematron ()
  {
    return m_aXSLTProvider != null && m_aXSLTProvider.isValidSchematron ();
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final IInputStreamProvider aXMLResource) throws Exception
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
      StreamUtils.close (aIS);
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
  public Document applySchematronValidation (@Nonnull final IInputStreamProvider aXMLResource) throws Exception
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
      StreamUtils.close (aIS);
    }
  }

  @Nullable
  public final Document applySchematronValidation (@Nonnull final Source aXMLSource) throws Exception
  {
    ValueEnforcer.notNull (aXMLSource, "XMLSource");

    if (!isValidSchematron ())
      return null;

    // Create result document
    final Document ret = XMLFactory.newDocument ();

    // Create the transformer object from the templates specified in the
    // constructor
    final Transformer aTransformer = m_aXSLTProvider.getXSLTTemplates ().newTransformer ();
    m_aTransformerCustomizer.customize (EStep.XSLT2XML, aTransformer);

    // Debug print the created XSLT document
    if (false)
      System.out.println (XMLWriter.getXMLString (m_aXSLTProvider.getXSLTDocument ()));

    // Do the main transformation
    aTransformer.transform (aXMLSource, new DOMResult (ret));

    // Debug print the created SVRL document
    if (false)
      System.out.println (XMLWriter.getXMLString (ret));

    return ret;
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final IInputStreamProvider aXMLResource) throws Exception
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

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ())
                            .append ("TransformerCustomizer", m_aTransformerCustomizer)
                            .append ("XSLTProvider", m_aXSLTProvider)
                            .append ("XSLTValidator", m_aXSLTValidator)
                            .toString ();
  }
}
