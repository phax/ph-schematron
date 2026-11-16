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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.SchematronException;

/**
 * Test class for class {@link AbstractSchematronCache}.
 *
 * @author Philip Helger
 */
public final class AbstractSchematronCacheTest
{
  private static final long TIMEOUT_SECONDS = 30;

  private record MockKey (String id) implements ISchematronCompilationCacheKey
  {}

  private enum EMockResult
  {
    VALUE,
    NULL,
    EXCEPTION
  }

  /**
   * A compilation that counts its calls and can wait for a latch before it finishes.
   */
  private static final class MockCompilation implements ISchematronCompilation <String>
  {
    private final MockKey m_aKey;
    private final AtomicInteger m_aCompileCount;
    private final CountDownLatch m_aStarted;
    private final CountDownLatch m_aProceed;
    private final EMockResult m_eResult;

    MockCompilation (@NonNull final String sID,
                     @NonNull final AtomicInteger aCompileCount,
                     @Nullable final CountDownLatch aStarted,
                     @Nullable final CountDownLatch aProceed,
                     @NonNull final EMockResult eResult)
    {
      m_aKey = new MockKey (sID);
      m_aCompileCount = aCompileCount;
      m_aStarted = aStarted;
      m_aProceed = aProceed;
      m_eResult = eResult;
    }

    @NonNull
    public IReadableResource getResource ()
    {
      return new ReadableResourceByteArray (new byte [0]);
    }

    @NonNull
    public ISchematronCompilationCacheKey getCacheKey ()
    {
      return m_aKey;
    }

    public boolean canCacheResult ()
    {
      return true;
    }

    @Nullable
    public String compile () throws SchematronException
    {
      m_aCompileCount.incrementAndGet ();
      if (m_aStarted != null)
        m_aStarted.countDown ();
      if (m_aProceed != null)
        try
        {
          if (!m_aProceed.await (TIMEOUT_SECONDS, TimeUnit.SECONDS))
            throw new SchematronException ("Timeout waiting to proceed");
        }
        catch (final InterruptedException ex)
        {
          Thread.currentThread ().interrupt ();
          throw new SchematronException ("Interrupted", ex);
        }
      if (m_eResult == EMockResult.EXCEPTION)
        throw new SchematronException ("Failed to compile " + m_aKey.id ());
      if (m_eResult == EMockResult.NULL)
        return null;
      // A new instance per compilation
      return new String ("compiled-" + m_aKey.id ());
    }
  }

  private static final class MockCache extends AbstractSchematronCache <MockCompilation, String>
  {
    MockCache ()
    {
      super ("mock");
    }
  }

  @Test
  public void testConcurrentCompileOfSameKey () throws Exception
  {
    final MockCache aCache = new MockCache ();
    final AtomicInteger aCompileCount = new AtomicInteger (0);
    final CountDownLatch aStarted = new CountDownLatch (1);
    final CountDownLatch aProceed = new CountDownLatch (1);
    final int nThreads = 8;
    final ExecutorService aES = Executors.newFixedThreadPool (nThreads);
    try
    {
      final ICommonsList <Future <String>> aFutures = new CommonsArrayList <> ();
      for (int i = 0; i < nThreads; ++i)
      {
        final MockCompilation aCfg = new MockCompilation ("same", aCompileCount, aStarted, aProceed, EMockResult.VALUE);
        aFutures.add (aES.submit (() -> aCache.getOrCompile (aCfg)));
      }

      // Let the compilation finish only when it is running
      assertTrue (aStarted.await (TIMEOUT_SECONDS, TimeUnit.SECONDS));
      aProceed.countDown ();

      final String sFirst = aFutures.getFirstOrNull ().get (TIMEOUT_SECONDS, TimeUnit.SECONDS);
      assertNotNull (sFirst);
      for (final Future <String> aFuture : aFutures)
        assertSame (sFirst, aFuture.get (TIMEOUT_SECONDS, TimeUnit.SECONDS));
    }
    finally
    {
      aES.shutdownNow ();
    }

    // Compiled exactly once
    assertEquals (1, aCompileCount.get ());
    assertEquals (1, aCache.size ());

    // Later calls are served from the cache
    assertSame (aCache.getOrCompile (new MockCompilation ("same", aCompileCount, null, null, EMockResult.VALUE)),
                aCache.getOrCompile (new MockCompilation ("same", aCompileCount, null, null, EMockResult.VALUE)));
    assertEquals (1, aCompileCount.get ());
  }

