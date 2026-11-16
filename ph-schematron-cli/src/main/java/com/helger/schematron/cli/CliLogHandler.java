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
package com.helger.schematron.cli;

import java.io.PrintWriter;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.NotThreadSafe;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.log.ILogHandler;

/**
 * The log handler of the command line client: info messages go to the standard output (or to the
 * error output, if the standard output carries the result), warnings and errors to the error
 * output, debug and trace messages only in verbose mode.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
@NotThreadSafe
final class CliLogHandler implements ILogHandler
{
  private final PrintWriter m_aOut;
  private final PrintWriter m_aErr;
  private final boolean m_bVerbose;
  private final boolean m_bQuiet;

  CliLogHandler (@NonNull final PrintWriter aOut,
                 @NonNull final PrintWriter aErr,
                 final boolean bVerbose,
                 final boolean bQuiet)
  {
    ValueEnforcer.notNull (aOut, "Out");
    ValueEnforcer.notNull (aErr, "Err");
    m_aOut = aOut;
    m_aErr = aErr;
    m_bVerbose = bVerbose;
    m_bQuiet = bQuiet;
  }

  private void _print (@NonNull final PrintWriter aPW,
                       @NonNull final String sPrefix,
                       @NonNull final String sMsg,
                       @Nullable final Throwable t)
  {
    // Texts of IError and SVRL messages already start with their level in brackets
    final String sLine = sMsg.startsWith ("[") ? sMsg : sPrefix + sMsg;
    if (t == null)
      aPW.println (sLine);
    else
      if (m_bVerbose)
      {
        aPW.println (sLine);
        t.printStackTrace (aPW);
      }
      else
        if (t.getMessage () != null && sMsg.contains (t.getMessage ()))
          aPW.println (sLine);
        else
          aPW.println (sLine + " (" + t.getClass ().getSimpleName () + ": " + t.getMessage () + ")");
    aPW.flush ();
  }

  public void trace (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    if (m_bVerbose)
      _print (m_aErr, "[trace] ", sMsg, t);
  }

  public void debug (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    if (m_bVerbose)
      _print (m_aErr, "[debug] ", sMsg, t);
  }

  public void info (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    if (!m_bQuiet)
      _print (m_aOut, "", sMsg, t);
  }

  public void warn (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    _print (m_aErr, "[warning] ", sMsg, t);
  }

  public void error (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    _print (m_aErr, "[error] ", sMsg, t);
  }
}
