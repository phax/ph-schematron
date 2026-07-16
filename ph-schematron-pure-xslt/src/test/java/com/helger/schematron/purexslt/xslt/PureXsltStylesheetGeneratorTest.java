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
package com.helger.schematron.purexslt.xslt;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

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
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.serialize.write.XMLWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

public final class PureXsltStylesheetGeneratorTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PureXsltStylesheetGeneratorTest.class);

  @Test
  public void testDumpGeneratedXsltForGithub137 () throws Exception
  {
    final FileSystemResource aRes = new FileSystemResource (new File ("src/test/resources/external/issues/github137/schematron.sch"));
    final PSSchema aSchema = new PSReader (aRes).readSchema ();
    assertNotNull (aSchema);
    final Document aDoc = PureXsltStylesheetGenerator.generate (aSchema);
    assertNotNull (aDoc);
    LOGGER.info ("Generated XSLT for github137:\n" +
                 XMLWriter.getNodeAsString (aDoc, new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));
  }

  @Test
  public void testDumpGeneratedXsltForXslFunction () throws Exception
  {
    final FileSystemResource aRes = new FileSystemResource (new File ("src/test/resources/external/xsl-function/schematron.sch"));
    final PSSchema aSchema = new PSReader (aRes).readSchema ();
    assertNotNull (aSchema);
    final Document aDoc = PureXsltStylesheetGenerator.generate (aSchema);
    assertNotNull (aDoc);
    LOGGER.info ("Generated XSLT for xsl-function:\n" +
                 XMLWriter.getNodeAsString (aDoc, new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));
  }

  @NonNull
  private static PSSchema _readGithub137 () throws Exception
  {
    final FileSystemResource aRes = new FileSystemResource (new File ("src/test/resources/external/issues/github137/schematron.sch"));
    final PSSchema aSchema = new PSReader (aRes).readSchema ();
    assertNotNull (aSchema);
    return aSchema;
  }

  @NonNull
  private static String _firstLocationAvt (@NonNull final Document aDoc)
  {
    // Find the single <svrl:failed-assert> and read its @location attribute value
    final NodeList aList = aDoc.getElementsByTagNameNS (CSVRL.SVRL_NAMESPACE_URI, "failed-assert");
    assertTrue ("Expected at least one svrl:failed-assert", aList.getLength () > 0);
    return ((Element) aList.item (0)).getAttribute ("location");
  }

  @Test
  public void testGenerateXslt30UsesFnPath () throws Exception
  {
    final Document aDoc = PureXsltStylesheetGenerator.generate (_readGithub137 (), null, EPureXsltVersion.XSLT_3_0);
    assertNotNull (aDoc);

    final Element aStylesheet = aDoc.getDocumentElement ();
    assertEquals ("3.0", aStylesheet.getAttribute ("version"));

    // XSLT 3.0 uses the built-in fn:path() and must NOT emit the phsch:path helper function
    assertEquals (0,
                  aDoc.getElementsByTagNameNS (PureXsltStylesheetGenerator.XSLT_NS, "function").getLength ());
    assertEquals ("{path(.)}", _firstLocationAvt (aDoc));
  }

  @Test
  public void testGenerateXslt20EmitsPathHelper () throws Exception
  {
    final Document aDoc = PureXsltStylesheetGenerator.generate (_readGithub137 (), null, EPureXsltVersion.XSLT_2_0);
    assertNotNull (aDoc);
    LOGGER.info ("Generated XSLT 2.0 for github137:\n" +
                 XMLWriter.getNodeAsString (aDoc, new XMLWriterSettings ().setUseExistingNamespaceDeclarations (true)));

    final Element aStylesheet = aDoc.getDocumentElement ();
    assertEquals ("2.0", aStylesheet.getAttribute ("version"));

    // XSLT 2.0 lacks fn:path() -> exactly one phsch:path helper function must be emitted
    final NodeList aFuncs = aDoc.getElementsByTagNameNS (PureXsltStylesheetGenerator.XSLT_NS, "function");
    assertEquals (1, aFuncs.getLength ());
    assertEquals (PureXsltStylesheetGenerator.PATH_FUNC_PREFIX + ":path",
                  ((Element) aFuncs.item (0)).getAttribute ("name"));

    // and the location attribute must call it
    assertEquals ("{" + PureXsltStylesheetGenerator.PATH_FUNC_PREFIX + ":path(.)}", _firstLocationAvt (aDoc));
  }
}
