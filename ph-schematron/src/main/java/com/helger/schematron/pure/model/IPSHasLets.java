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

import javax.annotation.Nonnull;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.collection.ext.ICommonsOrderedMap;

/**
 * Base interface for all objects having {@link PSLet} elements contained
 *
 * @author Philip Helger
 */
public interface IPSHasLets
{
  /**
   * Add a {@link PSLet} element.
   *
   * @param aLet
   *        The let element to be added. May not be <code>null</code>.
   */
  void addLet (@Nonnull PSLet aLet);

  /**
   * @return <code>true</code> if this object has at least on contained
   *         {@link PSLet} object.
   */
  boolean hasAnyLet ();

  /**
   * @return A list of all contained {@link PSLet} elements. Never
   *         <code>null</code>.
   */
  @Nonnull
  @ReturnsMutableCopy
  ICommonsList <PSLet> getAllLets ();

  /**
   * @return The content of all {@link PSLet} elements as an ordered Map from
   *         name to value. The order must match the declaration order! Never
   *         <code>null</code>.
   */
  @Nonnull
  @ReturnsMutableCopy
  ICommonsOrderedMap <String, String> getAllLetsAsMap ();
}
