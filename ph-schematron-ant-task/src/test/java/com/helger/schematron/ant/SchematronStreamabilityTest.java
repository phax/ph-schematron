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
package com.helger.schematron.ant;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.File;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildFileRule;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;

/**
 * Test class for class {@link SchematronStreamability}.
 *
 * @author Philip Helger
 */
public final class SchematronStreamabilityTest
{
  @Rule
  public final BuildFileRule m_aBuildRule = new BuildFileRule ();

  @Before
  public void init ()
  {
    m_aBuildRule.configureProject ("src/test/resources/external/streamability/build.xml");
    m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/external/streamability"));
    m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
  }

  @Test
  public void testBurstAllowed ()
  {
    m_aBuildRule.executeTarget ("burst");
    assertTrue (m_aBuildRule.getLog ().contains ("burst: 1 pattern, 1 rule (0 motionless, 1 burst, 0 non-local)"));
  }

  @Test
  public void testNonLocalFails ()
  {
    try
    {
      m_aBuildRule.executeTarget ("non-local");
      fail ();
    }
    catch (final BuildException ex)
    {
      assertTrue (ex.getMessage (), ex.getMessage ().contains ("is non-local, but at most burst is allowed"));
    }
  }

  @Test
  public void testReportOnly ()
  {
    m_aBuildRule.executeTarget ("report-only");
    assertTrue (m_aBuildRule.getLog ().contains ("non-local (axis step //)"));
  }

  @Test
  public void testUnknownMaximumClass ()
  {
    try
    {
      m_aBuildRule.executeTarget ("unknown-class");
      fail ();
    }
    catch (final BuildException ex)
    {
      assertTrue (ex.getMessage (), ex.getMessage ().contains ("'fast' is unknown"));
    }
  }
}
