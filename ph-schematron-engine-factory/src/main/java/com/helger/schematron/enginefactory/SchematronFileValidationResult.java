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
package com.helger.schematron.enginefactory;

import java.io.File;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

/**
 * The result of validating a single XML file with {@link SchematronValidationRunner}.
 *
 * @param xmlFile
 *        The validated XML file. Never <code>null</code>.
 * @param expectSuccess
 *        <code>true</code> if the file was expected to be valid.
 * @param errorCount
 *        The number of failed asserts and successful reports with level error or fatal error.
 * @param warningCount
 *        The number of failed asserts and successful reports with level warning. 0 if warnings
 *        are ignored.
 * @param infoCount
 *        The number of failed asserts and successful reports with a level below warning. 0 if
 *        warnings are ignored.
 * @param expectationFailureMessage
 *        The reason why the file did not meet the expectation (or could not be validated), or
 *        <code>null</code> if it met the expectation.
 * @param levelFailureMessage
 *        The reason why the file failed because of a level that must fail (see
 *        {@link SchematronValidationRunner#setFailOnValidationError(boolean)} etc.), or
 *        <code>null</code>.
 * @param exception
 *        The exception that occurred while validating. May be <code>null</code>.
 * @author Philip Helger
 * @since 11.0.0
 */
public record SchematronFileValidationResult (@NonNull File xmlFile,
                                              boolean expectSuccess,
                                              int errorCount,
                                              int warningCount,
                                              int infoCount,
                                              @Nullable String expectationFailureMessage,
                                              @Nullable String levelFailureMessage,
                                              @Nullable Throwable exception)
{
  /**
   * @return <code>true</code> if the file passed: the expectation was met and no level that must
   *         fail was present.
   */
  public boolean isSuccess ()
  {
    return expectationFailureMessage == null && levelFailureMessage == null;
  }

  /**
   * @return The expectation failure message, if present, the level failure message otherwise.
   *         <code>null</code> if the file passed.
   */
  @Nullable
  public String failureMessage ()
  {
    return expectationFailureMessage != null ? expectationFailureMessage : levelFailureMessage;
  }
}
