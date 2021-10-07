/*
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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
package com.helger.schematron.api.xslt.validator;

import javax.annotation.Nonnull;

import com.helger.commons.state.EValidity;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Base interface for objects that determine the validity of a Schematron
 * validation result. By default a Schematron validation is determined valid if
 * no failed-assert is present and no successful-report is present.
 * 
 * @author Philip Helger
 */
public interface ISchematronXSLTValidator
{
  /**
   * Determine the overall validity of a Schematron validation result.
   * 
   * @param aSO
   *        The Schematron validation result. Never <code>null</code>.
   * @return {@link EValidity#VALID} if the Schematron validation was
   *         successful, {@link EValidity#INVALID} if the validation failed.
   *         Never <code>null</code>.
   */
  @Nonnull
  EValidity getSchematronValidity (@Nonnull SchematronOutputType aSO);
}
