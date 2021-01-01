/**
 * Copyright (C) 2017-2021 Philip Helger (www.helger.com)
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

import static org.junit.Assert.fail;

import java.io.File;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildFileRule;
import org.junit.Rule;
import org.junit.Test;

public final class Issue50Test
{
  @Rule
  public final BuildFileRule m_aBuildRule = new BuildFileRule ();

  @Test
  public void testSuccess ()
  {
    m_aBuildRule.configureProject ("src/test/resources/issues/50/build.xml");
    m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/issues/50"));
    m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
    m_aBuildRule.getProject ().executeTarget ("schematron");
  }

  @Test
  public void testFailureError ()
  {
    try
    {
      m_aBuildRule.configureProject ("src/test/resources/issues/50/build-fail-error.xml");
      m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/issues/50"));
      m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
      m_aBuildRule.getProject ().executeTarget ("schematron");
      fail ();
    }
    catch (final BuildException ex)
    {
      // Expected
    }
  }

  @Test
  public void testFailureFatal ()
  {
    try
    {
      m_aBuildRule.configureProject ("src/test/resources/issues/50/build-fail-fatal.xml");
      m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/issues/50"));
      m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
      m_aBuildRule.getProject ().executeTarget ("schematron");
      fail ();
    }
    catch (final BuildException ex)
    {
      // Expected
    }
  }

  @Test
  public void testFailureInfo ()
  {
    try
    {
      m_aBuildRule.configureProject ("src/test/resources/issues/50/build-fail-info.xml");
      m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/issues/50"));
      m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
      m_aBuildRule.getProject ().executeTarget ("schematron");
      fail ();
    }
    catch (final BuildException ex)
    {
      // Expected
    }
  }

  @Test
  public void testFailureWarn ()
  {
    try
    {
      m_aBuildRule.configureProject ("src/test/resources/issues/50/build-fail-warn.xml");
      m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/issues/50"));
      m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
      m_aBuildRule.getProject ().executeTarget ("schematron");
      fail ();
    }
    catch (final BuildException ex)
    {
      // Expected
    }
  }
}
