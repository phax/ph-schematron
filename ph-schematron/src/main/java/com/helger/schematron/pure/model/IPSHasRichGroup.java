/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.model;

import javax.annotation.Nullable;

/**
 * Base interface for objects having a rich group.
 *
 * @author Philip Helger
 */
public interface IPSHasRichGroup
{
  /**
   * Overwrite any existing rich group.
   *
   * @param aRich
   *        The new rich group to set. May be <code>null</code>.
   */
  void setRich (@Nullable PSRichGroup aRich);

  /**
   * @return <code>true</code> if a rich group is present, <code>false</code>
   *         otherwise.
   */
  default boolean hasRich ()
  {
    return getRich () != null;
  }

  /**
   * @return Get the existing rich group or <code>null</code> if none is
   *         present.
   */
  @Nullable
  PSRichGroup getRich ();

  /**
   * @return Get a clone of the rich group or <code>null</code> if no rich group
   *         is present at this object.
   */
  @Nullable
  default PSRichGroup getRichClone ()
  {
    final PSRichGroup aRich = getRich ();
    return aRich == null ? null : aRich.getClone ();
  }
}
