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

import java.util.function.Consumer;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;

import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.io.stream.StreamHelper;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.saxon.SchematronTransformerFactory;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.transform.DefaultTransformURIResolver;
import com.helger.xml.transform.TransformSourceFactory;

/**
 * This Schematron validator factory uses an existing, precompiled Schematron XSLT for validation.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronProviderXSLTPrebuild implements ISchematronXSLTBasedProvider
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronProviderXSLTPrebuild.class);

  private final IReadableResource m_aXSLTResource;
  private Document m_aSchematronXSLTDoc;
  private Templates m_aSchematronXSLTTemplates;

  public SchematronProviderXSLTPrebuild (@Nullable final IReadableResource aXSLTResource,
                                         @Nullable final ErrorListener aCustomErrorListener,
                                         @Nullable final URIResolver aCustomURIResolver)
  {
    this (aXSLTResource, aCustomErrorListener, aCustomURIResolver, false, null);
  }

  /**
   * @param aXSLTResource
   *        The XSLT resource. May be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional XSLT error listener.
   * @param aCustomURIResolver
   *        An optional XSLT URI resolver.
   * @param bEnableTracing
   *        <code>true</code> to compile the stylesheet with Saxon's {@code COMPILE_WITH_TRACING}
   *        feature so that per-instruction trace events fire at execution time. Required for
   *        {@link com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry} to receive any
   *        events.
   * @since 10.0.0
   */
  public SchematronProviderXSLTPrebuild (@Nullable final IReadableResource aXSLTResource,
                                         @Nullable final ErrorListener aCustomErrorListener,
                                         @Nullable final URIResolver aCustomURIResolver,
                                         final boolean bEnableTracing)
  {
    this (aXSLTResource, aCustomErrorListener, aCustomURIResolver, bEnableTracing, null);
  }

  /**
   * @param aXSLTResource
   *        The XSLT resource. May be <code>null</code>.
   * @param aCustomErrorListener
   *        An optional XSLT error listener.
   * @param aCustomURIResolver
   *        An optional XSLT URI resolver.
   * @param bEnableTracing
   *        <code>true</code> to compile the stylesheet with Saxon's {@code COMPILE_WITH_TRACING}
   *        feature so that per-instruction trace events fire at execution time.
   * @param aTFCustomizer
   *        Optional customizer applied to the {@link TransformerFactory} after the standard error
   *        listener / URI resolver are set, just before the stylesheet is compiled. Use this to
   *        register Saxon extension functions on the underlying {@code Processor}.
   * @since 10.0.0
   */
  public SchematronProviderXSLTPrebuild (@Nullable final IReadableResource aXSLTResource,
                                         @Nullable final ErrorListener aCustomErrorListener,
                                         @Nullable final URIResolver aCustomURIResolver,
                                         final boolean bEnableTracing,
                                         @Nullable final Consumer <TransformerFactory> aTFCustomizer)
  {
    // A read-once resource (e.g. an InputStream) is buffered, so that it can be compiled and still be
    // read by getXSLTDocument
    final byte [] aXSLTBytes = aXSLTResource == null || aXSLTResource.isReadMultiple () ? null
                                                                                         : StreamHelper.getAllBytes (aXSLTResource);
    m_aXSLTResource = aXSLTBytes == null ? aXSLTResource
                                         : new ReadableResourceByteArray (aXSLTResource.getResourceID (), aXSLTBytes, false);
    try
    {
      /*
       * Compile directly from the resource. Saxon builds its own tree much faster than it can walk
       * a W3C DOM, and the DOM is not kept in memory for the lifetime of the compiled stylesheet.
       * The provided resolver is used as-is and is deliberately not wrapped in another
       * DefaultTransformURIResolver: since ph-commons 12.5.0 a resolver ends the resolution of a
       * blocked remote resource itself instead of delegating, so a wrapping resolver would silently
       * override the caller's decision which remote schemes are allowed.
       */
      final URIResolver aURIResolver = aCustomURIResolver != null ? aCustomURIResolver
                                                                  : new DefaultTransformURIResolver ();
      final TransformerFactory aTF = SchematronTransformerFactory.createTransformerFactory (aCustomErrorListener,
                                                                                            aURIResolver,
                                                                                            bEnableTracing);
      // Hand the factory to the caller-supplied customizer last so it can register Saxon
      // extension functions (or any other tweak) just before the validation stylesheet compiles.
      if (aTFCustomizer != null)
        aTFCustomizer.accept (aTF);
      m_aSchematronXSLTTemplates = aTF.newTemplates (TransformSourceFactory.create (m_aXSLTResource));
    }
    catch (final Exception ex)
    {
      LOGGER.error ("XSLT read/compilation error for " + aXSLTResource, ex);
    }
  }

  public boolean isValidSchematron ()
  {
    return m_aSchematronXSLTTemplates != null;
  }

  /**
   * {@inheritDoc}<br>
   * The XSLT is only read as a DOM on the first call, because it is not needed for validation.
   */
  @Nullable
  public Document getXSLTDocument ()
  {
    if (m_aSchematronXSLTDoc == null && m_aXSLTResource != null)
      m_aSchematronXSLTDoc = DOMReader.readXMLDOM (m_aXSLTResource);
    return m_aSchematronXSLTDoc;
  }

  @Nullable
  public Transformer getXSLTTransformer () throws TransformerConfigurationException
  {
    return m_aSchematronXSLTTemplates == null ? null : m_aSchematronXSLTTemplates.newTransformer ();
  }
}
