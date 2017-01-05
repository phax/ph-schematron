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
package com.helger.schematron.pure.errorhandler;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.pure.model.IPSElement;

/**
 * Base interface for a Pure Schematron error handler.
 *
 * @author Philip Helger
 */
public interface IPSErrorHandler
{
  /**
   * Emit a warning
   *
   * @param aRes
   *        The resource in which the error occurred. May be <code>null</code>.
   * @param aSourceElement
   *        The source element where the warning is encountered. Maybe
   *        <code>null</code> for XPath errors.
   * @param sMessage
   *        The main warning message. Never <code>null</code>.
   */
  void warn (@Nullable IReadableResource aRes, @Nullable IPSElement aSourceElement, @Nonnull String sMessage);

  /**
   * Emit an error. Shortcut for
   * {@link #error(IReadableResource, IPSElement, String, Throwable)} with
   * <code>null</code> {@link IReadableResource} and <code>null</code>
   * {@link Throwable}.
   *
   * @param aSourceElement
   *        The source element where the warning is encountered. Maybe
   *        <code>null</code> for XPath errors.
   * @param sMessage
   *        The main warning message. Never <code>null</code>.
   */
  default void error (@Nullable final IPSElement aSourceElement, @Nonnull final String sMessage)
  {
    error ((IReadableResource) null, aSourceElement, sMessage, (Throwable) null);
  }

  /**
   * Emit an error
   *
   * @param aRes
   *        The resource in which the error occurred. May be <code>null</code>.
   * @param aSourceElement
   *        The source element where the warning is encountered. Maybe
   *        <code>null</code> for XPath errors.
   * @param sMessage
   *        The main warning message. Never <code>null</code>.
   * @param t
   *        An optional exception that is the source of the error. May be
   *        <code>null</code>.
   */
  void error (@Nullable IReadableResource aRes,
              @Nullable IPSElement aSourceElement,
              @Nonnull String sMessage,
              @Nullable Throwable t);
}
