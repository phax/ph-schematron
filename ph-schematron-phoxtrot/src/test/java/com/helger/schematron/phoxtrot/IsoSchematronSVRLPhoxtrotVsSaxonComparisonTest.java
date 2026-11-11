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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;
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
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.saxon.SaxonXsltProcessor;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.serialize.write.XMLWriterSettings;

import net.sf.saxon.trans.XPathException;

/**
 * Compare the SVRL of the ISO Schematron pipeline on phoxtrot with the SVRL on Saxon, for all valid
 * Schematron test files against all test XML files, and check that errors happen on both or on
 * none. Differences are written to <code>target/svrl-compare/iso</code>. See
 * {@link SVRLComparisonHelper} for the accepted differences.
 *
 * @author Philip Helger
 */
public final class IsoSchematronSVRLPhoxtrotVsSaxonComparisonTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (IsoSchematronSVRLPhoxtrotVsSaxonComparisonTest.class);
  private static final File TARGET_DIR = new File ("target/svrl-compare/iso");
  private static final Pattern ERROR_CODE = Pattern.compile ("([A-Z]{4}[0-9]{4})");

  @NonNull
  private static SchematronResourceSCH _create (@NonNull final IReadableResource aSCH,
                                                @NonNull final ISchematronXsltProcessor aProcessor)
  {
    return SchematronResourceSCH.builder (aSCH).xsltProcessor (aProcessor).useCache (false).build ();
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
  private static String _validate (@NonNull final SchematronResourceSCH aSCH, @NonNull final IReadableResource aXML)
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
    for (final IReadableResource aSCHRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      final String sSCHPath = aSCHRes.getPath ();
      if (SVRLComparisonHelper.NO_SAXON_REFERENCE.contains (sSCHPath) ||
          SVRLComparisonHelper.KNOWN_PHOXTROT_FAILURES.contains (sSCHPath))
        continue;

      final SchematronResourceSCH aSaxonSCH = _create (aSCHRes, aSaxon);
      final SchematronResourceSCH aPhoxtrotSCH = _create (aSCHRes, aPhoxtrot);
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
          LOGGER.info ("Both failed on " + sSCHPath + " with " + aXMLRes.getPath () + ":\n  " + sSaxon + "\n  " + sPhoxtrot);
          continue;
        }
        if (!sSaxon.equals (sPhoxtrot))
        {
          final String sName = FilenameHelper.getWithoutExtension (sSCHPath).replace ('/', '_') +
                               "__" +
                               FilenameHelper.getWithoutExtension (FilenameHelper.getWithoutPath (aXMLRes.getPath ()))
                                             .replace (' ', '_');
          aDifferent.add (sSCHPath + " with " + aXMLRes.getPath ());
          SimpleFileIO.writeFile (new File (TARGET_DIR, sName + ".saxon.txt"),
                                  sSaxon,
                                  XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
          SimpleFileIO.writeFile (new File (TARGET_DIR, sName + ".phoxtrot.txt"),
                                  sPhoxtrot,
                                  XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
        }
      }
    }
    LOGGER.info ("Compared the SVRL of " +
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
    final String sSCH = "<schema xmlns='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>" +
                        "<ns prefix='xs' uri='http://www.w3.org/2001/XMLSchema'/>" +
                        "<pattern><rule context='a'><assert test='xs:integer(.) gt 0'>positive</assert></rule></pattern>" +
                        "</schema>";
    final IReadableResource aXML = new ReadableResourceString ("test.xml", "<a>abc</a>", StandardCharsets.UTF_8);
    for (final ISchematronXsltProcessor aProcessor : new ISchematronXsltProcessor [] { new SaxonXsltProcessor (),
                                                                                       new PhoxtrotXsltProcessor () })
    {
      final SchematronResourceSCH aSCH = SchematronResourceSCH.builderFromString (sSCH, StandardCharsets.UTF_8)
                                                              .xsltProcessor (aProcessor)
                                                              .useCache (false)
                                                              .build ();
      assertTrue (aSCH.isValidSchematron ());
      final String sResult = _validate (aSCH, aXML);
      // The cast of "abc" to xs:integer fails with FORG0001 on both
      assertTrue (aProcessor.getID () + ": " + sResult, sResult.startsWith ("ERROR "));
      assertTrue (aProcessor.getID () + ": " + sResult, sResult.startsWith ("ERROR [FORG0001] "));
    }
  }

  @Test
  public void testInvalidSchematron ()
  {
    final ISchematronXsltProcessor aSaxon = new SaxonXsltProcessor ();
    final ISchematronXsltProcessor aPhoxtrot = new PhoxtrotXsltProcessor ();
    int nInvalid = 0;
    // The files are invalid for the pure engine; the ISO pipeline accepts some of them. Both
    // processors must come to the same result.
    for (final IReadableResource aSCHRes : SchematronTestHelper.getAllInvalidSchematronFiles ())
    {
      final boolean bSaxonValid = _create (aSCHRes, aSaxon).isValidSchematron ();
      assertEquals (aSCHRes.getPath (), Boolean.valueOf (bSaxonValid), Boolean.valueOf (_create (aSCHRes,
                                                                                                  aPhoxtrot).isValidSchematron ()));
      if (!bSaxonValid)
        nInvalid++;
    }
    LOGGER.info (nInvalid +
                 " of " +
                 SchematronTestHelper.getAllInvalidSchematronFiles ().size () +
                 " invalid Schematron test files are invalid for the ISO pipeline on both processors");
  }
}
