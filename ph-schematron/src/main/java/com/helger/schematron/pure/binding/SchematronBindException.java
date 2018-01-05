/**
 * Copyright (C) 2014-2018 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.binding;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.schematron.SchematronException;

/**
 * Schematron exception that happens during binding.
 * 
 * @author Philip Helger
 */
public class SchematronBindException extends SchematronException
{
  /**
   * Constructor
   * 
   * @param sMsg
   *        error message
   */
  public SchematronBindException (@Nonnull final String sMsg)
  {
    super (sMsg);
  }

  /**
   * Constructor
   * 
   * @param sMsg
   *        error message
   * @param t
   *        Nested exception
   */
  public SchematronBindException (@Nonnull final String sMsg, @Nullable final Throwable t)
  {
    super (sMsg, t);
  }
}
