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
package com.helger.schematron.pure.model;

import javax.annotation.Nullable;

/**
 * Base interface for objects having a linkable group.
 *
 * @author Philip Helger
 */
public interface IPSHasLinkableGroup
{
  /**
   * @return Get the existing linkable group or <code>null</code> if none is
   *         present.
   */
  @Nullable
  PSLinkableGroup getLinkable ();

  /**
   * @return <code>true</code> if a linkable group is present,
   *         <code>false</code> otherwise.
   */
  default boolean hasLinkable ()
  {
    return getLinkable () != null;
  }

  /**
   * @return Get a clone of the linkable group or <code>null</code> if no
   *         linkable group is present at this object.
   */
  @Nullable
  default PSLinkableGroup getLinkableClone ()
  {
    final PSLinkableGroup aLinkable = getLinkable ();
    return aLinkable == null ? null : aLinkable.getClone ();
  }

  /**
   * Overwrite any existing linkable group.
   *
   * @param aLinkable
   *        The new linkable group to set. May be <code>null</code>.
   */
  void setLinkable (@Nullable PSLinkableGroup aLinkable);
}
