package com.helger.schematron.ant;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildFileRule;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class Issue40v2Test
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (Issue40v2Test.class);

  @Rule
  public final BuildFileRule m_aBuildRule = new BuildFileRule ();

  @Before
  public void init ()
  {
    m_aBuildRule.configureProject ("src/test/resources/issues/40v2/build.xml");
    m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
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
