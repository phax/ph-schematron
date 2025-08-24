/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import com.helger.base.lang.clazz.ClassHelper;
import com.helger.diagnostics.error.SingleError;
import com.helger.schematron.ISchematronErrorHandler;
import com.helger.schematron.pure.model.IPSElement;
import com.helger.schematron.pure.model.IPSHasID;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

/**
 * Base interface for a Pure Schematron error handler.<br>
 * Rewritten in v5.6.0
 *
 * @author Philip Helger
 */
public interface IPSErrorHandler extends ISchematronErrorHandler
{
  default void error (@Nonnull final IPSElement aSourceElement, @Nonnull final String sMessage)
  {
    handleError (SingleError.builderError ()
                            .errorFieldName (getErrorFieldName (aSourceElement))
                            .errorText (sMessage)
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
