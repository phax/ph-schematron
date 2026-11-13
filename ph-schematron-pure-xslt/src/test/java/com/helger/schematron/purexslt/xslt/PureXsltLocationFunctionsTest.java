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
import static org.junit.Assert.assertTrue;

import java.io.StringReader;
import java.nio.charset.StandardCharsets;

import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.inmemory.ReadableResourceString;
import com.helger.schematron.exchange.PSReader;
import com.helger.schematron.model.PSSchema;
import com.helger.schematron.saxon.SchematronProcessorFactory;
import com.helger.schematron.svrl.CSVRL;
import com.helger.xml.XMLFactory;

import net.sf.saxon.s9api.DOMDestination;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.Xslt30Transformer;
import net.sf.saxon.s9api.XsltExecutable;

/**
 * Test class for class {@link PureXsltLocationFunctions}.
 *
 * @author Philip Helger
 */
public final class PureXsltLocationFunctionsTest
{
  /**
   * Same named siblings in no namespace, in the default namespace and with two prefixes for the same
   * namespace, attributes with and without namespace, text, comments and processing instructions.
   */
  private static final String XML = "<?xml version='1.0' encoding='UTF-8'?>" +
                                    "<root xmlns:a='urn:a' xmlns:b='urn:a' xmlns:c='urn:c'>" +
                                    "<item id='1'>t1<!--c1--><?pi x?>t2</item>" +
                                    "<a:item a:id='2'/>" +
                                    "<item xmlns='urn:a'/>" +
                                    "<b:item/>" +
                                    "<item/>" +
                                    "<c:item c:id='3' id='4'>t3<?pi y?><?other z?><!--c2--><item/><item/></c:item>" +
                                    "<other/>" +
                                    "<item><a:item/><b:item/><item/></item>" +
                                    "</root>";

  private static final String CHECK_XSLT = "<xsl:stylesheet version='3.0'" +
                                           " xmlns:xsl='http://www.w3.org/1999/XSL/Transform'" +
                                           " xmlns:phsch='" +
                                           PureXsltStylesheetGenerator.PATH_FUNC_NS +
                                           "'>" +
                                           "<xsl:output method='text'/>" +
                                           "<xsl:template match='/'>" +
                                           // Trees without a document node
                                           "<xsl:variable name='free' as='element()'>" +
                                           "<r xmlns:a='urn:a'><x/><a:x/>text<x/><!--c--><?pi d?><x q='1'/></r>" +
                                           "</xsl:variable>" +
                                           "<xsl:variable name='attr' as='attribute()'>" +
                                           "<xsl:attribute name='q'>1</xsl:attribute>" +
                                           "</xsl:variable>" +
                                           "<xsl:variable name='nodes' select='(/, //node(), //@*, //namespace::*, $free, $free//node(), $free//@*, $free/namespace::*, $attr)'/>" +
                                           "<xsl:variable name='elements' select='(//*, $free/descendant-or-self::*)'/>" +
                                           "<xsl:for-each select='$nodes'>" +
                                           "<xsl:if test='phsch:fn-path(.) ne path(.)'>" +
                                           "<xsl:value-of select=\"'fn-path ' || path(.) || ' = ' || phsch:fn-path(.) || '&#10;'\"/>" +
                                           "</xsl:if>" +
                                           "</xsl:for-each>" +
                                           "<xsl:for-each select='$elements'>" +
                                           "<xsl:if test='phsch:index-by-name(.) ne 1 + count(preceding-sibling::*[name() = name(current())])'>" +
                                           "<xsl:value-of select=\"'index-by-name ' || path(.) || '&#10;'\"/>" +
                                           "</xsl:if>" +
                                           "<xsl:if test='phsch:index-by-ns-name(.) ne 1 + count(preceding-sibling::*[local-name() = local-name(current()) and namespace-uri() = namespace-uri(current())])'>" +
                                           "<xsl:value-of select=\"'index-by-ns-name ' || path(.) || '&#10;'\"/>" +
                                           "</xsl:if>" +
                                           "</xsl:for-each>" +
                                           "<xsl:value-of select=\"'checked ' || count($nodes) || ' ' || count($elements)\"/>" +
                                           "</xsl:template>" +
                                           "</xsl:stylesheet>";

