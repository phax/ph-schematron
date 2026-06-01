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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;

import org.junit.Test;

import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.schematron.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.pure.xpath.XQueryAsXPathFunctionConverter;

import net.sf.saxon.s9api.ExtensionFunction;

public final class Issue20150128Test
{
  @Test
  public void testEq () throws Exception
  {
    final String sTest2 = "<?xml version='1.0' encoding='iso-8859-1'?>\n" +
                          "<schema xmlns='http://purl.oclc.org/dsdl/schematron'>\n" +
                          "  <ns prefix='functx' uri='http://www.functx.com' />\n" +
                          "  <pattern >\n" +
                          "    <title>A very simple pattern with a title</title>\n" +
                          "    <rule context='chapter'>\n" +
                          "      <assert test='aaa eq 1'>aaa equals 1></assert>\n" +
                          "      </rule>\n" +
                          "  </pattern>\n" +
                          "\n" +
                          "</schema>";

    final CollectingPSErrorHandler aErrorHandler = new CollectingPSErrorHandler ();

    final ICommonsList <ExtensionFunction> aExtFunctions = new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream ("external/xquery/functx-1.0-nodoc-2007-01.xq"));
    assertNotNull (aExtFunctions);
    assertFalse (aExtFunctions.isEmpty ());

    final SchematronResourcePureXPath aResource = SchematronResourcePureXPath.fromString (sTest2,
                                                                                          StandardCharsets.ISO_8859_1);

    aResource.setErrorHandler (aErrorHandler);
    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().addAllExtensionFunctions (aExtFunctions).build ();
    aResource.setXPathConfig (aXPathConfig);
    assertTrue (aResource.isValidSchematron ());
    // Under XPath 2.0/3.0, the 'eq' operator in 'aaa eq 1' is a valid expression so it compiles
    // without errors. Previously under XPath 1.0 it triggered a syntax error.
    assertEquals (0, aErrorHandler.getErrorList ().size ());
  }
}
