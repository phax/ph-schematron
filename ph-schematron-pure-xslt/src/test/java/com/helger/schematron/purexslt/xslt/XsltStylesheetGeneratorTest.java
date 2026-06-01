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

import static org.junit.Assert.assertNotNull;

import java.io.File;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.model.PSSchema;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.serialize.write.XMLWriterSettings;

public final class XsltStylesheetGeneratorTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (XsltStylesheetGeneratorTest.class);

  @Test
  public void testDumpGeneratedXsltForGithub137 () throws Exception
  {
    final FileSystemResource aRes = new FileSystemResource (new File ("src/test/resources/external/issues/github137/schematron.sch"));
    final PSSchema aSchema = new PSReader (aRes).readSchema ();
    assertNotNull (aSchema);
    final IMicroDocument aDoc = XsltStylesheetGenerator.generate (aSchema);
    assertNotNull (aDoc);
    final XMLWriterSettings aWS = new XMLWriterSettings ().setNamespaceContext (XsltStylesheetGenerator.namespaceContextFor (aSchema));
    LOGGER.info ("Generated XSLT for github137:\n" + MicroWriter.getNodeAsString (aDoc, aWS));
  }

  @org.junit.Test
  public void testDumpGeneratedXsltForXslFunction () throws Exception
  {
    final FileSystemResource aRes = new FileSystemResource (new File ("src/test/resources/external/xsl-function/schematron.sch"));
    final PSSchema aSchema = new PSReader (aRes).readSchema ();
    assertNotNull (aSchema);
    final IMicroDocument aDoc = XsltStylesheetGenerator.generate (aSchema);
    assertNotNull (aDoc);
    final XMLWriterSettings aWS = new XMLWriterSettings ().setNamespaceContext (XsltStylesheetGenerator.namespaceContextFor (aSchema));
    LOGGER.info ("Generated XSLT for xsl-function:\n" + MicroWriter.getNodeAsString (aDoc, aWS));
  }
}
