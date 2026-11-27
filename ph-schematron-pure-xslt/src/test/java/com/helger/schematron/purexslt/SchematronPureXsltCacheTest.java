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
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertSame;

import java.nio.charset.StandardCharsets;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Before;
import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.xslt.ISchematronXSLTBasedProvider;
import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * Tests for {@link SchematronPureXsltCache}: cache hits return the same provider instance for
 * repeated lookups under the same key, and different keys (different phase / version / XSLT
 * processor) produce different cache entries.
 *
 * @author Philip Helger
 */
public final class SchematronPureXsltCacheTest
{
  /**
   * The XSLT processor on the class path under another ID, to have two processors in one test run.
   */
  private static final class OtherIDXsltProcessor implements ISchematronXsltProcessor
  {
    private final ISchematronXsltProcessor m_aDelegate = SchematronXsltProcessorRegistry.getDefaultProcessor ();

    @NonNull
    public String getID ()
    {
      return "other-" + m_aDelegate.getID ();
    }

    @NonNull
    public TransformerFactory getDefaultTransformerFactory ()
    {
      return m_aDelegate.getDefaultTransformerFactory ();
    }

    @NonNull
    public TransformerFactory createTransformerFactory (final boolean bEnableTracing)
    {
      return m_aDelegate.createTransformerFactory (bEnableTracing);
    }

    @NonNull
    public Source createSourceForInternalDocument (@NonNull final Document aDoc, @Nullable final String sBaseUri)
    {
      return m_aDelegate.createSourceForInternalDocument (aDoc, sBaseUri);
    }

    @NonNull
    public Source getEffectiveSource (@NonNull final Source aSource,
                                      @NonNull final Transformer aTransformer) throws TransformerException
    {
      return m_aDelegate.getEffectiveSource (aSource, aTransformer);
    }

    public void installTemplateTelemetry (@NonNull final Transformer aTransformer,
                                          @NonNull final ISchematronTemplateTelemetry aTelemetry)
    {
      m_aDelegate.installTemplateTelemetry (aTransformer, aTelemetry);
    }

    @Override
    public boolean isAllLocationFunctionsAvailable ()
    {
      return m_aDelegate.isAllLocationFunctionsAvailable ();
    }
  }

  private static final String SCHEMATRON = """
      <?xml version='1.0' encoding='UTF-8'?>
      <iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>
        <iso:pattern>
          <iso:rule context='/root'>
            <iso:assert test='item'>at least one item expected</iso:assert>
          </iso:rule>
        </iso:pattern>
      </iso:schema>""";

  private static ISchematronXSLTBasedProvider _compile (final ReadableResourceByteArray aRes,
                                                        final String sPhase,
                                                        final ISchematronXsltProcessor aXsltProcessor) throws Exception
  {
    final SchematronPureXsltConfig aConfig = SchematronPureXsltConfig.builder (aRes)
                                                                     .phase (sPhase)
                                                                     .xsltVersion (EPureXsltVersion.DEFAULT)
                                                                     .xsltProcessor (aXsltProcessor)
                                                                     .errorHandler (new LoggingPSErrorHandler ())
                                                                     .forceCacheResult (true)
                                                                     .build ();
    return SchematronPureXsltCache.shared ().getOrCompile (aConfig);
  }

  private static ISchematronXSLTBasedProvider _compileNotForced (final ReadableResourceByteArray aRes,
                                                                 final ErrorListener aErrorListener) throws Exception
  {
    final SchematronPureXsltConfig aConfig = SchematronPureXsltConfig.builder (aRes)
                                                                     .xsltVersion (EPureXsltVersion.DEFAULT)
                                                                     .errorListener (aErrorListener)
                                                                     .errorHandler (new LoggingPSErrorHandler ())
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
    final ISchematronXSLTBasedProvider aFirst = _compile (aRes, null, null);
    assertEquals (1, SchematronPureXsltCache.shared ().size ());

    final ISchematronXSLTBasedProvider aSecond = _compile (aRes, null, null);
    // Same key -> identical reference
    assertSame (aFirst, aSecond);
    assertEquals (1, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testProcessorIsPartOfTheCacheKey () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));

    final ISchematronXSLTBasedProvider aDefault = _compile (aRes, null, null);
    final ISchematronXSLTBasedProvider aOther = _compile (aRes, null, new OtherIDXsltProcessor ());
    assertNotSame (aDefault, aOther);
    assertEquals (2, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testDefaultProcessorIsCachedWithoutForcing () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));

    final ISchematronXSLTBasedProvider aFirst = _compileNotForced (aRes, null);
    assertNotNull (aFirst);
    assertEquals (1, SchematronPureXsltCache.shared ().size ());

    final ISchematronXSLTBasedProvider aSecond = _compileNotForced (aRes, null);
    assertSame (aFirst, aSecond);
    assertEquals (1, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testCustomErrorListenerBypassesTheCache () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));

    // A custom error listener is a custom hook, because the cache key does not contain it
    final ISchematronXSLTBasedProvider aFirst = _compileNotForced (aRes, new DoNothingTransformErrorListener ());
    assertNotNull (aFirst);
    assertEquals (0, SchematronPureXsltCache.shared ().size ());

    final ISchematronXSLTBasedProvider aSecond = _compileNotForced (aRes, new DoNothingTransformErrorListener ());
    assertNotSame (aFirst, aSecond);
    assertEquals (0, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testTwoResourcesShareOneCacheEntry () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));

    // Two independently built resources for the same Schematron must share the compiled XSLT
    final Node aXML = DOMReader.readXMLDOM ("<?xml version='1.0' encoding='UTF-8'?><root><item /></root>");
    assertNotNull (aXML);

    assertNotNull (SchematronResourcePureXslt.builder (aRes).build ().applySchematronValidationToSVRL (aXML, null));
    assertEquals (1, SchematronPureXsltCache.shared ().size ());

    assertNotNull (SchematronResourcePureXslt.builder (aRes).build ().applySchematronValidationToSVRL (aXML, null));
    assertEquals (1, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testDifferentPhaseProducesDistinctEntries () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    final ISchematronXSLTBasedProvider aAll = _compile (aRes, null, null);
    final ISchematronXSLTBasedProvider aDefault = _compile (aRes, "#DEFAULT", null);
    assertNotSame (aAll, aDefault);
    assertEquals (2, SchematronPureXsltCache.shared ().size ());
  }

  @Test
  public void testClearCacheEmptiesTheCache () throws Exception
  {
    final ReadableResourceByteArray aRes = new ReadableResourceByteArray (SCHEMATRON.getBytes (StandardCharsets.UTF_8));
    _compile (aRes, null, null);
    assertEquals (1, SchematronPureXsltCache.shared ().size ());
    SchematronPureXsltCache.shared ().clear ();
    assertEquals (0, SchematronPureXsltCache.shared ().size ());
  }
}
