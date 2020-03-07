package com.helger.schematron.config;

import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathFunctionResolver;
import javax.xml.xpath.XPathVariableResolver;

/**
 * XPath configuration to use.
 * <p>
 * This is a counter-measure against <a href="https://github.com/phax/ph-schematron/issues/96">#96</a>:
 * When using saxon-HE, you have stripped down XPath support (no XPath higher order functions according to the
 * <a href="https://www.saxonica.com/html/products/feature-matrix-9-9.html">saxon feature matrix</a>).
 * In this case, you perhaps want to use a different <emph>XPath implementation</emph> (most commonly the XPath
 * implementation shipped with Java).
 * </p>
 *
 * @see com.helger.schematron.pure.SchematronResourcePure
 * @see com.helger.schematron.pure.bound.xpath.PSXPathBoundSchema
 * @see com.helger.schematron.pure.bound.PSBoundSchemaCacheKey
 */
public interface XPathConfig {

    XPathFactory getXPathFactory();

    XPathVariableResolver getXPathVariableResolver();

    XPathFunctionResolver getXPathFunctionResolver();
}
