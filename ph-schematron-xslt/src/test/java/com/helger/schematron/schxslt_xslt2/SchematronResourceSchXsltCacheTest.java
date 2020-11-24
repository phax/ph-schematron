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
package com.helger.schematron.schxslt_xslt2;

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

import com.helger.commons.concurrent.ExecutorServiceHelper;
import com.helger.commons.error.IError;
import com.helger.commons.error.list.IErrorList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.schematron.xslt.ISchematronXSLTBasedProvider;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.CollectingTransformErrorListener;

/**
 * Test class for class {@link SchematronResourceSchXsltCache}
 *
 * @author Philip Helger
 */
public final class SchematronResourceSchXsltCacheTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceSchXsltCacheTest.class);
  private static final String VALID_SCHEMATRON = "test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "test-xml/valid01.xml";

  private static final int RUNS = 1000;

  @Test
  public void testValidSynchronous () throws Exception
  {
    // Ensure that the Schematron is cached
    SchematronResourceSchXslt.fromClassPath (VALID_SCHEMATRON);

    final long nStart = System.nanoTime ();
    for (int i = 0; i < RUNS; ++i)
    {
      final ISchematronResource aSV = SchematronResourceSchXslt.fromClassPath (VALID_SCHEMATRON);
      final Document aDoc = aSV.applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
      assertNotNull (aDoc);
      if (false)
        LOGGER.info (XMLWriter.getNodeAsString (aDoc));
    }
    final long nEnd = System.nanoTime ();
    LOGGER.info ("Sync Total: " + ((nEnd - nStart) / 1000) + " microsecs btw. " + ((nEnd - nStart) / 1000 / RUNS) + " microsecs/run");
  }

  @Test
  public void testValidAsynchronous () throws Exception
  {
    // Ensure that the Schematron is cached
    SchematronResourceSchXslt.fromClassPath (VALID_SCHEMATRON);

    // Create Thread pool with fixed number of threads
    final ExecutorService aSenderThreadPool = Executors.newFixedThreadPool (Runtime.getRuntime ().availableProcessors () * 2);

    final long nStart = System.nanoTime ();
    for (int i = 0; i < RUNS; ++i)
    {
      aSenderThreadPool.submit ( () -> {
        try
        {
          final ISchematronResource aSV = SchematronResourceSchXslt.fromClassPath (VALID_SCHEMATRON);
          final Document aDoc = aSV.applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
          assertNotNull (aDoc);
        }
        catch (final Exception ex)
        {
          throw new IllegalStateException (ex);
        }
      });
    }
    ExecutorServiceHelper.shutdownAndWaitUntilAllTasksAreFinished (aSenderThreadPool);
    final long nEnd = System.nanoTime ();
    LOGGER.info ("Async Total: " + ((nEnd - nStart) / 1000) + " microsecs btw. " + ((nEnd - nStart) / 1000 / RUNS) + " microsecs/run");
  }

  @Test
  public void testInvalidSchematron ()
  {
    assertFalse (new SchematronResourceSchXslt (new ClassPathResource ("test-sch/invalid01.sch")).isValidSchematron ());
    assertFalse (new SchematronResourceSchXslt (new ClassPathResource ("test-sch/this.file.does.not.exists")).isValidSchematron ());

    assertFalse (new SchematronResourceSchXslt (new FileSystemResource ("src/test/resources/test-sch/invalid01.sch")).isValidSchematron ());
    assertFalse (new SchematronResourceSchXslt (new FileSystemResource ("src/test/resources/test-sch/this.file.does.not.exists")).isValidSchematron ());
  }

  @Test
  public void testXSLTPreprocessor ()
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
      if (!aRes.getPath ().contains ("/ATGOV-UBL-") &&
          !aRes.getPath ().contains ("/ATNAT-UBL-") &&
          !aRes.getPath ().contains ("/BIICORE-UBL-") &&
          !aRes.getPath ().contains ("/BIIPROFILES-UBL-") &&
          !aRes.getPath ().contains ("/BIIRULES-") &&
          !aRes.getPath ().contains ("/DKNAT-") &&
          !aRes.getPath ().contains ("/EUGEN-UBL-") &&
          !aRes.getPath ().contains ("/ITNAT-UBL-") &&
          !aRes.getPath ().contains ("/NOGOV-") &&
          !aRes.getPath ().contains ("/NONAT-") &&
          !aRes.getPath ().endsWith ("/example-8-5.sch") &&
          !aRes.getPath ().endsWith ("/pattern-example-with-includes.sch") &&
          !aRes.getPath ().endsWith ("/pattern-example.sch"))
      {
        if (true)
          LOGGER.info (aRes.getPath ());

        final CollectingTransformErrorListener aCEH = new CollectingTransformErrorListener ();
        final ISchematronXSLTBasedProvider aPreprocessor = SchematronResourceSchXsltCache.createSchematronXSLTProvider (aRes,
                                                                                                                        new SchXsltTransformerCustomizer ().setErrorListener (aCEH)
                                                                                                                                                           .setLanguageCode ("de"));
        assertNotNull ("Failed to parse: " + aRes.toString () + " - " + aCEH.getErrorList ().toString (), aPreprocessor);
        assertTrue (aRes.getPath (), aPreprocessor.isValidSchematron ());
        assertNotNull (aPreprocessor.getXSLTDocument ());

        final IErrorList aErrorGroup = aCEH.getErrorList ();
        if (aErrorGroup.isNotEmpty ())
        {
          for (final IError aError : aErrorGroup)
            if (aError.isError ())
              LOGGER.info ("!!" + aError.getAsString (Locale.US));
          LOGGER.info ("!!" + XMLWriter.getNodeAsString (aPreprocessor.getXSLTDocument ()));
        }
      }
  }
}
