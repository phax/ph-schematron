/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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
import java.io.Reader;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;
import javax.xml.transform.Source;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotations.Nonempty;
import com.helger.commons.annotations.UnsupportedOperation;
import com.helger.commons.collections.ArrayHelper;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.URLResource;
import com.helger.commons.io.streams.NonBlockingByteArrayInputStream;
import com.helger.commons.io.streams.StreamUtils;
import com.helger.commons.state.EValidity;
import com.helger.commons.xml.serialize.DOMReader;
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.SchematronException;
import com.helger.schematron.SchematronUtils;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.bound.PSBoundSchemaCache;
import com.helger.schematron.pure.bound.PSBoundSchemaCacheKey;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.svrl.SVRLWriter;

/**
 * A Schematron resource that is not XSLT based but using the pure (native Java)
 * implementation.
 *
 * @author Philip Helger
 */
@Immutable
public class SchematronResourcePure extends AbstractSchematronResource
{
  // TODO move to ph-commons
  private static abstract class AbstractMemoryReadableResource implements IReadableResource
  {
    public AbstractMemoryReadableResource ()
    {}

    @Nonnull
    public String getPath ()
    {
      return "";
    }

    @Nullable
    public URL getAsURL ()
    {
      return null;
    }

    @Nullable
    public File getAsFile ()
    {
      return null;
    }

    public boolean exists ()
    {
      return true;
    }

    @Nullable
    public Reader getReader (@Nonnull final Charset aCharset)
    {
      return StreamUtils.createReader (getInputStream (), aCharset);
    }

    @Nullable
    @Deprecated
    public Reader getReader (@Nonnull final String sCharset)
    {
      return StreamUtils.createReader (getInputStream (), sCharset);
    }

    @Nonnull
    @UnsupportedOperation
    public IReadableResource getReadableCloneForPath (@Nonnull final String sPath)
    {
      throw new UnsupportedOperationException ();
    }
  }

  private static class ReadableResourceInputStream extends AbstractMemoryReadableResource
  {
    private final InputStream m_aIS;

    public ReadableResourceInputStream (@Nonnull final InputStream aIS)
    {
      m_aIS = ValueEnforcer.notNull (aIS, "InputStream");
    }

    @Nonnull
    public String getResourceID ()
    {
      return "input-stream";
    }

    @Nullable
    public InputStream getInputStream ()
    {
      return m_aIS;
    }
  }

  private static class ReadableResourceByteArray extends AbstractMemoryReadableResource
  {
    private final byte [] m_aSchematron;

    public ReadableResourceByteArray (@Nonnull final byte [] aSchematron)
    {
      // Create a copy to avoid outside modifications
      m_aSchematron = ArrayHelper.getCopy (ValueEnforcer.notNull (aSchematron, "Schematron"));
    }

    @Nonnull
    public String getResourceID ()
    {
      return "byte[]";
    }

    @Nullable
    public InputStream getInputStream ()
    {
      return new NonBlockingByteArrayInputStream (m_aSchematron);
    }
  }

  private final PSBoundSchemaCacheKey m_aCacheKey;

  public SchematronResourcePure (@Nonnull final IReadableResource aResource)
  {
    this (aResource, (String) null, (IPSErrorHandler) null);
  }

  public SchematronResourcePure (@Nonnull final IReadableResource aResource,
                                 @Nullable final String sPhase,
                                 @Nullable final IPSErrorHandler aErrorHandler)
  {
    this (aResource, new PSBoundSchemaCacheKey (aResource, sPhase, aErrorHandler));
  }

  public SchematronResourcePure (@Nonnull final IReadableResource aResource,
                                 @Nonnull final PSBoundSchemaCacheKey aCacheKey)
  {
    super (aResource);
    m_aCacheKey = ValueEnforcer.notNull (aCacheKey, "CacheKey");
  }

  @Nonnull
  protected IPSBoundSchema getBoundSchema ()
  {
    // Resolve from cache - inside the cacheKey the reading and binding happens
    return PSBoundSchemaCache.getInstance ().getFromCache (m_aCacheKey);
  }

  public boolean isValidSchematron ()
  {
    return getBoundSchema ().getOriginalSchema ().isValid ();
  }

  /**
   * The main method to convert a node to an SVRL document.
   *
   * @param aNode
   *        The source node to be validated. May not be <code>null</code>.
   * @return The SVRL document. Never <code>null</code>.
   * @throws SchematronException
   *         in case of a sever error validating the schema
   */
  @Nonnull
  public SchematronOutputType applySchematronValidation (@Nonnull final Node aNode) throws SchematronException
  {
    return getBoundSchema ().validateComplete (aNode);
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final IReadableResource aXMLResource) throws Exception
  {
    if (!isValidSchematron ())
      return EValidity.INVALID;

    final Document aDoc = DOMReader.readXMLDOM (aXMLResource);
    if (aDoc == null)
      throw new IllegalArgumentException ("Failed to read resource " + aXMLResource + " as XML");

    return getBoundSchema ().validatePartially (aDoc);
  }

  @Nonnull
  public EValidity getSchematronValidity (@Nonnull final Source aXMLSource) throws Exception
  {
    if (!isValidSchematron ())
      return EValidity.INVALID;

    final Node aNode = SchematronUtils.getNodeOfSource (aXMLSource);
    if (aNode == null)
      return EValidity.INVALID;

    return getBoundSchema ().validatePartially (aNode);
  }

  @Nullable
  public Document applySchematronValidation (@Nonnull final IReadableResource aXMLResource) throws Exception
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
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final IReadableResource aXMLResource) throws Exception
  {
    ValueEnforcer.notNull (aXMLResource, "XMLResource");

    if (!isValidSchematron ())
      return null;

    if (!aXMLResource.exists ())
      return null;

    final Document aDoc = DOMReader.readXMLDOM (aXMLResource);
    if (aDoc == null)
      throw new IllegalArgumentException ("Failed to read resource " + aXMLResource + " as XML");

    return applySchematronValidation (aDoc);
  }

  @Nullable
  public SchematronOutputType applySchematronValidationToSVRL (@Nonnull final Source aXMLSource) throws Exception
  {
    ValueEnforcer.notNull (aXMLSource, "XMLSource");

    if (!isValidSchematron ())
      return null;

    // Convert to Node
    final Node aNode = SchematronUtils.getNodeOfSource (aXMLSource);
    if (aNode == null)
      return null;

    return applySchematronValidation (aNode);
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
   * @param aIS
   *        The {@link InputStream} to read the Schematron rules from. May not
   *        be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourcePure fromInputStream (@Nonnull final InputStream aIS)
  {
    return new SchematronResourcePure (new ReadableResourceInputStream (aIS));
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
}
