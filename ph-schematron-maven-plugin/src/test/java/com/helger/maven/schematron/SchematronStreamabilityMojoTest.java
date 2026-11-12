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
package com.helger.maven.schematron;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.File;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugin.testing.MojoRule;
import org.junit.Rule;
import org.junit.Test;

/**
 * Test class for class {@link SchematronStreamabilityMojo}.
 *
 * @author Philip Helger
 */
public final class SchematronStreamabilityMojoTest
{
  @Rule
  public final MojoRule m_aRule = new MojoRule ();

  private SchematronStreamabilityMojo _getMojo () throws Exception
  {
    final File aPOM = new File ("src/test/resources/poms/test-streamability/pom.xml").getAbsoluteFile ();
    assertTrue (aPOM.isFile ());

    // Use "Configured" to get default values injected
    final SchematronStreamabilityMojo aMojo = (SchematronStreamabilityMojo) m_aRule.lookupConfiguredMojo (aPOM.getParentFile (),
                                                                                                          "streamability");
    assertNotNull (aMojo);
    return aMojo;
  }

  @Test
  public void testBurstAllowed () throws Exception
  {
    final SchematronStreamabilityMojo aMojo = _getMojo ();
    // Making the files is essential, otherwise the paths are interpreted
    // relative to the test POM!
    aMojo.setSchematronFile (new File ("src/test/resources/schematron/streamability-burst.sch").getAbsoluteFile ());
    aMojo.execute ();
  }

  @Test
  public void testNonLocalFails () throws Exception
  {
    final SchematronStreamabilityMojo aMojo = _getMojo ();
    // The uniqueness test reads all paragraphs
    aMojo.setSchematronFile (new File ("src/test/resources/schematron/streamability-non-local.sch").getAbsoluteFile ());
    try
    {
      aMojo.execute ();
      fail ();
    }
    catch (final MojoFailureException ex)
    {
      // Expected error
    }

    // Without a maximum the report is only logged
    aMojo.setMaximumClass (null);
    aMojo.execute ();
  }

  @Test
  public void testUnknownMaximumClass () throws Exception
  {
    final SchematronStreamabilityMojo aMojo = _getMojo ();
    aMojo.setSchematronFile (new File ("src/test/resources/schematron/streamability-burst.sch").getAbsoluteFile ());
    aMojo.setMaximumClass ("fast");
    try
    {
      aMojo.execute ();
      fail ();
    }
    catch (final MojoExecutionException ex)
    {
      // Expected error
    }
  }
}
