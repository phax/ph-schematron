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
package com.helger.schematron.it;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.util.Collection;

import javax.xml.transform.TransformerException;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.io.file.FilenameHelper;
import com.helger.io.file.SimpleFileIO;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.phoxtrot.PhoxtrotXsltProcessor;
import com.helger.schematron.saxon.SaxonXsltProcessor;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Compare the XSLT that the Schematron pipelines create on phoxtrot with the one they create on
 * Saxon, for all Schematron test files of the pipeline. Differences are written to
 * <code>target/pipeline-compare/&lt;pipeline&gt;</code>.
 * <p>
 * Accepted differences, each filed as phoxtrot suggestion: see {@link SVRLComparisonHelper} and the
 * known failures of {@link ComparedPipeline}.
 *
 * @author Philip Helger
 */
@RunWith (Parameterized.class)
public final class CreatedXSLTPhoxtrotVsSaxonComparisonTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (CreatedXSLTPhoxtrotVsSaxonComparisonTest.class);

  private final ComparedPipeline m_aPipeline;

  public CreatedXSLTPhoxtrotVsSaxonComparisonTest (@NonNull final ComparedPipeline aPipeline)
  {
    m_aPipeline = aPipeline;
  }

  @Parameterized.Parameters (name = "{0}")
  public static Collection <Object []> getAllPipelines ()
  {
    return new CommonsArrayList <> (new Object [] { ComparedPipeline.ISO },
                                    new Object [] { ComparedPipeline.SCHXSLT1 },
                                    new Object [] { ComparedPipeline.SCHXSLT2 });
  }

  @NonNull
  private String _createXSLT (@NonNull final IReadableResource aRes,
                              @NonNull final ISchematronXsltProcessor aProcessor) throws TransformerException
  {
    return XMLWriter.getNodeAsString (m_aPipeline.getXSLTCreator ().createXSLT (aRes, aProcessor),
                                      XMLWriterSettings.DEFAULT_XML_SETTINGS);
  }

  @Test
  public void testCreatedXSLTIsEqual () throws Exception
  {
    final ISchematronXsltProcessor aSaxon = new SaxonXsltProcessor ();
    final ISchematronXsltProcessor aPhoxtrot = new PhoxtrotXsltProcessor ();
    final File aTargetDir = new File ("target/pipeline-compare/" + m_aPipeline.getID ());

    final ICommonsList <String> aDifferent = new CommonsArrayList <> ();
    final ICommonsSet <String> aFailed = new CommonsHashSet <> ();
    int nCompared = 0;
    for (final IReadableResource aRes : m_aPipeline.getAllSources ())
    {
      final String sPath = aRes.getPath ();
      final String sPhoxtrot;
      try
      {
        sPhoxtrot = _createXSLT (aRes, aPhoxtrot);
      }
      catch (final TransformerException ex)
      {
        LOGGER.warn ("[" + m_aPipeline.getID () + "] phoxtrot failed on " + sPath + ": " + ex.getMessage ());
        aFailed.add (sPath);
        continue;
      }
      if (m_aPipeline.getNoSaxonReference ().contains (sPath))
        continue;

      final String sSaxon = _createXSLT (aRes, aSaxon);
      nCompared++;

      final ICommonsSet <String> aIsA = SVRLComparisonHelper.getAllIsA (aRes);
      if (!SVRLComparisonHelper.normaliseGeneratedIDs (sSaxon, aIsA)
                               .equals (SVRLComparisonHelper.normaliseGeneratedIDs (sPhoxtrot, aIsA)))
      {
        aDifferent.add (sPath);
        final String sBaseName = FilenameHelper.getWithoutExtension (sPath).replace ('/', '_');
        SimpleFileIO.writeFile (new File (aTargetDir, sBaseName + ".saxon.xslt"),
                                sSaxon,
                                XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
        SimpleFileIO.writeFile (new File (aTargetDir, sBaseName + ".phoxtrot.xslt"),
                                sPhoxtrot,
                                XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
      }
    }
    LOGGER.info ("[" +
                 m_aPipeline.getID () +
                 "] Compared the created XSLT of " +
                 nCompared +
                 " Schematron files: " +
                 aDifferent.size () +
                 " differ; phoxtrot failed on " +
                 aFailed.size ());
    assertEquals ("Unexpected phoxtrot failures", m_aPipeline.getKnownPhoxtrotFailures (), aFailed);
    assertEquals ("Unexpected created XSLT differences", m_aPipeline.getKnownDifferentXSLT (), new CommonsHashSet <> (aDifferent));
  }
}
