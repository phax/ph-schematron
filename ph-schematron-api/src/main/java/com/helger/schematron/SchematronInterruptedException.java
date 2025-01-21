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
package com.helger.schematron;

import javax.annotation.Nonnull;

/**
 * An unchecked "interrupted" exception.
 *
 * @author Philip Helger
 * @since 6.2.4
 */
public class SchematronInterruptedException extends RuntimeException
{
  /**
   * Constructor
   */
  public SchematronInterruptedException ()
  {
    super ("Interrupted Schematron compilation");
    SchematronDebug.getDebugLogger ().info ( () -> "Throwing SchematronInterruptedException()");
  }

  /**
   * Constructor with message
   *
   * @param sMsg
   *        Message to provide. Should not be <code>null</code>.
   */
  public SchematronInterruptedException (@Nonnull final String sMsg)
  {
    super ("Interrupted Schematron compilation: " + sMsg);
    SchematronDebug.getDebugLogger ().info ( () -> "Throwing SchematronInterruptedException(" + sMsg + ")");
  }
}
