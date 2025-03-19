/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import java.io.File;
import java.util.List;
import java.util.stream.Collectors;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.collection.impl.CommonsArrayList;

import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XPathCompiler;
import net.sf.saxon.s9api.XPathExecutable;
import net.sf.saxon.s9api.XPathSelector;
import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;

/**
 * Test for GitHub issue 185
 *
 * @author Philip Helger
 */
public final class Issue185NodeSetIssueTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (Issue185NodeSetIssueTest.class);

  @Test
  public void testPlainEval () throws Exception
  {
    // Requires Saxon XPath
    final XPathFactory xpf = XPathFactory.newInstance (XPathFactory.DEFAULT_OBJECT_MODEL_URI,
                                                       "net.sf.saxon.xpath.XPathFactoryImpl",
                                                       Thread.currentThread ().getContextClassLoader ());
    final XPath aXPath = xpf.newXPath ();
    final String expression = "('AA','BB','BT','RO-CT','RO-BC')";

    // Example to use it within an expression
    final Object o = aXPath.evaluate (expression, XPathConstants.NODESET);
    LOGGER.info ("Result: " + o + " - " + o.getClass ());
  }

  @Test
  public void testS9API () throws SaxonApiException
  {
    // Initialize Saxon's Processor
    // 'false' indicates non-standalone mode
    final Processor aS9Processor = new Processor (false);

    // Create an XPathCompiler
    final XPathCompiler aXPathCompiler = aS9Processor.newXPathCompiler ();

    // Create the XPath expression
    final String sExpression = "('AA', 'BB', 'BT', 'RO-CT', 'RO-BC')";
    final XPathExecutable aXPathExecutable = aXPathCompiler.compile (sExpression);

    // Evaluate the XPath expression
    final XPathSelector aSelector = aXPathExecutable.load ();

    if (false)
    {
      // Load XML file
      // Change path to your XML file
      final File xmlFile = new File ("yourfile.xml");
      final DocumentBuilder aS9Builder = aS9Processor.newDocumentBuilder ();
      final XdmNode document = aS9Builder.build (xmlFile);
      aSelector.setContextItem (document); // Set context to the XML document
    }

    // Get the result as a sequence
    final XdmValue result = aSelector.evaluate ();

    // Optionally: Convert the result into a List<String>
    final List <String> aEvaledList = result.stream ().map (XdmItem::getStringValue).collect (Collectors.toList ());
    assertEquals (new CommonsArrayList <> ("AA", "BB", "BT", "RO-CT", "RO-BC"), aEvaledList);
  }
}
