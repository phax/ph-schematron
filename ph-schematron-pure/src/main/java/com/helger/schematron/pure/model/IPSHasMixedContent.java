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
package com.helger.schematron.pure.model;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.collection.commons.ICommonsList;

/**
 * Base interface for a Schematron element that has {@link String} and
 * {@link IPSElement} content mixed.
 *
 * @author Philip Helger
 */
public interface IPSHasMixedContent extends IPSHasTexts
{
  /**
   * @return A list of all contained elements.
   */
  @NonNull
  @ReturnsMutableCopy
  ICommonsList <Object> getAllContentElements ();
}
