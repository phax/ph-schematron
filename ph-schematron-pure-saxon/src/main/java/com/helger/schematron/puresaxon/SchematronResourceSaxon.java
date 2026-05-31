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
package com.helger.schematron.puresaxon;

import java.io.File;
import java.io.InputStream;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;

import javax.xml.parsers.DocumentBuilderFactory;
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
import com.helger.schematron.puresaxon.xslt.XsltStylesheetGenerator;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.serialize.write.XMLWriterSettings;

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
 * <b>Phase 1 status:</b> handles {@code <sch:ns>}, {@code <sch:pattern>}, {@code <sch:rule>},
 * {@code <sch:assert>} with plain text content. Reports, lets, phases, value-of, names,
 * diagnostics and abstract patterns are not yet supported and will be silently skipped (logged at
 * WARN level by the generator).
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@NotThreadSafe
public class SchematronResourceSaxon extends AbstractSchematronResource
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceSaxon.class);

  private String m_sPhase;
  private IPSErrorHandler m_aErrorHandler = new LoggingPSErrorHandler ();
  private Processor m_aProcessor = new Processor (false);
  // Status vars
  private PSSchema m_aSchema;
  private XsltExecutable m_aCompiledXslt;

  public SchematronResourceSaxon (@NonNull final IReadableResource aResource)
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
  public final SchematronResourceSaxon setPhase (@Nullable final String sPhase)
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
  public final SchematronResourceSaxon setErrorHandler (@NonNull final IPSErrorHandler aErrorHandler)
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
  public final SchematronResourceSaxon setProcessor (@NonNull final Processor aProcessor)
  {
    ValueEnforcer.notNull (aProcessor, "Processor");
    if (m_aCompiledXslt != null)
      throw new IllegalStateException ("Schematron was already compiled and can therefore not be altered!");
    m_aProcessor = aProcessor;
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
      final PSSchema aSchema = getOrReadSchema ();
      final IMicroDocument aXsltDoc = XsltStylesheetGenerator.generate (aSchema);
      final MapBasedNamespaceContext aNsCtx = XsltStylesheetGenerator.namespaceContextFor (aSchema);
      final XMLWriterSettings aWriterSettings = new XMLWriterSettings ().setNamespaceContext (aNsCtx);
      final String sXslt = MicroWriter.getNodeAsString (aXsltDoc, aWriterSettings);
      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Generated XSLT for Saxon-native validation:\n" + sXslt);

      final XsltCompiler aCompiler = m_aProcessor.newXsltCompiler ();
      m_aCompiledXslt = aCompiler.compile (new StreamSource (new StringReader (sXslt)));
    }
    return m_aCompiledXslt;
  }

  @Override
  @NonNull
  public EValidity getSchematronValidity (@NonNull final Node aXMLNode, @Nullable final String sBaseURI) throws Exception
  {
    final SchematronOutputType aSVRL = applySchematronValidationToSVRL (aXMLNode, sBaseURI);
    if (aSVRL == null)
      return EValidity.INVALID;
    for (final Object aObj : aSVRL.getActivePatternAndFiredRuleAndFailedAssert ())
      if (aObj instanceof com.helger.schematron.svrl.jaxb.FailedAssert)
        return EValidity.INVALID;
    return EValidity.VALID;
  }

  @Override
  @Nullable
  public Document applySchematronValidation (@NonNull final Node aXMLNode, @Nullable final String sBaseURI) throws Exception
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
    final XsltExecutable aExecutable = getOrCompileXslt ();
    final Document aResultDoc = DocumentBuilderFactory.newInstance ().newDocumentBuilder ().newDocument ();
    final DOMDestination aDestination = new DOMDestination (aResultDoc);

    final var aTransformer = aExecutable.load30 ();
    if (sBaseURI != null)
      aTransformer.setGlobalContextItem (m_aProcessor.newDocumentBuilder ().wrap (aXMLNode));
    aTransformer.applyTemplates (new DOMSource (aXMLNode, sBaseURI), aDestination);

    final SchematronOutputType aSVRL = new SVRLMarshaller (false).read (aResultDoc);
    if (aSVRL == null)
      throw new IllegalStateException ("Saxon transformation did not produce a parseable SVRL document");
    return aSVRL;
  }

  // --- factory methods ---

  @NonNull
  public static SchematronResourceSaxon fromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourceSaxon (new ClassPathResource (sSCHPath));
  }

  @NonNull
  public static SchematronResourceSaxon fromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourceSaxon (new FileSystemResource (sSCHPath));
  }

  @NonNull
  public static SchematronResourceSaxon fromFile (@NonNull final File aSCHFile)
  {
    return new SchematronResourceSaxon (new FileSystemResource (aSCHFile));
  }

  @NonNull
  public static SchematronResourceSaxon fromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourceSaxon (new URLResource (sSCHURL));
  }

  @NonNull
  public static SchematronResourceSaxon fromURL (@NonNull final URL aSCHURL)
  {
    return new SchematronResourceSaxon (new URLResource (aSCHURL));
  }

  @NonNull
  public static SchematronResourceSaxon fromInputStream (@NonNull @Nonempty final String sResourceID,
                                                         @NonNull final InputStream aSchematronIS)
  {
    return new SchematronResourceSaxon (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  @NonNull
  public static SchematronResourceSaxon fromByteArray (@NonNull final byte [] aSchematron)
  {
    return new SchematronResourceSaxon (new ReadableResourceByteArray (aSchematron));
  }

  @NonNull
  public static SchematronResourceSaxon fromString (@NonNull final String sSchematron, @NonNull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }
}
