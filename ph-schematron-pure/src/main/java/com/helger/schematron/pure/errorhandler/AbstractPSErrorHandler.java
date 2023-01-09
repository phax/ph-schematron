/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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

import com.helger.commons.error.IError;
import com.helger.commons.string.ToStringGenerator;

/**
 * Abstract implementation of {@link IPSErrorHandler}.
 *
 * @author Philip Helger
 */
public abstract class AbstractPSErrorHandler implements IPSErrorHandler
{
  private final IPSErrorHandler m_aNestedErrorHandler;

  protected AbstractPSErrorHandler ()
  {
    this (null);
  }

  protected AbstractPSErrorHandler (@Nullable final IPSErrorHandler aNestedErrorHandler)
  {
    m_aNestedErrorHandler = aNestedErrorHandler;
  }

  /**
   * @return The nested error handler as passed in the constructor or
   *         <code>null</code> if none was provided.
   */
  @Nullable
  public IPSErrorHandler getNestedErrorHandler ()
  {
    return m_aNestedErrorHandler;
  }

  /**
   * The internal method to handle warnings and errors.
   *
   * @param aError
   *        The structured error. May not be <code>null</code>.
   */
  protected abstract void handleInternally (@Nonnull IError aError);

  public final void handleError (@Nonnull final IError aError)
  {
    handleInternally (aError);

    // Do we have a nested error handler?
    final IPSErrorHandler aNestedErrorHandler = getNestedErrorHandler ();
    if (aNestedErrorHandler != null)
      aNestedErrorHandler.handleError (aError);
  }

  @Override
  public String toString ()
  {
    return new ToStringGenerator (this).appendIfNotNull ("NestedErrorHandler", m_aNestedErrorHandler).getToString ();
  }
}
