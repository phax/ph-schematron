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

import java.util.Locale;
import java.util.Map;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.base.debug.GlobalDebug;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.telemetry.SaxonTraceListenerInstaller;
import com.helger.schematron.api.telemetry.SchematronTraceListener;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.LoggingTransformErrorListener;

/**
 * Stateless utility that applies a previously-compiled
 * {@link ISchematronXSLTBasedProvider XSLT-based Schematron provider} to an XML source. Used by
 * the builder-style validators introduced in v10.0.0 to avoid duplicating the transformation
 * plumbing across engines.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public final class SchematronXSLTValidator
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronXSLTValidator.class);

  private SchematronXSLTValidator ()
  {}

  /**
   * Apply the compiled Schematron provider to the given XML source.
   *
   * @param aProvider
   *        The compiled provider. May be <code>null</code>; in that case a warning is logged and
   *        <code>null</code> is returned.
   * @param aSource
   *        The XML source to validate. May not be <code>null</code>.
   * @param aErrorListener
   *        Optional transformer error listener. When <code>null</code>, a logging default is
   *        installed.
   * @param aURIResolver
   *        Optional URI resolver applied to the transformer.
   * @param aParameters
   *        Optional XSLT parameters applied to the transformer.
   * @return The SVRL DOM document or <code>null</code> if the provider is unusable.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @Nullable
  public static Document applyValidation (@Nullable final ISchematronXSLTBasedProvider aProvider,
                                          @NonNull final Source aSource,
                                          @Nullable final ErrorListener aErrorListener,
                                          @Nullable final URIResolver aURIResolver,
                                          @Nullable final Map <String, ?> aParameters) throws TransformerException
  {
    return applyValidation (aProvider, aSource, aErrorListener, aURIResolver, aParameters, null);
  }

  /**
   * Apply the compiled Schematron provider to the given XML source, optionally dispatching
   * per-template events to the supplied telemetry callback. Telemetry only fires when the provider
   * was compiled with Saxon's {@code COMPILE_WITH_TRACING} feature.
   *
   * @param aProvider
   *        The compiled provider. May be <code>null</code>; in that case a warning is logged and
   *        <code>null</code> is returned.
   * @param aSource
   *        The XML source to validate. May not be <code>null</code>.
   * @param aErrorListener
   *        Optional transformer error listener. When <code>null</code>, a logging default is
   *        installed.
   * @param aURIResolver
   *        Optional URI resolver applied to the transformer.
   * @param aParameters
   *        Optional XSLT parameters applied to the transformer.
   * @param aTelemetry
   *        Optional per-template telemetry callback. When non-<code>null</code>, a Saxon
   *        {@link net.sf.saxon.lib.TraceListener} bridging to this callback is installed on the
   *        underlying Saxon controller for the duration of the transform.
   * @return The SVRL DOM document or <code>null</code> if the provider is unusable.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   * @since 10.0.0
   */
  @Nullable
  public static Document applyValidation (@Nullable final ISchematronXSLTBasedProvider aProvider,
                                          @NonNull final Source aSource,
                                          @Nullable final ErrorListener aErrorListener,
                                          @Nullable final URIResolver aURIResolver,
                                          @Nullable final Map <String, ?> aParameters,
                                          @Nullable final ISchematronTemplateTelemetry aTelemetry)
                                                                                                    throws TransformerException
  {
    ValueEnforcer.notNull (aSource, "Source");

    if (aProvider == null || !aProvider.isValidSchematron ())
    {
      LOGGER.warn ("Cannot apply the Schematron validation, due to errors in the Schematron rules");
      return null;
    }

    if (SchematronDebug.isShowCreatedXSLT ())
      LOGGER.info ("Created XSLT document: " + XMLWriter.getNodeAsString (aProvider.getXSLTDocument ()));

    LOGGER.info ("Applying Schematron XSLT on XML instance" +
                 (StringHelper.isNotEmpty (aSource.getSystemId ()) ? " with base URI '" + aSource.getSystemId () + "'"
                                                                   : ""));

    final Document ret = XMLFactory.newDocument ();
    final Transformer aTransformer = aProvider.getXSLTTransformer ();

    if (aErrorListener != null)
      aTransformer.setErrorListener (aErrorListener);
    else
      aTransformer.setErrorListener (new LoggingTransformErrorListener (Locale.US));

    if (aURIResolver != null)
      aTransformer.setURIResolver (aURIResolver);

    if (aParameters != null)
      for (final Map.Entry <String, ?> aEntry : aParameters.entrySet ())
      {
        if (LOGGER.isDebugEnabled ())
          LOGGER.debug ("Adding XSLT parameter '" + aEntry.getKey () + "' = '" + aEntry.getValue () + "'");
        aTransformer.setParameter (aEntry.getKey (), aEntry.getValue ());
      }

    if (aTelemetry != null)
      SaxonTraceListenerInstaller.install (aTransformer, new SchematronTraceListener (aTelemetry));

    aTransformer.transform (aSource, new DOMResult (ret));

    if (SchematronDebug.isShowCreatedSVRL ())
      LOGGER.info ("Created SVRL:\n" + XMLWriter.getNodeAsString (ret));

    return ret;
  }

  /**
   * Convenience overload taking a DOM node and base URI. Wraps the node in a {@link DOMSource} with
   * the supplied system ID and delegates to
   * {@link #applyValidation(ISchematronXSLTBasedProvider, Source, ErrorListener, URIResolver, Map)}.
   *
   * @param aProvider
   *        The compiled provider. May be <code>null</code>; in that case a warning is logged and
   *        <code>null</code> is returned.
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @param aErrorListener
   *        Optional transformer error listener. When <code>null</code>, a logging default is
   *        installed.
   * @param aURIResolver
   *        Optional URI resolver applied to the transformer.
   * @param aParameters
   *        Optional XSLT parameters applied to the transformer.
   * @return The SVRL DOM document or <code>null</code> if the provider is unusable.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @Nullable
  public static Document applyValidation (@Nullable final ISchematronXSLTBasedProvider aProvider,
                                          @NonNull final Node aXMLNode,
                                          @Nullable final String sBaseURI,
                                          @Nullable final ErrorListener aErrorListener,
                                          @Nullable final URIResolver aURIResolver,
                                          @Nullable final Map <String, ?> aParameters) throws TransformerException
  {
    return applyValidation (aProvider, aXMLNode, sBaseURI, aErrorListener, aURIResolver, aParameters, null);
  }

  /**
   * Node-based convenience overload that adds optional telemetry. See
   * {@link #applyValidation(ISchematronXSLTBasedProvider, Source, ErrorListener, URIResolver, Map, ISchematronTemplateTelemetry)}.
   *
   * @param aProvider
   *        The compiled provider. May be <code>null</code>; in that case a warning is logged and
   *        <code>null</code> is returned.
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @param aErrorListener
   *        Optional transformer error listener. When <code>null</code>, a logging default is
   *        installed.
   * @param aURIResolver
   *        Optional URI resolver applied to the transformer.
   * @param aParameters
   *        Optional XSLT parameters applied to the transformer.
   * @param aTelemetry
   *        Optional per-template telemetry callback.
   * @return The SVRL DOM document or <code>null</code> if the provider is unusable.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   * @since 10.0.0
   */
  @Nullable
  public static Document applyValidation (@Nullable final ISchematronXSLTBasedProvider aProvider,
                                          @NonNull final Node aXMLNode,
                                          @Nullable final String sBaseURI,
                                          @Nullable final ErrorListener aErrorListener,
                                          @Nullable final URIResolver aURIResolver,
                                          @Nullable final Map <String, ?> aParameters,
                                          @Nullable final ISchematronTemplateTelemetry aTelemetry)
                                                                                                    throws TransformerException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");
    final DOMSource aSource = new DOMSource (aXMLNode);
    aSource.setSystemId (sBaseURI);
    return applyValidation (aProvider, aSource, aErrorListener, aURIResolver, aParameters, aTelemetry);
  }

  /**
   * Apply validation and return the parsed SVRL object.
   *
   * @param aProvider
   *        The compiled provider. May be <code>null</code>; in that case <code>null</code> is
   *        returned.
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @param aErrorListener
   *        Optional transformer error listener. When <code>null</code>, a logging default is
   *        installed.
   * @param aURIResolver
   *        Optional URI resolver applied to the transformer.
   * @param aParameters
   *        Optional XSLT parameters applied to the transformer.
   * @param bValidateSVRL
   *        If <code>true</code>, the produced SVRL DOM is validated against the SVRL JAXB schema
   *        while unmarshalling.
   * @return The parsed SVRL object, or <code>null</code> if validation could not be applied.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   */
  @Nullable
  public static SchematronOutputType applyToSVRL (@Nullable final ISchematronXSLTBasedProvider aProvider,
                                                  @NonNull final Node aXMLNode,
                                                  @Nullable final String sBaseURI,
                                                  @Nullable final ErrorListener aErrorListener,
                                                  @Nullable final URIResolver aURIResolver,
                                                  @Nullable final Map <String, ?> aParameters,
                                                  final boolean bValidateSVRL) throws TransformerException
  {
    return applyToSVRL (aProvider, aXMLNode, sBaseURI, aErrorListener, aURIResolver, aParameters, bValidateSVRL, null);
  }

  /**
   * Apply validation and return the parsed SVRL object, optionally dispatching per-template events
   * to the supplied telemetry callback.
   *
   * @param aProvider
   *        The compiled provider. May be <code>null</code>; in that case <code>null</code> is
   *        returned.
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @param aErrorListener
   *        Optional transformer error listener. When <code>null</code>, a logging default is
   *        installed.
   * @param aURIResolver
   *        Optional URI resolver applied to the transformer.
   * @param aParameters
   *        Optional XSLT parameters applied to the transformer.
   * @param bValidateSVRL
   *        If <code>true</code>, the produced SVRL DOM is validated against the SVRL JAXB schema
   *        while unmarshalling.
   * @param aTelemetry
   *        Optional per-template telemetry callback.
   * @return The parsed SVRL object, or <code>null</code> if validation could not be applied.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   * @since 10.0.0
   */
  @Nullable
  public static SchematronOutputType applyToSVRL (@Nullable final ISchematronXSLTBasedProvider aProvider,
                                                  @NonNull final Node aXMLNode,
                                                  @Nullable final String sBaseURI,
                                                  @Nullable final ErrorListener aErrorListener,
                                                  @Nullable final URIResolver aURIResolver,
                                                  @Nullable final Map <String, ?> aParameters,
                                                  final boolean bValidateSVRL,
                                                  @Nullable final ISchematronTemplateTelemetry aTelemetry)
                                                                                                           throws TransformerException
  {
    final Document aDoc = applyValidation (aProvider,
                                           aXMLNode,
                                           sBaseURI,
                                           aErrorListener,
                                           aURIResolver,
                                           aParameters,
                                           aTelemetry);
    if (aDoc == null)
      return null;
    if (aDoc.getDocumentElement () == null)
      throw new IllegalStateException ("Internal error: created SVRL DOM Document has no document node!");

    final SVRLMarshaller aMarshaller = new SVRLMarshaller (bValidateSVRL);
    if (GlobalDebug.isDebugMode ())
    {
      aMarshaller.readExceptionCallbacks ()
                 .set (ex -> LOGGER.error ("Error parsing the following SVRL:\n" + XMLWriter.getNodeAsString (aDoc),
                                           ex));
    }
    return aMarshaller.read (aDoc);
  }
}
