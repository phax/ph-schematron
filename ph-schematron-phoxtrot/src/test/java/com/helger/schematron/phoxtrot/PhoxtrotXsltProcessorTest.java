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
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.StringReader;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.base.wrapper.Wrapper;
import com.helger.phoxtrot.xslt.XsltTransformRequest;
import com.helger.phoxtrot.xslt.jaxp.PhoxtrotTransformer;
import com.helger.phoxtrot.xslt.jaxp.PhoxtrotTransformerFactory;
import com.helger.phoxtrot.xslt.jaxp.XdmSource;
import com.helger.schematron.api.telemetry.ISchematronTemplateTelemetry;
import com.helger.schematron.api.telemetry.SchematronTemplateInfo;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.schematron.saxon.SaxonXsltProcessor;
import com.helger.xml.XMLFactory;

/**
 * Test class for class {@link PhoxtrotXsltProcessor}.
 *
 * @author Philip Helger
 */
public final class PhoxtrotXsltProcessorTest
{
  private static final String XSLT = "<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>" +
                                     "<xsl:template match='/'><out><xsl:call-template name='named'/></out></xsl:template>" +
                                     "<xsl:template name='named'><named/></xsl:template>" +
                                     "</xsl:stylesheet>";

  @Test
  public void testRegistry ()
  {
    // Both processors are on the test class path, so none is the default
    assertEquals (2, SchematronXsltProcessorRegistry.getAllProcessors ().size ());
    assertTrue (SchematronXsltProcessorRegistry.getProcessorOfID (PhoxtrotXsltProcessor.ID) instanceof PhoxtrotXsltProcessor);
    assertTrue (SchematronXsltProcessorRegistry.getProcessorOfID (SaxonXsltProcessor.ID) instanceof SaxonXsltProcessor);
    assertNull (SchematronXsltProcessorRegistry.getProcessorOfID ("unknown"));
    try
    {
      SchematronXsltProcessorRegistry.getDefaultProcessor ();
      fail ();
    }
    catch (final IllegalStateException ex)
    {
      assertTrue (ex.getMessage ().contains ("saxon"));
      assertTrue (ex.getMessage ().contains ("phoxtrot"));
    }
  }

  @Test
  public void testTransformerFactories () throws Exception
  {
    final PhoxtrotXsltProcessor aProcessor = new PhoxtrotXsltProcessor ();
    assertSame (PhoxtrotTransformerFactories.getDefault (), aProcessor.getDefaultTransformerFactory ());

    for (final boolean bTracing : new boolean [] { false, true })
    {
      final TransformerFactory aTF = aProcessor.createTransformerFactory (bTracing);
      assertTrue (aTF instanceof PhoxtrotTransformerFactory);
      assertTrue (aTF.getFeature (XMLConstants.FEATURE_SECURE_PROCESSING));
      assertEquals (Long.valueOf (XsltTransformRequest.UNLIMITED_STEPS),
                    aTF.getAttribute (PhoxtrotTransformerFactory.ATTR_MAX_STEPS));
      assertEquals (Integer.valueOf (XsltTransformRequest.UNLIMITED_DEPTH),
                    aTF.getAttribute (PhoxtrotTransformerFactory.ATTR_MAX_DEPTH));
      assertEquals (PhoxtrotTransformerFactories.DEFAULT_THREADING,
                    aTF.getAttribute (PhoxtrotTransformerFactory.ATTR_THREADING));
    }
    assertNotSame (aProcessor.createTransformerFactory (false), aProcessor.createTransformerFactory (false));
  }

  @Test
  public void testSources () throws Exception
  {
    final PhoxtrotXsltProcessor aProcessor = new PhoxtrotXsltProcessor ();
    final Document aDoc = XMLFactory.newDocument ();
    aDoc.appendChild (aDoc.createElement ("root"));

    // Internal documents are converted into a phoxtrot tree
    final Source aInternal = aProcessor.createSourceForInternalDocument (aDoc, "urn:test");
    assertTrue (aInternal instanceof XdmSource);
    assertEquals ("urn:test", aInternal.getSystemId ());

    // All other sources are used as they are
    final Transformer aTransformer = aProcessor.getDefaultTransformerFactory ()
                                               .newTemplates (new StreamSource (new StringReader (XSLT)))
                                               .newTransformer ();
    final DOMSource aDOMSource = new DOMSource (aDoc, "urn:test");
    assertSame (aDOMSource, aProcessor.getEffectiveSource (aDOMSource, aTransformer));
    assertSame (aInternal, aProcessor.getEffectiveSource (aInternal, aTransformer));
  }

  @Test
  public void testTemplateTelemetry () throws Exception
  {
    final PhoxtrotXsltProcessor aProcessor = new PhoxtrotXsltProcessor ();
    final Transformer aTransformer = aProcessor.createTransformerFactory (true)
                                               .newTemplates (new StreamSource (new StringReader (XSLT)))
                                               .newTransformer ();
    assertTrue (aTransformer instanceof PhoxtrotTransformer);

    final StringBuilder aEvents = new StringBuilder ();
    final Wrapper <String> aLastNamed = new Wrapper <> ();
    aProcessor.installTemplateTelemetry (aTransformer, new ISchematronTemplateTelemetry ()
    {
      @Override
      public void onTransformStart ()
      {
        aEvents.append ("start;");
      }

      @Override
      public void onTemplateEnter (final SchematronTemplateInfo aInfo)
      {
        aEvents.append ("enter;");
        if (aInfo.getName () != null)
          aLastNamed.set (aInfo.getName ());
      }

      @Override
      public void onTemplateLeave (final SchematronTemplateInfo aInfo, final long nDurationNanos)
      {
        assertTrue (nDurationNanos >= 0);
        aEvents.append ("leave;");
      }

      @Override
      public void onTransformEnd ()
      {
        aEvents.append ("end;");
      }
    });

    final Document aSrc = XMLFactory.newDocument ();
    aSrc.appendChild (aSrc.createElement ("root"));
    aTransformer.transform (new DOMSource (aSrc), new DOMResult ());

    // The template rule and the named template, balanced
    assertEquals ("start;enter;enter;leave;leave;end;", aEvents.toString ());
    assertEquals ("named", aLastNamed.get ());
  }
}
