/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.io.File;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;

/**
 * Test for GitHub issue 182
 *
 * @author Bertrand Lorentz
 */
public final class Issue182Test
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue182Test.class);

  private static final String SCH = "src/test/resources/external/issues/github182/schematron.sch";
  private static final String XML_A = "src/test/resources/external/issues/github182/testA.xml";
  private static final String XML_B = "src/test/resources/external/issues/github182/testB.xml";

  private SchematronResourcePure m_aSCH;

  final private AtomicInteger errorCount = new AtomicInteger(0);

  @Before
  public void loadSchematron()
  {
    if (m_aSCH == null)
      m_aSCH = SchematronResourcePure.fromFile (SCH);
  }

  public void validateAndProduceSVRL (final File aXML) throws Exception
  {
    m_aSCH.validateCompletely (new LoggingPSErrorHandler ());

    // Perform validation
    final SchematronOutputType aSVRL = m_aSCH.applySchematronValidationToSVRL (new FileSystemResource (aXML));
    assertNotNull (aSVRL);
    if (true)
      LOGGER.info (aXML.getName() + " " + new SVRLMarshaller ().getAsString (aSVRL));

    if (SVRLHelper.getAllFailedAssertionsAndSuccessfulReports (aSVRL).size () != 0)
      errorCount.incrementAndGet();
  }

  @Test
  public void testConcurrency () throws Exception
  {
    int numberOfThreads = 2;
    ExecutorService service = Executors.newFixedThreadPool (10);
    CountDownLatch startLatch = new CountDownLatch (1);
    CountDownLatch finishedLatch = new CountDownLatch (numberOfThreads);
    for (int i = 0; i < numberOfThreads; i += 2) {
      service.execute (() -> {
        try
        {
          startLatch.await ();
          validateAndProduceSVRL (new File (XML_A));
        }
        catch (Exception e)
        {
          LOGGER.error ("Error validating XML A", e);
        }
        finishedLatch.countDown ();
      });
      service.execute(() -> {
        try
        {
          startLatch.await ();
          validateAndProduceSVRL (new File (XML_B));
        }
        catch (Exception e)
        {
          LOGGER.error ("Error validating XML B", e);
        }
        finishedLatch.countDown ();
      });
    }
    // All threads are waiting on startLatch, release them all together
    startLatch.countDown ();
    // Wait until all threads are finished
    finishedLatch.await ();

    assertEquals (0, errorCount.get());
  }
}
