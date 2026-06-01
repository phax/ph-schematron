/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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

import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.io.nonblocking.NonBlockingStringReader;
import com.helger.base.state.EValidity;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.exchange.SchematronReadException;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.preprocess.PSPreprocessor;
import com.helger.schematron.purexslt.binding.SaxonQueryBindingTransform;
import com.helger.schematron.purexslt.telemetry.SaxonTelemetry;
import com.helger.schematron.purexslt.xslt.EXsltVersion;
import com.helger.schematron.purexslt.xslt.XsltStylesheetGenerator;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.telemetry.ETelemetrySpanKind;
import com.helger.telemetry.ITelemetrySpan;
import com.helger.telemetry.Telemetry;
import com.helger.xml.XMLFactory;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.namespace.MapBasedNamespaceContext;
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

  private String m_sPhase;
  private IPSErrorHandler m_aErrorHandler = new LoggingPSErrorHandler ();
  private Processor m_aProcessor = new Processor (false);
  private URIResolver m_aURIResolver;
  private ErrorListener m_aErrorListener;
  private EXsltVersion m_eXsltVersion = EXsltVersion.DEFAULT;
  private boolean m_bTelemetry = false;
  private boolean m_bPerAssertionTelemetry = false;
  // Status vars
  private PSSchema m_aSchema;
  private XsltExecutable m_aCompiledXslt;

  public SchematronResourcePureXslt (@NonNull final IReadableResource aResource)
  {
    super (aResource);
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
   * Set the Schematron phase to be evaluated. May only be called before the schema is bound.
   *
   * @param sPhase
   *        The name of the phase to use. May be <code>null</code> which means all phases.
   * @return this
   */
  @NonNull
  public final SchematronResourcePureXslt setPhase (@Nullable final String sPhase)
  {
    if (m_aSchema != null)
      throw new IllegalStateException ("Schematron was already read and can therefore not be altered!");
    m_sPhase = sPhase;
    return this;
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
   * Set the error handler to be used when reading the Schematron source.
   *
   * @param aErrorHandler
   *        The error handler. May not be <code>null</code>.
   * @return this
   */
  @NonNull
  public final SchematronResourcePureXslt setErrorHandler (@NonNull final IPSErrorHandler aErrorHandler)
  {
    ValueEnforcer.notNull (aErrorHandler, "ErrorHandler");
    if (m_aSchema != null)
      throw new IllegalStateException ("Schematron was already read and can therefore not be altered!");
    m_aErrorHandler = aErrorHandler;
    return this;
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
   */
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
   */
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
   */
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
   *         attribute. Never <code>null</code>; defaults to {@link EXsltVersion#DEFAULT}.
   * @since 10.0.0
   */
  @NonNull
  public final EXsltVersion getXsltVersion ()
  {
    return m_eXsltVersion;
  }

  /**
   * Set the XSLT language version for the generated stylesheet. The default is XSLT&nbsp;3.0, which
   * gives access to {@code fn:path()} for the SVRL {@code location} attribute and 3.0 extension
   * functions. Choose {@link EXsltVersion#XSLT_2_0} only if you need strict XSLT&nbsp;2.0
   * compatibility - some 3.0-only features (notably {@code fn:path()}) will then fail compilation.
   *
   * @param eVersion
   *        The version. May not be <code>null</code>.
   * @return this
   * @since 10.0.0
   */
  @NonNull
  public final SchematronResourcePureXslt setXsltVersion (@NonNull final EXsltVersion eVersion)
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
   * @since 10.0.0
   */
  public final boolean isTelemetry ()
  {
    return m_bTelemetry;
  }

  /**
   * Enable or disable aggregate-level runtime telemetry. When enabled, every call to
   * {@code applySchematronValidationToSVRL} is wrapped in a {@link SaxonTelemetry#SPAN_VALIDATE}
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
   * @since 10.0.0
   */
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
   *         aggregate metrics. Only meaningful when {@link #isTelemetry()} is also <code>true</code>.
   *         Default is <code>false</code>.
   * @since 10.0.0
   */
  public final boolean isPerAssertionTelemetry ()
  {
    return m_bPerAssertionTelemetry;
  }

  /**
   * Enable per-assertion telemetry. When on, the post-hoc walk over the SVRL emits one
   * {@link SaxonTelemetry#SPAN_ASSERTION} span per failed-assert / successful-report carrying its
   * test expression, location and (when present) id. The Saxon transform is one opaque step, so
   * the spans carry no individual timing &mdash; only metadata for trace inspection. Has no effect
   * when {@link #isTelemetry()} is <code>false</code>.
   *
   * @param bPerAssertionTelemetry
   *        <code>true</code> to enable.
   * @return this
   * @since 10.0.0
   */
  @NonNull
  public final SchematronResourcePureXslt setPerAssertionTelemetry (final boolean bPerAssertionTelemetry)
  {
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_bPerAssertionTelemetry = bPerAssertionTelemetry;
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
   * Lazily generate the XSLT stylesheet from the parsed schema and compile it via Saxon.
   *
   * @return The compiled XSLT executable. Never <code>null</code>.
   * @throws Exception
   *         on read or compile failure.
   */
  @NonNull
  protected final XsltExecutable getOrCompileXslt () throws Exception
  {
    if (m_aCompiledXslt == null)
    {
      // Each phase is optionally wrapped in a telemetry span; phase spans nest under the
      // schematron.validate root span started in applySchematronValidationToSVRL via thread-local
      // current-span context.
      final PSSchema aRaw = _phase (SaxonTelemetry.SPAN_PARSE, this::getOrReadSchema);

      final PSPreprocessor aPreprocessor = PSPreprocessor.createPreprocessorWithoutInformationLoss (SaxonQueryBindingTransform.getInstance ());
      final PSSchema aSchema = _phase (SaxonTelemetry.SPAN_PREPROCESS, () -> aPreprocessor.getAsPreprocessedSchema (aRaw));

      final IMicroDocument aXsltDoc;
      final MapBasedNamespaceContext aNsCtx;
      {
        try (final ITelemetrySpan aSpan = _maybeStartSpan (SaxonTelemetry.SPAN_GENERATE))
        {
          aXsltDoc = XsltStylesheetGenerator.generate (aSchema, m_sPhase, m_eXsltVersion);
          aNsCtx = XsltStylesheetGenerator.namespaceContextFor (aSchema);
        }
      }

      // Force all namespace-context prefixes to be emitted as xmlns:* on the stylesheet root so
      // that prefixes referenced only from XPath attribute values (e.g. my:func() inside test=)
      // are resolvable when Saxon compiles the stylesheet. Without this, MicroWriter only emits
      // xmlns declarations for prefixes that appear as element/attribute names.
      final XMLWriterSettings aWriterSettings = new XMLWriterSettings ().setNamespaceContext (aNsCtx)
                                                                        .setPutNamespaceContextPrefixesInRoot (true);
      final String sXslt = MicroWriter.getNodeAsString (aXsltDoc, aWriterSettings);
      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Generated XSLT for Saxon-native validation:\n" + sXslt);

      try (final ITelemetrySpan aSpan = _maybeStartSpan (SaxonTelemetry.SPAN_COMPILE))
      {
        final XsltCompiler aCompiler = m_aProcessor.newXsltCompiler ();
        if (m_aURIResolver != null)
          aCompiler.setResourceResolver (new ResourceResolverWrappingURIResolver (m_aURIResolver));
        if (m_aErrorListener != null)
          aCompiler.setErrorReporter (new ErrorReporterToListener (m_aErrorListener));
        m_aCompiledXslt = aCompiler.compile (new StreamSource (new NonBlockingStringReader (sXslt)));
      }
    }
    return m_aCompiledXslt;
  }

  /**
   * Run {@code aBody} optionally wrapped in a telemetry span. When {@link #m_bTelemetry} is off the
   * body runs directly with no span overhead.
   */
  @Nullable
  private <T> T _phase (@NonNull final String sSpanName,
                        @NonNull final _CheckedSupplier <T> aBody) throws Exception
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
    return m_bTelemetry ? Telemetry.startSpan (sSpanName, ETelemetrySpanKind.INTERNAL) : Telemetry.NoOpTelemetrySpan.INSTANCE;
  }

  @FunctionalInterface
  private interface _CheckedSupplier <T>
  {
    T get () throws Exception;
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

    final long nStartNanos = System.nanoTime ();
    try (final ITelemetrySpan aRootSpan = Telemetry.startSpan (SaxonTelemetry.SPAN_VALIDATE,
                                                               ETelemetrySpanKind.INTERNAL))
    {
      aRootSpan.setAttribute (SaxonTelemetry.ATTR_ENGINE, SaxonTelemetry.ENGINE_VALUE);
      if (m_sPhase != null)
        aRootSpan.setAttribute (SaxonTelemetry.ATTR_PHASE, m_sPhase);
      try
      {
        final SchematronOutputType aSVRL = _doValidate (aXMLNode, sBaseURI);
        final double dDurationMs = (System.nanoTime () - nStartNanos) / 1_000_000.0;
        SaxonTelemetry.emitPostHoc (aSVRL, m_bPerAssertionTelemetry, dDurationMs);
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

  @NonNull
  private SchematronOutputType _doValidate (@NonNull final Node aXMLNode, @Nullable final String sBaseURI) throws Exception
  {
    final XsltExecutable aExecutable = getOrCompileXslt ();
    final Document aResultDoc = XMLFactory.newDocument ();
    final DOMDestination aDestination = new DOMDestination (aResultDoc);

    try (final ITelemetrySpan aSpan = _maybeStartSpan (SaxonTelemetry.SPAN_EXECUTE))
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

    final SchematronOutputType aSVRL = new SVRLMarshaller (false).read (aResultDoc);
    if (aSVRL == null)
      throw new IllegalStateException ("Saxon transformation did not produce a parseable SVRL document:\n" +
                                       XMLWriter.getNodeAsString (aResultDoc,
                                                                  new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN)));
    return aSVRL;
  }

  // --- factory methods ---

  @NonNull
  public static SchematronResourcePureXslt fromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePureXslt (new ClassPathResource (sSCHPath));
  }

  @NonNull
  public static SchematronResourcePureXslt fromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePureXslt (new FileSystemResource (sSCHPath));
  }

  @NonNull
  public static SchematronResourcePureXslt fromFile (@NonNull final File aSCHFile)
  {
    return new SchematronResourcePureXslt (new FileSystemResource (aSCHFile));
  }

  @NonNull
  public static SchematronResourcePureXslt fromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourcePureXslt (new URLResource (sSCHURL));
  }

  @NonNull
  public static SchematronResourcePureXslt fromURL (@NonNull final URL aSCHURL)
  {
    return new SchematronResourcePureXslt (new URLResource (aSCHURL));
  }

  @NonNull
  public static SchematronResourcePureXslt fromInputStream (@NonNull @Nonempty final String sResourceID,
                                                         @NonNull final InputStream aSchematronIS)
  {
    return new SchematronResourcePureXslt (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  @NonNull
  public static SchematronResourcePureXslt fromByteArray (@NonNull final byte [] aSchematron)
  {
    return new SchematronResourcePureXslt (new ReadableResourceByteArray (aSchematron));
  }

  @NonNull
  public static SchematronResourcePureXslt fromString (@NonNull final String sSchematron, @NonNull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }
}
