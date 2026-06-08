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
package com.helger.schematron.api.cache;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.Nonempty;
import com.helger.annotation.Nonnegative;
import com.helger.annotation.concurrent.GuardedBy;
import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.annotation.style.CodingStyleguideUnaware;
import com.helger.base.concurrent.SimpleReadWriteLock;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EChange;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.ICommonsMap;
import com.helger.collection.map.SoftHashMap;
import com.helger.collection.map.SoftLinkedHashMap;
import com.helger.schematron.SchematronException;

/**
 * Generic base class for Schematron engine caches. Each engine subclasses this with concrete
 * {@code CFG} and {@code ART} types and adds a static {@code shared()} accessor for the legacy
 * singleton-style usage.
 * <p>
 * The cache uses soft references for cached artifacts (via {@link SoftHashMap} or
 * {@link SoftLinkedHashMap}), so entries can be reclaimed under memory pressure. With a positive
 * max-size, the backing map uses LRU eviction; otherwise it is unbounded (subject only to soft
 * reference reclamation).
 * <p>
 * Compilations whose {@link ISchematronCompilation#canCacheResult()} returns <code>false</code>
 * bypass the cache entirely. Failed compilations (returning <code>null</code>) are not memoized.
 *
 * @author Philip Helger
 * @param <CFG>
 *        The engine-specific config type
 * @param <ARTIFACT>
 *        The engine-specific compiled artifact type
 * @since 10.0.0
 */
@ThreadSafe
public abstract class AbstractSchematronCache <CFG extends ISchematronCompilation <ARTIFACT>, ARTIFACT>
{
  /** Indicates that the cache has no maximum size. */
  public static final int NO_MAX_SIZE = 0;

  private static final Logger LOGGER = LoggerFactory.getLogger (AbstractSchematronCache.class);

  private final String m_sName;
  private final int m_nMaxSize;
  protected final SimpleReadWriteLock m_aRWLock = new SimpleReadWriteLock ();
  @GuardedBy ("m_aRWLock")
  private ICommonsMap <ISchematronCompilationCacheKey, ARTIFACT> m_aMap;

  /**
   * Constructor with no maximum size.
   *
   * @param sName
   *        The internal name of the cache. May neither be <code>null</code> nor empty.
   */
  protected AbstractSchematronCache (@NonNull @Nonempty final String sName)
  {
    this (sName, NO_MAX_SIZE);
  }

  /**
   * Constructor with a maximum size.
   *
   * @param sName
   *        The internal name of the cache. May neither be <code>null</code> nor empty.
   * @param nMaxSize
   *        The maximum number of entries in the cache. Values &le; 0 mean no limit.
   */
  protected AbstractSchematronCache (@NonNull @Nonempty final String sName, final int nMaxSize)
  {
    ValueEnforcer.notEmpty (sName, "Name");
    m_sName = sName;
    m_nMaxSize = nMaxSize;
  }

  /**
   * @return The cache name. Neither <code>null</code> nor empty.
   */
  @NonNull
  @Nonempty
  public final String getName ()
  {
    return m_sName;
  }

  /**
   * @return The maximum number of entries allowed in this cache. Values &le; 0 indicate that the
   *         cache size is not limited at all.
   */
  public final int getMaxSize ()
  {
    return m_nMaxSize;
  }

  /**
   * @return <code>true</code> if a positive max size was configured.
   */
  public final boolean hasMaxSize ()
  {
    return m_nMaxSize > 0;
  }

  @NonNull
  @CodingStyleguideUnaware
  private ICommonsMap <ISchematronCompilationCacheKey, ARTIFACT> _ensureMap ()
  {
    if (m_aMap == null)
      m_aMap = hasMaxSize () ? new SoftLinkedHashMap <> (m_nMaxSize) : new SoftHashMap <> ();
    return m_aMap;
  }

