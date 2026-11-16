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
package com.helger.schematron.streamability;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.base.id.IHasID;
import com.helger.base.lang.EnumHelper;

/**
 * The streamability class of a Schematron expression, rule, pattern or schema: what a validator needs to evaluate it
 * while it reads the instance document as a stream. The constants are ordered from the best to the worst class.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
public enum EStreamabilityClass implements IHasID <String>
{
  /**
   * Needs nothing beyond the context node, its attributes and its ancestors (and their attributes): everything is known
   * at the start tag of the context element. One pass, constant memory.
   */
  MOTIONLESS ("motionless"),
  /**
   * Needs only the subtree of the context node (and the ancestors as for {@link #MOTIONLESS}): the subtree is buffered,
   * checked and dropped. One pass, the memory of the largest matched subtree.
   */
  BURST ("burst"),
  /**
   * Needs data outside the subtree of the context node (the root, <code>//</code>, preceding or following nodes, keys
   * over the instance, values computed from the whole document) or cannot be analysed: two passes or the whole tree.
   */
  NON_LOCAL ("non-local");

  private final String m_sID;

  EStreamabilityClass (@NonNull @Nonempty final String sID)
  {
    m_sID = sID;
  }

  @NonNull
  @Nonempty
  public String getID ()
  {
    return m_sID;
  }

  /**
   * @param eOther
   *        The class to compare with. May not be <code>null</code>.
   * @return <code>true</code> if this class needs more than the passed one.
   */
  public boolean isWorseThan (@NonNull final EStreamabilityClass eOther)
  {
    return ordinal () > eOther.ordinal ();
  }

  /**
   * @param eOther
   *        The class to combine with. May not be <code>null</code>.
   * @return The worse of this class and the passed one. Never <code>null</code>.
   */
  @NonNull
  public EStreamabilityClass getWorse (@NonNull final EStreamabilityClass eOther)
  {
    return eOther.isWorseThan (this) ? eOther : this;
  }

  @Nullable
  public static EStreamabilityClass getFromIDOrNull (@Nullable final String sID)
  {
    return EnumHelper.getFromIDOrNull (EStreamabilityClass.class, sID);
  }
}
