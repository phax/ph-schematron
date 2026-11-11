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
import java.nio.charset.StandardCharsets;
import java.util.Collection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Assume;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.io.file.FilenameHelper;
import com.helger.io.file.SimpleFileIO;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.api.xslt.AbstractSchematronXSLTBasedResource;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.saxon.SaxonXsltProcessor;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.serialize.write.XMLWriterSettings;

import net.sf.saxon.trans.XPathException;

/**
 * Compare the SVRL of the XSLT based pipelines on phoxtrot with the SVRL on Saxon, for all their
 * test files against all test XML files, and check that errors happen on both or on
 * none. Differences are written to <code>target/svrl-compare/&lt;pipeline&gt;</code>. See
 * {@link SVRLComparisonHelper} for the accepted differences.
 *
 * @author Philip Helger
 */
@RunWith (Parameterized.class)
public final class SVRLPhoxtrotVsSaxonComparisonTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SVRLPhoxtrotVsSaxonComparisonTest.class);
  /** phoxtrot starts the message with the error code, e.g. "FORG0001: " or "ValidationError: " */
  private static final Pattern ERROR_CODE = Pattern.compile ("([A-Za-z][A-Za-z0-9_.-]*): ");

  private final ComparedPipeline m_aPipeline;

  public SVRLPhoxtrotVsSaxonComparisonTest (@NonNull final ComparedPipeline aPipeline)
  {
    m_aPipeline = aPipeline;
  }

  @Parameterized.Parameters (name = "{0}")
  public static Collection <Object []> getAllPipelines ()
  {
    return new CommonsArrayList <> (new Object [] { ComparedPipeline.ISO },
                                    new Object [] { ComparedPipeline.SCHXSLT1 },
                                    new Object [] { ComparedPipeline.SCHXSLT2 },
                                    new Object [] { ComparedPipeline.XSLT_PREBUILT });
  }


  /**
   * @return The error code of the exception or one of its causes (Saxon keeps it separately,
   *         phoxtrot starts the message with it), or <code>null</code>.
   */
  @Nullable
  private static String _getErrorCode (@NonNull final Throwable t)
  {
    for (Throwable aCur = t; aCur != null; aCur = aCur.getCause ())
    {
      if (aCur instanceof final XPathException aSaxonEx && aSaxonEx.getErrorCodeQName () != null)
        return aSaxonEx.getErrorCodeQName ().getLocalPart ();
      final String sMsg = aCur.getMessage ();
      if (sMsg != null)
      {
        final Matcher aMatcher = ERROR_CODE.matcher (sMsg);
        if (aMatcher.lookingAt ())
          return aMatcher.group (1);
      }
    }
    return null;
  }

  /**
   * @return The canonical SVRL, or the error code and message as a text.
   */
  @NonNull
  private static String _validate (@NonNull final AbstractSchematronXSLTBasedResource <?> aSCH,
                                   @NonNull final IReadableResource aXML)
  {
    try
    {
      final Document aSVRL = aSCH.applySchematronValidation (aXML);
      if (aSVRL == null)
        return "null";
      return String.join ("\n", SVRLComparisonHelper.getCanonicalEntries (aSVRL));
    }
    catch (final Exception ex)
    {
      return "ERROR [" + _getErrorCode (ex) + "] " + ex.getClass ().getName () + ": " + ex.getMessage ();
    }
  }

  @Test
  public void testSVRLIsEqual ()
  {
    final ISchematronXsltProcessor aSaxon = new SaxonXsltProcessor ();
    final ISchematronXsltProcessor aPhoxtrot = new PhoxtrotXsltProcessor ();

    final ICommonsList <IReadableResource> aXMLs = SchematronTestHelper.getAllValidXMLFiles ()
                                                                       .getAll (x -> x.getPath ().endsWith (".xml"));
    final ICommonsList <String> aDifferent = new CommonsArrayList <> ();
    int nCompared = 0;
    int nBothFailed = 0;
    final File aTargetDir = new File ("target/svrl-compare/" + m_aPipeline.getID ());
    for (final IReadableResource aSCHRes : m_aPipeline.getAllSources ())
    {
      final String sSCHPath = aSCHRes.getPath ();
      if (m_aPipeline.getNoSaxonReference ().contains (sSCHPath) ||
          m_aPipeline.getKnownPhoxtrotFailures ().contains (sSCHPath))
        continue;

      final AbstractSchematronXSLTBasedResource <?> aSaxonSCH = m_aPipeline.createResource (aSCHRes, aSaxon);
      final AbstractSchematronXSLTBasedResource <?> aPhoxtrotSCH = m_aPipeline.createResource (aSCHRes, aPhoxtrot);
      final ICommonsSet <String> aIsA = SVRLComparisonHelper.getAllIsA (aSCHRes);
      for (final IReadableResource aXMLRes : aXMLs)
      {
        final String sSaxon = SVRLComparisonHelper.normaliseGeneratedIDs (_validate (aSaxonSCH, aXMLRes), aIsA);
        final String sPhoxtrot = SVRLComparisonHelper.normaliseGeneratedIDs (_validate (aPhoxtrotSCH, aXMLRes),
                                                                              aIsA);
        nCompared++;
        if (sSaxon.startsWith ("ERROR ") && sPhoxtrot.startsWith ("ERROR "))
        {
          // Both failed - the messages differ by nature
          nBothFailed++;
          LOGGER.info ("[" + m_aPipeline.getID () + "] Both failed on " + sSCHPath + " with " + aXMLRes.getPath () + ":\n  " + sSaxon + "\n  " + sPhoxtrot);
          continue;
        }
        if (!sSaxon.equals (sPhoxtrot))
        {
          final String sName = FilenameHelper.getWithoutExtension (sSCHPath).replace ('/', '_') +
                               "__" +
                               FilenameHelper.getWithoutExtension (FilenameHelper.getWithoutPath (aXMLRes.getPath ()))
                                             .replace (' ', '_');
          aDifferent.add (sSCHPath + " with " + aXMLRes.getPath ());
          SimpleFileIO.writeFile (new File (aTargetDir, sName + ".saxon.txt"),
                                  sSaxon,
                                  XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
          SimpleFileIO.writeFile (new File (aTargetDir, sName + ".phoxtrot.txt"),
                                  sPhoxtrot,
                                  XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
        }
      }
    }
    LOGGER.info ("[" + m_aPipeline.getID () + "] Compared the SVRL of " +
                 nCompared +
                 " Schematron/XML pairs: " +
                 aDifferent.size () +
                 " differ; " +
                 nBothFailed +
                 " failed on both");
    assertTrue ("Different SVRL: " + aDifferent, aDifferent.isEmpty ());
  }

  @Test
  public void testDynamicError ()
  {
    // Only for the pipelines that read Schematron
    Assume.assumeTrue (m_aPipeline.getXSLTCreator () != null);

    final String sSCH = "<schema xmlns='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>" +
                        "<ns prefix='xs' uri='http://www.w3.org/2001/XMLSchema'/>" +
                        "<pattern><rule context='a'><assert test='xs:integer(.) gt 0'>positive</assert></rule></pattern>" +
                        "</schema>";
    final IReadableResource aXML = new ReadableResourceString ("test.xml", "<a>abc</a>", StandardCharsets.UTF_8);
    final String [] aResults = new String [2];
    final ISchematronXsltProcessor [] aProcessors = { new SaxonXsltProcessor (), new PhoxtrotXsltProcessor () };
    for (int i = 0; i < aProcessors.length; ++i)
    {
      final AbstractSchematronXSLTBasedResource <?> aSCH = m_aPipeline.createResource (new ReadableResourceString ("test.sch",
                                                                                                                  sSCH,
                                                                                                                  StandardCharsets.UTF_8),
                                                                                      aProcessors[i]);
      assertTrue (aSCH.isValidSchematron ());
      aResults[i] = _validate (aSCH, aXML);
      LOGGER.info ("[" + m_aPipeline.getID () + "] " + aProcessors[i].getID () + ": " + aResults[i]);
      assertTrue (aProcessors[i].getID () + ": " + aResults[i], aResults[i].startsWith ("ERROR ["));
    }
    // Saxon is the reference: the same error code on phoxtrot
    assertEquals (aResults[0].substring (0, aResults[0].indexOf (']') + 1),
                  aResults[1].substring (0, aResults[1].indexOf (']') + 1));
  }

  @Test
  public void testInvalidSchematron ()
  {
    // Only for the pipelines that read Schematron
    Assume.assumeTrue (m_aPipeline.getXSLTCreator () != null);

    final ISchematronXsltProcessor aSaxon = new SaxonXsltProcessor ();
    final ISchematronXsltProcessor aPhoxtrot = new PhoxtrotXsltProcessor ();
    int nInvalid = 0;
    // The files are invalid for the pure engine; the ISO pipeline accepts some of them. Both
    // processors must come to the same result.
    for (final IReadableResource aSCHRes : SchematronTestHelper.getAllInvalidSchematronFiles ())
    {
      final boolean bSaxonValid = m_aPipeline.createResource (aSCHRes, aSaxon).isValidSchematron ();
      assertEquals (aSCHRes.getPath (), Boolean.valueOf (bSaxonValid), Boolean.valueOf (m_aPipeline.createResource (aSCHRes, aPhoxtrot).isValidSchematron ()));
      if (!bSaxonValid)
        nInvalid++;
    }
    LOGGER.info ("[" + m_aPipeline.getID () + "] " + nInvalid +
                 " of " +
                 SchematronTestHelper.getAllInvalidSchematronFiles ().size () +
                 " invalid Schematron test files are invalid on both processors");
  }
}
