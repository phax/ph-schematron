/**
 * Copyright (C) 2014 phloc systems (www.phloc.com)
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
package com.helger.schematron.pure.model;

import java.util.List;

import javax.annotation.Nonnull;

import com.helger.commons.annotations.ReturnsMutableCopy;

/**
 * Base interface for all Schematron objects having text children (as Strings)
 * 
 * @author Philip Helger
 */
public interface IPSHasTexts
{
  /**
   * Add a new text element.
   * 
   * @param sText
   *        The text to be added. May not be <code>null</code>.
   */
  void addText (@Nonnull String sText);

  /**
   * @return <code>true</code> if at least one text element is contained,
   *         <code>false</code> if not
   */
  boolean hasAnyText ();

  /**
   * @return A copy of all contained text elements. Never <code>null</code>.
   */
  @Nonnull
  @ReturnsMutableCopy
  List <String> getAllTexts ();
}