  private static final String SCH = "<?xml version='1.0' encoding='UTF-8'?>" +
                                    "<schema xmlns='http://purl.oclc.org/dsdl/schematron' queryBinding='xslt2'>" +
                                    "<ns prefix='a' uri='urn:a'/>" +
                                    "<ns prefix='c' uri='urn:c'/>" +
                                    "<pattern>" +
                                    "<rule context='*'><report test='true()'>element</report></rule>" +
                                    "</pattern>" +
                                    "<pattern>" +
                                    "<rule context='@*'><report test='true()'>attribute</report></rule>" +
                                    "</pattern>" +
                                    "</schema>";

  @Test
  public void testSameResultsAsXPath () throws Exception
  {
    // The shared default processor disallows calls to external functions
    final Processor aProcessor = SchematronProcessorFactory.getDefault ();
    PureXsltLocationFunctions.registerIfMissing (aProcessor);
    // Registering again does nothing
    PureXsltLocationFunctions.registerIfMissing (aProcessor);

    final XsltExecutable aExecutable = aProcessor.newXsltCompiler ()
                                                 .compile (new StreamSource (new StringReader (CHECK_XSLT)));
    final XdmNode aInput = aProcessor.newDocumentBuilder ().build (new StreamSource (new StringReader (XML)));
    final Xslt30Transformer aTransformer = aExecutable.load30 ();
    final String sResult = aTransformer.applyTemplates (aInput).toString ();

    // No mismatches, only the final line with the counts
    assertTrue (sResult, sResult.startsWith ("checked "));
    final String [] aCounts = sResult.substring ("checked ".length ()).split (" ");
    assertTrue (sResult, Integer.parseInt (aCounts[0]) > 40);
    assertTrue (sResult, Integer.parseInt (aCounts[1]) > 15);
  }

  @NonNull
  private static ICommonsList <String> _getLocations (@NonNull final PSSchema aSchema,
                                                       @NonNull final EPureXsltVersion eVersion,
                                                       final boolean bNativeLocation) throws Exception
  {
    final Processor aProcessor = SchematronProcessorFactory.getDefault ();
    PureXsltLocationFunctions.registerIfMissing (aProcessor);

    final Document aXslt = PureXsltStylesheetGenerator.generate (aSchema, null, eVersion, bNativeLocation);
    final XsltExecutable aExecutable = aProcessor.newXsltCompiler ().compile (new DOMSource (aXslt));
    final XdmNode aInput = aProcessor.newDocumentBuilder ().build (new StreamSource (new StringReader (XML)));
    final Document aSVRL = XMLFactory.newDocument ();
    aExecutable.load30 ().applyTemplates (aInput, new DOMDestination (aSVRL));

    final ICommonsList <String> ret = new CommonsArrayList <> ();
    final NodeList aReports = aSVRL.getElementsByTagNameNS (CSVRL.SVRL_NAMESPACE_URI, "successful-report");
    for (int i = 0; i < aReports.getLength (); ++i)
      ret.add (((Element) aReports.item (i)).getAttribute ("location"));
    return ret;
  }

  @Test
  public void testNativeLocationEqualsPortable () throws Exception
  {
    final PSSchema aSchema = new PSReader (new ReadableResourceString (SCH, StandardCharsets.UTF_8)).readSchema ();
    for (final EPureXsltVersion eVersion : EPureXsltVersion.values ())
    {
      final ICommonsList <String> aPortable = _getLocations (aSchema, eVersion, false);
      final ICommonsList <String> aNative = _getLocations (aSchema, eVersion, true);
      // 14 elements and 4 attributes
      assertEquals (eVersion.getID (), 18, aPortable.size ());
      assertEquals (eVersion.getID (), aPortable, aNative);
    }
  }
}