  /**
   * Retrieve the compiled artifact for the given configuration, computing and caching it on demand.
   * Configurations for which {@link ISchematronCompilation#canCacheResult()} returns
   * <code>false</code> bypass the cache entirely and recompile each time. Compilation failures
   * (returning <code>null</code>) are not cached.
   *
   * @param aCfg
   *        The compilation config. May not be <code>null</code>.
   * @return The compiled artifact, or <code>null</code> if compilation returned <code>null</code>
   *         (e.g. invalid Schematron).
   * @throws SchematronException
   *         If compilation fails.
   */
  @Nullable
  public final ARTIFACT getOrCompile (@NonNull final CFG aCfg) throws SchematronException
  {
    ValueEnforcer.notNull (aCfg, "Cfg");

    if (!aCfg.canCacheResult ())
    {
      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Cache '" + m_sName + "': bypassing cache for non-cacheable config " + aCfg);
      return aCfg.compile ();
    }

    final ISchematronCompilationCacheKey aKey = aCfg.getCacheKey ();
    ValueEnforcer.notNull (aKey, "CacheKey");

    // First attempt: read-locked lookup
    ARTIFACT aValue = m_aRWLock.readLockedGet ( () -> m_aMap == null ? null : m_aMap.get (aKey));
    if (aValue != null)
      return aValue;

    // Compile under the write lock so concurrent callers for the same key share the result
    m_aRWLock.writeLock ().lock ();
    try
    {
      if (m_aMap != null)
      {
        aValue = m_aMap.get (aKey);
        if (aValue != null)
          return aValue;
      }
      aValue = aCfg.compile ();
      if (aValue == null)
      {
        if (LOGGER.isDebugEnabled ())
          LOGGER.debug ("Cache '" + m_sName + "': compilation returned null for key '" + aKey + "'; not caching");
        return null;
      }
      _ensureMap ().put (aKey, aValue);
      return aValue;
    }
    finally
    {
      m_aRWLock.writeLock ().unlock ();
    }
  }

  /**
   * Check whether the cache currently contains an entry for the given config (without compiling).
   *
   * @param aCfg
   *        The compilation config. May not be <code>null</code>.
   * @return <code>true</code> if the artifact is cached and the config is cacheable.
   */
  public final boolean isCached (@NonNull final CFG aCfg)
  {
    ValueEnforcer.notNull (aCfg, "Cfg");
    if (!aCfg.canCacheResult ())
      return false;

    final ISchematronCompilationCacheKey aKey = aCfg.getCacheKey ();
    return m_aRWLock.readLockedBoolean ( () -> m_aMap != null && m_aMap.containsKey (aKey));
  }

  /**
   * Remove the entry corresponding to the given config from the cache.
   *
   * @param aCfg
   *        The compilation config. May not be <code>null</code>.
   * @return {@link EChange#CHANGED} if an entry was removed, {@link EChange#UNCHANGED} otherwise.
   */
  @NonNull
  public final EChange invalidate (@NonNull final CFG aCfg)
  {
    ValueEnforcer.notNull (aCfg, "Cfg");
    return invalidate (aCfg.getCacheKey ());
  }

  /**
   * Remove an entry by its raw cache key.
   *
   * @param aKey
   *        The cache key. May not be <code>null</code>.
   * @return {@link EChange#CHANGED} if an entry was removed, {@link EChange#UNCHANGED} otherwise.
   */
  @NonNull
  public final EChange invalidate (@NonNull final Object aKey)
  {
    ValueEnforcer.notNull (aKey, "Key");
    return m_aRWLock.writeLockedGet ( () -> m_aMap != null && m_aMap.remove (aKey) != null ? EChange.CHANGED
                                                                                           : EChange.UNCHANGED);
  }

  /**
   * Remove all entries from the cache.
   *
   * @return {@link EChange#CHANGED} if the cache was non-empty before the call.
   */
  @NonNull
  public final EChange clear ()
  {
    return m_aRWLock.writeLockedGet ( () -> {
      if (m_aMap == null || m_aMap.isEmpty ())
        return EChange.UNCHANGED;
      m_aMap.clear ();
      return EChange.CHANGED;
    });
  }

  /**
   * @return The number of entries currently in the cache. Always &ge; 0.
   */
  @Nonnegative
  public final int size ()
  {
    return m_aRWLock.readLockedInt ( () -> m_aMap == null ? 0 : m_aMap.size ());
  }

  /**
   * @return <code>true</code> if the cache contains no entries.
   */
  public final boolean isEmpty ()
  {
    return m_aRWLock.readLockedBoolean ( () -> m_aMap == null || m_aMap.isEmpty ());
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("Name", m_sName)
                                       .append ("MaxSize", m_nMaxSize)
                                       .append ("Size", size ())
                                       .getToString ();
  }
}
