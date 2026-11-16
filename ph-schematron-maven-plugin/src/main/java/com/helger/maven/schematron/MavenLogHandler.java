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
package com.helger.maven.schematron;

import org.apache.maven.plugin.logging.Log;
import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.log.ILogHandler;

/**
 * Forwards the messages of the shared Schematron tool logic to the Maven log. The Maven log has no
 * trace level, so trace messages are logged as debug.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
final class MavenLogHandler implements ILogHandler
{
  private final Log m_aLog;

  MavenLogHandler (@NonNull final Log aLog)
  {
    ValueEnforcer.notNull (aLog, "Log");
    m_aLog = aLog;
  }

  public void trace (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    debug (sMsg, t);
  }

  public void debug (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    // The Maven log does not accept a null Throwable
    if (t == null)
      m_aLog.debug (sMsg);
    else
      m_aLog.debug (sMsg, t);
  }

  public void info (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    if (t == null)
      m_aLog.info (sMsg);
    else
      m_aLog.info (sMsg, t);
  }

  public void warn (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    if (t == null)
      m_aLog.warn (sMsg);
    else
      m_aLog.warn (sMsg, t);
  }

  public void error (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    if (t == null)
      m_aLog.error (sMsg);
    else
      m_aLog.error (sMsg, t);
  }
}
