/*
 * Copyright (C) 2020-2025 Philip Helger (www.helger.com)
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
package com.helger.schematron.schxslt.xslt2;

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
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.transform.CollectingTransformErrorListener;

/**
 * Test class for class {@link SchematronResourceSchXslt_XSLT2Cache}
 *
 * @author Philip Helger
 */
public final class SchematronResourceSchXslt_XSLT2CacheTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourceSchXslt_XSLT2CacheTest.class);
  private static final String VALID_SCHEMATRON = "external/test-sch/valid01.sch";
  private static final String VALID_XMLINSTANCE = "external/test-xml/valid01.xml";

  private static final int RUNS = 1000;

  @Test
  public void testValidSynchronous () throws Exception
  {
    // Ensure that the Schematron is cached
    SchematronResourceSchXslt_XSLT2.fromClassPath (VALID_SCHEMATRON);

    final long nStart = System.nanoTime ();
    for (int i = 0; i < RUNS; ++i)
    {
      final ISchematronResource aSV = SchematronResourceSchXslt_XSLT2.fromClassPath (VALID_SCHEMATRON);
      final Document aDoc = aSV.applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
      assertNotNull (aDoc);
      if (false)
        LOGGER.info (XMLWriter.getNodeAsString (aDoc));
    }
    final long nEnd = System.nanoTime ();
    LOGGER.info ("Sync Total: " +
                 ((nEnd - nStart) / 1000) +
                 " microsecs btw. " +
                 ((nEnd - nStart) / 1000 / RUNS) +
                 " microsecs/run");
  }

  @Test
  public void testValidAsynchronous () throws Exception
  {
    // Ensure that the Schematron is cached
    SchematronResourceSchXslt_XSLT2.fromClassPath (VALID_SCHEMATRON);

    // Create Thread pool with fixed number of threads
    final ExecutorService aSenderThreadPool = Executors.newFixedThreadPool (Runtime.getRuntime ()
                                                                                   .availableProcessors () *
                                                                            2);

    final long nStart = System.nanoTime ();
    for (int i = 0; i < RUNS; ++i)
    {
      aSenderThreadPool.submit ( () -> {
        try
        {
          final ISchematronResource aSV = SchematronResourceSchXslt_XSLT2.fromClassPath (VALID_SCHEMATRON);
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
    LOGGER.info ("Async Total: " +
                 ((nEnd - nStart) / 1000) +
                 " microsecs btw. " +
                 ((nEnd - nStart) / 1000 / RUNS) +
                 " microsecs/run");
  }

  @Test
  public void testInvalidSchematron ()
  {
    assertFalse (new SchematronResourceSchXslt_XSLT2 (new ClassPathResource ("test-sch/invalid01.sch")).isValidSchematron ());
    assertFalse (new SchematronResourceSchXslt_XSLT2 (new ClassPathResource ("test-sch/this.file.does.not.exists")).isValidSchematron ());

    assertFalse (new SchematronResourceSchXslt_XSLT2 (new FileSystemResource ("src/test/resources/test-sch/invalid01.sch")).isValidSchematron ());
    assertFalse (new SchematronResourceSchXslt_XSLT2 (new FileSystemResource ("src/test/resources/test-sch/this.file.does.not.exists")).isValidSchematron ());
  }

  @Test
  public void testXSLTPreprocessor ()
  {
    if (false)
      SchematronDebug.setDebugMode (true);
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      final String sPath = aRes.getPath ();

      if ("test-sch/biicore/BIICORE-UBL-T01.sch".equals (sPath) ||
          "test-sch/biicore/BIICORE-UBL-T10.sch".equals (sPath))
      {
        /**
         * SchXslt preprocessor error ; SystemID:
         * jar:file:/C:/Users/phili/.m2/repository/name/dmaus/schxslt/schxslt/1.9.4/schxslt-1.9.4.jar!/xslt/2.0/expand.xsl;
         * Line#: 99; Column#: 23
         * net.sf.saxon.trans.XPathException$StackOverflow: Too many nested
         * function calls. May be due to infinite recursion
         */
        continue;
      }

      if ("test-sch/biirules/BIIRULES-Facturae-T10.sch".equals (sPath) ||
          "test-sch/biirules/BIIRULES-UBL-T01.sch".equals (sPath) ||
          "test-sch/biirules/BIIRULES-UBL-T10.sch".equals (sPath) ||
          "test-sch/biirules/BIIRULES-UBL-T14.sch".equals (sPath) ||
          "test-sch/biirules/BIIRULES-UBL-T15.sch".equals (sPath) ||
          "test-sch/nonat/NONAT-ubl-T17.sch".equals (sPath))
      {
        // Saxon 12.0 issue
        /**
         * java.lang.NullPointerException at
         * net.sf.saxon.expr.parser.LoopLifter.markDependencies(LoopLifter.java:221)
         * at
         * net.sf.saxon.expr.parser.LoopLifter.gatherInfo(LoopLifter.java:171)
         */
        continue;
      }

      if (true)
        LOGGER.info (sPath);

      final CollectingTransformErrorListener aCEH = new CollectingTransformErrorListener ();
      final ISchematronXSLTBasedProvider aPreprocessor = SchematronResourceSchXslt_XSLT2Cache.createSchematronXSLTProvider (aRes,
                                                                                                                            new TransformerCustomizerSchXslt_XSLT2 ().setErrorListener (aCEH)
                                                                                                                                                                     .setLanguageCode ("de"));
      assertNotNull ("Failed to parse: " + aRes.toString () + " - " + aCEH.getErrorList ().toString (), aPreprocessor);
      assertTrue (sPath, aPreprocessor.isValidSchematron ());
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
