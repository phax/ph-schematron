/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.binding;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.ICommonsNavigableMap;
import com.helger.schematron.SchematronException;
import com.helger.schematron.config.XPathConfig;
import com.helger.schematron.config.XPathConfigImpl;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.schematron.pure.model.PSAssertReport;
import com.helger.schematron.pure.model.PSParam;
import com.helger.schematron.pure.model.PSRule;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.model.PSValueOf;
import com.helger.schematron.pure.validation.IPSValidationHandler;

/**
 * Base interface for a single query binding.
 *
 * @author Philip Helger
 */
public interface IPSQueryBinding extends Serializable
{
  // --- requirements to create a minimal syntax/pre-process ---

  /**
   * Negate the passed test statement. This is required in the creation of a
   * minified Schematron, when report elements are converted to assert elements.
   *
   * @param sTest
   *        The test expression.
   * @return The negated test expression
   */
  String getNegatedTestExpression (@Nonnull String sTest);

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
  @Nonnull
  @ReturnsMutableCopy
  ICommonsNavigableMap <String, String> getStringReplacementMap (@Nonnull List <PSParam> aParams);

  /**
   * Apply the Map created by {@link #getNegatedTestExpression(String)} on a
   * single string.<br>
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

  // --- requirements for compilation ---

  @Nonnull
  default IPSBoundSchema bind (@Nonnull final PSSchema aSchema,
                               @Nonnull final XPathConfig aXPathConfig) throws SchematronException
  {
    return bind (aSchema, (String) null, (IPSErrorHandler) null, aXPathConfig);
  }

  @Nonnull
  default IPSBoundSchema bind (@Nonnull final PSSchema aSchema,
                               @Nullable final String sPhase,
                               @Nullable final IPSErrorHandler aCustomErrorListener,
                               @Nonnull final XPathConfig aXPathConfig) throws SchematronException
  {
    return bind (aSchema,
                 sPhase,
                 aCustomErrorListener,
                 (IPSValidationHandler) null,
                 (XPathConfig) aXPathConfig);
  }

  /**
   * Create a bound schema, which is like a precompiled schema.
   *
   * @param aSchema
   *        The schema to be bound. May not be <code>null</code>.
   * @param sPhase
   *        The phase to use. May be <code>null</code>. If it is
   *        <code>null</code> than the defaultPhase is used that is defined in
   *        the schema. If no defaultPhase is present, than all patterns are
   *        evaluated.
   * @param aCustomErrorHandler
   *        An optional custom error handler to use. May be <code>null</code>.
   * @param aCustomValidationHandler
   *        A custom PS validation handler to use. May be <code>null</code>.
   * @param aXPathConfig
   *        Use {@link XPathConfigImpl}.
   * @return The precompiled, bound schema. Never <code>null</code>.
   * @throws SchematronException
   *         In case of a binding error
   */
  @Nonnull
  IPSBoundSchema bind (@Nonnull PSSchema aSchema,
                       @Nullable String sPhase,
                       @Nullable IPSErrorHandler aCustomErrorHandler,
                       @Nullable IPSValidationHandler aCustomValidationHandler,
                       @Nonnull XPathConfig aXPathConfig) throws SchematronException;
}
