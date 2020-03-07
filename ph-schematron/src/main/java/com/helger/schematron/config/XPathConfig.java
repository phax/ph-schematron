package com.helger.schematron.config;

import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

public interface XPathConfig {

    XPathFactory getXPathFactory();

    XPathVariableResolver getXPathVariableResolver();

    XPathFunctionResolver getXPathFunctionResolver();
}
