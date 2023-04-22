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
package com.helger.schematron.pure.supplementary;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;

import org.junit.Test;

import com.helger.commons.io.resource.ClassPathResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.pure.errorhandler.CollectingPSErrorHandler;
import com.helger.schematron.pure.xpath.IXPathConfig;
import com.helger.schematron.pure.xpath.XPathConfigBuilder;
import com.helger.schematron.pure.xpath.XQueryAsXPathFunctionConverter;
import com.helger.xml.xpath.MapBasedXPathFunctionResolver;

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

    final MapBasedXPathFunctionResolver aFunctionResolver = new XQueryAsXPathFunctionConverter ().loadXQuery (ClassPathResource.getInputStream ("external/xquery/functx-1.0-nodoc-2007-01.xq"));

    final SchematronResourcePure resource = SchematronResourcePure.fromString (sTest2, StandardCharsets.ISO_8859_1);

    resource.setErrorHandler (aErrorHandler);
    final IXPathConfig aXPathConfig = new XPathConfigBuilder ().setXPathFunctionResolver (aFunctionResolver).build ();
    resource.setXPathConfig (aXPathConfig);
    assertTrue (resource.isValidSchematron ());
    assertEquals (1, aErrorHandler.getErrorList ().size ());
  }
}
