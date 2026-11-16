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

import static org.easymock.EasyMock.expect;
import static org.easymock.EasyMock.replay;
import static org.easymock.EasyMock.verify;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
import org.easymock.EasyMockRule;
import org.easymock.Mock;
import org.easymock.TestSubject;
import org.junit.Rule;
import org.junit.Test;
import org.sonatype.plexus.build.incremental.BuildContext;

import com.helger.io.file.FileOperationManager;
import com.helger.io.file.SimpleFileIO;

/**
 * Test class for class {@link SchematronPreprocessMojo}.
 *
 * @author Philip Helger
 */
public final class SchematronPreprocessMojoFuncTest
{
  private static final File TARGET_DIR = new File ("target/test/preprocess");

  @Rule
  public final EasyMockRule mocks = new EasyMockRule (this);
  @Mock
  private MavenProject project;
  @Mock
  private BuildContext buildContext;

  @TestSubject
  private final SchematronPreprocessMojo OUT = new SchematronPreprocessMojo ();

  @Test
  public void testPreprocess () throws MojoExecutionException, MojoFailureException
  {
    expect (project.getBasedir ()).andReturn (new File (".")).anyTimes ();
    replay (project);

    final File aTarget = new File (TARGET_DIR, "preprocessed.sch");
    OUT.setSourceFile (new File ("src/test/resources/preprocess/abstract.sch"));
    OUT.setTargetFile (aTarget);
    OUT.setSchHeader ("my header");
    OUT.execute ();

    final String sContent = SimpleFileIO.getFileAsString (aTarget, StandardCharsets.UTF_8);
    assertTrue (sContent.contains ("<!--my header-->"));
    assertTrue (sContent.contains ("<rule context=\"ex:order\">"));
    // Empty pattern removed by default
    assertFalse (sContent.contains ("id=\"empty\""));

    verify (project);
  }

  @Test
  public void testNoOverwrite () throws MojoExecutionException, MojoFailureException
  {
    expect (project.getBasedir ()).andReturn (new File (".")).anyTimes ();
    replay (project);

    final File aTarget = new File (TARGET_DIR, "existing.sch");
    FileOperationManager.INSTANCE.createDirRecursiveIfNotExisting (TARGET_DIR);
    SimpleFileIO.writeFile (aTarget, "unchanged", StandardCharsets.UTF_8);
    OUT.setSourceFile (new File ("src/test/resources/preprocess/abstract.sch"));
    OUT.setTargetFile (aTarget);
    OUT.setOverwriteWithoutNotice (false);
    OUT.execute ();

    // Previously the file was overwritten anyway
    assertEquals ("unchanged", SimpleFileIO.getFileAsString (aTarget, StandardCharsets.UTF_8));

    verify (project);
  }
}
