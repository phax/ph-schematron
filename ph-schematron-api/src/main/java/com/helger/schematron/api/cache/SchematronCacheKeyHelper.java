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

import java.util.Map;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;

/**
 * Helper for the cache keys of Schematron compilations.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class SchematronCacheKeyHelper
{
  private SchematronCacheKeyHelper ()
  {}

  /**
   * Check if an XSLT parameter value can be part of a cache key. This is the case for
   * <code>null</code> and for the final, immutable JDK value types with a value based
   * <code>equals</code> and <code>hashCode</code>: {@link String}, {@link Boolean},
   * {@link Character}, {@link Byte}, {@link Short}, {@link Integer}, {@link Long}, {@link Float} and
   * {@link Double}. Values of other types (e.g. DOM nodes, processor specific values or classes that
   * may be subclassed) cannot be compared reliably.
   *
   * @param aValue
   *        The parameter value to check. May be <code>null</code>.
   * @return <code>true</code> if the value can be part of a cache key.
   */
  public static boolean isCacheableParameterValue (@Nullable final Object aValue)
  {
    return aValue == null ||
           aValue instanceof String ||
           aValue instanceof Boolean ||
           aValue instanceof Character ||
           aValue instanceof Byte ||
           aValue instanceof Short ||
           aValue instanceof Integer ||
           aValue instanceof Long ||
           aValue instanceof Float ||
           aValue instanceof Double;
  }

  /**
   * Check if all XSLT parameter values can be part of a cache key.
   *
   * @param aParameters
   *        The parameters to check. May not be <code>null</code>.
   * @return <code>true</code> if all values can be part of a cache key (also for an empty map).
   * @see #isCacheableParameterValue(Object)
   */
  public static boolean areAllParameterValuesCacheable (@NonNull final Map <String, ?> aParameters)
  {
    ValueEnforcer.notNull (aParameters, "Parameters");
    for (final Object aValue : aParameters.values ())
      if (!isCacheableParameterValue (aValue))
        return false;
    return true;
  }
}
