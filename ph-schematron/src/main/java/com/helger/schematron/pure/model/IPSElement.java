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

import java.io.Serializable;

import javax.annotation.Nonnull;

import com.helger.schematron.pure.errorhandler.IPSErrorHandler;
import com.helger.xml.microdom.IMicroElement;

/**
 * Base interface for a single Pure Schematron element
 *
 * @author Philip Helger
 */
public interface IPSElement extends Serializable
{
  /**
   * Check if this element is specified completely. This method stops at the
   * first encountered error.
   * 
   * @param aErrorHandler
   *        The error handler where the error details are stored. May not be
   *        <code>null</code>.
   * @return <code>true</code> if all mandatory fields are set and the element
   *         is valid, <code>false</code> otherwise.
   */
  boolean isValid (@Nonnull IPSErrorHandler aErrorHandler);

  /**
   * Check if this element is specified completely. This method performs all
   * validations independent of the number of encountered error.
   * 
   * @param aErrorHandler
   *        The error handler where the error details are stored. May not be
   *        <code>null</code>.
   */
  void validateCompletely (@Nonnull IPSErrorHandler aErrorHandler);

  /**
   * @return <code>true</code> if this element conforms to the Schematron
   *         minimal syntax, <code>false</code> otherwise.
   */
  boolean isMinimal ();

  /**
   * @return The XML representation of this element. Never <code>null</code>.
   */
  @Nonnull
  IMicroElement getAsMicroElement ();
}
