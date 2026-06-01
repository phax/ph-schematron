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
package com.helger.schematron.pure.binding;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.schematron.SchematronException;
import com.helger.schematron.errorhandler.IPSErrorHandler;
import com.helger.schematron.model.IPSQueryBindingTransform;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.pure.bound.IPSBoundSchema;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.xpath.IXPathConfig;

/**
 * Base interface for a single query binding. Extends
 * {@link IPSQueryBindingTransform} with the engine-specific binding step that
 * produces a bound, executable schema.
 *
 * @author Philip Helger
 */
public interface IPSQueryBinding extends IPSQueryBindingTransform
{
  // --- requirements for compilation ---

  @NonNull
  default IPSBoundSchema bind (@NonNull final PSSchema aSchema) throws SchematronException
  {
    return bind (aSchema, null, null, null, null);
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
   *        The XPath configuration to be used. May be <code>null</code>.
   * @return The bound schema and never <code>null</code>.
   * @throws SchematronException
   *         In case of a binding error
   * @since 5.5.0
   */
  @NonNull
  IPSBoundSchema bind (@NonNull PSSchema aSchema,
                       @Nullable String sPhase,
                       @Nullable IPSErrorHandler aCustomErrorHandler,
                       @Nullable IPSValidationHandler aCustomValidationHandler,
                       @Nullable IXPathConfig aXPathConfig) throws SchematronException;
}
