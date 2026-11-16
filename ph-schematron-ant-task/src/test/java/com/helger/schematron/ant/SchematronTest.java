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

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.File;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildFileRule;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;

/**
 * Test class for class {@link Schematron}.
 *
 * @author Philip Helger
 */
public final class SchematronTest
{
  @Rule
  public final BuildFileRule m_aBuildRule = new BuildFileRule ();

  @Before
  public void init ()
  {
    m_aBuildRule.configureProject ("src/test/resources/external/tools/build.xml");
    m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/external/tools"));
    m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
  }

  @Test
  public void testWarningsDontFail ()
  {
    m_aBuildRule.executeTarget ("validate-warnings");
    assertTrue (m_aBuildRule.getLog ().contains ("1 Schematron warning and 1 Schematron information found"));
  }

  @Test
  public void testIgnoreWarnings ()
  {
    m_aBuildRule.executeTarget ("validate-ignore-warnings");
    assertTrue (m_aBuildRule.getLog ().contains ("Ignoring 2 Schematron warnings and information"));
  }

  @Test
  public void testCollectWithoutFailFast ()
  {
    try
    {
      m_aBuildRule.executeTarget ("validate-collect");
      fail ();
    }
    catch (final BuildException ex)
    {
      assertTrue (ex.getMessage (), ex.getMessage ().startsWith ("2 errors found:"));
    }
  }

  @Test
  public void testLenient ()
  {
    m_aBuildRule.executeTarget ("validate-lenient");
  }
}
