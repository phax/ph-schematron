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
package com.helger.schematron.sch;

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
import com.helger.schematron.sch.SchematronSCHConfig.Builder;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Builder-driven validator entry point for the ISO Schematron engine (<code>.sch</code> files).
 * <p>
 * Use {@link #builder(com.helger.io.resource.IReadableResource)} to fluently configure and obtain
 * an instance, then call {@code applyTo*} / {@link #getValidity}. The compiled XSLT artifact is
 * resolved either from {@link SchematronSCHCache#shared() the shared cache}, a caller-supplied
 * {@link SchematronSCHCache} or freshly per invocation when uncached.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public final class SchematronSCH
{
  /** Default value for {@link #isValidateSVRL()}. */
  public static final boolean DEFAULT_VALIDATE_SVRL = true;

  private final SchematronSCHConfig m_aConfig;
  private final ISchematronXSLTBasedProvider m_aProvider;
  private ISchematronOutputValidityDeterminator m_aSOVDeterminator = new SchematronOutputValidityDeterminatorDefault ();
  private boolean m_bValidateSVRL = DEFAULT_VALIDATE_SVRL;

  private SchematronSCH (@NonNull final SchematronSCHConfig aConfig,
                         @Nullable final ISchematronXSLTBasedProvider aProvider)
  {
    m_aConfig = aConfig;
    m_aProvider = aProvider;
  }

  /**
   * @return The config used to compile this validator. Never <code>null</code>.
   */
  @NonNull
  public SchematronSCHConfig getConfig ()
  {
    return m_aConfig;
  }

  /**
   * @return The compiled XSLT provider, or <code>null</code> if compilation failed (e.g. invalid
   *         Schematron).
   */
  @Nullable
  public ISchematronXSLTBasedProvider getXSLTProvider ()
  {
    return m_aProvider;
  }

  /**
   * @return <code>true</code> if compilation succeeded and the underlying provider is valid.
   */
  public boolean isValidSchematron ()
  {
    return m_aProvider != null && m_aProvider.isValidSchematron ();
  }

  /**
   * @return The validity determinator used to interpret the SVRL output. Never <code>null</code>.
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
  public SchematronSCH setOutputValidityDeterminator (@NonNull final ISchematronOutputValidityDeterminator a)
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
  public SchematronSCH setValidateSVRL (final boolean b)
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
                                                    m_aConfig.getParameters (),
                                                    m_aConfig.getTelemetry ());
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
                                                    m_aConfig.getParameters (),
                                                    m_aConfig.getTelemetry ());
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
                                                m_bValidateSVRL,
                                                m_aConfig.getTelemetry ());
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
   * Compile the given config using {@link SchematronSCHCache#shared() the shared cache}.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @return A new {@link SchematronSCH} instance wrapping the compiled provider. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronSCH compileCached (@NonNull final SchematronSCHConfig aConfig) throws SchematronException
  {
    return compileCached (aConfig, SchematronSCHCache.shared ());
  }

  /**
   * Compile the given config using a caller-supplied cache.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @param aCache
   *        The cache instance to use. May not be <code>null</code>.
   * @return A new {@link SchematronSCH} instance wrapping the compiled provider. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronSCH compileCached (@NonNull final SchematronSCHConfig aConfig,
                                             @NonNull final SchematronSCHCache aCache) throws SchematronException
  {
    ValueEnforcer.notNull (aConfig, "Config");
    ValueEnforcer.notNull (aCache, "Cache");
    return new SchematronSCH (aConfig, aCache.getOrCompile (aConfig));
  }

  /**
   * Compile the given config without using any cache.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @return A new {@link SchematronSCH} instance wrapping the freshly compiled provider. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronSCH compileUncached (@NonNull final SchematronSCHConfig aConfig) throws SchematronException
  {
    ValueEnforcer.notNull (aConfig, "Config");
    return new SchematronSCH (aConfig, aConfig.compile ());
  }

  // === Convenience builder ===

  /**
   * Begin a fluent build chain. Delegates to {@link SchematronSCHConfig#builder}.
   *
   * @param aResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return A new builder. Never <code>null</code>.
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aResource)
  {
    return SchematronSCHConfig.builder (aResource);
  }
}
