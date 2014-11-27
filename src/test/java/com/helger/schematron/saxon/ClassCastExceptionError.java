package com.helger.schematron.saxon;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.helger.commons.xml.serialize.XMLWriter;

public class ClassCastExceptionError
{
  public static void main (final String [] args) throws Exception
  {
    final Document aDoc = DocumentBuilderFactory.newInstance ()
                                                .newDocumentBuilder ()
                                                .getDOMImplementation ()
                                                .createDocument (null, null, null);
    final Node eRoot = aDoc.appendChild (aDoc.createElement ("root"));
    eRoot.appendChild (aDoc.createElement ("para")).appendChild (aDoc.createTextNode ("100"));
    eRoot.appendChild (aDoc.createElement ("para")).appendChild (aDoc.createTextNode ("200"));
    System.out.println (XMLWriter.getXMLString (aDoc));

    final XPathExpression aExpr = XPathFactory.newInstance (XPathFactory.DEFAULT_OBJECT_MODEL_URI,
                                                            "net.sf.saxon.xpath.XPathFactoryImpl",
                                                            ClassLoader.getSystemClassLoader ())
                                              .newXPath ()
                                              .compile ("distinct-values(//para)");
    final Object aResult = aExpr.evaluate (aDoc, XPathConstants.NODESET);
    System.out.println (aResult);
  }
}
