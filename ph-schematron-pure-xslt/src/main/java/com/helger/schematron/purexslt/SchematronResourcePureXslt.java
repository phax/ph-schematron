/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.CGlobal;
import com.helger.base.builder.IBuilder;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.functional.IThrowingSupplier;
import com.helger.base.state.EValidity;
import com.helger.base.timing.StopWatch;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.SchematronException;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.exchange.SchematronReadException;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.preprocess.PSPreprocessor;
import com.helger.schematron.purexslt.binding.PureXsltQueryBindingTransform;
import com.helger.schematron.purexslt.telemetry.PureXsltTelemetry;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;
import com.helger.schematron.purexslt.xslt.PureXsltStylesheetGenerator;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.telemetry.ETelemetrySpanKind;
import com.helger.telemetry.ITelemetrySpan;
import com.helger.telemetry.Telemetry;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

import net.sf.saxon.lib.ErrorReporterToListener;
import net.sf.saxon.lib.ResourceResolverWrappingURIResolver;
import net.sf.saxon.s9api.DOMDestination;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;

/**
 * A Schematron resource that runs a pure-Java pipeline on top of Saxon s9api. Unlike
 * {@code SchematronResourcePure}, this class is intended to support Schematron schemas that contain
 * XSLT extensions (such as {@code <xsl:function>} or {@code <xsl:include>}) by compiling and
 * executing the schema through Saxon's XSLT engine natively &mdash; without going through the
 * external ISO Schematron XSLT preprocessing chain that {@code SchematronResourceSCH} uses.
 * <p>
 * <b>Supported scope:</b> {@code <sch:ns>}, {@code <sch:pattern>}, {@code <sch:rule>},
 * {@code <sch:assert>}, {@code <sch:report>}, {@code <sch:value-of>}, {@code <sch:name>},
 * {@code <sch:let>} at all four scopes, {@code <sch:phase>} / {@code <sch:active>},
 * {@code <sch:diagnostic>} references, abstract patterns with {@code is-a} parameter substitution,
 * {@code <sch:extends>} on rules and {@code <sch:include>} (the last three expanded by
 * {@link PSPreprocessor} before XSLT generation). XSLT extensions ({@code <xsl:function>},
 * {@code <xsl:include>}, {@code <xsl:key>}, ...) declared at schema level are passed through to the
 * generated stylesheet so Saxon compiles them as-is. Rich text spans ({@code <sch:emph>} /
 * {@code <sch:dir>} / {@code <sch:span>}) and {@code <sch:property>} references are not yet
 * handled.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public class SchematronResourcePureXslt extends AbstractSchematronResource
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourcePureXslt.class);

  /** Default for {@link #setForceCacheResult(boolean)}. */
  public static final boolean DEFAULT_FORCE_CACHE_RESULT = false;

  private final String m_sPhase;
  private IPSErrorHandler m_aErrorHandler = new LoggingPSErrorHandler ();
  private Processor m_aProcessor = new Processor (false);
  private URIResolver m_aURIResolver;
  private ErrorListener m_aErrorListener;
  private EPureXsltVersion m_eXsltVersion = EPureXsltVersion.DEFAULT;
  private boolean m_bTelemetry = false;
  private boolean m_bPerAssertionTelemetry = false;
  private boolean m_bForceCacheResult = DEFAULT_FORCE_CACHE_RESULT;
  // Status vars
  private PSSchema m_aSchema;
  private XsltExecutable m_aCompiledXslt;

  /**
   * Builder-based constructor. Applies all configurable state from the supplied {@link Builder} to
   * the newly-constructed resource. Invoked by {@link Builder#build()}.
   *
   * @param aBuilder
   *        The configured builder. May not be <code>null</code>.
   */
  protected SchematronResourcePureXslt (@NonNull final Builder aBuilder)
  {
    super (aBuilder.m_aResource,
           aBuilder.m_bUseCache,
           aBuilder.m_bLenient,
           aBuilder.m_bEntityResolverSet ? aBuilder.m_aEntityResolver : null);
    m_sPhase = aBuilder.m_sPhase;
    m_aErrorHandler = aBuilder.m_aErrorHandler;
    m_aProcessor = aBuilder.m_aProcessor;
    m_aURIResolver = aBuilder.m_aURIResolver;
    m_aErrorListener = aBuilder.m_aErrorListener;
    m_eXsltVersion = aBuilder.m_eXsltVersion;
    m_bTelemetry = aBuilder.m_bTelemetry;
    m_bPerAssertionTelemetry = aBuilder.m_bPerAssertionTelemetry;
    m_bForceCacheResult = aBuilder.m_bForceCacheResult;
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
   * @return The error handler used during reading. Never <code>null</code>.
   */
  @NonNull
  public final IPSErrorHandler getErrorHandler ()
  {
    return m_aErrorHandler;
  }

  /**
   * Lazily read the Schematron source into a {@link PSSchema}.
   *
   * @return The parsed schema. Never <code>null</code>.
   * @throws SchematronReadException
   *         if the source cannot be read.
   */
  @NonNull
  public final PSSchema getOrReadSchema () throws SchematronReadException
  {
    if (m_aSchema == null)
    {
      final PSReader aReader = new PSReader (getResource (), m_aErrorHandler, getEntityResolver ());
      // Saxon-native engine understands XSLT sequence constructors in <sch:let> bodies
      aReader.setPreserveLetBodyElements (true);
      m_aSchema = aReader.readSchema ();
      if (m_aSchema == null)
        throw new SchematronReadException (getResource (), "Failed to read Schematron from " + getResource ());
    }
    return m_aSchema;
  }

  /**
   * @return The Saxon {@link Processor} used to compile and run the generated XSLT. Never
   *         <code>null</code>.
   */
  @NonNull
  public final Processor getProcessor ()
  {
    return m_aProcessor;
  }

  /**
   * Set a custom Saxon {@link Processor}. Useful e.g. to register extension functions or to share a
   * Processor across multiple Schematron resources.
   *
   * @param aProcessor
   *        The processor. May not be <code>null</code>.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final SchematronResourcePureXslt setProcessor (@NonNull final Processor aProcessor)
  {
    ValueEnforcer.notNull (aProcessor, "Processor");
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_aProcessor = aProcessor;
    return this;
  }

  /**
   * @return The {@link URIResolver} used by Saxon for {@code xsl:include} / {@code xsl:import}
   *         resolution at compile time and {@code document()} / {@code doc()} resolution at run
   *         time. May be <code>null</code>, in which case Saxon's default resolver is used.
   */
  @Nullable
  public final URIResolver getURIResolver ()
  {
    return m_aURIResolver;
  }

  /**
   * Install a custom {@link URIResolver}. Applied to both the {@link XsltCompiler} (so it can
   * resolve href references in any {@code <xsl:include>} / {@code <xsl:import>} passed through from
   * the schema's foreign elements) and the runtime {@code Xslt30Transformer} (so XPath
   * {@code document()} calls in asserts and reports route through it too).
   *
   * @param aURIResolver
   *        The resolver. May be <code>null</code> to clear.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final SchematronResourcePureXslt setURIResolver (@Nullable final URIResolver aURIResolver)
  {
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_aURIResolver = aURIResolver;
    return this;
  }

  /**
   * @return The JAXP {@link ErrorListener} used by Saxon during stylesheet compilation. May be
   *         <code>null</code>, in which case Saxon's default reporter is used.
   */
  @Nullable
  public final ErrorListener getErrorListener ()
  {
    return m_aErrorListener;
  }

  /**
   * Install a custom JAXP {@link ErrorListener} for Saxon stylesheet compilation. The listener
   * receives every compile-time warning, error and fatal error from Saxon (including any surfacing
   * from {@code <xsl:*>} foreign content passed through from the schema). It does <em>not</em>
   * receive Schematron-source parse problems &mdash; those go through {@link IPSErrorHandler} set
   * via {@link #setErrorHandler(IPSErrorHandler)}.
   *
   * @param aErrorListener
   *        The listener. May be <code>null</code> to clear.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final SchematronResourcePureXslt setErrorListener (@Nullable final ErrorListener aErrorListener)
  {
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_aErrorListener = aErrorListener;
    return this;
  }

  /**
   * @return The XSLT language version written to the generated stylesheet's {@code version}
   *         attribute. Never <code>null</code>; defaults to {@link EPureXsltVersion#DEFAULT}.
   */
  @NonNull
  public final EPureXsltVersion getXsltVersion ()
  {
    return m_eXsltVersion;
  }

  /**
   * Set the XSLT language version for the generated stylesheet. The default is XSLT&nbsp;3.0, which
   * gives access to {@code fn:path()} for the SVRL {@code location} attribute and 3.0 extension
   * functions. Choose {@link EPureXsltVersion#XSLT_2_0} only if you need strict XSLT&nbsp;2.0
   * compatibility - some 3.0-only features (notably {@code fn:path()}) will then fail compilation.
   *
   * @param eVersion
   *        The version. May not be <code>null</code>.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final SchematronResourcePureXslt setXsltVersion (@NonNull final EPureXsltVersion eVersion)
  {
    ValueEnforcer.notNull (eVersion, "XsltVersion");
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_eXsltVersion = eVersion;
    return this;
  }

  /**
   * @return <code>true</code> if runtime telemetry (phase spans + post-hoc counters + duration
   *         histogram) is emitted via ph-telemetry during validation. Default is
   *         <code>false</code>.
   */
  public final boolean isTelemetry ()
  {
    return m_bTelemetry;
  }

  /**
   * Enable or disable aggregate-level runtime telemetry. When enabled, every call to
   * {@code applySchematronValidationToSVRL} is wrapped in a {@link PureXsltTelemetry#SPAN_VALIDATE}
   * span with child spans for each pipeline phase (parse, preprocess, generate, compile, execute).
   * After the transform completes the SVRL output is walked to emit counters for failed asserts,
   * fired reports, fired rules and active patterns, as well as a
   * {@code schematron.validate.duration} histogram entry. Zero-cost when no ph-telemetry SPI is
   * registered.
   * <p>
   * Can only be set before the Schematron is compiled.
   *
   * @param bTelemetry
   *        <code>true</code> to enable.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final SchematronResourcePureXslt setTelemetry (final boolean bTelemetry)
  {
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_bTelemetry = bTelemetry;
    return this;
  }

  /**
   * @return <code>true</code> if per-assertion telemetry spans are emitted in addition to the
   *         aggregate metrics. Only meaningful when {@link #isTelemetry()} is also
   *         <code>true</code>. Default is <code>false</code>.
   */
  public final boolean isPerAssertionTelemetry ()
  {
    return m_bPerAssertionTelemetry;
  }

  /**
   * Enable per-assertion telemetry. When on, the post-hoc walk over the SVRL emits one
   * {@link PureXsltTelemetry#SPAN_ASSERTION} span per failed-assert / successful-report carrying
   * its test expression, location and (when present) id. The Saxon transform is one opaque step, so
   * the spans carry no individual timing &mdash; only metadata for trace inspection. Has no effect
   * when {@link #isTelemetry()} is <code>false</code>.
   *
   * @param bPerAssertionTelemetry
   *        <code>true</code> to enable.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final SchematronResourcePureXslt setPerAssertionTelemetry (final boolean bPerAssertionTelemetry)
  {
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_bPerAssertionTelemetry = bPerAssertionTelemetry;
    return this;
  }

  /**
   * @return <code>true</code> if {@link SchematronPureXsltCache} is consulted even when a custom
   *         {@link URIResolver} or {@link ErrorListener} is installed. Default is
   *         {@link #DEFAULT_FORCE_CACHE_RESULT}.
   */
  public final boolean isForceCacheResult ()
  {
    return m_bForceCacheResult;
  }

  /**
   * By default the cache in {@link SchematronPureXsltCache} is bypassed when a custom
   * {@link URIResolver} or {@link ErrorListener} is installed, because those hooks can affect what
   * Saxon emits in ways the cache key does not capture. Setting this to <code>true</code> tells the
   * engine that the hooks are deterministic for a given
   * {@code (resource, phase, version, processor)} tuple and allows the cache to participate.
   * <p>
   * Can only be set before the Schematron is compiled.
   *
   * @param bForceCacheResult
   *        <code>true</code> to force cache use.
   * @return this
   * @deprecated since 10.0.0 — configure via {@link #builder(IReadableResource)} instead. Will
   *             remain for backward compatibility.
   */
  @Deprecated (since = "10.0.0", forRemoval = false)
  @NonNull
  public final SchematronResourcePureXslt setForceCacheResult (final boolean bForceCacheResult)
  {
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_bForceCacheResult = bForceCacheResult;
    return this;
  }

  @Override
  public boolean isValidSchematron ()
  {
    try
    {
      return getOrReadSchema () != null;
    }
    catch (final Exception ex)
    {
      LOGGER.error ("Schematron source could not be read: " + ex.getMessage ());
      return false;
    }
  }

  /**
   * @return A {@link SchematronPureXsltConfig} snapshot of this resource's compile-time state.
   *         Runtime-only fields (telemetry toggles) are intentionally not propagated.
   */
  @NonNull
  public final SchematronPureXsltConfig toConfig ()
  {
    return SchematronPureXsltConfig.builder (getResource ())
                                   .phase (m_sPhase)
                                   .xsltVersion (m_eXsltVersion)
                                   .processor (m_aProcessor)
                                   .errorHandler (m_aErrorHandler != null ? m_aErrorHandler
                                                                          : new LoggingPSErrorHandler ())
                                   .entityResolver (getEntityResolver ())
                                   .uriResolver (m_aURIResolver)
                                   .errorListener (m_aErrorListener)
                                   .forceCacheResult (m_bForceCacheResult)
                                   .build ();
  }

  /**
   * Run {@code aBody} optionally wrapped in a telemetry span. When {@link #m_bTelemetry} is off the
   * body runs directly with no span overhead.
   */
  @Nullable
  private <T> T _phase (@NonNull final String sSpanName, @NonNull final IThrowingSupplier <T, Exception> aBody)
                                                                                                                throws Exception
  {
    if (!m_bTelemetry)
      return aBody.get ();

    try (final ITelemetrySpan aSpan = Telemetry.startSpan (sSpanName, ETelemetrySpanKind.INTERNAL))
    {
      try
      {
        final T r = aBody.get ();
        aSpan.setStatusOk ();
        return r;
      }
      catch (final Exception ex)
      {
        aSpan.recordException (ex).setStatusError (ex.getMessage ());
        throw ex;
      }
    }
  }

  @NonNull
  private ITelemetrySpan _maybeStartSpan (@NonNull final String sSpanName)
  {
    return m_bTelemetry ? Telemetry.startSpan (sSpanName, ETelemetrySpanKind.INTERNAL)
                        : Telemetry.NoOpTelemetrySpan.INSTANCE;
  }

  /**
   * Lazily generate the XSLT stylesheet from the parsed schema and compile it via Saxon.
   *
   * @return The compiled XSLT executable. Never <code>null</code>.
   * @throws Exception
   *         on read or compile failure.
   */
  @NonNull
  protected final XsltExecutable getOrCompileXslt () throws Exception
  {
    if (m_aCompiledXslt != null)
      return m_aCompiledXslt;

    // Cache participation:
    // isUseCache() (inherited) controls the shared module-level cache as a whole;
    // m_bForceCacheResult overrides the safety bypass when custom hooks are installed.
    // Custom URI/Error hooks bypass the cache unless setForceCacheResult(true) was called, because
    // the cache key encodes (resource, phase, version, processor) only and the hooks can change
    // what Saxon compiles.
    final boolean bHaveCustomHooks = m_aURIResolver != null || m_aErrorListener != null;
    final boolean bCacheable = isUseCache () && (!bHaveCustomHooks || m_bForceCacheResult);

    if (bCacheable)
    {
      // One-shot compile through the cache. Phase spans (parse / preprocess / generate / compile)
      // intentionally do not fire here: on a cache hit no work happens; on a cache miss the spans
      // would only paint a misleading picture compared to the cached fast path. The
      // schematron.validate.duration histogram still reflects the wall-clock cost.
      final SchematronPureXsltConfig aConfig = SchematronPureXsltConfig.builder (getResource ())
                                                                       .phase (m_sPhase)
                                                                       .xsltVersion (m_eXsltVersion)
                                                                       .processor (m_aProcessor)
                                                                       .errorHandler (m_aErrorHandler != null
                                                                                                              ? m_aErrorHandler
                                                                                                              : new LoggingPSErrorHandler ())
                                                                       .entityResolver (getEntityResolver ())
                                                                       .uriResolver (m_aURIResolver)
                                                                       .errorListener (m_aErrorListener)
                                                                       .forceCacheResult (true)
                                                                       .build ();
      m_aCompiledXslt = SchematronPureXsltCache.shared ().getOrCompile (aConfig);
      if (m_aCompiledXslt == null)
        throw new SchematronException ("Failed to compile pure-XSLT for " + getResource ());
      return m_aCompiledXslt;
    }

    // Inline path - bypasses the cache, exposes each pipeline phase to telemetry.
    final PSSchema aRaw = _phase (PureXsltTelemetry.SPAN_PARSE, this::getOrReadSchema);

    final PSPreprocessor aPreprocessor = PSPreprocessor.createPreprocessorWithoutInformationLoss (PureXsltQueryBindingTransform.getInstance ());
    final PSSchema aSchema = _phase (PureXsltTelemetry.SPAN_PREPROCESS,
                                     () -> aPreprocessor.getAsPreprocessedSchema (aRaw));

    final Document aXsltDoc;
    {
      try (final ITelemetrySpan aSpan = _maybeStartSpan (PureXsltTelemetry.SPAN_GENERATE))
      {
        aXsltDoc = PureXsltStylesheetGenerator.generate (aSchema, m_sPhase, m_eXsltVersion);
      }
    }

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Generated XSLT for Saxon-native validation:\n" +
                    XMLWriter.getNodeAsString (aXsltDoc,
                                               new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));

    try (final ITelemetrySpan aSpan = _maybeStartSpan (PureXsltTelemetry.SPAN_COMPILE))
    {
      final XsltCompiler aCompiler = m_aProcessor.newXsltCompiler ();
      if (m_aURIResolver != null)
        aCompiler.setResourceResolver (new ResourceResolverWrappingURIResolver (m_aURIResolver));
      if (m_aErrorListener != null)
        aCompiler.setErrorReporter (new ErrorReporterToListener (m_aErrorListener));
      m_aCompiledXslt = aCompiler.compile (new DOMSource (aXsltDoc));
    }
    return m_aCompiledXslt;
  }

  @NonNull
  private SchematronOutputType _doValidate (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                           throws Exception
  {
    final XsltExecutable aExecutable = getOrCompileXslt ();
    final Document aResultDoc = XMLFactory.newDocument ();
    final DOMDestination aDestination = new DOMDestination (aResultDoc);

    try (final ITelemetrySpan aSpan = _maybeStartSpan (PureXsltTelemetry.SPAN_EXECUTE))
    {
      final var aTransformer = aExecutable.load30 ();
      if (m_aURIResolver != null)
        aTransformer.setResourceResolver (new ResourceResolverWrappingURIResolver (m_aURIResolver));
      if (m_aErrorListener != null)
        aTransformer.setErrorListener (m_aErrorListener);
      if (sBaseURI != null)
        aTransformer.setGlobalContextItem (m_aProcessor.newDocumentBuilder ().wrap (aXMLNode));
      aTransformer.applyTemplates (new DOMSource (aXMLNode, sBaseURI), aDestination);
    }

    final SchematronOutputType aSVRL = new SVRLMarshaller ().setUseSchema (false).read (aResultDoc);
    if (aSVRL == null)
      throw new IllegalStateException ("Saxon transformation did not produce a parseable SVRL document:\n" +
                                       XMLWriter.getNodeAsString (aResultDoc,
                                                                  new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN)));
    return aSVRL;
  }

  @Override
  @NonNull
  public EValidity getSchematronValidity (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                         throws Exception
  {
    final SchematronOutputType aSVRL = applySchematronValidationToSVRL (aXMLNode, sBaseURI);
    if (aSVRL == null)
      return EValidity.INVALID;

    for (final Object aObj : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof FailedAssert)
        return EValidity.INVALID;

    return EValidity.VALID;
  }

  @Override
  @Nullable
  public Document applySchematronValidation (@NonNull final Node aXMLNode, @Nullable final String sBaseURI)
                                                                                                            throws Exception
  {
    final SchematronOutputType aSVRL = applySchematronValidationToSVRL (aXMLNode, sBaseURI);
    if (aSVRL == null)
      return null;
    return new SVRLMarshaller ().getAsDocument (aSVRL);
  }

  @Override
  @NonNull
  public SchematronOutputType applySchematronValidationToSVRL (@NonNull final Node aXMLNode,
                                                               @Nullable final String sBaseURI) throws Exception
  {
    if (!m_bTelemetry)
      return _doValidate (aXMLNode, sBaseURI);

    final StopWatch aSW = StopWatch.createdStarted ();
    try (final ITelemetrySpan aRootSpan = Telemetry.startSpan (PureXsltTelemetry.SPAN_VALIDATE,
                                                               ETelemetrySpanKind.INTERNAL))
    {
      aRootSpan.setAttribute (PureXsltTelemetry.ATTR_ENGINE, PureXsltTelemetry.ENGINE_VALUE);
      if (m_sPhase != null)
        aRootSpan.setAttribute (PureXsltTelemetry.ATTR_PHASE, m_sPhase);
      try
      {
        final SchematronOutputType aSVRL = _doValidate (aXMLNode, sBaseURI);

        aSW.stop ();
        final double dDurationMs = aSW.getNanos () / (double) CGlobal.NANOSECONDS_PER_MILLISECOND;
        PureXsltTelemetry.emitPostHoc (aSVRL, m_bPerAssertionTelemetry, dDurationMs);
        aRootSpan.setStatusOk ();
        return aSVRL;
      }
      catch (final Exception ex)
      {
        aRootSpan.recordException (ex).setStatusError (ex.getMessage ());
        throw ex;
      }
    }
  }

  // --- Builder factories ---

  /**
   * @param aResource
   *        The Schematron resource. May not be <code>null</code>.
   * @return A new {@link Builder} that produces a configured {@link SchematronResourcePureXslt}.
   *         Never <code>null</code>.
   */
  @NonNull
  public static Builder builder (@NonNull final IReadableResource aResource)
  {
    return new Builder (aResource);
  }

  /**
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be <code>null</code> nor
   *        empty.
   * @return A new {@link Builder} reading the Schematron from the default classloader. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder builderFromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new Builder (new ClassPathResource (sSCHPath));
  }

  /**
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be <code>null</code> nor
   *        empty.
   * @param aClassLoader
   *        The class loader to be used. May be <code>null</code>.
   * @return A new {@link Builder} reading the Schematron from the given classloader. Never
   *         <code>null</code>.
   */
  @NonNull
  public static Builder builderFromClassPath (@NonNull @Nonempty final String sSCHPath,
                                              @Nullable final ClassLoader aClassLoader)
  {
    return new Builder (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be <code>null</code> nor empty.
   * @return A new {@link Builder} reading the Schematron from the file system. Never
   *         <code>null</code>.
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
   */
  @NonNull
  public static SchematronResourcePureXslt compileCached (@NonNull final IReadableResource aResource) throws SchematronException
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
   */
  @NonNull
  public static SchematronResourcePureXslt compileCached (@NonNull final IReadableResource aResource,
                                                          @NonNull final SchematronPureXsltCache aCache) throws SchematronException
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
   */
  @NonNull
  public static SchematronResourcePureXslt compileUncached (@NonNull final IReadableResource aResource) throws SchematronException
  {
    return builder (aResource).buildUncached ();
  }

  // === Builder ===

  /**
   * Fluent builder for {@link SchematronResourcePureXslt}. Not thread-safe.
   */
  @NotThreadSafe
  public static final class Builder implements IBuilder <SchematronResourcePureXslt>
  {
    private final IReadableResource m_aResource;
    private boolean m_bUseCache = AbstractSchematronResource.DEFAULT_USE_CACHE;
    private boolean m_bLenient = com.helger.schematron.CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;
    private EntityResolver m_aEntityResolver;
    private boolean m_bEntityResolverSet;
    private String m_sPhase;
    private IPSErrorHandler m_aErrorHandler = new LoggingPSErrorHandler ();
    private Processor m_aProcessor = new Processor (false);
    private URIResolver m_aURIResolver;
    private ErrorListener m_aErrorListener;
    private EPureXsltVersion m_eXsltVersion = EPureXsltVersion.DEFAULT;
    private boolean m_bTelemetry;
    private boolean m_bPerAssertionTelemetry;
    private boolean m_bForceCacheResult = DEFAULT_FORCE_CACHE_RESULT;

    Builder (@NonNull final IReadableResource aResource)
    {
      ValueEnforcer.notNull (aResource, "Resource");
      m_aResource = aResource;
    }

    /**
     * @param b
     *        <code>true</code> to participate in the compilation cache, <code>false</code> to
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
     *        The Schematron error handler. May not be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder errorHandler (@NonNull final IPSErrorHandler a)
    {
      ValueEnforcer.notNull (a, "ErrorHandler");
      m_aErrorHandler = a;
      return this;
    }

    /**
     * @param a
     *        The Saxon {@link Processor}. May not be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder processor (@NonNull final Processor a)
    {
      ValueEnforcer.notNull (a, "Processor");
      m_aProcessor = a;
      return this;
    }

    /**
     * @param a
     *        The URI resolver, or <code>null</code> for the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder uriResolver (@Nullable final URIResolver a)
    {
      m_aURIResolver = a;
      return this;
    }

    /**
     * @param a
     *        The JAXP error listener, or <code>null</code> for the engine default.
     * @return this for chaining
     */
    @NonNull
    public Builder errorListener (@Nullable final ErrorListener a)
    {
      m_aErrorListener = a;
      return this;
    }

    /**
     * @param e
     *        The XSLT version for the generated stylesheet. May not be <code>null</code>.
     * @return this for chaining
     */
    @NonNull
    public Builder xsltVersion (@NonNull final EPureXsltVersion e)
    {
      ValueEnforcer.notNull (e, "XsltVersion");
      m_eXsltVersion = e;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to enable aggregate-level telemetry.
     * @return this for chaining
     */
    @NonNull
    public Builder telemetry (final boolean b)
    {
      m_bTelemetry = b;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to enable per-assertion telemetry spans (only meaningful when
     *        {@link #telemetry(boolean)} is also <code>true</code>).
     * @return this for chaining
     */
    @NonNull
    public Builder perAssertionTelemetry (final boolean b)
    {
      m_bPerAssertionTelemetry = b;
      return this;
    }

    /**
     * @param b
     *        <code>true</code> to force cache use even when custom URI/Error hooks are set. Default
     *        is {@link #DEFAULT_FORCE_CACHE_RESULT}.
     * @return this for chaining
     */
    @NonNull
    public Builder forceCacheResult (final boolean b)
    {
      m_bForceCacheResult = b;
      return this;
    }

    /**
     * @return A new {@link SchematronResourcePureXslt} configured with the values of this builder.
     *         Never <code>null</code>.
     */
    @NonNull
    public SchematronResourcePureXslt build ()
    {
      return new SchematronResourcePureXslt (this);
    }

    /**
     * Build the resource and eagerly compile via the {@link SchematronPureXsltCache#shared() shared
     * cache}. Pre-warms the cache for any subsequent caller with the same config and surfaces
     * compilation failures as {@link SchematronException} rather than letting them appear lazily on
     * first validation.
     *
     * @return The fully compiled resource. Never <code>null</code>.
     * @throws SchematronException
     *         on compilation error.
     */
    @NonNull
    public SchematronResourcePureXslt buildCached () throws SchematronException
    {
      useCache (true);
      final SchematronResourcePureXslt ret = build ();
      SchematronPureXsltCache.shared ().getOrCompile (ret.toConfig ());
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
     */
    @NonNull
    public SchematronResourcePureXslt buildCached (@NonNull final SchematronPureXsltCache aCache) throws SchematronException
    {
      ValueEnforcer.notNull (aCache, "Cache");
      useCache (true);
      final SchematronResourcePureXslt ret = build ();
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
     */
    @NonNull
    public SchematronResourcePureXslt buildUncached () throws SchematronException
    {
      useCache (false);
      final SchematronResourcePureXslt ret = build ();
      ret.toConfig ().compile ();
      return ret;
    }
  }
}
