/**
 * Copyright (C) 2014 Philip Helger (www.helger.com)
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

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.xml.xpath.XPathFunction;
import javax.xml.xpath.XPathFunctionException;

import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.expr.instruct.UserFunction;
import net.sf.saxon.functions.ExecutableFunctionLibrary;
import net.sf.saxon.functions.FunctionLibrary;
import net.sf.saxon.functions.FunctionLibraryList;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.query.QueryModule;
import net.sf.saxon.query.StaticQueryContext;
import net.sf.saxon.query.XQueryExpression;
import net.sf.saxon.trans.XPathException;

import org.junit.Ignore;
import org.junit.Test;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import com.helger.commons.charset.CCharset;
import com.helger.commons.collections.ContainerHelper;
import com.helger.commons.io.IReadableResource;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.streams.StringInputStream;
import com.helger.commons.xml.serialize.DOMReader;
import com.helger.commons.xml.xpath.MapBasedXPathFunctionResolver;
import com.helger.commons.xml.xpath.MapBasedXPathVariableResolver;
import com.helger.schematron.SchematronException;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.svrl.SVRLUtils;
import com.helger.schematrontest.SchematronTestHelper;

/**
 * Test class for class {@link SchematronResourcePure}.
 *
 * @author Philip Helger
 */
public final class SchematronResourcePureTest
{
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
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n"
                         + "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \n"
                         + "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \n"
                         + "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\n"
                         + "         queryBinding='xslt2'\n"
                         + "         schemaVersion=\"ISO19757-3\">\n"
                         + "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n"
                         + "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\n"
                         + " <iso:pattern >\n"
                         + "    <iso:title>A very simple pattern with a title</iso:title>\n"
                         + "    <iso:rule context=\"chapter\">\n"
                         + "      <iso:assert test=\"title\">Chapter should have a title</iso:assert>\n"
                         + "      <iso:report test=\"count(para)\">\n"
                         + "      <iso:value-of select=\"count(para)\"/> paragraphs</iso:report>\n"
                         + "    </iso:rule>\n"
                         + "  </iso:pattern>\n"
                         + "\n"
                         + "</iso:schema>";
    assertTrue (SchematronResourcePure.fromByteArray (sTest.getBytes (CCharset.CHARSET_ISO_8859_1_OBJ))
                                      .isValidSchematron ());
    assertTrue (SchematronResourcePure.fromInputStream (new StringInputStream (sTest, CCharset.CHARSET_ISO_8859_1_OBJ))
                                      .isValidSchematron ());
  }

  @Test
  public void testParseWithXPathError ()
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n"
                         + "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \n"
                         + "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \n"
                         + "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\n"
                         + "         queryBinding='xslt2'\n"
                         + "         schemaVersion=\"ISO19757-3\">\n"
                         + "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n"
                         + "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\n"
                         + " <iso:pattern >\n"
                         + "    <iso:title>A very simple pattern with a title</iso:title>\n"
                         + "    <iso:rule context=\"chapter\">\n"
                         // This line contains the XPath error (Node xor number
                         // is invalid)
                         + "      <iso:assert test=\"title xor 55\">Chapter should have a title</iso:assert>\n"
                         + "      <iso:report test=\"count(para)\">\n"
                         + "      <iso:value-of select=\"count(para)\"/> paragraphs</iso:report>\n"
                         + "    </iso:rule>\n"
                         + "  </iso:pattern>\n"
                         + "\n"
                         + "</iso:schema>";
    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();
    assertFalse (SchematronResourcePure.fromByteArray (sTest.getBytes (CCharset.CHARSET_ISO_8859_1_OBJ))
                                       .setErrorHandler (aErrorHandler)
                                       .isValidSchematron ());
    assertEquals ("Expected only one error: " + aErrorHandler.getResourceErrors ().toString (),
                  1,
                  aErrorHandler.getResourceErrors ().size ());
    System.out.println (aErrorHandler.getResourceErrors ().toString ());
  }

  @Test
  public void testResolveVariables () throws SchematronException, SAXException
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n"
                         + "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \n"
                         + "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \n"
                         + "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\n"
                         + "         queryBinding='xslt2'\n"
                         + "         schemaVersion=\"ISO19757-3\">\n"
                         + "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n"
                         + "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\n"
                         + "  <iso:ns prefix=\"java\" uri=\"http://helger.com/schematron/test\" />\n"
                         + "  <iso:pattern >\n"
                         + "    <iso:title>A very simple pattern with a title</iso:title>\n"
                         + "    <iso:rule context=\"chapter\">\n"
                         // Custom variable
                         + "      <iso:assert test=\"$title-element\">Chapter should have a title</iso:assert>\n"
                         // Custom function
                         + "      <iso:report test=\"java:my-count(para) = 2\">\n"
                         // Custom function
                         + "      <iso:value-of select=\"java:my-count(para)\"/> paragraphs found</iso:report>\n"
                         + "    </iso:rule>\n"
                         + "  </iso:pattern>\n"
                         + "\n"
                         + "</iso:schema>";

    // Test without variable and function resolver
    assertFalse (SchematronResourcePure.fromString (sTest, CCharset.CHARSET_ISO_8859_1_OBJ).isValidSchematron ());

    // Test with variable and function resolver
    final MapBasedXPathVariableResolver aVarResolver = new MapBasedXPathVariableResolver ();
    aVarResolver.addUniqueVariable ("title-element", "title");

    final MapBasedXPathFunctionResolver aFunctionResolver = new MapBasedXPathFunctionResolver ();
    aFunctionResolver.addUniqueFunction ("http://helger.com/schematron/test", "my-count", 1, new XPathFunction ()
    {
      public Object evaluate (@SuppressWarnings ("rawtypes") final List args) throws XPathFunctionException
      {
        final List <?> aArg = (List <?>) args.get (0);
        return Integer.valueOf (aArg.size ());
      }
    });
    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?><chapter><title /><para>First para</para><para>Second para</para></chapter>");
    final SchematronOutputType aOT = SchematronResourcePure.fromString (sTest, CCharset.CHARSET_ISO_8859_1_OBJ)
                                                           .setVariableResolver (aVarResolver)
                                                           .setFunctionResolver (aFunctionResolver)
                                                           .applySchematronValidation (aTestDoc);
    assertNotNull (aOT);
    assertEquals (0, SVRLUtils.getAllFailedAssertions (aOT).size ());
    assertEquals (1, SVRLUtils.getAllSuccesssfulReports (aOT).size ());
    // Note: the text contains all whitespaces!
    assertEquals ("\n      2 paragraphs found", SVRLUtils.getAllSuccesssfulReports (aOT).get (0).getText ());
  }

  @Test
  public void testResolveFunctions () throws SchematronException, SAXException
  {
    final String sTest = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n"
                         + "<iso:schema xmlns=\"http://purl.oclc.org/dsdl/schematron\" \n"
                         + "         xmlns:iso=\"http://purl.oclc.org/dsdl/schematron\" \n"
                         + "         xmlns:sch=\"http://www.ascc.net/xml/schematron\"\n"
                         + "         queryBinding='xslt2'\n"
                         + "         schemaVersion=\"ISO19757-3\">\n"
                         + "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n"
                         + "  <iso:ns prefix=\"dp\" uri=\"http://www.dpawson.co.uk/ns#\" />\n"
                         + "  <iso:ns prefix=\"java\" uri=\"http://helger.com/schematron/test\" />\n"
                         + "  <iso:pattern >\n"
                         + "    <iso:title>A very simple pattern with a title</iso:title>\n"
                         + "    <iso:rule context=\"chapter\">\n"
                         + "      <iso:assert test=\"title\">Chapter should have a title</iso:assert>\n"
                         + "      <iso:report test=\"count(para) = 2\">\n"
                         // Custom function
                         + "      Node details: <iso:value-of select=\"java:get-nodelist-details(para)\"/> - end</iso:report>\n"
                         + "    </iso:rule>\n"
                         + "  </iso:pattern>\n"
                         + "\n"
                         + "</iso:schema>";

    // Test with variable and function resolver
    final MapBasedXPathFunctionResolver aFunctionResolver = new MapBasedXPathFunctionResolver ();
    aFunctionResolver.addUniqueFunction ("http://helger.com/schematron/test",
                                         "get-nodelist-details",
                                         1,
                                         new XPathFunction ()
                                         {
                                           public Object evaluate (@SuppressWarnings ("rawtypes") final List args) throws XPathFunctionException
                                           {
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

                                               ret.append (aNode.getNodeName ())
                                                  .append ("[")
                                                  .append (aNode.getTextContent ())
                                                  .append ("]");
                                             }

                                             return ret;
                                           }
                                         });

    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>"
                                                    + "<chapter>"
                                                    + "<title />"
                                                    + "<para>First para</para>"
                                                    + "<para>Second para</para>"
                                                    + "</chapter>");
    final SchematronOutputType aOT = SchematronResourcePure.fromString (sTest, CCharset.CHARSET_ISO_8859_1_OBJ)
                                                           .setFunctionResolver (aFunctionResolver)
                                                           .applySchematronValidation (aTestDoc);
    assertNotNull (aOT);
    assertEquals (0, SVRLUtils.getAllFailedAssertions (aOT).size ());
    assertEquals (1, SVRLUtils.getAllSuccesssfulReports (aOT).size ());
    // Note: the text contains all whitespaces!
    assertEquals ("\n      Node details: para[First para], para[Second para] - end",
                  SVRLUtils.getAllSuccesssfulReports (aOT).get (0).getText ());
  }

  @Test
  @Ignore ("Does not work right now")
  public void testResolveXQueryFunctions () throws Exception
  {
    final String sTest = "<?xml version='1.0' encoding='iso-8859-1'?>\n"
                         + "<iso:schema xmlns='http://purl.oclc.org/dsdl/schematron' \n"
                         + "         xmlns:iso='http://purl.oclc.org/dsdl/schematron' \n"
                         + "         xmlns:sch='http://www.ascc.net/xml/schematron'\n"
                         + "         queryBinding='xslt2'\n"
                         + "         schemaVersion='ISO19757-3'>\n"
                         + "  <iso:title>Test ISO schematron file. Introduction mode</iso:title>\n"
                         + "  <iso:ns prefix='dp' uri='http://www.dpawson.co.uk/ns#' />\n"
                         + "  <iso:ns prefix='functx' uri='http://www.functx.com' />\n"
                         + "  <iso:pattern >\n"
                         + "    <iso:title>A very simple pattern with a title</iso:title>\n"
                         + "    <iso:rule context='chapter'>\n"
                         + "      <iso:assert test='title'>Chapter should have a title</iso:assert>\n"
                         + "      <iso:report test='count(para) = 2'>\n"
                         // Custom function
                         + "      Node details: <iso:value-of select='functx:node-kind(para)'/> - end</iso:report>\n"
                         + "    </iso:rule>\n"
                         + "  </iso:pattern>\n"
                         + "\n"
                         + "</iso:schema>";

    final class Data
    {
      final String m_sName;
      final int m_nArity;

      public Data (final String sName, final int nArity)
      {
        m_sName = sName;
        m_nArity = nArity;
      }
    }

    final String FUNCX_NS = "http://www.functx.com";
    final List <Data> aFuncXFunctions = new ArrayList <Data> ();
    aFuncXFunctions.add (new Data ("time", 3));
    aFuncXFunctions.add (new Data ("all-whitespace", 1));
    aFuncXFunctions.add (new Data ("trim", 1));
    aFuncXFunctions.add (new Data ("wrap-values-in-elements", 2));
    aFuncXFunctions.add (new Data ("update-attributes", 3));
    aFuncXFunctions.add (new Data ("id-from-element", 1));
    aFuncXFunctions.add (new Data ("yearMonthDuration", 2));
    aFuncXFunctions.add (new Data ("substring-before-last-match", 2));
    aFuncXFunctions.add (new Data ("atomic-type", 1));
    aFuncXFunctions.add (new Data ("add-months", 2));
    aFuncXFunctions.add (new Data ("scheme-from-uri", 1));
    aFuncXFunctions.add (new Data ("mmddyyyy-to-date", 1));
    aFuncXFunctions.add (new Data ("value-union", 2));
    aFuncXFunctions.add (new Data ("id-untyped", 2));
    aFuncXFunctions.add (new Data ("substring-before-match", 2));
    aFuncXFunctions.add (new Data ("max-depth", 1));
    aFuncXFunctions.add (new Data ("total-months-from-duration", 1));
    aFuncXFunctions.add (new Data ("value-except", 2));
    aFuncXFunctions.add (new Data ("index-of-match-first", 2));
    aFuncXFunctions.add (new Data ("name-test", 2));
    aFuncXFunctions.add (new Data ("pad-string-to-length", 3));
    aFuncXFunctions.add (new Data ("date", 3));
    aFuncXFunctions.add (new Data ("replace-element-values", 2));
    aFuncXFunctions.add (new Data ("substring-after-match", 2));
    aFuncXFunctions.add (new Data ("get-matches", 2));
    aFuncXFunctions.add (new Data ("change-element-ns", 3));
    aFuncXFunctions.add (new Data ("is-a-number", 1));
    aFuncXFunctions.add (new Data ("remove-elements-not-contents", 2));
    aFuncXFunctions.add (new Data ("siblings", 1));
    aFuncXFunctions.add (new Data ("node-kind", 1));
    aFuncXFunctions.add (new Data ("day-in-year", 1));
    aFuncXFunctions.add (new Data ("total-seconds-from-duration", 1));
    aFuncXFunctions.add (new Data ("last-day-of-month", 1));
    aFuncXFunctions.add (new Data ("sequence-type", 1));
    aFuncXFunctions.add (new Data ("substring-before-last", 2));
    aFuncXFunctions.add (new Data ("are-distinct-values", 1));
    aFuncXFunctions.add (new Data ("max-string", 1));
    aFuncXFunctions.add (new Data ("words-to-camel-case", 1));
    aFuncXFunctions.add (new Data ("siblings-same-name", 1));
    aFuncXFunctions.add (new Data ("open-ref-document", 1));
    aFuncXFunctions.add (new Data ("format-as-title-en", 1));
    aFuncXFunctions.add (new Data ("if-absent", 2));
    aFuncXFunctions.add (new Data ("substring-after-if-contains", 2));
    aFuncXFunctions.add (new Data ("copy-attributes", 2));
    aFuncXFunctions.add (new Data ("first-day-of-year", 1));
    aFuncXFunctions.add (new Data ("substring-after-last", 2));
    aFuncXFunctions.add (new Data ("add-attributes", 3));
    aFuncXFunctions.add (new Data ("remove-attributes-deep", 2));
    aFuncXFunctions.add (new Data ("day-of-week", 1));
    aFuncXFunctions.add (new Data ("has-mixed-content", 1));
    aFuncXFunctions.add (new Data ("dynamic-path", 2));
    aFuncXFunctions.add (new Data ("value-intersect", 2));
    aFuncXFunctions.add (new Data ("sort-case-insensitive", 1));
    aFuncXFunctions.add (new Data ("if-empty", 2));
    aFuncXFunctions.add (new Data ("substring-before-if-contains", 2));
    aFuncXFunctions.add (new Data ("first-node", 1));
    aFuncXFunctions.add (new Data ("get-matches-and-non-matches", 2));
    aFuncXFunctions.add (new Data ("is-absolute-uri", 1));
    aFuncXFunctions.add (new Data ("index-of-string-last", 2));
    aFuncXFunctions.add (new Data ("remove-attributes", 2));
    aFuncXFunctions.add (new Data ("is-leap-year", 1));
    aFuncXFunctions.add (new Data ("right-trim", 1));
    aFuncXFunctions.add (new Data ("replace-beginning", 3));
    aFuncXFunctions.add (new Data ("is-node-among-descendants-deep-equal", 2));
    aFuncXFunctions.add (new Data ("sort-as-numeric", 1));
    aFuncXFunctions.add (new Data ("total-days-from-duration", 1));
    aFuncXFunctions.add (new Data ("days-in-month", 1));
    aFuncXFunctions.add (new Data ("line-count", 1));
    aFuncXFunctions.add (new Data ("contains-any-of", 2));
    aFuncXFunctions.add (new Data ("non-distinct-values", 1));
    aFuncXFunctions.add (new Data ("total-years-from-duration", 1));
    aFuncXFunctions.add (new Data ("leaf-elements", 1));
    aFuncXFunctions.add (new Data ("max-determine-type", 1));
    aFuncXFunctions.add (new Data ("index-of-node", 2));
    aFuncXFunctions.add (new Data ("remove-elements-deep", 2));
    aFuncXFunctions.add (new Data ("sequence-node-equal-any-order", 2));
    aFuncXFunctions.add (new Data ("dayTimeDuration", 4));
    aFuncXFunctions.add (new Data ("day-of-week-abbrev-en", 1));
    aFuncXFunctions.add (new Data ("index-of-string-first", 2));
    aFuncXFunctions.add (new Data ("camel-case-to-words", 2));
    aFuncXFunctions.add (new Data ("last-day-of-year", 1));
    aFuncXFunctions.add (new Data ("is-node-in-sequence", 2));
    aFuncXFunctions.add (new Data ("precedes-not-ancestor", 2));
    aFuncXFunctions.add (new Data ("fragment-from-uri", 1));
    aFuncXFunctions.add (new Data ("depth-of-node", 1));
    aFuncXFunctions.add (new Data ("is-node-among-descendants", 2));
    aFuncXFunctions.add (new Data ("total-hours-from-duration", 1));
    aFuncXFunctions.add (new Data ("word-count", 1));
    aFuncXFunctions.add (new Data ("sequence-node-equal", 2));
    aFuncXFunctions.add (new Data ("dateTime", 6));
    aFuncXFunctions.add (new Data ("min-string", 1));
    aFuncXFunctions.add (new Data ("distinct-element-names", 1));
    aFuncXFunctions.add (new Data ("min-node", 1));
    aFuncXFunctions.add (new Data ("between-exclusive", 3));
    aFuncXFunctions.add (new Data ("avg-empty-is-zero", 2));
    aFuncXFunctions.add (new Data ("replace-first", 3));
    aFuncXFunctions.add (new Data ("has-empty-content", 1));
    aFuncXFunctions.add (new Data ("pad-integer-to-length", 2));
    aFuncXFunctions.add (new Data ("has-simple-content", 1));
    aFuncXFunctions.add (new Data ("has-element-only-content", 1));
    aFuncXFunctions.add (new Data ("change-element-names-deep", 3));
    aFuncXFunctions.add (new Data ("is-value-in-sequence", 2));
    aFuncXFunctions.add (new Data ("contains-case-insensitive", 2));
    aFuncXFunctions.add (new Data ("left-trim", 1));
    aFuncXFunctions.add (new Data ("next-day", 1));
    aFuncXFunctions.add (new Data ("repeat-string", 2));
    aFuncXFunctions.add (new Data ("duration-from-timezone", 1));
    aFuncXFunctions.add (new Data ("min-determine-type", 1));
    aFuncXFunctions.add (new Data ("ordinal-number-en", 1));
    aFuncXFunctions.add (new Data ("distinct-deep", 1));
    aFuncXFunctions.add (new Data ("total-minutes-from-duration", 1));
    aFuncXFunctions.add (new Data ("path-to-node", 1));
    aFuncXFunctions.add (new Data ("is-node-in-sequence-deep-equal", 2));
    aFuncXFunctions.add (new Data ("insert-string", 3));
    aFuncXFunctions.add (new Data ("month-name-en", 1));
    aFuncXFunctions.add (new Data ("contains-word", 2));
    aFuncXFunctions.add (new Data ("lines", 1));
    aFuncXFunctions.add (new Data ("exclusive-or", 2));
    aFuncXFunctions.add (new Data ("capitalize-first", 1));
    aFuncXFunctions.add (new Data ("between-inclusive", 3));
    aFuncXFunctions.add (new Data ("index-of-deep-equal-node", 2));
    aFuncXFunctions.add (new Data ("max-node", 1));
    aFuncXFunctions.add (new Data ("distinct-nodes", 1));
    aFuncXFunctions.add (new Data ("remove-elements", 2));
    aFuncXFunctions.add (new Data ("sort", 1));
    aFuncXFunctions.add (new Data ("index-of-string", 2));
    aFuncXFunctions.add (new Data ("escape-for-regex", 1));
    aFuncXFunctions.add (new Data ("timezone-from-duration", 1));
    aFuncXFunctions.add (new Data ("previous-day", 1));
    aFuncXFunctions.add (new Data ("min-non-empty-string", 1));
    aFuncXFunctions.add (new Data ("path-to-node-with-pos", 1));
    aFuncXFunctions.add (new Data ("replace-multi", 3));
    aFuncXFunctions.add (new Data ("is-ancestor", 2));
    aFuncXFunctions.add (new Data ("first-day-of-month", 1));
    aFuncXFunctions.add (new Data ("namespaces-in-use", 1));
    aFuncXFunctions.add (new Data ("sort-document-order", 1));
    aFuncXFunctions.add (new Data ("month-abbrev-en", 1));
    aFuncXFunctions.add (new Data ("is-descendant", 2));
    aFuncXFunctions.add (new Data ("number-of-matches", 2));
    aFuncXFunctions.add (new Data ("distinct-attribute-names", 1));
    aFuncXFunctions.add (new Data ("follows-not-descendant", 2));
    aFuncXFunctions.add (new Data ("max-line-length", 1));
    aFuncXFunctions.add (new Data ("distinct-element-paths", 1));
    aFuncXFunctions.add (new Data ("substring-after-last-match", 2));
    aFuncXFunctions.add (new Data ("reverse-string", 1));
    aFuncXFunctions.add (new Data ("sequence-deep-equal", 2));
    aFuncXFunctions.add (new Data ("chars", 1));
    aFuncXFunctions.add (new Data ("change-element-ns-deep", 3));
    aFuncXFunctions.add (new Data ("day-of-week-name-en", 1));
    aFuncXFunctions.add (new Data ("add-or-update-attributes", 3));
    aFuncXFunctions.add (new Data ("last-node", 1));

    final MapBasedXPathFunctionResolver aFunctionResolver = new MapBasedXPathFunctionResolver ();

    // create a Configuration object
    final Configuration C = new Configuration ();
    final StaticQueryContext SQC = C.newStaticQueryContext ();
    SQC.setBaseURI (new File ("").toURI ().toURL ().toExternalForm ());
    final XQueryExpression exp = SQC.compileQuery (ClassPathResource.getInputStream ("xquery/functx-1.0-nodoc-2007-01.xq"),
                                                   null);
    final Controller aXQController = exp.newController ();
    final QueryModule aXQQueryModule = exp.getStaticContext ();
    // aExpQueryModule.getUserDefinedFunction (uri, localName, arity)

    // find all methods
    if (false)
    {
      final FunctionLibraryList aFuncLibList = exp.getExecutable ().getFunctionLibrary ();
      for (final FunctionLibrary aFuncLib : aFuncLibList.getLibraryList ())
        if (aFuncLib instanceof FunctionLibraryList)
        {
          final FunctionLibraryList aRealFuncLib = (FunctionLibraryList) aFuncLib;
          for (final UserFunction aUserFunc : ContainerHelper.newList (((ExecutableFunctionLibrary) aRealFuncLib.get (0)).iterateFunctions ()))
          {
            System.out.println ("aFuncXFunctions.add (new Data (\"" +
                                aUserFunc.getFunctionName ().getLocalPart () +
                                "\"," +
                                aUserFunc.getNumberOfArguments () +
                                "));");
          }
        }
    }
    else
    {
      for (final Data aFuncXData : aFuncXFunctions)
      {
        final UserFunction aUF = aXQQueryModule.getUserDefinedFunction (FUNCX_NS,
                                                                        aFuncXData.m_sName,
                                                                        aFuncXData.m_nArity);
        aFunctionResolver.addUniqueFunction (FUNCX_NS, aFuncXData.m_sName, aFuncXData.m_nArity, new XPathFunction ()
        {
          public Object evaluate (@SuppressWarnings ("rawtypes") final List args) throws XPathFunctionException
          {
            final Sequence [] aValues = new Sequence [args.size ()];
            int i = 0;
            for (final Object arg : args)
            {
              if (arg instanceof ArrayList)
              {
                // ????
              }
              else
              {
                System.out.println (arg.getClass ());
                aValues[i] = (Sequence) arg;
              }
              ++i;
            }
            try
            {
              return aUF.call (aValues, aXQController);
            }
            catch (final XPathException ex)
            {
              throw new XPathFunctionException (ex);
            }
          }
        });
      }
    }

    // Test with variable and function resolver
    final Document aTestDoc = DOMReader.readXMLDOM ("<?xml version='1.0'?>"
                                                    + "<chapter>"
                                                    + "<title />"
                                                    + "<para>First para</para>"
                                                    + "<para>Second para</para>"
                                                    + "</chapter>");
    final SchematronOutputType aOT = SchematronResourcePure.fromString (sTest, CCharset.CHARSET_ISO_8859_1_OBJ)
                                                           .setFunctionResolver (aFunctionResolver)
                                                           .applySchematronValidation (aTestDoc);
    assertNotNull (aOT);
    assertEquals (0, SVRLUtils.getAllFailedAssertions (aOT).size ());
    assertEquals (1, SVRLUtils.getAllSuccesssfulReports (aOT).size ());
    // Note: the text contains all whitespaces!
    assertEquals ("\n      Node details: para[First para], para[Second para] - end",
                  SVRLUtils.getAllSuccesssfulReports (aOT).get (0).getText ());
  }
}
