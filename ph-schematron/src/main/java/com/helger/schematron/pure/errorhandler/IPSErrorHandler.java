/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
import com.helger.commons.error.SingleError;
import com.helger.commons.lang.ClassHelper;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.schematron.pure.model.IPSHasID;

/**
 * Base interface for a Pure Schematron error handler.<br>
 * Rewritten in v5.6.0
 *
 * @author Philip Helger
 */
public interface IPSErrorHandler
{
  /**
   * Handle a warning or error
   *
   * @param aError
   *        The structured error. May not be <code>null</code>.
   */
  void handleError (@Nonnull IError aError);

  default void error (@Nonnull final IPSElement aSourceElement, @Nonnull final String sMessage)
  {
    handleError (SingleError.builderError ()
                            .setErrorFieldName (getErrorFieldName (aSourceElement))
                            .setErrorText (sMessage)
                            .build ());
  }

  @Nullable
  static String getErrorFieldName (@Nullable final IPSElement aSourceElement)
  {
    if (aSourceElement == null)
      return null;
    String sField = ClassHelper.getClassLocalName (aSourceElement);
    if (aSourceElement instanceof IPSHasID && ((IPSHasID) aSourceElement).hasID ())
      sField += " [ID=" + ((IPSHasID) aSourceElement).getID () + "]";
    return sField;
  }
}
