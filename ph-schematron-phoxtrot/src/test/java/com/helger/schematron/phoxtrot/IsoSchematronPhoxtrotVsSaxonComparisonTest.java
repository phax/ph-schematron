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
package com.helger.schematron.phoxtrot;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.File;

import javax.xml.transform.TransformerException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.base.timing.StopWatch;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.io.file.FilenameHelper;
import com.helger.io.file.SimpleFileIO;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.saxon.SaxonXsltProcessor;
import com.helger.schematron.sch.SchematronProviderXSLTFromSCH;
import com.helger.schematron.sch.SchematronSCHConfig;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Compare the XSLT that the ISO Schematron pipeline creates on phoxtrot with the one it creates on
 * Saxon, for all valid Schematron test files. Differences are written to
 * <code>target/pipeline-compare/iso</code>.
 * <p>
 * Accepted differences:
 * <ul>
 * <li>The IDs of patterns instantiated from abstract patterns are built from
 * <code>generate-id()</code> in <code>iso_abstract_expand.xsl</code>, whose values are
 * implementation-dependent. They are normalised before the comparison.</li>
 * </ul>
 *
 * @author Philip Helger
 */
public final class IsoSchematronPhoxtrotVsSaxonComparisonTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (IsoSchematronPhoxtrotVsSaxonComparisonTest.class);
  private static final File TARGET_DIR = new File ("target/pipeline-compare/iso");

  @Nullable
  private static String _createXSLT (@NonNull final IReadableResource aRes,
                                     @NonNull final ISchematronXsltProcessor aProcessor) throws TransformerException
  {
    final StopWatch aSW = StopWatch.createdStarted ();
    final Document aDoc = SchematronProviderXSLTFromSCH.createSchematronXSLT (SchematronSCHConfig.builder (aRes)
                                                                                                    .xsltProcessor (aProcessor)
                                                                                                    .build ());
    aSW.stop ();
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Created XSLT of " + aRes.getPath () + " on " + aProcessor.getID () + " in " + aSW.getMillis () + " ms");
    return XMLWriter.getNodeAsString (aDoc, XMLWriterSettings.DEFAULT_XML_SETTINGS);
  }

  @Test
  public void testCreatedXSLTIsEqual () throws Exception
  {
    final ISchematronXsltProcessor aSaxon = new SaxonXsltProcessor ();
    final ISchematronXsltProcessor aPhoxtrot = new PhoxtrotXsltProcessor ();

    final ICommonsList <String> aDifferent = new CommonsArrayList <> ();
    final ICommonsSet <String> aFailed = new CommonsHashSet <> ();
    int nCompared = 0;
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      final String sPath = aRes.getPath ();
      final String sPhoxtrot;
      try
      {
        sPhoxtrot = _createXSLT (aRes, aPhoxtrot);
      }
      catch (final TransformerException ex)
      {
        LOGGER.warn ("phoxtrot failed on " + sPath + ": " + ex.getMessage ());
        aFailed.add (sPath);
        continue;
      }
      if (SVRLComparisonHelper.NO_SAXON_REFERENCE.contains (sPath))
        continue;

      final String sSaxon = _createXSLT (aRes, aSaxon);
      nCompared++;

      final ICommonsSet <String> aIsA = SVRLComparisonHelper.getAllIsA (aRes);
      if (!SVRLComparisonHelper.normaliseGeneratedIDs (sSaxon, aIsA).equals (SVRLComparisonHelper.normaliseGeneratedIDs (sPhoxtrot, aIsA)))
      {
        aDifferent.add (sPath);
        final String sBaseName = FilenameHelper.getWithoutExtension (sPath).replace ('/', '_');
        SimpleFileIO.writeFile (new File (TARGET_DIR, sBaseName + ".saxon.xslt"),
                                sSaxon,
                                XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
        SimpleFileIO.writeFile (new File (TARGET_DIR, sBaseName + ".phoxtrot.xslt"),
                                sPhoxtrot,
                                XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
      }
    }
    LOGGER.info ("Compared the created XSLT of " +
                 nCompared +
                 " Schematron files: " +
                 aDifferent.size () +
                 " differ; phoxtrot failed on " +
                 aFailed.size ());
    assertEquals ("Unexpected phoxtrot failures", SVRLComparisonHelper.KNOWN_PHOXTROT_FAILURES, aFailed);
    assertTrue ("Different created XSLT: " + aDifferent, aDifferent.isEmpty ());
  }
}
