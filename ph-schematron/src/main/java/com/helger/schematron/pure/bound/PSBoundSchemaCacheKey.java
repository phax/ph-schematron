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
package com.helger.schematron.pure.bound;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

import org.xml.sax.EntityResolver;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.OverrideOnDemand;
import com.helger.commons.equals.EqualsHelper;
import com.helger.commons.hashcode.HashCodeGenerator;
import com.helger.commons.hashcode.IHashCodeGenerator;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.SchematronException;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.binding.PSQueryBindingRegistry;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.preprocess.PSPreprocessor;
import com.helger.schematron.pure.preprocess.SchematronPreprocessException;

/**
 * This class represents keys for the {@link PSBoundSchemaCache}. It is a
 * combination of a resource and a phase. It is the responsible class for
 * reading and binding a Schematron resource.
 *
 * @author Philip Helger
 */
@Immutable
public class PSBoundSchemaCacheKey
{
  private final IReadableResource m_aResource;
  private final String m_sPhase;
  private final IPSErrorHandler m_aErrorHandler;
  private final XPathVariableResolver m_aVariableResolver;
  private final XPathFunctionResolver m_aFunctionResolver;
  private final EntityResolver m_aEntityResolver;
  // Status vars
  private transient int m_nHashCode = IHashCodeGenerator.ILLEGAL_HASHCODE;

  public PSBoundSchemaCacheKey (@Nonnull final IReadableResource aResource,
                                @Nullable final String sPhase,
                                @Nullable final IPSErrorHandler aErrorHandler,
                                @Nullable final XPathVariableResolver aVariableResolver,
                                @Nullable final XPathFunctionResolver aFunctionResolver,
                                @Nullable final EntityResolver aEntityResolver)
  {
    ValueEnforcer.notNull (aResource, "Resource");

    m_aResource = aResource;
    m_sPhase = sPhase;
    m_aErrorHandler = aErrorHandler;
    m_aVariableResolver = aVariableResolver;
    m_aFunctionResolver = aFunctionResolver;
    m_aEntityResolver = aEntityResolver;
  }

  /**
   * @return The resource passed in the constructor. Never <code>null</code>.
   */
  @Nonnull
  public final IReadableResource getResource ()
  {
    return m_aResource;
  }

  /**
   * @return The phase selected in the constructor. May be <code>null</code>.
   */
  @Nullable
  public final String getPhase ()
  {
    return m_sPhase;
  }

  /**
   * @return The error handler passed in the constructor. May be
   *         <code>null</code>.
   */
  @Nullable
  public final IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  /**
   * @return The variable resolver to be used. May be <code>null</code>.
   */
  @Nullable
  public final XPathVariableResolver getVariableResolver ()
  {
    return m_aVariableResolver;
  }

  /**
   * @return The function resolver to be used. May be <code>null</code>.
   */
  @Nullable
  public final XPathFunctionResolver getFunctionResolver ()
  {
    return m_aFunctionResolver;
  }

  /**
   * @return The XML entity resolver to be used. May be <code>null</code>.
   */
  @Nullable
  public final EntityResolver getEntityResolver ()
  {
    return m_aEntityResolver;
  }

  /**
   * Read the specified schema from the passed resource.
   *
   * @param aResource
   *        The resource to read from. Never <code>null</code>.
   * @param aErrorHandler
   *        The error handler to use. May be <code>null</code>.
   * @return The read schema. May not be <code>null</code>.
   * @throws SchematronException
   *         In case there is an error reading.
   */
  @Nonnull
  @OverrideOnDemand
  @Deprecated
  public PSSchema readSchema (@Nonnull final IReadableResource aResource,
                              @Nullable final IPSErrorHandler aErrorHandler) throws SchematronException
  {
    return readSchema (aResource, aErrorHandler, (EntityResolver) null);
  }

  /**
   * Read the specified schema from the passed resource.
   *
   * @param aResource
   *        The resource to read from. Never <code>null</code>.
   * @param aErrorHandler
   *        The error handler to use. May be <code>null</code>.
   * @param aEntityResolver
   *        The XML entity resolver to be used. May be <code>null</code>.
   * @return The read schema. May not be <code>null</code>.
   * @throws SchematronException
   *         In case there is an error reading.
   */
  @Nonnull
  @OverrideOnDemand
  public PSSchema readSchema (@Nonnull final IReadableResource aResource,
                              @Nullable final IPSErrorHandler aErrorHandler,
                              @Nullable final EntityResolver aEntityResolver) throws SchematronException
  {
    return new PSReader (aResource, aErrorHandler, aEntityResolver).readSchema ();
  }

