/*
 * Copyright (C) 2017-2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.ant;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.log.ILogHandler;

/**
 * Forwards the messages of the shared Schematron tool logic to the log of an Ant task.
 *
 * @author Philip Helger
 * @since 11.0.0
 */
final class AntLogHandler implements ILogHandler
{
  private final Task m_aTask;

  AntLogHandler (@NonNull final Task aTask)
  {
    ValueEnforcer.notNull (aTask, "Task");
    m_aTask = aTask;
  }

  public void trace (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    m_aTask.log (sMsg, t, Project.MSG_VERBOSE);
  }

  public void debug (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    m_aTask.log (sMsg, t, Project.MSG_DEBUG);
  }

  public void info (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    m_aTask.log (sMsg, t, Project.MSG_INFO);
  }

  public void warn (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    m_aTask.log (sMsg, t, Project.MSG_WARN);
  }

  public void error (@NonNull final String sMsg, @Nullable final Throwable t)
  {
    m_aTask.log (sMsg, t, Project.MSG_ERR);
  }
}
