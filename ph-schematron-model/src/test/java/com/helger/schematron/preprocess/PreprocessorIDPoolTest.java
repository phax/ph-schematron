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
package com.helger.schematron.preprocess;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import java.util.Random;
import java.util.Set;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsSet;

/**
 * Test class for class {@link PreprocessorIDPool}.
 *
 * @author Philip Helger
 */
public final class PreprocessorIDPoolTest
{
  /**
   * The algorithm of {@link PreprocessorIDPool#getUniqueID(String)} before it remembered the next index per ID: probe
   * all indices from 0.
   */
  @NonNull
  private static String _getUniqueIDByFullProbing (@NonNull final Set <String> aUsedIDs, @NonNull final String sID)
  {
    if (aUsedIDs.add (sID))
      return sID;
    final String sNewBaseID = sID + PreprocessorIDPool.getDefaultSeparator ();
    int nIndex = 0;
    while (!aUsedIDs.add (sNewBaseID + nIndex))
      ++nIndex;
    return sNewBaseID + nIndex;
  }

  @Test
  public void testBasic ()
  {
    final PreprocessorIDPool aPool = new PreprocessorIDPool ();
    assertNull (aPool.getUniqueID (null));
    assertEquals ("a", aPool.getUniqueID ("a"));
    assertEquals ("a0", aPool.getUniqueID ("a"));
    assertEquals ("a1", aPool.getUniqueID ("a"));
    assertEquals ("a3", aPool.getUniqueID ("a3"));
    assertEquals ("a2", aPool.getUniqueID ("a"));
    assertEquals ("a4", aPool.getUniqueID ("a"));
    assertEquals ("a10", aPool.getUniqueID ("a1"));
    assertEquals ("a5", aPool.getUniqueID ("a"));
  }

  @Test
  public void testUnchanged ()
  {
    final PreprocessorIDPool aPool = new PreprocessorIDPool.Unchanged ();
    assertNull (aPool.getUniqueID (null));
    assertEquals ("a", aPool.getUniqueID ("a"));
    assertEquals ("a", aPool.getUniqueID ("a"));
  }

  @Test
  public void testManyRepeatsSameAsFullProbing ()
  {
    final String [] aIDs = { "a", "a0", "a1", "a12", "a1", "b", "b0", "b00", "c" };
    final Random aRandom = new Random (20260101L);
    final PreprocessorIDPool aPool = new PreprocessorIDPool ();
    final ICommonsSet <String> aReferenceUsedIDs = new CommonsHashSet <> ();
    for (int i = 0; i < 20_000; ++i)
    {
      final String sID = aIDs[aRandom.nextInt (aIDs.length)];
      assertEquals (_getUniqueIDByFullProbing (aReferenceUsedIDs, sID), aPool.getUniqueID (sID));
    }

    // Many repeats of a single ID
    for (int i = 0; i < 5_000; ++i)
      assertEquals (_getUniqueIDByFullProbing (aReferenceUsedIDs, "d"), aPool.getUniqueID ("d"));
  }
}
