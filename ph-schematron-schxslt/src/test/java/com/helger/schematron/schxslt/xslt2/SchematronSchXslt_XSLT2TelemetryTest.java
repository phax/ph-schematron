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
package com.helger.schematron.schxslt.xslt2;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.concurrent.atomic.AtomicInteger;

import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.telemetry.SchematronTemplateInfo;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Test class for {@link ISchematronTemplateTelemetry} integration with the SchXslt 1.x engine.
 *
 * @author Philip Helger
 */
public final class SchematronSchXslt_XSLT2TelemetryTest
{
  private static final ClassPathResource VALID_SCHEMATRON = new ClassPathResource ("external/test-sch/valid01.sch");
  private static final ClassPathResource VALID_XMLINSTANCE = new ClassPathResource ("external/test-xml/valid01.xml");

  private static final class CountingTelemetry implements ISchematronTemplateTelemetry
  {
    private final AtomicInteger m_aStart = new AtomicInteger ();
    private final AtomicInteger m_aEnter = new AtomicInteger ();
    private final AtomicInteger m_aLeave = new AtomicInteger ();
    private final AtomicInteger m_aEnd = new AtomicInteger ();
    private volatile SchematronTemplateInfo m_aLastInfo;
    private volatile long m_nLastDuration = -1;

    public void onTransformStart ()
    {
      m_aStart.incrementAndGet ();
    }

    public void onTemplateEnter (final SchematronTemplateInfo aInfo)
    {
      System.out.println ("> " + aInfo.toString ());
      m_aEnter.incrementAndGet ();
      m_aLastInfo = aInfo;
    }

    public void onTemplateLeave (final SchematronTemplateInfo aInfo, final long nDurationNanos)
    {
      System.out.println ("< " + aInfo.toString ());
      m_aLeave.incrementAndGet ();
      m_nLastDuration = nDurationNanos;
    }

    public void onTransformEnd ()
    {
      m_aEnd.incrementAndGet ();
    }
  }

  @Test
  public void testTelemetryReceivesTemplateEvents () throws Exception
  {
    final CountingTelemetry aTelemetry = new CountingTelemetry ();
    final SchematronSchXslt_XSLT2 aValidator = SchematronSchXslt_XSLT2.builder (VALID_SCHEMATRON)
                                                                      .telemetry (aTelemetry)
                                                                      .buildUncached ();
    assertTrue ("invalid schematron", aValidator.isValidSchematron ());

    final Document aXMLDoc = DOMReader.readXMLDOM (VALID_XMLINSTANCE);
    assertNotNull (aXMLDoc);
    final Document aSVRL = aValidator.applyValidation (aXMLDoc, null);
    assertNotNull (aSVRL);

    assertEquals (1, aTelemetry.m_aStart.get ());
    assertEquals (1, aTelemetry.m_aEnd.get ());
    assertTrue ("Expected at least one template enter event, got " + aTelemetry.m_aEnter.get (),
                aTelemetry.m_aEnter.get () > 0);
    assertEquals ("enter/leave count mismatch", aTelemetry.m_aEnter.get (), aTelemetry.m_aLeave.get ());
    assertNotNull (aTelemetry.m_aLastInfo);
    assertTrue ("Expected non-negative duration, got " + aTelemetry.m_nLastDuration, aTelemetry.m_nLastDuration >= 0);
  }

  @Test
  public void testNoTelemetryProducesNoEvents () throws Exception
  {
    final SchematronSchXslt_XSLT2 aValidator = SchematronSchXslt_XSLT2.builder (VALID_SCHEMATRON).buildUncached ();
    assertTrue ("invalid schematron", aValidator.isValidSchematron ());

    final Document aXMLDoc = DOMReader.readXMLDOM (VALID_XMLINSTANCE);
    assertNotNull (aXMLDoc);
    final Document aSVRL = aValidator.applyValidation (aXMLDoc, null);
    assertNotNull (aSVRL);
  }

  @Test
  public void testTracingSplitsCacheKey ()
  {
    final SchematronSchXslt_XSLT2Config aPlain = SchematronSchXslt_XSLT2Config.builder (VALID_SCHEMATRON).build ();
    final SchematronSchXslt_XSLT2Config aTraced = SchematronSchXslt_XSLT2Config.builder (VALID_SCHEMATRON)
                                                                               .telemetry (new CountingTelemetry ())
                                                                               .build ();
    assertNotEquals ("Trace-enabled and trace-free configs must produce different cache keys",
                     aPlain.getCacheKey (),
                     aTraced.getCacheKey ());
  }
}
