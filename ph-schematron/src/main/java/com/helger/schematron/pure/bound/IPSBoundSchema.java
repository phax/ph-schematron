/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.bound;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Node;

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.state.EValidity;
import com.helger.schematron.CSchematron;
import com.helger.schematron.pure.binding.IPSQueryBinding;
import com.helger.schematron.pure.model.PSPattern;
import com.helger.schematron.pure.model.PSPhase;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.pure.validation.IPSValidationHandler;
import com.helger.schematron.pure.validation.SchematronValidationException;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Base interface for a bound schema. A bound schema is a {@link PSSchema} with
 * a specific
 *
 * @author Philip Helger
 */
public interface IPSBoundSchema
{
  /**
   * @return The query binding that was used to create this bound schema.
   */
  @Nonnull
  IPSQueryBinding getQueryBinding ();

  /**
   * @return The original schema used to bind. Never <code>null</code>.
   */
  @Nonnull
  PSSchema getOriginalSchema ();

  /**
   * @return The namespace context as defined by the namespaces in the original
   *         schema. Never <code>null</code>.
   */
  @Nonnull
  MapBasedNamespaceContext getNamespaceContext ();

  /**
   * @return Get the phase ID used. If none was specified, the schema
   *         defaultPhase is used. If this is not present, than all patterns are
   *         used and ID of the phase is {@link CSchematron#PHASE_ALL}.
   */
  @Nonnull
  String getPhaseID ();

  /**
   * @return The phase object to be evaluated. May be <code>null</code> if no
   *         specific phase is to be validated!
   */
  @Nullable
  PSPhase getPhase ();

  /**
   * @return <code>true</code> if a special phase was specified,
   *         <code>false</code> if not.
   */
  boolean isPhaseSpecified ();

  /**
   * @return A list of all patterns to be validated. If a phase was selected,
   *         only the patterns matching the selected phase are contained. Never
   *         <code>null</code>.
   */
  @Nonnull
  @ReturnsMutableCopy
  ICommonsList <PSPattern> getAllRelevantPatterns ();

  /**
   * Get the validation context to be used. As rules can be stated as "element"
   * they are not necessarily present on root level. For XPath this may e.g. be
   * resolved by prepending "//" so that all elements are resolved correctly.
   *
   * @param sRuleContext
   *        The original rule context. May not be <code>null</code>.
   * @return The real validation context to use.
   */
  @Nonnull
  String getValidationContext (@Nonnull String sRuleContext);

  /**
   * The generic validation method. It validates the passed XML node to this
   * bound schema.
   *
   * @param aNode
   *        The node to be validated. May not be <code>null</code>.
   * @param aHandler
   *        The validation handler that receives the callback informations. May
   *        not be <code>null</code>.
   * @throws SchematronValidationException
   *         In case a validation exception occurs
   */
  void validate (@Nonnull Node aNode, @Nonnull IPSValidationHandler aHandler) throws SchematronValidationException;

  /**
   * Special validation that breaks on the first error. This is a specialized
   * call of {@link #validate(Node, IPSValidationHandler)}.
   *
   * @param aNode
   *        The XML node to be validated. May not be <code>null</code>.
   * @return {@link EValidity#VALID} if the document is valid,
   *         {@link EValidity#INVALID} if it is invalid.
   * @throws SchematronValidationException
   *         In case a validation exception occurs
   */
  @Nonnull
  EValidity validatePartially (@Nonnull Node aNode) throws SchematronValidationException;

  /**
   * Special validation that creates an SVRL document. This is a specialized
   * call of {@link #validate(Node, IPSValidationHandler)}.
   *
   * @param aNode
   *        The XML node to be validated. May not be <code>null</code>.
   * @return The SVRL domain object.
   * @throws SchematronValidationException
   *         In case a validation exception occurs
   */
  @Nonnull
  SchematronOutputType validateComplete (@Nonnull Node aNode) throws SchematronValidationException;
}
