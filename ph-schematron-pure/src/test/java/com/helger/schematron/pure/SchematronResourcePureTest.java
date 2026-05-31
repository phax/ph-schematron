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
import static org.junit.Assert.fail;

import java.nio.charset.StandardCharsets;

import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.helger.base.io.nonblocking.NonBlockingByteArrayInputStream;
import com.helger.base.io.stream.StringInputStream;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.io.resource.inmemory.ReadableResourceByteArray;
import com.helger.schematron.SchematronException;
import com.helger.schematron.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.errorhandler.DoNothingPSErrorHandler;
import com.helger.schematron.errorhandler.LoggingPSErrorHandler;
import com.helger.schematron.model.PSRule;
import com.helger.schematron.pure.validation.IPSValidationHandler;
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

import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.s9api.ExtensionFunction;
import net.sf.saxon.s9api.ItemType;
import net.sf.saxon.s9api.OccurrenceIndicator;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SequenceType;
import net.sf.saxon.s9api.XPathCompiler;
import net.sf.saxon.s9api.XPathSelector;
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
   * Demonstrates that the configured {@link EXPathVersion} actually reaches the Saxon compiler: the
   * test expression uses <code>fn:head(...)</code>, which was introduced in XPath 3.0. With the
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
   * Validates that when the XML is provided through {@link SchematronResourcePure#getAsNode} the
   * document ends up parsed straight into a Saxon TinyTree exposed behind a
   * {@link net.sf.saxon.dom.NodeOverNodeInfo} facade — instead of a regular DOM document — and that
   * validation still works end-to-end. Also checks the fall-back to plain DOM parsing when a custom
   * XML entity resolver is configured.
   */
  @Test
  public void testSaxonTinyTreeFastPath () throws Exception
  {
    final String sSchema = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                           "  <iso:pattern>\n" +
                           "    <iso:rule context='/root'>\n" +
                           "      <iso:assert test='count(item) = 3'>three items expected</iso:assert>\n" +
                           "    </iso:rule>\n" +
                           "  </iso:pattern>\n" +
                           "</iso:schema>";

    final byte [] aXmlBytes = "<root><item/><item/><item/></root>".getBytes (StandardCharsets.UTF_8);

    // Capture the runtime type of the DOM node fed into the validation handler for the matched
    // rule context. With the TinyTree fast path it must be a Saxon-backed facade.
    final Class <?> [] aCapturedNodeClass = new Class <?> [1];
    final IPSValidationHandler aSpyHandler = new IPSValidationHandler ()
    {
      @Override
      public void onRuleStart (@NonNull final PSRule aRule, @NonNull final NodeList aContextList)
      {
        if (aContextList.getLength () > 0 && aCapturedNodeClass[0] == null)
          aCapturedNodeClass[0] = aContextList.item (0).getClass ();
      }
    };

    // Fast path: no entity resolver -> Saxon TinyTree
    final SchematronResourcePure aSCH = SchematronResourcePure.fromString (sSchema, StandardCharsets.UTF_8)
                                                              .setCustomValidationHandler (aSpyHandler);
    final SchematronOutputType aOT = aSCH.applySchematronValidationToSVRL (new ReadableResourceByteArray (aXmlBytes));
    assertNotNull (aOT);
    assertEquals (0, SVRLHelper.getAllFailedAssertions (aOT).size ());
    assertNotNull ("onRuleStart never fired", aCapturedNodeClass[0]);
    assertTrue ("Expected a Saxon NodeOverNodeInfo facade for the matched rule context node, got: " +
                aCapturedNodeClass[0].getName (),
                NodeOverNodeInfo.class.isAssignableFrom (aCapturedNodeClass[0]));

    // Fallback path: an entity resolver forces the DOM parsing route. The matched node must NOT
    // be a Saxon facade then.
    aCapturedNodeClass[0] = null;
    final SchematronResourcePure aSCH2 = SchematronResourcePure.fromString (sSchema, StandardCharsets.UTF_8)
                                                               .setCustomValidationHandler (aSpyHandler);
    aSCH2.setEntityResolver ( (publicId, systemId) -> null);
    final SchematronOutputType aOT2 = aSCH2.applySchematronValidationToSVRL (new ReadableResourceByteArray (aXmlBytes));
    assertNotNull (aOT2);
    assertNotNull ("onRuleStart never fired", aCapturedNodeClass[0]);
    assertFalse ("Expected a real DOM node when an entity resolver is configured, got: " +
                 aCapturedNodeClass[0].getName (),
                 NodeOverNodeInfo.class.isAssignableFrom (aCapturedNodeClass[0]));
  }

  /**
   * Regression test for the security review of the 9.2.0 Saxon TinyTree fast path. Saxon's default
   * {@code DocumentBuilder} route uses an unhardened JAXP {@code SAXParser} - i.e. with
   * {@code FEATURE_SECURE_PROCESSING=false}, DOCTYPE allowed and external entities enabled. The
   * {@code _buildSaxonDocument} helper wraps the input through a hardened {@link XMLReader}; this
   * test feeds an XML document carrying a DOCTYPE declaration and asserts the parser refuses it
   * up front (DISALLOW_DOCTYPE_DECL fires before any external resolution would be attempted).
   */
  @Test
  public void testFastPathHardenedAgainstXXE ()
  {
    final String sSchema = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                           "<iso:schema xmlns:iso='http://purl.oclc.org/dsdl/schematron'>\n" +
                           "  <iso:pattern>\n" +
                           "    <iso:rule context='/root'>\n" +
                           "      <iso:assert test='true()'>ok</iso:assert>\n" +
                           "    </iso:rule>\n" +
                           "  </iso:pattern>\n" +
                           "</iso:schema>";

    // Hostile XML: an external-entity reference that would, if resolved, fetch /etc/passwd.
    final String sHostileXml = "<?xml version='1.0' encoding='UTF-8'?>\n" +
                               "<!DOCTYPE root [\n" +
                               "  <!ENTITY xxe SYSTEM \"file:///etc/passwd\">\n" +
                               "]>\n" +
                               "<root>&xxe;</root>";

    final SchematronResourcePure aSCH = SchematronResourcePure.fromString (sSchema, StandardCharsets.UTF_8);
    Throwable thrown = null;
    try
    {
      aSCH.applySchematronValidationToSVRL (new ReadableResourceByteArray (sHostileXml.getBytes (StandardCharsets.UTF_8)));
    }
    catch (final Exception ex)
    {
      thrown = ex;
    }
    assertNotNull ("Expected the hardened parser to reject the DOCTYPE-bearing input", thrown);
    // Surface the SAX cause to make sure we are failing on the hardened-feature path and not on
    // an unrelated downstream error.
    Throwable cause = thrown;
    boolean bSawDoctypeRejection = false;
    while (cause != null)
    {
      final String sMsg = cause.getMessage ();
      if (sMsg != null && sMsg.toLowerCase ().contains ("doctype"))
      {
        bSawDoctypeRejection = true;
        break;
      }
      cause = cause.getCause ();
    }
    assertTrue ("Expected failure to mention DOCTYPE rejection but got: " + thrown, bSawDoctypeRejection);
  }

  /**
   * Regression test for the security review: {@code XPathConfigBuilder.build()} must not mutate
   * the shared {@code DEFAULT_PROCESSOR} when extension functions are added without an explicit
   * processor. Otherwise a function registered for caller A leaks into every other caller using
   * the default config (cross-tenant function poisoning).
   */
  @Test
  public void testBuildDoesNotPoisonDefaultProcessor () throws Exception
  {
    final ExtensionFunction aFn = new ExtensionFunction ()
    {
      public QName getName ()
      {
        return new QName ("http://helger.com/schematron/test", "tenant-A-secret");
      }

      public SequenceType [] getArgumentTypes ()
      {
        return new SequenceType [0];
      }

      @Override
      public SequenceType getResultType ()
      {
        return ItemType.STRING.one ();
      }

      public XdmValue call (final XdmValue [] args)
      {
        return new XdmAtomicValue ("leaked");
      }
    };

    final IXPathConfig aTenantA = new XPathConfigBuilder ().addExtensionFunction (aFn).build ();
    assertTrue ("Tenant A should have got its own Processor (not the shared default)",
                aTenantA.getProcessor () != XPathConfigBuilder.DEFAULT_PROCESSOR);

    // Now tenant B uses XPathConfigBuilder.DEFAULT - calling tenant A's function must fail. With
    // the old code, DEFAULT_PROCESSOR had been mutated by tenant A's build() and tenant B's
    // expression would succeed.
    final XPathCompiler aXPathC = XPathConfigBuilder.DEFAULT_PROCESSOR.newXPathCompiler ();
    aXPathC.declareNamespace ("t", "http://helger.com/schematron/test");
    try
    {
      aXPathC.compile ("t:tenant-A-secret()");
      fail ("Tenant A's extension function leaked into the shared DEFAULT_PROCESSOR");
    }
    catch (final net.sf.saxon.s9api.SaxonApiException expected)
    {
      // good - the function is not visible on the shared processor
    }
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
      return new SequenceType [] { SequenceType.makeSequenceType (ItemType.ANY_NODE,
                                                                  OccurrenceIndicator.ZERO_OR_MORE) };
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

        ret.append (aXdmNode.getNodeName ().getLocalName ())
           .append ("[")
           .append (aXdmNode.getStringValue ())
           .append ("]");
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

  /**
   * Standalone XPath-only test (no Schematron) that proves the {@code functx:are-distinct-values}
   * user function can be called via the Saxon s9api. Originally this exercised the JAXP XPath API
   * and hit a {@code ClassCastException} between {@code DOMNodeWrapper} and {@code AtomicValue}
   * inside {@code distinct-values}; the s9api path with a TinyTree-built document avoids the DOM
   * bridge entirely and behaves correctly.
   *
   * @throws Exception
   *         on error
   */
  @Test
  public void testResolveXQueryAreDistinctValues () throws Exception
  {
    final Processor aProc = new Processor (false);

    // Register all functx extension functions on the processor
    final ICommonsList <ExtensionFunction> aFunctions = new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream (FILE_XQ));
    for (final ExtensionFunction aFn : aFunctions)
      aProc.registerExtensionFunction (aFn);

    // Build the input document as a Saxon TinyTree
    final byte [] aXmlBytes = ("<?xml version='1.0'?>" +
                               "<chapter>" +
                               "<title/>" +
                               "<para>100</para>" +
                               "<para>200</para>" +
                               "</chapter>").getBytes (StandardCharsets.UTF_8);
    final XdmNode aDocXdm = aProc.newDocumentBuilder ()
                                 .build (new StreamSource (new NonBlockingByteArrayInputStream (aXmlBytes)));

    final XPathCompiler aXPathC = aProc.newXPathCompiler ();
    aXPathC.declareNamespace ("functx", "http://www.functx.com");

    // count(/chapter/para) == 2
    XPathSelector sel = aXPathC.compile ("count(/chapter/para)").load ();
    sel.setContextItem (aDocXdm);
    assertEquals (2L, ((XdmAtomicValue) sel.evaluateSingle ()).getLongValue ());

    // count(distinct-values(/chapter/para)) == 2
    sel = aXPathC.compile ("count(distinct-values(/chapter/para))").load ();
    sel.setContextItem (aDocXdm);
    assertEquals (2L, ((XdmAtomicValue) sel.evaluateSingle ()).getLongValue ());

    // functx:are-distinct-values(/chapter/para) == true
    sel = aXPathC.compile ("functx:are-distinct-values(/chapter/para)").load ();
    sel.setContextItem (aDocXdm);
    assertTrue (((XdmAtomicValue) sel.evaluateSingle ()).getBooleanValue ());
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
