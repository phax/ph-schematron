/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.resource.URLResource;
import com.helger.commons.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.commons.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.api.xslt.AbstractSchematronXSLTBasedResource;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;

/**
 * A Schematron resource that is based on an existing, pre-compiled XSLT script.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourceXSLT extends AbstractSchematronXSLTBasedResource <SchematronResourceXSLT>
{
  /**
   * Constructor
   *
   * @param aXSLTResource
   *        The XSLT resource. May not be <code>null</code>.
   */
  public SchematronResourceXSLT (@Nonnull final IReadableResource aXSLTResource)
  {
    super (aXSLTResource);
  }

  @Override
  @Nullable
  public ISchematronXSLTBasedProvider getXSLTProvider ()
  {
    if (isUseCache ())
      return SchematronResourceXSLTCache.getSchematronXSLTProvider (getResource (), getErrorListener (), getURIResolver ());

    // Always create a new one
    return SchematronResourceXSLTCache.createSchematronXSLTProvider (getResource (), getErrorListener (), getURIResolver ());
  }

  @Nonnull
  public static SchematronResourceXSLT fromClassPath (@Nonnull @Nonempty final String sXSLTPath)
  {
    return new SchematronResourceXSLT (new ClassPathResource (sXSLTPath));
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull @Nonempty final String sXSLTPath)
  {
    return new SchematronResourceXSLT (new FileSystemResource (sXSLTPath));
  }

  @Nonnull
  public static SchematronResourceXSLT fromFile (@Nonnull final File aXSLTFile)
  {
    return new SchematronResourceXSLT (new FileSystemResource (aXSLTFile));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided
   * at a URL
   *
   * @param sSCHURL
   *        The URL to the XSLT Schematron rules. May neither be <code>null</code>
   *        nor empty.
   * @return Never <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   */
  @Nonnull
  public static SchematronResourceXSLT fromURL (@Nonnull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourceXSLT (new URLResource (sSCHURL));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided
   * at a URL
   *
   * @param aSCHURL
   *        The URL to the XSLT Schematron rules. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceXSLT fromURL (@Nonnull final URL aSCHURL)
  {
    return new SchematronResourceXSLT (new URLResource(aSCHURL));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided
   * by an arbitrary {@link InputStream}.<br>
   *
   * @param aSchematronIS
   *        The {@link InputStream} to read the XSLT Schematron rules from. May not
   *        be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceXSLT fromInputStream (@Nonnull final InputStream aSchematronIS)
  {
    return new SchematronResourceXSLT (new ReadableResourceInputStream(aSchematronIS));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided
   * by an arbitrary byte array.<br>
   *
   * @param aSchematron
   *        The byte array representing the XSLT Schematron. May not be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceXSLT fromByteArray (@Nonnull final byte [] aSchematron)
  {
    return new SchematronResourceXSLT (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * Create a new {@link SchematronResourceXSLT} from XSLT Schematron rules provided
   * by an arbitrary String.<br>
   *
   * @param sSchematron
   *        The String representing the XSLT Schematron. May not be <code>null</code>
   *        .
   * @param aCharset
   *        The charset to be used to convert the String to a byte array.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceXSLT fromString (@Nonnull final String sSchematron, @Nonnull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }
}
