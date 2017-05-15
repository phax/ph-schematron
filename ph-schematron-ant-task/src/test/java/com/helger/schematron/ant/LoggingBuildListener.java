/**
 * Copyright (C) 2017 Philip Helger (www.helger.com)
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

import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.BuildListener;
import org.apache.tools.ant.Project;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

final class LoggingBuildListener implements BuildListener
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (LoggingBuildListener.class);

  public void taskStarted (final BuildEvent aEvent)
  {}

  public void taskFinished (final BuildEvent aEvent)
  {}

  public void targetStarted (final BuildEvent aEvent)
  {}

  public void targetFinished (final BuildEvent aEvent)
  {}

  public void messageLogged (final BuildEvent aEvent)
  {
    if (aEvent.getPriority () <= Project.MSG_ERR)
      s_aLogger.error (aEvent.getMessage (), aEvent.getException ());
    else
      if (aEvent.getPriority () <= Project.MSG_WARN)
        s_aLogger.warn (aEvent.getMessage (), aEvent.getException ());
      else
        if (aEvent.getPriority () <= Project.MSG_INFO)
          s_aLogger.info (aEvent.getMessage (), aEvent.getException ());
        else
          s_aLogger.debug (aEvent.getMessage (), aEvent.getException ());
  }

  public void buildStarted (final BuildEvent aEvent)
  {}

  public void buildFinished (final BuildEvent aEvent)
  {}
}
