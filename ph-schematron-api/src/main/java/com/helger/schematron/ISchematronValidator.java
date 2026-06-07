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
package com.helger.schematron;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Node;

import com.helger.base.state.EValidity;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Shared contract for the builder-driven Schematron validator entry points (the classes obtained
 * from a <code>SchematronXyzConfig</code> via <code>compileCached</code> /
 * <code>compileUncached</code>). It complements {@link ISchematronResource} for users that operate
 * on an already-compiled validator rather than on a {@link com.helger.io.resource.IReadableResource
 * resource}.
 *
 * @author Philip Helger
 * @since 10.0.0
 */
public interface ISchematronValidator
{
  /**
   * @return <code>true</code> if the underlying Schematron compiles / binds without errors and can
   *         be used to validate XML.
   */
  boolean isValidSchematron ();

  /**
   * Apply Schematron validation to the given DOM node and return the parsed SVRL object.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The parsed SVRL output, or <code>null</code> if validation could not be applied.
   * @throws Exception
   *         In case the validation fails. Concrete implementations may narrow this to a more
   *         specific checked exception.
   */
  @Nullable
  SchematronOutputType applyToSVRL (@NonNull Node aXMLNode, @Nullable String sBaseURI) throws Exception;

  /**
   * Apply Schematron validation and reduce the SVRL output to an {@link EValidity} verdict.
   *
   * @param aXMLNode
   *        The XML node to validate. May not be <code>null</code>.
   * @param sBaseURI
   *        Optional base URI used as the source system ID.
   * @return The validity verdict. Never <code>null</code>. {@link EValidity#INVALID} is returned if
   *         validation could not be applied.
   * @throws Exception
   *         In case the validation fails. Concrete implementations may narrow this to a more
   *         specific checked exception.
   */
  @NonNull
  EValidity getValidity (@NonNull Node aXMLNode, @Nullable String sBaseURI) throws Exception;
}
