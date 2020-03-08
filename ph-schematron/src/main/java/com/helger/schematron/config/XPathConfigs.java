package com.helger.schematron.config;

import com.helger.xml.xpath.XPathHelper;

import javax.xml.xpath.XPathFactory;

public class XPathConfigs {

    static final XPathFactory SAXON_FIRST = XPathHelper.createXPathFactorySaxonFirst ();

    public static final XPathConfig DEFAULT = new XPathConfigImpl(SAXON_FIRST, null, null);
}
