/**
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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

import java.util.HashSet;
import java.util.Set;

import javax.annotation.Nullable;
import javax.annotation.concurrent.NotThreadSafe;

import com.helger.commons.string.ToStringGenerator;

/**
 * Utility lookup cache for all used IDs within a schema.
 * 
 * @author Philip Helger
 */
@NotThreadSafe
final class PreprocessorIDPool
{
  private final Set <String> m_aUsedIDs = new HashSet <String> ();

  public PreprocessorIDPool ()
  {}

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
      // Unique ID
      return sID;
    }

    // Non-unique ID
    int nIndex = 0;
    String sNewID = sID + nIndex;
    do
    {
      if (m_aUsedIDs.add (sNewID))
      {
        // Now it's unique
        return sNewID;
      }
      ++nIndex;
      sNewID = sID + nIndex;
    } while (true);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).append ("usedIDs", m_aUsedIDs).toString ();
  }
}
