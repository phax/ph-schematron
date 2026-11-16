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
package com.helger.schematron.saxon;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;

import com.helger.schematron.api.xslt.CSchematronLocationFunctions;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.Xslt30Transformer;
import net.sf.saxon.s9api.XsltExecutable;

/**
 * Test class for class {@link SaxonLocationFunctions}.
 *
 * @author Philip Helger
 */
public final class SaxonLocationFunctionsTest
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
                                           CSchematronLocationFunctions.NAMESPACE_URI +
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

  /**
   * An XSLT 2.0 stylesheet that uses the function only if it is available, like the ISO Schematron
   * skeleton does.
   */
  private static final String USE_WHEN_XSLT = "<xsl:stylesheet version='2.0'" +
                                              " xmlns:xsl='http://www.w3.org/1999/XSL/Transform'" +
                                              " xmlns:phsch='" +
                                              CSchematronLocationFunctions.NAMESPACE_URI +
                                              "'>" +
                                              "<xsl:output method='text'/>" +
                                              "<xsl:template match='/'>" +
                                              "<xsl:value-of use-when=\"function-available('phsch:index-by-ns-name', 1)\"" +
                                              " select='phsch:index-by-ns-name(/root/*[8]), phsch:index-by-ns-name(/root/*[4])'/>" +
                                              "<xsl:value-of use-when=\"not(function-available('phsch:index-by-ns-name', 1))\"" +
                                              " select=\"'missing'\"/>" +
                                              "</xsl:template>" +
                                              "</xsl:stylesheet>";

  @Test
  public void testSameResultsAsXPath () throws Exception
  {
    // The shared default processor disallows calls to external functions
    final Processor aProcessor = SchematronProcessorFactory.getDefault ();
    SaxonLocationFunctions.registerIfMissing (aProcessor);
    // Registering again does nothing
    SaxonLocationFunctions.registerIfMissing (aProcessor);

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

  @Test
  public void testRegisteredOnTransformerFactory () throws Exception
  {
    // Secure processing is on, which disallows calls to external functions
    for (final TransformerFactory aTF : new TransformerFactory [] { SchematronTransformerFactory.getDefault (),
                                                                    SchematronTransformerFactory.createTransformerFactory (true) })
    {
      final StringWriter aSW = new StringWriter ();
      aTF.newTransformer (new StreamSource (new StringReader (USE_WHEN_XSLT)))
         .transform (new StreamSource (new StringReader (XML)), new StreamResult (aSW));
      // The third item without namespace and the third item in namespace urn:a
      assertEquals ("3 3", aSW.toString ());
    }
  }
}
