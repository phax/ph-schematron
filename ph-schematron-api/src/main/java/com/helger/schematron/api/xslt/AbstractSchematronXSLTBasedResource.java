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
package com.helger.schematron.api.xslt;

import java.util.function.Consumer;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableObject;
import com.helger.base.debug.GlobalDebug;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EValidity;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.base.trait.IGenericImplTrait;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.xslt.validator.ISchematronOutputValidityDeterminator;
import com.helger.schematron.api.xslt.validator.SchematronOutputValidityDeterminatorDefault;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;
import com.helger.xml.transform.DefaultTransformURIResolver;

/**
 * Abstract implementation of a Schematron resource that is based on XSLT transformations.
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
  protected Consumer <TransformerFactory> m_aTFCustomizer;
  protected ISchematronTemplateTelemetry m_aTelemetry;
  private ISchematronOutputValidityDeterminator m_aSOVDeterminator = new SchematronOutputValidityDeterminatorDefault ();
  private boolean m_bValidateSVRL = DEFAULT_VALIDATE_SVRL;
  /**
   * Latched <code>true</code> the first time {@link #getXSLTProvider()} is called on this instance.
   * Used by {@link #checkNotCompiledYet()} so that compile-time setters fail fast post-compile,
   * instead of silently producing a stale provider on the next cache hit.
   */
  protected boolean m_bAlreadyCompiled;

  protected AbstractSchematronXSLTBasedResource (@NonNull final IReadableResource aSCHResource)
  {
    this (aSCHResource, null, null, null, null);
  }

  /**
   * Constructor
   *
   * @param aSCHResource
   *        The resource to read the Schematron rules from.
   * @param aCustomErrorListener
   *        The error listener to use, or <code>null</code> for the engine default.
   * @param aCustomURIResolver
   *        The URI resolver to use, or <code>null</code> for the engine default.
   * @param aTFCustomizer
   *        The optional TransformerFactory customizer - may be <code>null</code>.
   * @param aTelemetry
   *        The telemetry callback, or <code>null</code> to disable telemetry.
   */
  protected AbstractSchematronXSLTBasedResource (@NonNull final IReadableResource aSCHResource,
                                                 @Nullable final ErrorListener aCustomErrorListener,
                                                 @Nullable final URIResolver aCustomURIResolver,
                                                 @Nullable final Consumer <TransformerFactory> aTFCustomizer,
                                                 @Nullable final ISchematronTemplateTelemetry aTelemetry)
  {
    super (aSCHResource);
    // The URI resolver is necessary for the XSLT to resolve URLs relative to
    // the SCH
    final String sBaseURL = SchematronXSLTBaseURL.findBaseURL (aSCHResource);
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Using '" + sBaseURL + "' as base URL for SCH resource " + aSCHResource);
    m_aCustomErrorListener = aCustomErrorListener;
    m_aCustomURIResolver = aCustomURIResolver != null ? aCustomURIResolver : new DefaultTransformURIResolver ()
                                                                                                               .setDefaultBase (sBaseURL);
    m_aTFCustomizer = aTFCustomizer;
    m_aTelemetry = aTelemetry;
  }

  /**
   * Throw {@link IllegalStateException} if this resource has already been compiled (i.e.
   * {@link #getXSLTProvider()} has been called at least once and {@link #markCompiled()} was
   * invoked). Subclasses should call this from any compile-affecting setter.
   *
   * @since 10.0.0
   */
  protected final void checkNotCompiledYet ()
  {
    if (m_bAlreadyCompiled)
      throw new IllegalStateException ("This Schematron resource has already been compiled. " +
                                       "Construct a new instance instead of mutating compile-time settings post-compile.");
  }

  /**
   * Mark this resource as compiled. Called by subclass implementations of
   * {@link #getXSLTProvider()} at the start of the first invocation. Once latched, compile-time
   * setters that call {@link #checkNotCompiledYet()} will throw.
   *
   * @since 10.0.0
   */
  protected final void markCompiled ()
  {
    m_bAlreadyCompiled = true;
  }

  @Nullable
  public final ErrorListener getErrorListener ()
  {
    return m_aCustomErrorListener;
  }

  /**
   * @param aCustomErrorListener
   *        The error listener to use, or <code>null</code> for the engine default.
   * @return this
   * @deprecated since 10.0.0 — configure via the engine-specific resource Builder instead (e.g.
   *             <code>SchematronResourceSCH.builder(res).errorListener(...).build()</code>). Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final IMPLTYPE setErrorListener (@Nullable final ErrorListener aCustomErrorListener)
  {
    checkNotCompiledYet ();
    m_aCustomErrorListener = aCustomErrorListener;
    return thisAsT ();
  }

  @Nullable
  public final URIResolver getURIResolver ()
  {
    return m_aCustomURIResolver;
  }

  /**
   * @param aCustomURIResolver
   *        The URI resolver to use, or <code>null</code> for the engine default.
   * @return this
   * @deprecated since 10.0.0 — configure via the engine-specific resource Builder instead (e.g.
   *             <code>SchematronResourceSCH.builder(res).uriResolver(...).build()</code>). Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final IMPLTYPE setURIResolver (@Nullable final URIResolver aCustomURIResolver)
  {
    checkNotCompiledYet ();
    m_aCustomURIResolver = aCustomURIResolver;
    return thisAsT ();
  }

  @NonNull
  @ReturnsMutableObject
  public final ICommonsOrderedMap <String, Object> parameters ()
  {
    return m_aCustomParameters;
  }

  /**
   * @return The {@link TransformerFactory} customizer applied to the final compile-step transformer
   *         factory just before the validation stylesheet is compiled, or <code>null</code> if
   *         none.
   * @since 10.0.0
   */
  @Nullable
  public final Consumer <TransformerFactory> getTransformerFactoryCustomizer ()
  {
    return m_aTFCustomizer;
  }

  /**
   * @return The per-template telemetry callback configured for the XSLT transformation, or
   *         <code>null</code> if telemetry is disabled.
   * @since 10.0.0
   */
  @Nullable
  public final ISchematronTemplateTelemetry getTelemetry ()
  {
    return m_aTelemetry;
  }

  /**
   * Set the XML entity resolver to be used when reading the XML to be validated.
   *
   * @param aEntityResolver
   *        The entity resolver to set. May be <code>null</code>.
   * @return this
   * @since 4.2.3
   * @deprecated since 10.0.0 — configure via the engine-specific resource Builder instead (e.g.
   *             <code>SchematronResourceSCH.builder(res).entityResolver(...).build()</code>). Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final IMPLTYPE setEntityResolver (@Nullable final EntityResolver aEntityResolver)
  {
    internalSetEntityResolver (aEntityResolver);
    return thisAsT ();
  }

  /**
   * @return The XSLT provider passed in the constructor. May be <code>null</code>.
   */
  @Nullable
  public abstract ISchematronXSLTBasedProvider getXSLTProvider ();

  /**
   * @return The Schematron output validator to be used. Never <code>null</code>.
   */
  @NonNull
  public final ISchematronOutputValidityDeterminator getOutputValidityDeterminator ()
  {
    return m_aSOVDeterminator;
  }

  /**
   * @param aSOVDeterminator
   *        The validity determinator to use. May not be <code>null</code>.
   * @return this
   * @deprecated since 10.0.0 — configure via the engine-specific resource Builder instead (e.g.
   *             <code>SchematronResourceSCH.builder(res).outputValidityDeterminator(...).build()</code>).
   *             Will remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final IMPLTYPE setOutputValidityDeterminator (@NonNull final ISchematronOutputValidityDeterminator aSOVDeterminator)
  {
    ValueEnforcer.notNull (aSOVDeterminator, "SchematronOutputValidityDeterminator");
    m_aSOVDeterminator = aSOVDeterminator;
    return thisAsT ();
  }

  public final boolean isValidateSVRL ()
  {
    return m_bValidateSVRL;
  }

  /**
   * @param bValidateSVRL
   *        <code>true</code> to validate the produced SVRL against its XSD, <code>false</code> to
   *        skip validation.
   * @return this
   * @deprecated since 10.0.0 — configure via the engine-specific resource Builder instead (e.g.
   *             <code>SchematronResourceSCH.builder(res).validateSVRL(false).build()</code>). Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
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

  @NonNull
  public final EValidity getSchematronValidity (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
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

  @Override
  @Nullable
  public final Document applySchematronValidation (@NonNull final Source aSource) throws TransformerException
  {
    return SchematronXSLTValidator.applyValidation (getXSLTProvider (),
                                                    aSource,
                                                    m_aCustomErrorListener,
                                                    m_aCustomURIResolver,
                                                    m_aCustomParameters,
                                                    m_aTelemetry);
  }

  @Nullable
  public Document applySchematronValidation (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                            throws Exception
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    final DOMSource aSource = new DOMSource (aXMLNode);
    aSource.setSystemId (sBaseURI);
    return applySchematronValidation (aSource);
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@NonNull final Node aXMLSource,
                                                               @Nullable final String sBaseURI) throws Exception
  {
    final Document aDoc = applySchematronValidation (aXMLSource, sBaseURI);
    if (aDoc == null)
      return null;

    // Avoid NPE later on
    if (aDoc.getDocumentElement () == null)
      throw new IllegalStateException ("Internal error: created SVRL DOM Document has no document node!");

    if (false)
      LOGGER.info (XMLWriter.getNodeAsString (aDoc,
                                              new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN)));

    // Now try to read the resulting XML document as a SVRL document - may fail
    final var aMarshaller = new SVRLMarshaller ().setUseSchema (m_bValidateSVRL);
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
