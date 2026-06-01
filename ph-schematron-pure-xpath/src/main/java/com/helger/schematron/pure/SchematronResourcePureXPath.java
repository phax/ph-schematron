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
package com.helger.schematron.pure;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.URLResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.exchange.PSWriter;
import com.helger.schematron.model.PSSchema;

/**
 * Canonical name for the pure-Java XPath-driven Schematron engine, introduced in v10.0.0. Identical
 * behaviour to the older {@link SchematronResourcePure} (which remains as a deprecated alias for
 * source compatibility) &mdash; this class only differs in name. Use {@code PureXPath} in new code
 * to make the engine choice obvious alongside {@code SchematronResourcePureXslt} (the Saxon-native
 * XSLT engine) and {@code SchematronResourceSCH} / {@code SchematronResourceXSLT} (the ISO-XSLT
 * engines).
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@SuppressWarnings ("deprecation")
@NotThreadSafe
public class SchematronResourcePureXPath extends SchematronResourcePure
{
  /**
   * Create a new resource around the given Schematron source.
   *
   * @param aResource
   *        The Schematron source to read from. May not be <code>null</code>.
   */
  public SchematronResourcePureXPath (@NonNull final IReadableResource aResource)
  {
    super (aResource);
  }

  /**
   * Create a new resource around the given Schematron source, pre-configured with phase and error
   * handler.
   *
   * @param aResource
   *        The Schematron source to read from. May not be <code>null</code>.
   * @param sPhase
   *        The phase to use. May be <code>null</code> for "all".
   * @param aErrorHandler
   *        Error handler used during binding. May be <code>null</code>.
   */
  public SchematronResourcePureXPath (@NonNull final IReadableResource aResource,
                                      @Nullable final String sPhase,
                                      @Nullable final IPSErrorHandler aErrorHandler)
  {
    super (aResource, sPhase, aErrorHandler);
  }

  // === covariant static factories so chains like fromFile(f).setPhase(...) return the new type ===

  /**
   * @param sSCHPath
   *        The classpath-relative Schematron path. Never <code>null</code> nor empty.
   * @return A new {@link SchematronResourcePureXPath} reading from the classpath. Never
   *         <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromClassPath (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePureXPath (new ClassPathResource (sSCHPath));
  }

  /**
   * @param sSCHPath
   *        The classpath-relative Schematron path. Never <code>null</code> nor empty.
   * @param aClassLoader
   *        The class loader to resolve the path with. May be <code>null</code> to use the default.
   * @return A new {@link SchematronResourcePureXPath} reading from the classpath. Never
   *         <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromClassPath (@NonNull @Nonempty final String sSCHPath,
                                                           @Nullable final ClassLoader aClassLoader)
  {
    return new SchematronResourcePureXPath (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * @param sSCHPath
   *        Filesystem path to the Schematron file. Never <code>null</code> nor empty.
   * @return A new {@link SchematronResourcePureXPath} reading from the file. Never
   *         <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromFile (@NonNull @Nonempty final String sSCHPath)
  {
    return new SchematronResourcePureXPath (new FileSystemResource (sSCHPath));
  }

  /**
   * @param aSCHFile
   *        The Schematron file. Never <code>null</code>.
   * @return A new {@link SchematronResourcePureXPath} reading from the file. Never
   *         <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromFile (@NonNull final File aSCHFile)
  {
    return new SchematronResourcePureXPath (new FileSystemResource (aSCHFile));
  }

  /**
   * @param sSCHURL
   *        A textual URL pointing at the Schematron source. Never <code>null</code> nor empty.
   * @return A new {@link SchematronResourcePureXPath} reading from that URL. Never
   *         <code>null</code>.
   * @throws MalformedURLException
   *         If {@code sSCHURL} is not a syntactically valid URL.
   */
  @NonNull
  public static SchematronResourcePureXPath fromURL (@NonNull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourcePureXPath (new URLResource (sSCHURL));
  }

  /**
   * @param aSCHURL
   *        The URL pointing at the Schematron source. Never <code>null</code>.
   * @return A new {@link SchematronResourcePureXPath} reading from that URL. Never
   *         <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromURL (@NonNull final URL aSCHURL)
  {
    return new SchematronResourcePureXPath (new URLResource (aSCHURL));
  }

  /**
   * @param sResourceID
   *        Logical id used to identify the in-memory source in diagnostics. Never <code>null</code>
   *        nor empty.
   * @param aSchematronIS
   *        The Schematron source stream. Never <code>null</code>. Consumed by the resource.
   * @return A new {@link SchematronResourcePureXPath} reading from the stream. Never
   *         <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromInputStream (@NonNull @Nonempty final String sResourceID,
                                                             @NonNull final InputStream aSchematronIS)
  {
    return new SchematronResourcePureXPath (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  /**
   * @param aSchematron
   *        The Schematron source bytes. Never <code>null</code>.
   * @return A new {@link SchematronResourcePureXPath} reading from the byte array. Never
   *         <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromByteArray (@NonNull final byte [] aSchematron)
  {
    return new SchematronResourcePureXPath (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * @param sSchematron
   *        The Schematron source string. Never <code>null</code>.
   * @param aCharset
   *        The character set used to encode the string to bytes. Never <code>null</code>.
   * @return A new {@link SchematronResourcePureXPath} reading from the encoded string. Never
   *         <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromString (@NonNull final String sSchematron, @NonNull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }

  /**
   * @param aSchematron
   *        An already-parsed Schematron schema. Never <code>null</code>.
   * @return A new {@link SchematronResourcePureXPath} backed by a UTF-8 serialization of the given
   *         schema. Never <code>null</code>.
   */
  @NonNull
  public static SchematronResourcePureXPath fromSchema (@NonNull final PSSchema aSchematron)
  {
    return fromString (new PSWriter ().getXMLStringNotNull (aSchematron), StandardCharsets.UTF_8);
  }
}
