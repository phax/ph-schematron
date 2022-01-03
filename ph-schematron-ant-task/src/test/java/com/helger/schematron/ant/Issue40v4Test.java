/*
 * Copyright (C) 2017-2022 Philip Helger (www.helger.com)
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

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildFileRule;
import org.junit.Before;
import org.junit.Test;

public final class Issue40v4Test
{
  public final BuildFileRule m_aBuildRule = new BuildFileRule ();

  @Before
  public void init ()
  {
    m_aBuildRule.configureProject ("src/test/resources/issues/40v4/build.xml");
    m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener (false));
  }

  @Test
  public void testWithExternalDTD ()
  {
    try
    {
      // Do not redirect stdout etc.
      m_aBuildRule.getProject ().executeTarget ("check");
      fail ();
    }
    catch (final BuildException ex)
    {
      // Expected
    }
  }
}
