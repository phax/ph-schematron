package com.helger.schematron.ant;

import org.apache.tools.ant.BuildFileRule;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;

import com.helger.commons.system.SystemProperties;

public final class Issue40Test
{
  @Rule
  public final BuildFileRule buildRule = new BuildFileRule ();

  @Before
  public void init ()
  {
    SystemProperties.setPropertyValue ("javax.xml.accessExternalDTD", "all");
    buildRule.configureProject ("src/test/resources/issues/40/build.xml");
  }

  @Test
  public void testWithExternalDTD ()
  {
    buildRule.executeTarget ("check");
  }
}
