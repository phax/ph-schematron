/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.schematron.supplementary;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.nio.file.Files;
import java.nio.file.Paths;

import org.junit.Test;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resourceresolver.DefaultResourceResolver;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.sch.SchematronResourceSCH;

public final class Issue110Test
{
  @Test
  public void testIncludedFilesNotDeleted () throws Exception
  {
    DefaultResourceResolver.setDebugResolve (true);
    final String sPath = "target/test-classes/issues/github110/";
    final ISchematronResource aSV = SchematronResourceSCH.fromClassPath (sPath + "ATGOV-UBL-T10.sch");
    aSV.applySchematronValidation (new FileSystemResource (sPath + "test.xml"));
    assertTrue (new FileSystemResource (sPath + "include/ATGOV-T10-abstract.sch").exists ());
    Files.delete (Paths.get (new FileSystemResource (sPath + "include/ATGOV-T10-abstract.sch").getAsURL ().toURI ()));
    assertFalse (new FileSystemResource (sPath + "include/ATGOV-T10-abstract.sch").exists ());
  }
}
