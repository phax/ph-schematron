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
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.StringReader;

import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;

/**
 * Test class for class {@link SaxonTinyTreeHelper}.
 *
 * @author Philip Helger
 */
public final class SaxonTinyTreeHelperTest
{
  @Test
  public void testRegularDocument () throws SaxonApiException
  {
    final Processor aProcessor = SchematronProcessorFactory.getDefault ();
    final Document aDoc = SaxonTinyTreeHelper.buildDocumentFacade (aProcessor,
                                                                   new StreamSource (new StringReader ("<root><a>x</a></root>"),
                                                                                     "https://example.org/input.xml"));
    assertNotNull (aDoc);
    assertTrue (aDoc instanceof NodeOverNodeInfo);
    assertEquals ("root", aDoc.getDocumentElement ().getLocalName ());
    assertEquals ("x", aDoc.getDocumentElement ().getTextContent ());
  }

  @Test
  public void testDoctypeIsRejected ()
  {
    final Processor aProcessor = SchematronProcessorFactory.getDefault ();
    // Internal entity only - the DOCTYPE declaration itself must be rejected
    final String sXML = "<?xml version=\"1.0\"?>\n" +
                        "<!DOCTYPE root [<!ENTITY e \"expanded\">]>\n" +
                        "<root>&e;</root>";
    try
    {
      SaxonTinyTreeHelper.buildDocumentFacade (aProcessor, new StreamSource (new StringReader (sXML)));
      fail ("DOCTYPE declarations must not be allowed");
    }
    catch (final SaxonApiException ex)
    {
      // expected
    }
  }

  @Test
  public void testExternalEntityIsRejected ()
  {
    final Processor aProcessor = SchematronProcessorFactory.getDefault ();
    final String sXML = "<?xml version=\"1.0\"?>\n" +
                        "<!DOCTYPE root [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]>\n" +
                        "<root>&xxe;</root>";
    try
    {
      SaxonTinyTreeHelper.buildDocumentFacade (aProcessor, new StreamSource (new StringReader (sXML)));
      fail ("External entities must not be resolved");
    }
    catch (final SaxonApiException ex)
    {
      // expected
    }
  }

  @Test
  public void testSAXSourceWithoutXMLReader ()
  {
    final Processor aProcessor = SchematronProcessorFactory.getDefault ();
    final String sXML = "<?xml version=\"1.0\"?>\n" +
                        "<!DOCTYPE root [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]>\n" +
                        "<root>&xxe;</root>";
    final SAXSource aSource = new SAXSource (new InputSource (new StringReader (sXML)));
    try
    {
      SaxonTinyTreeHelper.buildDocumentFacade (aProcessor, aSource);
      fail ("A SAXSource without XMLReader must be parsed with the secure XMLReader");
    }
    catch (final SaxonApiException ex)
    {
      // expected
    }
    // The caller's object must not be modified
    assertNull (aSource.getXMLReader ());
  }
}
