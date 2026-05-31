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
package com.helger.schematron.pure.benchmark;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;

import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.base.io.nonblocking.NonBlockingByteArrayInputStream;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.xml.serialize.read.DOMReader;

import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XdmNode;

/**
 * Manual benchmark comparing two ways of feeding a large XML document into
 * {@link SchematronResourcePure}:
 * <ul>
 * <li>the regular {@code org.w3c.dom} tree built by {@link DOMReader} (then bridged to Saxon via
 * {@code DocumentWrapper} inside the bound schema)</li>
 * <li>the Saxon TinyTree built by {@link DocumentBuilder} and presented to validation as a DOM
 * facade via {@link NodeOverNodeInfo} — this is what <code>SchematronResourcePure.getAsNode</code>
 * produces.</li>
 * </ul>
 * <p>
 * The benchmark splits the wall-clock into <em>parse</em>, <em>validate</em> and <em>total</em> so
 * you can see where each path spends its time. The same Schematron is bound exactly once and the
 * same document bytes are reused; only the XML→tree representation changes.
 * </p>
 * <p>
 * Run via your IDE or {@code mvn exec:java}. This is intentionally <em>not</em> a JUnit test: real
 * timings need a quiet machine and several seconds.
 * </p>
 *
 * @author Philip Helger
 */
public final class MainBenchmarkDomVsTinyTree extends AbstractBenchmarkTask
{
  /** Number of {@code <item>} elements in the generated test document. */
  private static final int ITEM_COUNT = 20_000;
  /** Number of measured iterations per metric. */
  private static final int RUNS = 30;
  /** Number of warm-up iterations to JIT-compile both paths. */
  private static final int WARMUP_RUNS = 5;

  /**
   * Pure-XPath Schematron with a handful of rules that walk the input document. Designed to be
   * representative of "real" Schematron in shape: nested rule contexts, a {@code let} variable,
   * multiple asserts and {@code count()} / {@code string-length()} / {@code number()} calls.
   */
  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
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

  private static String _ms (final double dMs)
  {
    return BigDecimal.valueOf (dMs).setScale (2, RoundingMode.HALF_UP).toPlainString ();
  }

  private static void _validateDomTotal (final SchematronResourcePure aSCH, final byte [] aXmlBytes) throws Exception
  {
    final Document aDoc = DOMReader.readXMLDOM (aXmlBytes);
    aSCH.applySchematronValidationToSVRL (aDoc, null);
  }

  private static void _validateTinyTreeTotal (final SchematronResourcePure aSCH,
                                              final DocumentBuilder aBuilder,
                                              final byte [] aXmlBytes) throws Exception
  {
    final XdmNode aXdm = aBuilder.build (new StreamSource (new NonBlockingByteArrayInputStream (aXmlBytes)));
    final Node aFacade = NodeOverNodeInfo.wrap (aXdm.getUnderlyingNode ());
    aSCH.applySchematronValidationToSVRL (aFacade, null);
  }

  private static byte [] _generateXml (final int nItems)
  {
    final StringBuilder aSB = new StringBuilder (64 + nItems * 64);
    aSB.append ("<?xml version='1.0' encoding='UTF-8'?>\n<root>\n");
    for (int i = 0; i < nItems; i++)
      aSB.append ("  <item id='item-").append (i).append ("'><value>").append (i).append ("</value></item>\n");
    aSB.append ("</root>\n");
    return aSB.toString ().getBytes (StandardCharsets.UTF_8);
  }

  private static void _report (final String sLabel, final long nDomNanos, final long nSaxNanos)
  {
    final double dDomMs = nDomNanos / 1_000_000.0 / RUNS;
    final double dSaxMs = nSaxNanos / 1_000_000.0 / RUNS;
    final String sSpeedup = dSaxMs <= 0 ? "n/a" : BigDecimal.valueOf (dDomMs / dSaxMs)
                                                            .setScale (2, RoundingMode.HALF_UP)
                                                            .toPlainString () + "x";
    LOGGER.info (String.format ("  %-18s DOM=%6s ms   TinyTree=%6s ms   speedup=%s",
                                sLabel,
                                _ms (dDomMs),
                                _ms (dSaxMs),
                                sSpeedup));
  }