  /**
   * Determine the query binding for the read schema.
   *
   * @param aSchema
   *        The read schema. Never <code>null</code>.
   * @return The query binding to use. Never <code>null</code>.
   * @throws SchematronException
   *         In case the determination fails.
   */
  @Nonnull
  @OverrideOnDemand
  public IPSQueryBinding getQueryBinding (@Nonnull final PSSchema aSchema) throws SchematronException
  {
    return PSQueryBindingRegistry.getQueryBindingOfNameOrThrow (aSchema.getQueryBinding ());
  }

  /**
   * Create the pre-processor to be used for
   * {@link #createPreprocessedSchema(PSSchema, IPSQueryBinding)}.
   *
   * @param aQueryBinding
   *        The query binding to be determined from the read schema. Never
   *        <code>null</code>.
   * @return The pre-processor to be used.
   */
  @Nonnull
  @OverrideOnDemand
  public PSPreprocessor createPreprocessor (@Nonnull final IPSQueryBinding aQueryBinding)
  {
    final PSPreprocessor aPreprocessor = PSPreprocessor.createPreprocessorWithoutInformationLoss (aQueryBinding);
    return aPreprocessor;
  }

  /**
   * Pre-process the read schema, using the determined query binding.
   *
   * @param aSchema
   *        The read schema. Never <code>null</code>.
   * @param aQueryBinding
   *        The determined query binding. Never <code>null</code>.
   * @return The pre-processed schema and never <code>null</code>.
   * @throws SchematronException
   *         In case pre-processing fails
   */
  @Nonnull
  @OverrideOnDemand
  public PSSchema createPreprocessedSchema (@Nonnull final PSSchema aSchema,
                                            @Nonnull final IPSQueryBinding aQueryBinding) throws SchematronException
  {
    final PSPreprocessor aPreprocessor = createPreprocessor (aQueryBinding);
    final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);
    if (aPreprocessedSchema == null)
      throw new SchematronPreprocessException ("Failed to preprocess schema " +
                                               aSchema +
                                               " with query binding " +
                                               aQueryBinding);
    return aPreprocessedSchema;
  }

  /**
   * The main routine to create a bound schema from the passed resource and
   * phase. The usual routine is to
   * <ol>
   * <li>read the schema from the resource - see
   * {@link #readSchema(IReadableResource, IPSErrorHandler)}</li>
   * <li>resolve the query binding - see {@link #getQueryBinding(PSSchema)}</li>
   * <li>pre-process the schema -
   * {@link #createPreprocessedSchema(PSSchema, IPSQueryBinding)}</li>
   * <li>and finally bind it -
   * {@link IPSQueryBinding#bind(PSSchema, String, IPSErrorHandler, javax.xml.xpath.XPathVariableResolver, javax.xml.xpath.XPathFunctionResolver)}
   * </li>
   * </ol>
   *
   * @return The bound schema. Never <code>null</code>.
   * @throws SchematronException
   *         In case reading or binding fails.
   */
  @Nonnull
  public IPSBoundSchema createBoundSchema () throws SchematronException
  {
    // Read schema from resource
    final PSSchema aSchema = readSchema (getResource (), getErrorHandler (), getEntityResolver ());

    // Resolve the query binding to be used
    final IPSQueryBinding aQueryBinding = getQueryBinding (aSchema);

    // Pre-process schema
    final PSSchema aPreprocessedSchema = createPreprocessedSchema (aSchema, aQueryBinding);

    // And finally bind the pre-processed schema
    return aQueryBinding.bind (aPreprocessedSchema,
                               getPhase (),
                               getErrorHandler (),
                               getVariableResolver (),
                               getFunctionResolver ());
  }

  @Override
  public boolean equals (final Object o)
  {
    if (o == this)
      return true;
    if (o == null || !getClass ().equals (o.getClass ()))
      return false;
    final PSBoundSchemaCacheKey rhs = (PSBoundSchemaCacheKey) o;
    return m_aResource.equals (rhs.m_aResource) &&
           EqualsHelper.equals (m_sPhase, rhs.m_sPhase) &&
           EqualsHelper.equals (m_aVariableResolver, rhs.m_aVariableResolver) &&
           EqualsHelper.equals (m_aFunctionResolver, rhs.m_aFunctionResolver);
  }

  @Override
  public int hashCode ()
  {
    int ret = m_nHashCode;
    if (ret == IHashCodeGenerator.ILLEGAL_HASHCODE)
      ret = m_nHashCode = new HashCodeGenerator (this).append (m_aResource)
                                                      .append (m_sPhase)
                                                      .append (m_aVariableResolver)
                                                      .append (m_aFunctionResolver)
                                                      .getHashCode ();
    return ret;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("resource", m_aResource)
                                       .append ("phase", m_sPhase)
                                       .appendIfNotNull ("errorHandler", m_aErrorHandler)
                                       .appendIfNotNull ("variableResolver", m_aVariableResolver)
                                       .appendIfNotNull ("functionResolver", m_aFunctionResolver)
                                       .toString ();
  }
}
