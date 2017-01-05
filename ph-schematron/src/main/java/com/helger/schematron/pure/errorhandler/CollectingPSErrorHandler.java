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

import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.ext.ICommonsList;
import com.helger.commons.error.IError;
import com.helger.commons.error.SingleError;
import com.helger.commons.error.SingleError.SingleErrorBuilder;
import com.helger.commons.error.level.IErrorLevel;
import com.helger.commons.error.list.ErrorList;
import com.helger.commons.error.list.IErrorList;
import com.helger.commons.error.location.ErrorLocation;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.lang.ClassHelper;
import com.helger.commons.state.EChange;
import com.helger.commons.string.ToStringGenerator;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.schematron.pure.model.IPSHasID;

/**
 * An implementation if {@link IPSErrorHandler} that collects all error
 * messages.
 *
 * @author Philip Helger
 */
public class CollectingPSErrorHandler extends AbstractPSErrorHandler
{
  private final ErrorList m_aErrors = new ErrorList ();

  public CollectingPSErrorHandler ()
  {
    super ();
  }

  public CollectingPSErrorHandler (@Nullable final IPSErrorHandler aNestedErrorHandler)
  {
    super (aNestedErrorHandler);
  }

  @Override
  protected void handle (@Nullable final IReadableResource aRes,
                         @Nonnull final IErrorLevel aErrorLevel,
                         @Nullable final IPSElement aSourceElement,
                         @Nonnull final String sMessage,
                         @Nullable final Throwable t)
  {
    final SingleErrorBuilder aBuilder = SingleError.builder ()
                                                   .setErrorLevel (aErrorLevel)
                                                   .setErrorLocation (aRes == null ? null
                                                                                   : new ErrorLocation (aRes.getResourceID ()))
                                                   .setErrorText (sMessage)
                                                   .setLinkedException (t);

    if (aSourceElement != null)
    {
      String sField = ClassHelper.getClassLocalName (aSourceElement);
      if (aSourceElement instanceof IPSHasID && ((IPSHasID) aSourceElement).hasID ())
        sField += " [ID=" + ((IPSHasID) aSourceElement).getID () + "]";
      aBuilder.setErrorFieldName (sField);
    }
    m_aErrors.add (aBuilder.build ());
  }

  @Nonnull
  @ReturnsMutableCopy
  public IErrorList getResourceErrors ()
  {
    return m_aErrors.getClone ();
  }

  @Nonnull
  public ICommonsList <IError> getAllResourceErrors ()
  {
    return m_aErrors.getAllItems ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public IErrorList getAllFailures ()
  {
    return m_aErrors.getAllFailures ();
  }

  @Nonnull
  @ReturnsMutableCopy
  public IErrorList getAllErrors ()
  {
    return m_aErrors.getAllErrors ();
  }

  /**
   * Clear all currently stored errors. This might be helpful, if the same error
   * handler is used several times.
   *
   * @return {@link EChange#CHANGED} if at least one item was cleared.
   */
  @Nonnull
  public EChange clearResourceErrors ()
  {
    return m_aErrors.clear ();
  }

  /**
   * @return <code>true</code> if no error is contained, <code>false</code> if
   *         at least one error is contained.
   */
  public boolean isEmpty ()
  {
    return m_aErrors.isEmpty ();
  }

  @Override
  public String toString ()
  {
    return ToStringGenerator.getDerived (super.toString ()).appendIfNotNull ("errors", m_aErrors).toString ();
  }
}
