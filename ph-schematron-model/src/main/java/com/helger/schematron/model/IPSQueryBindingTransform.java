/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.collection.commons.ICommonsNavigableMap;

/**
 * Engine-agnostic, syntactic part of a query binding. Provides the string-level
 * transformations needed by the preprocessor (test negation and parameter
 * substitution). The full {@code IPSQueryBinding} interface in
 * {@code ph-schematron-pure} extends this and adds the engine-specific binding
 * step that produces a bound, executable schema.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public interface IPSQueryBindingTransform extends Serializable
{
  /**
   * Negate the passed test statement. This is required in the creation of a
   * minified Schematron, when report elements are converted to assert elements.
   *
   * @param sTest
   *        The test expression.
   * @return The negated test expression
   */
  String getNegatedTestExpression (@NonNull String sTest);

  /**
   * Convert the passed list of {@link PSParam} elements to a map suitable for
   * String replacement. This is needed to resolve placeholders in abstract
   * patterns. The default query binding e.g. adds a "$" in front of each
   * parameter name. The so created map is used to resolve abstract rule and
   * pattern data to real values.
   *
   * @param aParams
   *        Source list. May not be <code>null</code>.
   * @return Non-<code>null</code> String replacement map.
   */
  @NonNull
  @ReturnsMutableCopy
  ICommonsNavigableMap <String, String> getStringReplacementMap (@NonNull List <PSParam> aParams);

  /**
   * Apply the Map created by {@link #getStringReplacementMap(List)} on a single
   * string.<br>
   * According to iso_abstract_expand.xsl, line 233 the text replacements happen
   * for the following attributes:
   * <ul>
   * <li>test - only in {@link PSAssertReport}</li>
   * <li>context - only in {@link PSRule}</li>
   * <li>select - only in {@link PSValueOf}</li>
   * </ul>
   * As an experimental option in line 244 the replacement is also applied to
   * all text nodes. This is currently not supported!
   *
   * @param sText
   *        The original text. May be <code>null</code>.
   * @param aStringReplacements
   *        All replacements as map from source to target. The map should be
   *        ordered by longest keys first.
   * @return <code>null</code> if the input string was <code>null</code>.
   */
  @Nullable
  String getWithParamTextsReplaced (@Nullable String sText, @Nullable Map <String, String> aStringReplacements);
}
