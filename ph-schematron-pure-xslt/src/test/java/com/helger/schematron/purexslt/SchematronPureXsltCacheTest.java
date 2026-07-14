/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.purexslt;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertSame;

import java.nio.charset.StandardCharsets;

import org.junit.Before;
import org.junit.Test;

import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XsltExecutable;

/**
 * Tests for {@link SchematronPureXsltCache}: cache hits return the same {@link XsltExecutable}
 * instance for repeated lookups under the same key, and different keys (different phase / version /
 * processor) produce different cache entries.
 *
 * @author Philip Helger
 */
public final class SchematronPureXsltCacheTest
{
  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                           "  <iso:pattern>\n" +
                                           "    <iso:rule context='/root'>\n" +
                                           "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "</iso:schema>";

  private static XsltExecutable _compile (final ReadableResourceByteArray aRes,
                                          final String sPhase,
                                          final Processor aProcessor) throws Exception
  {
    final SchematronPureXsltConfig aConfig = SchematronPureXsltConfig.builder (aRes)
                                                                     .phase (sPhase)
                                                                     .xsltVersion (EPureXsltVersion.DEFAULT)
                                                                     .processor (aProcessor)
                                                                     .errorHandler (new LoggingPSErrorHandler ())
                                                                     .forceCacheResult (true)
                                                                     .build ();
    return SchematronPureXsltCache.shared ().getOrCompile (aConfig);
  }

  @Before
  public void clear ()
  {
    SchematronPureXsltCache.shared ().clear ();
  }

  @Test
  public void testRepeatLookupReturnsCachedInstance () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    final Processor aProcessor = new Processor (false);

    final XsltExecutable aFirst = _compile (aRes, null, aProcessor);
    assertEquals (1, SchematronPureXsltCache.shared ().size ());

    final XsltExecutable aSecond = _compile (aRes, null, aProcessor);
    // Same key -> identical reference
    assertSame (aFirst, aSecond);
    assertEquals (1, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testDifferentProcessorProducesDistinctEntries () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    final Processor aProcA = new Processor (false);
    final Processor aProcB = new Processor (false);

    final XsltExecutable aWithA = _compile (aRes, null, aProcA);
    final XsltExecutable aWithB = _compile (aRes, null, aProcB);
    assertNotSame (aWithA, aWithB);
    assertEquals (2, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testDifferentPhaseProducesDistinctEntries () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    final Processor aProcessor = new Processor (false);

    final XsltExecutable aAll = _compile (aRes, null, aProcessor);
    final XsltExecutable aDefault = _compile (aRes, "#DEFAULT", aProcessor);
    assertNotSame (aAll, aDefault);
    assertEquals (2, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testClearCacheEmptiesTheCache () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    _compile (aRes, null, new Processor (false));
    assertEquals (1, SchematronPureXsltCache.shared ().size ());
    SchematronPureXsltCache.shared ().clear ();
    assertEquals (0, SchematronPureXsltCache.shared ().size ());
  }
}
