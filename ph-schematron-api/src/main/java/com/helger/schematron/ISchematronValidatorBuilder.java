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
package com.helger.schematron;

import org.jspecify.annotations.NonNull;

import com.helger.base.builder.IBuilder;

/**
 * Shared contract for the fluent builders nested inside the
 * <code>SchematronXyzConfig</code> classes. Adds the three "compile in one step" shortcuts
 * (cached with shared cache, cached with caller-supplied cache, uncached) on top of the value-only
 * {@link IBuilder#build()} call.
 *
 * @author Philip Helger
 * @since 10.0.0
 * @param <CONFIG>
 *        The concrete config value type produced by {@link #build()}.
 * @param <CACHE>
 *        The cache type accepted by {@link #buildCached(Object)}.
 * @param <V>
 *        The concrete {@link ISchematronValidator} produced by the <code>build*</code> shortcuts.
 */
public interface ISchematronValidatorBuilder <CONFIG, CACHE, V extends ISchematronValidator>
                                             extends
                                             IBuilder <CONFIG>
{
  /**
   * Build the config and compile via the engine's shared cache.
   *
   * @return The compiled validator. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  V buildCached () throws SchematronException;

  /**
   * Build the config and compile via the caller-supplied cache.
   *
   * @param aCache
   *        The cache instance to use. May not be <code>null</code>.
   * @return The compiled validator. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  V buildCached (@NonNull CACHE aCache) throws SchematronException;

  /**
   * Build the config and compile without using any cache.
   *
   * @return The compiled validator. Never <code>null</code>.
   * @throws SchematronException
   *         on compilation error.
   */
  @NonNull
  V buildUncached () throws SchematronException;
}
