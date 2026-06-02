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

import javax.xml.transform.ErrorListener;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.xml.sax.EntityResolver;

import com.helger.annotation.concurrent.GuardedBy;
import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.base.concurrent.SimpleReadWriteLock;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.base.string.StringImplode;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronException;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.exchange.SchematronReadException;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.preprocess.PSPreprocessor;
import com.helger.schematron.purexslt.binding.PureXsltQueryBindingTransform;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;
import com.helger.schematron.purexslt.xslt.PureXsltStylesheetGenerator;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

import net.sf.saxon.lib.ErrorReporterToListener;
import net.sf.saxon.lib.ResourceResolverWrappingURIResolver;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;

/**
 * Module-level cache of compiled XSLT executables produced by the {@code pure-xslt} engine, keyed
 * by Schematron resource id, selected phase, target XSLT version and Saxon {@link Processor}
 * identity. Mirrors the role of {@code SchematronResourceSCHCache} for the ISO-XSLT engine and
 * {@code SchematronResourceSchXslt_XSLT2Cache} for SchXslt.
 * <p>
 * Cache lookup is bypassed when the caller has installed a custom {@link URIResolver} or
 * {@link ErrorListener} on the {@code SchematronResourcePureXslt} instance, since those hooks can
 * affect compilation in ways the cache key does not encode. {@code setForceCacheResult(true)} on
 * the resource overrides this guard for callers who know their hooks are deterministic.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@ThreadSafe
public final class SchematronResourcePureXsltCache
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourcePureXsltCache.class);
  private static final SimpleReadWriteLock RW_LOCK = new SimpleReadWriteLock ();
  @GuardedBy ("RW_LOCK")
  private static final ICommonsMap <String, XsltExecutable> MAP = new CommonsHashMap <> ();

  private SchematronResourcePureXsltCache ()
  {}

  /**
   * Compile a fresh XSLT executable from the given Schematron source without consulting the cache.
   * Performs the full pipeline: parse SCH &rarr; preprocess (abstract patterns, includes, extends)
   * &rarr; generate XSLT 3.0 DOM &rarr; Saxon
   * {@link XsltCompiler#compile(javax.xml.transform.Source)} (via {@link DOMSource}).
   *
   * @param aResource
   *        The Schematron source. May not be <code>null</code>.
   * @param sPhase
   *        The phase to evaluate. May be <code>null</code> for "all".
   * @param eVersion
   *        The target XSLT language version. May not be <code>null</code>.
   * @param aProcessor
   *        The Saxon {@link Processor} used to obtain the {@link XsltCompiler}. May not be
   *        <code>null</code>.
   * @param aErrorHandler
   *        The {@link IPSErrorHandler} used by {@link PSReader}. May be <code>null</code> to use a
   *        {@link LoggingPSErrorHandler}.
   * @param aEntityResolver
   *        Entity resolver for the SCH parse. May be <code>null</code>.
   * @param aURIResolver
   *        URI resolver applied to the {@link XsltCompiler} (for {@code xsl:include} /
   *        {@code xsl:import}). May be <code>null</code>.
   * @param aErrorListener
   *        Error listener applied to the {@link XsltCompiler}. May be <code>null</code>.
   * @return The compiled stylesheet. Never <code>null</code>.
   * @throws SchematronReadException
   *         if the schema cannot be read.
   * @throws SaxonApiException
   *         if Saxon rejects the generated stylesheet.
   * @throws com.helger.schematron.SchematronException
   *         if preprocessing fails.
   */
  @NonNull
  public static XsltExecutable createCompiledXslt (@NonNull final IReadableResource aResource,
                                                   @Nullable final String sPhase,
                                                   @NonNull final EPureXsltVersion eVersion,
                                                   @NonNull final Processor aProcessor,
                                                   @Nullable final IPSErrorHandler aErrorHandler,
                                                   @Nullable final EntityResolver aEntityResolver,
                                                   @Nullable final URIResolver aURIResolver,
                                                   @Nullable final ErrorListener aErrorListener) throws SaxonApiException,
                                                                                                 com.helger.schematron.SchematronException
  {
    ValueEnforcer.notNull (aResource, "Resource");
    ValueEnforcer.notNull (eVersion, "Version");
    ValueEnforcer.notNull (aProcessor, "Processor");

    final PSReader aReader = new PSReader (aResource,
                                           aErrorHandler != null ? aErrorHandler : new LoggingPSErrorHandler (),
                                           aEntityResolver);
    aReader.setPreserveLetBodyElements (true);
    final PSSchema aRaw = aReader.readSchema ();
    if (aRaw == null)
      throw new SchematronReadException (aResource, "Failed to read Schematron from " + aResource);

    final PSPreprocessor aPreprocessor = PSPreprocessor.createPreprocessorWithoutInformationLoss (PureXsltQueryBindingTransform.getInstance ());
    final PSSchema aSchema = aPreprocessor.getAsPreprocessedSchema (aRaw);

    final Document aXsltDoc = PureXsltStylesheetGenerator.generate (aSchema, sPhase, eVersion);
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Generated XSLT for Saxon-native validation:\n" +
                    XMLWriter.getNodeAsString (aXsltDoc,
                                               new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));

    final XsltCompiler aCompiler = aProcessor.newXsltCompiler ();
    if (aURIResolver != null)
      aCompiler.setResourceResolver (new ResourceResolverWrappingURIResolver (aURIResolver));
    if (aErrorListener != null)
      aCompiler.setErrorReporter (new ErrorReporterToListener (aErrorListener));
    return aCompiler.compile (new DOMSource (aXsltDoc));
  }

  /**
   * Look up (and compile on miss) a cached {@link XsltExecutable} for the given source. The cache
   * key combines the resource id, the phase, the XSLT version and the identity of the
   * {@link Processor} so that two {@code SchematronResourcePureXslt} instances sharing a Processor
   * share the compile work but instances using different Processors do not.
   *
   * @param aResource
   *        The Schematron source. May not be <code>null</code>.
   * @param sPhase
   *        Selected phase. May be <code>null</code>.
   * @param eVersion
   *        XSLT version. May not be <code>null</code>.
   * @param aProcessor
   *        Saxon processor. May not be <code>null</code>.
   * @param aErrorHandler
   *        SCH-parse error handler. May be <code>null</code>.
   * @param aEntityResolver
   *        SCH-parse entity resolver. May be <code>null</code>.
   * @param aURIResolver
   *        XSLT compile-time URI resolver. May be <code>null</code>.
   * @param aErrorListener
   *        XSLT compile-time error listener. May be <code>null</code>.
   * @return The compiled stylesheet (cached or freshly compiled). Never <code>null</code>.
   * @throws SaxonApiException
   *         if Saxon rejects the generated stylesheet on a cache miss.
   * @throws SchematronException
   *         if reading or preprocessing the source fails on a cache miss.
   */
  @NonNull
  public static XsltExecutable getCompiledXslt (@NonNull final IReadableResource aResource,
                                                @Nullable final String sPhase,
                                                @NonNull final EPureXsltVersion eVersion,
                                                @NonNull final Processor aProcessor,
                                                @Nullable final IPSErrorHandler aErrorHandler,
                                                @Nullable final EntityResolver aEntityResolver,
                                                @Nullable final URIResolver aURIResolver,
                                                @Nullable final ErrorListener aErrorListener) throws SaxonApiException,
                                                                                              SchematronException
  {
    ValueEnforcer.notNull (aResource, "Resource");
    ValueEnforcer.notNull (eVersion, "Version");
    ValueEnforcer.notNull (aProcessor, "Processor");

    final String sCacheKey = StringImplode.imploder ()
                                          .source (aResource.getResourceID (),
                                                   StringHelper.getNotNull (sPhase),
                                                   eVersion.getID (),
                                                   Integer.toHexString (System.identityHashCode (aProcessor)))
                                          .separator (':')
                                          .build ();

    // Fast path: read-locked lookup
    XsltExecutable aCached = RW_LOCK.readLockedGet ( () -> MAP.get (sCacheKey));
    if (aCached != null)
      return aCached;

    // Slow path: write-locked re-check then compile-on-miss. Compilation itself runs OUTSIDE the
    // write lock so concurrent compiles for *different* keys don't serialize on each other.
    aCached = RW_LOCK.writeLockedGet ( () -> MAP.get (sCacheKey));
    if (aCached != null)
      return aCached;

    final XsltExecutable aFresh = createCompiledXslt (aResource,
                                                      sPhase,
                                                      eVersion,
                                                      aProcessor,
                                                      aErrorHandler,
                                                      aEntityResolver,
                                                      aURIResolver,
                                                      aErrorListener);
    RW_LOCK.writeLocked ( () -> MAP.put (sCacheKey, aFresh));
    return aFresh;
  }

  /**
   * Drop every cached compiled stylesheet. Useful after schema files change on disk or when test
   * isolation matters.
   */
  public static void clearCache ()
  {
    RW_LOCK.writeLocked (MAP::clear);
  }

  /**
   * @return The number of cache entries currently held. Mostly useful from tests.
   */
  public static int getCachedEntryCount ()
  {
    return RW_LOCK.readLockedInt (MAP::size);
  }
}
