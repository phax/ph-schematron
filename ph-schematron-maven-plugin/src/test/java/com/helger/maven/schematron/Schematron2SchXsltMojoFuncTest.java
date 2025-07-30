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

import static org.easymock.EasyMock.expect;
import static org.easymock.EasyMock.replay;
import static org.easymock.EasyMock.verify;

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

import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsMap;

public final class Schematron2SchXsltMojoFuncTest
{
  @Rule
  public final EasyMockRule mocks = new EasyMockRule (this);
  @Mock
  private MavenProject project;
  @Mock
  private BuildContext buildContext;

  @TestSubject
  private final Schematron2SchXsltMojo OUT = new Schematron2SchXsltMojo ();

  @Test
  public void testMavenPlugin () throws MojoExecutionException, MojoFailureException
  {
    expect (project.getBasedir ()).andReturn (new File (".")).anyTimes ();
    replay (project);

    // Note: default values are not used here
    OUT.setSchematronDirectory (new File ("src/test/resources/schematron"));
    OUT.setSchematronPattern ("**/*.sch");
    OUT.setXsltDirectory (new File ("target/test/schematron-via-maven-plugin"));
    OUT.setXsltExtension (".xslt");

    final ICommonsMap <String, String> aParams = new CommonsHashMap <> ();
    aParams.put ("allow-foreign", "true");
    OUT.setParameters (aParams);

    OUT.execute ();

    verify (project);
  }
}
