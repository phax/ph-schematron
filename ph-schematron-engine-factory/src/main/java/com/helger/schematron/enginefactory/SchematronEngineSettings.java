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
package com.helger.schematron.enginefactory;

import java.util.Map;

import javax.xml.transform.URIResolver;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.xml.sax.EntityResolver;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsLinkedHashMap;
import com.helger.collection.commons.ICommonsOrderedMap;
import com.helger.schematron.CSchematron;
import com.helger.schematron.ESchematronEngine;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.sch.SchematronSCHConfig;

/**
 * The settings to create a Schematron resource or an XSLT with {@link SchematronEngineFactory}.
 * Settings an engine does not support are ignored by it.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
public class SchematronEngineSettings
{
  public static final ESchematronEngine DEFAULT_ENGINE = ESchematronEngine.ISO_SCHEMATRON;

  private ESchematronEngine m_eEngine = DEFAULT_ENGINE;
  private ISchematronXsltProcessor m_aXsltProcessor;
  private String m_sPhase;
  private String m_sLanguageCode;
  private final ICommonsOrderedMap <String, String> m_aParameters = new CommonsLinkedHashMap <> ();
  private boolean m_bForceCacheResult = SchematronSCHConfig.DEFAULT_FORCE_CACHE_RESULT;
  private boolean m_bLenient = CSchematron.DEFAULT_ALLOW_DEPRECATED_NAMESPACES;
  private URIResolver m_aURIResolver;
  private EntityResolver m_aEntityResolver;

  public SchematronEngineSettings ()
  {}

  /**
   * @return The engine to use. Never <code>null</code>. Default is {@link #DEFAULT_ENGINE}.
   */
  @NonNull
  public ESchematronEngine getEngine ()
  {
    return m_eEngine;
  }

  @NonNull
  public SchematronEngineSettings setEngine (@NonNull final ESchematronEngine eEngine)
  {
    ValueEnforcer.notNull (eEngine, "Engine");
    m_eEngine = eEngine;
    return this;
  }

  /**
   * @return The XSLT processor of the XSLT based engines. May be <code>null</code> to use the
   *         default one.
   */
  @Nullable
  public ISchematronXsltProcessor getXsltProcessor ()
  {
    return m_aXsltProcessor;
  }

  @NonNull
  public SchematronEngineSettings setXsltProcessor (@Nullable final ISchematronXsltProcessor aXsltProcessor)
  {
    m_aXsltProcessor = aXsltProcessor;
    return this;
  }

  /**
   * @return The phase to use. May be <code>null</code> to use the default phase. Not used by the
   *         engine {@link ESchematronEngine#XSLT_PREBUILT}.
   */
  @Nullable
  public String getPhase ()
  {
    return m_sPhase;
  }

  @NonNull
  public SchematronEngineSettings setPhase (@Nullable final String sPhase)
  {
    m_sPhase = sPhase;
    return this;
  }

  /**
   * @return The language code to use. May be <code>null</code> for the default (English). Only
   *         used by the engines {@link ESchematronEngine#ISO_SCHEMATRON},
   *         {@link ESchematronEngine#SCHXSLT1} and {@link ESchematronEngine#SCHXSLT2}.
   */
  @Nullable
  public String getLanguageCode ()
  {
    return m_sLanguageCode;
  }

  @NonNull
  public SchematronEngineSettings setLanguageCode (@Nullable final String sLanguageCode)
  {
    m_sLanguageCode = sLanguageCode;
    return this;
  }

  /**
   * @return A copy of the custom XSLT parameters. Never <code>null</code>. Only used by the XSLT
   *         based engines except {@link ESchematronEngine#PURE_XSLT}.
   */
  @NonNull
  @ReturnsMutableCopy
  public ICommonsOrderedMap <String, String> getAllParameters ()
  {
    return m_aParameters.getClone ();
  }

  @NonNull
  public SchematronEngineSettings setParameters (@Nullable final Map <String, String> aParameters)
  {
    m_aParameters.clear ();
    if (aParameters != null)
      m_aParameters.putAll (aParameters);
    return this;
  }

  /**
   * @return <code>true</code> if the result of the SCH to XSLT conversion is cached also if a
   *         custom error listener or URI resolver is present. Default is
   *         {@link SchematronSCHConfig#DEFAULT_FORCE_CACHE_RESULT}.
   */
  public boolean isForceCacheResult ()
  {
    return m_bForceCacheResult;
  }

  @NonNull
  public SchematronEngineSettings setForceCacheResult (final boolean bForceCacheResult)
  {
    m_bForceCacheResult = bForceCacheResult;
    return this;
  }

  /**
   * @return <code>true</code> if deprecated Schematron namespace URIs are accepted. Only used by the
   *         engine {@link ESchematronEngine#PURE_XPATH}.
   */
  public boolean isLenient ()
  {
    return m_bLenient;
  }

  @NonNull
  public SchematronEngineSettings setLenient (final boolean bLenient)
  {
    m_bLenient = bLenient;
    return this;
  }

  /**
   * @return The URI resolver to use. May be <code>null</code>. Not used by the engines
   *         {@link ESchematronEngine#PURE_XPATH} and {@link ESchematronEngine#PURE_XSLT}.
   */
  @Nullable
  public URIResolver getURIResolver ()
  {
    return m_aURIResolver;
  }

  @NonNull
  public SchematronEngineSettings setURIResolver (@Nullable final URIResolver aURIResolver)
  {
    m_aURIResolver = aURIResolver;
    return this;
  }

  /**
   * @return The entity resolver to use. May be <code>null</code>. Not used by the engine
   *         {@link ESchematronEngine#PURE_XSLT}.
   */
  @Nullable
  public EntityResolver getEntityResolver ()
  {
    return m_aEntityResolver;
  }

  @NonNull
  public SchematronEngineSettings setEntityResolver (@Nullable final EntityResolver aEntityResolver)
  {
    m_aEntityResolver = aEntityResolver;
    return this;
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (null).append ("Engine", m_eEngine)
                                       .append ("XsltProcessor", m_aXsltProcessor)
                                       .append ("Phase", m_sPhase)
                                       .append ("LanguageCode", m_sLanguageCode)
                                       .append ("Parameters", m_aParameters)
                                       .append ("ForceCacheResult", m_bForceCacheResult)
                                       .append ("Lenient", m_bLenient)
                                       .append ("URIResolver", m_aURIResolver)
                                       .append ("EntityResolver", m_aEntityResolver)
                                       .getToString ();
  }
}
