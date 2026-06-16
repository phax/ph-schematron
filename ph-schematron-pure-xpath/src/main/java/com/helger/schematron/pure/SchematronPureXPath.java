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
package com.helger.schematron.pure;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EValidity;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.ISchematronValidator;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.SchematronException;
import com.helger.schematron.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.SchematronPureXPathConfig.Builder;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Builder-driven validator entry point for the pure-Java XPath Schematron engine.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public final class SchematronPureXPath implements ISchematronValidator
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronPureXPath.class);

  private final SchematronPureXPathConfig m_aConfig;
  private final IPSBoundSchema m_aBoundSchema;

  private SchematronPureXPath (@NonNull final SchematronPureXPathConfig aConfig,
                               @NonNull final IPSBoundSchema aBoundSchema)
  {
    m_aConfig = aConfig;
    m_aBoundSchema = aBoundSchema;
  }

  /**
   * @return The configuration this instance was created from. Never <code>null</code>.
   */
  @NonNull
  public SchematronPureXPathConfig getConfig ()
  {
    return m_aConfig;
  }

  /**
   * @return The compiled, bound Schematron schema. Never <code>null</code>.
   */
  @NonNull
  public IPSBoundSchema getBoundSchema ()
  {
    return m_aBoundSchema;
  }

  /**
   * @return <code>true</code> if the underlying Schematron parses and binds without errors.
   */
  public boolean isValidSchematron ()
  {
    try
    {
      final IPSErrorHandler aEH = m_aConfig.getErrorHandler () != null ? m_aConfig.getErrorHandler ()
                                                                       : new DoNothingPSErrorHandler ();
      return m_aBoundSchema.getOriginalSchema ().isValid (aEH);
    }
    catch (final RuntimeException ex)
    {
      return false;
    }
  }

  /**
   * Apply Schematron validation to the given XML node and return the parsed SVRL object.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The parsed SVRL output. Never <code>null</code>.
   * @throws SchematronException
   *         If the validation fails.
   */
  @NonNull
  public SchematronOutputType applyToSVRL (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                          throws SchematronException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");
    final SchematronOutputType aSOT = m_aBoundSchema.validateComplete (aXMLNode, sBaseURI);
    if (SchematronDebug.isShowCreatedSVRL ())
      LOGGER.info ("Created SVRL:\n" + new SVRLMarshaller ().setUseSchema (false).getAsString (aSOT));
    return aSOT;
  }

  /**
   * Quick validity check (short-circuits on the first failing assertion).
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The validity verdict. Never <code>null</code>. {@link EValidity#INVALID} is returned if
   *         the underlying Schematron itself is invalid.
   * @throws Exception
   *         If the partial validation pass fails.
   */
  @NonNull
  public EValidity getValidity (@NonNull final Node aXMLNode, @Nullable final String sBaseURI) throws Exception
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");
    if (!isValidSchematron ())
      return EValidity.INVALID;
    return m_aBoundSchema.validatePartially (aXMLNode, sBaseURI);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Config", m_aConfig)
                                       .append ("BoundSchema", m_aBoundSchema)
                                       .getToString ();
  }

  // === Compilation entry points ===

  /**
   * Compile the given config via the {@link SchematronPureXPathCache#shared() shared cache}.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @return A new {@link SchematronPureXPath} instance wrapping the bound schema. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronPureXPath compileCached (@NonNull final SchematronPureXPathConfig aConfig) throws SchematronException
  {
    return compileCached (aConfig, SchematronPureXPathCache.shared ());
  }

  /**
   * Compile the given config via the supplied cache instance.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @param aCache
   *        The cache instance to use. May not be <code>null</code>.
   * @return A new {@link SchematronPureXPath} instance wrapping the bound schema. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronPureXPath compileCached (@NonNull final SchematronPureXPathConfig aConfig,
                                                   @NonNull final SchematronPureXPathCache aCache) throws SchematronException
  {
    ValueEnforcer.notNull (aConfig, "Config");
    ValueEnforcer.notNull (aCache, "Cache");
    final IPSBoundSchema aBound = aCache.getOrCompile (aConfig);
    if (aBound == null)
      throw new SchematronException ("Failed to bind Schematron " + aConfig.getResource ());
    return new SchematronPureXPath (aConfig, aBound);
  }

  /**
   * Compile the given config without using any cache.
   *
   * @param aConfig
   *        The configuration to compile. May not be <code>null</code>.
   * @return A new {@link SchematronPureXPath} instance wrapping the freshly bound schema. Never
   *         <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  public static SchematronPureXPath compileUncached (@NonNull final SchematronPureXPathConfig aConfig) throws SchematronException
  {
    ValueEnforcer.notNull (aConfig, "Config");
    final IPSBoundSchema aBound = aConfig.compile ();
    if (aBound == null)
      throw new SchematronException ("Failed to bind Schematron " + aConfig.getResource ());
    return new SchematronPureXPath (aConfig, aBound);
  }

  /**
   * Shortcut to {@link SchematronPureXPathConfig#builder(IReadableResource)}.
   *
   * @param aResource
   *        The Schematron resource to validate against. May not be <code>null</code>.
   * @return A new {@link Builder} pre-configured with the given resource. Never <code>null</code>.
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aResource)
  {
    return SchematronPureXPathConfig.builder (aResource);
  }
}
