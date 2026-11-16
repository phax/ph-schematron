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
package com.helger.schematron.api.xslt;

import java.util.Map;
import java.util.WeakHashMap;

import javax.xml.transform.TransformerFactory;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.GuardedBy;
import com.helger.annotation.concurrent.ThreadSafe;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.base.concurrent.SimpleLock;
import com.helger.base.enforce.ValueEnforcer;

/**
 * Provides one lock per {@link TransformerFactory} instance. A shared factory must not be
 * configured and used for compiling by several threads at the same time. A {@link SimpleLock} is
 * used instead of <code>synchronized</code> on the factory, because on Java 21 to 23 a virtual
 * thread that waits for a monitor blocks its carrier thread for the whole compilation.
 * <p>
 * The factories are referenced weakly, so that a lock does not keep its factory alive.
 * </p>
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@ThreadSafe
public final class TransformerFactoryLocks
{
  private static final SimpleLock LOCK = new SimpleLock ();
  @GuardedBy ("LOCK")
  private static final Map <TransformerFactory, SimpleLock> LOCKS = new WeakHashMap <> ();

  @PresentForCodeCoverage
  private static final TransformerFactoryLocks INSTANCE = new TransformerFactoryLocks ();

  private TransformerFactoryLocks ()
  {}

  /**
   * Get the lock of the provided factory. The same factory instance always gets the same lock.
   *
   * @param aTF
   *        The transformer factory to get the lock for. May not be <code>null</code>.
   * @return The lock of the factory. Never <code>null</code>.
   */
  @NonNull
  public static SimpleLock getLock (@NonNull final TransformerFactory aTF)
  {
    ValueEnforcer.notNull (aTF, "TransformerFactory");
    return LOCK.lockedGet ( () -> LOCKS.computeIfAbsent (aTF, k -> new SimpleLock ()));
  }
}
