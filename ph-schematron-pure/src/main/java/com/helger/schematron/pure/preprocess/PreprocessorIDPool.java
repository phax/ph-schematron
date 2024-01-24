/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.preprocess;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsHashSet;
import com.helger.commons.collection.impl.ICommonsSet;
import com.helger.commons.string.ToStringGenerator;

/**
 * Utility lookup cache for all used IDs within a schema.
 *
 * @author Philip Helger
 */
@NotThreadSafe
public class PreprocessorIDPool
{
  public static final String DEFAULT_SEPARATOR = "";
  private static final Logger LOGGER = LoggerFactory.getLogger (PreprocessorIDPool.class);

  private static String s_sDefaultSeparator = DEFAULT_SEPARATOR;

  /**
   * @return The separator to be used between the original ID and the counter
   *         added to make the ID unique. Never <code>null</code>. The default
   *         value is {@link #DEFAULT_SEPARATOR}.
   * @since 6.3.5
   */
  @Nonnull
  public static String getDefaultSeparator ()
  {
    return s_sDefaultSeparator;
  }

  /**
   * Set the separator to be used between the original ID and the counter added
   * internally.
   *
   * @param sDefaultSeparator
   *        Any non-<code>null</code> value is okay.
   * @since 6.3.5
   */
  public static void setDefaultSeparator (@Nonnull final String sDefaultSeparator)
  {
    ValueEnforcer.notNull (sDefaultSeparator, "separator");
    s_sDefaultSeparator = sDefaultSeparator;
  }

  private final ICommonsSet <String> m_aUsedIDs = new CommonsHashSet <> ();

  public PreprocessorIDPool ()
  {}

  /**
   * @return The separator to be used between the original ID and the counter
   *         added to make the ID unique. Never <code>null</code>. The default
   *         value is {@link #DEFAULT_SEPARATOR}.
   * @see #getDefaultSeparator()
   * @see #setDefaultSeparator(String)
   * @since 6.3.5
   */
  @Nonnull
  public String getSeparator ()
  {
    return getDefaultSeparator ();
  }

  /**
   * Create a unique ID based on the passed one. If the passed ID is not yet
   * contained, than a numeric index is appended until the ID is unique.
   *
   * @param sID
   *        The source ID. May be <code>null</code>.
   * @return <code>null</code> if the passed ID is <code>null</code> indicating
   *         that no ID is present. Otherwise a unique ID is returned.
   */
  @Nullable
  public String getUniqueID (@Nullable final String sID)
  {
    if (sID == null)
      return null;

    if (m_aUsedIDs.add (sID))
    {
      // Provided ID is still unique
      return sID;
    }

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("The ID '" + sID + "' was already used in the current Schematron - creating a unique version");

    // Non-unique ID
    final String sNewBaseID = sID + getSeparator ();
    int nIndex = 0;
    String sNewID = sNewBaseID + nIndex;
    do
    {
      if (m_aUsedIDs.add (sNewID))
      {
        // Now it's unique
        LOGGER.warn ("The ID '" +
                     sID +
                     "' was already used in the current Schematron and replaced with '" +
                     sNewID +
                     "'");
        return sNewID;
      }
      ++nIndex;
      sNewID = sNewBaseID + nIndex;
    } while (true);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("usedIDs", m_aUsedIDs).getToString ();
  }
}
