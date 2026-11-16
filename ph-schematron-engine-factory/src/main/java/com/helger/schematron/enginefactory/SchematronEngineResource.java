/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.enginefactory;

import org.jspecify.annotations.NonNull;

import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.diagnostics.error.list.IErrorList;
import com.helger.schematron.ISchematronResource;

/**
 * The result of {@link SchematronEngineFactory#createResource(java.io.File, SchematronEngineSettings)}:
 * the Schematron resource and the errors found while checking the Schematron.
 *
 * @param resource
 *        The created Schematron resource. Never <code>null</code>.
 * @param errors
 *        The errors, warnings and information of the Schematron check. Never <code>null</code>.
 * @author Philip Helger
 * @since 11.0.0
 */
public record SchematronEngineResource (@NonNull ISchematronResource resource, @NonNull IErrorList errors)
{
  /**
   * @return <code>true</code> if at least one error of level {@link EErrorLevel#ERROR} or higher was
   *         found, so that the resource must not be used.
   */
  public boolean hasAnyError ()
  {
    return errors.containsAny (x -> x.getErrorLevel ().isGE (EErrorLevel.ERROR));
  }
}
