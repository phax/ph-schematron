package com.helger.schematron.ant;

import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildFileRule;
import org.apache.tools.ant.BuildListener;
import org.apache.tools.ant.Project;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class Issue40Test
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (Issue40Test.class);

  @Rule
  public final BuildFileRule m_aBuildRule = new BuildFileRule ();

  @Before
  public void init ()
  {
    m_aBuildRule.configureProject ("src/test/resources/issues/40/build.xml");
    m_aBuildRule.getProject ().addBuildListener (new BuildListener ()
    {
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
    });
  }

  @Test
  public void testWithExternalDTD ()
  {
    try
    {
      // Do not redirect stdout etc.
      m_aBuildRule.getProject ().executeTarget ("check");
    }
    catch (final BuildException ex)
    {
      s_aLogger.error ("Ooops", ex);
    }
  }
}
