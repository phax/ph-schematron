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

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

import javax.xml.transform.Source;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.builder.IBuilder;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.io.iface.IHasInputStream;
import com.helger.base.location.SimpleLocation;
import com.helger.base.state.EValidity;
import com.helger.base.string.StringHelper;
import com.helger.diagnostics.error.SingleError;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.AbstractMemoryReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.CSchematron;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.SchematronException;
import com.helger.schematron.api.telemetry.CSchematronTelemetry;
import com.helger.schematron.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.exchange.PSWriter;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.bound.PSBoundSchemaCache;
import com.helger.schematron.pure.bound.PSBoundSchemaCacheKey;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.validation.telemetry.TelemetryValidationHandler;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.telemetry.ETelemetrySpanKind;
import com.helger.telemetry.ITelemetrySpan;
import com.helger.telemetry.Telemetry;
import com.helger.xml.serialize.read.SAXReaderFactory;
import com.helger.xml.serialize.write.XMLWriterSettings;
import com.helger.xml.transform.TransformSourceFactory;

import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmNode;

/**
 * Canonical name for the pure-Java XPath-driven Schematron engine, introduced in v10.0.0. This
 * class itself is not thread safe, but the underlying cache is thread safe. So once you have
 * configured this object fully (via the setters), it can be considered thread safe.<br>
 * <b>Important:</b> This class can only handle XPath expressions but no XSLT functions in
 * Schematron asserts and reports! If your Schematrons use XSLT functionality you're better off
 * using the {@code com.helger.schematron.sch.SchematronResourceSCH} or
 * {@code com.helger.schematron.purexslt.SchematronResourcePureXslt} classes instead.
 * <p>
 * The pre-v10 name <code>SchematronResourcePure</code> is preserved as a deprecated
 * source-compatible subclass for callers that already use it.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public class SchematronResourcePureXPath extends AbstractSchematronResource
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourcePureXPath.class);

  private String m_sPhase;
  private IPSErrorHandler m_aErrorHandler;
  private IPSValidationHandler m_aCustomValidationHandler;
  private IXPathConfig m_aXPathConfig = XPathConfigBuilder.DEFAULT;
  private boolean m_bPerRuleExecutionTelemetry = false;
  // Status var
  private IPSBoundSchema m_aBoundSchema;

  @Deprecated (since = "10.0.0", forRemoval = false)
  public SchematronResourcePureXPath (@NonNull final IReadableResource aResource)
  {
    super (aResource);
  }

  @Deprecated (since = "10.0.0", forRemoval = false)
  public SchematronResourcePureXPath (@NonNull final IReadableResource aResource,
                                      @Nullable final String sPhase,
                                      @Nullable final IPSErrorHandler aErrorHandler)
  {
    super (aResource);
    setPhase (sPhase);
    setErrorHandler (aErrorHandler);
  }

  /**
   * Builder-based constructor. Applies all configurable state from the supplied {@link Builder} to
   * the newly-constructed resource. Invoked by {@link Builder#build()}.
   *
   * @param aBuilder
   *        The configured builder. May not be <code>null</code>.
   */
  protected SchematronResourcePureXPath (@NonNull final Builder aBuilder)
  {
    super (aBuilder.m_aResource,
           aBuilder.m_bUseCache,
           aBuilder.m_bLenient,
           aBuilder.m_bEntityResolverSet ? aBuilder.m_aEntityResolver : null,
           aBuilder.m_bUseTelemetry,
           aBuilder.m_bPerAssertionResultTelemetry);
    m_sPhase = aBuilder.m_sPhase;
    m_aErrorHandler = aBuilder.m_aErrorHandler;
    m_aCustomValidationHandler = aBuilder.m_aCustomValidationHandler;
    m_aXPathConfig = aBuilder.m_aXPathConfig;
    m_bPerRuleExecutionTelemetry = aBuilder.m_bPerRuleExecutionTelemetry;
  }

  /**
   * @return The phase to be used. May be <code>null</code>.
   */
  @Nullable
  public final String getPhase ()
  {
    return m_sPhase;
  }

  /**
   * Set the Schematron phase to be evaluated. Changing the phase will result in a newly bound
   * schema!
   *
   * @param sPhase
   *        The name of the phase to use. May be <code>null</code> which means all phases.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public SchematronResourcePureXPath setPhase (@Nullable final String sPhase)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_sPhase = sPhase;
    return this;
  }

  /**
   * @return The error handler to be used to bind the schema. May be <code>null</code>.
   */
  @Nullable
  public final IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  /**
   * Set the error handler to be used during binding.
   *
   * @param aErrorHandler
   *        The error handler. May be <code>null</code>.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public SchematronResourcePureXPath setErrorHandler (@Nullable final IPSErrorHandler aErrorHandler)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aErrorHandler = aErrorHandler;
    return this;
  }

  /**
   * @return The custom validation handler to be used to bind the schema. May be <code>null</code>.
   * @since 5.3.0
   */
  @Nullable
  public final IPSValidationHandler getCustomValidationHandler ()
  {
    return m_aCustomValidationHandler;
  }

  /**
   * Set the custom validation handler to be used during binding.
   *
   * @param aCustomValidationHandler
   *        The validation handler. May be <code>null</code>.
   * @return this
   * @since 5.3.0
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public SchematronResourcePureXPath setCustomValidationHandler (@Nullable final IPSValidationHandler aCustomValidationHandler)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aCustomValidationHandler = aCustomValidationHandler;
    return this;
  }

  /**
   * @return The contained {@link IXPathConfig}. Never <code>null</code>.
   * @since 8.0.0
   */
  @NonNull
  public final IXPathConfig getXPathConfig ()
  {
    return m_aXPathConfig;
  }

  /**
   * Set the {@link XPathConfig} to be used in the XPath statements. This can only be set before the
   * Schematron is bound. If it is already bound an exception is thrown to indicate the unnecessity
   * of the call.
   *
   * @param aXPathConfig
   *        The XPath config to set. May be <code>null</code>.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public SchematronResourcePureXPath setXPathConfig (@NonNull final IXPathConfig aXPathConfig)
  {
    ValueEnforcer.notNull (aXPathConfig, "XPathConfig");
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aXPathConfig = aXPathConfig;
    return this;
  }

  /**
   * @return <code>true</code> if per-rule execution timing histograms
   *         ({@code schematron.rule.duration}, {@code schematron.context.duration},
   *         {@code schematron.assert.duration}) are recorded to find the most expensive rules. Only
   *         meaningful when {@link #isTelemetry()} is also <code>true</code>. Default is
   *         <code>false</code>.
   * @since 10.0.0
   */
  public final boolean isPerRuleExecutionTelemetry ()
  {
    return m_bPerRuleExecutionTelemetry;
  }

  /**
   * Set the XML entity resolver to be used when reading the Schematron or the XML to be validated.
   * This can only be set before the Schematron is bound. If it is already bound an exception is
   * thrown to indicate the unnecessity of the call.
   *
   * @param aEntityResolver
   *        The entity resolver to set. May be <code>null</code>.
   * @return this
   * @since 4.1.1
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public SchematronResourcePureXPath setEntityResolver (@Nullable final EntityResolver aEntityResolver)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    internalSetEntityResolver (aEntityResolver);
    return this;
  }

  @NonNull
  private Document _buildSaxonDocument (@NonNull final Source aSource) throws SaxonApiException
  {
    final DocumentBuilder aBuilder = m_aXPathConfig.getProcessor ().newDocumentBuilder ();
    final String sSystemId = aSource.getSystemId ();
    if (StringHelper.isNotEmpty (sSystemId))
      try
      {
        aBuilder.setBaseURI (new URI (sSystemId));
      }
      catch (final Exception ex)
      {
        // Not a valid URI - skip; Saxon will fall back to whatever the Source carries
      }

    // Bridge through a hardened XMLReader so Saxon's TinyTree fast path inherits XXE protection.
    // StreamSource is the only Source flavour that Saxon parses itself - SAXSource carries its
    // own XMLReader, DOMSource / StAXSource walk a pre-built tree (no parsing).
    final Source aSafeSource;
    if (aSource instanceof final StreamSource aStreamSrc)
    {
      final XMLReader aXMLReader = SAXReaderFactory.createXMLReader ();

      final InputSource aInputSrc;
      if (aStreamSrc.getInputStream () != null)
        aInputSrc = new InputSource (aStreamSrc.getInputStream ());
      else
        if (aStreamSrc.getReader () != null)
          aInputSrc = new InputSource (aStreamSrc.getReader ());
        else
          aInputSrc = new InputSource (aStreamSrc.getSystemId ());

      if (StringHelper.isNotEmpty (aStreamSrc.getSystemId ()))
        aInputSrc.setSystemId (aStreamSrc.getSystemId ());
      if (StringHelper.isNotEmpty (aStreamSrc.getPublicId ()))
        aInputSrc.setPublicId (aStreamSrc.getPublicId ());

      final SAXSource aSAXSrc = new SAXSource (aXMLReader, aInputSrc);
      if (StringHelper.isNotEmpty (aStreamSrc.getSystemId ()))
        aSAXSrc.setSystemId (aStreamSrc.getSystemId ());

      aSafeSource = aSAXSrc;
    }
    else
    {
      // Non-StreamSource - parsing is the caller's responsibility (or there is none).
      aSafeSource = aSource;
    }

    final XdmNode aXdm = aBuilder.build (aSafeSource);
    final Node aDom = NodeOverNodeInfo.wrap (aXdm.getUnderlyingNode ());
    if (aDom instanceof final Document aDoc)
      return aDoc;

    throw new IllegalStateException ("Saxon DocumentBuilder did not return a document NodeInfo: " + aDom);
  }

  /**
   * Read the XML through Saxon's {@link DocumentBuilder} and present it as a DOM facade over the
   * resulting TinyTree. Downstream {@code validate(...)} detects the facade and skips the slower
   * {@code DocumentWrapper} bridge, giving a significant speed-up for large inputs.
   * <p>
   * The TinyTree fast path is skipped when a custom XML entity resolver is configured — in that
   * case the default DOM parsing path (which honours the resolver) is used instead.
   * </p>
   */
  @Override
  @Nullable
  protected NodeAndBaseURI getAsNode (@NonNull final IHasInputStream aXMLResource) throws Exception
  {
    if (getEntityResolver () != null)
    {
      // Defer to the DOM-based default so the entity resolver is honoured
      return super.getAsNode (aXMLResource);
    }

    final StreamSource aStreamSrc = TransformSourceFactory.create (aXMLResource);
    InputStream aIS = null;
    try
    {
      aIS = aStreamSrc.getInputStream ();
    }
    catch (final IllegalStateException ex)
    {
      // Happens e.g. for non-existing resources - fall through
    }
    if (aIS == null)
    {
      LOGGER.warn ("XML resource " + aXMLResource + " does not exist!");
      return null;
    }

    final String sBaseURI = aStreamSrc.getSystemId ();
    final StreamSource aSrcWithURI = new StreamSource (aIS, sBaseURI);
    final Document aDoc = _buildSaxonDocument (aSrcWithURI);
    LOGGER.info ("Read XML resource " + aXMLResource + " into Saxon TinyTree");
    return new NodeAndBaseURI (aDoc, sBaseURI);
  }

  /**
   * Read a {@link Source} through Saxon's {@link DocumentBuilder} and present it as a DOM facade
   * over the resulting TinyTree. The TinyTree fast path is skipped when a custom XML entity
   * resolver is configured.
   */
  @Override
  @Nullable
  protected Node getAsNode (@NonNull final Source aXMLSource) throws Exception
  {
    if (getEntityResolver () != null)
    {
      // Defer to the DOM-based default so the entity resolver is honoured
      return super.getAsNode (aXMLSource);
    }
    return _buildSaxonDocument (aXMLSource);
  }

  /**
   * @return The effective validation handler used during binding. Equal to
   *         {@link #getCustomValidationHandler()} unless {@link #setTelemetry(boolean) telemetry}
   *         is enabled, in which case a {@link TelemetryValidationHandler} is chained in.
   */
  @Nullable
  private IPSValidationHandler _resolveEffectiveValidationHandler ()
  {
    if (!isTelemetry ())
      return m_aCustomValidationHandler;

    final TelemetryValidationHandler aTelemetry = new TelemetryValidationHandler (ESchematronEngine.PURE_XPATH,
                                                                                  isPerAssertionResultTelemetry (),
                                                                                  m_bPerRuleExecutionTelemetry);
    // Null-safe combine: m_aCustomValidationHandler may be null when telemetry is enabled on its
    // own
    return IPSValidationHandler.and (m_aCustomValidationHandler, aTelemetry);
  }

  @NonNull
  protected IPSBoundSchema createBoundSchema ()
  {
    final IReadableResource aResource = getResource ();
    final PSBoundSchemaCacheKey aCacheKey = new PSBoundSchemaCacheKey (aResource,
                                                                       m_sPhase,
                                                                       m_aErrorHandler,
                                                                       _resolveEffectiveValidationHandler (),
                                                                       m_aXPathConfig,
                                                                       getEntityResolver (),
                                                                       isLenient ());
    if (aResource instanceof AbstractMemoryReadableResource || !isUseCache ())
    {
      // No need to cache anything for memory resources
      try
      {
        return aCacheKey.createBoundSchema ();
      }
      catch (final SchematronException ex)
      {
        // Convert to runtime exception
        throw new IllegalStateException ("Failed to bind Schematron", ex);
      }
    }

    // Resolve from cache - inside the cacheKey the reading and binding
    // happens
    return PSBoundSchemaCache.getInstance ().getFromCache (aCacheKey);
  }

  /**
   * Get the cached bound schema or create a new one.
   *
   * @return The bound schema. Never <code>null</code>.
   */
  @NonNull
  public IPSBoundSchema getOrCreateBoundSchema ()
  {
    // Always caching
    if (m_aBoundSchema == null)
      try
      {
        m_aBoundSchema = createBoundSchema ();
      }
      catch (final RuntimeException ex)
      {
        if (m_aErrorHandler != null)
        {
          m_aErrorHandler.handleError (SingleError.builderError ()
                                                  .errorLocation (new SimpleLocation (getResource ().getPath ()))
                                                  .errorText ("Error creating bound schema")
                                                  .linkedException (ex)
                                                  .build ());
        }
        throw ex;
      }

    return m_aBoundSchema;
  }

  /**
   * @return A {@link SchematronPureXPathConfig} snapshot of this resource's compile-time state.
   *         Runtime-only fields (telemetry toggles) are intentionally not propagated.
   * @since 10.0.0
   */
  @NonNull
  public final SchematronPureXPathConfig toConfig ()
  {
    return SchematronPureXPathConfig.builder (getResource ())
                                    .phase (m_sPhase)
                                    .errorHandler (m_aErrorHandler)
                                    .customValidationHandler (m_aCustomValidationHandler)
                                    .xpathConfig (m_aXPathConfig)
                                    .entityResolver (getEntityResolver ())
                                    .lenient (isLenient ())
                                    .build ();
  }

  public boolean isValidSchematron ()
  {
    // Use the provided error handler (if any)
    try
    {
      final IPSErrorHandler aErrorHandler = m_aErrorHandler != null ? m_aErrorHandler : new DoNothingPSErrorHandler ();
      return getOrCreateBoundSchema ().getOriginalSchema ().isValid (aErrorHandler);
    }
    catch (final RuntimeException ex)
    {
      // May happen when XPath errors are contained
      return false;
    }
  }

  /**
   * Use the internal error handler to validate all elements in the schematron. It tries to catch as
   * many errors as possible.
   */
  public void validateCompletely ()
  {
    // Use the provided error handler (if any)
    final IPSErrorHandler aErrorHandler = m_aErrorHandler != null ? m_aErrorHandler : new DoNothingPSErrorHandler ();
    validateCompletely (aErrorHandler);
  }

  /**
   * Use the provided error handler to validate all elements in the schematron. It tries to catch as
   * many errors as possible.
   *
   * @param aErrorHandler
   *        The error handler to use. May not be <code>null</code>.
   */
  public void validateCompletely (@NonNull final IPSErrorHandler aErrorHandler)
  {
    ValueEnforcer.notNull (aErrorHandler, "ErrorHandler");

    try
    {
      getOrCreateBoundSchema ().getOriginalSchema ().validateCompletely (aErrorHandler);
    }
    catch (final RuntimeException ex)
    {
      // May happen when XPath errors are contained
    }
  }

  @NonNull
  public EValidity getSchematronValidity (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                         throws SchematronException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    if (!isValidSchematron ())
      return EValidity.INVALID;

    return getOrCreateBoundSchema ().validatePartially (aXMLNode, sBaseURI);
  }

  /**
   * The main method to convert a node to an SVRL document.
   *
   * @param aXMLNode
   *        The source node to be validated. May not be <code>null</code>.
   * @param sBaseURI
   *        Base URI of the XML document to be validated. May be <code>null</code>.
   * @return The SVRL document. Never <code>null</code>.
   * @throws SchematronException
   *         in case of a sever error validating the schema
   */
  @NonNull
  public SchematronOutputType applySchematronValidationToSVRL (@NonNull final Node aXMLNode,
                                                               @Nullable final String sBaseURI) throws SchematronException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    final SchematronOutputType aSOT;
    if (isTelemetry ())
    {
      // Tracing span wraps the whole validation; the chained TelemetryValidationHandler emits the
      // counters and (optionally) per-assert child spans.
      final var aBound = getOrCreateBoundSchema ();
      try (final ITelemetrySpan aSpan = Telemetry.startSpan (CSchematronTelemetry.SPAN_VALIDATE,
                                                             ETelemetrySpanKind.INTERNAL))
      {
        aSpan.setAttribute (CSchematronTelemetry.ATTR_ENGINE, ESchematronEngine.PURE_XPATH.getID ());
        if (StringHelper.isNotEmpty (m_sPhase))
          aSpan.setAttribute (CSchematronTelemetry.ATTR_PHASE, m_sPhase);

        try
        {
          aSOT = aBound.validateComplete (aXMLNode, sBaseURI);
          aSpan.setStatusOk ();
        }
        catch (final SchematronException ex)
        {
          aSpan.recordException (ex).setStatusError (ex.getMessage ());
          throw ex;
        }
      }
    }
    else
    {
      aSOT = getOrCreateBoundSchema ().validateComplete (aXMLNode, sBaseURI);
    }

    // Debug print the created SVRL document
    if (SchematronDebug.isShowCreatedSVRL ())
      LOGGER.info ("Created SVRL:\n" + new SVRLMarshaller ().setUseSchema (false).getAsString (aSOT));

    return aSOT;
  }

  @Nullable
  public Document applySchematronValidation (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                            throws SchematronException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    final SchematronOutputType aSO = applySchematronValidationToSVRL (aXMLNode, sBaseURI);
    return new SVRLMarshaller ().getAsDocument (aSO);
  }

  // === Builder factories ===

  /**
   * @param aResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return A new {@link Builder} that produces a configured {@link SchematronResourcePureXPath}.
   *         Never <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aResource)
  {
    return new Builder (aResource);
  }

  /**
   * @param sSCHPath
   *        The classpath relative path to the Schematron rules. May neither be <code>null</code>
   *        nor empty.
   * @return A new {@link Builder} reading the Schematron from the default classloader. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new Builder (new ClassPathResource (sSCHPath));
  }

  /**
   * @param sSCHPath
   *        The classpath relative path to the Schematron rules. May neither be <code>null</code>
   *        nor empty.
   * @param aClassLoader
   *        The class loader to be used to retrieve the classpath resource. May be
   *        <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given classloader. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromClassPath (@NonNull @Nonempty final String sSCHPath,
                                              @Nullable final ClassLoader aClassLoader)
  {
    return new Builder (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * @param sSCHPath
   *        The file system path to the Schematron rules. May neither be <code>null</code> nor
   *        empty.
   * @return A new {@link Builder} reading the Schematron from the file system. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return new Builder (new FileSystemResource (sSCHPath));
  }

  /**
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given file. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromFile (@NonNull final File aSCHFile)
  {
    return new Builder (new FileSystemResource (aSCHFile));
  }

  /**
   * @param sSCHURL
   *        The URL to the Schematron rules. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the Schematron from the given URL. Never
   *         <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new Builder (new URLResource (sSCHURL));
  }

  /**
   * @param aSCHURL
   *        The URL to the Schematron rules. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given URL. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromURL (@NonNull final URL aSCHURL)
  {
    return new Builder (new URLResource (aSCHURL));
  }

  /**
   * @param sResourceID
   *        Resource ID to be used as the cache key. Should neither be <code>null</code> nor empty.
   * @param aSchematronIS
   *        The {@link InputStream} to read the Schematron rules from. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given input stream. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromInputStream (@NonNull @Nonempty final String sResourceID,
                                                @NonNull final InputStream aSchematronIS)
  {
    return new Builder (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  /**
   * @param aSchematron
   *        The byte array representing the Schematron. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given byte array. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromByteArray (@NonNull final byte [] aSchematron)
  {
    return new Builder (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * @param sSchematron
   *        The String representing the Schematron. May not be <code>null</code>.
   * @param aCharset
   *        The charset used to encode the string to bytes. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the encoded string bytes. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromString (@NonNull final String sSchematron, @NonNull final Charset aCharset)
  {
    return builderFromByteArray (sSchematron.getBytes (aCharset));
  }

  /**
   * @param sSchematron
   *        The String representing the Schematron. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the encoded string bytes. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromString (@NonNull final String sSchematron)
  {
    return builderFromString (sSchematron, StandardCharsets.UTF_8);
  }

  // === Eager-compile shortcuts ===

  /**
   * Convenience: equivalent to {@code builder(aResource).buildCached()}.
   *
   * @param aResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return The fully compiled resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourcePureXPath compileCached (@NonNull final IReadableResource aResource) throws SchematronException
  {
    return builder (aResource).buildCached ();
  }

  /**
   * Convenience: equivalent to {@code builder(aResource).buildCached(aCache)}.
   *
   * @param aResource
   *        The Schematron resource. May not be <code>null</code>.
   * @param aCache
   *        The cache instance to use. May not be <code>null</code>.
   * @return The fully compiled resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourcePureXPath compileCached (@NonNull final IReadableResource aResource,
                                                           @NonNull final SchematronPureXPathCache aCache) throws SchematronException
  {
    return builder (aResource).buildCached (aCache);
  }

  /**
   * Convenience: equivalent to {@code builder(aResource).buildUncached()}.
   *
   * @param aResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return The configured resource. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   * @since 10.0.0
   */
  @NonNull
  public static SchematronResourcePureXPath compileUncached (@NonNull final IReadableResource aResource) throws SchematronException
  {
    return builder (aResource).buildUncached ();
  }

  /**
   * @param aSchematron
   *        The Schematron model to be used. May not be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the serialized domain model. Never
   *         <code>null</code>.
   * @since 10.0.0
   */
  @NonNull
  public static Builder builderFromSchema (@NonNull final PSSchema aSchematron)
  {
    return builderFromString (new PSWriter ().getXMLString (aSchematron), XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from a Classpath Schematron rules
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron rules.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromClassPath(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePureXPath (new ClassPathResource (sSCHPath));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from a Classpath Schematron rules
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron rules.
   * @param aClassLoader
   *        The class loader to be used to retrieve the classpath resource. May be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.0.4
   * @deprecated since 10.0.0 — use {@link #builderFromClassPath(String, ClassLoader)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromClassPath (@NonNull @Nonempty final String sSCHPath,
                                                           @Nullable final ClassLoader aClassLoader)
  {
    return new SchematronResourcePureXPath (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from file system Schematron rules
   *
   * @param sSCHPath
   *        The file system path to the Schematron rules.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromFile(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePureXPath (new FileSystemResource (sSCHPath));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from file system Schematron rules
   *
   * @param aSCHFile
   *        The file system path to the Schematron rules.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromFile(File)} instead. Will remain for backward
   *             compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromFile (@NonNull final File aSCHFile)
  {
    return new SchematronResourcePureXPath (new FileSystemResource (aSCHFile));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from Schematron rules provided at a URL
   *
   * @param sSCHURL
   *        The URL to the Schematron rules. May neither be <code>null</code> nor empty.
   * @return Never <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   * @deprecated since 10.0.0 — use {@link #builderFromURL(String)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourcePureXPath (new URLResource (sSCHURL));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from Schematron rules provided at a URL
   *
   * @param aSCHURL
   *        The URL to the Schematron rules. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromURL(URL)} instead. Will remain for backward
   *             compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromURL (@NonNull final URL aSCHURL)
  {
    return new SchematronResourcePureXPath (new URLResource (aSCHURL));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from Schematron rules provided by an arbitrary
   * {@link InputStream}.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param sResourceID
   *        Resource ID to be used as the cache key. Should neither be <code>null</code> nor empty.
   * @param aSchematronIS
   *        The {@link InputStream} to read the Schematron rules from. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.5
   * @deprecated since 10.0.0 — use {@link #builderFromInputStream(String, InputStream)} instead.
   *             Will remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromInputStream (@NonNull @Nonempty final String sResourceID,
                                                             @NonNull final InputStream aSchematronIS)
  {
    return new SchematronResourcePureXPath (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from Schematron rules provided by an arbitrary
   * byte array.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param aSchematron
   *        The byte array representing the Schematron. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromByteArray(byte[])} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromByteArray (@NonNull final byte [] aSchematron)
  {
    return new SchematronResourcePureXPath (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from Schematron rules provided by an arbitrary
   * String.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param sSchematron
   *        The String representing the Schematron. May not be <code>null</code> .
   * @param aCharset
   *        The charset to be used to convert the String to a byte array.
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromString(String, Charset)} instead. Will remain
   *             for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromString (@NonNull final String sSchematron,
                                                        @NonNull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }

  /**
   * Create a new {@link SchematronResourcePureXPath} from Schematron rules provided by a domain
   * model.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param aSchematron
   *        The Schematron model to be used. May not be <code>null</code> .
   * @return Never <code>null</code>.
   * @deprecated since 10.0.0 — use {@link #builderFromSchema(PSSchema)} instead. Will remain for
   *             backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public static SchematronResourcePureXPath fromSchema (@NonNull final PSSchema aSchematron)
  {
    return fromString (new PSWriter ().getXMLString (aSchematron), XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
  }

  // === Builder ===

  /**
   * Fluent builder for {@link SchematronResourcePureXPath}. Not thread-safe.
   *
   * @since 10.0.0
   */
  @NotThreadSafe
  public static final class Builder implements IBuilder <SchematronResourcePureXPath>
  {
    private final IReadableResource m_aResource;
    private boolean m_bUseCache = AbstractSchematronResource.DEFAULT_USE_CACHE;
    private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;
    private EntityResolver m_aEntityResolver;
    private boolean m_bEntityResolverSet;
    private String m_sPhase;
    private IPSErrorHandler m_aErrorHandler;
    private IPSValidationHandler m_aCustomValidationHandler;
    private IXPathConfig m_aXPathConfig = XPathConfigBuilder.DEFAULT;
    private boolean m_bUseTelemetry;
    private boolean m_bPerAssertionResultTelemetry;
    private boolean m_bPerRuleExecutionTelemetry;

    Builder (@NonNull final IReadableResource aResource)
    {
      ValueEnforcer.notNull (aResource, "Resource");
      m_aResource = aResource;
    }

    /**
     * @param b
     *        <code>true</code> to participate in the bound-schema cache, <code>false</code> to
     *        bypass it. Default is {@link AbstractSchematronResource#DEFAULT_USE_CACHE}.
     * @return this for chaining
     */
    @NonNull
    public Builder useCache (final boolean b)
    {
      m_bUseCache = b;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to allow deprecated Schematron namespaces, <code>false</code> for
     *        strict mode.
     * @return this for chaining
     */
    @NonNull
    public Builder lenient (final boolean b)
    {
      m_bLenient = b;
      return this;
    }

    /**
     * @param a
     *        The XML entity resolver, or <code>null</code> to disable entity resolution. Replaces
     *        the resource-derived default.
     * @return this for chaining
     */
    @NonNull
    public Builder entityResolver (@Nullable final EntityResolver a)
    {
      m_aEntityResolver = a;
      m_bEntityResolverSet = true;
      return this;
    }

    /**
     * @param s
     *        The Schematron phase to use, or <code>null</code> for the default phase.
     * @return this for chaining
     */
    @NonNull
    public Builder phase (@Nullable final String s)
    {
      m_sPhase = s;
      return this;
    }

    /**
     * @param a
     *        The Schematron error handler, or <code>null</code> for the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder errorHandler (@Nullable final IPSErrorHandler a)
    {
      m_aErrorHandler = a;
      return this;
    }

    /**
     * @param a
     *        The custom validation handler invoked during validation, or <code>null</code> for
     *        none.
     * @return this for chaining
     */
    @NonNull
    public Builder customValidationHandler (@Nullable final IPSValidationHandler a)
    {
      m_aCustomValidationHandler = a;
      return this;
    }

    /**
     * @param a
     *        The XPath configuration. May not be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder xpathConfig (@NonNull final IXPathConfig a)
    {
      ValueEnforcer.notNull (a, "XPathConfig");
      m_aXPathConfig = a;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to enable aggregate-level telemetry, <code>false</code> to disable.
     * @return this for chaining
     */
    @NonNull
    public Builder telemetry (final boolean b)
    {
      m_bUseTelemetry = b;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to emit a {@code schematron.assertion} span per failed-assert /
     *        successful-report (post-evaluation findings). Only meaningful when
     *        {@link #telemetry(boolean)} is also <code>true</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder perAssertionResultTelemetry (final boolean b)
    {
      m_bPerAssertionResultTelemetry = b;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to record per-rule execution timing histograms
     *        ({@code schematron.rule.duration}, {@code schematron.context.duration},
     *        {@code schematron.assert.duration}) for ranking the most expensive rules. Only
     *        meaningful when {@link #telemetry(boolean)} is also <code>true</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder perRuleExecutionTelemetry (final boolean b)
    {
      m_bPerRuleExecutionTelemetry = b;
      return this;
    }

    /**
     * @return A new {@link SchematronResourcePureXPath} configured with the values of this builder.
     *         Never <code>null</code>.
     */
    @NonNull
    public SchematronResourcePureXPath build ()
    {
      return new SchematronResourcePureXPath (this);
    }

    /**
     * Build the resource and eagerly compile via the {@link SchematronPureXPathCache#shared()
     * shared cache}. Pre-warms the cache for any subsequent caller with the same config and
     * surfaces compilation failures as {@link SchematronException} rather than letting them appear
     * lazily on first validation.
     *
     * @return The fully compiled resource. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     * @since 10.0.0
     */
    @NonNull
    public SchematronResourcePureXPath buildCached () throws SchematronException
    {
      useCache (true);
      final SchematronResourcePureXPath ret = build ();
      SchematronPureXPathCache.shared ().getOrCompile (ret.toConfig ());
      return ret;
    }

    /**
     * Build the resource and eagerly compile via the supplied cache.
     *
     * @param aCache
     *        The cache instance to use. May not be <code>null</code>.
     * @return The fully compiled resource. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     * @since 10.0.0
     */
    @NonNull
    public SchematronResourcePureXPath buildCached (@NonNull final SchematronPureXPathCache aCache) throws SchematronException
    {
      ValueEnforcer.notNull (aCache, "Cache");
      useCache (true);
      final SchematronResourcePureXPath ret = build ();
      aCache.getOrCompile (ret.toConfig ());
      return ret;
    }

    /**
     * Build the resource and eagerly compile without using any cache. The validation result is
     * discarded; subsequent validation calls will recompile per the resource's lazy-compile
     * semantics. Useful as a fail-fast verification at construction time.
     *
     * @return The configured resource. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     * @since 10.0.0
     */
    @NonNull
    public SchematronResourcePureXPath buildUncached () throws SchematronException
    {
      useCache (false);
      final SchematronResourcePureXPath ret = build ();
      ret.toConfig ().compile ();
      return ret;
    }
  }
}
