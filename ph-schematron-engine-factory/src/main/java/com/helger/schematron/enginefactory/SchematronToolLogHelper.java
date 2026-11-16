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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.log.ILogHandler;
import com.helger.diagnostics.error.level.EErrorLevel;
import com.helger.diagnostics.error.level.IErrorLevel;

/**
 * Helper to log to an {@link ILogHandler} with the level of an {@link IErrorLevel}.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@Immutable
public final class SchematronToolLogHelper
{
  private SchematronToolLogHelper ()
  {}

  /**
   * Log a message with the logging level matching the provided error level: error and fatal error
   * as error, warning as warning, everything else as info.
   *
   * @param aLogHandler
   *        The log handler to use. May not be <code>null</code>.
   * @param aErrorLevel
   *        The error level to use. May not be <code>null</code>.
   * @param sMsg
   *        The message to log. May not be <code>null</code>.
   */
  public static void log (@NonNull final ILogHandler aLogHandler,
                          @NonNull final IErrorLevel aErrorLevel,
                          @NonNull final String sMsg)
  {
    if (aErrorLevel.isGE (EErrorLevel.ERROR))
      aLogHandler.error (sMsg);
    else
      if (aErrorLevel.isGE (EErrorLevel.WARN))
        aLogHandler.warn (sMsg);
      else
        aLogHandler.info (sMsg);
  }
}
