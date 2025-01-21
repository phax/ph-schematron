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
package com.helger.schematron.pure.binding.xpath;

import java.io.Serializable;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.xml.xpath.XPathExpression;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.ICommonsOrderedMap;
import com.helger.commons.collection.impl.ICommonsOrderedSet;
import com.helger.commons.lang.ICloneable;

/**
 * Read-only interface for {@link PSXPathVariables}.
 *
 * @author Philip Helger
 */
public interface IPSXPathVariables extends ICloneable <PSXPathVariables>, Serializable
{
  /**
   * @return All contained variable key value pairs. Never <code>null</code>.
   */
  @Nonnull
  @ReturnsMutableCopy
  ICommonsOrderedMap <String, XPathExpression> getAll ();

  /**
   * @return All contained variable names. Never <code>null</code>.
   * @since v8
   */
  @Nonnull
  @ReturnsMutableCopy
  ICommonsOrderedSet <String> getAllNames ();

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
  XPathExpression get (@Nullable String sName);
}
