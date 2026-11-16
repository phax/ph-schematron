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

import java.io.File;

import org.apache.tools.ant.BuildFileRule;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;

/**
 * Test for issue #40: XML files with a DTD that is resolved via an Ant XML catalog.
 *
 * @author Philip Helger
 */
public final class Issue40v3Test
{
  @Rule
  public final BuildFileRule m_aBuildRule = new BuildFileRule ();

  @Before
  public void init ()
  {
    m_aBuildRule.configureProject ("src/test/resources/external/issues/40v3/build.xml");
    // The basedir of the build file is relative to it, but Ant takes it relative to the working directory
    m_aBuildRule.getProject ().setBaseDir (new File ("src/test/resources/external/issues/40v3/xml"));
    m_aBuildRule.getProject ().addBuildListener (new LoggingBuildListener ());
  }

  @Test
  public void testWithExternalDTD ()
  {
    m_aBuildRule.executeTarget ("check");
    assertTrue (m_aBuildRule.getLog ().contains ("test.xml' was validated against Schematron"));
    assertTrue (m_aBuildRule.getLog ().contains ("test2.xml' was validated against Schematron"));
  }
}