  @Test
  public void testConcurrentCompileOfDifferentKeys () throws Exception
  {
    final MockCache aCache = new MockCache ();
    final AtomicInteger aCompileCount = new AtomicInteger (0);
    final int nKeys = 4;
    // Each compilation only finishes when all compilations have started - this only works if they
    // run in parallel
    final CountDownLatch aAllStarted = new CountDownLatch (nKeys);
    final ExecutorService aES = Executors.newFixedThreadPool (nKeys);
    try
    {
      final ICommonsList <Future <String>> aFutures = new CommonsArrayList <> ();
      for (int i = 0; i < nKeys; ++i)
      {
        final MockCompilation aCfg = new MockCompilation ("key" + i, aCompileCount, aAllStarted, aAllStarted, EMockResult.VALUE);
        aFutures.add (aES.submit (() -> aCache.getOrCompile (aCfg)));
      }
      for (int i = 0; i < nKeys; ++i)
        assertEquals ("compiled-key" + i, aFutures.get (i).get (TIMEOUT_SECONDS, TimeUnit.SECONDS));
    }
    finally
    {
      aES.shutdownNow ();
    }
    assertEquals (nKeys, aCompileCount.get ());
    assertEquals (nKeys, aCache.size ());
  }

  @Test
  public void testHitDoesNotWaitForCompile () throws Exception
  {
    final MockCache aCache = new MockCache ();
    final AtomicInteger aCompileCount = new AtomicInteger (0);
    final String sCached = aCache.getOrCompile (new MockCompilation ("cached", aCompileCount, null, null, EMockResult.VALUE));

    final CountDownLatch aStarted = new CountDownLatch (1);
    final CountDownLatch aProceed = new CountDownLatch (1);
    final ExecutorService aES = Executors.newSingleThreadExecutor ();
    try
    {
      final Callable <String> aSlowCompile = () -> aCache.getOrCompile (new MockCompilation ("slow",
                                                                                             aCompileCount,
                                                                                             aStarted,
                                                                                             aProceed,
                                                                                             EMockResult.VALUE));
      final Future <String> aFuture = aES.submit (aSlowCompile);
      assertTrue (aStarted.await (TIMEOUT_SECONDS, TimeUnit.SECONDS));

      // While "slow" is compiled, the cached entry is still served
      assertSame (sCached, aCache.getOrCompile (new MockCompilation ("cached", aCompileCount, null, null, EMockResult.VALUE)));
      assertEquals (1, aCache.size ());

      aProceed.countDown ();
      assertEquals ("compiled-slow", aFuture.get (TIMEOUT_SECONDS, TimeUnit.SECONDS));
    }
    finally
    {
      aES.shutdownNow ();
    }
    assertEquals (2, aCompileCount.get ());
    assertEquals (2, aCache.size ());
  }

  @Test
  public void testNullResultIsNotCached () throws Exception
  {
    final MockCache aCache = new MockCache ();
    final AtomicInteger aCompileCount = new AtomicInteger (0);
    assertNull (aCache.getOrCompile (new MockCompilation ("null", aCompileCount, null, null, EMockResult.NULL)));
    assertNull (aCache.getOrCompile (new MockCompilation ("null", aCompileCount, null, null, EMockResult.NULL)));
    assertEquals (2, aCompileCount.get ());
    assertTrue (aCache.isEmpty ());
  }

  @Test
  public void testExceptionIsPassedToWaitingCallers () throws Exception
  {
    final MockCache aCache = new MockCache ();
    final AtomicInteger aCompileCount = new AtomicInteger (0);
    final CountDownLatch aStarted = new CountDownLatch (1);
    final CountDownLatch aProceed = new CountDownLatch (1);
    final int nThreads = 4;
    final ExecutorService aES = Executors.newFixedThreadPool (nThreads);
    try
    {
      final ICommonsList <Future <String>> aFutures = new CommonsArrayList <> ();
      for (int i = 0; i < nThreads; ++i)
      {
        final MockCompilation aCfg = new MockCompilation ("fail",
                                                          aCompileCount,
                                                          aStarted,
                                                          aProceed,
                                                          EMockResult.EXCEPTION);
        aFutures.add (aES.submit (() -> aCache.getOrCompile (aCfg)));
      }
      assertTrue (aStarted.await (TIMEOUT_SECONDS, TimeUnit.SECONDS));
      aProceed.countDown ();

      // Every caller gets the failure
      for (final Future <String> aFuture : aFutures)
        try
        {
          aFuture.get (TIMEOUT_SECONDS, TimeUnit.SECONDS);
          fail ();
        }
        catch (final ExecutionException ex)
        {
          assertTrue (ex.getCause () instanceof SchematronException);
        }
    }
    finally
    {
      aES.shutdownNow ();
    }
    // Callers arriving after the failure compile again
    assertTrue (aCompileCount.get () >= 1);
    assertTrue (aCache.isEmpty ());
  }

  @Test
  public void testChangeCount () throws Exception
  {
    final MockCache aCache = new MockCache ();
    final AtomicInteger aCompileCount = new AtomicInteger (0);
    final MockCompilation aCfg = new MockCompilation ("a", aCompileCount, null, null, EMockResult.VALUE);
    final long nStart = aCache.getChangeCount ();
    aCache.getOrCompile (aCfg);
    assertEquals (nStart, aCache.getChangeCount ());

    aCache.invalidate (aCfg);
    final long nAfterInvalidate = aCache.getChangeCount ();
    assertNotEquals (nStart, nAfterInvalidate);

    aCache.clear ();
    assertNotEquals (nAfterInvalidate, aCache.getChangeCount ());
  }
}
