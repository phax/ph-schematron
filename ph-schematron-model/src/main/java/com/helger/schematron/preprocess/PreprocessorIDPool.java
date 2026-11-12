/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.preprocess;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsMap;
import com.helger.collection.commons.ICommonsSet;

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
   * @return The separator to be used between the original ID and the counter added to make the ID
   *         unique. Never <code>null</code>. The default value is {@link #DEFAULT_SEPARATOR}.
   * @since 6.3.5
   */
  @NonNull
  public static String getDefaultSeparator ()
  {
    return s_sDefaultSeparator;
  }

  /**
   * Set the separator to be used between the original ID and the counter added internally.
   *
   * @param sDefaultSeparator
   *        Any non-<code>null</code> value is okay.
   * @since 6.3.5
   */
  public static void setDefaultSeparator (@NonNull final String sDefaultSeparator)
  {
    ValueEnforcer.notNull (sDefaultSeparator, "separator");
    s_sDefaultSeparator = sDefaultSeparator;
  }

  /**
   * An ID pool that returns all IDs unchanged, even if they were used before.
   *
   * @since 10.3.2
   */
  public static class Unchanged extends PreprocessorIDPool
  {
    @Override
    @Nullable
    public String getUniqueID (@Nullable final String sID)
    {
      return sID;
    }
  }

  private final ICommonsSet <String> m_aUsedIDs = new CommonsHashSet <> ();
  /**
   * The next index to probe per base ID (ID plus separator): all smaller indices are already used, so the probing does
   * not start at 0 again for every repetition of an ID.
   */
  private final ICommonsMap <String, Integer> m_aNextIndex = new CommonsHashMap <> ();

  public PreprocessorIDPool ()
  {}

  /**
   * @return The separator to be used between the original ID and the counter added to make the ID
   *         unique. Never <code>null</code>. The default value is {@link #DEFAULT_SEPARATOR}.
   * @see #getDefaultSeparator()
   * @see #setDefaultSeparator(String)
   * @since 6.3.5
   */
  @NonNull
  public String getSeparator ()
  {
    return getDefaultSeparator ();
  }

  /**
   * Create a unique ID based on the passed one. If the passed ID is not yet contained, than a
   * numeric index is appended until the ID is unique.
   *
   * @param sID
   *        The source ID. May be <code>null</code>.
   * @return <code>null</code> if the passed ID is <code>null</code> indicating that no ID is
   *         present. Otherwise a unique ID is returned.
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
    final Integer aNextIndex = m_aNextIndex.get (sNewBaseID);
    int nIndex = aNextIndex == null ? 0 : aNextIndex.intValue ();
    String sNewID = sNewBaseID + nIndex;
    do
    {
      if (m_aUsedIDs.add (sNewID))
      {
        m_aNextIndex.put (sNewBaseID, Integer.valueOf (nIndex + 1));
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
    return new ToStringGenerator (this).append ("UsedIDs", m_aUsedIDs).getToString ();
  }
}
