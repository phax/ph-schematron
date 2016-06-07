/**
 * Copyright (C) 2014-2016 Philip Helger (www.helger.com)
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
package com.helger.schematron.xslt;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.commons.concurrent.ManagedExecutorService;
import com.helger.commons.error.IResourceError;
import com.helger.commons.error.IResourceErrorGroup;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.CollectingTransformErrorListener;

/**
 * Test class for class {@link SchematronResourceSCHCache}
 *
 * @author Philip Helger
 */
public final class SchematronResourceSCHCacheTest
{
  private static final Logger s_aLogger = LoggerFactory.getLogger (SchematronResourceSCHCacheTest.class);
  private static final String VALID_SCHEMATRON = "test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "test-xml/valid01.xml";

  private static final int RUNS = 1000;

  @Test
  public void testValidSynchronous () throws Exception
  {
    // Ensure that the Schematron is cached
    SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON);

    final long nStart = System.nanoTime ();
    for (int i = 0; i < RUNS; ++i)
    {
      final ISchematronResource aSV = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON);
      final Document aDoc = aSV.applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
      assertNotNull (aDoc);
      if (false)
        s_aLogger.info (XMLWriter.getXMLString (aDoc));
    }
    final long nEnd = System.nanoTime ();
    s_aLogger.info ("Sync Total: " +
                    ((nEnd - nStart) / 1000) +
                    " microsecs btw. " +
                    ((nEnd - nStart) / 1000 / RUNS) +
                    " microsecs/run");
  }

  @Test
  public void testValidAsynchronous () throws Exception
  {
    // Ensure that the Schematron is cached
    SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON);

    // Create Thread pool with fixed number of threads
    final ExecutorService aSenderThreadPool = Executors.newFixedThreadPool (Runtime.getRuntime ()
                                                                                   .availableProcessors () * 2);

    final long nStart = System.nanoTime ();
    for (int i = 0; i < RUNS; ++i)
    {
      aSenderThreadPool.submit (new Runnable ()
      {
        public void run ()
        {
          try
          {
            final ISchematronResource aSV = SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON);
            final Document aDoc = aSV.applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
            assertNotNull (aDoc);
          }
          catch (final Exception ex)
          {
            throw new IllegalStateException (ex);
          }
        }
      });
    }
    new ManagedExecutorService (aSenderThreadPool).shutdownAndWaitUntilAllTasksAreFinished ();
    final long nEnd = System.nanoTime ();
    s_aLogger.info ("Async Total: " +
                    ((nEnd - nStart) / 1000) +
                    " microsecs btw. " +
                    ((nEnd - nStart) / 1000 / RUNS) +
                    " microsecs/run");
  }

  @Test
  public void testInvalidSchematron ()
  {
    assertFalse (new SchematronResourceSCH (new ClassPathResource ("test-sch/invalid01.sch")).isValidSchematron ());
    assertFalse (new SchematronResourceSCH (new ClassPathResource ("test-sch/this.file.does.not.exists")).isValidSchematron ());

    assertFalse (new SchematronResourceSCH (new FileSystemResource ("src/test/resources/test-sch/invalid01.sch")).isValidSchematron ());
    assertFalse (new SchematronResourceSCH (new FileSystemResource ("src/test/resources/test-sch/this.file.does.not.exists")).isValidSchematron ());
  }

  @Test
  public void testXSLTPreprocessor ()
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
      if (!aRes.getPath ().endsWith ("/BIICORE-UBL-T01.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T10.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T14.sch") &&
          !aRes.getPath ().endsWith ("/BIICORE-UBL-T15.sch") &&
          !aRes.getPath ().endsWith ("/CellarBook.sch") &&
          !aRes.getPath ().endsWith ("/pattern-example-with-includes.sch") &&
          !aRes.getPath ().endsWith ("/pattern-example.sch") &&
          !aRes.getPath ().endsWith ("/schematron-svrl.sch"))
      {
        final CollectingTransformErrorListener aCEH = new CollectingTransformErrorListener ();
        final ISchematronXSLTBasedProvider aPreprocessor = SchematronResourceSCHCache.createSchematronXSLTProvider (aRes,
                                                                                                                    new SCHTransformerCustomizer ().setErrorListener (aCEH)
                                                                                                                                                   .setLanguageCode ("de"));
        assertNotNull (aPreprocessor);
        assertTrue (aRes.getPath (), aPreprocessor.isValidSchematron ());
        assertNotNull (aPreprocessor.getXSLTDocument ());

        final IResourceErrorGroup aErrorGroup = aCEH.getResourceErrors ();
        if (!aErrorGroup.isEmpty ())
        {
          for (final IResourceError aError : aErrorGroup)
            if (aError.isError ())
              s_aLogger.info ("!!" + aError.getAsString (Locale.US));
          s_aLogger.info ("!!" + XMLWriter.getXMLString (aPreprocessor.getXSLTDocument ()));
        }
      }
  }
}
