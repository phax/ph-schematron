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
package com.helger.schematron.phoxtrot;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.schematron.api.xslt.CSchematronLocationFunctions;

/**
 * Test class for class {@link PhoxtrotLocationFunctions}.
 *
 * @author Philip Helger
 */
public final class PhoxtrotLocationFunctionsTest
{
  /**
   * Same named siblings in no namespace, in the default namespace and with two prefixes for the same
   * namespace.
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

  private static final String STYLESHEET_START = "<xsl:stylesheet version='2.0'" +
                                                 " xmlns:xsl='http://www.w3.org/1999/XSL/Transform'" +
                                                 " xmlns:phsch='" +
                                                 CSchematronLocationFunctions.NAMESPACE_URI +
                                                 "'>" +
                                                 "<xsl:output method='text'/>";

  /**
   * Compares the function with the <code>count()</code> expression it replaces for all elements,
   * including the ones of a tree without a document node.
   */
  private static final String CHECK_XSLT = STYLESHEET_START +
                                           "<xsl:template match='/'>" +
                                           "<xsl:variable name='free' as='element()'>" +
                                           "<r xmlns:a='urn:a'><x/><a:x/>text<x/><!--c--><?pi d?><x q='1'/></r>" +
                                           "</xsl:variable>" +
                                           "<xsl:variable name='elements' select='(//*, $free/descendant-or-self::*)'/>" +
                                           "<xsl:for-each select='$elements'>" +
                                           "<xsl:if test='phsch:index-by-ns-name(.) ne 1 + count(preceding-sibling::*[local-name() = local-name(current()) and namespace-uri() = namespace-uri(current())])'>" +
                                           "<xsl:value-of select=\"concat('index-by-ns-name ', name(), ' ', count(preceding-sibling::*), '&#10;')\"/>" +
                                           "</xsl:if>" +
                                           "</xsl:for-each>" +
                                           "<xsl:value-of select=\"concat('checked ', count($elements))\"/>" +
                                           "</xsl:template>" +
                                           "</xsl:stylesheet>";

  /**
   * Uses the function only if it is available, like the ISO Schematron skeleton does.
   */
  private static final String USE_WHEN_XSLT = STYLESHEET_START +
                                              "<xsl:template match='/'>" +
                                              "<xsl:value-of use-when=\"function-available('phsch:index-by-ns-name', 1)\"" +
                                              " select='phsch:index-by-ns-name(/root/*[8]), phsch:index-by-ns-name(/root/*[4])'/>" +
                                              "<xsl:value-of use-when=\"not(function-available('phsch:index-by-ns-name', 1))\"" +
                                              " select=\"'missing'\"/>" +
                                              "</xsl:template>" +
                                              "</xsl:stylesheet>";

  @NonNull
  private static String _transform (@NonNull final TransformerFactory aTF, @NonNull final String sXslt) throws Exception
  {
    final StringWriter aSW = new StringWriter ();
    aTF.newTransformer (new StreamSource (new StringReader (sXslt)))
       .transform (new StreamSource (new StringReader (XML)), new StreamResult (aSW));
    return aSW.toString ();
  }

  @Test
  public void testSameResultsAsXPath () throws Exception
  {
    final String sResult = _transform (PhoxtrotTransformerFactories.getDefault (), CHECK_XSLT);
    // No mismatches, only the final line with the count
    assertTrue (sResult, sResult.startsWith ("checked "));
    assertTrue (sResult, Integer.parseInt (sResult.substring ("checked ".length ())) > 15);
  }

  @Test
  public void testAvailableViaUseWhen () throws Exception
  {
    // Registering again does nothing
    PhoxtrotLocationFunctions.registerIfMissing ();

    // phoxtrot S49: use-when does not see the registered function yet, so the fallback is taken. Once
    // fixed, this is "3 3" (the third item without namespace and the third item in namespace urn:a)
    assertEquals ("missing", _transform (PhoxtrotTransformerFactories.getDefault (), USE_WHEN_XSLT));
    assertEquals ("missing", _transform (PhoxtrotTransformerFactories.createTransformerFactory (), USE_WHEN_XSLT));
  }
}
