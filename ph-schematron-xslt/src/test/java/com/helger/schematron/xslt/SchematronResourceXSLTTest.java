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
package com.helger.schematron.xslt;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.nio.charset.StandardCharsets;

import javax.xml.transform.TransformerException;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.base.io.nonblocking.NonBlockingByteArrayInputStream;
import com.helger.base.io.stream.StreamHelper;
import com.helger.base.debug.GlobalDebug;
import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.SchematronDebug;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.xml.transform.DoNothingTransformErrorListener;

/**
 * Test class for class {@link SchematronResourceXSLT}.
 *
 * @author Philip Helger
 */
public final class SchematronResourceXSLTTest
{
  private static final ClassPathResource VALID_XSLT_SCHEMATRON = new ClassPathResource ("external/test-xslt/valid01.xslt");
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("external/test-xml/valid01.xml");
  private static final String XSLT_PREFIX = "<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>" +
                                            "<xsl:template match='/'>";
  private static final String XSLT_SUFFIX = "</xsl:template></xsl:stylesheet>";

  private boolean m_bOldDebugMode;
  private boolean m_bOldShowCreatedSVRL;

  @Before
  public void before ()
  {
    // The SVRL is only read without a DOM, if it is not logged
    m_bOldDebugMode = GlobalDebug.isDebugMode ();
    m_bOldShowCreatedSVRL = SchematronDebug.isShowCreatedSVRL ();
    GlobalDebug.setDebugModeDirect (false);
    SchematronDebug.setShowCreatedSVRL (false);
  }

  @After
  public void after ()
  {
    GlobalDebug.setDebugModeDirect (m_bOldDebugMode);
    SchematronDebug.setShowCreatedSVRL (m_bOldShowCreatedSVRL);
  }

  @Test
  public void testFromUrl () throws Exception
  {
    final SchematronResourceXSLT sch = SchematronResourceXSLT.builderFromURL (VALID_XSLT_SCHEMATRON.getAsURL ())
                                                             .build ();
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromStringUrl () throws Exception
  {
    final SchematronResourceXSLT sch = SchematronResourceXSLT.builderFromURL (VALID_XSLT_SCHEMATRON.getAsURL ()
                                                                                                   .toExternalForm ())
                                                             .build ();
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromInputStream () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.builderFromInputStream ("mock-res-id",
                                                                                      new NonBlockingByteArrayInputStream (aPayload))
                                                             .build ();
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromByteArray () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.builderFromByteArray (aPayload).build ();
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testFromString () throws Exception
  {
    final byte [] aPayload = StreamHelper.getAllBytes (VALID_XSLT_SCHEMATRON);
    final SchematronResourceXSLT sch = SchematronResourceXSLT.builderFromString (new String (aPayload,
                                                                                             StandardCharsets.UTF_8),
                                                                                 StandardCharsets.UTF_8).build ();
    assertTrue ("invalid schematron", sch.isValidSchematron ());

    final Document aDoc = sch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
  }

  @Test
  public void testSVRLSameAsFromDOM () throws Exception
  {
    // The SVRL of this XSLT is not valid according to the SVRL XML Schema
    final SchematronResourceXSLT aSch = SchematronResourceXSLT.builder (VALID_XSLT_SCHEMATRON)
                                                              .validateSVRL (false)
                                                              .build ();
    final SchematronOutputType aSVRL = aSch.applySchematronValidationToSVRL (VALID_XMLINSTANCE);
    assertNotNull (aSVRL);

    // Reading the SVRL from the transformation is the same as reading the SVRL DOM
    final Document aDoc = aSch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
    assertEquals (new SVRLMarshaller ().setUseSchema (false).read (aDoc), aSVRL);

    // Same with the SVRL DOM being logged
    SchematronDebug.setShowCreatedSVRL (true);
    assertEquals (aSVRL, aSch.applySchematronValidationToSVRL (VALID_XMLINSTANCE));

    // With SVRL validation, both fail
    SchematronDebug.setShowCreatedSVRL (false);
    final SchematronResourceXSLT aSchValidating = SchematronResourceXSLT.builder (VALID_XSLT_SCHEMATRON).build ();
    assertNull (aSchValidating.applySchematronValidationToSVRL (VALID_XMLINSTANCE));
    assertNull (new SVRLMarshaller ().read (aDoc));
  }

  @Test
  public void testNoSVRLCreated () throws Exception
  {
    final String sXSLT = XSLT_PREFIX + "<foo xmlns='urn:test'><bar/></foo>" + XSLT_SUFFIX;

    // With SVRL validation the result cannot be read
    final SchematronResourceXSLT aSch = SchematronResourceXSLT.builderFromString (sXSLT).useCache (false).build ();
    assertTrue (aSch.isValidSchematron ());
    assertNull (aSch.applySchematronValidationToSVRL (VALID_XMLINSTANCE));
    final Document aDoc = aSch.applySchematronValidation (VALID_XMLINSTANCE);
    assertNotNull (aDoc);
    assertNull (new SVRLMarshaller ().read (aDoc));

    // Without SVRL validation the result is the same as when reading the DOM
    final SchematronResourceXSLT aSchNoValidation = SchematronResourceXSLT.builderFromString (sXSLT)
                                                                          .useCache (false)
                                                                          .validateSVRL (false)
                                                                          .build ();
    assertEquals (new SVRLMarshaller ().setUseSchema (false).read (aDoc),
                  aSchNoValidation.applySchematronValidationToSVRL (VALID_XMLINSTANCE));
  }

  @Test
  public void testEmptyResult () throws Exception
  {
    final SchematronResourceXSLT aSch = SchematronResourceXSLT.builderFromString (XSLT_PREFIX + XSLT_SUFFIX)
                                                              .useCache (false)
                                                              .build ();
    assertTrue (aSch.isValidSchematron ());
    try
    {
      aSch.applySchematronValidationToSVRL (VALID_XMLINSTANCE);
      fail ();
    }
    catch (final IllegalStateException ex)
    {
      // expected
    }
  }

  @Test
  public void testTransformationError () throws Exception
  {
    final SchematronResourceXSLT aSch = SchematronResourceXSLT.builderFromString (XSLT_PREFIX +
                                                                                  "<xsl:message terminate='yes'>stop</xsl:message>" +
                                                                                  XSLT_SUFFIX)
                                                              .useCache (false)
                                                              .errorListener (new DoNothingTransformErrorListener ())
                                                              .build ();
    assertTrue (aSch.isValidSchematron ());
    try
    {
      aSch.applySchematronValidationToSVRL (VALID_XMLINSTANCE);
      fail ();
    }
    catch (final TransformerException ex)
    {
      // expected
    }
  }
}
