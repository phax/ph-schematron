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
package com.helger.schematron.pure.errorhandler;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EChange;
import com.helger.base.tostring.ToStringGenerator;
import com.helger.diagnostics.error.IError;
import com.helger.diagnostics.error.list.ErrorList;
import com.helger.diagnostics.error.list.IErrorList;

/**
 * Abstract collecting {@link IPSErrorHandler} that collects all error messages
 * in an error list.
 *
 * @author Philip Helger
 * @since 4.2.1
 */
public abstract class AbstractCollectingPSErrorHandler extends AbstractPSErrorHandler
{
  private final ErrorList m_aErrorList;

  public AbstractCollectingPSErrorHandler (@NonNull final ErrorList aErrorList,
                                           @Nullable final IPSErrorHandler aNestedErrorHandler)
  {
    super (aNestedErrorHandler);
    m_aErrorList = ValueEnforcer.notNull (aErrorList, "ErrorList");
  }

  @Override
  protected void handleInternally (@NonNull final IError aError)
  {
    m_aErrorList.add (aError);
  }

  @NonNull
  @ReturnsMutableCopy
  public IErrorList getErrorList ()
  {
    return m_aErrorList.getClone ();
  }

  @NonNull
  @ReturnsMutableCopy
  public IErrorList getAllFailures ()
  {
    return m_aErrorList.getAllFailures ();
  }

  @NonNull
  @ReturnsMutableCopy
  public IErrorList getAllErrors ()
  {
    return m_aErrorList.getAllErrors ();
  }

  /**
   * Clear all currently stored errors. This might be helpful, if the same error
   * handler is used several times.
   *
   * @return {@link EChange#CHANGED} if at least one item was cleared.
   */
  @NonNull
  public EChange clearResourceErrors ()
  {
    return m_aErrorList.removeAll ();
  }

  /**
   * @return <code>true</code> if no error is contained, <code>false</code> if
   *         at least one error is contained.
   */
  public boolean isEmpty ()
  {
    return m_aErrorList.isEmpty ();
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ()).append ("ErrorList", m_aErrorList).getToString ();
  }
}
