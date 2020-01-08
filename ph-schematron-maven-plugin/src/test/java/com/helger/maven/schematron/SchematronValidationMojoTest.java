/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.File;

import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugin.testing.MojoRule;
import org.junit.Rule;
import org.junit.Test;

import com.helger.commons.collection.impl.ICommonsMap;

public final class SchematronValidationMojoTest
{
  @Rule
  public final MojoRule m_aRule = new MojoRule ();

  @Test
  public void testCustomParameters () throws Exception
  {
    final File aPOM = new File ("src/test/resources/poms/test-validate1/pom.xml").getAbsoluteFile ();
    assertNotNull (aPOM);
    assertTrue (aPOM.exists ());
    assertTrue (aPOM.isFile ());

    // Use "Configured" to get default values injected
    final SchematronValidationMojo aMojo = (SchematronValidationMojo) m_aRule.lookupConfiguredMojo (aPOM.getParentFile (),
                                                                                                    "validate");
    assertNotNull (aMojo);
    // Making the files is essential, otherwise the paths are interpreted
    // relative to the test POM!
    aMojo.setSchematronFile (new File ("src/test/resources/schematron/check-classifications.sch").getAbsoluteFile ());
    aMojo.setXmlDirectory (new File ("src/test/resources/data").getAbsoluteFile ());
    aMojo.setXmlIncludes ("*-valid.xml");

    // Test parameters from POM
    final ICommonsMap <String, String> aParams = aMojo.getParameters ();
    assertNotNull (aParams);
    assertEquals (2, aParams.size ());
    assertEquals ("true", aParams.get ("allow-foreign"));
    assertEquals ("else", aParams.get ("anything"));

    aMojo.execute ();
  }

  @Test
  public void testFailFastDisabled () throws Exception
  {
    final File aPOM = new File ("src/test/resources/poms/test-validate2/pom.xml").getAbsoluteFile ();
    assertNotNull (aPOM);
    assertTrue (aPOM.exists ());
    assertTrue (aPOM.isFile ());

    // Use "Configured" to get default values injected
    final SchematronValidationMojo aMojo = (SchematronValidationMojo) m_aRule.lookupConfiguredMojo (aPOM.getParentFile (),
                                                                                                    "validate");
    assertNotNull (aMojo);
    // Making the files is essential, otherwise the paths are interpreted
    // relative to the test POM!
    aMojo.setSchematronFile (new File ("src/test/resources/schematron/check-classifications.sch").getAbsoluteFile ());
    aMojo.setXmlDirectory (new File ("src/test/resources/data2").getAbsoluteFile ());
    aMojo.setXmlIncludes ("*-invalid.xml");

    try
    {
      aMojo.execute ();
      fail ();
    }
    catch (final MojoFailureException ex)
    {
      // Expected error
    }
  }
}
