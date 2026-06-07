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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.schematron.api.cache.AbstractSchematronCache;
import com.helger.schematron.pure.bound.IPSBoundSchema;

/**
 * Cache for compiled {@link IPSBoundSchema} instances produced from {@link SchematronPureXPathConfig}.
 * <p>
 * Note: the legacy {@link com.helger.schematron.pure.bound.PSBoundSchemaCache} singleton is kept
 * for backward compatibility but is independent from this cache. Both caches share the same key
 * type (the underlying {@link com.helger.schematron.pure.bound.PSBoundSchemaCacheKey}) but each
 * has its own backing storage.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
@ThreadSafe
public final class SchematronPureXPathCache extends AbstractSchematronCache <SchematronPureXPathConfig, IPSBoundSchema>
{
  /** Default name of the shared cache. */
  public static final String DEFAULT_NAME = "schematron-xpath";

  private static final class SingletonHolder
  {
    static final SchematronPureXPathCache INSTANCE = new SchematronPureXPathCache ();
  }

  /**
   * Create a new, unbounded cache with the {@link #DEFAULT_NAME default name}.
   */
  public SchematronPureXPathCache ()
  {
    this (DEFAULT_NAME, NO_MAX_SIZE);
  }

  /**
   * Create a new cache with a custom name and no max size.
   *
   * @param sName
   *        The cache name. May neither be <code>null</code> nor empty.
   */
  public SchematronPureXPathCache (@NonNull @Nonempty final String sName)
  {
    this (sName, NO_MAX_SIZE);
  }

  /**
   * Create a new cache with a custom name and a maximum size.
   *
   * @param sName
   *        The cache name. May neither be <code>null</code> nor empty.
   * @param nMaxSize
   *        The maximum number of entries. Values &le; 0 mean unbounded.
   */
  public SchematronPureXPathCache (@NonNull @Nonempty final String sName, final int nMaxSize)
  {
    super (sName, nMaxSize);
  }

  /**
   * @return The process-wide shared instance.
   */
  @NonNull
  public static SchematronPureXPathCache shared ()
  {
    return SingletonHolder.INSTANCE;
  }
}
