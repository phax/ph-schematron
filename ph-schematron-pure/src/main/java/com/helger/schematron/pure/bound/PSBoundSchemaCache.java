/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.bound;

import javax.annotation.Nonnull;

import com.helger.commons.CGlobal;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.cache.Cache;
import com.helger.schematron.SchematronException;

/**
 * A cache for {@link IPSBoundSchema} instances. Use {@link #getInstance()} to
 * retrieve a global singleton instance. Alternatively you may instantiate this
 * class regularly.
 *
 * @author Philip Helger
 */
public class PSBoundSchemaCache extends Cache <PSBoundSchemaCacheKey, IPSBoundSchema>
{
  private static final class SingletonHolder
  {
    static final PSBoundSchemaCache INSTANCE = new PSBoundSchemaCache ();
  }

  /**
   * Default constructor for the singleton.
   */
  private PSBoundSchemaCache ()
  {
    this (PSBoundSchemaCache.class.getName ());
  }

  public PSBoundSchemaCache (@Nonnull final String sCacheName)
  {
    super (aKey -> {
      ValueEnforcer.notNull (aKey, "Key");

      try
      {
        return aKey.createBoundSchema ();
      }
      catch (final SchematronException ex)
      {
        // Convert to an unchecked exception :(
        throw new IllegalArgumentException (ex);
      }
    }, CGlobal.ILLEGAL_UINT, sCacheName);
  }

  @Nonnull
  public static PSBoundSchemaCache getInstance ()
  {
    return SingletonHolder.INSTANCE;
  }
}
