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
package com.helger.schematron.supplementary;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.concurrent.ThreadHelper;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.sch.SchematronResourceSCH;

public final class Issue119Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue119Test.class);

  @Test
  public void testRunAndCancel () throws Exception
  {
    final ExecutorService executor = Executors.newCachedThreadPool ();

    LOGGER.info ("Spawn task");
    final Future <?> future = executor.submit ( () -> {
      LOGGER.info ("Loading Schematron");
      final ISchematronResource aSV = SchematronResourceSCH.fromClassPath ("/issues/github119/EN16931-UBL-validation-preprocessed.sch");
      try
      {
        LOGGER.info ("Applying Schematron");
        aSV.applySchematronValidation (new ClassPathResource ("/issues/github119/ubl-tc434-example1.xml"));
        LOGGER.info ("Finished applying Schematron");
      }
      catch (final Exception ex)
      {
        LOGGER.error ("Error", ex);
      }
    });

    LOGGER.info ("Wait");
    ThreadHelper.sleepSeconds (1);

    LOGGER.info ("Cancel");
    future.cancel (true);

    LOGGER.info ("Done");
  }
}
