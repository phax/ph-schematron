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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.transform.TransformerException;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.base.io.stream.StreamHelper;
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

  /**
   * Saxon takes very long for these (see SchematronSCHCacheTest), so they are only converted on
   * phoxtrot.
   */
  private static final ICommonsSet <String> NO_SAXON_REFERENCE = new CommonsHashSet <> ("external/test-sch/biicore/BIICORE-UBL-T01.sch",
                                                                                        "external/test-sch/biicore/BIICORE-UBL-T10.sch",
                                                                                        "external/test-sch/biicore/BIICORE-UBL-T14.sch",
                                                                                        "external/test-sch/biicore/BIICORE-UBL-T15.sch");

  /**
   * The include step nests deeper than the phoxtrot limit of 10,000 levels, which the JAXP adapter
   * cannot raise yet (phoxtrot suggestion S35).
   */
  private static final ICommonsSet <String> KNOWN_PHOXTROT_FAILURES = new CommonsHashSet <> ("external/test-sch/eugen/EUGEN-UBL-T14.sch",
                                                                                             "external/test-sch/eugen/EUGEN-UBL-T15.sch");

  private static final Pattern IS_A = Pattern.compile ("is-a=\"([^\"]+)\"");

  @NonNull
  private static ICommonsSet <String> _getAllIsA (@NonNull final IReadableResource aRes)
  {
    final ICommonsSet <String> ret = new CommonsHashSet <> ();
    final String sSCH = StreamHelper.getAllBytesAsString (aRes, XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
    final Matcher aMatcher = IS_A.matcher (sSCH);
    while (aMatcher.find ())
      ret.add (aMatcher.group (1));
    return ret;
  }

  /**
   * Replace the <code>generate-id()</code> part of the IDs of instantiated patterns (Saxon e.g.
   * <code>w141aac11</code>, phoxtrot e.g. <code>id1</code>) with a fixed text.
   */
  @NonNull
  private static String _normaliseGeneratedIDs (@NonNull final String sXSLT, @NonNull final ICommonsSet <String> aIsA)
  {
    String ret = sXSLT;
    for (final String sIsA : aIsA)
      ret = ret.replaceAll ("(?:w[0-9a-z]+|id[0-9]+)(" + Pattern.quote (sIsA) + ")", "GENERATED-ID$1");
    return ret;
  }

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
      if (NO_SAXON_REFERENCE.contains (sPath))
        continue;

      final String sSaxon = _createXSLT (aRes, aSaxon);
      nCompared++;

      final ICommonsSet <String> aIsA = _getAllIsA (aRes);
      if (!_normaliseGeneratedIDs (sSaxon, aIsA).equals (_normaliseGeneratedIDs (sPhoxtrot, aIsA)))
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
    assertEquals ("Unexpected phoxtrot failures", KNOWN_PHOXTROT_FAILURES, aFailed);
    assertTrue ("Different created XSLT: " + aDifferent, aDifferent.isEmpty ());
  }
}