  public static void main (final String [] args) throws Exception
  {
    logSystemInfo ();

    LOGGER.info ("Generating XML with " + ITEM_COUNT + " <item> elements...");
    final byte [] aXmlBytes = _generateXml (ITEM_COUNT);
    LOGGER.info ("XML size: " + aXmlBytes.length + " bytes (~" + (aXmlBytes.length / 1024) + " KiB)");

    // Bind the schema exactly once - we want to measure the per-invocation cost without
    // re-binding noise.
    final SchematronResourcePure aSCH = SchematronResourcePure.fromString (SCHEMATRON, StandardCharsets.UTF_8);
    aSCH.getOrCreateBoundSchema ();

    final Processor aProcessor = XPathConfigBuilder.DEFAULT_PROCESSOR;
    final DocumentBuilder aSaxonBuilder = aProcessor.newDocumentBuilder ();

    LOGGER.info ("Warming up (both paths, " + WARMUP_RUNS + " iterations each)...");
    for (int i = 0; i < WARMUP_RUNS; i++)
    {
      _validateDomTotal (aSCH, aXmlBytes);
      _validateTinyTreeTotal (aSCH, aSaxonBuilder, aXmlBytes);
    }

    LOGGER.info ("Real checks (both paths, " + RUNS + " iterations each)...");

    // ---- 1) full path: parse + validate ----
    long tDomTotal = 0, tSaxTotal = 0;
    for (int i = 0; i < RUNS; i++)
    {
      final long t1 = System.nanoTime ();
      _validateDomTotal (aSCH, aXmlBytes);
      final long t2 = System.nanoTime ();
      _validateTinyTreeTotal (aSCH, aSaxonBuilder, aXmlBytes);
      final long t3 = System.nanoTime ();
      tDomTotal += (t2 - t1);
      tSaxTotal += (t3 - t2);
    }

    // ---- 2) parse-only ----
    long tDomParse = 0, tSaxParse = 0;
    for (int i = 0; i < RUNS; i++)
    {
      final long t1 = System.nanoTime ();
      DOMReader.readXMLDOM (aXmlBytes);
      final long t2 = System.nanoTime ();
      aSaxonBuilder.build (new StreamSource (new NonBlockingByteArrayInputStream (aXmlBytes)));
      final long t3 = System.nanoTime ();
      tDomParse += (t2 - t1);
      tSaxParse += (t3 - t2);
    }

    // ---- 3) validate-only: parse once outside the timed region ----
    final Document aPreparsedDom = DOMReader.readXMLDOM (aXmlBytes);
    final XdmNode aPreparsedSaxon = aSaxonBuilder.build (new StreamSource (new NonBlockingByteArrayInputStream (aXmlBytes)));
    final Node aPreparsedFacade = NodeOverNodeInfo.wrap (aPreparsedSaxon.getUnderlyingNode ());

    long tDomVal = 0, tSaxVal = 0;
    for (int i = 0; i < RUNS; i++)
    {
      final long t1 = System.nanoTime ();
      aSCH.applySchematronValidationToSVRL (aPreparsedDom, null);
      final long t2 = System.nanoTime ();
      aSCH.applySchematronValidationToSVRL (aPreparsedFacade, null);
      final long t3 = System.nanoTime ();
      tDomVal += (t2 - t1);
      tSaxVal += (t3 - t2);
    }

    LOGGER.info ("=== Results (averaged over " + RUNS + " runs) ===");
    _report ("Parse only", tDomParse, tSaxParse);
    _report ("Validate only", tDomVal, tSaxVal);
    _report ("Parse + validate", tDomTotal, tSaxTotal);
  }
}
