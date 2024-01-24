/*
 * Copyright (C) 2017-2024 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;

import com.helger.commons.debug.GlobalDebug;

/**
 * Abstract base class with common functionality of Schematron ANT tasks.
 *
 * @author Philip Helger
 * @since 5.1.2
 */
public abstract class AbstractSchematronTask extends Task
{
  /**
   * <code>true</code> if the build should fail if any error occurs. Defaults to
   * <code>true</code>.
   */
  private boolean m_bFailOnError = true;

  protected AbstractSchematronTask ()
  {
    // Disables e.g. the JAXBContextCache stuff
    GlobalDebug.setDebugModeDirect (false);
  }

  protected void _debug (@Nonnull final String sMsg)
  {
    log (sMsg, Project.MSG_DEBUG);
  }

  protected void _info (@Nonnull final String sMsg)
  {
    log (sMsg, Project.MSG_INFO);
  }

  protected void _warn (@Nonnull final String sMsg)
  {
    _warn (sMsg, null);
  }

  protected void _warn (@Nonnull final String sMsg, @Nullable final Throwable t)
  {
    log (sMsg, t, Project.MSG_WARN);
  }

  protected void _error (@Nonnull final String sMsg)
  {
    _error (sMsg, null);
  }

  protected void _error (@Nonnull final String sMsg, @Nullable final Throwable t)
  {
    log (sMsg, t, Project.MSG_ERR);
  }

  protected void _errorOrFail (@Nonnull final String sMsg)
  {
    _errorOrFail (sMsg, null);
  }

  protected void _errorOrFail (@Nonnull final String sMsg, @Nullable final Throwable t)
  {
    if (m_bFailOnError)
      throw new BuildException (sMsg, t);
    _error (sMsg, t);
  }

  public void setFailOnError (final boolean bFailOnError)
  {
    m_bFailOnError = bFailOnError;

    _debug (bFailOnError ? "Will fail on error" : "Will not fail on error");
  }
}
