/*
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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

import static org.easymock.EasyMock.expect;
import static org.easymock.EasyMock.replay;
import static org.easymock.EasyMock.verify;
import static org.junit.Assert.fail;

import java.io.File;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
import org.easymock.EasyMockRule;
import org.easymock.Mock;
import org.easymock.TestSubject;
import org.junit.Rule;
import org.junit.Test;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.schematron.ESchematronMode;

public final class SchematronValidationMojoFuncTest
{
  @Rule
  public final EasyMockRule mocks = new EasyMockRule (this);
  @Mock
  private MavenProject project;
  @Mock
  private BuildContext buildContext;

  @TestSubject
  private final SchematronValidationMojo OUT = new SchematronValidationMojo ();

  @Test
  public void testMavenPluginValidTestGood () throws MojoExecutionException, MojoFailureException
  {
    expect (project.getBasedir ()).andReturn (new File (".")).anyTimes ();
    replay (project);

    OUT.setSchematronFile (new File ("src/test/resources/schematron/check-classifications.sch"));
    OUT.setSchematronProcessingEngine (ESchematronMode.PURE.getID ());
    OUT.setXmlDirectory (new File ("src/test/resources/data"));
    OUT.setXmlIncludes (new String [] { "*.xml" });
    OUT.setXmlExcludes (new String [] { "*-invalid.xml" });
    OUT.execute ();

    verify (project);
  }

  @Test
  public void testMavenPluginValidTestBad () throws MojoExecutionException, MojoFailureException
  {
    expect (project.getBasedir ()).andReturn (new File (".")).anyTimes ();
    replay (project);

    OUT.setSchematronFile (new File ("src/test/resources/schematron/check-classifications.sch"));
    OUT.setSchematronProcessingEngine (ESchematronMode.PURE.getID ());
    OUT.setXmlErrorDirectory (new File ("src/test/resources/data"));
    OUT.setXmlErrorIncludes (new String [] { "*-invalid.xml" });
    OUT.execute ();

    verify (project);
  }

  @Test
  public void testMavenPluginInvalid () throws MojoExecutionException
  {
    expect (project.getBasedir ()).andReturn (new File (".")).anyTimes ();
    replay (project);

    OUT.setSchematronFile (new File ("src/test/resources/schematron/check-classifications.sch"));
    OUT.setSchematronProcessingEngine (ESchematronMode.PURE.getID ());
    OUT.setXmlDirectory (new File ("src/test/resources/data"));
    OUT.setXmlIncludes (new String [] { "*.xml" });
    OUT.setXmlExcludes (new String [] { "*-valid.xml" });
    try
    {
      OUT.execute ();
      fail ();
    }
    catch (final MojoFailureException ex)
    {
      // expected
    }

    verify (project);
  }
}
