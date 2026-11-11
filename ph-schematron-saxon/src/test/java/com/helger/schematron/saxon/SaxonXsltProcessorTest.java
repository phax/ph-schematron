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
package com.helger.schematron.saxon;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.StringReader;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;
import org.w3c.dom.Document;

import com.helger.schematron.api.xslt.processor.ISchematronXsltProcessor;
import com.helger.schematron.api.xslt.processor.SchematronXsltProcessorRegistry;
import com.helger.xml.XMLFactory;

import net.sf.saxon.TransformerFactoryImpl;

/**
 * Test class for class {@link SaxonXsltProcessor}.
 *
 * @author Philip Helger
 */
public final class SaxonXsltProcessorTest
{
  @Test
  public void testRegistry ()
  {
    // Saxon is the only XSLT processor on the class path
    assertEquals (1, SchematronXsltProcessorRegistry.getAllProcessors ().size ());
    final ISchematronXsltProcessor aProcessor = SchematronXsltProcessorRegistry.getDefaultProcessor ();
    assertTrue (aProcessor instanceof SaxonXsltProcessor);
    assertEquals (SaxonXsltProcessor.ID, aProcessor.getID ());
    assertSame (aProcessor, SchematronXsltProcessorRegistry.getProcessorOfID (SaxonXsltProcessor.ID));
    assertNull (SchematronXsltProcessorRegistry.getProcessorOfID ("phoxtrot"));

    assertSame (aProcessor, SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (null));
    assertSame (aProcessor, SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (""));
    assertSame (aProcessor, SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault (SaxonXsltProcessor.ID));
    try
    {
      SchematronXsltProcessorRegistry.getProcessorOfIDOrDefault ("phoxtrot");
      fail ();
    }
    catch (final IllegalArgumentException ex)
    {
      // The available processors are listed
      assertTrue (ex.getMessage ().contains ("saxon"));
    }
  }

  @Test
  public void testTransformerFactories ()
  {
    final SaxonXsltProcessor aProcessor = new SaxonXsltProcessor ();
    assertSame (SchematronTransformerFactory.getDefault (), aProcessor.getDefaultTransformerFactory ());
    assertTrue (aProcessor.createTransformerFactory (false) instanceof TransformerFactoryImpl);
    assertTrue (aProcessor.createTransformerFactory (true) instanceof TransformerFactoryImpl);
    assertNotSame (aProcessor.createTransformerFactory (false), aProcessor.createTransformerFactory (false));
  }

  @Test
  public void testSources () throws Exception
  {
    final SaxonXsltProcessor aProcessor = new SaxonXsltProcessor ();
    final Document aDoc = XMLFactory.newDocument ();
    aDoc.appendChild (aDoc.createElement ("root"));

    // Internal documents are marked, so that Saxon may build its own tree
    final Source aInternal = aProcessor.createSourceForInternalDocument (aDoc, "urn:test");
    assertTrue (aInternal instanceof SaxonDOMSource);
    assertEquals ("urn:test", aInternal.getSystemId ());

    // A compiled stylesheet, as in the validation (the identity transformer is no TransformerImpl)
    final String sXSLT = "<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>" +
                         "<xsl:template match='/'><out/></xsl:template>" +
                         "</xsl:stylesheet>";
    final Transformer aTransformer = aProcessor.getDefaultTransformerFactory ()
                                               .newTemplates (new StreamSource (new StringReader (sXSLT)))
                                               .newTransformer ();
    // Saxon builds its own tree only for internal documents
    final Source aEffective = aProcessor.getEffectiveSource (aInternal, aTransformer);
    assertNotSame (aInternal, aEffective);
    assertEquals ("urn:test", aEffective.getSystemId ());

    // A caller supplied DOM is used as it is
    final DOMSource aDOMSource = new DOMSource (aDoc, "urn:test");
    assertSame (aDOMSource, aProcessor.getEffectiveSource (aDOMSource, aTransformer));
  }
}
