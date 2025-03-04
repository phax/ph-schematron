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

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
}
