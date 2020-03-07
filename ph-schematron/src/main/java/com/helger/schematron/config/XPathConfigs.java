package com.helger.schematron.config;

import com.helger.schematron.pure.bound.xpath.PSXPathBoundSchema;
import com.helger.xml.xpath.XPathHelper;

import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

public class XPathConfigs {

    static final XPathFactory SAXON_FIRST = XPathHelper.createXPathFactorySaxonFirst ();

    public static final XPathConfig DEFAULT = new XPathConfigImpl(SAXON_FIRST, null, null);
}
