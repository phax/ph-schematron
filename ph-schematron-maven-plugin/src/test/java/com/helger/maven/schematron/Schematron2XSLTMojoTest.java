/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import java.io.File;

import org.apache.maven.plugin.testing.MojoRule;
import org.junit.Rule;
import org.junit.Test;

import com.helger.collection.commons.ICommonsMap;

public final class Schematron2XSLTMojoTest
{
  @Rule
  public final MojoRule m_aRule = new MojoRule ();

  @Test
  public void testCustomParameters () throws Exception
  {
    final File aPOM = new File ("src/test/resources/poms/test-sch2xslt1/pom.xml");
    assertNotNull (aPOM);
    assertTrue (aPOM.exists ());

    // Use "Configured" to get default values injected
    final Schematron2XSLTMojo aMojo = (Schematron2XSLTMojo) m_aRule.lookupConfiguredMojo (aPOM.getParentFile (),
                                                                                          "convert");
    assertNotNull (aMojo);
    // Making the files is essential, otherwise the paths are interpreted
    // relative to the test POM!
    aMojo.setSchematronDirectory (new File ("src/test/resources/schematron").getAbsoluteFile ());
    aMojo.setXsltDirectory (new File ("target/test/schematron-via-maven-plugin2").getAbsoluteFile ());

    // Test parameters from POM
    final ICommonsMap <String, String> aParams = aMojo.getParameters ();
    assertNotNull (aParams);
    assertEquals (2, aParams.size ());
    assertEquals ("true", aParams.get ("allow-foreign"));
    assertEquals ("else", aParams.get ("anything"));

    aMojo.execute ();
  }

  @Test
  public void testUseSchXslt1 () throws Exception
  {
    final File aPOM = new File ("src/test/resources/poms/test-sch2xslt2/pom.xml");
    assertNotNull (aPOM);
    assertTrue (aPOM.exists ());

    // Use "Configured" to get default values injected
    final Schematron2XSLTMojo aMojo = (Schematron2XSLTMojo) m_aRule.lookupConfiguredMojo (aPOM.getParentFile (),
                                                                                          "convert");
    assertNotNull (aMojo);
    // Making the files is essential, otherwise the paths are interpreted
    // relative to the test POM!
    aMojo.setSchematronDirectory (new File ("src/test/resources/schematron").getAbsoluteFile ());
    aMojo.setXsltDirectory (new File ("target/test/schematron-via-maven-plugin2").getAbsoluteFile ());

    // Test parameters from POM
    final String sEngine = aMojo.getSchematronEngine ();
    assertEquals ("schxslt1", sEngine);

    aMojo.execute ();
  }

  @Test
  public void testUseSchXslt2 () throws Exception
  {
    final File aPOM = new File ("src/test/resources/poms/test-sch2xslt3/pom.xml");
    assertNotNull (aPOM);
    assertTrue (aPOM.exists ());

    // Use "Configured" to get default values injected
    final Schematron2XSLTMojo aMojo = (Schematron2XSLTMojo) m_aRule.lookupConfiguredMojo (aPOM.getParentFile (),
                                                                                          "convert");
    assertNotNull (aMojo);

    // Making the files is essential, otherwise the paths are interpreted
    // relative to the test POM!
    aMojo.setSchematronDirectory (new File ("src/test/resources/schematron").getAbsoluteFile ());
    aMojo.setXsltDirectory (new File ("target/test/schematron-via-maven-plugin2").getAbsoluteFile ());

    // Test parameters from POM
    final String sEngine = aMojo.getSchematronEngine ();
    assertEquals ("schxslt2", sEngine);

    aMojo.execute ();
  }
}
