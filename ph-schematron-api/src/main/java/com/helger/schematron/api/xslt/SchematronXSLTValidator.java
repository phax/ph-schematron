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
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.sax.SAXSource;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.DTDHandler;
import org.xml.sax.EntityResolver;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXNotRecognizedException;
import org.xml.sax.SAXNotSupportedException;
import org.xml.sax.XMLReader;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.debug.GlobalDebug;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.string.StringHelper;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.LoggingTransformErrorListener;

/**
 * Stateless utility that applies a previously-compiled {@link ISchematronXSLTBasedProvider
 * XSLT-based Schematron provider} to an XML source. Used by the builder-style validators introduced
 * in v10.0.0 to avoid duplicating the transformation plumbing across engines.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@Immutable
public final class SchematronXSLTValidator
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronXSLTValidator.class);

  private static final String SAX_FEATURE_NAMESPACES = "http://xml.org/sax/features/namespaces";
  private static final String SAX_FEATURE_NAMESPACE_PREFIXES = "http://xml.org/sax/features/namespace-prefixes";

  /**
   * A SAX action that may fail.
   */
  @FunctionalInterface
  private interface ISAXAction
  {
    void run () throws SAXException;
  }

  /**
   * Forwards the SAX events of the transformation to the content handler of the SVRL unmarshaller.
   * The first exception of the unmarshaller is remembered and all later events are dropped, so that
   * the transformation is not aborted. The exception is reported after the transformation, as when
   * reading an SVRL DOM.
   */
  private static final class SVRLForwardingContentHandler implements ContentHandler
  {
    private final ContentHandler m_aTarget;
    private SAXException m_aException;
    private boolean m_bHasElement;

    SVRLForwardingContentHandler (@NonNull final ContentHandler aTarget)
    {
      m_aTarget = aTarget;
    }

    private void _forward (@NonNull final ISAXAction aAction)
    {
      if (m_aException == null)
        try
        {
          aAction.run ();
        }
        catch (final SAXException ex)
        {
          m_aException = ex;
        }
    }

    public void setDocumentLocator (final Locator aLocator)
    {
      m_aTarget.setDocumentLocator (aLocator);
    }

    public void startDocument ()
    {
      _forward (m_aTarget::startDocument);
    }

    public void endDocument ()
    {
      _forward (m_aTarget::endDocument);
    }

    public void startPrefixMapping (final String sPrefix, final String sURI)
    {
      _forward (() -> m_aTarget.startPrefixMapping (sPrefix, sURI));
    }

    public void endPrefixMapping (final String sPrefix)
    {
      _forward (() -> m_aTarget.endPrefixMapping (sPrefix));
    }

    public void startElement (final String sURI, final String sLocalName, final String sQName, final Attributes aAttrs)
    {
      m_bHasElement = true;
      _forward (() -> m_aTarget.startElement (sURI, sLocalName, sQName, aAttrs));
    }

    public void endElement (final String sURI, final String sLocalName, final String sQName)
    {
      _forward (() -> m_aTarget.endElement (sURI, sLocalName, sQName));
    }

    public void characters (final char [] aCh, final int nStart, final int nLength)
    {
      _forward (() -> m_aTarget.characters (aCh, nStart, nLength));
    }

    public void ignorableWhitespace (final char [] aCh, final int nStart, final int nLength)
    {
      _forward (() -> m_aTarget.ignorableWhitespace (aCh, nStart, nLength));
    }

    public void processingInstruction (final String sTarget, final String sData)
    {
      _forward (() -> m_aTarget.processingInstruction (sTarget, sData));
    }

    public void skippedEntity (final String sName)
    {
      _forward (() -> m_aTarget.skippedEntity (sName));
    }
  }

  /**
   * Transports a {@link TransformerException} through the JAXB unmarshaller, so that it is thrown
   * to the caller instead of being reported as an SVRL reading error.
   */
  private static final class WrappedTransformerException extends RuntimeException
  {
    WrappedTransformerException (@NonNull final TransformerException aCause)
    {
      super (aCause);
    }

    @NonNull
    TransformerException getTransformerException ()
    {
      return (TransformerException) getCause ();
    }
  }

  /**
   * An {@link XMLReader} for the JAXB unmarshaller that does not parse, but runs the Schematron
   * transformation and emits the created SVRL as SAX events. That avoids building an SVRL DOM.
   */
  private static final class SVRLTransformingXMLReader implements XMLReader
  {
    private final Transformer m_aTransformer;
    private final Source m_aSource;
    private ContentHandler m_aContentHandler;
    private ErrorHandler m_aErrorHandler;
    private EntityResolver m_aEntityResolver;
    private DTDHandler m_aDTDHandler;

    SVRLTransformingXMLReader (@NonNull final Transformer aTransformer, @NonNull final Source aSource)
    {
      m_aTransformer = aTransformer;
      m_aSource = aSource;
    }

    private void _transform () throws SAXException
    {
      final SVRLForwardingContentHandler aHandler = new SVRLForwardingContentHandler (m_aContentHandler);
      try
      {
        m_aTransformer.transform (m_aSource, new SAXResult (aHandler));
      }
      catch (final TransformerException ex)
      {
        throw new WrappedTransformerException (ex);
      }

      // Same check as for the SVRL DOM
      if (!aHandler.m_bHasElement)
        throw new IllegalStateException ("Internal error: created SVRL DOM Document has no document node!");

      if (aHandler.m_aException != null)
        throw aHandler.m_aException;
    }

    public boolean getFeature (final String sName) throws SAXNotRecognizedException
    {
      if (SAX_FEATURE_NAMESPACES.equals (sName))
        return true;
      if (SAX_FEATURE_NAMESPACE_PREFIXES.equals (sName))
        return false;
      throw new SAXNotRecognizedException (sName);
    }

    public void setFeature (final String sName, final boolean bValue) throws SAXNotRecognizedException,
                                                                      SAXNotSupportedException
    {
      if (SAX_FEATURE_NAMESPACES.equals (sName) || SAX_FEATURE_NAMESPACE_PREFIXES.equals (sName))
      {
        if (bValue != getFeature (sName))
          throw new SAXNotSupportedException (sName);
        return;
      }
      throw new SAXNotRecognizedException (sName);
    }

    public Object getProperty (final String sName) throws SAXNotRecognizedException
    {
      throw new SAXNotRecognizedException (sName);
    }

    public void setProperty (final String sName, final Object aValue) throws SAXNotRecognizedException
    {
      throw new SAXNotRecognizedException (sName);
    }

    public void setEntityResolver (final EntityResolver aResolver)
    {
      m_aEntityResolver = aResolver;
    }

    public EntityResolver getEntityResolver ()
    {
      return m_aEntityResolver;
    }

    public void setDTDHandler (final DTDHandler aHandler)
    {
      m_aDTDHandler = aHandler;
    }

    public DTDHandler getDTDHandler ()
    {
      return m_aDTDHandler;
    }

    public void setContentHandler (final ContentHandler aHandler)
    {
      m_aContentHandler = aHandler;
    }

    public ContentHandler getContentHandler ()
    {
      return m_aContentHandler;
    }

    public void setErrorHandler (final ErrorHandler aHandler)
    {
      m_aErrorHandler = aHandler;
    }

    public ErrorHandler getErrorHandler ()
    {
      return m_aErrorHandler;
    }

    public void parse (final InputSource aInput) throws SAXException
    {
      _transform ();
    }

    public void parse (final String sSystemID) throws SAXException
    {
      _transform ();
    }
  }

  private SchematronXSLTValidator ()
  {}

  /**
   * Create the transformer of the provider and apply all settings to it.
   *
   * @return <code>null</code> if the provider is unusable.
   */
  @Nullable
  private static Transformer _createTransformer (@Nullable final ISchematronXSLTBasedProvider aProvider,
                                                 @NonNull final Source aSource,
                                                 @Nullable final ErrorListener aErrorListener,
                                                 @Nullable final URIResolver aURIResolver,
                                                 @Nullable final Map <String, ?> aParameters,
                                                 @Nullable final ISchematronTemplateTelemetry aTelemetry) throws TransformerException
  {
    if (aProvider == null || !aProvider.isValidSchematron ())
    {
      LOGGER.warn ("Cannot apply the Schematron validation, due to errors in the Schematron rules");
      return null;
    }

    if (SchematronDebug.isShowCreatedXSLT ())
      LOGGER.info ("Created XSLT document: " + XMLWriter.getNodeAsString (aProvider.getXSLTDocument ()));

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Applying Schematron XSLT on XML instance" +
                    (StringHelper.isNotEmpty (aSource.getSystemId ()) ? " with base URI '" + aSource.getSystemId () + "'"
                                                                      : ""));

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
      aProvider.getXsltProcessor ().installTemplateTelemetry (aTransformer, aTelemetry);

    return aTransformer;
  }

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
   * was compiled with tracing enabled (see
   * {@link ISchematronXsltProcessor#createTransformerFactory(boolean)}).
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
   *        Optional per-template telemetry callback. When non-<code>null</code>, it is installed on
   *        the transformer by the XSLT processor of the provider for the duration of the
   *        transform.
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
                                          @Nullable final ISchematronTemplateTelemetry aTelemetry) throws TransformerException
  {
    ValueEnforcer.notNull (aSource, "Source");

    final Transformer aTransformer = _createTransformer (aProvider,
                                                         aSource,
                                                         aErrorListener,
                                                         aURIResolver,
                                                         aParameters,
                                                         aTelemetry);
    if (aTransformer == null)
      return null;

    // The processor may convert the source into its own tree model
    final Source aEffectiveSource = aProvider.getXsltProcessor ().getEffectiveSource (aSource, aTransformer);
    final Document ret = XMLFactory.newDocument ();
    aTransformer.transform (aEffectiveSource, new DOMResult (ret));

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
                                          @Nullable final ISchematronTemplateTelemetry aTelemetry) throws TransformerException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");
    final DOMSource aSource = new DOMSource (aXMLNode);
    aSource.setSystemId (sBaseURI);
    return applyValidation (aProvider, aSource, aErrorListener, aURIResolver, aParameters, aTelemetry);
  }

  @Nullable
  private static SchematronOutputType _readSVRL (@Nullable final Document aDoc, final boolean bValidateSVRL)
  {
    if (aDoc == null)
      return null;
    if (aDoc.getDocumentElement () == null)
      throw new IllegalStateException ("Internal error: created SVRL DOM Document has no document node!");

    final var aMarshaller = new SVRLMarshaller ().setUseSchema (bValidateSVRL);
    if (GlobalDebug.isDebugMode ())
    {
      aMarshaller.readExceptionCallbacks ()
                 .set (ex -> LOGGER.error ("Error parsing the following SVRL:\n" + XMLWriter.getNodeAsString (aDoc),
                                           ex));
    }
    return aMarshaller.read (aDoc);
  }

  /**
   * Apply validation and return the parsed SVRL object, optionally dispatching per-template events
   * to the supplied telemetry callback. The created SVRL is read directly from the SAX events of the
   * transformation, without building an SVRL DOM - unless debug mode or
   * {@link SchematronDebug#isShowCreatedSVRL()} is enabled, because the SVRL DOM is logged then.
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
   * @param bValidateSVRL
   *        If <code>true</code>, the produced SVRL is validated against the SVRL XML Schema while
   *        unmarshalling.
   * @param aTelemetry
   *        Optional per-template telemetry callback.
   * @return The parsed SVRL object, or <code>null</code> if validation could not be applied or the
   *         SVRL could not be read.
   * @throws TransformerException
   *         If the XSLT transformation fails.
   * @since 11.0.0
   */
  @Nullable
  public static SchematronOutputType applyToSVRL (@Nullable final ISchematronXSLTBasedProvider aProvider,
                                                  @NonNull final Source aSource,
                                                  @Nullable final ErrorListener aErrorListener,
                                                  @Nullable final URIResolver aURIResolver,
                                                  @Nullable final Map <String, ?> aParameters,
                                                  final boolean bValidateSVRL,
                                                  @Nullable final ISchematronTemplateTelemetry aTelemetry) throws TransformerException
  {
    ValueEnforcer.notNull (aSource, "Source");

    if (GlobalDebug.isDebugMode () || SchematronDebug.isShowCreatedSVRL ())
    {
      // The SVRL DOM is needed for logging
      return _readSVRL (applyValidation (aProvider, aSource, aErrorListener, aURIResolver, aParameters, aTelemetry),
                        bValidateSVRL);
    }

    final Transformer aTransformer = _createTransformer (aProvider,
                                                         aSource,
                                                         aErrorListener,
                                                         aURIResolver,
                                                         aParameters,
                                                         aTelemetry);
    if (aTransformer == null)
      return null;

    // The processor may convert the source into its own tree model
    final Source aEffectiveSource = aProvider.getXsltProcessor ().getEffectiveSource (aSource, aTransformer);

    // The unmarshaller "parses" by running the transformation
    final SAXSource aSVRLSource = new SAXSource (new SVRLTransformingXMLReader (aTransformer, aEffectiveSource),
                                                 new InputSource ());
    try
    {
      return new SVRLMarshaller ().setUseSchema (bValidateSVRL).read (aSVRLSource);
    }
    catch (final WrappedTransformerException ex)
    {
      throw ex.getTransformerException ();
    }
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
   * to the supplied telemetry callback. See
   * {@link #applyToSVRL(ISchematronXSLTBasedProvider, Source, ErrorListener, URIResolver, Map, boolean, ISchematronTemplateTelemetry)}.
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
                                                  @Nullable final ISchematronTemplateTelemetry aTelemetry) throws TransformerException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");
    final DOMSource aSource = new DOMSource (aXMLNode);
    aSource.setSystemId (sBaseURI);
    return applyToSVRL (aProvider, aSource, aErrorListener, aURIResolver, aParameters, bValidateSVRL, aTelemetry);
  }
}
