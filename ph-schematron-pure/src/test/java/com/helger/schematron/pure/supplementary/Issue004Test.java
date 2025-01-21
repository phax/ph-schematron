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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertTrue;

import java.io.File;

import org.junit.Ignore;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;

public final class Issue004Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue004Test.class);

  @Test
  @Ignore
  public void testReadFromUNCWithInclude () throws Exception
  {
    final File aSchematronFile = new File ("\\\\PC61826\\share\\example-8-5.sch");
    if (aSchematronFile.exists ())
    {
      final SchematronResourcePure aResPure = SchematronResourcePure.fromFile (aSchematronFile);
      aResPure.setErrorHandler (new LoggingPSErrorHandler ());
      aResPure.validateCompletely ();
      assertTrue (aResPure.isValidSchematron ());
    }
    else
      LOGGER.info ("Test ignored because file does not exist");
  }
}
