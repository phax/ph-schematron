/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.binding.xpath;

import java.io.Serializable;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.ICommonsNavigableMap;
import com.helger.commons.lang.ICloneable;

/**
 * Read-only interface for {@link PSXPathVariables}.
 *
 * @author Philip Helger
 */
public interface IPSXPathVariables extends ICloneable <PSXPathVariables>, Serializable
{
  /**
   * Perform the text replacement of all variables in the specified text.
   *
   * @param sText
   *        The source text. May be <code>null</code>.
   * @return The text with all values replaced. May be <code>null</code> if the
   *         source text is <code>null</code>.
   */
  @Nullable
  String getAppliedReplacement (@Nullable String sText);

  /**
   * @return All contained variable key value pairs. Never <code>null</code>.
   */
  @Nonnull
  @ReturnsMutableCopy
  ICommonsNavigableMap <String, String> getAll ();

  /**
   * @param sName
   *        Name of the variable to check
   * @return <code>true</code> if a variable with the passed name in present.
   */
  boolean contains (@Nullable String sName);

  /**
   * @param sName
   *        Variable name
   * @return The variable value of the variable with the specified name or
   *         <code>null</code> if no such variable is present.
   */
  @Nullable
  String get (@Nullable String sName);
}
