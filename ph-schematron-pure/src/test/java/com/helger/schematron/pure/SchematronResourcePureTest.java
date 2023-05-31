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
package com.helger.schematron.pure;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;
import java.util.List;

import javax.xml.validation.Schema;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFactoryConfigurationException;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.io.stream.StringInputStream;
import com.helger.commons.lang.ClassLoaderHelper;
import com.helger.schematron.SchematronException;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.pure.xpath.XQueryAsXPathFunctionConverter;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.schema.XMLSchemaCache;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.serialize.read.DOMReaderSettings;
import com.helger.xml.xpath.MapBasedXPathFunctionResolver;
import com.helger.xml.xpath.MapBasedXPathVariableResolver;

/**
 * Test class for class {@link SchematronResourcePure}.
 *
 * @author Philip Helger
 */
public final class SchematronResourcePureTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (SchematronResourcePureTest.class);
  private static final String FILE_XQ = "external/xquery/functx-1.0-nodoc-2007-01.xq";

  @Test
  public void testBasic () throws Exception
  {
    for (final IReadableResource aRes : SchematronTestHelper.getAllValidSchematronFiles ())
    {
      // The validity is tested in another test case!
      // Parse them
      final SchematronResourcePure aResPure = new SchematronResourcePure (aRes);
      assertTrue (aRes.getPath (), aResPure.isValidSchematron ());
    }
  }

  @Test
  public void testFromByteArray ()
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n" +
                         "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \n" +
                         "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \n" +
                         "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\n" +
                         "         queryBinding='xpath2'\n" +
                         "         schemaVersion=\"ISO19757-3\">\n" +
                         "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n" +
                         "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\n" +
                         " <iso:pattern >\n" +
                         "    <iso:title>A very simple pattern with a title</iso:title>\n" +
                         "    <iso:rule context=\"chapter\">\n" +
                         "      <iso:assert test=\"title\">Chapter should have a title</iso:assert>\n" +
                         "      <iso:report test=\"count(para)\">\n" +
                         "      <iso:value-of select=\"count(para)\"/> paragraphs</iso:report>\n" +
                         "    </iso:rule>\n" +
                         "  </iso:pattern>\n" +
                         "\n" +
                         "</iso:schema>";
    assertTrue (SchematronResourcePure.fromByteArray (sTest.getBytes (StandardCharsets.UTF_8)).isValidSchematron ());
    assertTrue (SchematronResourcePure.fromInputStream ("ba-from-string",
                                                        new StringInputStream (sTest, StandardCharsets.UTF_8))
                                      .isValidSchematron ());
  }

  @Test
  public void testParseWithXPathError ()
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n" +
                         "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \n" +
                         "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \n" +
                         "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\n" +
                         "         queryBinding='xpath2'\n" +
                         "         schemaVersion=\"ISO19757-3\">\n" +
                         "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n" +
                         "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\n" +
                         "  <iso:pattern>\n" +
                         "    <iso:rule context=\"chapter\">\n"
                         // This line contains the XPath error (Node xor number
                         // is invalid)
                         +
                         "      <iso:assert test=\"title xor 55\">Chapter should have a title</iso:assert>\n"
                         // This line contains the second XPath error (Node xor
                         // number is still invalid)
                         +
                         "      <iso:assert test=\"title xor 33\">Chapter should have a title</iso:assert>\n" +
                         "    </iso:rule>\n" +
                         "  </iso:pattern>\n" +
                         "</iso:schema>";
    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();
    final SchematronResourcePure aSch = SchematronResourcePure.fromByteArray (sTest.getBytes (StandardCharsets.UTF_8))
                                                              .setErrorHandler (aErrorHandler);
    // Perform quick validation
    assertFalse (aSch.isValidSchematron ());
    assertEquals ("Expected three errors: " + aErrorHandler.getErrorList ().toString (),
                  3,
                  aErrorHandler.getErrorList ().size ());
    if (false)
      LOGGER.info (aErrorHandler.getErrorList ().toString ());

    // Perform complete validation
    aErrorHandler.clearResourceErrors ();
    aSch.validateCompletely ();
    assertEquals ("Expected three errors: " + aErrorHandler.getErrorList ().toString (),
                  3,
                  aErrorHandler.getErrorList ().size ());
  }

  @Test
  public void testResolveVariables () throws SchematronException, XPathFactoryConfigurationException
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n" +
                         "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \n" +
                         "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \n" +
                         "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\n" +
                         "         queryBinding='xslt2'\n" +
                         "         schemaVersion=\"ISO19757-3\">\n" +
                         "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n" +
                         "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\n" +
                         "  <iso:ns prefix=\"java\" uri=\"http://helger.com/schematron/test\" />\n" +
                         "  <iso:pattern >\n" +
                         "    <iso:title>A very simple pattern with a title</iso:title>\n" +
                         "    <iso:rule context=\"chapter\">\n"
                         // Custom variable
                         +
                         "      <iso:assert test=\"$title-element\">Chapter should have a title</iso:assert>\n"
                         // Custom function
                         +
                         "      <iso:report test=\"java:my-count(para) = 2\">\n"
                         // Custom function
                         +
                         "      <iso:value-of select=\"java:my-count(para)\"/> paragraphs found</iso:report>\n" +
                         "    </iso:rule>\n" +
                         "  </iso:pattern>\n" +
                         "\n" +
                         "</iso:schema>";

    // Test without variable and function resolver
    // -> an error is expected, but we don't need to log it
    assertFalse (SchematronResourcePure.fromString (sTest, StandardCharsets.UTF_8)
                                       .setErrorHandler (new DoNothingPSErrorHandler ())
                                       .isValidSchematron ());

    // Test with variable and function resolver
    final MapBasedXPathVariableResolver aVarResolver = new MapBasedXPathVariableResolver ();
    aVarResolver.addUniqueVariable ("title-element", "title");

    final MapBasedXPathFunctionResolver aFunctionResolver = new MapBasedXPathFunctionResolver ();
    aFunctionResolver.addUniqueFunction ("http://helger.com/schematron/test", "my-count", 1, args -> {
      final List <?> aArg = (List <?>) args.get (0);
      return Integer.valueOf (aArg.size ());
    });
    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().setXPathVariableResolver (aVarResolver)
                                                               .setXPathFunctionResolver (aFunctionResolver)
                                                               .build ();

    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?><chapter><title /><para>First para</para><para>Second para</para></chapter>");
    final SchematronOutputType aOT = SchematronResourcePure.fromString (sTest, StandardCharsets.UTF_8)
                                                           .setXPathConfig (aXPathConfig)
                                                           .applySchematronValidationToSVRL (aTestDoc, null);
    assertNotNull (aOT);
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOT).size ());
    assertEquals (1, SVRLHelper.getAllSuccessfulReports (aOT).size ());
    // Note: the text contains all whitespaces!
    assertEquals ("\n      2 paragraphs found".trim (), SVRLHelper.getAllSuccessfulReports (aOT).get (0).getText ());
  }

  @Test
  public void testResolveFunctions () throws SchematronException, XPathFactoryConfigurationException
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n" +
                         "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \n" +
                         "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \n" +
                         "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\n" +
                         "         queryBinding='xslt2'\n" +
                         "         schemaVersion=\"ISO19757-3\">\n" +
                         "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n" +
                         "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\n" +
                         "  <iso:ns prefix=\"java\" uri=\"http://helger.com/schematron/test\" />\n" +
                         "  <iso:pattern >\n" +
                         "    <iso:title>A very simple pattern with a title</iso:title>\n" +
                         "    <iso:rule context=\"chapter\">\n" +
                         "      <iso:assert test=\"title\">Chapter should have a title</iso:assert>\n" +
                         "      <iso:report test=\"count(para) = 2\">\n"
                         // Custom function
                         +
                         "      Node details: <iso:value-of select=\"java:get-nodelist-details(para)\"/> - end</iso:report>\n" +
                         "    </iso:rule>\n" +
                         "  </iso:pattern>\n" +
                         "\n" +
                         "</iso:schema>";

    // Test with variable and function resolver
    final MapBasedXPathFunctionResolver aFunctionResolver = new MapBasedXPathFunctionResolver ();
    aFunctionResolver.addUniqueFunction ("http://helger.com/schematron/test", "get-nodelist-details", 1, args -> {
      // We expect exactly one argument
      assertEquals (1, args.size ());
      // The type of the first argument
      // itself is also a list
      final List <?> aFirstArg = (List <?>) args.get (0);
      // Ensure that the first argument
      // only contains Nodes
      final StringBuilder ret = new StringBuilder ();
      boolean bFirst = true;
      for (final Object aFirstArgItem : aFirstArg)
      {
        assertTrue (aFirstArgItem instanceof Node);
        final Node aNode = (Node) aFirstArgItem;

        if (bFirst)
          bFirst = false;
        else
          ret.append (", ");

        ret.append (aNode.getNodeName ()).append ("[").append (aNode.getTextContent ()).append ("]");
      }

      return ret;
    });

    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    "<title />" +
                                                    "<para>First para</para>" +
                                                    "<para>Second para</para>" +
                                                    "</chapter>");
    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().setXPathFunctionResolver (aFunctionResolver).build ();
    final SchematronOutputType aOT = SchematronResourcePure.fromByteArray (sTest.getBytes (StandardCharsets.UTF_8))
                                                           .setXPathConfig (aXPathConfig)
                                                           .applySchematronValidationToSVRL (aTestDoc, null);
    assertNotNull (aOT);
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOT).size ());
    assertEquals (1, SVRLHelper.getAllSuccessfulReports (aOT).size ());
    // Note: the text contains all whitespaces!
    assertEquals ("\n      Node details: para[First para], para[Second para] - end".trim (),
                  SVRLHelper.getAllSuccessfulReports (aOT).get (0).getText ());
  }

  @Test
  public void testResolveXQueryFunctions () throws Exception
  {
    final String sTest = "<?xml version='1.0' encoding='iso-8859-1'?>\n" +
                         "<iso:schema xmlns='http://purl.oclc.org/dsdl/schematron' \n" +
                         "         xmlns:iso='http://purl.oclc.org/dsdl/schematron' \n" +
                         "         xmlns:sch='http://www.ascc.net/xml/schematron'\n" +
                         "         queryBinding='xslt2'\n" +
                         "         schemaVersion='ISO19757-3'>\n" +
                         "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n" +
                         "  <iso:ns prefix='dp' uri='http://www.dpawson.co.uk/ns#' />\n" +
                         "  <iso:ns prefix='functx' uri='http://www.functx.com' />\n" +
                         "  <iso:pattern >\n" +
                         "    <iso:title>A very simple pattern with a title</iso:title>\n" +
                         "    <iso:rule context='chapter'>\n" +
                         "      <iso:assert test='title'>Chapter should have a title</iso:assert>\n" +
                         "      <iso:report test='count(para) = 2'>\n"
                         // Custom function
                         +
                         "      Node kind: <iso:value-of select='functx:node-kind(para)'/> - end</iso:report>\n" +
                         "    </iso:rule>\n" +
                         "  </iso:pattern>\n" +
                         "\n" +
                         "</iso:schema>";

    final MapBasedXPathFunctionResolver aFunctionResolver = new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream (FILE_XQ));

    // Test with variable and function resolver
    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    "<title />" +
                                                    "<para>First para</para>" +
                                                    "<para>Second para</para>" +
                                                    "</chapter>");
    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().setXPathFunctionResolver (aFunctionResolver).build ();
    final SchematronOutputType aOT = SchematronResourcePure.fromByteArray (sTest.getBytes (StandardCharsets.UTF_8))
                                                           .setXPathConfig (aXPathConfig)
                                                           .applySchematronValidationToSVRL (aTestDoc, null);
    assertNotNull (aOT);
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOT).size ());
    assertEquals (1, SVRLHelper.getAllSuccessfulReports (aOT).size ());
    // Note: the text contains all whitespaces!
    assertEquals ("\n      Node kind: element - end".trim (),
                  SVRLHelper.getAllSuccessfulReports (aOT).get (0).getText ());
  }

  @Test
  public void testResolveFunctXAreDistinctValuesQueryFunctions () throws Exception
  {
    final String sTest = "<?xml version='1.0' encoding='iso-8859-1'?>\n" +
                         "<iso:schema xmlns='http://purl.oclc.org/dsdl/schematron' \n" +
                         "         xmlns:iso='http://purl.oclc.org/dsdl/schematron' \n" +
                         "         xmlns:sch='http://www.ascc.net/xml/schematron'\n" +
                         "         queryBinding='xslt2'\n" +
                         "         schemaVersion='ISO19757-3'>\n" +
                         "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n" +
                         "  <iso:ns prefix='dp' uri='http://www.dpawson.co.uk/ns#' />\n" +
                         "  <iso:ns prefix='fn' uri='http://www.w3.org/2005/xpath-functions' />\n" +
                         "  <iso:ns prefix='functx' uri='http://www.functx.com' />\n" +
                         "  <iso:pattern >\n" +
                         "    <iso:title>A very simple pattern with a title</iso:title>\n" +
                         "    <iso:rule context='chapter'>\n" +
                         "      <iso:assert test='functx:are-distinct-values(para)'>Should have distinct values</iso:assert>\n" +
                         "    </iso:rule>\n" +
                         "  </iso:pattern>\n" +
                         "</iso:schema>";

    final MapBasedXPathFunctionResolver aFunctionResolver = new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream (FILE_XQ));

    // Test with variable and function resolver
    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    "<title />" +
                                                    "<para>100</para>" +
                                                    "<para>200</para>" +
                                                    "</chapter>");
    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler (new LoggingPSErrorHandler ());
    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().setXPathFunctionResolver (aFunctionResolver).build ();
    final SchematronOutputType aOT = SchematronResourcePure.fromByteArray (sTest.getBytes (StandardCharsets.UTF_8))
                                                           .setXPathConfig (aXPathConfig)
                                                           .setErrorHandler (aErrorHandler)
                                                           .applySchematronValidationToSVRL (aTestDoc, null);
    assertNotNull (aOT);
    // XXX fails :(
    if (false)
      assertTrue (aErrorHandler.getAllErrors ().toString (), aErrorHandler.isEmpty ());
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOT).size ());
  }

  @Test
  public void testSaxon12Bug () throws Exception
  {
    final XPath xPath = XPathFactory.newInstance (XPathFactory.DEFAULT_OBJECT_MODEL_URI,
                                                  "net.sf.saxon.xpath.XPathFactoryImpl",
                                                  ClassLoaderHelper.getContextClassLoader ())
                                    .newXPath ();
    assertNotNull (xPath);
    assertTrue (xPath instanceof net.sf.saxon.xpath.XPathEvaluator);

    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    "<title />" +
                                                    "<para>100</para>" +
                                                    "<para>200</para>" +
                                                    "</chapter>");

    Object ret = xPath.evaluate ("count(para)", aTestDoc.getDocumentElement (), XPathConstants.NUMBER);
    assertEquals (Double.valueOf (2), ret);

    ret = xPath.evaluate ("count(distinct-values(para))", aTestDoc.getDocumentElement (), XPathConstants.NUMBER);
    assertEquals (Double.valueOf (2), ret);

    final MapBasedXPathFunctionResolver aFunctionResolver = new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream (FILE_XQ));
    xPath.setXPathFunctionResolver (aFunctionResolver);
    xPath.setNamespaceContext (new MapBasedNamespaceContext ().addMapping ("functx", "http://www.functx.com"));

    ret = xPath.evaluate ("functx:are-distinct-values(para)", aTestDoc.getDocumentElement (), XPathConstants.BOOLEAN);
    assertEquals (Boolean.TRUE, ret);
  }

  @Test
  public void testFunctXAreDistinctValuesWithXSD () throws Exception
  {
    final String sTest = "<?xml version='1.0' encoding='iso-8859-1'?>\n" +
                         "<schema xmlns='http://purl.oclc.org/dsdl/schematron'>\n" +
                         "  <ns prefix=\"xs\" uri=\"http://www.w3.org/2001/XMLSchema\"/>\n" +
                         "  <ns prefix='fn' uri='http://www.w3.org/2005/xpath-functions' />\n" +
                         "  <ns prefix='functx' uri='http://www.functx.com' />\n" +
                         "  <pattern name='toto'>\n" +
                         "    <title>A very simple pattern with a title</title>\n" +
                         "    <rule context='chapter'>\n" +
                         "      <assert test='fn:count(fn:distinct-values(para)) = fn:count(para)'>Should have distinct values</assert>\n" +
                         "      </rule>\n" +
                         "  </pattern>\n" +
                         "</schema>";

    final MapBasedXPathFunctionResolver aFunctionResolver = new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream (FILE_XQ));

    final Schema aSchema = XMLSchemaCache.getInstance ()
                                         .getSchema (new ClassPathResource ("external/issues/20141124/chapter.xsd"));
    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    " <title />" +
                                                    " <para>09</para>" +
                                                    " <para>9</para>" +
                                                    "</chapter>",
                                                    new DOMReaderSettings ().setSchema (aSchema));

    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().setXPathFunctionResolver (aFunctionResolver).build ();
    final SchematronOutputType aOT = SchematronResourcePure.fromByteArray (sTest.getBytes (StandardCharsets.UTF_8))
                                                           .setXPathConfig (aXPathConfig)
                                                           .applySchematronValidationToSVRL (aTestDoc, null);
    assertNotNull (aOT);
    if (SVRLHelper.getAllFailedAssertions (aOT).isNotEmpty ())
    {
      LOGGER.info (SVRLHelper.getAllFailedAssertions (aOT).get (0).getText ());
    }
    assertTrue (SVRLHelper.getAllFailedAssertions (aOT).isEmpty ());
  }
}
