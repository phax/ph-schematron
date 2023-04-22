/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.schematron.pure.preprocess;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.io.file.FilenameHelper;
import com.helger.commons.io.file.SimpleFileIO;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.system.ENewLineMode;
import com.helger.schematron.SchematronException;
import com.helger.schematron.SchematronHelper;
import com.helger.schematron.pure.binding.xpath.PSXPathQueryBinding;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.pure.exchange.PSReader;
import com.helger.schematron.pure.exchange.PSWriter;
import com.helger.schematron.pure.exchange.PSWriterSettings;
import com.helger.schematron.pure.model.PSSchema;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.microdom.IMicroDocument;
import com.helger.xml.microdom.serialize.MicroWriter;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Test class for class {@link PSPreprocessor}.
 *
 * @author Philip Helger
 */
public final class PSPreprocessorTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PSPreprocessorTest.class);

  @Test
  public void testBasic () throws Exception
  {
    final PSPreprocessor aPreprocessor = new PSPreprocessor (PSXPathQueryBinding.getInstance ());
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      // Resolve all includes
      final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (aRes,
                                                                                      new LoggingPSErrorHandler ());
      assertNotNull (aDoc);

      // Read to domain object
      final PSReader aReader = new PSReader (aRes);
      final PSSchema aSchema = aReader.readSchemaFromXML (aDoc.getDocumentElement ());
      assertNotNull (aSchema);

      // Ensure the schema is valid
      final CollectingPSErrorHandler aErrHdl = new CollectingPSErrorHandler ();
      assertTrue (aRes.getPath (), aSchema.isValid (aErrHdl));
      assertTrue (aErrHdl.isEmpty ());

      // Convert to minified schema if not-yet minimal
      final PSSchema aPreprocessedSchema = aPreprocessor.getAsMinimalSchema (aSchema);
      assertNotNull (aPreprocessedSchema);

      if (false)
      {
        final String sXML = MicroWriter.getNodeAsString (aPreprocessedSchema.getAsMicroElement ());
        SimpleFileIO.writeFile (new File ("test-minified",
                                          FilenameHelper.getWithoutPath (aRes.getPath ()) + ".min-pure.sch"),
                                sXML,
                                XMLWriterSettings.DEFAULT_XML_CHARSET_OBJ);
      }

      // Ensure it is still valid and minimal
      assertTrue (aRes.getPath (), aPreprocessedSchema.isValid (aErrHdl));
      assertTrue (aRes.getPath (), aPreprocessedSchema.isMinimal ());
    }
  }

  @Test
  public void testWithTitle () throws SchematronException
  {
    final PSPreprocessor aPreprocessor = new PSPreprocessor (PSXPathQueryBinding.getInstance ()).setKeepTitles (true)
                                                                                                .setKeepDiagnostics (true);
    final IReadableResource aRes = new ClassPathResource ("external/test-sch/example-3-5.sch");
    final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (aRes, new LoggingPSErrorHandler ());
    final PSReader aReader = new PSReader (aRes);
    final PSSchema aSchema = aReader.readSchemaFromXML (aDoc.getDocumentElement ());
    final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);
    assertNotNull (aPreprocessedSchema);
    assertTrue (aPreprocessedSchema.isValid (new DoNothingPSErrorHandler ()));
    // Because titles are not in minimal mode
    assertFalse (aPreprocessedSchema.isMinimal ());
  }

  @Test
  public void testIssue51 () throws SchematronException
  {
    final PSPreprocessor aPreprocessor = new PSPreprocessor (PSXPathQueryBinding.getInstance ()).setKeepTitles (true)
                                                                                                .setKeepDiagnostics (true);
    final IReadableResource aRes = new FileSystemResource ("src/test/resources/external/issues/github51/test51.sch");
    final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (aRes, new LoggingPSErrorHandler ());
    final PSReader aReader = new PSReader (aRes).setLenient (true);
    final PSSchema aSchema = aReader.readSchemaFromXML (aDoc.getDocumentElement ());
    final PSSchema aPreprocessedSchema = aPreprocessor.getAsPreprocessedSchema (aSchema);
    assertNotNull (aPreprocessedSchema);
    assertTrue (aPreprocessedSchema.isValid (new DoNothingPSErrorHandler ()));

    final PSWriterSettings aPWS = new PSWriterSettings ();
    aPWS.setXMLWriterSettings (new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN)
                                                       .setNewLineMode (ENewLineMode.WINDOWS)
                                                       .setPutNamespaceContextPrefixesInRoot (true)
                                                       .setNamespaceContext (PSWriterSettings.createNamespaceMapping (aPreprocessedSchema)));
    final String sXML = new PSWriter (aPWS).getXMLString (aPreprocessedSchema);

    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Preprocessed:\n" + sXML);

    assertEquals ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n" +
                  "<schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" xmlns:sqs=\"http://example.org/sqs\" xmlns:sqf=\"http://example.org/sqf\" queryBinding=\"xslt2\">\r\n" +
                  "  <ns prefix=\"sqs\" uri=\"http://example.org/sqs\" />\r\n" +
                  "  <ns prefix=\"sqf\" uri=\"http://example.org/sqf\" />\r\n" +
                  "  <pattern name=\"Customer\">\r\n" +
                  "    <rule context=\"/file/Customer\">\r\n" +
                  "      <assert test=\"base-uri()\" role=\"fatal\">\n" +
                  "        <sqs:issue id=\"xyz\">\n" +
                  "          <sqs:element name=\"hudri\">bla</sqs:element>\n" +
                  "        </sqs:issue>\n" +
                  "        base-uri is '<value-of select=\"base-uri()\" />'\n" +
                  "        <sqf:fix id=\"a12\" />\n" +
                  "      </assert>\r\n" +
                  "    </rule>\r\n" +
                  "  </pattern>\r\n" +
                  "</schema>\r\n",
                  sXML);
  }

  @Test
  public void testIssue138 () throws SchematronException
  {
    final IReadableResource aRes = new FileSystemResource ("src/test/resources/external/issues/github138/test138.sch");
    final IMicroDocument aDoc = SchematronHelper.getWithResolvedSchematronIncludes (aRes, new LoggingPSErrorHandler ());
    final PSReader aReader = new PSReader (aRes);
    final PSSchema aSchema = aReader.readSchemaFromXML (aDoc.getDocumentElement ());
    assertNotNull (aSchema);

    PreprocessorIDPool.setDefaultSeparator ("##");
    try
    {
      final PSPreprocessor aPreprocessor = new PSPreprocessor (PSXPathQueryBinding.getInstance ());
      final PSSchema aPreprocessedSchema = aPreprocessor.getForcedPreprocessedSchema (aSchema);
      assertNotNull (aPreprocessedSchema);
      assertTrue (aPreprocessedSchema.isValid (new DoNothingPSErrorHandler ()));

      final PSWriterSettings aPWS = new PSWriterSettings ();
      aPWS.setXMLWriterSettings (new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN)
                                                         .setNewLineMode (ENewLineMode.WINDOWS));
      final String sXML = new PSWriter (aPWS).getXMLString (aPreprocessedSchema);

      if (LOGGER.isDebugEnabled ())
        LOGGER.debug ("Preprocessed:\n" + sXML);

      assertEquals ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n" +
                    "<schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" queryBinding=\"xslt2\">\r\n" +
                    "  <pattern name=\"Customer\">\r\n" +
                    "    <rule context=\"/file/Customer\">\r\n" +
                    "      <assert id=\"ab\" test=\"true\" role=\"fatal\">ab1</assert>\r\n" +
                    "    </rule>\r\n" +
                    "    <rule context=\"/file/Client\">\r\n" +
                    "      <assert id=\"ab##0\" test=\"true\" role=\"fatal\">ab2</assert>\r\n" +
                    "    </rule>\r\n" +
                    "  </pattern>\r\n" +
                    "</schema>\r\n",
                    sXML);
    }
    finally
    {
      // Restore default
      PreprocessorIDPool.setDefaultSeparator (PreprocessorIDPool.DEFAULT_SEPARATOR);
    }
  }
}
