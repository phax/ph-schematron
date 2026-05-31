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
package com.helger.schematron.pure;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;

import javax.xml.validation.Schema;

import org.junit.Ignore;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.base.io.stream.StringInputStream;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.schematron.SchematronException;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.pure.xpath.EXPathVersion;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.pure.xpath.XQueryAsXPathFunctionConverter;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.testfiles.SchematronTestHelper;
import com.helger.xml.schema.XMLSchemaCache;
import com.helger.xml.serialize.read.DOMReader;
import com.helger.xml.serialize.read.DOMReaderSettings;

import net.sf.saxon.s9api.ExtensionFunction;
import net.sf.saxon.s9api.ItemType;
import net.sf.saxon.s9api.OccurrenceIndicator;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SequenceType;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;

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

  /**
   * Demonstrates that the configured {@link EXPathVersion} actually reaches the Saxon compiler:
   * the test expression uses <code>fn:head(...)</code>, which was introduced in XPath 3.0. With the
   * default {@link EXPathVersion#XPATH_3_1} the schema binds and the assertion passes. With
   * {@link EXPathVersion#XPATH_2_0} the compiler does not know <code>fn:head</code>, so binding
   * fails.
   */
  @Test
  public void testXPathVersionPicksFunctions () throws Exception
  {
    final String sSchema = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                           "  <iso:pattern>\n" +
                           "    <iso:rule context='/root'>\n" +
                           "      <iso:assert test=\"head(('first','second')) = 'first'\">head() must return 'first'</iso:assert>\n" +
                           "    </iso:rule>\n" +
                           "  </iso:pattern>\n" +
                           "</iso:schema>";

    final Document aDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?><root/>");

    // XPath 3.1 (default) - head() is known, schema binds, assertion passes
    final SchematronOutputType aOK = SchematronResourcePure.fromString (sSchema, StandardCharsets.UTF_8)
                                                           .applySchematronValidationToSVRL (aDoc, null);
    assertNotNull (aOK);
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOK).size ());

    // Same check, but explicitly picking XPath 3.1 - identical outcome
    final IXPathConfig aXPathConfig31 = new XPathConfigBuilder ().setXPathVersion (EXPathVersion.XPATH_3_1).build ();
    final SchematronOutputType aOK31 = SchematronResourcePure.fromString (sSchema, StandardCharsets.UTF_8)
                                                             .setXPathConfig (aXPathConfig31)
                                                             .applySchematronValidationToSVRL (aDoc, null);
    assertNotNull (aOK31);
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOK31).size ());

    // XPath 2.0 - head() does not exist, binding must fail
    final IXPathConfig aXPathConfig20 = new XPathConfigBuilder ().setXPathVersion (EXPathVersion.XPATH_2_0).build ();
    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();
    final SchematronResourcePure aSch20 = SchematronResourcePure.fromString (sSchema, StandardCharsets.UTF_8)
                                                                .setXPathConfig (aXPathConfig20)
                                                                .setErrorHandler (aErrorHandler);
    assertFalse (aSch20.isValidSchematron ());
    assertTrue ("Expected an XPath compile error, got: " + aErrorHandler.getErrorList (),
                aErrorHandler.getErrorList ().isNotEmpty ());
  }

  /**
   * Simple {@link ExtensionFunction} that returns the number of items in its single argument.
   */
  private static final class MyCountFunction implements ExtensionFunction
  {
    public QName getName ()
    {
      return new QName ("http://helger.com/schematron/test", "my-count");
    }

    public SequenceType [] getArgumentTypes ()
    {
      return new SequenceType [] { SequenceType.ANY };
    }

    @Override
    public SequenceType getResultType ()
    {
      return ItemType.INTEGER.one ();
    }

    public XdmValue call (final XdmValue [] aArgs)
    {
      return new XdmAtomicValue (aArgs[0].size ());
    }
  }

  @Test
  public void testResolveVariables () throws SchematronException
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
    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().addExternalVariable (new QName ("title-element"),
                                                                                      new XdmAtomicValue ("title"))
                                                               .addExtensionFunction (new MyCountFunction ())
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

  /**
   * Extension function that joins each node's name and text content.
   */
  private static final class GetNodelistDetailsFunction implements ExtensionFunction
  {
    public QName getName ()
    {
      return new QName ("http://helger.com/schematron/test", "get-nodelist-details");
    }

    public SequenceType [] getArgumentTypes ()
    {
      return new SequenceType [] { SequenceType.makeSequenceType (ItemType.ANY_NODE, OccurrenceIndicator.ZERO_OR_MORE) };
    }

    @Override
    public SequenceType getResultType ()
    {
      return ItemType.STRING.one ();
    }

    public XdmValue call (final XdmValue [] aArgs)
    {
      assertEquals (1, aArgs.length);
      final XdmValue aFirstArg = aArgs[0];
      final StringBuilder ret = new StringBuilder ();
      boolean bFirst = true;
      for (final XdmItem aItem : aFirstArg)
      {
        assertTrue (aItem instanceof XdmNode);
        final XdmNode aXdmNode = (XdmNode) aItem;

        if (bFirst)
          bFirst = false;
        else
          ret.append (", ");

        ret.append (aXdmNode.getNodeName ().getLocalName ()).append ("[").append (aXdmNode.getStringValue ()).append (
                                                                                                                      "]");
      }
      return new XdmAtomicValue (ret.toString ());
    }
  }

  @Test
  public void testResolveFunctions () throws SchematronException
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

    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    "<title />" +
                                                    "<para>First para</para>" +
                                                    "<para>Second para</para>" +
                                                    "</chapter>");
    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().addExtensionFunction (new GetNodelistDetailsFunction ())
                                                               .build ();
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

    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().addAllExtensionFunctions (new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream (FILE_XQ)))
                                                               .build ();

    // Test with variable and function resolver
    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    "<title />" +
                                                    "<para>First para</para>" +
                                                    "<para>Second para</para>" +
                                                    "</chapter>");
    final SchematronOutputType aOT = SchematronResourcePure.fromByteArray (sTest.getBytes (StandardCharsets.UTF_8))
                                                           .setXPathConfig (aXPathConfig)
                                                           .applySchematronValidationToSVRL (aTestDoc, null);
    assertNotNull (aOT);
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOT).size ());
    assertEquals (1, SVRLHelper.getAllSuccessfulReports (aOT).size ());
    // Under XPath 2.0/3.0, applying functx:node-kind to a 2-node sequence yields one result per
    // node (space-separated), instead of the XPath-1.0 first-only behavior we used to rely on.
    assertEquals ("\n      Node kind: element element - end".trim (),
                  SVRLHelper.getAllSuccessfulReports (aOT).get (0).getText ());
  }

  @Test
  @Ignore
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

    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().addAllExtensionFunctions (new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream (FILE_XQ)))
                                                               .build ();

    // Test with variable and function resolver
    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    "<title />" +
                                                    "<para>100</para>" +
                                                    "<para>200</para>" +
                                                    "</chapter>");
    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler (new LoggingPSErrorHandler ());
    final SchematronOutputType aOT = SchematronResourcePure.fromByteArray (sTest.getBytes (StandardCharsets.UTF_8))
                                                           .setXPathConfig (aXPathConfig)
                                                           .setErrorHandler (aErrorHandler)
                                                           .applySchematronValidationToSVRL (aTestDoc, null);
    assertNotNull (aOT);
    // XXX fails :(
    assertTrue (aErrorHandler.getAllErrors ().toString (), aErrorHandler.isEmpty ());
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOT).size ());
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

    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().addAllExtensionFunctions (new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream (FILE_XQ)))
                                                               .build ();

    final Schema aSchema = XMLSchemaCache.getInstance ()
                                         .getSchema (new ClassPathResource ("external/issues/20141124/chapter.xsd"));
    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>" +
                                                    "<chapter>" +
                                                    " <title />" +
                                                    " <para>09</para>" +
                                                    " <para>9</para>" +
                                                    "</chapter>",
                                                    new DOMReaderSettings ().setSchema (aSchema));

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
