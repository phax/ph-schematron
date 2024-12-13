/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.commons.lang.ClassLoaderHelper;
import com.helger.xml.XMLFactory;
import com.helger.xml.serialize.write.XMLWriter;

public class MainClassCastExceptionError
{
  public static void main (final String [] args) throws Exception
  {
    final Document aDoc = XMLFactory.newDocument ();
    final Node eRoot = aDoc.appendChild (aDoc.createElement ("root"));
    eRoot.appendChild (aDoc.createElement ("para")).appendChild (aDoc.createTextNode ("100"));
    eRoot.appendChild (aDoc.createElement ("para")).appendChild (aDoc.createTextNode ("200"));
    System.out.println (XMLWriter.getNodeAsString (aDoc));

    final XPathExpression aExpr = XPathFactory.newInstance (XPathFactory.DEFAULT_OBJECT_MODEL_URI,
                                                            "net.sf.saxon.xpath.XPathFactoryImpl",
                                                            ClassLoaderHelper.getSystemClassLoader ())
                                              .newXPath ()
                                              .compile ("distinct-values(//para)");
    final Object aResult = aExpr.evaluate (aDoc, XPathConstants.NODESET);
    System.out.println (aResult);
  }
}
