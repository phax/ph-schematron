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
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

import java.nio.charset.StandardCharsets;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.base.timing.StopWatch;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.SchematronInterruptedException;
import com.helger.schematron.api.xslt.AbstractSchematronXSLTBasedResource;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.phoxtrot.PhoxtrotXsltProcessor;
import com.helger.schematron.saxon.SaxonXsltProcessor;

/**
 * The limits of the ISO Schematron pipeline on phoxtrot compared with Saxon: a large document with
 * the default limits, interruption and deep <code>or</code> chains.
 *
 * @author Philip Helger
 */
public final class LimitsPhoxtrotVsSaxonTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (LimitsPhoxtrotVsSaxonTest.class);
  private static final ISchematronXsltProcessor [] PROCESSORS = { new SaxonXsltProcessor (),
                                                                  new PhoxtrotXsltProcessor () };

  /** Like BenchmarkDomVsTinyTree in ph-schematron-benchmarks */
  private static final String SCH_LARGE = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                          "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                          "  <iso:let name='total' value='count(/root/item)'/>\n" +
                                          "  <iso:pattern>\n" +
                                          "    <iso:rule context='/root'>\n" +
                                          "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                          "      <iso:assert test='$total &gt; 0'>total must be positive</iso:assert>\n" +
                                          "    </iso:rule>\n" +
                                          "    <iso:rule context='/root/item'>\n" +
                                          "      <iso:assert test='@id'>item must have an id</iso:assert>\n" +
                                          "      <iso:assert test='string-length(@id) &gt; 0'>id must be non-empty</iso:assert>\n" +
                                          "      <iso:assert test='value'>item must have a value child</iso:assert>\n" +
                                          "      <iso:assert test='number(value) &gt;= 0'>value must be a non-negative number</iso:assert>\n" +
                                          "    </iso:rule>\n" +
                                          "  </iso:pattern>\n" +
                                          "</iso:schema>";

  @NonNull
  private static AbstractSchematronXSLTBasedResource <?> _create (@NonNull final String sSCH,
                                                                  @NonNull final ISchematronXsltProcessor aProcessor)
  {
    return ComparedPipeline.ISO.createResource (new ReadableResourceString ("test.sch", sSCH, StandardCharsets.UTF_8),
                                                aProcessor);
  }

  @NonNull
  private static ICommonsList <String> _validate (@NonNull final String sSCH,
                                                  @NonNull final IReadableResource aXML,
                                                  @NonNull final ISchematronXsltProcessor aProcessor) throws Exception
  {
    final StopWatch aSW = StopWatch.createdStarted ();
    final Document aSVRL = _create (sSCH, aProcessor).applySchematronValidation (aXML);
    LOGGER.info (aProcessor.getID () + ": " + aSW.stopAndGetMillis () + " ms");
    assertNotNull (aSVRL);
    return SVRLComparisonHelper.getCanonicalEntries (aSVRL);
  }

  @Test
  public void testLargeDocument () throws Exception
  {
    final int nItems = 20_000;
    final StringBuilder aSB = new StringBuilder (64 + nItems * 64);
    aSB.append ("<root>\n");
    for (int i = 0; i < nItems; i++)
    {
      // One negative value, so that one assertion fails
      aSB.append ("  <item id='item-").append (i).append ("'><value>").append (i == 4711 ? -1 : i).append ("</value></item>\n");
    }
    aSB.append ("</root>\n");
    final IReadableResource aXML = new ReadableResourceString ("large.xml", aSB.toString (), StandardCharsets.UTF_8);

    final ICommonsList <String> aSaxon = _validate (SCH_LARGE, aXML, PROCESSORS[0]);
    final ICommonsList <String> aPhoxtrot = _validate (SCH_LARGE, aXML, PROCESSORS[1]);
    assertEquals (aSaxon, aPhoxtrot);
  }

  @NonNull
  private static String _createOrChainSCH (final int nTerms)
  {
    final StringBuilder aTest = new StringBuilder ();
    for (int i = 0; i < nTerms; i++)
    {
      if (i > 0)
        aTest.append (" or ");
      aTest.append ("@x = '").append (i).append ('\'');
    }
    return "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>" +
           "<iso:pattern><iso:rule context='a'><iso:assert test=\"" +
           aTest +
           "\">x in range</iso:assert></iso:rule></iso:pattern>" +
           "</iso:schema>";
  }

  @NonNull
  private static IReadableResource _createOrChainXML (final int nTerms)
  {
    // The last term matches for the first element, none for the second
    return new ReadableResourceString ("test.xml",
                                       "<root><a x='" + (nTerms - 1) + "'/><a x='-1'/></root>",
                                       StandardCharsets.UTF_8);
  }

  @Test
  public void testDeepOrChain () throws Exception
  {
    final int nTerms = 200;
    final String sSCH = _createOrChainSCH (nTerms);
    final ICommonsList <String> aSaxon = _validate (sSCH, _createOrChainXML (nTerms), PROCESSORS[0]);
    final ICommonsList <String> aPhoxtrot = _validate (sSCH, _createOrChainXML (nTerms), PROCESSORS[1]);
    assertEquals (aSaxon, aPhoxtrot);
  }

  @Test
  public void testLongOrChainKnownDifference () throws Exception
  {
    // About 20,000 characters: Saxon validates it, but the ISO include step nests deeper than the
    // phoxtrot limit of 10,000 levels (phoxtrot suggestion S35). When that is fixed, compare the
    // SVRL here instead.
    final int nTerms = 1_000;
    final String sSCH = _createOrChainSCH (nTerms);
    assertNotNull (_validate (sSCH, _createOrChainXML (nTerms), PROCESSORS[0]));
    assertFalse (_create (sSCH, PROCESSORS[1]).isValidSchematron ());
  }

  @Test
  public void testInterruptedBeforeConversion ()
  {
    for (final ISchematronXsltProcessor aProcessor : PROCESSORS)
    {
      final AbstractSchematronXSLTBasedResource <?> aSCH = _create (SCH_LARGE, aProcessor);
      Thread.currentThread ().interrupt ();
      try
      {
        aSCH.isValidSchematron ();
        fail (aProcessor.getID ());
      }
      catch (final SchematronInterruptedException ex)
      {
        // expected
      }
      finally
      {
        // Clear the flag in case it was not consumed
        Thread.interrupted ();
      }
    }
  }
}
