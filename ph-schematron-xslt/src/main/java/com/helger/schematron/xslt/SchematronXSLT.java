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
package com.helger.schematron.xslt;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EValidity;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronException;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.api.xslt.SchematronXSLTValidator;
import com.helger.schematron.api.xslt.validator.ISchematronOutputValidityDeterminator;
import com.helger.schematron.api.xslt.validator.SchematronOutputValidityDeterminatorDefault;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.xslt.SchematronXSLTConfig.Builder;

/**
 * Builder-driven validator entry point for pre-built XSLT-based Schematron rules.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public final class SchematronXSLT
{
  /** Default value for {@link #isValidateSVRL()}. */
  public static final boolean DEFAULT_VALIDATE_SVRL = true;

  private final SchematronXSLTConfig m_aConfig;
  private final ISchematronXSLTBasedProvider m_aProvider;
  private ISchematronOutputValidityDeterminator m_aSOVDeterminator = new SchematronOutputValidityDeterminatorDefault ();
  private boolean m_bValidateSVRL = DEFAULT_VALIDATE_SVRL;

  private SchematronXSLT (@NonNull final SchematronXSLTConfig aConfig,
                          @Nullable final ISchematronXSLTBasedProvider aProvider)
  {
    m_aConfig = aConfig;
    m_aProvider = aProvider;
  }

  /**
   * @return The configuration this instance was created from. Never <code>null</code>.
   */
  @NonNull
  public SchematronXSLTConfig getConfig ()
  {
    return m_aConfig;
  }

  /**
   * @return The compiled XSLT-based provider, or <code>null</code> if compilation failed (e.g.
   *         missing or invalid resource).
   */
  @Nullable
  public ISchematronXSLTBasedProvider getXSLTProvider ()
  {
    return m_aProvider;
  }

  /**
   * @return <code>true</code> if a usable provider was compiled and reports itself as valid.
   */
  public boolean isValidSchematron ()
  {
    return m_aProvider != null && m_aProvider.isValidSchematron ();
  }

  /**
   * @return The current output validity determinator used by {@link #getValidity(Node, String)}.
   *         Never <code>null</code>.
   */
  @NonNull
  public ISchematronOutputValidityDeterminator getOutputValidityDeterminator ()
  {
    return m_aSOVDeterminator;
  }

  /**
   * Set the output validity determinator used by {@link #getValidity(Node, String)}.
   *
   * @param a
   *        The new determinator. May not be <code>null</code>.
   * @return this for chaining
   */
  @NonNull
  public SchematronXSLT setOutputValidityDeterminator (@NonNull final ISchematronOutputValidityDeterminator a)
  {
    ValueEnforcer.notNull (a, "SOVDeterminator");
    m_aSOVDeterminator = a;
    return this;
  }

  /**
   * @return <code>true</code> if the produced SVRL DOM is validated against the SVRL JAXB schema
   *         while unmarshalling. Default is {@link #DEFAULT_VALIDATE_SVRL}.
   */
  public boolean isValidateSVRL ()
  {
    return m_bValidateSVRL;
  }

  /**
   * Toggle SVRL schema validation during unmarshalling.
   *
   * @param b
   *        <code>true</code> to validate the produced SVRL, <code>false</code> to skip validation.
   * @return this for chaining
   */
  @NonNull
  public SchematronXSLT setValidateSVRL (final boolean b)
  {
    m_bValidateSVRL = b;
    return this;
  }

  /**
   * Apply the Schematron validation to the given XML source and return the raw SVRL DOM.
   *
   * @param aSource
   *        The XML source to validate. May not be <code>null</code>.
   * @return The SVRL DOM document or <code>null</code> if the provider is unusable.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @Nullable
  public Document applyValidation (@NonNull final Source aSource) throws TransformerException
  {
    return SchematronXSLTValidator.applyValidation (m_aProvider,
                                                    aSource,
                                                    m_aConfig.getErrorListener (),
                                                    m_aConfig.getURIResolver (),
                                                    m_aConfig.getParameters ());
  }

  /**
   * Apply the Schematron validation to the given DOM node and return the raw SVRL DOM.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The SVRL DOM document or <code>null</code> if the provider is unusable.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @Nullable
  public Document applyValidation (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                  throws TransformerException
  {
    return SchematronXSLTValidator.applyValidation (m_aProvider,
                                                    aXMLNode,
                                                    sBaseURI,
                                                    m_aConfig.getErrorListener (),
                                                    m_aConfig.getURIResolver (),
                                                    m_aConfig.getParameters ());
  }

  /**
   * Apply the Schematron validation to the given DOM node and return the parsed SVRL object.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The parsed SVRL object, or <code>null</code> if validation could not be applied.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @Nullable
  public SchematronOutputType applyToSVRL (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                          throws TransformerException
  {
    return SchematronXSLTValidator.applyToSVRL (m_aProvider,
                                                aXMLNode,
                                                sBaseURI,
                                                m_aConfig.getErrorListener (),
                                                m_aConfig.getURIResolver (),
                                                m_aConfig.getParameters (),
                                                m_bValidateSVRL);
  }

  /**
   * Apply the Schematron validation and reduce the SVRL output to a {@link EValidity} verdict via
   * the configured {@link ISchematronOutputValidityDeterminator}.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The validity verdict. Never <code>null</code>. {@link EValidity#INVALID} is returned if
   *         validation could not be applied.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @NonNull
  public EValidity getValidity (@NonNull final Node aXMLNode, @Nullable final String sBaseURI) throws TransformerException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");
    final SchematronOutputType aSO = applyToSVRL (aXMLNode, sBaseURI);
    if (aSO == null)
      return EValidity.INVALID;
    return m_aSOVDeterminator.getSchematronOutputValidity (aSO);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Config", m_aConfig)
                                       .append ("Provider", m_aProvider)
                                       .append ("ValidateSVRL", m_bValidateSVRL)
                                       .getToString ();
  }

  // === Compilation entry points ===

  /**
   * Compile the given config via the {@link SchematronXSLTCache#shared() shared cache}.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @return A new {@link SchematronXSLT} instance wrapping the compiled provider. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronXSLT compileCached (@NonNull final SchematronXSLTConfig aConfig) throws SchematronException
  {
    return compileCached (aConfig, SchematronXSLTCache.shared ());
  }

  /**
   * Compile the given config via the supplied cache instance.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @param aCache
   *        The cache instance to use. May not be <code>null</code>.
   * @return A new {@link SchematronXSLT} instance wrapping the compiled provider. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronXSLT compileCached (@NonNull final SchematronXSLTConfig aConfig,
                                              @NonNull final SchematronXSLTCache aCache) throws SchematronException
  {
    ValueEnforcer.notNull (aConfig, "Config");
    ValueEnforcer.notNull (aCache, "Cache");
    return new SchematronXSLT (aConfig, aCache.getOrCompile (aConfig));
  }

  /**
   * Compile the given config without using any cache. The returned instance owns its provider.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @return A new {@link SchematronXSLT} instance wrapping the freshly compiled provider. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronXSLT compileUncached (@NonNull final SchematronXSLTConfig aConfig) throws SchematronException
  {
    ValueEnforcer.notNull (aConfig, "Config");
    return new SchematronXSLT (aConfig, aConfig.compile ());
  }

  /**
   * Shortcut to {@link SchematronXSLTConfig#builder(IReadableResource)}.
   *
   * @param aResource
   *        The XSLT resource to validate against. May not be <code>null</code>.
   * @return A new {@link Builder} pre-configured with the given resource. Never <code>null</code>.
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aResource)
  {
    return SchematronXSLTConfig.builder (aResource);
  }
}
