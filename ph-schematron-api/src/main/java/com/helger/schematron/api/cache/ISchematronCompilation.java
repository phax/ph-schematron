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

import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronException;

/**
 * Abstraction over a single Schematron compilation step that produces an engine-specific compiled
 * artifact (e.g. an {@code ISchematronXSLTBasedProvider}, {@code IPSBoundSchema} or
 * {@code XsltExecutable}). Instances are immutable value objects produced by the per-engine config
 * builders and consumed both by the per-engine {@link AbstractSchematronCache} and by one-shot
 * validation paths.
 *
 * @author Philip Helger
 * @param <ARTIFACT>
 *        The compiled artifact type
 * @since 10.0.0
 */
public interface ISchematronCompilation <ARTIFACT>
{
  /**
   * @return The underlying Schematron resource. Never <code>null</code>.
   */
  @NonNull
  IReadableResource getResource ();

  /**
   * @return An immutable, value-equality-based key used by caches. The key must include every
   *         dimension that influences the shape of the compiled artifact. Runtime hooks such as
   *         error listeners or per-call parameters must NOT participate. Never <code>null</code>.
   */
  @NonNull
  ISchematronCompilationCacheKey getCacheKey ();

  /**
   * @return <code>true</code> if the result of {@link #compile()} may be cached for this config.
   *         When <code>false</code>, callers must bypass the cache and recompile every time. The
   *         per-engine "force cache result" override is encoded into this method.
   */
  boolean canCacheResult ();

  /**
   * Perform the actual compilation. Implementations should be deterministic — same cache key, same
   * canCacheResult, same output (up to the runtime hooks that do not affect the artifact).
   *
   * @return The compiled artifact. May be <code>null</code> only when the input resource is missing
   *         or syntactically invalid; caches must not memoize a <code>null</code> result.
   * @throws SchematronException
   *         on compilation error.
   */
  @Nullable
  ARTIFACT compile () throws SchematronException;
}
