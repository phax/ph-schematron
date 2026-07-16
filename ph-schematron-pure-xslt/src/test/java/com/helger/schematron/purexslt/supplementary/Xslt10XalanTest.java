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
package com.helger.schematron.purexslt.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.util.Locale;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.purexslt.xslt.EPureXsltVersion;
import com.helger.schematron.purexslt.xslt.PureXsltStylesheetGenerator;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.serialize.write.XMLWriter;

/**
 * Runs a generated {@link EPureXsltVersion#XSLT_1_0} stylesheet through the XSLT&nbsp;1.0 processor
 * bundled in the Java runtime (XSLTC-based Xalan), i.e. a genuine 1.0 engine rather than Saxon in
 * backwards-compatibility mode. This verifies that the generated scaffolding - in particular the
 * recursive {@code phsch-path} mode templates that stand in for {@code fn:path()} - is truly
 * XSLT&nbsp;1.0 conformant. The referenced schemas deliberately use only XPath&nbsp;1.0.
 *
 * @author Philip Helger
 */
public final class Xslt10XalanTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Xslt10XalanTest.class);

  // The XSLT 1.0 processor bundled in the Java runtime. Referenced by concrete class name so we
  // bypass the JAXP service lookup - which would otherwise pick up Saxon (also on the classpath).
  private static final String JDK_XALAN = "com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl";

  @NonNull
  private static Document _runOnXalan (@NonNull final File aSch, @NonNull final File aXML) throws Exception
  {
    final PSSchema aSchema = new PSReader (new FileSystemResource (aSch)).readSchema ();
    assertNotNull (aSchema);
    final Document aXslt = PureXsltStylesheetGenerator.generate (aSchema, null, EPureXsltVersion.XSLT_1_0);
    LOGGER.info ("Generated XSLT 1.0:\n" + XMLWriter.getNodeAsString (aXslt));

    // Force the JDK-bundled Xalan/XSLTC, NOT Saxon
    final TransformerFactory aFactory = TransformerFactory.newInstance (JDK_XALAN, null);
    assertTrue ("Expected the JDK-bundled Xalan/XSLTC processor, got " + aFactory.getClass ().getName (),
                aFactory.getClass ().getName ().toLowerCase (Locale.ROOT).contains ("xalan"));

    final Transformer aTransformer = aFactory.newTransformer (new DOMSource (aXslt));
    final DOMResult aResult = new DOMResult ();
    aTransformer.transform (new StreamSource (aXML), aResult);
    final Document aSVRL = (Document) aResult.getNode ();
    assertNotNull (aSVRL);
    LOGGER.info ("SVRL from Xalan:\n" + XMLWriter.getNodeAsString (aSVRL));
    return aSVRL;
  }

  @NonNull
  private static Element _singleFailedAssert (@NonNull final Document aSVRL)
  {
    final NodeList aFA = aSVRL.getElementsByTagNameNS (CSVRL.SVRL_NAMESPACE_URI, "failed-assert");
    assertEquals ("expected exactly one svrl:failed-assert", 1, aFA.getLength ());
    return (Element) aFA.item (0);
  }

  @Test
  public void testNoNamespace () throws Exception
  {
    // Second <book> has no @isbn -> the assert fails on it
    final Document aSVRL = _runOnXalan (new File ("src/test/resources/external/xslt10/schematron.sch"),
                                        new File ("src/test/resources/external/xslt10/test.xml"));
    final Element aFA = _singleFailedAssert (aSVRL);
    assertEquals ("/library[1]/book[2]", aFA.getAttribute ("location"));
  }

  @Test
  public void testNamespaced () throws Exception
  {
    // Same, but every element is in urn:example:lib -> path uses the local-name()/namespace-uri()
    // predicate form emitted by the phsch-path mode templates
    final Document aSVRL = _runOnXalan (new File ("src/test/resources/external/xslt10/schematron-ns.sch"),
                                        new File ("src/test/resources/external/xslt10/test-ns.xml"));
    final Element aFA = _singleFailedAssert (aSVRL);
    assertEquals ("/*[local-name()='library' and namespace-uri()='urn:example:lib'][1]" +
                  "/*[local-name()='book' and namespace-uri()='urn:example:lib'][2]",
                  aFA.getAttribute ("location"));
  }
}
