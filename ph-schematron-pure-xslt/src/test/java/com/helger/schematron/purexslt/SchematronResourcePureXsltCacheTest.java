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
import com.helger.schematron.purexslt.xslt.EXsltVersion;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XsltExecutable;

/**
 * Tests for {@link SchematronResourcePureXsltCache}: cache hits return the same
 * {@link XsltExecutable} instance for repeated lookups under the same key, and different keys
 * (different phase / version / processor) produce different cache entries.
 *
 * @author Philip Helger
 */
public final class SchematronResourcePureXsltCacheTest
{
  private static final String SCHEMATRON = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                                           "  <iso:pattern>\n" +
                                           "    <iso:rule context='/root'>\n" +
                                           "      <iso:assert test='item'>at least one item expected</iso:assert>\n" +
                                           "    </iso:rule>\n" +
                                           "  </iso:pattern>\n" +
                                           "</iso:schema>";

  @Before
  public void clear ()
  {
    SchematronResourcePureXsltCache.clearCache ();
  }

  @Test
  public void testRepeatLookupReturnsCachedInstance () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    final Processor aProcessor = new Processor (false);

    final XsltExecutable aFirst = SchematronResourcePureXsltCache.getCompiledXslt (aRes,
                                                                                   null,
                                                                                   EXsltVersion.DEFAULT,
                                                                                   aProcessor,
                                                                                   null,
                                                                                   null,
                                                                                   null,
                                                                                   null);
    assertEquals (1, SchematronResourcePureXsltCache.getCachedEntryCount ());

    final XsltExecutable aSecond = SchematronResourcePureXsltCache.getCompiledXslt (aRes,
                                                                                    null,
                                                                                    EXsltVersion.DEFAULT,
                                                                                    aProcessor,
                                                                                    null,
                                                                                    null,
                                                                                    null,
                                                                                    null);
    // Same key -> identical reference
    assertSame (aFirst, aSecond);
    assertEquals (1, SchematronResourcePureXsltCache.getCachedEntryCount ());
  }

  @Test
  public void testDifferentProcessorProducesDistinctEntries () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    final Processor aProcA = new Processor (false);
    final Processor aProcB = new Processor (false);

    final XsltExecutable aWithA = SchematronResourcePureXsltCache.getCompiledXslt (aRes,
                                                                                   null,
                                                                                   EXsltVersion.DEFAULT,
                                                                                   aProcA,
                                                                                   null,
                                                                                   null,
                                                                                   null,
                                                                                   null);
    final XsltExecutable aWithB = SchematronResourcePureXsltCache.getCompiledXslt (aRes,
                                                                                   null,
                                                                                   EXsltVersion.DEFAULT,
                                                                                   aProcB,
                                                                                   null,
                                                                                   null,
                                                                                   null,
                                                                                   null);
    assertNotSame (aWithA, aWithB);
    assertEquals (2, SchematronResourcePureXsltCache.getCachedEntryCount ());
  }

  @Test
  public void testDifferentPhaseProducesDistinctEntries () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    final Processor aProcessor = new Processor (false);

    final XsltExecutable aAll = SchematronResourcePureXsltCache.getCompiledXslt (aRes,
                                                                                 null,
                                                                                 EXsltVersion.DEFAULT,
                                                                                 aProcessor,
                                                                                 null,
                                                                                 null,
                                                                                 null,
                                                                                 null);
    final XsltExecutable aDefault = SchematronResourcePureXsltCache.getCompiledXslt (aRes,
                                                                                     "#DEFAULT",
                                                                                     EXsltVersion.DEFAULT,
                                                                                     aProcessor,
                                                                                     null,
                                                                                     null,
                                                                                     null,
                                                                                     null);
    assertNotSame (aAll, aDefault);
    assertEquals (2, SchematronResourcePureXsltCache.getCachedEntryCount ());
  }

  @Test
  public void testClearCacheEmptiesTheCache () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    SchematronResourcePureXsltCache.getCompiledXslt (aRes,
                                                     null,
                                                     EXsltVersion.DEFAULT,
                                                     new Processor (false),
                                                     null,
                                                     null,
                                                     null,
                                                     null);
    assertEquals (1, SchematronResourcePureXsltCache.getCachedEntryCount ());
    SchematronResourcePureXsltCache.clearCache ();
    assertEquals (0, SchematronResourcePureXsltCache.getCachedEntryCount ());
  }
}
