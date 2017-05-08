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
          s_aLogger.info (aEvent.getMessage (), aEvent.getException ());
  }

  public void buildStarted (final BuildEvent aEvent)
  {}

  public void buildFinished (final BuildEvent aEvent)
  {}
}
