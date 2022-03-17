/*
 * Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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
package com.helger.schematron.sch;

import java.io.File;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.annotation.OverrideOnDemand;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.resource.URLResource;
import com.helger.commons.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.commons.io.resource.inmemory.ReadableResourceInputStream;
import com.helger.schematron.api.xslt.AbstractSchematronXSLTBasedResource;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;

/**
 * A Schematron resource that is based on the original SCH file.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class SchematronResourceSCH extends AbstractSchematronXSLTBasedResource <SchematronResourceSCH>
{
  private String m_sPhase;
  private String m_sLanguageCode;
  private boolean m_bForceCacheResult = TransformerCustomizerSCH.DEFAULT_FORCE_CACHE_RESULT;

  /**
   * Constructor
   *
   * @param aSCHResource
   *        The Schematron resource. May not be <code>null</code>.
   */
  public SchematronResourceSCH (@Nonnull final IReadableResource aSCHResource)
  {
    super (aSCHResource);
  }

  @Nullable
  public final String getPhase ()
  {
    return m_sPhase;
  }

  public final void setPhase (@Nullable final String sPhase)
  {
    m_sPhase = sPhase;
  }

  @Nullable
  public final String getLanguageCode ()
  {
    return m_sLanguageCode;
  }

  public final void setLanguageCode (@Nullable final String sLanguageCode)
  {
    m_sLanguageCode = sLanguageCode;
  }

  /**
   * @return <code>true</code> if internal caching of the result should be
   *         forced, <code>false</code> if not.
   * @since 5.2.1
   */
  public final boolean isForceCacheResult ()
  {
    return m_bForceCacheResult;
  }

  /**
   * Force the caching of results. This only applies when Schematron to XSLT
   * conversion is performed.
   *
   * @param bForceCacheResult
   *        <code>true</code> to force result caching, <code>false</code> to
   *        cache only if no parameters are present.
   * @since 5.2.1
   */
  public final void setForceCacheResult (final boolean bForceCacheResult)
  {
    m_bForceCacheResult = bForceCacheResult;
  }

  @Nonnull
  protected final TransformerCustomizerSCH applyDefaultValuesOnTransformerCustomizer (@Nonnull final TransformerCustomizerSCH aTC)
  {
    ValueEnforcer.notNull (aTC, "TransformerCustomizer");
    aTC.setErrorListener (getErrorListener ())
       .setURIResolver (getURIResolver ())
       .setParameters (parameters ())
       .setPhase (m_sPhase)
       .setLanguageCode (m_sLanguageCode)
       .setForceCacheResult (m_bForceCacheResult);
    return aTC;
  }

  @Nonnull
  @OverrideOnDemand
  protected TransformerCustomizerSCH createTransformerCustomizer ()
  {
    return applyDefaultValuesOnTransformerCustomizer (new TransformerCustomizerSCH ());
  }

  @Override
  @Nullable
  public ISchematronXSLTBasedProvider getXSLTProvider ()
  {
    final TransformerCustomizerSCH aTransformerCustomizer = createTransformerCustomizer ();
    if (isUseCache ())
      return SchematronResourceSCHCache.getSchematronXSLTProvider (getResource (), aTransformerCustomizer);

    // Always create a new one
    return SchematronResourceSCHCache.createSchematronXSLTProvider (getResource (), aTransformerCustomizer);
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The classpath relative path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @param aClassLoader
   *        The class loader to be used to retrieve the classpath resource. May
   *        be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.0.4
   */
  @Nonnull
  public static SchematronResourceSCH fromClassPath (@Nonnull @Nonempty final String sSCHPath, @Nullable final ClassLoader aClassLoader)
  {
    return new SchematronResourceSCH (new ClassPathResource (sSCHPath, aClassLoader));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param sSCHPath
   *        The file system path to the Schematron file. May neither be
   *        <code>null</code> nor empty.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull @Nonempty final String sSCHPath)
  {
    return new SchematronResourceSCH (new FileSystemResource (sSCHPath));
  }

  /**
   * Create a new Schematron resource.
   *
   * @param aSCHFile
   *        The Schematron file. May not be <code>null</code>.
   * @return Never <code>null</code>.
   */
  @Nonnull
  public static SchematronResourceSCH fromFile (@Nonnull final File aSCHFile)
  {
    return new SchematronResourceSCH (new FileSystemResource (aSCHFile));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided
   * at a URL
   *
   * @param sSCHURL
   *        The URL to the Schematron rules. May neither be <code>null</code>
   *        nor empty.
   * @return Never <code>null</code>.
   * @throws MalformedURLException
   *         In case an invalid URL is provided
   * @since 6.2.6
   */
  @Nonnull
  public static SchematronResourceSCH fromURL (@Nonnull @Nonempty final String sSCHURL) throws MalformedURLException
  {
    return new SchematronResourceSCH (new URLResource (sSCHURL));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided
   * at a URL
   *
   * @param aSCHURL
   *        The URL to the Schematron rules. May not be <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.6
   */
  @Nonnull
  public static SchematronResourceSCH fromURL (@Nonnull final URL aSCHURL)
  {
    return new SchematronResourceSCH (new URLResource (aSCHURL));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided
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
   * @since 6.2.6
   */
  @Nonnull
  public static SchematronResourceSCH fromInputStream (@Nonnull @Nonempty final String sResourceID,
                                                       @Nonnull final InputStream aSchematronIS)
  {
    return new SchematronResourceSCH (new ReadableResourceInputStream (sResourceID, aSchematronIS));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided
   * by an arbitrary byte array.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param aSchematron
   *        The byte array representing the Schematron. May not be
   *        <code>null</code>.
   * @return Never <code>null</code>.
   * @since 6.2.6
   */
  @Nonnull
  public static SchematronResourceSCH fromByteArray (@Nonnull final byte [] aSchematron)
  {
    return new SchematronResourceSCH (new ReadableResourceByteArray (aSchematron));
  }

  /**
   * Create a new {@link SchematronResourceSCH} from Schematron rules provided
   * by an arbitrary String.<br>
   * <b>Important:</b> in this case, no include resolution will be performed!!
   *
   * @param sSchematron
   *        The String representing the Schematron. May not be <code>null</code>
   *        .
   * @param aCharset
   *        The charset to be used to convert the String to a byte array.
   * @return Never <code>null</code>.
   * @since 6.2.6
   */
  @Nonnull
  public static SchematronResourceSCH fromString (@Nonnull final String sSchematron, @Nonnull final Charset aCharset)
  {
    return fromByteArray (sSchematron.getBytes (aCharset));
  }
}
