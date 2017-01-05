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
package com.helger.schematron.pure;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;
import javax.xml.transform.Source;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.charset.CharsetManager;
import com.helger.commons.io.IHasInputStream;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.resource.URLResource;
import com.helger.commons.io.resource.inmemory.AbstractMemoryReadableResource;
import com.helger.commons.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.commons.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.commons.state.EValidity;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.SchematronException;
import com.helger.schematron.SchematronResourceHelper;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.bound.PSBoundSchemaCache;
import com.helger.schematron.pure.bound.PSBoundSchemaCacheKey;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.exchange.PSWriter;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.svrl.SVRLWriter;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * A Schematron resource that is not XSLT based but using the pure (native Java)
 * implementation. This class itself is not thread safe, but the underlying
 * cache is thread safe. So once you configured this object fully (with all the
 * setter), it can be considered thread safe.<br>
 * <b>Important:</b> This class can <u>only</u> handle XPath expressions but no
 * XSLT functions in Schematron asserts and reports!
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourcePure extends AbstractSchematronResource
{
  private String m_sPhase;
  private IPSErrorHandler m_aErrorHandler;
  private XPathVariableResolver m_aVariableResolver;
  private XPathFunctionResolver m_aFunctionResolver;
  private EntityResolver m_aEntityResolver;
  // Status var
  private IPSBoundSchema m_aBoundSchema;

  public SchematronResourcePure (@Nonnull final IReadableResource aResource)
  {
    this (aResource, (String) null, (IPSErrorHandler) null);
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
  public String getPhase ()
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
  public SchematronResourcePure setPhase (@Nullable final String sPhase)
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
  public IPSErrorHandler getErrorHandler ()
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
  public SchematronResourcePure setErrorHandler (@Nullable final IPSErrorHandler aErrorHandler)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aErrorHandler = aErrorHandler;
    return this;
  }

  /**
   * @return The variable resolver to be used. May be <code>null</code>.
   */
  @Nullable
  public XPathVariableResolver getVariableResolver ()
  {
    return m_aVariableResolver;
  }

  /**
   * Set the variable resolver to be used in the XPath statements. This can only
   * be set before the Schematron is bound. If it is already bound an exception
   * is thrown to indicate the unnecessity of the call.
   *
   * @param aVariableResolver
   *        The variable resolver to set. May be <code>null</code>.
   * @return this
   */
  @Nonnull
  public SchematronResourcePure setVariableResolver (@Nullable final XPathVariableResolver aVariableResolver)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aVariableResolver = aVariableResolver;
    return this;
  }

  /**
   * @return The function resolver to be used. May be <code>null</code>.
   */
  @Nullable
  public XPathFunctionResolver getFunctionResolver ()
  {
    return m_aFunctionResolver;
  }

  /**
   * Set the function resolver to be used in the XPath statements. This can only
   * be set before the Schematron is bound. If it is already bound an exception
   * is thrown to indicate the unnecessity of the call.
   *
   * @param aFunctionResolver
   *        The function resolver to set. May be <code>null</code>.
   * @return this
   */
  @Nonnull
  public SchematronResourcePure setFunctionResolver (@Nullable final XPathFunctionResolver aFunctionResolver)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aFunctionResolver = aFunctionResolver;
    return this;
  }

  /**
   * @return The XML entity resolver to be used. May be <code>null</code>.
   * @since 4.1.1
   */
  @Nullable
  public EntityResolver getEntityResolver ()
  {
    return m_aEntityResolver;
  }

  /**
   * Set the XML entity resolver to be used when reading XML. This can only be
   * set before the Schematron is bound. If it is already bound an exception is
   * thrown to indicate the unnecessity of the call.
   *
   * @param aEntityResolver
   *        The function resolver to set. May be <code>null</code>.
   * @return this
   * @since 4.1.1
   */
  @Nonnull
  public SchematronResourcePure setEntityResolver (@Nullable final EntityResolver aEntityResolver)
  {
    if (m_aBoundSchema != null)
      throw new IllegalStateException ("Schematron was already bound and can therefore not be altered!");
    m_aEntityResolver = aEntityResolver;
    return this;
  }

  @Nonnull
  protected IPSBoundSchema createBoundSchema ()
  {
    final IReadableResource aResource = getResource ();
    final IPSErrorHandler aErrorHandler = getErrorHandler ();
    final PSBoundSchemaCacheKey aCacheKey = new PSBoundSchemaCacheKey (aResource,
                                                                       getPhase (),
                                                                       aErrorHandler,
                                                                       getVariableResolver (),
                                                                       getFunctionResolver (),
                                                                       getEntityResolver ());
    if (aResource instanceof AbstractMemoryReadableResource)
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

  @Nonnull
  protected IPSBoundSchema getOrCreateBoundSchema ()
  {
    if (m_aBoundSchema == null)
      try
      {
        m_aBoundSchema = createBoundSchema ();
      }
      catch (final RuntimeException ex)
      {
        if (m_aErrorHandler != null)
          m_aErrorHandler.error (getResource (), null, "Error creating bound schema", ex);
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

  /**
   * The main method to convert a node to an SVRL document.
   *
   * @param aXMLNode
   *        The source node to be validated. May not be <code>null</code>.
   * @return The SVRL document. Never <code>null</code>.
   * @throws SchematronException
   *         in case of a sever error validating the schema
   */
  @Nonnull
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Node aXMLNode) throws SchematronException
  {
    return getOrCreateBoundSchema ().validateComplete (aXMLNode);
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    if (!isValidSchematron ())
      return EValidity.INVALID;

    final Document aDoc = DOMReader.readXMLDOM (aXMLResource.getInputStream ());
    if (aDoc == null)
      throw new IllegalArgumentException ("Failed to read resource " + aXMLResource + " as XML");

    return getOrCreateBoundSchema ().validatePartially (aDoc);
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final Source aXMLSource) throws Exception
  {
    if (!isValidSchematron ())
      return EValidity.INVALID;

    // Convert Source to Node
    final Node aNode = SchematronResourceHelper.getNodeOfSource (aXMLSource);
    if (aNode == null)
      return EValidity.INVALID;

    return getOrCreateBoundSchema ().validatePartially (aNode);
  }

  @Nullable
  public Document applySchematronValidation (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    final SchematronOutputType aSO = applySchematronValidationToSVRL (aXMLResource);
    return aSO == null ? null : SVRLWriter.createXML (aSO);
  }

  @Nullable
  public Document applySchematronValidation (@Nonnull final Source aXMLSource) throws Exception
  {
    final SchematronOutputType aSO = applySchematronValidationToSVRL (aXMLSource);
    return aSO == null ? null : SVRLWriter.createXML (aSO);
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final IHasInputStream aXMLResource) throws Exception
  {
    ValueEnforcer.notNull (aXMLResource, "XMLResource");

    if (!isValidSchematron ())
      return null;

    final InputStream aIS = aXMLResource.getInputStream ();
    if (aIS == null)
      return null;

    final Document aDoc = DOMReader.readXMLDOM (aIS);
    if (aDoc == null)
      throw new IllegalArgumentException ("Failed to read resource " + aXMLResource + " as XML");

    return applySchematronValidationToSVRL (aDoc);
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Source aXMLSource) throws Exception
  {
    ValueEnforcer.notNull (aXMLSource, "XMLSource");

    if (!isValidSchematron ())
      return null;

    // Convert to Node
    final Node aNode = SchematronResourceHelper.getNodeOfSource (aXMLSource);
    if (aNode == null)
      return null;

    return applySchematronValidationToSVRL (aNode);
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
   * @param aSchematronIS
   *        The {@link InputStream} to read the Schematron rules from. May not
   *        be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromInputStream (@Nonnull final InputStream aSchematronIS)
  {
    return new SchematronResourcePure (new ReadableResourceInputStream (aSchematronIS));
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
    return fromByteArray (CharsetManager.getAsBytes (sSchematron, aCharset));
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
