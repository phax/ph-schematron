/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
import java.net.URL;
import java.nio.charset.Charset;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.location.SimpleLocation;
import com.helger.base.state.EValidity;
import com.helger.diagnostics.error.SingleError;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.AbstractMemoryReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.SchematronException;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.bound.PSBoundSchemaCache;
import com.helger.schematron.pure.bound.PSBoundSchemaCacheKey;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.exchange.PSWriter;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.serialize.write.XMLWriterSettings;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

/**
 * A Schematron resource that is not XSLT based but using the pure (native Java)
 * implementation. This class itself is not thread safe, but the underlying
 * cache is thread safe. So once you configured this object fully (with all the
 * setter), it can be considered thread safe.<br>
 * <b>Important:</b> This class can <u>only</u> handle XPath expressions but no
 * XSLT functions in Schematron asserts and reports! If your Schematrons use
 * XSLT functionality you're better off using the
 * <code>com.helger.schematron.sch.SchematronResourceSCH</code> or
 * <code>com.helger.schematron.xslt.SchematronResourceXSLT</code> classes
 * instead!
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourcePure extends AbstractSchematronResource
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourcePure.class);

  private String m_sPhase;
  private IPSErrorHandler m_aErrorHandler;
  private IPSValidationHandler m_aCustomValidationHandler;
  private IXPathConfig m_aXPathConfig = XPathConfigBuilder.DEFAULT;
  // Status var
  private IPSBoundSchema m_aBoundSchema;

  public SchematronResourcePure (@Nonnull final IReadableResource aResource)
  {
    super (aResource);
  }

  public SchematronResourcePure (@Nonnull final IReadableResource aResource,
                                 @Nullable final String sPhase,
                                 @Nullable final IPSErrorHandler aErrorHandler)
  {
    super (aResource);
    setPhase (sPhase);
    setErrorHandler (aErrorHandler);
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
   * Set the Schematron phase to be evaluated. Changing the phase will result in
   * a newly bound schema!
   *
   * @param sPhase
   *        The name of the phase to use. May be <code>null</code> which means
   *        all phases.
   * @return this
   */
  @Nonnull
  public final SchematronResourcePure setPhase (@Nullable final String sPhase)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_sPhase = sPhase;
    return this;
  }

  /**
   * @return The error handler to be used to bind the schema. May be
   *         <code>null</code>.
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
   */
  @Nonnull
  public final SchematronResourcePure setErrorHandler (@Nullable final IPSErrorHandler aErrorHandler)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aErrorHandler = aErrorHandler;
    return this;
  }

  /**
   * @return The custom validation handler to be used to bind the schema. May be
   *         <code>null</code>.
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
   */
  @Nonnull
  public final SchematronResourcePure setCustomValidationHandler (@Nullable final IPSValidationHandler aCustomValidationHandler)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aCustomValidationHandler = aCustomValidationHandler;
    return this;
  }

  /**
   * @return The contained {@link IXPathConfig}. Never <code>null</code>.
   * @since v8
   */
  @Nonnull
  public final IXPathConfig getXPathConfig ()
  {
    return m_aXPathConfig;
  }

  /**
   * Set the {@link XPathConfig} to be used in the XPath statements. This can
   * only be set before the Schematron is bound. If it is already bound an
   * exception is thrown to indicate the unnecessity of the call.
   *
   * @param aXPathConfig
   *        The XPath config to set. May be <code>null</code>.
   * @return this
   */
  @Nonnull
  public final SchematronResourcePure setXPathConfig (@Nonnull final IXPathConfig aXPathConfig)
  {
    ValueEnforcer.notNull (aXPathConfig, "XPathConfig");
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aXPathConfig = aXPathConfig;
    return this;
  }

  /**
   * Set the XML entity resolver to be used when reading the Schematron or the
   * XML to be validated. This can only be set before the Schematron is bound.
   * If it is already bound an exception is thrown to indicate the unnecessity
   * of the call.
   *
   * @param aEntityResolver
   *        The entity resolver to set. May be <code>null</code>.
   * @return this
   * @since 4.1.1
   */
  @Nonnull
  public SchematronResourcePure setEntityResolver (@Nullable final EntityResolver aEntityResolver)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    internalSetEntityResolver (aEntityResolver);
    return this;
  }

  @Nonnull
  protected IPSBoundSchema createBoundSchema ()
  {
    final IReadableResource aResource = getResource ();
    final PSBoundSchemaCacheKey aCacheKey = new PSBoundSchemaCacheKey (aResource,
                                                                       m_sPhase,
                                                                       m_aErrorHandler,
                                                                       m_aCustomValidationHandler,
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
  @Nonnull
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
          m_aErrorHandler.handleError (SingleError.builderError ()
                                                  .errorLocation (new SimpleLocation (getResource ().getPath ()))
                                                  .errorText ("Error creating bound schema")
                                                  .linkedException (ex)
                                                  .build ());
        throw ex;
      }

    return m_aBoundSchema;
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
   * Use the internal error handler to validate all elements in the schematron.
   * It tries to catch as many errors as possible.
   */
  public void validateCompletely ()
  {
    // Use the provided error handler (if any)
    final IPSErrorHandler aErrorHandler = m_aErrorHandler != null ? m_aErrorHandler : new DoNothingPSErrorHandler ();
    validateCompletely (aErrorHandler);
  }

  /**
   * Use the provided error handler to validate all elements in the schematron.
   * It tries to catch as many errors as possible.
   *
   * @param aErrorHandler
   *        The error handler to use. May not be <code>null</code>.
   */
  public void validateCompletely (@Nonnull final IPSErrorHandler aErrorHandler)
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

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final Node aXMLNode,
                                          @Nullable final String sBaseURI) throws Exception
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
   *        Base URI of the XML document to be validated. May be
   *        <code>null</code>.
   * @return The SVRL document. Never <code>null</code>.
   * @throws SchematronException
   *         in case of a sever error validating the schema
   */
  @Nonnull
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Node aXMLNode,
                                                               @Nullable final String sBaseURI) throws SchematronException
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    final SchematronOutputType aSOT = getOrCreateBoundSchema ().validateComplete (aXMLNode, sBaseURI);

    // Debug print the created SVRL document
    if (SchematronDebug.isShowCreatedSVRL ())
      LOGGER.info ("Created SVRL:\n" + new SVRLMarshaller (false).getAsString (aSOT));

    return aSOT;
  }

  @Nullable
  public Document applySchematronValidation (@Nonnull final Node aXMLNode,
                                             @Nullable final String sBaseURI) throws Exception
  {
    ValueEnforcer.notNull (aXMLNode, "XMLNode");

    final SchematronOutputType aSO = applySchematronValidationToSVRL (aXMLNode, sBaseURI);
    return new SVRLMarshaller ().getAsDocument (aSO);
  }

  /**
   * Create a new {@link SchematronResourcePure} from a Classpath Schematron
   * rules
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron rules.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromClassPath (@Nonnull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePure (new ClassPathResource (sSCHPath));
  }

  /**
   * Create a new {@link SchematronResourcePure} from a Classpath Schematron
   * rules
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron rules.
   * @param aClassLoader
   *        The class loader to be used to retrieve the classpath resource. May
   *        be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.0.4
   */
  @Nonnull
  public static SchematronResourcePure fromClassPath (@Nonnull @Nonempty final String sSCHPath,
                                                      @Nullable final ClassLoader aClassLoader)
  {
    return new SchematronResourcePure (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * Create a new {@link SchematronResourcePure} from file system Schematron
   * rules
   *
   * @param sSCHPath
   *        The file system path to the Schematron rules.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromFile (@Nonnull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePure (new FileSystemResource (sSCHPath));
  }

  /**
   * Create a new {@link SchematronResourcePure} from file system Schematron
   * rules
   *
   * @param aSCHFile
   *        The file system path to the Schematron rules.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromFile (@Nonnull final File aSCHFile)
  {
    return new SchematronResourcePure (new FileSystemResource (aSCHFile));
  }

  /**
   * Create a new {@link SchematronResourcePure} from Schematron rules provided
   * at a URL
   *
   * @param sSCHURL
   *        The URL to the Schematron rules. May neither be <code>null</code>
   *        nor empty.
   * @return Never <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   */
  @Nonnull
  public static SchematronResourcePure fromURL (@Nonnull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourcePure (new URLResource (sSCHURL));
  }

  /**
   * Create a new {@link SchematronResourcePure} from Schematron rules provided
   * at a URL
   *
   * @param aSCHURL
   *        The URL to the Schematron rules. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromURL (@Nonnull final URL aSCHURL)
  {
    return new SchematronResourcePure (new URLResource (aSCHURL));
  }

  /**
   * Create a new {@link SchematronResourcePure} from Schematron rules provided
   * by an arbitrary {@link InputStream}.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param sResourceID
   *        Resource ID to be used as the cache key. Should neither be
   *        <code>null</code> nor empty.
   * @param aSchematronIS
   *        The {@link InputStream} to read the Schematron rules from. May not
   *        be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.5
   */
  @Nonnull
  public static SchematronResourcePure fromInputStream (@Nonnull @Nonempty final String sResourceID,
                                                        @Nonnull final InputStream aSchematronIS)
  {
    return new SchematronResourcePure (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  /**
   * Create a new {@link SchematronResourcePure} from Schematron rules provided
   * by an arbitrary byte array.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param aSchematron
   *        The byte array representing the Schematron. May not be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromByteArray (@Nonnull final byte [] aSchematron)
  {
    return new SchematronResourcePure (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * Create a new {@link SchematronResourcePure} from Schematron rules provided
   * by an arbitrary String.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param sSchematron
   *        The String representing the Schematron. May not be <code>null</code>
   *        .
   * @param aCharset
   *        The charset to be used to convert the String to a byte array.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromString (@Nonnull final String sSchematron, @Nonnull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }

  /**
   * Create a new {@link SchematronResourcePure} from Schematron rules provided
   * by a domain model.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param aSchematron
   *        The Schematron model to be used. May not be <code>null</code> .
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromSchema (@Nonnull final PSSchema aSchematron)
  {
    return fromString (new PSWriter ().getXMLString (aSchematron), XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
  }
}
